#his script is to be run in order to combine the solutions files with the xref files

#select ebvs

#solutions file header
#trait effect level solution
state=$(cat "TX_WI.txt")
for x in $state
    do
        cd ${x}

        awk '$2==4' solutions | awk '{print $3,$4}' | sort +0 -1 > ids_ebvs #print renumbered ID's of cows with the EBVS

        awk '$8>80' renadd04.ped | awk '{print $1,$10}'| sort +0 -1 > xref.sort #get the renumbered and original IDs of bulls with 80 daughters

        join -1 1 -2 1 xref.sort ids_ebvs  | awk '{print $2,$3}' | sort +0 -1 > famous_ebv_${x} #$1 is bull id (original), column 2 is ebv

        cp famous_ebv_${x} ../famous_bulls/.

        cd ..
    done

cd famous_bulls

join -1 1 -2 1 famous_ebv_WI famous_ebv_TX > famous_ebvs_all #$2 is WI, $3 is TX

#156 in TX
#296 in WI


#for getting the combined file

#sort +0 -1 WI/ebvs_WI_famous > WI/sorted_WI_ebvs
#sort +0 -1 TX/ebvs_TX_famous > TX/sorted_TX_ebvs
#join -1 1 -2 1 TX/sorted_TX_ebvs WI/sorted_WI_ebvs > TX_WI_ebvs #47 bulls in both states


