#Script to make a phen file with about 40,000 cows from CA and 40,000 from NE


awk 'substr($2,1,2)=="93"' phen_all.clean.dat_1 | awk '{print $0,0,0,0,$9,$11,$13}' > CA_phen.clean

awk 'substr($2,1,2)!="93"' phen_all.clean.dat_1 | awk '{print $0,$9,$11,$13,0,0,0}' > NE_phen.clean

cat  CA_phen.clean NE_phen.clean > All_phen.clean