#calculating mean and se averages 

rm h2_ne_50k 

rm se_ne_50k 

 

for i in {1..10} 

do 

 

grep 'Sample Mean:' airemlf90_log_$i | awk '{print $3}' > temp_h2 

grep 'Sample SD:' airemlf90_log_$i | awk '{print $3}' > temp_se 

echo `cat temp_h2` >> h2_ne_50k 

echo `cat temp_se` >> se_ne_50k 

 

done 