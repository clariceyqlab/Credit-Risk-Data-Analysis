library(readxl)
data <- read_excel("RiskSpanSkillsAssessment.xlsx",sheet = "Data")
View(data)
attach(data)

/**Report1
aggregate(CURRENT_BALANCE~LENDER_INST_TYPE_DESCRIPTION,data,length)
length(LOAN_NUMBER)
aggregate(CURRENT_BALANCE~LENDER_INST_TYPE_DESCRIPTION,data,mean)
mean(CURRENT_BALANCE)
aggregate(CURRENT_BALANCE~LENDER_INST_TYPE_DESCRIPTION,data,max)
max(CURRENT_BALANCE)
aggregate(CURRENT_BALANCE~LENDER_INST_TYPE_DESCRIPTION,data,min)
min(CURRENT_BALANCE)

/**Report2
min(LTV)
max(LTV)
data$LTVcat<-cut(data$LTV, breaks=seq(80,100,5),labels=c("<= 85%",">85% and <= 90%",">90% and <= 95%","> 95%"))
aggregate(CURRENT_BALANCE~LTVcat,data,length)
aggregate(CURRENT_BALANCE~LTVcat,data,mean)
aggregate(CURRENT_BALANCE~LTVcat,data,max)
aggregate(CURRENT_BALANCE~LTVcat,data,min)

/**Report3
install.packages("lubridate")
library("lubridate")
install.packages("zoo")
library("zoo")
data$Age <-(as.yearmon(strptime("06.01.2013", format = "%m.%d.%Y"))- as.yearmon(strptime(data$LOAN_ORIG_DATE, format = "%Y-%m-%d")))*12
attach(data)
data$Agecat<-addNA(cut(Age, breaks=c(0,10,20,30,40,70),labels=c("0 - 9 Months","10 - 19 Months","20 - 29 Months","30 - 39 Months",">= 40 Months"), right=FALSE))
aggregate(CURRENT_BALANCE~Agecat,data,length)
aggregate(CURRENT_BALANCE~Agecat,data,mean)
aggregate(CURRENT_BALANCE~Agecat,data,max)
aggregate(CURRENT_BALANCE~Agecat,data,min)

/**Report4
min(FICO_SCORE)
max(FICO_SCORE)
data$FICOcat<-cut(FICO_SCORE, breaks=c(100,600,700,800,900),labels=c("< 600","600 - 699","700 - 799",">= 800"),right=FALSE)
R4 <- aggregate(CURRENT_BALANCE~FICOcat+LTVcat,data,sum)
R4

/**BarGraph
install.packages("ggplot2")
library(ggplot2)
library(scales)
g1 <- ggplot(data=R4, aes(x=LTVcat, y=CURRENT_BALANCE/1000000, fill=FICOcat))+
  geom_bar(stat="identity", position=position_dodge())+scale_fill_hue(name="FICO Score")+
  ggtitle("Current Balance by LTV Cohorts and FICO Cohorts")+xlab("LTV Cohorts") + ylab("Current Balance ($M)")+
  theme_bw() +theme(legend.position=c(.85, .85))+scale_y_continuous(labels=comma)
g2 <- ggplot(data=R4, aes(x=FICOcat, y=CURRENT_BALANCE/1000000, fill=LTVcat))+
  geom_bar(stat="identity", position=position_dodge())+scale_fill_hue(name="Loan to Value")+
  ggtitle("Current Balance by FICO Cohorts and LTV Cohorts")+xlab("FICO Score") + ylab("Current Balance ($M)")+
  theme_bw() +theme(legend.position=c(.15, .85))+scale_y_continuous(labels=comma)
g1
g2