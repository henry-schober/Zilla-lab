#This script combineds both the clean phen files of ca and ne together

for i in {1..10}
 do
cat phen_ca.clean.dat_$i phen_ne.clean.dat_$i > phen_all.clean.dat_$i
done
