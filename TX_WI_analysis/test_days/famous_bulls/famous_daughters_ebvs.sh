#script to get famous daughters ebvs


#solutions file header
#trait effect level solution
state=$(cat "TX_WI.txt")
for x in $state
    do
        if [ ! -d "./famous_daughters_ebvs" ] 
            then mkdir -p "./famous_daughters_ebvs"
        fi
        
        cd ${x}/famous_daughters/

        awk '$2==4' solutions | awk '{print $3,$4}' | sort +0 -1 > ids_ebvs #print renumbered ID's of cows with the EBVS

        awk '$8>80' renadd04.ped | awk '{print $1,$10}'| sort +0 -1 > xref.sort #get the renumbered and original IDs

        join -1 1 -2 1 xref.sort ids_ebvs  | awk '{print $2,$3}' | sort +0 -1 > famous_ebv_${x} #$1 is bull id (original), column 2 is ebv

        cp famous_ebv_${x} ../../famous_daughters_ebvs/.

        cd ../..
    done

cd famous_daughters_ebvs

join -1 1 -2 1 famous_ebv_WI famous_ebv_TX > famous_ebvs_all #$2 is WI, $3 is TX
