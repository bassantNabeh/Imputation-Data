# Libraries
library(mice) 
library(VIM)

########## Reading Data ###########
# tacking into considration transforming empty cells to NA 
Meteorite_Landings <- read.csv(file.choose(), header = T, na.strings = c("","NA"))

View(Meteorite_Landings)


###  Structrure of this Data per col (which shows data types & number of levels for Factor variables)
str(Meteorite_Landings)


### Data Summarize that aslo shows up NA's Values in each Col
summary(Meteorite_Landings)


# Checking on total NA values using Summation (to be more sure after using summary)
sum(is.na(Meteorite_Landings)==TRUE)  # 22367


########### Missing Data #############

# Missing Data Percentage
percentage <- function(x) {sum(is.na(x))/length(x)*100}

apply(Meteorite_Landings, 2, percentage)

# To show Missing Data per each col on shape of like Truth Table, value = 1 means that there's no missing data & 0 OW
md.pattern(Meteorite_Landings)

# Observed & Missing relationship (4 times)
md.pairs(Meteorite_Landings)

# red supposed to be for missing data
marginplot(Meteorite_Landings[, c('mass..g.', 'reclat')])


########### IMPUTE ###########

# m for number of completeness (imputation times)
# use cart as it doesn't depend on linear regression 

imputeMass <- mice(Meteorite_Landings[,5:6], method = "cart")
imputeYear <- mice(Meteorite_Landings[,6:7], method = "cart")
imputeRec <- mice(Meteorite_Landings[,8:9], method = "cart")

# To show best method which I'll get the missing data with it
print(imputeRec)

# Showing imputed data of specific col over iterations based on row's number
imputeRec$imp$reclat
imputeYear$imp$year

# just to check there's a NA
Meteorite_Landings[148,]
summary(Meteorite_Landings$GeoLocation)


########## Compelete Data ############

# To get imputed data, 1 is supposed refer to m times of imputation of the missing data
newDataRec <- complete(imputeRec, 1)     # (when change 1, imputed data will change too)
print(newDataRec)

newDataMass <- complete(imputeMass, 1)
print(newDataMass)

newDataYear <- complete(imputeYear, 1)
print(newDataYear)


########## FINAL IMPUTED DATA ############

# by combining all cols that we get from complete fn
newDataMeteorite <- cbind(Meteorite_Landings$name, Meteorite_Landings$id, Meteorite_Landings$nametype, 
                          Meteorite_Landings$recclass, newDataMass, newDataYear$year, newDataRec)

sum(is.na(newDataMeteorite)==TRUE)  # should be zero now


########## for Renaming ############ 

# tools to split up a big data structure into homogeneous pieces, apply a fn to each piece and then combine all results together.
library(plyr) 

# Modify names by name, not position.
newDataMeteorite = rename(newDataMeteorite ,c("Meteorite_Landings$name"="name", "Meteorite_Landings$id"="id",
                                               "Meteorite_Landings$nametype"="nametype", "Meteorite_Landings$recclass"
                                              = "recclass", "newDataYear$year"="year"))

## combine last col that mainly depends on the 2 col previous it 
# using seperator to seperate between the 2 values like in the original data
newDataMeteorite$GeoLocation <- with(newDataMeteorite, paste(newDataMeteorite$reclat, newDataMeteorite$reclong,
                                     sep = ","))

View(newDataMeteorite)

library(openxlsx)
write.csv(newDataMeteorite, "newDataMeteorite.csv")


#library(data.table)
#newDataMeteorite(newDataMeteorite, old=c("Meteorite_Landings$name","Meteorite_Landings$id","Meteorite_Landings$nametype",
#                                         "Meteorite_Landings$recclass" , "newDataYear$year"), 
#                 new=c("name", "id" , "nametype", "recclass" , "year"))


