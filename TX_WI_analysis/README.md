README for testdays

The first script we are running is `preprocessing.sh`

The script looks like this:
```
awk '$5==1' all_testday_seg.txt > firstlac_td.txt 
#This piece of code selects for the first lactation records

awk '$7>= 5 && $7 <= 305' firstlac_td.txt > filtered_testday.txt
#this gets us our final filtered file that contains the testday info selecting for animals with the dim being between 5 and 305, 26182006 records

awk '{print $1}' filtered_testday.txt | uniq -c | awk '$1>5' | awk '{print $2}' | sort > cross_5_rec_post_filter.id 
#here we get the original id of cows with DIM between 5 and 305 days, with at least 5 records

sort +0 -1 filtered_testday.txt > filtered_testday_sorted.txt
#sort the filtered file in order to combine it with the file of cows that have at least 5 records

join -1 1 -2 1 cross_5_rec_post_filter.id filtered_testday_sorted.txt > joined_merged_filtered_data.txt
#here we wanted to combine the cross reference file that contain just the id's of cows that fit our filtering parameters, with the full data set, allowing us to get the data of only the first lactation of the cows with at least 5 test day records, wiht the DIM being between 5 and 305 days

awk '$1 ~ /^HO/' joined_merged_filtered_data.txt > merged_filtered_data.txt #filter the previous file even more to only contain holsteins, 21035917 records
```
What this script accomplishes is we are able to obtain the phenotype file of the first lactaction of holsteins that have more than 5 test day records and only have DIM records between 5 and 305 days. This file is going to be our basis for our phenotype files. We will now use this file in order to get the top farms 
