ln -s /data/henry/henrys/phenotypes/phenotypes_ca_no_small_first_lac .  #adding soft link to phenotype files
ln -s /data/henry/henrys/phenotypes/phenotypes_ne_no_small_first_lac .

wc -l  phenotypes_ca_no_small_first_lac #counting how many animals
wc -l  phenotypes_ne_no_small_first_lac

cat phenotypes_ca_no_small_first_lac phenotypes_ne_no_small_first_lac > phenotypes.all #creating a single file
cp /data/breno/ped.noupg .  #copying original files

#grabbed the renumf par file from the original two trait directory
ln -s /data/henry/henrys/first_lac/bulls30/30_daughters/renum.par .


awk '{print $1}' phenotypes_ca_no_small_first_lac | sort +0 -1 > ids_ca_original #only the ids from CA cows
awk '{print $1}' phenotypes_ne_no_small_first_lac | sort +0 -1 > ids_ne_original #only ids from NE cows



awk '{print $10,$2}' renadd06.ped | sort +0 -1 > id_sire #this file contains original ids and sire ids - sire id is the renumbered one


join -1 1 -2 1 id_sire ids_ca_original > ca_with_sire #here we are having only the ids of cows from ca with their sire 
join -1 1 -2 1 id_sire ids_ne_original > ne_with_sire #same as above for ne


wc -l ca_with_sire #confirms that we have the same number of animals as the original files
wc -l ne_with_sire

awk '{print $2}' ca_with_sire| sort +0 -1 | uniq -c | awk '$2!=0' > sires_ca #print sire ids for ca, count daughters, and remove sire =0
awk '{print $2}' ne_with_sire| sort +0 -1 | uniq -c | awk '$2!=0' > sires_ne #same as above for ne


awk '$1>30' sires_ca > famous_sires_ca #select sires with more than 30 daughters for ca
awk '$1>30' sires_ne > famous_sires_ne #same as above for ne



awk '{print $2}' famous_sires_ca | sort > to_keep_ca #keep only sire ids for ca - renumbered sire ID of 30+daughters in california
awk '{print $2}' famous_sires_ne | sort > to_keep_ne #same as above for ne

join -1 1 -2 1 to_keep_ca to_keep_ne | sort +0 -1 > to_keep_all #join sires, so only sires in both files are kept - renumbered id. Use this file for extracting phenotype

awk '{print $1,$10}' renadd06.ped | sort +0 -1  > xref #creates a cross reference file 

join -1 1 -2 1 to_keep_all xref | awk '{print $2}' | sort +0 -1  > bulls_original_ids #extract original ids for bulls

#in this last file we have 2040 bulls with more than 30 daughters in each state

## If you want to get all of the daughters phenotypes together
sort +1 -2 id_sire | awk '$2!=0' > sorted_id_sire #sorted the renumbered sire id and original daughter id file by sire id and got rid of the sire id of 0
join -1 1 -2 2 to_keep_all sorted_id_sire | awk '{print $2}' > famous_daughters_orig_id #got original id of all daughters with famous sires
sort +0 -1 famous_daughters_orig_id > famous_daughter.sorted
sort +0 -1 phenotypes.all > phen.sorted  
join -1 1 -2 1 famous_daughter.sorted phen.sorted > famous_daughter.phen

## NE
sort +1 -2 ne_with_sire | awk '$2!=0' > sorted_id_sire_NE #sorted the renumbered sire id and original daughter id file by sire id and got rid of the sire id of 0
join -1 1 -2 2 to_keep_all sorted_id_sire_NE | awk '{print $2}' |uniq -c | awk '{print $2}' > famous_daughters_orig_id_NE #got original id of NE daughters with famous sires
sort +0 -1 famous_daughters_orig_id_NE > NE_famous_daughter.sorted
sort +0 -1 phenotypes_ne_no_small_first_lac > phen_NE.sorted  
join -1 1 -2 1 NE_famous_daughter.sorted phen_NE.sorted > famous_daughter_NE.phen

## CA

sort +1 -2 ca_with_sire | awk '$2!=0' > sorted_id_sire_CA #sorted the renumbered sire id and original daughter id file by sire id and got rid of the sire id of 0
join -1 1 -2 2 to_keep_all sorted_id_sire_CA | awk '{print $2}' |uniq -c | awk '{print $2}' > famous_daughters_orig_id_CA #got original id of CA daughters with famous sires
sort +0 -1 famous_daughters_orig_id_CA > CA_famous_daughter.sorted
sort +0 -1 phenotypes_ca_no_small_first_lac > phen_CA.sorted  
join -1 1 -2 1 CA_famous_daughter.sorted phen_CA.sorted > famous_daughter_CA.phen

