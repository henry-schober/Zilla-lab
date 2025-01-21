#The purpose of this script is two create two important output files; phenotypes_${x}_no_small_first_lac and cgs_30
#the phenotype output file is used for running blupf90
#the cgs_30 output file contains daughters in a cg with more than 30 daughters
# These two files are to be used for all three traits, do not need to make seperate files for each trait
# The input files needed for this is renum_$x.par (doesn't matter what trait par file, milk was just the first one), phen_red_x, new_ped_x


state=$(cat "CA_NE.txt")
for x in $state
    do
        mkdir ${x}_phen_cgs
        cd ${x}_phen_cgs

        ln -s /data/henry/henrys/phenotypes/phen_red_${x} .
        ln -s /data/henry/henrys/pedigrees/ped_${x}/new_ped_${x} .

        ulimit -s unlimited
        export OMP_STACKSIZE=1G

        INBREEDING
        -no inbreeding

        echo renum_${x}.par | renumf90 | tee renum_${x}.log
        echo "OPTION method VCE" >>  renf90.par
        echo "OPTION use yams" >> renf90.par
        awk ' $1!=0' renf90.dat > renf90.temp


        #removing small CG


        grep  "Effect group 1" renf90.tables | awk '{print $8}' > number_cg


        read -d $'\x04' var_cg  < number_cg

        grep "Effect group 1" renf90.tables -A $var_cg | awk 'NR>2' > cgs

        awk '$2>29' cgs > cgs_30

        awk '{print $3}' cgs_30 | sort > cg30.sort #7758 cgs

        sort +1 -2 renf90.dat > renf90.sort

        join -1 1 -2 2 cg30.sort renf90.sort > renf90.temp


        awk '{print $2,$1,$3,$4,$5,$6,$7,$8,$9}' renf90.temp > renf90.clean.dat

        ##################################
        #remove small herd by sire groups#
        ##################################

        awk '{print $3}' renf90.clean.dat | sort | uniq -c > hxs
        awk '$1>3' hxs | awk ' {print $2}' | sort > hxs_4 #22k

        sort +2 -3 renf90.temp > renf90.temp.sort
        join -1 1 -2 3 hxs_4  renf90.temp.sort >  renf90.temp2



        awk '{print $1}' renf90.temp2 | sort | uniq -c | awk ' $1<4' #no small hxs :)
        awk '{print $2}' renf90.temp2 | sort | uniq -c | awk ' $1<4' #14 small cg

        awk '{print $2}' renf90.temp2 | sort | uniq -c | awk '$1>3' | awk ' {print $2}' | sort > cg2 #7732 cgs
        sort +1 -2 renf90.temp2 >  renf90.temp.sort3

        join -1 1 -2 2 cg2  renf90.temp.sort3 >  renf90.temp3

        awk '{print $1}' renf90.temp3 | sort | uniq -c | awk ' $1<4'
        awk '{print $2}' renf90.temp3 | sort | uniq -c | awk ' $1<4' #2400

        awk '{print $3,$2,$1,$4,$5,$6,$7,$8,$9}' renf90.temp3 > renf90.clean2.dat

        awk ' {print $7}' renf90.clean2.dat | sort +0 -1 > ids_clean #type

        uniq ids_clean | sort +0 -1 > ids_single
        uniq -c ids_clean | wc -l

        sort +0 -1 renadd06.ped > renadd.sort
        join -1 1 -2 1 ids_single renadd.sort | awk '{print $10}' | sort +0 -1 > ids.red.${x}



        sort +0 -1  phen_red_${x} > phen_${x}.sort

        join ids.red.${x} phen_${x}.sort > phenotypes_${x}_no_small_first_lac

        cd ../
    done


