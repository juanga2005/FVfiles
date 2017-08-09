###########################################

#File Name : designCreate.R

#Date : 08-08-2017

#Author: Juan Garcia

#Email: jggarcia@sfu.ca

#Last Modified: mié 09 ago 2017 01:05:14 PDT

#Purpose:Script to create the design points

#Modifications:

###########################################


#Values of the parameters
p=0.471236
L=-60.86922
z0=2.661986

f1=rep(p,64);f2=rep(z0,64);f3=rep(L,64)

Tab=cbind(f1,f2,f3)

write.table(Tab,'design.txt',col.names=F,row.names=F)
