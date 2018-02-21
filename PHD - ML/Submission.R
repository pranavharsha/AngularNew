rm(list=ls(all=TRUE))
library("forecast")
library("stats")
library("DMwR")
library(TTR)
library(forecastHybrid)

#Reading and Pre PRocessing

data=read.csv("C:\\Users\\pranav\\Desktop\\PHD - ML\\Train.csv")
testdata=read.csv("C:\\Users\\pranav\\Desktop\\PHD - ML\\template.csv")

testWomen=testdata[testdata$ProductCategory=="WomenClothing",]
testWomen=testWomen[,-c(3,4)]

plot(data)

WomenClothingData=data[data$ProductCategory=="WomenClothing",]
WomenClothingData=WomenClothingData[,-c(3)]

MenClothingData=data[data$ProductCategory=="MenClothing",]
MenClothingData=MenClothingData[,-c(3)]

OtherClothingData=data[data$ProductCategory=="OtherClothing",]
OtherClothingData=OtherClothingData[,-c(3)]

ImputedWomenClothingData=centralImputation(WomenClothingData)
ImputedMenClothingData=centralImputation(MenClothingData)
ImputedOtherClothingData=centralImputation(OtherClothingData)

NewTsWomen=ts(ImputedWomenClothingData$Sales.In.ThousandDollars., frequency = 12, start = c(2009, 1), end =c(2015, 12))
plot(NewTsWomen, xlab="Year",ylab="Sales",main="Women Clothing Sales")
DecomWomen=decompose(NewTsWomen)
autoplot(DecomWomen,title="Women Clothing Series Decomposition")
plot(DecomWomen,xlab="Year",ylab="Sales",title="Women Clothing Series Decomposition")

NewTsMen=ts(ImputedMenClothingData$Sales.In.ThousandDollars., frequency = 12, start = c(2009, 1), end =c(2015, 12))
plot(NewTsMen, xlab="Year",ylab="Sales",main="Men Clothing Sales")
DecomMen=decompose(NewTsMen)
autoplot(DecomMen,title ="Men Clothing Series Decomposition")
plot(DecomMen)

NewTsOther=ts(ImputedOtherClothingData$Sales.In.ThousandDollars., frequency = 12, start = c(2009, 1), end =c(2015, 12))
plot(NewTsOther, xlab="Year",ylab="Sales",main="Other Clothing Sales")
DecomOther=decompose(NewTsOther)
autoplot(DecomOther,title="Other Clothing Series Decomposition")
plot(DecomOther)
#SMA

SMAWomen=SMA(NewTsWomen, n=2)
SMAWomen

SMAMen=SMA(NewTsMen, n=2)
SMAMen

SMAOther=SMA(NewTsOther, n=2)
SMAMen

MAPEWomen <- mean(abs(NewTsWomen[2:length(NewTsWomen)]-SMAWomen[2:length(NewTsWomen)])/abs(NewTsWomen[2:length(NewTsWomen)]))*100
MAPEWomen
MAPEMen <- mean(abs(NewTsMen[2:length(NewTsMen)]-SMAMen[2:length(NewTsMen)])/abs(NewTsMen[2:length(NewTsMen)]))*100
MAPEMen
MAPEOther <- mean(abs(NewTsOther[2:length(NewTsOther)]-SMAOther[2:length(NewTsOther)])/abs(NewTsOther[2:length(NewTsOther)]))*100
MAPEOther

#Arima Models

ArimaWomen=auto.arima(NewTsWomen, approximation=FALSE,trace=FALSE)
summary(ArimaWomen)

ArimaMen=auto.arima(NewTsMen, approximation=FALSE,trace=FALSE)
summary(ArimaMen)

ArimaOther=auto.arima(NewTsOther, approximation=FALSE,trace=FALSE)
summary(ArimaOther)

WomenForecasts=forecast(ArimaWomen,h=12)
WomenForecasts=data.frame(WomenForecasts)

MenForecasts=forecast(ArimaMen,h=12)
MenForecasts=data.frame(MenForecasts)

OtherForecasts=forecast(ArimaOther,h=12)
OtherForecasts=data.frame(OtherForecasts)

#Holt Winter Models

HWWomen=HoltWinters(NewTsWomen)
HWMen=HoltWinters(NewTsMen)
HWOther=HoltWinters(NewTsOther)

MAPEWomen1 <- mean(abs(NewTsWomen[2:length(NewTsWomen)]-HWWomen[2:length(NewTsWomen)])/abs(NewTsWomen[2:length(NewTsWomen)]))*100
MAPEWomen1
MAPEMen1 <- mean(abs(NewTsMen[2:length(NewTsMen)]-HWMen[2:length(NewTsMen)])/abs(NewTsMen[2:length(NewTsMen)]))*100
MAPEMen1
MAPEOther1 <- mean(abs(NewTsOther[2:length(NewTsOther)]-HWOther[2:length(NewTsOther)])/abs(NewTsOther[2:length(NewTsOther)]))*100
MAPEOther1

WomenForecastsHW=forecast(HWWomen,h=12)
WomenForecastsHW=data.frame(WomenForecastsHW)

MenForecastsHW=forecast(HWMen,h=12)
MenForecastsHW=data.frame(MenForecastsHW)

OtherForecastsHW=forecast(ArimaOther,h=12)
OtherForecastsHW=data.frame(OtherForecastsHW)

#Getting Arima values of auto arima

ArWOrder=arimaorder(ArimaWomen)
ArWOrder
ArMOrder=arimaorder(ArimaMen)
ArMOrder
ArOOrder=arimaorder(ArimaOther)
ArOOrder

#Tuning Arima model on p,q,d and P,Q,D values

p=c(0,1,2,3)
d=c(0,1,2,3)
q=c(0,1,2,3)
P=c(0,1,2,3)
D=c(0,1,2,3)
Q=c(0,1,2,3)

for(a in p){
  for(b in d){
    for(c in q){
      for(e in P){
        for(f in D){
          for(g in Q){
             arimaWomensTuneModel=arima(NewTsWomen,order = c(a,b,c),seasonal = list(order = c(e,f,g), period = 12))
             #print(a,b,c)
             #print(e,f,g)
             cat(sprintf("\"%f\" \"%f\ \"%f\"\n", a, b ,c))
             cat(sprintf("\"%f\" \"%f\ \"%f\"\n", e, f ,g))
             summary(arimaWomensTuneModel)
             
          }
        }
      }
    }
  }
}


for(a in p){
  for(b in d){
    for(c in q){
      for(e in P){
        for(f in D){
          for(g in Q){
            arimaMenTuneModel=arima(NewTsMen,order = c(a,b,c),seasonal = list(order = c(e,f,g), period = 12))
            #print(a,b,c)
            #print(e,f,g)
            cat(sprintf("\"%f\" \"%f\ \"%f\"\n", a, b ,c))
            cat(sprintf("\"%f\" \"%f\ \"%f\"\n", e, f ,g))
            summary(arimaMenTuneModel)
            
          }
        }
      }
    }
  }
}

for(a in p){
  for(b in d){
    for(c in q){
      for(e in P){
        for(f in D){
          for(g in Q){
            arimaOtherTuneModel=arima(NewTsOther,order = c(a,b,c),seasonal = list(order = c(e,f,g), period = 12))
            #print(a,b,c)
            #print(e,f,g)
            cat(sprintf("\"%f\" \"%f\ \"%f\"\n", a, b ,c))
            cat(sprintf("\"%f\" \"%f\ \"%f\"\n", e, f ,g))
            summary(arimaOtherTuneModel)
            
          }
        }
      }
    }
  }
}

#Final Model and Predictions

ArimaWomenNew=arima(NewTsWomen,order = c(0,1,1),seasonal = list(order = c(2,2,2), period = 12))
summary(ArimaWomenNew)
NewWF2=forecast(ArimaWomenNew,h=12)
plot(forecast(ArimaWomenNew,h=12),main="Women Sales Forecasting",xlab = "Time",ylab = "Sales")
NewWF1=data.frame(NewWF1)

ArimaMenNew=arima(NewTsMen,order = c(0,1,1),seasonal = list(order = c(0,1,1), period = 12))
summary(ArimaMenNew)
plot(forecast(ArimaMenNew,h=12),main="Men Sales Forecasting",xlab = "Time",ylab = "Sales")
NewMF2=forecast(ArimaMenNew,h=12)
NewMF1=data.frame(NewMF1)

ArimaOthernNew=arima(NewTsOther,order = c(0,0,0),seasonal = list(order = c(1,2,2), period = 12))
summary(ArimaOthernNew)
plot(forecast(ArimaOthernNew,h=12),main="Other Sales Forecasting",xlab = "Time",ylab = "Sales")
NewOF2=forecast(ArimaOthernNew,h=12)
NewOF1=data.frame(NewOF1)


