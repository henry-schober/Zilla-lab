

# this script is to be ran after preprocessing.sh, this is to help us get the top farms

awk '{print $4}' merged_filtered_data.txt | sort | uniq -c | sort +0 -1 -nr > top_farms.ids #gets us the farm ids with how many records they have for Holsteins only

awk '{print $1, $4}' merged_filtered_data.txt | sort -u -k1,1 | awk '{print $2}' | sort | uniq -c | sort +0 -1 -nr > top_farms_animals.id #get us the farm ids with how many cows are at that farm, Holsteins only #ISSUE PROBLEM

awk '$2 ~ /^35/' top_farms_animals.id > top_WI.ids

awk '$2 ~ /^74/' top_farms_animals.id > top_TX.ids

awk '{print $1}' top_WI.ids > temp_sum_WI.txt #gets us just the amount of animals per each farm

awk '{print $1}' top_TX.ids > temp_sum_TX.txt #gets us just the amount of animals per each farm

awk '{print $4, $0}' merged_filtered_data.txt |sort +0 -1 > sorted_filtered_data.txt

#start of while loop

for x in temp_sum_WI.txt temp_sum_TX.txt
    do
        prefix=$(echo "$x" | cut -d "." -f 1 | cut -d "_" -f 3)
        sum=0
        line_number=0
        while read -r value; do
            line_number=$((line_number + 1))
            sum=$((sum + value))
            echo "Current sum: $sum (Line: $line_number)"
            
            # Check if the sum has reached or exceeded 180000
            if [ "$sum" -ge 180000 ]; then
                echo "Sum reached 180000 or more at line $line_number. Stopping."

                head "-$line_number" top_${prefix}.ids | awk '{print $2}' > top_${line_number}_${prefix}.id

                sort top_${line_number}_${prefix}.id > top_${line_number}_${prefix}_sorted.id

                grep -Fw -f top_${line_number}_${prefix}_sorted.id sorted_filtered_data.txt > top_${line_number}_${prefix}_data.txt
                break
            fi
        done < ${x} > sum_response_${prefix} 
done

    