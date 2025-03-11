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

        #making the phen file which will have dim by season where dim is currently
        awk '{print $10}' phen_${x} | cut -c 5,6 > month_num

        awk '{
            if ($1 == 12 || $1 == 1 || $1 == 2) {
                $2 = 1
            } else if ($1 == 3 || $1 == 4 || $1 == 5) {
                $2 = 2
            } else if ($1 == 6 || $1 == 7 || $1 == 8) {
                $2 = 3
            } else if ($1 == 9 || $1 == 10 || $1 == 11) {
                $2 = 4
            }
            print $0 
        }' month_num > season_num_temp

        awk '{print $2}' season_num_temp > season_num
        paste -d " " phen_${x} season_num > phen_${x}_temp
        awk '{print $0, $7$13}' phen_${x}_temp > phen_${x}_temp2
        awk '{print $1, $2, $3, $4, $5, $6, $14, $8, $9, $10, $11, $12}' phen_${x}_temp2 > phen_${x}_season

        sed "s:phen_${x}:phen_${x}_season:g" renum_td.par > renum_${x}_season.par

        echo renum_${x}_season.par | renumf90 | tee renum_dim_season.log

        awk '{print $10}' renadd04.ped | sort > ids.reduced.sort
        join -1 1 -2 1 ids.reduced.sort /data/breno/ped.noupg.sort > new_ped_${x}

        sed "s:ped.noupg:new_ped_${x}:g" renum_${x}_season.par > renum_${x}_s.par

        echo renum_${x}_season.par | renumf90 | tee renum_dim_season_red.log

        echo "OPTION method VCE" >>  renf90.par
        echo "OPTION use yams" >> renf90.par
        echo "OPTION se_covar_function H2d_${x} G_4_4_1_1/(G_4_4_1_1+G_5_5_1_1+R_1_1)" >> renf90.par


        ulimit -s unlimited
        export OMP_STACKSIZE=128M

        echo renf90.par  | blupf90+ | tee aireml_testday_${x}.log

        cp aireml_testday_${x}.log aireml_log

        cd ../..
done

