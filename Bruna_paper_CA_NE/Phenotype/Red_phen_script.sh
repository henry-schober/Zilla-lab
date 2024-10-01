# This file creates the original reduced pheno file for both CA and NE 

ln -s /data/unziped/yld_phenotypes.txt .
ln -s /data/unziped/pedigree.txt .

awk 'NR>4' yld_phenotypes.txt | awk '{print $1,$2}' > ids_all #create a file with only id and mgm group
awk 'NR>4' yld_phenotypes.txt | sort +0 -1 > pheno1

head -100 ids_all > ids_red #reduced id file for quick visualization

awk '{print $1,substr($2,1,2)}' ids_all > ids_state_all #first two bytes are the state

awk '$2==93' ids_state_all > ids_CA #select california state=93

awk '$2<17 && $2!=10' ids_state_all > ids_NE #select new england: state from 11 to 16 and removes 10
awk '$10=="HO"' pedigree.txt | awk '{print $2,$3,$4,$5}' > pedigree_hol.ped #unsure of what this is doing for the the pedigree file

state=$(cat "CA_NE.txt") #this is just a text file that literally only has CA and NE in it. the location is up a directory ../CA_NE.txt. will be useful for the rest of the analysis
for x in $state
    do
        awk '{print $1}' ids_${x} | sort +0 -1 | uniq > ids_${x}.sort #sorted id list of both states
        
        join -1 1 -2 1 pheno1 ids_${x}.sort > phenotype_${x} #combining the id lists with the sorted phenotype file to get only phenotype of cows in CA or NE

        awk '$5>2000' phenotype_${x} | awk '$6==1' > phen_red_${x} #taking data from first lactation of cows born after 2000
    done
awk '{for(i=1;i<=NF;i++)if($i<0)$i=0}1' pedigree_hol.ped > ped.noupg #remove negative pedigrees for upg

