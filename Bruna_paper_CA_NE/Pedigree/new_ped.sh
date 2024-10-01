#######################
########    script ####
#######################

#this script will create a new pedigree file for both CA and NE data with less animals
ln -s /data/breno/ped.noupg .

state=$( at "CA_NE.txt")
for x in $state
    do
        mkdir ped_${x}
        cd ped_${x}

        ulimit -s unlimited
        export OMP_STACKSIZE=1G

        INBREEDING
        -no inbreeding

        ln -s ../ped.noupg .

        ln -s ../Phenotype/phen_red_${x}

        #this par file is different than the other as it had ped.noupg as its pedigree file
        echo renum_${x}_ped.par | renumf90 | tee renum_${x}_large.log

        awk '{print $10}' renadd06.ped | sort > ids.reduced.sort
        join -1 1 -2 1 ids.reduced.sort /data/breno/ped.noupg.sort > new_ped_${x}

        cd ../
    done
#the file on data/breno ped.noupg.sort is available to you


#how many phenotypes?
wc -l phen_red_CA
# 1178770 phen_red_ca
wc -l phen_red_NE
#how many pedigrees before renum?
wc -l /data/breno/ped.noupg
#82223611 ../ped.noupg