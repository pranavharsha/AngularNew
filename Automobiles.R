library(DMwR)
library(car)
library(corrplot)
library(caret)
library(dummies)

AutoMaster=read.csv("C:\\Users\\KATTAP02\\Downloads\\Zillow\\Automobiles.csv",header=T,sep="\t")
str(AutoMaster)
dim(AutoMaster)

AutoData=centralImputation(AutoMaster)
sum(is.na(AutoData))

str(AutoData)

DummifiedData=dummy.data.frame(AutoData,names=c("aspiration","drive_wheel","num_cyl","fuel_system"))

str(DummifiedData)

set.seed(7)
trainrows=sample(1:nrow(DummifiedData),size=0.7*nrow(DummifiedData))
pcatrain=DummifiedData[trainrows,]
pcatest=DummifiedData[-trainrows,]
dim(pcatrain)
dim(pcatest)

PCApreProc=preProcess(pcatrain[,setdiff(names(DummifiedData),"price")],method = c("center", "scale"))

pcatrain=predict(PCApreProc,pcatrain)
pcatest=predict(PCApreProc,pcatest)

head(pcatrain)
head(pcatest)

pcamodel=prcomp(pcatrain[,setdiff(names(pcatrain),"price")])
plot(pcamodel)
biplot(pcamodel,scale = 0)

summary(pcamodel)
screeplot(pcamodel,npcs=length(pcamodel$sdev),type="lines")

trainpcafinal=as.data.frame(predict(pcamodel,pcatrain[,setdiff(names(pcatrain),"price")]))
trainpcafinal=trainpcafinal[,1:18]
dim(trainpcafinal)
head(trainpcafinal)
trainpcafinal=data.frame(trainpcafinal,pcatrain$price)
colnames(trainpcafinal)[19]="price"
str(trainpcafinal)

testpcafinal=as.data.frame(predict(pcamodel,pcatest[,setdiff(names(pcatest),"price")]))
testpcafinal=testpcafinal[,1:18]
dim(testpcafinal)
head(testpcafinal)
testpcafinal=data.frame(testpcafinal,pcatest$price)
colnames(testpcafinal)[19]="price"

pcaregmodel=lm(formula=price~.,data=trainpcafinal)
summary(pcaregmodel)
plot(pcaregmodel)

steppcamodel=stepAIC(pcaregmodel,direction="both")
summary(steppcamodel)





















