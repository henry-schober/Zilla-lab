#script to get famous daughters ebvs



if [ ! -d "./2trait_ebvs" ] 
    then mkdir -p "./2trait_ebvs"
fi

cd ./two_trait/

awk '$1==1' solutions > WI_solutions

awk '$1==2' solutions > TX_solutions

for x in WI_solutions TX_solutions
    do
        prefix=$(echo "$x" | cut -d "_" -f 1 )
        awk '$2==4' ${x} | awk '{print $3,$4}' | sort +0 -1 > ids_ebvs_${prefix} #print renumbered ID's of cows with the EBVS

        awk '$8>80' renadd04.ped | awk '{print $1,$10}'| sort +0 -1 > xref.sort #get the renumbered and original IDs

        join -1 1 -2 1 xref.sort ids_ebvs_${prefix}  | awk '{print $2,$3}' | sort +0 -1 > famous_ebv_${prefix} #$1 is bull id (original), column 2 is ebv

        cp famous_ebv_${prefix} ../2trait_ebvs/.
    done

cd ../2trait_ebvs

join -1 1 -2 1 famous_ebv_WI famous_ebv_TX > famous_ebvs_all #$2 is WI, $3 is TX
