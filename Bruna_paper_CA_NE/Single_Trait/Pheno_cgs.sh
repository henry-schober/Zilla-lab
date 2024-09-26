#this script will run analysis for milk in new_england only - first location only
# copy the data file for first lactation equivalent to phenotypes_ca_no_small
# before running: create a new parameter file with all 3 variance components updated and the correct column. Let'say it will be called renum_ca_milk.par


ln -s /data/henry/henrys/phenotypes/phen_red_ne .
ln -s /data/henry/henrys/pedigrees/ped_ne/new_ped_ne .



ulimit -s unlimited
export OMP_STACKSIZE=1G

INBREEDING
-no inbreeding

echo renum_ne_milk.par | renumf90 | tee renum_ne.log

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

join ids.red.ne phen_ne.sort > phenotypes_ne_no_small_first_lac
