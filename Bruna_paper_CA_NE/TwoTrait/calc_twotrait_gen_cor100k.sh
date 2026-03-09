#This script is ran to grab the genetic correlations from the aireml_log files in the two trait model. 
#a second portion of the script will calcualte the variance components for the single trait combined suing 50k from each state


cd /work/breno/bruna_2_trait_100k/milk_two_trait #or
# cd /work/breno/bruna_2_trait_100k/milk_two_trait #or
# cd /work/breno/bruna_2_trait_100k/milk_two_trait
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

mv *.mean gen_corr/ #works well to this point

#for the se

 awk '{sum+=$1; sumsq+=$1^2} END {print sqrt(sumsq/NR - (sum/NR)^2)}' ../rg_50k
 awk '{sum+=$1; sumsq+=$1^2} END {print sqrt(sumsq/NR - (sum/NR)^2)}' ../rg_se_50k



 #checking convergence problems

 
