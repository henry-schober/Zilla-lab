#This script was used in Gaurav's test day

awk '{print $2, $3, $4, $5, $6, $7, $8, $9}' top133_farms_data.txt > top133_clean

# Remove rows where dim_testday > 305 and add new columns: age_of_animal_in_years, herd_test_day, stage_of_lactation
awk 'BEGIN { FS=OFS=" " }
{
        # Calculate age of the animal in years (birth to calving)
        cmd = "echo $(( ($(date -d "$3" +%s) - $(date -d "$2" +%s)) / (365*86400) ))"
        cmd | getline age_of_animal_in_years
        close(cmd)

        # Calculate herd test day (adding dim_testday to calving date)
        cmd = "date -d \""$3" + "$7" days\" +%Y%m%d"
        cmd | getline herd_test_day
        close(cmd)

        # Calculate stage of lactation (divide into 10 groups)
        stage_of_lactation = int(1 + ($7 / 305 * 100 / 10))

        # Print original data along with the new columns
        print $0, age_of_animal_in_years, herd_test_day, stage_of_lactation
}' "top133_clean" > "top133_added_effects.txt"

#adding random animal effect (just their ID's from the crossreference)

awk ' NR > 2 {print}' crossreferences.txt | awk '{print $1, $2}' | sort +1 -2 > Xref_id

sort +0 -1 top133_added_effects.txt > sorted_top133_ae.txt

join -1 2 -2 1 Xref_id sorted_top133_ae.txt | awk '{print $1, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $2}' > top133_phen # 4024208 records



# Now lets split this data up and add the files to different directories based on the state

awk '$4~ /^35/' top133_phen > ./WI/phen_WI

awk '$4~ /^74/' top133_phen > ./TX/phen_TX
