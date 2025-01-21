# This script to make the cgs file and phenotype file we are going to use for the first analysis of the test day data


ln -s /data/henry/henrys/test_days/5_rec_firstlac_td.txt .
ln -s /data/henry/henrys/pedigrees/ped_TX/new_ped_TX .



ulimit -s unlimited
export OMP_STACKSIZE=1G

INBREEDING
-no inbreeding

echo renum_td.par | renumf90 | tee renum_TX.log

#removing small CG
grep  "Effect group 1" renf90.tables | awk '{print $8}' > number_cg
 #8th field (no.of level~no.of cg) followeed by spaces; levels ; renf90.tables (3 columns; effect1(mgm),no. of animals in cg, levels)

read -d $'\x04' var_cg  < number_cg #183069
 #creating a variable

grep "Effect group 1" renf90.tables -A $var_cg | awk 'NR>2' > cgs
#mgm grp, no.of animals, #Col 3 - the renumbered cg code)

awk '$2>4' cgs > cgs_4
 #the renumbered cg code. Blupf90 uses this in the model, and your solution file will contain that value.

awk '{print $3}' cgs_4 | sort > cg4.sort #92000cgs #3rd column has renum cgs ids,so cg4.sort has 1 column of ids
#the third column contains the id of the cg, so you will use that value to match the renumbered values on your renf90.dat file

sort +1 -2 renf90.dat > renf90.sort  #8th column is mgm
#If the third column contains the id of herd by sire, and the second is the cg, you should be sorting by cg, which is column 2 in this case. It must always match your file.

join -1 1 -2 2 cg4.sort renf90.sort > renf90.temp  #matches cg with phen, we can filter out small cgs

awk '$10 == 74' renf90.temp | wc -l
 #Count for Texas ; 235799

awk '$10 == 74 {print $1}' renf90.temp | sort | uniq -c > cg_tx_distribution.txt
 #CG distribution for texas
