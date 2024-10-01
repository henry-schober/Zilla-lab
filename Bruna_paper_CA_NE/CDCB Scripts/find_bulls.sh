cd /data/unziped
pwd 
awk '$11=="HO"' pedigree.txt > pedigree.holstein
awk '{for(i=1;i<=NF;i++)if($i<0)$i=0}1' pedigree.holstein > ped.ho.noupg
awk '{print $2}'  ped.ho.noupg | sort +0 -1 | uniq -c > ho.bulls #let's try to get around 40k bulls
