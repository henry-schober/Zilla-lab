ln -s /data/unziped/yld_phenotypes.txt .
#for future somatic cell analysis
#ln -s /data/unziped/scs_phenotypes.txt .


awk 'NR>4' yld_phenotypes.txt | awk '{print $1,$2}' > ids_all #create a file with only id and mgm group

head -100 ids_all > ids_red

awk '{print $1,substr($2,1,2)}' ids_all > ids_state_all #first two bytes are the state

awk '$2==93' ids_state_all > ids_ca #select california state=93

awk '$2<17 && $2!=10' ids_state_all > ids_ne #select new england: state from 11 to 16 and removes 10

awk '{print $1}' ids_ca | sort +0 -1 | uniq > ids_ca.sort
awk '{print $1}' ids_ne | sort +0 -1 | uniq > ids_ne.sort

awk 'NR>4' yld_phenotypes.txt | sort +0 -1 > pheno1

join -1 1 -2 1 pheno1 ids_ca.sort > phenotype_ca
join -1 1 -2 1 pheno1 ids_ne.sort > phenotype_ne
awk '$10=="HO"' pedigree.txt | awk '{print $2,$3,$4,$5}' > pedigree_hol.ped


awk '$5>2000' phenotype_ca > phen_red_ca_temp #only getting data of cows born after 1st lactation
awk '$6==1' phen_red_ca_temp > phen_red_ca #only getting the data of first lactations
awk '$5>2000' phenotype_ne > phen_red_ne_temp
awk '$6==1' phen_red_ne_temp > phen_red_ne


awk '{for(i=1;i<=NF;i++)if($i<0)$i=0}1' pedigree_hol.ped > ped.noupg #remove negative pedigrees for upg
