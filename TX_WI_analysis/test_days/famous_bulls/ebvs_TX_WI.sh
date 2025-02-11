#his script is to be run in order to combine the solutions files with the xref files

#select ebvs

#solutions file header
#trait effect level solution

awk '$2==6' solutions | awk '{print $3,$4}' | sort +0 -1 > ids_ebvs #print renumbered ID's of cows with the EBVS

awk '{print $1,$10}' renadd04.ped | sort +0 -1 > xref.sort #get the renumbered and original IDs

join -1 1 -2 1 xref.sort ebvs_all_renum  | awk '{print $2,$3}' | sort +0 -1 > ebvs_origid #$1 is bull id (original), column 2 is ebv


awk '$8>40' renadd06.ped | awk '{print $10}' | sort +0 -1 > famous.bulls.CA_milk

join -1 1 -2 1 famous.bulls.CA_milk ebvs_CA_milk > ebvs_CA_milk_famous
