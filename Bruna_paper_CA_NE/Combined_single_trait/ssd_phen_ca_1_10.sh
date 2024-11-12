#This script is going to create 10 phen.clean files for ne and ca, depending on which version of the script you run
#Now we can change the components and run this script
ln -s /data/henry/henrys/first_lac/california/phenotypes_ca_no_small_first_lac .
ln -s /data/henry/henrys/pedigrees/ped_ca/new_ped_ca .
ln -s /data/henry/henrys/first_lac/california/cgs_30 .

for i in {1..10}
 do

cp cgs_30 cgs_30_new   #restart the cgs_30 file
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


sort +1 -2 phenotypes_ca_no_small_first_lac > phen_red_ca.sort  #sort the original file
awk ' {print $1}' reduced_cg | sort > red.cgs.sort  #vector of cgs -> original

join -1 1 -2 2 red.cgs.sort phen_red_ca.sort  > phen_rd_ca.sort # joining sorted data and cgs.red

awk '{print $2,$1,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18}' phen_rd_ca.sort  > phen_ca.clean.dat #rearranging data file

mv phen_ca.clean.dat phen_ca.clean.dat_$i

done
