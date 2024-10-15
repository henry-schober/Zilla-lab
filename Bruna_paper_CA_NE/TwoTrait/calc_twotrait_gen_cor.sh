#This script is ran to grab the genetic correlations from the aireml_log files in the two trait model. 



mkdir gen_corr/

for i in {1..10}
    do
        grep -A 2 'rg12' aireml_log_$i | grep 'Sample Mean:' | awk '{print $3}' > temp_rg

        grep -A 3 'rg12' aireml_log_$i | grep 'Sample SD:' | awk '{print $3}' > temp_rg_se


        echo `cat temp_rg` >> rg_50k
        echo `cat temp_rg_se` >> rg_se_50k
done

awk '{s+=$1}END{print "ave:",s/NR}' RS="\n" rg_50k > rg.mean
awk '{s+=$1}END{print "ave:",s/NR}' RS="\n" rg_se_50k > rg_se.mean

mv *.mean gen_corr/