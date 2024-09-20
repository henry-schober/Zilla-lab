#this script will run analysis for milk in California only - first location only
# copy the data file for first lactation equivalent to phenotypes_ca_no_small
# before running: create a new parameter file with all 3 variance components updated and the correct column. Let'say it will be called renum_ca_milk.par


ln -s /data/henry/henrys/phenotypes/phen_red_all .
ln -s /data/breno/ped.noupg.sort .

ln -s /data/henry/henrys/first_lac/two_trait/phenotypes_all_no_small_first_lac . 

ln -s /data/henry/henrys/first_lac/two_trait/cgs_30 . 

###################################
#### SSD ne 50k script  ###########
###################################

#Run after you ran the beginning of the only large 30 file and replace all of the phen to phen no small

for i in {1..10}
 do

cp cgs_30 cgs_30_new   #restart the cgs_8 file
rm temp_cg1 temp_cg2 reduced_cg #remove temporary files
touch reduced_cg #start the cg file


nanim_var=0
while [ $nanim_var -le 50000 ]
do

  wc -l cgs_30_new | awk '{print $1}'  > number_cg30         #the number of cgs in the file
  read -d $'\x04' var_cg30  < number_cg30                    #create a variable with that number

#  var_cg30=$((var_cg30+1))
  var_random=$((RANDOM%$var_cg30+1)) #sample a random number from 1 to cg number
  awk -v var_random="$var_random" 'NR==var_random' cgs_30_new > temp_cg1 #select the column matching the random number
  cat temp_cg1 reduced_cg > temp_cg2 #create a temporary file concatenating the cg info
  mv temp_cg2 reduced_cg #rename it
  awk -F' ' '{sum+=$2;} END{print sum;}' reduced_cg > nanim #sum the number of animals in all cgs
  read -d $'\x04' nanim_var  < nanim #create a variable



  #now we will remove the matched column, to avoid repeated cgs

  awk -v var_random="$var_random" 'NR!=var_random' cgs_30_new > temp #select the column matching the random number
  cp temp cgs_30_new

  #  echo "Number of animals is $nanim_var "
  #  nanim_var=$(( $nanim_var + 1 ))
done


 awk '{print $1}'  reduced_cg | sort | uniq -c | awk '$1>1'


sort +1 -2 phenotypes_all_no_small_first_lac > phen_red_all.sort  #sort the original file
awk ' {print $1}' reduced_cg | sort > red.cgs.sort  #vector of cgs -> original

join -1 1 -2 2 red.cgs.sort phen_red_all.sort  > phen_rd_all.sort # joining sorted data and cgs.red

awk '{print $2,$1,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$20,$21,$22,$23,$24}' phen_rd_all.sort  > phen_all.clean.dat #rearranging data file

#here we want to manually cp the renum_ne_milk.par to renum.red.par file and then insert the previous variances that we got
cp renum_milk.par renum.red.par
sed 's:phen_red_all: phen_all.clean.dat:g' renum.red.par > renum.r.par

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


cp  aireml_all.log aireml_log_$i


done