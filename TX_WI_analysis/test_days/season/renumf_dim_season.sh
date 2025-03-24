#Script to add the DIM by season column


state=$(cat "TX_WI.txt")
for x in $state
    do
        if [ ! -d "./${x}/dim_season" ] 
            then mkdir -p "./${x}/dim_season"
        fi
        
        cd ./${x}/dim_season
        ln -s ../phen_${x} .
        ln -s /data/breno/ped.noupg .
        cp ../renum_td.par .


        ulimit -s unlimited
        export OMP_STACKSIZE=1G

        sed "s:ped.noupg:new_ped_${x}:g" renum_${x}_season.par > renum_${x}_s.par

        echo renum_${x}_s.par | renumf90 | tee renum_dim_season_red.log

        echo "OPTION method VCE" >>  renf90.par
        echo "OPTION use yams" >> renf90.par
        echo "OPTION se_covar_function H2d_${x} G_4_4_1_1/(G_4_4_1_1+G_5_5_1_1+R_1_1)" >> renf90.par


        ulimit -s unlimited
        export OMP_STACKSIZE=128M

        echo renf90.par  | blupf90+ | tee aireml_testday_${x}.log

        cp aireml_testday_${x}.log aireml_log

        cd ../..
done

