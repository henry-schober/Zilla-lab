ln -s /eval1/2112/yld/phenotypes.txt #sets a link to the original phenotypes file, very helpful for large data files
awk 'NR>4' phenotypes.txt | awk '{print $1,$2}' > ids_all #create a file with only id and mgm group

head -100 ids_all > ids_red #reduced the ids to the first 100 ids

awk '{print $1,substr($2,1,2)}' ids_all > ids_state_all #first two bytes are the state #add in the column for the states ids

awk '$2==93' ids_state_all > ids_ca #select california state=93

awk '$2<17 && $2!=10' ids_state_all > ids_ne #select new england: state from 11 to 16 and removes 10

awk '{print $1}' ids_ca | sort +0 -1 | uniq > ids_ca.sort #the output of the file is in a given order, and there is only one column in this file
awk '{print $1}' ids_ne | sort +0 -1 | uniq > ids_ne.sort #the output of the file is in a given order, and there is only one column in this file

awk 'NR>4' phenotypes.txt | sort +0 -1 > pheno1 

join -1 1 -2 1 pheno1 ids_ca.sort > phenotype_ca #combined the pheno file and ids_ca.sort file by the ids
join -1 1 -2 1 pheno1 ids_ne.sort > phenotype_ne #combined the pheno file and ids_ne.sort file by the ids

ln -s /eval1/2112/pedigrees.txt #link to the large pedigrees data file
awk '{print $2,$3,$4}' pedigrees.txt > pedigree_new.ped #print only columns 2, 3, 4 into a new pedigree file


awk '$5>2000' phenotype_ca > phen_red_ca #column 5 variables have to be greater than 2000
awk '$5>2000' phenotype_ne > phen_red_ne #column 5 variables have to be greater than 2000

awk '{for(i=1;i<=NF;i++)if($i<0)$i=0}1' ../pedigree_new.ped > ped.noupg #remove negative pedigrees for upg
mkdir california #make a directory for the california state
cd california #change that directory

ln -s ../phen_red_ca #Link to the reduced phenotype file for california
cp ../renum_ca.par . #copy the renum paramater file for california