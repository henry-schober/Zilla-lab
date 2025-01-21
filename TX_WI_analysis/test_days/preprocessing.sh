# in the /data/henry/henrys/test_days directory

# Goals: select only animals with at least 5 records (get 100,000 to 150,000 animals)
#   exclude animals with less than 2 records during the summer months (get around a half million animals)

# first part

    #ID_mgm file has both animal ID and mgm group which first two letters is either 35 (WI) or 74(TX)

    #awk '{print $1}' ID_mgm | sort | uniq -c | awk '$1>=5' | awk '{print $2}' > 5_rec_IDs

    # combining the ID of 5+ rec animals to the original data file

    #sort +0 -1 all_testday_seg.txt > sorted_all_testday_seg.txt
    #join -1 1 -2 1 sorted_all_testday_seg.txt 5_rec_IDs > 5_rec_testdays.txt

awk '$5==1 && $6>=5' all_testday_seg.txt > 5_rec_firstlac_td.txt #select for first lactation and at least 5 test days total

awk '$7>= 5 && $7 <= 305' 5_rec_firstlac_td.txt > filtered_testday.txt #this gets us our final filtered file that contains the testday info selecting for animals with the dim being between 5 and 305

