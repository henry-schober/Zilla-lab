# The purpose of this script is to get the GEBV of CA and NE for each trait

#for these analysis we are using the full phen file so phenotypes no small as this also takes out small cg animals and inlcudes first lac

#Assign path to trait and state ID files

stateID=$(cat "CA_NE.txt")
traits=$(cat "traits.txt")

# Make sure that all of the PATH/TO/DIR are CLEAN, so that the automatic script can easily move using the variables.

ln -s /data/henry/henrys/first_lac/california/phenotypes_ca_no_small_first_lac .
ln -s /data/henry/henrys/pedigrees/ped_CA/new_ped_ca . 
#cp /data/henry/henrys/first_lac/california/cgs_30 .

ulimit -s unlimited
export OMP_STACKSIZE=128M

#here we want to manually cp the renum_ca_milk.par to renum.red.par file and then insert the previous variances that we got
cp renum_ca_milk.par renum.red.par
sed 's:phen_red_ca:phenotypes_ca_no_small_first_lac:g' renum.red.par > renum.r.par

echo renum.r.par | renumf90 | tee renum_ca_r.log

echo "OPTION use yams" >> renf90.par


echo renf90.par  | blupf90+ | tee aireml_ca.log


######################################################
#### HAVE NOT RAN THIS YET, JUST THEORETICAL CODE#####
######################################################

for x in $stateID
    do
    for y in $traits
        do
            mkdir /data/henry/henrys/first_lac/${x}/${y}/GEBV
            cd /data/henry/henrys/first_lac/${x}/${y}/GEBV

            ln -s /data/henry/henrys/first_lac/${x}/phenotypes_${x}_no_small_first_lac .
            ln -s /data/henry/henrys/pedigrees/ped_${x}/new_ped_${x} .

            cp ../renum_${x}_${y}.par renum.red.par
            sed "s:phen_red_${x}:phenotypes_${x}_no_small_first_lac:g" renum.red.par > renum.r.par

            ulimit -s unlimited
            export OMP_STACKSIZE=128M
            echo renum.r.par | renumf90 | tee renum_${x}_${y}_r.log

            echo "OPTION use yams" >> renf90.par

            echo renf90.par  | blupf90+ | tee aireml_${x}.log

            cd /data/henry/henrys/first_lac
    done
done
