cd /data/breno/test_first_lactation

awk 'NR>4' ../yld_phenotypes.txt | awk '{print $1,$2,$3,$4,$5,$6}' > first_columns #create a file with id, mgm group, herd by sire, age parity, yob, and parity

awk '{print $1,$2,$3,$4,$5,$6,substr($2,1,2)}' first_columns > state_all #first two bytes are the state #add state in column 7

awk '$7==93' state_all > all_ca #select california state=93

awk '$7<17 && $7!=10' state_all > all_ne #select new england: state from 11 to 16 and removes 10



awk '$5>2000' all_ca > phen_red_ca #only animals born after 2000 
awk '$5>2000' all_ne > phen_red_ne #same as above


awk '$6==1' phen_red_ne > ne_1st #only first lactation
awk '$6==1' phen_red_ca > ca_1st #only first lactation 


#wc -l ne_1st
#448290 ne_1st #number of cows seem to match yours
# wc -l ca_1st
#4552114 ca_1st #number of cows in CA seems to match your 


awk '{print $1}' ne_1st | sort | uniq -c | awk '$1>1' #no duplications
awk '{print $1}' ca_1st | sort | uniq -c | awk '$1>1' #no duplications
