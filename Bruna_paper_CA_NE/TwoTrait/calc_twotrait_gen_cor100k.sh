#This script is ran to grab the genetic correlations from the aireml_log files in the two trait model. 
#a second portion of the script will calcualte the variance components for the single trait combined suing 50k from each state


cd /work/breno/bruna_2_trait_100k/milk_two_trait #or
# cd /work/breno/bruna_2_trait_100k/protein_two_trait #or
# cd /work/breno/bruna_2_trait_100k/fat_two_trait
mkdir gen_corr/

for i in {1..10}
    do
        grep -A 2 'rg12' aireml_log_$i | grep 'Sample Mean:' | awk '{print $3}' > temp_rg

        grep -A 3 'rg12' aireml_log_$i | grep 'Sample SD:' | awk '{print $3}' > temp_rg_se


        echo `cat temp_rg` >> rg_100k
        echo `cat temp_rg_se` >> rg_se_100k
done

awk '{s+=$1}END{print "ave:",s/NR}' RS="\n" rg_100k > rg.mean
awk '{s+=$1}END{print "ave:",s/NR}' RS="\n" rg_se_100k > rg_se.mean

mv *.mean gen_corr/ 

#for the se

 awk '{sum+=$1; sumsq+=$1^2} END {print sqrt(sumsq/NR - (sum/NR)^2)}' ../rg_100k
 awk '{sum+=$1; sumsq+=$1^2} END {print sqrt(sumsq/NR - (sum/NR)^2)}' ../rg_se_100k



 #Here I am including the code for the two trait mean se.sh so that it all stays in the same script for the 100k analysis

 #this script is to calculate the mean and sd of the two trait analysis files
mkdir mean_solutions

#for getting the correct aireml log files, size and target directory changes
# find -type f -size -22000c -print0 | xargs -0 mv -t analysis_files/

for i in {1..10}
    do
        grep -A 2 'H2d_NE' aireml_log_$i | grep 'Sample Mean:' | awk '{print $3}' > temp_h2_NE
        grep -A 2 'H2d_CA' aireml_log_$i | grep 'Sample Mean:' | awk '{print $3}' > temp_h2_CA

        grep -A 3 'H2d_NE' aireml_log_$i | grep 'Sample SD:' | awk '{print $3}' > temp_se_NE
        grep -A 3 'H2d_CA' aireml_log_$i | grep 'Sample SD:' | awk '{print $3}' > temp_se_CA


        echo `cat temp_h2_NE` >> h2_NE_100k
        echo `cat temp_h2_CA` >> h2_CA_100k
        echo `cat temp_se_NE` >> se_NE_100k
        echo `cat temp_se_CA` >> se_CA_100k
done




for i in {1..10}
    do
        grep -A 2 ' Genetic variance(s) for effect  2' aireml_log_$i | awk 'NR==2 {print $1}' > temp_hxs_NE
        grep -A 2 ' Genetic variance(s) for effect  2' aireml_log_$i | awk 'NR==3 {print $2}' > temp_hxs_CA

        grep -A 2 ' Genetic variance(s) for effect  6' aireml_log_$i | awk 'NR==2 {print $1}' > temp_age_NE
        grep -A 2 ' Genetic variance(s) for effect  6' aireml_log_$i | awk 'NR==3 {print $2}' > temp_age_CA

        grep -A 2 ' Residual variance(s)' aireml_log_$i | awk 'NR==2 {print $1}' > temp_rv_NE
        grep -A 2 ' Residual variance(s)' aireml_log_$i | awk 'NR==3 {print $2}' > temp_rv_CA

        echo `cat temp_hxs_NE` >> hxs_NE_100k
        echo `cat temp_hxs_CA` >> hxs_CA_100k
        echo `cat temp_age_NE` >> age_NE_100k
        echo `cat temp_age_CA` >> age_CA_100k
        echo `cat temp_rv_NE` >> rv_NE_100k
        echo `cat temp_rv_CA` >> rv_CA_100k
done


 #for the sd:

awk '{sum+=$1; sumsq+=$1^2} END {print sqrt(sumsq/NR - (sum/NR)^2)}' ../age_CA_100k
awk '{sum+=$1; sumsq+=$1^2} END {print sqrt(sumsq/NR - (sum/NR)^2)}' ../hxs_CA_100k
awk '{sum+=$1; sumsq+=$1^2} END {print sqrt(sumsq/NR - (sum/NR)^2)}' ../rv_CA_100k
awk '{sum+=$1; sumsq+=$1^2} END {print sqrt(sumsq/NR - (sum/NR)^2)}' ../h2_CA_100k
awk '{sum+=$1; sumsq+=$1^2} END {print sqrt(sumsq/NR - (sum/NR)^2)}' ../se_CA_100k


awk '{sum+=$1; sumsq+=$1^2} END {print sqrt(sumsq/NR - (sum/NR)^2)}' ../age_NE_100k
awk '{sum+=$1; sumsq+=$1^2} END {print sqrt(sumsq/NR - (sum/NR)^2)}' ../hxs_NE_100k
awk '{sum+=$1; sumsq+=$1^2} END {print sqrt(sumsq/NR - (sum/NR)^2)}' ../rv_NE_100k
awk '{sum+=$1; sumsq+=$1^2} END {print sqrt(sumsq/NR - (sum/NR)^2)}' ../h2_NE_100k
awk '{sum+=$1; sumsq+=$1^2} END {print sqrt(sumsq/NR - (sum/NR)^2)}' ../se_NE_100k



rm filelist.txt
touch filelist.txt

#nested for loop to get rid of unnecessary code
variances="h2 se hxs age rv"
state="NE CA"

for x in $variances; do
    for y in $state; do
        echo "${x}_${y}_100k" >> filelist.txt
    done
done


filenames=$(cat filelist.txt)
for x in $filenames
    do
        awk '{s+=$1}END{print "ave:",s/NR}' RS="\n" $x > ${x}.mean
    done
mv *.mean mean_solutions/




##################################################
#now for the single trait combined analysis ######
##################################################


mkdir mean_solutions_st
rm h2_ne_50k
rm se_ne_50k
rm hxs_50k
rm age_50k
rm rv_50k

for i in {1..10}
    do
        grep 'Sample Mean:' aireml_st_log_$i | awk '{print $3}' > temp_h2

        grep 'Sample SD:' aireml_st_log_$i | awk '{print $3}' > temp_se

        echo `cat temp_h2` >> h2_st_100k

        echo `cat temp_se` >> se_st_100k
done


for i in {1..10}
    do
        grep -A 1 ' Genetic variance(s) for effect  2' aireml_st_log_$i | tail -n 1 > temp_hxs
        grep -A 1 ' Genetic variance(s) for effect  6' aireml_st_log_$i | tail -n 1 > temp_age
        grep -A 1 ' Residual variance(s)' aireml_st_log_$i | tail -n 1 > temp_rv

        echo `cat temp_hxs` >> hxs_st_100k
        echo `cat temp_age` >> age_st_100k
        echo `cat temp_rv` >> rv_st_100k
done




awk '{s+=$1}END{print "ave:",s/NR}' RS="\n" h2_st_100k > mean_st_h2_10.meanst
 #awk '{sum+=$1; sumsq+=$1^2} END {print sqrt(sumsq/NR - (sum/NR)^2)}' ../h2_ne_50k > sd_h2_10.sd #calculate sd
awk '{s+=$1}END{print "ave:",s/NR}' RS="\n" se_st_100k > mean_se_10.meanst

awk '{s+=$1}END{print "ave:",s/NR}' RS="\n" hxs_st_100k > mean_st_hxs_10.meanst
awk '{s+=$1}END{print "ave:",s/NR}' RS="\n" age_st_100k > mean_st_age_10.meanst
awk '{s+=$1}END{print "ave:",s/NR}' RS="\n" rv_st_100k > mean_st_rv_10.meanst

mkdir mean_st
cd mean_st

cp ../*.meanst .




awk '{sum+=$1; sumsq+=$1^2} END {print sqrt(sumsq/NR - (sum/NR)^2)}' ../h2_st_100k
awk '{sum+=$1; sumsq+=$1^2} END {print sqrt(sumsq/NR - (sum/NR)^2)}' ../se_st_100k
awk '{sum+=$1; sumsq+=$1^2} END {print sqrt(sumsq/NR - (sum/NR)^2)}' ../age_st_100k
awk '{sum+=$1; sumsq+=$1^2} END {print sqrt(sumsq/NR - (sum/NR)^2)}' ../hxs_st_100k
awk '{sum+=$1; sumsq+=$1^2} END {print sqrt(sumsq/NR - (sum/NR)^2)}' ../rv_st_100k
