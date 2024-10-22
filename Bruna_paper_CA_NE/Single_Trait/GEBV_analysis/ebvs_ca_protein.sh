#select ebvs

#solutions file header
#trait effect level solution

awk '$2==6' solutions | awk '{print $3,$4}' | sort +0 -1 > ebvs_all_renum #print renumbered ID's with the EBVS

awk '{print $1,$10}' renadd06.ped | sort +0 -1 > xref.sort #get the renumbered and original IDs

join -1 1 -2 1 xref.sort ebvs_all_renum  | awk '{print $2,$3}' | sort +0 -1 > ebvs_CA_protein #$1 is bull id (original), column 2 is ebv


awk '$8>40' renadd06.ped | awk '{print $10}' | sort +0 -1 > famous.bulls.CA_protein

join -1 1 -2 1 famous.bulls.CA_protein ebvs_CA_protein > ebvs_CA_protein_famous 


#In a separate directory, copy all of the famous ebv files over to easily join them using the following commmand

#join -1 1 -2 1 ebvs_CA_protein_famous ebvs_NE_protein_famous > ebvs_protein_famous #column 1 is orig ID, column 2 is CA, column 3 is NE

#join -1 1 -2 1 ebvs_CA_milk_famous ebvs_NE_milk_famous > ebvs_milk_famous

#join -1 1 -2 1 ebvs_CA_fat_famous ebvs_NE_fat_famous > ebvs_fat_famous

#then, we calculate the correlation between each state using only ebvs of the famous bulls
#include in your results for each state number of bulls and correlation

#repeat for all 3 traits and two states. 


