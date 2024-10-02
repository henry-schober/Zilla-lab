echo renum_ne.par | renumf90 | tee renum_ne.log #use renum_ne.par file into renumf90 and have the output as renum_ne.log

echo "OPTION method VCE" >>  renf90.par #including new option into parameter file
echo "OPTIONS use yams" >> renf90.par #add new option for use yams
 awk ' $1!=0' renf90.dat > renf90.temp #get rid of the first line as in the first column 0 is the first entry


#removing small CG


grep  "Effect group 1" renf90.tables | awk '{print $8}' > number_cg #Get the number of cgs and put them into a new file


read -d $'\x04' var_cg  < number_cg #only select for the number of cgs greater than 4

grep "Effect group 1" renf90.tables -A $var_cg | awk 'NR>2' > cgs 

awk '$2>7' cgs > cgs_8 #this makes it so that the number of cgs has to be at least 8

awk '{print $3}' cgs_8 | sort > cg8.sort #sort out the contemporary groups

sort +1 -2 renf90.dat > renf90.sort

join -1 1 -2 2 cg8.sort renf90.sort > renf90.temp #combined the cg files and the renf90 dat file


awk '{print $2,$1,$3,$4,$5,$6,$7,$8,$9}' renf90.temp > renf90.clean.dat #clean the combined file



##################################
########## Pseudo Code ###########
##################################

#1 pick a cg
#2 do we have more than 100k?
#2.1 = yes -> stop
#2.2 = no -> pick another cg



#part #1 - pick a cg
wc -l cgs_8 | awk '{print $1}'  > number_cg8 
read -d $'\x04' var_cg8  < number_cg8


#########################################################
######### create/remove/prepare the files needed ########
#########################################################


cp cgs_8 cgs_8_new   #restart the cgs_8 file
rm temp_cg1 temp_cg2 reduced_cg #remove temporary files
touch reduced_cg #start the cg file


nanim_var=0
while [ $nanim_var -le 100000 ]
do

  wc -l cgs_8_new | awk '{print $1}'  > number_cg8         #the number of cgs in the file
  read -d $'\x04' var_cg8  < number_cg8                    #create a variable with that number

#  var_cg8=$((var_cg8+1))
  var_random=$((RANDOM%$var_cg8+1)) #sample a random number from 1 to cg number
  awk -v var_random="$var_random" 'NR==var_random' cgs_8_new > temp_cg1 #select the column matching the random number
  cat temp_cg1 reduced_cg > temp_cg2 #create a temporary file concatenating the cg info
  mv temp_cg2 reduced_cg #rename it
  awk -F' ' '{sum+=$2;} END{print sum;}' reduced_cg > nanim #sum the number of animals in all cgs
  read -d $'\x04' nanim_var  < nanim #create a variable



  #now we will remove the matched column, to avoid repeated cgs

  awk -v var_random="$var_random" 'NR!=var_random' cgs_8_new > temp #select the column matching the random number
  cp temp cgs_8_new

  #  echo "Number of animals is $nanim_var "
  #  nanim_var=$(( $nanim_var + 1 ))
done


 awk '{print $1}'  reduced_cg | sort | uniq -c | awk '$1>1'



awk ' {print $3}' reduced_cg | sort > red.cgs.sort  #vector of cgs
join -1 1 -2 2 red.cgs.sort renf90.sort > renf90.temp # joining sorted data and cgs.red
awk '{print $2,$1,$3,$4,$5,$6,$7,$8,$9}' renf90.temp > renf90.clean.dat #rearranging data file




sed 's:renf90.dat:renf90.clean.dat:g' renf90.par > aireml.par
ulimit -s unlimit
export OMP_STACKSIZE=712M

echo aireml.par  | blupf90+ | tee aireml_ne.log #perform aireml 