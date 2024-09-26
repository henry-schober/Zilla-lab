# This script is to help automate our analyses after getting our phenotype files, runs all of the ssd.sh scripts we have

## Single Trait

# NE
# milk
cd /data/henry/henrys/first_lac/new_england/milk
sh ssd50k_pheno_ne_no_small.sh

# protein
cd ../protein
sh ssd50k_pheno_ne_no_small.sh

# fat
cd ../fat
sh ssd50k_pheno_ne_no_small.sh

# CA
# milk
cd /data/henry/henrys/first_lac/california/milk
sh ssd50k_pheno_ca_no_small.sh

# protein
cd ../protein
sh ssd50k_pheno_ca_no_small.sh

# fat
cd ../fat
sh ssd50k_pheno_ca_no_small.sh

# Combined CA and NE

# milk
cd /data/henry/henrys/first_lac/combined/milk
sh ssd_phen_all_milk.sh

# protein
cd ../protein
sh ssd_phen_all_protein.sh

# fat
cd ../fat
sh ssd_phen_all_fat.sh


## Two trait 

