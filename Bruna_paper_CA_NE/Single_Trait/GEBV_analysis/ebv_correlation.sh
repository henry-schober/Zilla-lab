R

#assigning values to files

milk<-read.table('ebvs_milk_famous')
fat<-read.table('ebvs_fat_famous')
protein<-read.table('ebvs_protein_famous')

#calculation correlation between EBVs, $2 is CA, $2 is NE

cor(milk[,2],milk[,3]) # 0.8317268
cor(fat[,2],fat[,3]) # 0.8615846
cor(protein[,2],protein[,3]) # 0.8418167