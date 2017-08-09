###########################################

#File Name : designCreate.R

#Date : 08-08-2017

#Author: Juan Garcia

#Email: jggarcia@sfu.ca

#Last Modified: mar 08 ago 2017 16:42:25 PDT

#Purpose:Script to create the design points

#Modifications:

###########################################


#Values of the parameters
p=0.1
L=-60
z0=2.7

f1=rep(p,64);f2=rep(z0,64);f3=rep(L,64)

Tab=cbind(f1,f2,f3)

write.table(Tab,'design.txt',col.names=F,row.names=F)
