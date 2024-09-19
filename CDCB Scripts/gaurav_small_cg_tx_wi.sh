

echo renum_ne_milk.par | renumf90 | tee renum_ne.log

#removing small CG


grep  "Effect group 1" renf90.tables | awk '{print $8}' > number_cg


read -d $'\x04' var_cg  < number_cg

grep "Effect group 1" renf90.tables -A $var_cg | awk 'NR>2' > cgs

awk '$2>4' cgs > cgs_4

awk '{print $3}' cgs_4 | sort > cg4.sort #

sort +1 -2 renf90.dat > renf90.sort

join -1 1 -2 2 cg4.sort renf90.sort > renf90.temp
