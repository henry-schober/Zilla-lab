#This script is very similar to the original renumf.sh script, however it is modified so that it now runs blupf90+ on daughters of famous bulls (100+ daughters) only

state=$(cat "TX_WI.txt")
for x in $state
    do
        if [ ! -d "./${x}/famous_daughters" ] 
            then mkdir -p "./${x}/famous_daughters"
        fi

        cd ./${x}/famous_daughters
        
        ulimit -s unlimited
        export OMP_STACKSIZE=1G

        cp ../renum_${x}.par .
        ln -s ../phen_${x} . 
        ln -s ../new_ped_${x} .  

        echo renum_${x}.par | renumf90 | tee renum_testdaymilk_${x}.log

        awk '$8>100' renadd04.ped | awk '{print $1}' | sort > bulls_xref

        sort +1 -2 renadd04.ped > sorted_renadd    
        join -1 1 -2 2 bulls_xref sorted_renadd > daughter_renadd04.ped

        #the next step is to use the daughter ids from the file above and select their records:
        awk '{print $10}' daughter_renadd04.ped | sort +0 -1 > famous_daughters_id #single column with the daughter original ids

        #you can sort your original data file by the animal id column, and join with the id of the cows 
        sort +11 -12 phen_${x} > sorted_phen_${x} #where column is the column with animal ids (12 If I remember it right)

        join -1 1 -2 12 famous_daughters_id sorted_phen_${x} > famous_daughters.phen_temp
        #your new joint file will have different columns, since column 1 will be the id
        awk '{print $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $1}' famous_daughters.phen_temp > famous_daughters.phen

        sed 's:phen_TX:famous_daughters.phen:g' renum_${x}.par > renum_2_${x}.par

        echo renum_2_${x}.par | renumf90 | tee renum_testdaymilk_2_${x}.log

        #for aireml
        echo "OPTION method VCE" >>  renf90.par
        echo "OPTION use yams" >> renf90.par
        echo "OPTION se_covar_function H2d_${x} G_4_4_1_1/(G_4_4_1_1+G_5_5_1_1+R_1_1)" >> renf90.par


        ulimit -s unlimited
        export OMP_STACKSIZE=128M

        echo renf90.par  | blupf90+ | tee aireml_testday_${x}.log

        cp aireml_testday_${x}.log aireml_log

        cd ../..

done

