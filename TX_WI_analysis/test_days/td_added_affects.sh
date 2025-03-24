#new script to added the added and fixed effects to the phenotype files

for x in top_122_TX_data.txt top_11_WI_data.txt
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
                    {
                    if ($7 >= 5 && $7 <= 35) {
                        stage_of_lactation = 1
                    } else if ($7 >= 36 && $7 <= 65) {
                        stage_of_lactation = 2
                    }else if ($7 >= 66 && $7 <= 95) {
                        stage_of_lactation = 3
                    }else if ($7 >= 96 && $7 <= 125) {
                        stage_of_lactation = 4
                    }else if ($7 >= 126 && $7 <= 155) {
                        stage_of_lactation = 5
                    }else if ($7 >= 156 && $7 <= 185) {
                        stage_of_lactation = 6
                    }else if ($7 >= 186 && $7 <= 215) {
                        stage_of_lactation = 7
                    }else if ($7 >= 216 && $7 <= 245) {
                        stage_of_lactation = 8
                    }else if ($7 >= 246 && $7 <= 275) {
                        stage_of_lactation = 9
                    }else if ($7 >= 276 && $7 <= 305) {
                        stage_of_lactation = 10
                    }
                    }

                    # Print original data along with the new columns
                    print $0, age_of_animal_in_years, herd_test_day, stage_of_lactation
            }' "${prefix}_clean" > "${prefix}_added_effects.txt"

            #adding random animal effect (just their ID's from the crossreference)

            awk ' NR > 2 {print}' crossreferences.txt | awk '{print $1, $2}' | sort +1 -2 > Xref_id #get rid of Ho in xref

            sort +0 -1 ${prefix}_added_effects.txt > sorted_${prefix}

            join -1 2 -2 1 Xref_id sorted_${prefix} | awk '{print $1, $3, $4, $5, $6, $7, $8, $9, $10, $5"_"$11, $12, $2}' > phen_${prefix2}_temp

            awk '{print $10}' phen_${prefix2}_temp | sort | uniq -c | awk '$1 >=4' | awk '{print $2}' | sort > HTD_4_${prefix2}

            sort +9 -10 phen_${prefix2}_temp > sorted_phen_${prefix2}

            join -1 1 -2 10 HTD_4_${prefix2} sorted_phen_${prefix2} | awk '{print $2, $3, $4, $5, $6, $7, $8, $9, $10, $1, $11, $12}' > phen_${prefix2}

            cp phen_${prefix2} ./${prefix2}/.
    done

