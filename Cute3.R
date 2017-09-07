rm(list=ls())

library(caret)
library(DMwR)
library(glmnet)
library(foreign)
library(dplyr)
library(ggplot2)
library(pROC)
require(e1071)
library(C50)
library(rpart)
library(MLmetrics)
library(kernlab)
library(randomForest)
library(mlr)
library(rpart)
library(data.table)
library(h2o)
library(factoextra)
library(ROCR)

MasterData=read.csv("C:\\Users\\KATTAP02\\Desktop\\Data.csv")
Data=MasterData
Data$ID=NULL
str(Data)

Data$TARGET=as.factor(Data$TARGET)
sum(is.na(Data))

set.seed(7)

trainrows=createDataPartition(Data$TARGET,p=0.7,list = F)
traindata=Data[trainrows,]
testdata=Data[-trainrows,]

valrows=createDataPartition(traindata$TARGET,p=0.7,list=F)
traindata=traindata[valrows,]
valdata=traindata[-valrows,]

preprocstep=preProcess(traindata,method = c("center","scale"))
PreProctraindata=predict(preprocstep,traindata)
PreProcvaldata=predict(preprocstep,valdata)
PreProctestdata=predict(preprocstep,testdata)

pcaout=prcomp(PreProctraindata[setdiff(names(PreProctraindata),"TARGET")])
summary(pcaout)

screeplot(pcaout,npcs=length(pcaout$sdev),type="lines",xlim=c(0,30))

fviz_screeplot(pcaout, ncp=30)

trainpcafinal=as.data.frame(predict(pcaout,PreProctraindata[,setdiff(names(PreProctraindata),"Target")]))
trainpcafinal=trainpcafinal[,1:20]
trainpcafinal=data.frame(trainpcafinal,PreProctraindata$TARGET)
colnames(trainpcafinal)[21]="TARGET"

Valpcafinal=as.data.frame(predict(pcaout,PreProcvaldata[,setdiff(names(PreProcvaldata),"Target")]))
Valpcafinal=Valpcafinal[,1:20]
Valpcafinal=data.frame(Valpcafinal,PreProcvaldata$TARGET)
colnames(Valpcafinal)[21]="TARGET"

testpcafinal=as.data.frame(predict(pcaout,PreProctestdata[,setdiff(names(PreProctestdata),"Target")]))
testpcafinal=testpcafinal[,1:20]
testpcafinal=data.frame(testpcafinal,PreProctestdata$TARGET)
colnames(testpcafinal)[21]="TARGET"

SmotedPcaTrain=SMOTE(TARGET~.,trainpcafinal,perc.over = 100, perc.under=200)
prop.table(table(SmotedPcaTrain$TARGET))

k=c(1:30)
knnAuc1=c()
knnAuc2=c()
for(i in k)
{
knnmodel1=knn3(TARGET ~ . , trainpcafinal, k = i)
preds_k <- predict(knnmodel1, Valpcafinal)
predsknn <- ifelse(preds_k[, 1] > preds_k[, 2], 0, 1)
roc_obj <- roc(Valpcafinal$TARGET, predsknn)
knnAuc1[i]=auc(roc_obj)
}
knnAuc1

for(i in k)
{
knnmodel1=knn3(TARGET ~ . , SmotedPcaTrain, k = i)
preds_k <- predict(knnmodel1, Valpcafinal)
predsknn <- ifelse(preds_k[, 1] > preds_k[, 2], 0, 1)
roc_obj <- roc(Valpcafinal$TARGET, predsknn)
knnAuc2[i]=auc(roc_obj)
}
knnAuc2

k=k[c(3:30)]
knnAuc1=knnAuc1[c(3:30)]
knnAuc2=knnAuc2[c(3:30)]

qplot(k,knnAuc1,geom = "line")

knndf=data.frame(k=k,NonSmoted=knnAuc1,Smoted=knnAuc2)

ggplot(data=knndf,aes(x=k,y=NonSmoted))+geom_bar(stat="identity", fill="steelblue")+ylab("Non Smoted AUC")+xlab("Value of K")

ggplot(data=knndf,aes(x=k,y=Smoted))+geom_bar(stat="identity", fill="steelblue")+ylab("Smoted AUC")+xlab("Value of K")


svmModel1=ksvm(TARGET~.,trainpcafinal,kernel="vanilladot",prob.model= TRUE)
predssvm1 <- predict(svmModel1, Valpcafinal)
predprobs1=predict(svmModel1, Valpcafinal,type = "prob")
svmfinalpreds1=ifelse(predprobs2[, 1] > predprobs2[, 2], 0, 1)
svmRocObj1<- roc(Valpcafinal$TARGET, svmfinalpreds1)
svmAuc1=auc(svmRocObj1)
svmAuc1
confusionMatrix(predssvm1, Valpcafinal$TARGET)

svmModel2=ksvm(TARGET~.,SmotedPcaTrain,kernel="vanilladot",prob.model= TRUE)
predssvm2 <- predict(svmModel2, Valpcafinal)
predprobs2=predict(svmModel2, Valpcafinal,type = "prob")
svmfinalpreds2=ifelse(predprobs2[, 1] > predprobs2[, 2], 0, 1)
svmRocObj2<- roc(Valpcafinal$TARGET, svmfinalpreds2)
svmAuc2=auc(svmRocObj2)
svmAuc2
confusionMatrix(predssvm2, Valpcafinal$TARGET)

svmModel3=ksvm(TARGET~.,trainpcafinal,kernel="tanhdot",prob.model= TRUE)
predssvm3 <- predict(svmModel3, Valpcafinal)
predprobs3=predict(svmModel3, Valpcafinal,type = "prob")
svmfinalpreds3=ifelse(predprobs3[, 1] > predprobs3[, 2], 0, 1)
svmRocObj3<- roc(Valpcafinal$TARGET, svmfinalpreds3)
svmAuc3=auc(svmRocObj3)
svmAuc3
confusionMatrix(predssvm3, Valpcafinal$TARGET)

svmModel4=ksvm(TARGET~.,SmotedPcaTrain,kernel="tanhdot",prob.model= TRUE)
predssvm4 <- predict(svmModel4, Valpcafinal)
predprobs4=predict(svmModel4, Valpcafinal,type = "prob")
svmfinalpreds4=ifelse(predprobs4[, 1] > predprobs4[, 2], 0, 1)
svmRocObj4<- roc(Valpcafinal$TARGET, svmfinalpreds4)
svmAuc4=auc(svmRocObj4)
svmAuc4
confusionMatrix(predssvm4, Valpcafinal$TARGET)


svmModel5=ksvm(TARGET~.,trainpcafinal,kernel="rbfdot",prob.model= TRUE)
predssvm5 <- predict(svmModel5, Valpcafinal)
predprobs5=predict(svmModel5, Valpcafinal,type = "prob")
svmfinalpreds5=ifelse(predprobs5[, 1] > predprobs5[, 2], 0, 1)
svmRocObj5<- roc(Valpcafinal$TARGET, svmfinalpreds5)
svmAuc5=auc(svmRocObj5)
svmAuc5
confusionMatrix(predssvm5, Valpcafinal$TARGET)

svmModel6=ksvm(TARGET~.,SmotedPcaTrain,kernel="rbfdot",prob.model= TRUE)
predssvm6 <- predict(svmModel6, Valpcafinal)
predprobs6=predict(svmModel6, Valpcafinal,type = "prob")
svmfinalpreds6=ifelse(predprobs6[, 1] > predprobs6[, 2], 0, 1)
svmRocObj6<- roc(Valpcafinal$TARGET, svmfinalpreds6)
svmAuc6=auc(svmRocObj6)
svmAuc6
confusionMatrix(predssvm6, Valpcafinal$TARGET)

svmModel7=ksvm(TARGET~.,trainpcafinal,kernel="polydot",prob.model= TRUE)
predssvm7 <- predict(svmModel7, Valpcafinal)
predprobs7=predict(svmModel7, Valpcafinal,type = "prob")
svmfinalpreds7=ifelse(predprobs7[, 1] > predprobs7[, 2], 0, 1)
svmRocObj7<- roc(Valpcafinal$TARGET, svmfinalpreds7)
svmAuc7=auc(svmRocObj7)
svmAuc7
confusionMatrix(predssvm7, Valpcafinal$TARGET)

svmModel8=ksvm(TARGET~.,SmotedPcaTrain,kernel="polydot",prob.model= TRUE)
predssvm8 <- predict(svmModel8, Valpcafinal)
predprobs8=predict(svmModel8, Valpcafinal,type = "prob")
svmfinalpreds8=ifelse(predprobs8[, 1] > predprobs8[, 2], 0, 1)
svmRocObj8<- roc(Valpcafinal$TARGET, svmfinalpreds8)
svmAuc8=auc(svmRocObj8)
svmAuc8
confusionMatrix(predssvm8, Valpcafinal$TARGET)

DtModel1=rpart(TARGET~.,trainpcafinal)
DT1Preds=predict(DtModel1,Valpcafinal[,setdiff(names(Valpcafinal),"Target")])
preds_tree1 <- ifelse(DT1Preds[, 1] > DT1Preds[, 2], 0, 1)
treerocobj1 <- roc(Valpcafinal$TARGET, preds_tree1)
DTauc1=auc(treerocobj1)

DtModel2=rpart(TARGET~.,SmotedPcaTrain)
DT2Preds=predict(DtModel2,Valpcafinal[,setdiff(names(Valpcafinal),"Target")])
preds_tree2 <- ifelse(DT2Preds[, 1] > DT2Preds[, 2], 0, 1)
treerocobj2 <- roc(Valpcafinal$TARGET, preds_tree2)
DTauc2=auc(treerocobj2)


RfModel1=randomForest(TARGET~ . , trainpcafinal)
predsrf1 <- predict(RfModel1, Valpcafinal)
probpredsRf1=predict(RfModel1, Valpcafinal,type = "prob")
Rfpredsfinal1=ifelse(probpredsRf1[, 1] > probpredsRf1[, 2], 0, 1)
RFRocObj1<- roc(Valpcafinal$TARGET, Rfpredsfinal1)
RFAuc1=auc(RFRocObj1)
RFAuc1
confusionMatrix(predsrf1, Valpcafinal$TARGET)

RfModel2=randomForest(TARGET~ . , SmotedPcaTrain)
predsrf2 <- predict(RfModel2, Valpcafinal)
probpredsRf2=predict(RfModel2, Valpcafinal,type = "prob")
Rfpredsfinal2=ifelse(probpredsRf2[, 1] > probpredsRf2[, 2], 0, 1)
RFRocObj2<- roc(Valpcafinal$TARGET, Rfpredsfinal2)
RFAuc2=auc(RFRocObj2)
RFAuc2
confusionMatrix(predsrf2, Valpcafinal$TARGET)








