require(xgboost)
#datalink <- 'C:/Users/User/PycharmProjects/untitled6/nasa/Meteorite_Landings.csv'
data <- read.csv(file.choose(), header = T, na.strings = c("","NA"))

x=data$Altitude..km.
y=data$Velocity..km.s.

x[is.na(x)]=0
y[is.na(y)]=0

#data(x, package='xgboost')
#data(agaricus.test, package='xgboost')
#train <- x
#test <- agaricus.test

#print(dim(as.matrix(x)))
#print(head(x))
#xgb_params<-list("objective"="multi:softprob","eval_metric"="mlogloss","num_class"=nc)
MSE <- xgboost(data =as.matrix(x), label = y, max.depth = 2, eta = 1, nthread = 2, nrounds = 2, objective = "reg:linear")

MSE
