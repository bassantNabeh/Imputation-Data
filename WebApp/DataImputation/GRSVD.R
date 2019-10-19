fire <- read.csv(file.choose(), header = T, na.strings = c("",NA))

#fire=fire[-c(2,3)]
    
str(fire)


library(varhandle)

fire$Date.Time...Peak.Brightness..UT.=unfactor(fire$Date.Time...Peak.Brightness..UT.)

fire$Date.Time...Peak.Brightness..UT.[5:10]=NA

y=fire$Date.Time...Peak.Brightness..UT.


z=unique(y)

Counter=1

for (name in fire$Date.Time...Peak.Brightness..UT.) {
  
  fire$Date.Time...Peak.Brightness..UT.[Counter]=ifelse(is.na(name),NA,which(z %in% name))
  Counter=Counter+1
}

fire$Date.Time...Peak.Brightness..UT.=as.numeric(fire$Date.Time...Peak.Brightness..UT.)




fire$Latitude..Deg.=unfactor(fire$Latitude..Deg.)

fire$Latitude..Deg.[5:10]=NA

y2=fire$Latitude..Deg.


z2=unique(y2)

Counter2=1

for (name2 in fire$Latitude..Deg.) {
  
  fire$Latitude..Deg.[Counter2]=ifelse(is.na(name2),NA,which(z2 %in% name2))
  Counter2=Counter2+1
}

fire$Latitude..Deg.=as.numeric(fire$Latitude..Deg.)




fire$Longitude..Deg.=unfactor(fire$Longitude..Deg.)

fire$Longitude..Deg.[5:10]=NA

y3=fire$Longitude..Deg.


z3=unique(y3)

Counter3=1

for (name3 in fire$Longitude..Deg.) {
  
  fire$Longitude..Deg.[Counter3]=ifelse(is.na(name3),NA,which(z3 %in% name3))
  Counter3=Counter3+1
}

fire$Longitude..Deg.=as.numeric(fire$Longitude..Deg.)




library(softImpute)

x=data.matrix(fire, rownames.force = NA)

fits=softImpute(x,trace=TRUE,type="svd")
p=complete(x,fits)

firep=as.data.frame(p)



firep$Date.Time...Peak.Brightness..UT.=ceiling(firep$Date.Time...Peak.Brightness..UT.)

firep$Date.Time...Peak.Brightness..UT.=z[firep$Date.Time...Peak.Brightness..UT.]



firep$Latitude..Deg.=ceiling(firep$Latitude..Deg.)

firep$Latitude..Deg.=z2[firep$Latitude..Deg.]



firep$Longitude..Deg.=ceiling(firep$Longitude..Deg.)

firep$Longitude..Deg.=z3[firep$Longitude..Deg.]



firep$Date.Time...Peak.Brightness..UT.=as.numeric(firep$Date.Time...Peak.Brightness..UT.)
firep$Latitude..Deg.=as.numeric(firep$Latitude..Deg.)
firep$Longitude..Deg.=as.numeric(fire$Longitude..Deg.)


fire[is.na(fire)]=0
firep[is.na(firep)]=0

MSE=(sum(((fire - firep) ^2) )/ (dim(fire)[1]*dim(firep)[2]))^0.5
MSE
