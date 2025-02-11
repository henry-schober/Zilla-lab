#his script is to be run in order to combine the solutions files with the xref files

#select ebvs

#solutions file header
#trait effect level solution

awk '$2==4' solutions | awk '{print $3,$4}' | sort +0 -1 > ids_ebvs #print renumbered ID's of cows with the EBVS

awk '{print $1,$10}' renadd04.ped | sort +0 -1 > xref.sort #get the renumbered and original IDs

join -1 1 -2 1 xref.sort ids_ebvs  | awk '{print $2,$3}' | sort +0 -1 > ebvs_origid #$1 is bull id (original), column 2 is ebv


awk '$8>100' renadd04.ped | awk '{print $10}' | sort +0 -1 > famous_bulls_WI

join -1 1 -2 1 famous_bulls_WI ebvs_origid > ebvs_WI_famous

#156 in TX
#296 in WI


#for getting the combined file

#sort +0 -1 WI/ebvs_WI_famous > WI/sorted_WI_ebvs
#sort +0 -1 TX/ebvs_TX_famous > TX/sorted_TX_ebvs
#join -1 1 -2 1 TX/sorted_TX_ebvs WI/sorted_WI_ebvs > TX_WI_ebvs #47 bulls in both states


