#calculating mean and se averages
mkdir mean_solutions
rm h2_ne_50k
rm se_ne_50k
rm hxs_50k
rm age_50k
rm rv_50k

for i in {1..10}
    do
        grep 'Sample Mean:' aireml_all_log_$i | awk '{print $3}' > temp_h2

        grep 'Sample SD:' aireml_all_log_$i | awk '{print $3}' > temp_se

        echo `cat temp_h2` >> h2_ne_50k

        echo `cat temp_se` >> se_ne_50k
done


for i in {1..10}
    do
        grep -A 1 ' Genetic variance(s) for effect  2' aireml_all_log_$i | tail -n 1 > temp_hxs
        grep -A 1 ' Genetic variance(s) for effect  6' aireml_all_log_$i | tail -n 1 > temp_age
        grep -A 1 ' Residual variance(s)' aireml_all_log_$i | tail -n 1 > temp_rv

        echo `cat temp_hxs` >> hxs_50k
        echo `cat temp_age` >> age_50k
        echo `cat temp_rv` >> rv_50k
done



awk '{s+=$1}END{print "ave:",s/NR}' RS="\n" h2_ne_50k > mean_h2_10.mean

awk '{s+=$1}END{print "ave:",s/NR}' RS="\n" se_ne_50k > mean_se_10.mean

awk '{s+=$1}END{print "ave:",s/NR}' RS="\n" hxs_50k > mean_hxs_10.mean
awk '{s+=$1}END{print "ave:",s/NR}' RS="\n" age_50k > mean_age_10.mean
awk '{s+=$1}END{print "ave:",s/NR}' RS="\n" rv_50k > mean_rv_10.mean

mv *.mean mean_solutions/
