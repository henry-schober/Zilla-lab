ln -s /data/henry/henrys/phenotypes/phen_red_ne .
ln -s /data/henry/henrys/pedigrees/ped_ne/new_ped_ne .
cp /data/henry/henrys/new_england/renum_ne.par renum_ne.par_temp
#sed 's:9:#######:g' renum_ne.par_temp > renum_ne.par #change # to whatever number to whatever effect you want

ulimit -s unlimited
export OMP_STACKSIZE=1G

INBREEDING
-no inbreeding

echo renum_ne.par | renumf90 | tee renum_ne.log

#This is a test to see the duplication#

echo "OPTION method VCE" >>  renf90.par
echo "OPTIONS use yams" >> renf90.par
 awk ' $1!=0' renf90.dat > renf90.temp


#removing small CG


grep  "Effect group 1" renf90.tables | awk '{print $8}' > number_cg


read -d $'\x04' var_cg  < number_cg

grep "Effect group 1" renf90.tables -A $var_cg | awk 'NR>2' > cgs

awk '$2>29' cgs > cgs_30

awk '{print $3}' cgs_30 | sort > cg30.sort #7758 cgs

sort +1 -2 renf90.dat > renf90.sort

join -1 1 -2 2 cg30.sort renf90.sort > renf90.temp


awk '{print $2,$1,$3,$4,$5,$6,$7,$8,$9}' renf90.temp > renf90.clean.dat

##################################
#remove small herd by sire groups#
##################################

awk '{print $3}' renf90.clean.dat | sort | uniq -c > hxs
awk '$1>3' hxs | awk ' {print $2}' | sort > hxs_4 #22k

sort +2 -3 renf90.temp > renf90.temp.sort
join -1 1 -2 3 hxs_4  renf90.temp.sort >  renf90.temp2



awk '{print $1}' renf90.temp2 | sort | uniq -c | awk ' $1<4' #no small hxs :)
awk '{print $2}' renf90.temp2 | sort | uniq -c | awk ' $1<4' #14 small cg





awk '{print $2}' renf90.temp2 | sort | uniq -c | awk '$1>3' | awk ' {print $2}' | sort > cg2 #7732 cgs
sort +1 -2 renf90.temp2 >  renf90.temp.sort3

join -1 1 -2 2 cg2  renf90.temp.sort3 >  renf90.temp3

awk '{print $1}' renf90.temp3 | sort | uniq -c | awk ' $1<4'
awk '{print $2}' renf90.temp3 | sort | uniq -c | awk ' $1<4' #2400

awk '{print $3,$2,$1,$4,$5,$6,$7,$8,$9}' renf90.temp3 > renf90.clean2.dat

awk ' {print $7}' renf90.clean2.dat | sort +0 -1 > ids_clean #type

uniq ids_clean | sort +0 -1 > ids_single
uniq -c ids_clean | wc -l

sort +0 -1 renadd06.ped > renadd.sort
join -1 1 -2 1 ids_single renadd.sort | awk '{print $10}' | sort +0 -1 > ids.red.ne



sort +0 -1  phen_red_ne > phen_ne.sort

join ids.red.ne phen_ne.sort > phenotypes_ne_no_small

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


sort +1 -2 phenotypes_ne_no_small > phen_red_ne.sort  #sort the original file
awk ' {print $1}' reduced_cg | sort > red.cgs.sort  #vector of cgs -> original

join -1 1 -2 2 red.cgs.sort phen_red_ne.sort  > phen_rd_ne.sort # joining sorted data and cgs.red

awk '{print $2,$1,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18}' phen_rd_ne.sort  > phen_ne.clean.dat #rearranging data file

#here we want to manually cp the renum_ne.par to renum.red.par file and then insert the previous variances that we got
sed 's:phen_red_ne: phen_ne.clean.dat:g' renum.red.par > renum.r.par

echo renum.r.par | renumf90 | tee renum_ne_r.log

echo "OPTION method VCE" >>  renf90.par
echo "OPTION use yams" >> renf90.par
echo "OPTION se_covar_function H2d G_6_6_1_1/(G_6_6_1_1+R_1_1)" >> renf90.par
#awk ' $1!=0' renf90.dat > renf90.temp


sed 's:renf90.dat:renf90.clean.dat:g' renf90.par > aireml.par
ulimit -s unlimited
export OMP_STACKSIZE=128M

echo renf90.par  | blupf90+ | tee aireml_ne.log


cp  aireml_ne.log aireml_log_$i


done
