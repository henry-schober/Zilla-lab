ln -s /data/henry/henrys/phenotypes/phen_red_all .
ln -s /data/breno/ped.noupg.sort .

ln -s /data/henry/henrys/first_lac/two_trait/phenotypes_all_no_small_first_lac . 

ln -s /data/henry/henrys/first_lac/two_trait/cgs_30 . 


#This script is to use the same phen files we already created from the combined single trait analysis, we just need to change it so that they are formatted for two trait analysis




for i in {1..10}
 do

awk 'substr($2,1,2)=="93"' phen_all.clean.dat_$i | awk '{print $0,0,0,0,$9,$11,$13}' > CA_phen.clean

awk 'substr($2,1,2)!="93"' phen_all.clean.dat_$i | awk '{print $0,$9,$11,$13,0,0,0}' > NE_phen.clean

cat  CA_phen.clean NE_phen.clean > All_phen.clean_$i



#here we want to manually cp the renum_ne_milk.par to renum.red.par file and then insert the previous variances that we got
cp renum_milk.par renum.red.par
sed "s:phen_red_all: All_phen.clean_$i:g" renum.red.par > renum.r.par

echo renum.r.par | renumf90 | tee renum_milk_r.log

echo "OPTION method VCE" >>  renf90.par
echo "OPTION use yams" >> renf90.par
echo "OPTION maxrounds 30" >> renf90.par
echo "OPTION conv_crit 1d-08" >> renf90.par
echo "OPTION se_covar_function H2d_NE G_6_6_1_1/(G_6_6_1_1+G_2_2_1_1+R_1_1)" >> renf90.par
echo "OPTION se_covar_function H2d_CA G_6_6_2_2/(G_6_6_2_2+G_2_2_2_2+R_2_2)" >> renf90.par
echo "OPTION se_covar_function rg12 G_6_6_1_2/(G_6_6_1_1*G_6_6_2_2)**0.5" >> renf90.par
#awk ' $1!=0' renf90.dat > renf90.temp

ulimit -s unlimited
export OMP_STACKSIZE=128M

echo renf90.par  | blupf90+ | tee aireml_all.log


cp  aireml_all.log aireml_log_$i


done