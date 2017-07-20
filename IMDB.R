library(DMwR)
library(car)
library(corrplot)
library(caret)
library(dummies)
library(MASS)
library(ROCR)

load("C:\\Users\\KATTAP02\\Downloads\\Zillow\\imdb_rotten_tom.Rdata")

str(movies)

winsset=movies[,c("best_pic_win","best_actor_win","best_actress_win")]

str(winsset)

head(winsset)

picwin=winsset$best_pic_win
actorwin=winsset$best_actor_win
actresswin=winsset$best_actress_win

length(picwin)
length(actorwin)
length(actresswin)

targetvec=c()
length(targetvec)

for(i in 1:651)
{

if(picwin[i]=="yes" & actorwin[i]=="yes" &actresswin[i]=="yes")
{
 targetvec[i]="pic-actor-actress"
}
else if(picwin[i]=="yes" & actorwin[i]=="yes" &actresswin[i]=="no")
{
 targetvec[i]="pic-actor"
}
else if(picwin[i]=="yes" & actorwin[i]=="no" &actresswin[i]=="yes")
{
 targetvec[i]="pic-actress"
}
else if(picwin[i]=="yes" & actorwin[i]=="no" &actresswin[i]=="no")
{
 targetvec[i]="pic"
}
else if(picwin[i]=="no" & actorwin[i]=="yes" &actresswin[i]=="yes")
{
 targetvec[i]="actor-actress"
}
else if(picwin[i]=="no" & actorwin[i]=="yes" &actresswin[i]=="no")
{
 targetvec[i]="actor"
}
else if(picwin[i]=="no" & actorwin[i]=="no" &actresswin[i]=="yes")
{
 targetvec[i]="actress"
}
else if(picwin[i]=="no" & actorwin[i]=="no" &actresswin[i]=="no")
{
 targetvec[i]="none"
}
else
{
 targetvec[i]="none"
}

}


winsset$targetfield=targetvec

str(winsset)

winsset$targetfield=as.factor(winsset$targetfield)

levels(winsset$targetfield)



RqdFieldsDataSet=movies[,c(2,3,4,5,7,8,9,13,14,15,16,17,18,21,22,23,24,20)]
str(RqdFieldsDataSet)

sum(is.na(RqdFieldsDataSet))

summary(RqdFieldsDataSet)

test=as.data.frame(RqdFieldsDataSet[which(is.na(RqdFieldsDataSet$runtime)),])


RqdFieldsDataSet=na.omit(RqdFieldsDataSet)


set.seed(7)

trainrows=createDataPartition(RqdFieldsDataSet$best_pic_win,p=0.7,list=F)

traindata=RqdFieldsDataSet[trainrows,]
testdata=RqdFieldsDataSet[-trainrows,]
preproc=preProcess(traindata)
traindata=predict(preproc,traindata)
testdata=predict(preproc,testdata)

dim(traindata)
dim(testdata)


logreg1=glm(best_pic_win~.,family="binomial",data=traindata)
summary(logreg1)
plot(logreg1)

probs1=predict(logreg1,type="response")
preds1=prediction(probs1,traindata$best_pic_win)

performace1=performance(preds1,measure="tpr",x.measure="fpr")

plot(performace1, col=rainbow(10), colorize=T, print.cutoffs.at=seq(0,1,0.05))

probstest1=predict(logreg1,testdata,type="response")
predstest1=ifelse(probstest1 > 0.1, "yes", "no")












