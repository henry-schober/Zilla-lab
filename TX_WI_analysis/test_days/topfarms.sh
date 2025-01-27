#!/bin/bash

# this script is to be ran after preprocessing.sh, this is to help us get the top farms

awk '{print $4}' merged_filtered_data.txt | sort | uniq -c | sort +0 -1 -nr > top_farms.ids #gets us the farm ids with how many records they have


awk '{print $1, $4}' merged_filtered_data.txt | sort -u -k1,1 | awk '{print $2}' | uniq -c | sort +0 -1 -nr > top_farms_animals.id #get us the farm ids with how many cows are at that farm

awk '{print $1}' top_farms_animals.id > temp_sum.txt #gets us just the amount of animals per each farm

#start of while loop
sum=0
line_number=0
while read -r value; do
    line_number=$((line_number + 1))
    sum=$((sum + value))
    echo "Current sum: $sum (Line: $line_number)"
    
    # Check if the sum has reached or exceeded 150000
    if [ "$sum" -ge 150000 ]; then
        echo "Sum reached 150000 or more at line $line_number. Stopping."
        break
    fi
done < temp_sum.txt > sum_response
    
head -95 top_farms_animals.id | awk '{print $2}' > top95_farms.id

sort top95_farms.id > top95_sorted.id

awk '{print $4, $0}' merged_filtered_data.txt |sort +0 -1 > sorted_filtered_data.txt

join -1 1 -2 1 top95_sorted.id sorted_filtered_data.txt > top95_farm_data.txt

