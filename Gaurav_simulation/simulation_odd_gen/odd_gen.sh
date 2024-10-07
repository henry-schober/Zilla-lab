#!/bin/bash


#SBATCH --account=bdo18001
#SBATCH --partition=priority
#SBATCH --qos=bdo18001big
#SBATCH --constraint='epyc128'
#SBATCH --ntasks=24
#SBATCH --time=32:00:00
#SBATCH --mem=128GB
#SBATCH --mail-type=ALL
#SBATCH --mail-user=henry.schober@uconn.edu
#SBATCH -o script_simulation.sh_%j.out
#SBATCH -e script_simulation.sh_%j.err

ulimit -s unlimited
export OMP_STACKSIZE=128M

#1.run renumf90
#you must have renum.par in your directory
echo renum.par | renumf90 | tee renum.log #running renumf90  

#2. Removing phenotypes from young animals(gen 10)

awk '$6!=10' renf90.dat > renf90.train  #creating a training population for first 9 gen, 10th generation is on column 6
awk '$6==10' renf90.dat | awk '{print $3}' | sort > ids.gen10 # saving animal ids for gen 10

#part2;Estimation of gebv, snp effects with variance

awk '$6==10' renf90.dat | awk ' {print $3,$5}' | sort  +0 -1 > tbv.gen10 #save ids and TBV for generation 10

#Training population - odd generations

mkdir oddgen_train
cd oddgen_train

cp ../renf90.train renf90.dat_temp #copying the training data set and saving it as renf90.dat_temp
ln -s ../genotypes.snp .  # softlink for the genotypes file
ln -s ../genotypes.snp_XrefID .  
cp ../renadd02.ped .       # softlink for the pedigree file
cp ../renf90.par .   
cp ../ids.gen10 .
cp ../tbv.gen10 .
cp ../gen_map.txt .

awk '$6==1 || $6==3 || $6==5 || $6==7' renf90.dat_temp > renf90.dat

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

echo pre.par | blupf90 | tee ssgblup_all_pre.log #run pregs
echo post.par | postGSf90 | tee ssgblup_all_post.log #run postgs

awk '$2==2' solutions | awk ' {print $3, $4}' | sort +0 -1 > solutions.sort #save ebvs for generation 10
join -1 1 -2 1 solutions.sort ids.gen10 > solutions.gen10_oddgen #gebv

join -1 1 -2 1 solutions.sort tbv.gen10 > sol_tv.gen10_oddgen  #tbv

join -1 1 -2 1 solutions.gen10_oddgen tbv.gen10 > val.oddgen.gen10 #to validate


cd ..


#module to load R
module load gcc/11.3.0
module load r/4.2.2
R #enter into R

#1.Correlation between gebv

#Note- change the directory from where you can pull your files needed

all<-read.table('/gpfs/sharedfs1/zilla-lab/simulation_test/simulation_zilla/all_train/val.all.gen10')
even<-read.table('/gpfs/sharedfs1/zilla-lab/simulation_test/simulation_zilla/even_train/val.even.gen10')
odd<-read.table('/gpfs/sharedfs1/zilla-lab/simulation_test/simulation_zilla/odd_train/val.odd.gen10')
odd_gen<-read.table('/gpfs/sharedfs1/zilla-lab/simulation_hank/simulation_odd_gen/oddgen_train')


cor(all) #
cor(even) #
cor(odd) #
cor(odd_gen)

cor(all[,2],even[,2]) # 0.81
cor(all[,2],odd[,2]) # 0.83
cor(odd[,2],even[,2]) # 0.40
cor(all[,2],odd_gen[,2]) 
cor(odd_gen[,2],odd[,2]) #
cor(odd_gen[,2],even[,2]) # 


#2. Correlation between snp effects
all<-read.table('/gpfs/sharedfs1/zilla-lab/simulation_test/simulation_zilla/snp_sol',header=T)
even<-read.table('/gpfs/sharedfs1/zilla-lab/simulation_test/simulation_zilla/snp_sol',header=T)
odd<-read.table('/gpfs/sharedfs1/zilla-lab/simulation_test/simulation_zilla/odd_train/snp_sol',header=T)

odd_gen<-read.table('/gpfs/sharedfs1/zilla-lab/simulation_hank/simulation_odd_gen/oddgen_train/snp_sol',header=T)

cor(all[,6],even[,6]) # 0.753
cor(all[,6],odd[,6]) #    0.756
cor(odd[,6],even[,6]) #  0.205
cor(all[,6],odd_gen[,6]) #
cor(odd_gen[,6],odd[,6]) #    
cor(odd_gen[,6],even[,6]) #  

#3.Accuracy(Correlation between GEBV and TBV)

all_g<-read.table('/gpfs/sharedfs1/zilla-lab/simulation_test/simulation_zilla/all_train/val.all.gen10')
even_g<-read.table('/gpfs/sharedfs1/zilla-lab/simulation_test/simulation_zilla/even_train/val.even.gen10')
odd_g<-read.table('/gpfs/sharedfs1/zilla-lab/simulation_test/simulation_zilla/odd_train/val.odd.gen10')
odd_gen_t<-read.table('/gpfs/sharedfs1/zilla-lab/simulation_hank/simulation_odd_gen/oddgen_train/val.oddgen.gen10')

all_t<-read.table('/gpfs/sharedfs1/zilla-lab/simulation_test/simulation_zilla/all_train/sol_tv.gen10_all')
even_t<-read.table('/gpfs/sharedfs1/zilla-lab/simulation_test/simulation_zilla/even_train/sol_tv.gen10_even')
odd_t<-read.table('/gpfs/sharedfs1/zilla-lab/simulation_test/simulation_zilla/odd_train/sol_tv.gen10_odd')
odd_gen_t<-read.table('/gpfs/sharedfs1/zilla-lab/simulation_hank/simulation_odd_gen/oddgen_train/sol_tv.gen10_oddgen')



cor(all_g[,2],all_t[,3]) #0.54
cor(even_g[,2],even_t[,3])#0.46
cor(odd_g[,2],odd_t[,3]) #0.45
cor(odd_gen_g[,2],odd_gen_t[,3])


#or
#cor(all_t[,2],all_t[,3])#0.54
#cor(even_t[,2],even_t[,3])#0.46
#cor(odd_t[,2],odd_t[,3]) #0.45
  
  