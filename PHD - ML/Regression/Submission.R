rm(list=ls(all=TRUE))
library(XLConnect)
library(xlsx)
library(caret)
library(MASS)
library(car)
library(Metrics)
library(stringr)
library(plyr)
library("DMwR")
library(corrplot)
library(MASS)
library(car)
library(glmnet)
library(doParallel)
library(data.table)
library(caret)
library(rpart)
library(DAAG)
library(randomForest)
library(h2o)

data=read.csv("C:\\Users\\pranav\\Desktop\\PHD - ML\\Train.csv")
weatherdata=data.frame()

WomenClothingData=data[data$ProductCategory=="WomenClothing",]
WomenClothingData=WomenClothingData[,-c(3)]

economicdata=read.xlsx("C:/Users/pranav/Desktop/PHD - ML/MacroEconomicData.xlsx",sheetIndex = 1)

holidaysdata=read.xlsx("C:/Users/pranav/Desktop/PHD - ML/Events_HolidaysData.xlsx",sheetIndex = 1)

WD1=read.xlsx("C:/Users/pranav/Desktop/PHD - ML/WeatherData.xlsx",sheetIndex = 1)
WD2=read.xlsx("C:/Users/pranav/Desktop/PHD - ML/WeatherData.xlsx",sheetIndex = 2)
WD3=read.xlsx("C:/Users/pranav/Desktop/PHD - ML/WeatherData.xlsx",sheetIndex = 3)
WD4=read.xlsx("C:/Users/pranav/Desktop/PHD - ML/WeatherData.xlsx",sheetIndex = 4)
WD5=read.xlsx("C:/Users/pranav/Desktop/PHD - ML/WeatherData.xlsx",sheetIndex = 5)
WD6=read.xlsx("C:/Users/pranav/Desktop/PHD - ML/WeatherData.xlsx",sheetIndex = 6)
WD7=read.xlsx("C:/Users/pranav/Desktop/PHD - ML/WeatherData.xlsx",sheetIndex = 7)
WD8=read.xlsx("C:/Users/pranav/Desktop/PHD - ML/WeatherData.xlsx",sheetIndex = 8)

#Pre processing weather dataset

WD1[WD1=="-"]=NA
WD1$Precip.Â..mm..sum[WD1$Precip.Â..mm..sum=="T"]=0

WD2$Year[WD2$Year==2009]=2010
WD2[WD2=="-"]=NA
WD2$Precip.Â..mm..sum[WD2$Precip.Â..mm..sum=="T"]=0

WD3$Year[WD3$Year==2009]=2011
WD3[WD3=="-"]=NA
WD3$Precip.Â..mm..sum[WD3$Precip.Â..mm..sum=="T"]=0

WD4$Year[WD4$Year==2009]=2012
WD4[WD4=="-"]=NA
WD4$Precip.Â..mm..sum[WD4$Precip.Â..mm..sum=="T"]=0

WD5$Year[WD5$Year==2009]=2013
WD5[WD5=="-"]=NA
WD5$Precip.Â..mm..sum[WD5$Precip.Â..mm..sum=="T"]=0

WD6$Year[WD6$Year==2009]=2014
WD6[WD6=="-"]=NA
WD6$Precip.Â..mm..sum[WD6$Precip.Â..mm..sum=="T"]=0

WD7$Year[WD7$Year==2009]=2015
WD7[WD7=="-"]=NA
WD7$Precip.Â..mm..sum[WD7$Precip.Â..mm..sum=="T"]=0

WD8$Year[WD8$Year==2009]=2016
WD8[WD8=="-"]=NA
WD8$Precip.Â..mm..sum[WD8$Precip.Â..mm..sum=="T"]=0

sum(is.na(WD1New))
colSums(is.na(WD1New))

sum(is.na(WD4))
colSums(is.na(WD4))

WD1New=WD1[,-c(23)]
str(WD1New)
WD1New$WindÂ..km.h..low=as.numeric(WD1New$WindÂ..km.h..low)
WD1New$WindÂ..km.h..avg=as.numeric(WD1New$WindÂ..km.h..avg)
WD1New$WindÂ..km.h..high=as.numeric(WD1New$WindÂ..km.h..high)
WD1New$Precip.Â..mm..sum=as.numeric(WD1New$Precip.Â..mm..sum)
aggdata2009=aggregate(WD1New, by=list(WD1New$Month),FUN=mean, na.rm=TRUE)
aggdata2009$Month=aggdata2009$Group.1
aggdata2009$Group.1=NULL

WD2New=WD2[,-c(23)]
str(WD2New)
WD2New$WindÂ..km.h..low=as.numeric(WD2New$WindÂ..km.h..low)
WD2New$WindÂ..km.h..avg=as.numeric(WD2New$WindÂ..km.h..avg)
WD2New$WindÂ..km.h..high=as.numeric(WD2New$WindÂ..km.h..high)
WD2New$Precip.Â..mm..sum=as.numeric(WD2New$Precip.Â..mm..sum)
aggdata2010=aggregate(WD2New, by=list(WD2New$Month),FUN=mean, na.rm=TRUE)
aggdata2010$Month=aggdata2010$Group.1
aggdata2010$Group.1=NULL

WD3New=WD3[,-c(23)]
str(WD3New)
WD3New$WindÂ..km.h..low=as.numeric(WD3New$WindÂ..km.h..low)
WD3New$WindÂ..km.h..avg=as.numeric(WD3New$WindÂ..km.h..avg)
WD3New$WindÂ..km.h..high=as.numeric(WD3New$WindÂ..km.h..high)
WD3New$Precip.Â..mm..sum=as.numeric(WD3New$Precip.Â..mm..sum)
aggdata2011=aggregate(WD3New, by=list(WD3New$Month),FUN=mean, na.rm=TRUE)
aggdata2011$Month=aggdata2011$Group.1
aggdata2011$Group.1=NULL

WD4New=WD4[,-c(23)]
str(WD4New)
WD4New$Temp.high..Â.C.=as.numeric(WD4New$Temp.high..Â.C.)
WD4New$Temp.avg..Â.C.=as.numeric(WD4New$Temp.avg..Â.C.)
WD4New$Temp.low..Â.C.=as.numeric(WD4New$Temp.low..Â.C.)
WD4New$WindÂ..km.h..low=as.numeric(WD4New$WindÂ..km.h..low)
WD4New$WindÂ..km.h..avg=as.numeric(WD4New$WindÂ..km.h..avg)
WD4New$WindÂ..km.h..high=as.numeric(WD4New$WindÂ..km.h..high)
WD4New$Precip.Â..mm..sum=as.numeric(WD4New$Precip.Â..mm..sum)
WD4New$Dew.Point.high..Â.C.=as.numeric(WD4New$Dew.Point.high..Â.C.)
WD4New$Dew.Point.avg..Â.C.=as.numeric(WD4New$Dew.Point.avg..Â.C.)
WD4New$Dew.Point.low..Â.C.=as.numeric(WD4New$Dew.Point.low..Â.C.)
WD4New$HumidityÂ.....high=as.numeric(WD4New$HumidityÂ.....high)
WD4New$HumidityÂ.....avg=as.numeric(WD4New$HumidityÂ.....avg)
WD4New$HumidityÂ.....low=as.numeric(WD4New$HumidityÂ.....low)
WD4New$Sea.Level.Press.Â..hPa..high=as.numeric(WD4New$Sea.Level.Press.Â..hPa..high)
WD4New$Sea.Level.Press.Â..hPa..avg=as.numeric(WD4New$Sea.Level.Press.Â..hPa..avg)
WD4New$Sea.Level.Press.Â..hPa..low=as.numeric(WD4New$Sea.Level.Press.Â..hPa..low)
WD4New$VisibilityÂ..km..high=as.numeric(WD4New$VisibilityÂ..km..high)
WD4New$VisibilityÂ..km..avg=as.numeric(WD4New$VisibilityÂ..km..avg)
WD4New$VisibilityÂ..km..low=as.numeric(WD4New$VisibilityÂ..km..low)

aggdata2012=aggregate(WD4New, by=list(WD4New$Month),FUN=mean, na.rm=TRUE)
aggdata2012$Month=aggdata2012$Group.1
aggdata2012$Group.1=NULL


WD5New=WD5[,-c(23)]
str(WD5New)
WD5New$WindÂ..km.h..low=as.numeric(WD5New$WindÂ..km.h..low)
WD5New$WindÂ..km.h..avg=as.numeric(WD5New$WindÂ..km.h..avg)
WD5New$WindÂ..km.h..high=as.numeric(WD5New$WindÂ..km.h..high)
WD5New$Precip.Â..mm..sum=as.numeric(WD5New$Precip.Â..mm..sum)
aggdata2013=aggregate(WD5New, by=list(WD5New$Month),FUN=mean, na.rm=TRUE)
aggdata2013$Month=aggdata2013$Group.1
aggdata2013$Group.1=NULL


WD6New=WD6[,-c(23)]
str(WD6New)
WD6New$Temp.high..Â.C.=as.numeric(WD6New$Temp.high..Â.C.)
WD6New$Temp.avg..Â.C.=as.numeric(WD6New$Temp.avg..Â.C.)
WD6New$Temp.low..Â.C.=as.numeric(WD6New$Temp.low..Â.C.)
WD6New$WindÂ..km.h..low=as.numeric(WD6New$WindÂ..km.h..low)
WD6New$WindÂ..km.h..avg=as.numeric(WD6New$WindÂ..km.h..avg)
WD6New$WindÂ..km.h..high=as.numeric(WD6New$WindÂ..km.h..high)
WD6New$Precip.Â..mm..sum=as.numeric(WD6New$Precip.Â..mm..sum)
WD6New$Dew.Point.high..Â.C.=as.numeric(WD6New$Dew.Point.high..Â.C.)
WD6New$Dew.Point.avg..Â.C.=as.numeric(WD6New$Dew.Point.avg..Â.C.)
WD6New$Dew.Point.low..Â.C.=as.numeric(WD6New$Dew.Point.low..Â.C.)
WD6New$HumidityÂ.....high=as.numeric(WD6New$HumidityÂ.....high)
WD6New$HumidityÂ.....avg=as.numeric(WD6New$HumidityÂ.....avg)
WD6New$HumidityÂ.....low=as.numeric(WD6New$HumidityÂ.....low)
WD6New$Sea.Level.Press.Â..hPa..high=as.numeric(WD6New$Sea.Level.Press.Â..hPa..high)
WD6New$Sea.Level.Press.Â..hPa..avg=as.numeric(WD6New$Sea.Level.Press.Â..hPa..avg)
WD6New$Sea.Level.Press.Â..hPa..low=as.numeric(WD6New$Sea.Level.Press.Â..hPa..low)
WD6New$VisibilityÂ..km..high=as.numeric(WD6New$VisibilityÂ..km..high)
WD6New$VisibilityÂ..km..avg=as.numeric(WD6New$VisibilityÂ..km..avg)
WD6New$VisibilityÂ..km..low=as.numeric(WD6New$VisibilityÂ..km..low)
aggdata2014=aggregate(WD6New, by=list(WD6New$Month),FUN=mean, na.rm=TRUE)
aggdata2014$Month=aggdata2014$Group.1
aggdata2014$Group.1=NULL

WD7New=WD7[,-c(23)]
str(WD7New)
WD7New$Sea.Level.Press.Â..hPa..high=as.numeric(WD7New$Sea.Level.Press.Â..hPa..high)
WD7New$Sea.Level.Press.Â..hPa..avg=as.numeric(WD7New$Sea.Level.Press.Â..hPa..avg)
WD7New$Sea.Level.Press.Â..hPa..low=as.numeric(WD7New$Sea.Level.Press.Â..hPa..low)
WD7New$VisibilityÂ..km..high=as.numeric(WD7New$VisibilityÂ..km..high)
WD7New$VisibilityÂ..km..avg=as.numeric(WD7New$VisibilityÂ..km..avg)
WD7New$VisibilityÂ..km..low=as.numeric(WD7New$VisibilityÂ..km..low)
WD7New$WindÂ..km.h..low=as.numeric(WD7New$WindÂ..km.h..low)
WD7New$WindÂ..km.h..avg=as.numeric(WD7New$WindÂ..km.h..avg)
WD7New$WindÂ..km.h..high=as.numeric(WD7New$WindÂ..km.h..high)
WD7New$Precip.Â..mm..sum=as.numeric(WD7New$Precip.Â..mm..sum)
aggdata2015=aggregate(WD7New, by=list(WD7New$Month),FUN=mean, na.rm=TRUE)
aggdata2015$Month=aggdata2015$Group.1
aggdata2015$Group.1=NULL


WD8New=WD8[,-c(23)]
str(WD8New)
WD8New$Sea.Level.Press.Â..hPa..high=as.numeric(WD8New$Sea.Level.Press.Â..hPa..high)
WD8New$Sea.Level.Press.Â..hPa..avg=as.numeric(WD8New$Sea.Level.Press.Â..hPa..avg)
WD8New$Sea.Level.Press.Â..hPa..low=as.numeric(WD8New$Sea.Level.Press.Â..hPa..low)
WD8New$VisibilityÂ..km..high=as.numeric(WD8New$VisibilityÂ..km..high)
WD8New$VisibilityÂ..km..avg=as.numeric(WD8New$VisibilityÂ..km..avg)
WD8New$VisibilityÂ..km..low=as.numeric(WD8New$VisibilityÂ..km..low)
WD8New$WindÂ..km.h..low=as.numeric(WD8New$WindÂ..km.h..low)
WD8New$WindÂ..km.h..avg=as.numeric(WD8New$WindÂ..km.h..avg)
WD8New$WindÂ..km.h..high=as.numeric(WD8New$WindÂ..km.h..high)
WD8New$Precip.Â..mm..sum=as.numeric(WD8New$Precip.Â..mm..sum)
aggdata2016=aggregate(WD8New, by=list(WD8New$Month),FUN=mean, na.rm=TRUE)
aggdata2016$Month=aggdata2016$Group.1
aggdata2016$Group.1=NULL

CompleteWeatherData=rbind(aggdata2009,aggdata2010)
CompleteWeatherData=rbind(CompleteWeatherData,aggdata2011)
CompleteWeatherData=rbind(CompleteWeatherData,aggdata2012)
CompleteWeatherData=rbind(CompleteWeatherData,aggdata2013)
CompleteWeatherData=rbind(CompleteWeatherData,aggdata2014)
CompleteWeatherData=rbind(CompleteWeatherData,aggdata2015)

CompleteWeatherData$Day=NULL
TestWeatherData=aggdata2016[,-c(3)]

#Pre processing Economic dataset

ED1<-data.frame((str_split_fixed(economicdata$Year.Month, "-", 2)))
str(ED1)
ED1$X2<-as.character(ED1$X2)
ED1$X2[ED1$X2==" Jan"]<-"1"
ED1$X2[ED1$X2==" Feb"]<-"2"
ED1$X2[ED1$X2==" Mar"]<-"3"
ED1$X2[ED1$X2==" Apr"]<-"4"
ED1$X2[ED1$X2==" May"]<-"5"
ED1$X2[ED1$X2==" Jun"]<-"6"
ED1$X2[ED1$X2==" Jul"]<-"7"
ED1$X2[ED1$X2==" Aug"]<-"8"
ED1$X2[ED1$X2==" Sep"]<-"9"
ED1$X2[ED1$X2==" Oct"]<-"10"
ED1$X2[ED1$X2==" Nov"]<-"11"
ED1$X2[ED1$X2==" Dec"]<-"12"

ED1$X2<-as.numeric(ED1$X2)
ED1$X1<-as.numeric(as.character(ED1$X1))
colnames(ED1)<-c("Year","Month")

MacroEconomicData<-cbind(ED1,economicdata)
MacroEconomicData$Year.Month<-NULL

MacroEconomicData[MacroEconomicData=="?"]=NA

MacroEconomicData$Month[MacroEconomicData$Month== 1]<-"Jan"
MacroEconomicData$Month[MacroEconomicData$Month== 2]<-"Feb"
MacroEconomicData$Month[MacroEconomicData$Month== 3]<-"Mar"
MacroEconomicData$Month[MacroEconomicData$Month== 4]<-"Apr"
MacroEconomicData$Month[MacroEconomicData$Month== 5]<-"May"
MacroEconomicData$Month[MacroEconomicData$Month== 6]<-"Jun"
MacroEconomicData$Month[MacroEconomicData$Month== 7]<-"Jul"
MacroEconomicData$Month[MacroEconomicData$Month== 8]<-"Aug"
MacroEconomicData$Month[MacroEconomicData$Month== 9]<-"Sep"
MacroEconomicData$Month[MacroEconomicData$Month== 10]<-"Oct"
MacroEconomicData$Month[MacroEconomicData$Month== 11]<-"Nov"
MacroEconomicData$Month[MacroEconomicData$Month== 12]<-"Dec"

CompleteEconomicData=MacroEconomicData[c(1:84),]
TestEconomicData=MacroEconomicData[c(85:96),]

CompleteEconomicData=CompleteEconomicData[,-c(11)]
TestEconomicData=TestEconomicData[,-c(11)]

sum(is.na(CompleteEconomicData))
colSums(is.na(CompleteEconomicData))

#Pre processing Holidays Data

HD1=holidaysdata[,-c(3,4)]
str(HD1)
MonthDate=HD1$MonthDate
MonthDate=substring(MonthDate,6,7)
HD1$MonthDate=MonthDate
HD1$MonthDate=as.numeric(HD1$MonthDate)

HD1$MonthDate[HD1$MonthDate== 1]<-"Jan"
HD1$MonthDate[HD1$MonthDate== 2]<-"Feb"
HD1$MonthDate[HD1$MonthDate== 3]<-"Mar"
HD1$MonthDate[HD1$MonthDate== 4]<-"Apr"
HD1$MonthDate[HD1$MonthDate== 5]<-"May"
HD1$MonthDate[HD1$MonthDate== 6]<-"Jun"
HD1$MonthDate[HD1$MonthDate== 7]<-"Jul"
HD1$MonthDate[HD1$MonthDate== 8]<-"Aug"
HD1$MonthDate[HD1$MonthDate== 9]<-"Sep"
HD1$MonthDate[HD1$MonthDate== 10]<-"Oct"
HD1$MonthDate[HD1$MonthDate== 11]<-"Nov"
HD1$MonthDate[HD1$MonthDate== 12]<-"Dec"

aggHolData=count(HD1, c('Year','MonthDate'))
TestHolData=aggHolData[c(71:81),]
CompleteHolData=aggHolData[c(1:70),]

#Combining the preprocessed data to prepare a dataset.

str(CompleteEconomicData)
str(CompleteHolData)
str(CompleteWeatherData)
colnames(CompleteHolData)[2]="Month"
CompleteEconomicData$Month=as.factor(CompleteEconomicData$Month)
CompleteHolData$MonthDate=as.factor(CompleteHolData$MonthDate)

CompleteEcoHol=merge(CompleteEconomicData,CompleteHolData,by=c("Year","Month"),all=TRUE)
CompleteEcoHol$freq[is.na(CompleteEcoHol$freq)]=0

CompleteSubDataSet=merge(CompleteEcoHol,CompleteWeatherData,by=c("Year","Month"),all=TRUE)
CompleteSubDataSet$Month=as.character(CompleteSubDataSet$Month)
CompleteSubDataSet$Month[CompleteSubDataSet$Month=="Jan"]<-"1"
CompleteSubDataSet$Month[CompleteSubDataSet$Month=="Feb"]<-"2"
CompleteSubDataSet$Month[CompleteSubDataSet$Month=="Mar"]<-"3"
CompleteSubDataSet$Month[CompleteSubDataSet$Month=="Apr"]<-"4"
CompleteSubDataSet$Month[CompleteSubDataSet$Month=="May"]<-"5"
CompleteSubDataSet$Month[CompleteSubDataSet$Month=="Jun"]<-"6"
CompleteSubDataSet$Month[CompleteSubDataSet$Month=="Jul"]<-"7"
CompleteSubDataSet$Month[CompleteSubDataSet$Month=="Aug"]<-"8"
CompleteSubDataSet$Month[CompleteSubDataSet$Month=="Sep"]<-"9"
CompleteSubDataSet$Month[CompleteSubDataSet$Month=="Oct"]<-"10"
CompleteSubDataSet$Month[CompleteSubDataSet$Month=="Nov"]<-"11"
CompleteSubDataSet$Month[CompleteSubDataSet$Month=="Dec"]<-"12"
CompleteSubDataSet$Month=as.numeric(CompleteSubDataSet$Month)
str(CompleteSubDataSet)
str(WomenClothingData)
FinalDataSet=merge(CompleteSubDataSet,WomenClothingData,by=c("Year","Month"),all=TRUE)

colnames(TestHolData)[2]="Month"
TestEcoHol=merge(TestEconomicData,TestHolData,by=c("Year","Month"),all=TRUE)
TestEcoHol$freq[is.na(TestEcoHol$freq)]=0

TestCompleteSet=merge(TestEcoHol,TestWeatherData,by=c("Year","Month"),all=TRUE)
str(TestCompleteSet)

TestCompleteSet$Month[TestCompleteSet$Month=="Jan"]<-"1"
TestCompleteSet$Month[TestCompleteSet$Month=="Feb"]<-"2"
TestCompleteSet$Month[TestCompleteSet$Month=="Mar"]<-"3"
TestCompleteSet$Month[TestCompleteSet$Month=="Apr"]<-"4"
TestCompleteSet$Month[TestCompleteSet$Month=="May"]<-"5"
TestCompleteSet$Month[TestCompleteSet$Month=="Jun"]<-"6"
TestCompleteSet$Month[TestCompleteSet$Month=="Jul"]<-"7"
TestCompleteSet$Month[TestCompleteSet$Month=="Aug"]<-"8"
TestCompleteSet$Month[TestCompleteSet$Month=="Sep"]<-"9"
TestCompleteSet$Month[TestCompleteSet$Month=="Oct"]<-"10"
TestCompleteSet$Month[TestCompleteSet$Month=="Nov"]<-"11"
TestCompleteSet$Month[TestCompleteSet$Month=="Dec"]<-"12"

TestCompleteSet$Month=as.numeric(TestCompleteSet$Month)

TestCompleteSetOrdered=TestCompleteSet[order(TestCompleteSet$Year,TestCompleteSet$Month),]
FinalDataSetOrdered=FinalDataSet[order(FinalDataSet$Year,FinalDataSet$Month),]

#plots

plot(TrainData$Temp.high..Â.C.,TrainData$Sales.In.ThousandDollars.,
     xlab='Temp High',ylab='Sales In Thousand Dollors',main='Temp High vs Sales In Thousand Dollors')

plot(TrainData$Temp.avg..Â.C.,TrainData$Sales.In.ThousandDollars.,
     xlab='Temp Avg',ylab='Sales In Thousand Dollors',main='Temp Avg vs Sales In Thousand Dollors')
plot(TrainData$Temp.low..Â.C.,TrainData$Sales.In.ThousandDollars.,
     xlab='Temp Low',ylab='Sales In Thousand Dollors',main='Temp Low vs Sales In Thousand Dollors')
plot(TrainData$Dew.Point.high..Â.C.,TrainData$Sales.In.ThousandDollars.,
     xlab='Dew Point High',ylab='Sales In Thousand Dollors',main='Dew Point High vs Sales In Thousand Dollors')
plot(TrainData$Dew.Point.avg..Â.C.,TrainData$Sales.In.ThousandDollars.,
     xlab='Dew Point Avg',ylab='Sales In Thousand Dollors',main='Dew Point Avg vs Sales In Thousand Dollors')
plot(TrainData$Dew.Point.low..Â.C.,TrainData$Sales.In.ThousandDollars.,
     xlab='Dew Point Low',ylab='Sales In Thousand Dollors',main='Dew Point Low vs Sales In Thousand Dollors')
plot(TrainData$HumidityÂ.....high,TrainData$Sales.In.ThousandDollars.,
     xlab='Humidity High',ylab='Sales In Thousand Dollors',main='Humidity High vs Sales In Thousand Dollors')
plot(TrainData$HumidityÂ.....avg,TrainData$Sales.In.ThousandDollars.,
     xlab='Humidity Avg',ylab='Sales In Thousand Dollors',main='Humidity Avg vs Sales In Thousand Dollors')
plot(TrainData$HumidityÂ.....low,TrainData$Sales.In.ThousandDollars.,
     xlab='Humidity Low',ylab='Sales In Thousand Dollors',main='Humidity Low vs Sales In Thousand Dollors')
plot(TrainData$VisibilityÂ..km..avg,TrainData$Sales.In.ThousandDollars.,
     xlab='Visibility Avg',ylab='Sales In Thousand Dollors',main='Visibility Avg vs Sales In Thousand Dollors')
plot(TrainData$VisibilityÂ..km..low,TrainData$Sales.In.ThousandDollars.,
     xlab='Visibility Low',ylab='Sales In Thousand Dollors',main='Visibility Low vs Sales In Thousand Dollors')
plot(TrainData$WindÂ..km.h..low,TrainData$Sales.In.ThousandDollars.,
     xlab='Wind Km Low',ylab='Sales In Thousand Dollors',main='Wind Km Low vs Sales In Thousand Dollors')
plot(TrainData$WindÂ..km.h..high,TrainData$Sales.In.ThousandDollars.,
     xlab='Wind Km High',ylab='Sales In Thousand Dollors',main='Wind Km High vs Sales In Thousand Dollors')
plot(TrainData$WindÂ..km.h..avg,TrainData$Sales.In.ThousandDollars.,
     xlab='Wind Km Avg',ylab='Sales In Thousand Dollors',main='Wind Km Avg vs Sales In Thousand Dollors')
plot(TrainData$AverageSealevel,TrainData$Sales.In.ThousandDollars.,
     xlab='AverageSealevel',ylab='Sales In Thousand Dollors',main='AverageSealevel vs Sales In Thousand Dollors')
plot(TrainData$Monthly.Nominal.GDP.Index..inMillion..,TrainData$Sales.In.ThousandDollars.,
     xlab='Nominal.GDP.Index',ylab='Sales In Thousand Dollors',main='Nominal.GDP.Index vs Sales In Thousand Dollors')
plot(TrainData$Monthly.Real.GDP.Index..inMillion..,TrainData
     $Sales.In.ThousandDollars.,
     xlab='Monthly.GDP.Index',ylab='Sales In Thousand Dollors',main='Monthly.GDP.Index vs Sales In Thousand Dollors')
plot(TrainData$CPI,TrainData$Sales.In.ThousandDollars.,
     xlab='CPI',ylab='Sales In Thousand Dollors',main='CPI vs Sales In Thousand Dollors')
plot(TrainData$unemployment.rate,TrainData
     $Sales.In.ThousandDollars.,
     xlab='Unemployment Rate',ylab='Sales In Thousand Dollors',main='Unemployment Rate vs Sales In Thousand Dollors')

plot(TrainData$CommercialBankInterestRateonCreditCardPlans,TrainData$Sales.In.ThousandDollars.,
     xlab='CommercialBankInterestRateonCreditCardPlans',ylab='Sales In Thousand Dollors',main='CommercialBankInterestRateonCreditCardPlans vs Sales In Thousand Dollors')

plot(TrainData$Finance.Rate.on.Personal.Loans.at.Commercial.Banks..24.Month.Loan,TrainData$Sales.In.ThousandDollars.,
     xlab='Finance Rate on Personal Loans',ylab='Sales In Thousand Dollors',main='Finance Rate on Personal Loans vs Sales In Thousand Dollors')

plot(TrainData$Earnings.or.wages..in.dollars.per.hour,TrainData$Sales.In.ThousandDollars.,
     xlab='Earnings In Dollars Per Hour',ylab='Sales In Thousand Dollors',main='Earnings In Dollars Per Hour vs Sales In Thousand Dollors')

plot(TrainData$Cotton.Monthly.Price...US.cents.per.Pound.lbs.,TrainData$Sales.In.ThousandDollars.,
     xlab='Cotton Monthly Price',ylab='Sales In Thousand Dollors',main='Cotton Monthly Price vs Sales In Thousand Dollors')

plot(TrainData$Change.in..,TrainData$Sales.In.ThousandDollars.,
     xlab = '% Change In Cotton Prices',ylab='Sales In Thousand Dollors',main='% Change In Cotton Prices vs Sales In Thousand Dollors')

plot(TrainData$Average.upland.planted.million.acres.,TrainData$Sales.In.ThousandDollars.,
     xlab = 'Average Upland Planted Million Acres',ylab='Sales In Thousand Dollors',main='Average Upland Planted Million Acres vs Sales In Thousand Dollors'   )

plot(TrainData$Average.upland.harvested.million.acres.,TrainData$Sales.In.ThousandDollars.,
     xlab = 'Average Upland Harvested Million Acres',ylab='Sales In Thousand Dollors',main='Average Upland Harvested Million Acres vs Sales In Thousand Dollors')

plot(TrainData$yieldperharvested.acre,TrainData$Sales.In.ThousandDollars.,
     xlab='Yieldperharvested Acre',ylab='Sales In Thousand Dollors',main='Yieldperharvested Acre vs Sales In Thousand Dollors')

plot(TrainData$Production..in..480.lb.netweright.in.million.bales.,TrainData$Sales.In.ThousandDollars.,
     xlab='Production In 480lb Netweright In Million Bales',ylab='Sales In Thousand Dollors',main='Production In 480lb Netweright In Million Bales Acre vs Sales In Thousand Dollors')


plot(TrainData$Mill.use...in..480.lb.netweright.in.million.bales.,TrainData$Sales.In.ThousandDollars.,
     xlab='Mill Use In 480lb Netweright In Million Bales',ylab='Sales In Thousand Dollors',main='Mill Use In 480lb Netweright In Million Bales vs Sales In Thousand Dollors')


plot(TrainData$Exports,TrainData$Sales.In.ThousandDollars.,
     xlab='Exports',ylab='Sales In Thousand Dollors',main='Exports vs Sales In Thousand Dollors')


#Modelling

TrainData=FinalDataSetOrdered[,-c(1,6)]
TestData=TestCompleteSetOrdered[,-c(1,6)]

str(TrainData)
str(TestData)

TrainData$Month=as.factor(TrainData$Month)
TestData$Month=as.factor(TestData$Month)

sum(is.na(TrainData))
colSums(is.na(TestData))
TrainData=centralImputation(TrainData)

std_model=preProcess(TrainData[, !names(TrainData) %in% c("Sales.In.ThousandDollars.")], method = c("center", "scale"))

TrainData[, !names(TrainData) %in% c("Sales.In.ThousandDollars.")] <- predict(object = std_model, newdata = TrainData[, !names(TrainData) %in% c("Sales.In.ThousandDollars.")])

TestData[, !names(TestData) %in% c("Sales.In.ThousandDollars.")] <- predict(object = std_model, newdata = TestData[, !names(TestData) %in% c("Sales.In.ThousandDollars.")])

corrplot(cor(TrainData[,-c(1,5)]), method = "number")

#Regression Modelling

RegModel1=lm(formula = Sales.In.ThousandDollars.~.,data = TrainData)
summary(RegModel1)
Preds1=predict(RegModel1,TrainData[,-c(37)])
regr.eval(TrainData$Sales.In.ThousandDollars., Preds1)
TPreds1=predict(RegModel1,TestData)
TPreds1=as.data.frame(TPreds1)

RegLogModel1=lm(log(Sales.In.ThousandDollars.)~.,data=TrainData)
Preds2=predict(RegLogModel1,TrainData[,-c(37)])
Preds2=exp(Preds2)
regr.eval(TrainData$Sales.In.ThousandDollars., Preds2)
TPreds2=predict(RegLogModel1,TestData)
TPreds2=exp(TPreds2)
TPreds2=as.data.frame(TPreds2)

StepReg1=stepAIC(RegModel1, direction = "both")
summary(StepReg1)
Preds3=predict(StepReg1,TrainData[,-c(37)])
regr.eval(TrainData$Sales.In.ThousandDollars., Preds3)
TPreds4=predict(StepReg1,TestData)
TPreds4=as.data.frame(TPreds4)

StepReg2=stepAIC(RegLogModel1, direction = "both")
summary(StepReg2)
Preds4=predict(StepReg2,TrainData[,-c(37)])
Preds4=exp(Preds4)
regr.eval(TrainData$Sales.In.ThousandDollars., Preds4)
TPreds3=predict(StepReg2,TestData)
TPreds3=exp(TPreds3)
TPreds3=as.data.frame(TPreds3)

NewReg1=cv.lm(df = TrainData, form.lm = formula(Sales.In.ThousandDollars. ~ .), m=5, dots = FALSE, seed=29, plotit=TRUE, printit=TRUE)

#Lasso and Ridge Regression

trainmatrix=model.matrix(TrainData$Sales.In.ThousandDollars.~.,TrainData)
testmatrix=model.matrix(~.,TestData)
registerDoParallel(8)
lassomodel=glmnet(trainmatrix,TrainData$Sales.In.ThousandDollars,family = "gaussian",alpha=1)
cvlassomodel=cv.glmnet(trainmatrix,TrainData$Sales.In.ThousandDollars, type.measure="mse", alpha=1, family="gaussian",nfolds=10,parallel=TRUE)

for (i in 0:100) {
  assign(paste("fit", i, sep=""), cv.glmnet(trainmatrix,TrainData$Sales.In.ThousandDollars, type.measure="mse", alpha=1, family="gaussian",nfolds=10,parallel=TRUE))
}
plot(lassomodel, xvar="lambda")
plot(fit10, main="LASSO")
cvlassomodel$lambda.min
newmodelLasso=glmnet(trainmatrix,TrainData$Sales.In.ThousandDollars,family = "gaussian",alpha=1,lambda = cvlassomodel$lambda.min)
summary(newmodelLasso)
lassopreds=predict(newmodelLasso,trainmatrix)
regr.eval(lassopreds,TrainData$Sales.In.ThousandDollars)
Tpreds5=predict(newmodelLasso,testmatrix)
Tpreds5=as.data.frame(Tpreds5)

ridgemodel=glmnet(trainmatrix,TrainData$Sales.In.ThousandDollars,family = "gaussian",alpha=0)
cvridgemodel=cv.glmnet(trainmatrix,TrainData$Sales.In.ThousandDollars, type.measure="mse", alpha=0, family="gaussian",nfolds=10,parallel=TRUE)

for (i in 0:100) {
  assign(paste("fit", i, sep=""), cv.glmnet(trainmatrix,TrainData$Sales.In.ThousandDollars, type.measure="mse", alpha=1, family="gaussian",nfolds=10,parallel=TRUE))
}

plot(ridgemodel, xvar="lambda")
plot(fit10, main="Ridge")

newridgemodel=glmnet(trainmatrix,TrainData$Sales.In.ThousandDollars,family = "gaussian",alpha=1,lambda = ridgemodel$lambda.min)
summary(newridgemodel)
ridgepreds=predict(newridgemodel,trainmatrix)
regr.eval(ridgepreds,TrainData$Sales.In.ThousandDollars)
Tpreds6=predict(newridgemodel,testmatrix)
Tpreds6=as.data.frame(Tpreds6)

#Random Forests

library(randomForest)
model_rf <- randomForest(Sales.In.ThousandDollars. ~ . , TrainData)
regr.eval(predict(model_rf,TrainData),TrainData$Sales.In.ThousandDollars)
preds_rf <- predict(model_rf, TestData)
RFPreds1=as.data.frame(preds_rf)

#GBM

library(gbm)
library(pROC)

model_gbm <- gbm(Sales.In.ThousandDollars. ~ . , cv.folds = 8, interaction.depth = 3, 
                 shrinkage = 0.005, distribution= 'gaussian',
                 data = TrainData, n.trees = 1600)
regr.eval(predict(model_gbm,TrainData),TrainData$Sales.In.ThousandDollars)
PredVal = predict(model_gbm,newdata = TestData,n.trees = 1600)
PredVal=as.data.frame(PredVal)

#Tuning of GBM

ntrees=c(1500,1700,1800,1900,2000,2100,2200)

for(num in ntrees){
newmodel_gbm <- gbm(Sales.In.ThousandDollars. ~ . , cv.folds = 8, interaction.depth = 3, 
                 shrinkage = 0.005, distribution= 'gaussian',
                 data = TrainData, n.trees = num)
gbmPreds=predict(newmodel_gbm,TrainData)
print(num)
print(regr.eval(gbmPreds,TrainData$Sales.In.ThousandDollars))
}

model_gbm2k <- gbm(Sales.In.ThousandDollars. ~ . , cv.folds = 8, interaction.depth = 3, 
                 shrinkage = 0.005, distribution= 'gaussian',
                 data = TrainData, n.trees = 2000)

PredVal2k = predict(model_gbm2k,newdata = TestData,n.trees = 2000)
PredVal2k=as.data.frame(PredVal2k)

model_gbm1900 <- gbm(Sales.In.ThousandDollars. ~ . , cv.folds = 8, interaction.depth = 3, 
                   shrinkage = 0.005, distribution= 'gaussian',
                   data = TrainData, n.trees = 1900)

PredVal1900 = predict(model_gbm1900,newdata = TestData,n.trees = 1900)
PredVal1900=as.data.frame(PredVal1900)

model_gbm1800 <- gbm(Sales.In.ThousandDollars. ~ . , cv.folds = 8, interaction.depth = 3, 
                     shrinkage = 0.005, distribution= 'gaussian',
                     data = TrainData, n.trees = 1800)

PredVal1800 = predict(model_gbm1800,newdata = TestData,n.trees = 1800)
PredVal1800=as.data.frame(PredVal1800)

shrinkage = c(0.001, 0.01, 0.1)
interaction.depth = c(1, 2, 4,5)

for(sh in shrinkage){
  for(idep in interaction.depth){
    gbmtunemodel=gbm(Sales.In.ThousandDollars. ~ . , cv.folds = 8, interaction.depth = idep, 
                     shrinkage = sh, distribution= 'gaussian',
                     data = TrainData, n.trees = 1800)
    gbmtunePreds=predict(gbmtunemodel,TrainData)
    print(sh)
    print(idep)
    print(regr.eval(gbmtunePreds,TrainData$Sales.In.ThousandDollars))
    
  }
}

gbmTune1=gbm(Sales.In.ThousandDollars. ~ . , cv.folds = 8, interaction.depth = 2, 
             shrinkage = 0.001, distribution= 'gaussian',
             data = TrainData, n.trees = 1800)
regr.eval(predict(gbmTune1,TrainData),TrainData$Sales.In.ThousandDollars)
PredValTuneGbm1 = predict(gbmTune1,newdata = TestData,n.trees = 1800)
PredValTuneGbm1=as.data.frame(PredValTuneGbm1)

