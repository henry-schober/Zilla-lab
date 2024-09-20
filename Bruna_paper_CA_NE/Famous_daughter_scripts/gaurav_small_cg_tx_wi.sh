#This script is to give us the the new cgs file
#First run the bulls30_breno.bash script

cat famous_daughter_WI.phen famous_daughter_TX.phen > famous_daughter_phen_all #creating a single file for famous daughters


#Check to make sure the renum par file is updated to correct data file and pheno file, no need to recalculate variances

ln -s /data/henry/henrys/first_lac/two_trait/milk/renum_milk.par .
sed 's:phen_red_all:famous_daughter_phen_all:g' renum_milk.par > renum_milk.temp  #convert ne to ca
mv renum_milk.tmp renum_milk.par
echo renum_milk.par | renumf90 | tee renum_milk_bull30.log



#removing small CG


grep  "Effect group 1" renf90.tables | awk '{print $8}' > number_cg


read -d $'\x04' var_cg  < number_cg

grep "Effect group 1" renf90.tables -A $var_cg | awk 'NR>2' > cgs

awk '$2>4' cgs > cgs_4

awk '{print $3}' cgs_4 | sort > cg4.sort #419866 cgs

sort +2 -3 renf90.dat > renf90.sort

join -1 1 -2 3 cg4.sort renf90.sort > renf90.temp
