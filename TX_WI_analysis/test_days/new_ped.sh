#This file is to get the new ped file

#how many phenotypes?
wc -l /data/henry/henrys/test_days/TX/phen_TX
# we get 145478 records for TX
#how many pedigrees before renum?
wc -l /data/breno/ped.noupg
#82223611 



state=$(cat "TX_WI.txt")
for x in $state
    do
        cd ./${x}

        ln -s /data/breno/ped.noupg .
        ln -s /data/breno/ped.noupg.sort .

        ulimit -s unlimited
        export OMP_STACKSIZE=1G

        echo renum_td.par | renumf90 | tee renum_testdaymilk_${x}.log

        awk '{print $10}' renadd04.ped | sort > ids.reduced.sort
        join -1 1 -2 1 ids.reduced.sort /data/breno/ped.noupg.sort > new_ped_${x}

        cd ..
done