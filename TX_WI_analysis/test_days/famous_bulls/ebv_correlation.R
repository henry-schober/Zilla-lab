#!/usr/bin/Rscript

#assigning values to files

age<-read.table('TX_WI_ebvs')

#$2 is TX, $3 is WI
cor(age[,2],age[,3]) #-0.1117253

