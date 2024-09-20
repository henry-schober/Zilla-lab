
#This script runs the renumf and blup analysis for the daughters of famous bulls (bulls with 30 + daughters in CA and NE)

# ln -s /data/henry/henrys/phenotypes/phen_red_all .
ln -s /data/breno/ped.noupg.sort .

ln -s /data/henry/henrys/first_lac/bulls30/phenotypes_bull30_first_lac .

ln -s /data/henry/henrys/first_lac/bulls30/cgs_30 .

###################################
#### SSD ne 50k script  ###########
###################################

ln -s /data/henry/henrys/first_lac/two_trait/milk/renum_milk.par

#here we want to manually cp the renum_ne_milk.par to renum.red.par file and then insert the previous variances that we got

cp renum_milk.par renum.red.par
sed 's:phen_red_all: phenotypes_bull30_first_lac:g' renum.red.par > renum.r.par

echo renum.r.par | renumf90 | tee renum_milk_r.log

echo "OPTION method VCE" >>  renf90.par
echo "OPTION use yams" >> renf90.par
echo "OPTION maxrounds 50" >> renf90.par
echo "OPTION se_covar_function H2d_NE G_6_6_1_1/(G_6_6_1_1+G_2_2_1_1+R_1_1)" >> renf90.par
echo "OPTION se_covar_function H2d_CA G_6_6_2_2/(G_6_6_2_2+G_2_2_2_2+R_2_2)" >> renf90.par
echo "OPTION se_covar_function rg12 G_6_6_1_2/(G_6_6_1_1*G_6_6_2_2)**0.5" >> renf90.par
#awk ' $1!=0' renf90.dat > renf90.temp

ulimit -s unlimited
export OMP_STACKSIZE=128M

echo renf90.par  | blupf90+ | tee aireml_all.log


cp  aireml_all.log aireml_log_1
