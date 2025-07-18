#!/bin/bash
#SBATCH --partition=priority
#SBATCH --ntasks=24
#SBATCH --time=32:00:00
#SBATCH --mem=128GB

#1.run renumf90
#you must have renum.par in your directory
echo renum.par | renumf90 | tee renum.log #running renumf90

#2. Removing phenotypes from young animals(gen 10)

awk '$6!=10' renf90.dat > renf90.train  #creating a training population for first 9 gen, 10th generation is on column 6
awk '$6==10' renf90.dat | awk '{print $3}' | sort > ids.gen10 # saving animal ids for gen 10

#part2;Estimation of gebv, snp effects with variance

awk '$6==10' renf90.dat | awk ' {print $3,$5}' | sort  +0 -1 > tbv.gen10 #save ids and TBV for generation 10

#Training population- set1

mkdir gen_1to3_train #making a directory
cd gen_1to3_train #enter into the directory

awk '$6>=1 && $6<=3' ../renf90.train  > renf90.dat #copying the training data set and saving it as renf90.dat
ln -s ../genotypes.snp .  # softlink for the genotypes file
ln -s ../genotypes.snp_XrefID .
cp ../renadd02.ped .       # softlink for the pedigree file
cp ../renf90.par .
cp ../ids.gen10 .
cp ../tbv.gen10 .
cp ../gen_map.txt .

cp renf90.par pre.par #initialize parameter file for pregs
cp renf90.par post.par #initialize parameter file for postgs


echo "OPTION saveGInverse" >> pre.par #add option to saves G inverse for gwas pregsf
echo "OPTION map_file gen_map.txt" >> pre.par #add option for map file
echo "OPTION snp_p_value" >>pre.par #computes p-values for GWAS from elements of the inverse of MME from blupf90

echo "OPTION readGInverse" >> post.par #add option for postgsf which reads G inverse which we created
echo "OPTION map_file gen_map.txt" >> post.par #add option to assign SNP to their location for Manhattan plots, so chromosomes are visualized in different colors
echo "OPTION Manhattan_plot_R_format pdf" >> post.par #add option to plot the Manhattan plot (SNP effects) for each trait and correlated effects using R(format is pdf).
echo "OPTION windows_variance 20" >> post.par #add option to calculates the variance explained by 20 adjacent SNPs
echo "OPTION windows_variance_type 1" >> post.par #add option to calculate the variance explained by n adjacent SNPs(1 for moving windows)
echo "OPTION snp_p_value" >> post.par #computes p-values for GWAS from elements of the inverse of MME from blupf90

#before you run blupf90 or any other software, I suggest using:
ulimit -s unlimited
export OMP_STACKSIZE=128M

echo pre.par | blupf90 | tee ssgblup_set1_pre.log #run pregs
echo post.par | postGSf90 | tee ssgblup_set1_post.log #run postgs

awk '$2==2' solutions | awk ' {print $3, $4}' | sort +0 -1 > solutions.sort #save ebvs for generation 10
join -1 1 -2 1 solutions.sort ids.gen10 > solutions.gen10_set1 #gebv

join -1 1 -2 1 solutions.sort tbv.gen10 > sol_tv.gen10_set1  #tbv

join -1 1 -2 1 solutions.gen10_set1 tbv.gen10 > val.set1.gen10 #to validate

####Training population- 4,5,6

cd ..
mkdir gen_4to6_train
cd gen_4to6_train

#create a file with 4-6 gen only
awk '$6>=4 && $6<=6' ../renf90.train > renf90.dat #copying the training data set and saving it as renf90.dat
ln -s ../renadd02.ped . # softlink for the pedigree file
ln -s ../genotypes.snp . #softlink for the genotype file
ln -s ../genotypes.snp_XrefID . #and the xref ID file
cp ../ids.gen10 .
cp ../tbv.gen10 .
cp ../renf90.par .
cp ../gen_map.txt .

cp renf90.par pre.par #initialize parameter file for pregs
cp renf90.par post.par #initialize parameter file for postgs


echo "OPTION saveGInverse" >> pre.par #add option for gwas pregs
echo "OPTION map_file gen_map.txt" >> pre.par #add option for mapped file
echo "OPTION snp_p_value" >> pre.par #computes p-values for GWAS from elements of the inverse of MME from blupf90

echo "OPTION readGInverse" >> post.par #add option for reading G inverse file
echo "OPTION map_file gen_map.txt" >> post.par #add option to assign SNP to their location for Manhattan plots for visualising chr in different colours
echo "OPTION Manhattan_plot_R_format pdf" >> post.par #add option to plot the Mplot(SNP effects) for each trait and correlated effects using R in pdf format
echo "OPTION windows_variance 20" >> post.par #calculates the variance explained by 20 adjacent SNPs
echo "OPTION windows_variance_type 1" >> post.par #add option to set window type for variances calculation(1 for moving windows)
echo "OPTION snp_p_value" >>post.par #computes p-values for GWAS from elements of the inverse of MME from blupf90

#before you run blupf90 or any other software, I suggest using:
ulimit -s unlimited
export OMP_STACKSIZE=128M

echo pre.par | blupf90 | tee ssgblup_set2_pre.log #run pregs
echo post.par | postGSf90 | tee ssgblup_set2_post.log #run postgs

awk '$2==2' solutions | awk ' {print $3, $4}' | sort +0 -1 > solutions.sort #save ebvs for generation 10
join -1 1 -2 1 solutions.sort ids.gen10 > solutions.gen10_set2 # gebv
join -1 1 -2 1 solutions.sort tbv.gen10 > sol_tv.gen10_set2 # tbv
join -1 1 -2 1 solutions.gen10_set2 tbv.gen10 > val.set2.gen10 #to validate


#Training population-set3

cd ..
mkdir gen_7to9_train
cd gen_7to9_train

#create a file with 7-9 gen only
awk '$6>=7 && $6<=9' ../renf90.train > renf90.dat #copying the training data set and saving it as renf90.dat
ln -s ../renadd02.ped . # softlink for the pedigree file
ln -s ../genotypes.snp . #softlink for the genotype file
ln -s ../genotypes.snp_XrefID . #and the xref ID file
cp ../renf90.par .
cp ../ids.gen10 .
cp ../tbv.gen10 .
cp ../gen_map.txt .

cp renf90.par pre.par #initialize parameter file for pregs
cp renf90.par post.par #initialize parameter file for postgs

echo "OPTION saveGInverse" >> pre.par #add option for gwas pregs
echo "OPTION map_file gen_map.txt" >> pre.par #add option for mapped file
echo "OPTION snp_p_value" >>pre.par #computes p-values for GWAS from elements of the inverse of MME from blupf90

echo "OPTION readGInverse" >> post.par #add option for reading G inverse file
echo "OPTION map_file gen_map.txt" >> post.par #add option to assign SNP to their location for Manhattan plots for visualising chr in different colours
echo "OPTION Manhattan_plot_R_format pdf" >> post.par #add option to plot the Mplot(SNP effects) for each trait and correlated effects using R in pdf format
echo "OPTION windows_variance 20" >> post.par #calculates the variance explained by 20 adjacent SNPs
echo "OPTION windows_variance_type 1" >> post.par #add option to set window type for variances calculation(1 for moving windows)
echo "OPTION snp_p_value" >>post.par #computes p-values for GWAS from elements of the inverse of MME from blupf90

#before you run blupf90 or any other software, I suggest using:
ulimit -s unlimited
export OMP_STACKSIZE=128M

echo pre.par | blupf90 | tee ssgblup_set3_pre.log #run pregs
echo post.par | postGSf90 | tee ssgblup_set3_post.log #run postgs


awk '$2==2'  solutions | awk ' {print $3, $4}' | sort +0 -1 > solutions.sort
join -1 1 -2 1 solutions.sort ids.gen10 > solutions.gen10_set3
join -1 1 -2 1 solutions.sort tbv.gen10 > sol_tv.gen10_set3
join -1 1 -2 1 solutions.gen10_set3 tbv.gen10 > val.set3.gen10

cd ..
#module to load R
module load r/4.2.2
R #enter into R

#1.Correlation between gebv

#Note- change the directory from where you can pull your files needed

set1<-read.table('/gpfs/sharedfs1/zilla-lab/simulation_test/simulation_zilla/gen_1to3_train/val.set1.gen10')
set3<-read.table('/gpfs/sharedfs1/zilla-lab/simulation_test/simulation_zilla/gen_4to6_train/val.set2.gen10')
set2<-read.table('/gpfs/sharedfs1/zilla-lab/simulation_test/simulation_zilla/gen_7to9_train/val.set3.gen10')


cor(set1) #
cor(set2) #
cor(set3) #

cor(set1[,2],set2[,2]) # 0.81
cor(set1[,2],set3[,2]) # 0.83
cor(set2[,2],set3[,2]) # 0.40

#2. Correlation between snp effects
set1_s<-read.table('/gpfs/sharedfs1/zilla-lab/simulation_test/simulation_zilla/gen_1to3_train/snp_sol',header=T)
set2_s<-read.table('/gpfs/sharedfs1/zilla-lab/simulation_test/simulation_zilla/gen_4to6_train/snp_sol',header=T)
set3_s<-read.table('/gpfs/sharedfs1/zilla-lab/simulation_test/simulation_zilla/gen_7to9_train/snp_sol',header=T)

cor(set1_s[,6],set2_s[,6]) # 0.094
cor(set1_s[,6],set3_s[,6]) #    0.050
cor(set2_s[,6],set3_s[,6]) #  0.11

#3.Accuracy(Correlation between GEBV and TBV)

set1_g<-read.table('/gpfs/sharedfs1/zilla-lab/simulation_test/simulation_zilla/gen_1to3_train/val.set1.gen10')
set2_g<-read.table('/gpfs/sharedfs1/zilla-lab/simulation_test/simulation_zilla/gen_4to6_train/val.set2.gen10')
set3_g<-read.table('/gpfs/sharedfs1/zilla-lab/simulation_test/simulation_zilla/gen_7to9_train/val.set3.gen10')

set1_t<-read.table('/gpfs/sharedfs1/zilla-lab/simulation_test/simulation_zilla/gen_1to3_train/sol_tv.gen10_set1')
set2_t<-read.table('/gpfs/sharedfs1/zilla-lab/simulation_test/simulation_zilla/gen_4to6_train/sol_tv.gen10_set2')
set3_t<-read.table('/gpfs/sharedfs1/zilla-lab/simulation_test/simulation_zilla/gen_7to9_train/sol_tv.gen10_set3')

cor(set1_g[,2],set1_t[,3]) #0.20
cor(set2_g[,2],set2_t[,3])#0.29
cor(set3_g[,2],set3_t[,3]) #0.5

#or
cor(set1_t[,2],set1_t[,3])#0.20
cor(set2_t[,2],set2_t[,3])#0.29
cor(set3_t[,2],set3_t[,3]) #0.50



