#chapter 3 exercice 1 :
#set directory
setwd(dir = '../mydirectory')
#data loading
data<-read.csv('birdflu.csv',header=T,sep=';')
#Use the names and str command in R to view the data.
names(data)
str(data)
#print the number of bird flu cases in 2003
sum(data$cases_2003)
#What is the total number of bird flu cases in 2003 and in 2005?
sum(data$cases_2003)+sum(data$cases_2005)
#What is the total number of bird flu cases per country?
#we create the column 'total_per_country' that represents the total number of bird flu cases per country
data$total_per_country=rowSums(data[,c(2,4,6,8,10,12)])
#Which country has had the most cases?
worst_country=data$X[data$total_per_country==max(data$total_per_country)]
worst_country
#Which country has had the least bird flu deaths ?
best_country=data$X[data$total_per_country==min(data$total_per_country)]
best_country
#What is the total number of cases per year?
#we create the row 'Total_per_year' that represents the total number of bird flu cases or deaths per year
data <- cbind(data, Total_per_year = rowSums(data))
