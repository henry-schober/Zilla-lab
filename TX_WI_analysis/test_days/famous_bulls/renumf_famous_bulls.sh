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
        
        #here we wanna join the bulls_xref (file containing bull id in renadd format that have more than 100 daughters and then join it by column $2 in renadd as that is the father column) 

        sed 's:renadd04.ped:daughter_renadd04.ped:g' renf90.par > renf90_famous.par
        #for aireml
        echo "OPTION method VCE" >>  renf90_famous.par
        echo "OPTION use yams" >> renf90_famous.par
        echo "OPTION se_covar_function H2d_${x} G_4_4_1_1/(G_4_4_1_1+G_5_5_1_1+R_1_1)" >> renf90_famous.par


        ulimit -s unlimited
        export OMP_STACKSIZE=128M

        echo renf90_famous.par  | blupf90+ | tee aireml_testday_${x}.log

        cp aireml_testday_${x}.log aireml_log

        cd ../..

done

