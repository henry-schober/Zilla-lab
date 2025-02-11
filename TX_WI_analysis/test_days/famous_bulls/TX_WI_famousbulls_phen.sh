#this script is to get the files need to run the famous bull scripts

#We already have the script of famous holstein bulls, so we are going to take the bulls that have 100+ daughters and then cross reference their sire id with the TX and WI phen files

cp /data/henry/henrys/all_sires/ho.bulls100 .
awk '{print $2}' ho.bulls100 | sort +0 -1 > famous_bulls_sorted


#bring the new_ped files into this directory first
state=$(cat "TX_WI.txt")
for x in $state
    do
        mkdir ${x}
        cd ${x}

        ln -s /data/henry/henrys/test_days/${x}/new_ped_${x} .
        sort +1 -2 new_ped_${x} > sorted_ped_${x}
        join -1 1 -2 2 famous_bulls_sorted sorted_ped_${x} > famous_${x}
        
        ulimit -s unlimited
        export OMP_STACKSIZE=128M

        ln -s /data/henry/henrys/test_days/${x}/phen_${x} .

        cp ../../renum_td.par .
        sed "s:phen_WI:phen_${x}:g" renum_td.par > renum_temp.par
        sed "s:new_ped_WI:new_ped_${x}:g" renum_temp.par > renum_td_${x}.par

        echo renum_td_${x}.par | renumf90 | tee renum_td_${x}.log

        echo "OPTION use yams" >> renf90.par

        echo renf90.par  | blupf90+ | tee aireml_${x}.log
        
        cd ..

    done

