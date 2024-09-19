#This script is to be used with the combined phenotype file for the milk trait
#Comment out the ped file in the par file 
ln -s /data/breno/ped.noupg.sort . #I used this here as I believe this is the ped file before it we sorted it by ca or ne

for i in {1..10}
 do

cp renum_all_milk.par renum.red.par

sed "s:phen_red_ca:phen_all.clean.dat_$i:g" renum.red.par > renum.r.par

echo renum.r.par | renumf90 | tee renum_all_r.log

echo "OPTION method VCE" >>  renf90.par
echo "OPTION use yams" >> renf90.par
echo "OPTION se_covar_function H2d G_6_6_1_1/(G_6_6_1_1+G_2_2_1_1+R_1_1)" >> renf90.par
#awk ' $1!=0' renf90.dat > renf90.temp


ulimit -s unlimited
export OMP_STACKSIZE=128M

echo renf90.par  | blupf90+ | tee aireml_all.log


cp  aireml_all.log aireml_all_log_$i


done