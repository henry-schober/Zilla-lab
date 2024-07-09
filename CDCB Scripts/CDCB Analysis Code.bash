#!/bin/sh

#SBATCH --account=bdo18001
#SBATCH --partition=priority
#SBATCH --qos=bdo18001big
#SBATCH --constraint='epyc128'
#SBATCH --mem=40000

#Header 

#script
ln -s /eval1/2112/yld/phenotypes.txt
awk 'NR>4' phenotypes.txt | awk '{print $1,$2}' > ids_all #create a file with only id and mgm group

head -100 ids_all > ids_red

awk '{print $1,substr($2,1,2)}' ids_all > ids_state_all #first two bytes are the state

awk '$2==93' ids_state_all > ids_ca #select california state=93

awk '$2<17 && $2!=10' ids_state_all > ids_ne #select new england: state from 11 to 16 and removes 10

awk '{print $1}' ids_ca | sort +0 -1 | uniq > ids_ca.sort
awk '{print $1}' ids_ne | sort +0 -1 | uniq > ids_ne.sort

awk 'NR>4' phenotypes.txt | sort +0 -1 > pheno1

join -1 1 -2 1 pheno1 ids_ca.sort > phenotype_ca
join -1 1 -2 1 pheno1 ids_ne.sort > phenotype_ne

ln -s /eval1/2112/pedigrees.txt
awk '{print $2,$3,$4}' pedigrees.txt > pedigree_new.ped


awk '$5>2000' phenotype_ca > phen_red_ca
awk '$5>2000' phenotype_ne > phen_red_ne

awk '{for(i=1;i<=NF;i++)if($i<0)$i=0}1' ../pedigree_new.ped > ped.noupg #remove negative pedigrees for upg
mkdir california
cd california

ln -s ../phen_red_ca
cp ../renum_ca.par .

echo renum_ca.par | renumf90 | tee tee renum_ca.log
echo "OPTION use_yams" >> renf90.par
echo renf90.par | airemlf90 | tee aireml_ca.log
cd ..

mkdir ne
cd ne

ln -s ../phen_red_ne
cp ../renum_ne.par .

echo renum_ne.par | renumf90 | tee renum_ne.log
echo "OPTION use_yams" >> renf90.par
echo renf90.par | airemlf90 | tee aireml_ca.log
echo
cd ..

mkdir ca_ne
cd ca_ne


awk '{ print $0,$9,$11,$13,0,0,0}' ../phen_red_ca > ca.temp
awk '{ print $0,0,0,0,$9,$11,$13}' ../phen_red_ne > ne.temp

cat ca.temp ne.temp >  phenotype_two.dat
echo "OPTION use_yams" >> renf90.par
ulimit -s unlimited

echo renf90.par | airemlf90 | tee aireml_ca1.log
      
echo renum_two.par | renumf90 | renum_two.log

cd ..





mkdir ne_2010
cd ne_2010
#awk '$5>2010' ../phenotype_ne | awk 'int(100*rand())%20<1' > phen_ne_2010_red #not random :(

for i in {1..30}
do
echo $i
#cp airemlf90.log airemlf90.log_$i
#done

awk '$5>2010' ../phenotype_ne | shuf | head -25000 > phen_ne_2010_red

#cp phen_ne_2010_red phen_$i

sed 's:phen_red_ne:phen_ne_2010_red:g' ../renum_ne.par > renum_ne.par
#sed
echo renum_ne.par | renumf90 | tee tee renum_ne$i.log
echo "OPTION use_yams" >> renf90.par
echo "OPTION se_covar_function H2 G_6_6_1_1/(G_6_6_1_1+R_1_1)" >> renf90.par
ulimit -s unlimited
export OMP_STACKSIZE=512M
echo renf90.par | airemlf90 | tee aireml_ne_$i.log

cp airemlf90.log airemlf90.log_$i

done

rm h2_ne_25k
rm se_ne_25k
for i in {1..30}
do
grep 'Sample Mean:' airemlf90.log_$i | awk '{print $3}' > temp_h2
grep 'Sample SD:' airemlf90.log_$i | awk '{print $3}' > temp_se
echo `cat temp_h2` >> h2_ne_25k
echo `cat temp_se` >> se_ne_25k

done
#script
ln -s /eval1/2112/yld/phenotypes.txt
awk 'NR>4' phenotypes.txt | awk '{print $1,$2}' > ids_all #create a file with only id and mgm group

head -100 ids_all > ids_red

awk '{print $1,substr($2,1,2)}' ids_all > ids_state_all #first two bytes are the state

awk '$2==93' ids_state_all > ids_ca #select california state=93

awk '$2<17 && $2!=10' ids_state_all > ids_ne #select new england: state from 11 to 16 and removes 10

awk '{print $1}' ids_ca | sort +0 -1 | uniq > ids_ca.sort
awk '{print $1}' ids_ne | sort +0 -1 | uniq > ids_ne.sort

awk 'NR>4' phenotypes.txt | sort +0 -1 > pheno1

join -1 1 -2 1 pheno1 ids_ca.sort > phenotype_ca
join -1 1 -2 1 pheno1 ids_ne.sort > phenotype_ne

ln -s /eval1/2112/pedigrees.txt
awk '{print $2,$3,$4}' pedigrees.txt > pedigree_new.ped


awk '$5>2000' phenotype_ca > phen_red_ca
awk '$5>2000' phenotype_ne > phen_red_ne

awk '{for(i=1;i<=NF;i++)if($i<0)$i=0}1' ../pedigree_new.ped > ped.noupg #remove negative pedigrees for upg
mkdir california
cd california

ln -s ../phen_red_ca
cp ../renum_ca.par .

echo renum_ca.par | renumf90 | tee tee renum_ca.log
echo "OPTION use_yams" >> renf90.par
echo renf90.par | airemlf90 | tee aireml_ca.log
cd ..

mkdir ne
cd ne

ln -s ../phen_red_ne
cp ../renum_ne.par .

echo renum_ne.par | renumf90 | tee renum_ne.log
echo "OPTION use_yams" >> renf90.par
echo renf90.par | airemlf90 | tee aireml_ca.log
echo
cd ..

mkdir ca_ne
cd ca_ne


awk '{ print $0,$9,$11,$13,0,0,0}' ../phen_red_ca > ca.temp
awk '{ print $0,0,0,0,$9,$11,$13}' ../phen_red_ne > ne.temp

cat ca.temp ne.temp >  phenotype_two.dat
echo "OPTION use_yams" >> renf90.par
ulimit -s unlimited

echo renf90.par | airemlf90 | tee aireml_ca1.log
      
echo renum_two.par | renumf90 | renum_two.log

cd ..





mkdir ne_2010
cd ne_2010
#awk '$5>2010' ../phenotype_ne | awk 'int(100*rand())%20<1' > phen_ne_2010_red #not random :(

for i in {1..30}
do
echo $i
#cp airemlf90.log airemlf90.log_$i
#done

awk '$5>2010' ../phenotype_ne | shuf | head -25000 > phen_ne_2010_red

#cp phen_ne_2010_red phen_$i

sed 's:phen_red_ne:phen_ne_2010_red:g' ../renum_ne.par > renum_ne.par
#sed
echo renum_ne.par | renumf90 | tee tee renum_ne$i.log
echo "OPTION use_yams" >> renf90.par
echo "OPTION se_covar_function H2 G_6_6_1_1/(G_6_6_1_1+R_1_1)" >> renf90.par
ulimit -s unlimited
export OMP_STACKSIZE=512M
echo renf90.par | airemlf90 | tee aireml_ne_$i.log

cp airemlf90.log airemlf90.log_$i

done

rm h2_ne_25k
rm se_ne_25k
for i in {1..30}
do
grep 'Sample Mean:' airemlf90.log_$i | awk '{print $3}' > temp_h2
grep 'Sample SD:' airemlf90.log_$i | awk '{print $3}' > temp_se
echo `cat temp_h2` >> h2_ne_25k
echo `cat temp_se` >> se_ne_25k

done
