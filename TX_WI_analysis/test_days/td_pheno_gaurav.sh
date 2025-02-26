#This script was used in Gaurav's test day

for x in top_15_TX_data.txt top_5_WI_data.txt
        do
                prefix=$(echo "$x" | cut -d "." -f 1 )
                prefix2=$(echo "$prefix" | cut -d "_" -f 3 )
                awk '{print $2, $3, $4, $5, $6, $7, $8, $9}' ${x} > ${prefix}_clean

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
                }' "${prefix}_clean" > "${prefix}_added_effects.txt"

                #adding random animal effect (just their ID's from the crossreference)

                awk ' NR > 2 {print}' crossreferences.txt | awk '{print $1, $2}' | sort +1 -2 > Xref_id #get rid of Ho in xref

                sort +0 -1 ${prefix}_added_effects.txt > sorted_${prefix}

                join -1 2 -2 1 Xref_id sorted_${prefix} | awk '{print $1, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $2}' > phen_${prefix2} 

                cp phen_${prefix2} ./${prefix2}/.
        done

