#This script is to run the analysis that we have with the current phen files. run once to get the renadd06.ped ped file so we can get a new ped file

state=$(cat "TX_WI.txt")
for x in $state
    do
        cd ./${x}

        ln -s /data/breno/ped.noupg
        
        ulimit -s unlimited
        export OMP_STACKSIZE=1G

        echo renum_td.par | renumf90 | tee renum_testdaymilk_${x}.log


        #for aireml
        echo "OPTION method VCE" >>  renf90.par
        echo "OPTION use yams" >> renf90.par
        echo "OPTION maxrounds 50" >> renf90.par
        echo "OPTION se_covar_function H2d_${x} G_4_4_1_1/(G_4_4_1_1+G_5_5_1_1+R_1_1)" >> renf90.par


        ulimit -s unlimited
        export OMP_STACKSIZE=128M

        echo renf90.par  | blupf90+ | tee aireml_testday_${x}.log

        cp aireml_testday_${x}.log aireml_log

        cd ..

done

