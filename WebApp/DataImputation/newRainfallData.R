# Libraries
library(mice) 
library(VIM)

########## Reading Data ###########
# tacking into considration transforming empty cells to NA 
Global_Landslide_Rainfall <- read.csv(file.choose(), header = T, na.strings = c("","NA"))


# delete countrycod col as it's all empty
#Global_Landslide_Rainfall <- Global_Landslide_Rainfall[-c(27)]

View(Global_Landslide_Rainfall) # check if there're 34 cols first before running the previous line


###  Structrure of this Data per col (which shows data types & number of levels for Factor variables)
str(Global_Landslide_Rainfall)


###  Data Summarize that aslo shows up NA's Values in each Col
summary(Global_Landslide_Rainfall)


# Checking on total NA values using Summation (to be more sure after using summary)
sum(is.na(Global_Landslide_Rainfall)==TRUE)  # 29057 after deleting the empty col


########### Missing Data #############

# Missing Data Percentage
percentage <- function(x) {sum(is.na(x))/length(x)*100}

apply(Global_Landslide_Rainfall, 2, percentage)

# To show Missing Data per each col on shape of like Truth Table, value = 1 means that there's no missing data & 0 OW
md.pattern(Global_Landslide_Rainfall)

# Observed & Missing relationship (4 times)
md.pairs(Global_Landslide_Rainfall)

# red supposed to be for missing data
marginplot(Global_Landslide_Rainfall[, c('adminname2', 'photos_lin')])


########### IMPUTE ###########

# m for number of completeness (imputation times)
# use cart as it doesn't depend on linear regression 
# divide imputed data with high numbers of levels by rows to avoid crashing

imputeRainfallDate <- mice(Global_Landslide_Rainfall[, 3:4], method = "cart", maxit = 3)  
imputeRainfallTimeCountry <- mice(Global_Landslide_Rainfall[, 5:6], method = "cart")
imputeRainfallNearestUp <- mice(Global_Landslide_Rainfall[1:2219, 7:8], method = "cart", maxit = 3, m = 3)### 6545 levels
imputeRainfallNearestMid <- mice(Global_Landslide_Rainfall[2220:4449, 7:8], method = "cart", maxit = 3, m = 3)
imputeRainfallNearestDown <- mice(Global_Landslide_Rainfall[4450:6788, 7:8], method = "cart", maxit = 3, m = 3)
imputeRainfallStormName <- mice(Global_Landslide_Rainfall[, 9:12], method = "cart")
imputeRainfallSourceName <- mice(Global_Landslide_Rainfall[, 13:14], method = "cart")
imputeRainfallSourceLineUp <- mice(Global_Landslide_Rainfall[1:2219, 15:16], method = "cart", maxit = 3, m = 3)### 5083 levels
imputeRainfallSourceLineMid <- mice(Global_Landslide_Rainfall[2220:4449, 15:16], method = "cart", maxit = 3, m = 3)
imputeRainfallSourceLineDown <- mice(Global_Landslide_Rainfall[4450:6788, 15:16], method = "cart", maxit = 3, m = 3)
imputeRainfallLandPhotoCat <- mice(Global_Landslide_Rainfall[, 17:21], method = "cart")
imputeRainfallNearUp <- mice(Global_Landslide_Rainfall[1:3349, 22:23], method = "cart", maxit = 3, m = 3)### 3563 levels
imputeRainfallNearDown <- mice(Global_Landslide_Rainfall[3350:6788, 22:23], method = "cart", maxit = 3, m = 3)
imputeRainfallAdmine12 <- mice(Global_Landslide_Rainfall[, 24:25], method = "cart")
imputeRainfallContKey <- mice(Global_Landslide_Rainfall[, 27:28], method = "cart")

# show best method which I'll get the missing data with it
print(imputeRainfallDate)

# Showing imputed data of specific col over iterations based on row's number
#imputeRainfall$imp$adminname1

# just to check there's a NA
Global_Landslide_Rainfall[2,]
summary(Global_Landslide_Rainfall$adminname2)


########## Compelete Data ############

# To get imputed data, 1 is supposed refer to m times of imputation of the missing data
newDataRainfallDate <- complete(imputeRainfallDate, 1)     # (when change 1, imputed data will change too)
newDataRainfallTimeCountry <- complete(imputeRainfallTimeCountry, 1)
newDataRainfallNearestUp <- complete(imputeRainfallNearestUp, 1)        ######
newDataRainfallNearestMid <- complete(imputeRainfallNearestMid, 1)
newDataRainfallNearestDown <- complete(imputeRainfallNearestDown, 1)
newDataRainfallStormName <- complete(imputeRainfallStormName, 1)
newDataRainfallSourceName <- complete(imputeRainfallSourceName, 1)
newDataRainfallSourceLineUp <- complete(imputeRainfallSourceLineUp, 1)    ######
newDataRainfallSourceLineMid <- complete(imputeRainfallSourceLineMid, 1)
newDataRainfallSourceLineDown <- complete(imputeRainfallSourceLineDown, 1)
newDataRainfallLandPhotoCat <- complete(imputeRainfallLandPhotoCat, 1)
newDataRainfallNearUP <- complete(imputeRainfallNearUp, 1)        ######
newDataRainfallNearDown <- complete(imputeRainfallNearDown, 1)
newDataRainfallAdmine12 <- complete(imputeRainfallAdmine12, 1)
newDataRainfallContKey <- complete(imputeRainfallContKey, 1)

print(newDataRainfallAdmine12)

# to combine the divided cols -by rows-
newDataRainfallNear <- rbind(newDataRainfallNearUP, newDataRainfallNearDown)
print(newDataRainfallNear)
sum(is.na(newDataRainfallNear)==TRUE)

newDataRainfallSourceLine <- rbind(newDataRainfallSourceLineUp, newDataRainfallSourceLineMid, newDataRainfallSourceLineDown)
sum(is.na(newDataRainfallSourceLine)==TRUE)

newDataRainfallNearest <- rbind(newDataRainfallNearestUp, newDataRainfallNearestMid, newDataRainfallNearestDown)
sum(is.na(newDataRainfallNearest)==TRUE)


########## FINAL IMPUTED DATA ############

# by combining all cols that we get from complete fn
newDataRainfall <- cbind(Global_Landslide_Rainfall$the_geom, Global_Landslide_Rainfall$OBJECTID, newDataRainfallDate,
                         newDataRainfallTimeCountry, newDataRainfallNearest, newDataRainfallStormName, 
                         newDataRainfallSourceName, newDataRainfallSourceLine, newDataRainfallLandPhotoCat, 
                         newDataRainfallNear, newDataRainfallAdmine12, Global_Landslide_Rainfall$population, 
                         newDataRainfallContKey, Global_Landslide_Rainfall$version, Global_Landslide_Rainfall$user_id, 
                         Global_Landslide_Rainfall$tstamp, Global_Landslide_Rainfall$changeset_,
                         Global_Landslide_Rainfall$latitude, Global_Landslide_Rainfall$longitude)

sum(is.na(newDataRainfall)==TRUE)  # should be zero now 


########## for Renaming ############ 

# tools to split up a big data structure into homogeneous pieces, apply a fn to each piece and then combine all results together.
library(plyr) 

# Modify names by name, not position.
newDataRainfall = rename(newDataRainfall ,c("Global_Landslide_Rainfall$the_geom" = "the_geom", 
                                            "Global_Landslide_Rainfall$OBJECTID" = "OBJECTID",
                                            "Global_Landslide_Rainfall$population" = "population",
                                            "Global_Landslide_Rainfall$version" = "version",
                                            "Global_Landslide_Rainfall$user_id" = "user_id",
                                            "Global_Landslide_Rainfall$tstamp" = "tstamp",
                                            "Global_Landslide_Rainfall$changeset_" = "changeset_",
                                            "Global_Landslide_Rainfall$latitude" = "latitude",
                                            "Global_Landslide_Rainfall$longitude" = "longitude"))

# view the final new data after imputation 
View(newDataRainfall)

library(openxlsx)
write.csv(newDataRainfall, "newDataRainfall.csv")


