# in the /data/henry/henrys/test_days directory

# Goals: select only animals with at least 5 records (get 100,000 to 150,000 animals)
#   exclude animals with less than 2 records during the summer months (get around a half million animals)

awk '$5==1' all_testday_seg.txt > firstlac_td.txt 
#select for first lactation.

awk '$7>= 5 && $7 <= 305' firstlac_td.txt > filtered_testday.txt
#this gets us our final filtered file that contains the testday info selecting for animals with the dim being between 5 and 305,

awk '{print $1}' filtered_testday.txt | uniq -c | awk '$1>5' | awk '{print $2}' | sort > cross_5_rec_post_filter.id 
#here we get the original id of cows with DIM between 5 and 305 days, with at least 5 records

sort +0 -1 filtered_testday.txt > filtered_testday_sorted.txt
#sort the filtered file in order to combine it with the file of cows that have at least 5 records

join -1 1 -2 1 cross_5_rec_post_filter.id filtered_testday_sorted.txt > joined_merged_filtered_data.txt

awk '$1 ~ /^HO/' joined_merged_filtered_data.txt > merged_filtered_data.txt #get holsteins only

