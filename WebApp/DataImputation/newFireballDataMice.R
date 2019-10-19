# Libraries
library(mice) 
library(VIM)

########## Reading Data ###########
# tacking into considration transforming empty cells to NA 
Fireball_And_Bolide_Reports <- read.csv(file.choose(), header = T, na.strings = c("","NA"))






View(Fireball_And_Bolide_Reports)


###  Structrure of this Data per col (which shows data types & number of levels for Factor variables)
str(Fireball_And_Bolide_Reports)


### Data Summarize that aslo shows up NA's Values in each Col
summary(Fireball_And_Bolide_Reports)


# Checking on total NA values using Summation (to be more sure after using summary)
sum(is.na(Fireball_And_Bolide_Reports)==TRUE)  # 299


########### Missing Data #############

# Missing Data Percentage
percentage <- function(x) {sum(is.na(x))/length(x)*100}

apply(Fireball_And_Bolide_Reports, 2, percentage)

# To show Missing Data per each col on shape of like Truth Table, value = 1 means that there's no missing data & 0 OW
md.pattern(Fireball_And_Bolide_Reports)

# Observed & Missing relationship (4 times)
md.pairs(Fireball_And_Bolide_Reports)

# red supposed to be for missing data
marginplot(Fireball_And_Bolide_Reports[, c('Velocity..km.s.', 'Velocity.Components..km.s...vy')])


########### IMPUTE ###########

# m for number of completeness (imputation times)
# use cart as it doesn't depend on linear regression 

imputeFire <- mice(Fireball_And_Bolide_Reports)

# To show best method which I'll get the missing data with it
print(imputeFire)

# Showing imputed data of specific col over iterations based on row's number
imputeFire$imp$Altitude..km.

# just to check there's a NA
Fireball_And_Bolide_Reports[39,]
summary(Fireball_And_Bolide_Reports$Velocity..km.s.)


########## Compelete Data ############

# To get imputed data, 1 is supposed refer to m times of imputation of the missing data
newDataFireball <- complete(imputeFire, 1)     # (when change 1, imputed data will change too)
sum(is.na(newDataFireball)==TRUE)  # should be zero now 
View(newDataFireball)


Fireball_And_Bolide_Reports=Fireball_And_Bolide_Reports[-c(1,2,3)]
newDataFireball=newDataFireball[-c(1,2,3)]


Fireball_And_Bolide_Reports[is.na(Fireball_And_Bolide_Reports)]=0
MSE=(sum(((Fireball_And_Bolide_Reports - newDataFireball) ^2) )/ (dim(Fireball_And_Bolide_Reports)[1]*dim(Fireball_And_Bolide_Reports)[2]))^0.5
MSE

library(openxlsx)
write.csv(newDataFireball, "newDataFireball.csv")
