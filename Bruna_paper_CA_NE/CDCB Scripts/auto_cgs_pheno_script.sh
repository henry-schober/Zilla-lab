#The purpose of this script is to run all the phenotype scripts
cd /data/henry/henrys/first_lac/new_england/milk

sh combined_ne_w_var_milk.sh

mv cgs_30 ../.
mv phenotypes_ne_no_small_first_lac ../.

cd /data/henry/henrys/first_lac/california/milk

sh combined_ca_w_var_milk.sh

mv cgs_30 ../.
mv phenotypes_ca_no_small_first_lac ../.


cd /data/henry/henrys/first_lac/combined/ne

sh ssd_phen_ne_1_10.sh

cp phen_ne.clean* ../.

cd /data/henry/henrys/first_lac/combined/ca

sh ssd_phen_ca_1_10.sh

cp phen_ca.clean* ../.

cd /data/henry/henrys/first_lac/combined

sh combining_phen.sh

#stop here before going into two trait folder as we can use the variances found in the previous analysis
