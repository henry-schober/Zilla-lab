#select ebvs

awk ' $2==6' solutions | awk '{print $3,$4}' | sort +0 -1 > ebvs_all_renum

awk '{print $1,$10}' renadd06.ped | sort +0 -1 > xref.sort

join -1 1 -2 1 xref.sort ebvs_all_renum  | awk '{print $2,$3}' | sort +0 -1 > ebvs_ca_protein #$1 is bull id (original), column 2 is ebv


awk '$8>40' renadd06.ped | awk '{print $10}' sort +0 -1 > famous.bulls.ca_protein

join -1 1 -2 1 famous.bulls.ca_protein ebvs_ca_protein > ebvs_ca_protein_famous 

#join -1 1 -2 1 ebvs_ca_protein_famous ebvs_ne_protein_famous > ebs_protein_famous


#then, we calculate the correlation between each state using only ebvs of the famous bulls
#include in your results for each state number of bulls and correlation

#repeat for all 3 traits and two states. 


