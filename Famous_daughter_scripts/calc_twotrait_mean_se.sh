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


        echo `cat temp_h2_NE` >> h2_NE_50k
        echo `cat temp_h2_CA` >> h2_CA_50k
        echo `cat temp_se_NE` >> se_NE_50k
        echo `cat temp_se_CA` >> se_CA_50k
done


for i in {1..10}
    do
        grep -A 2 ' Genetic variance(s) for effect  2' aireml_log_$i | awk 'NR==2 {print $1}' > temp_hxs_NE
        grep -A 2 ' Genetic variance(s) for effect  2' aireml_log_$i | awk 'NR==3 {print $2}' > temp_hxs_CA

        grep -A 2 ' Genetic variance(s) for effect  6' aireml_log_$i | awk 'NR==2 {print $1}' > temp_age_NE
        grep -A 2 ' Genetic variance(s) for effect  6' aireml_log_$i | awk 'NR==3 {print $2}' > temp_age_CA

        grep -A 2 ' Residual variance(s)' aireml_log_$i | awk 'NR==2 {print $1}' > temp_rv_NE
        grep -A 2 ' Residual variance(s)' aireml_log_$i | awk 'NR==3 {print $2}' > temp_rv_CA

        echo `cat temp_hxs_NE` >> hxs_NE_50k
        echo `cat temp_hxs_CA` >> hxs_CA_50k
        echo `cat temp_age_NE` >> age_NE_50k
        echo `cat temp_age_CA` >> age_CA_50k
        echo `cat temp_rv_NE` >> rv_NE_50k
        echo `cat temp_rv_CA` >> rv_CA_50k
done

#USE this for the two trait model!!
#grep -A 2 'Genetic variance(s) for effect  2' aireml_log_$i | awk 'NR==2 {NE=$1} NR==3 {CA=$2} END {print NE, CA}'

#This code actually finds us the average of the values in the previous files
rm filelist.txt
touch filelist.txt

#nested for loop to get rid of unnecessary code
variances="h2 se hxs age rv"
state="NE CA"

for x in $variances; do
    for y in $state; do
        echo "${x}_${y}_50k" >> filelist.txt
    done
done


filenames=$(cat filelist.txt)
for x in $filenames
    do
        awk '{s+=$1}END{print "ave:",s/NR}' RS="\n" $x > ${x}.mean
    done
mv *.mean mean_solutions/