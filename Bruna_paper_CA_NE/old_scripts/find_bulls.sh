cd /data/unziped
pwd 
awk '$11=="HO"' pedigree.txt > pedigree.holstein
awk '{for(i=1;i<=NF;i++)if($i<0)$i=0}1' pedigree.holstein > ped.ho.noupg
awk '{print $3}'  ped.ho.noupg | sort +0 -1 | uniq -c | awk '$2>0' > ho.bulls #Print the sire IDs, then sort and count the uniq instances of the IDS, removing the ID of 0. We get 905331 bulls.
awk '$1>20' ho.bulls > ho.bulls20 #161580
awk '$1>40' ho.bulls > ho.bulls40 #93995
awk '$1>60' ho.bulls > ho.bulls60 #70193
awk '$1>100' ho.bulls > ho.bulls100 #46044
awk '$1>120' ho.bulls > ho.bulls120 #38970