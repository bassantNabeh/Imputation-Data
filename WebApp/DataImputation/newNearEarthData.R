# Libraries
library(mice) 
library(VIM)
library(randomForest)

########## Reading Data ###########
# tacking into considration transforming empty cells to NA 
Near_Earth_Comets_Orbital_Elements <- read.csv(file.choose(), header = T, na.strings = c("","NA"))

View(Near_Earth_Comets_Orbital_Elements)


###  Structrure of this Data per col (which shows data types & number of levels for Factor variables)
str(Near_Earth_Comets_Orbital_Elements)


### Data Summarize that aslo shows up NA's Values in each Col
summary(Near_Earth_Comets_Orbital_Elements)


# Checking on total NA values using Summation (to be more sure after using summary)
sum(is.na(Near_Earth_Comets_Orbital_Elements)==TRUE)  # 547


########### Missing Data #############

# Missing Data Percentage
percentage <- function(x) {sum(is.na(x))/length(x)*100}

apply(Near_Earth_Comets_Orbital_Elements, 2, percentage)

# To show Missing Data per each col on shape of like Truth Table, value = 1 means that there's no missing data & 0 OW
md.pattern(Near_Earth_Comets_Orbital_Elements)

# Observed & Missing relationship (4 times)
md.pairs(Near_Earth_Comets_Orbital_Elements)

# red supposed to be for missing data
marginplot(Near_Earth_Comets_Orbital_Elements[, c('A3..AU.d.2.', 'DT..d.')])


## just to make numbers more large to be able to compute it and to see it as infinty value 
Near_Earth_Comets_Orbital_Elements$A1..AU.d.2. <- Near_Earth_Comets_Orbital_Elements$A1..AU.d.2. * 10000
Near_Earth_Comets_Orbital_Elements$A2..AU.d.2. <- Near_Earth_Comets_Orbital_Elements$A2..AU.d.2. * 10000
Near_Earth_Comets_Orbital_Elements$A3..AU.d.2. <- Near_Earth_Comets_Orbital_Elements$A3..AU.d.2. * 10000
sum(is.na(Near_Earth_Comets_Orbital_Elements)==TRUE)


########### IMPUTE ###########

# m for number of completeness (imputation times)
# use cart as it doesn't depend on linear regression 

imputeEarth <- mice(Near_Earth_Comets_Orbital_Elements, method = "cart")

# To show best method which I'll get the missing data with it
print(imputeEarth)

# Showing missed data over iterations based on their row's number
imputeEarth$imp$DT..d.

# just to check there's a NA
Near_Earth_Comets_Orbital_Elements[2,]
summary(Near_Earth_Comets_Orbital_Elements$A2..AU.d.2.)


########## Compelete Data ############

# To get imputed data, 1 is supposed refer to m times of imputation the missing data
newDataNearEarth <- complete(imputeEarth, 1)

sum(is.na(newDataNearEarth)==TRUE) # should be zero now 

## to return it back to it's main value range 
newDataNearEarth$A1..AU.d.2. <- newDataNearEarth$A1..AU.d.2. / 10000
newDataNearEarth$A2..AU.d.2. <- newDataNearEarth$A2..AU.d.2. / 10000
newDataNearEarth$A3..AU.d.2. <- newDataNearEarth$A3..AU.d.2. / 10000

View(newDataNearEarth)

library(openxlsx)
write.csv(newDataNearEarth,"newDataNearEarth.csv")

