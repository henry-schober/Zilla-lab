#This script was used in Gaurav's test day

awk '{print $2, $3, $4, $5, $6, $7, $8, $9}' top95_farms_data.txt > top95_clean

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
}' "top95_clean" > "top95_added_effects.txt"

# Now lets split this data up and add the files to different directories based on the state

awk '$4~ /^35/' top95_added_effects.txt > ./WI/phen_WI

awk '$4~ /^74/' top95_added_effects.txt > ./TX/phen_TX
