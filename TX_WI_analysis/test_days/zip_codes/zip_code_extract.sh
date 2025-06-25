#this is going to be the script that gets us the zip codes from the herd test dates

state=$(cat "TX_WI.txt")
for x in $state
    do
        awk '{print $10}' phen_${x} | sort | uniq | awk '{print substr($1, 1, 8), $1}' > mgm_ids_${x}

        sort +0 -1 top200_farms_zips > sorted_zips_farms

        join -1 1 -2 1 mgm_ids_${x} sorted_zips_farms | awk '{print $1, substr($3, 1, 5), $2, substr($2, 10, 17)}' > mgm_zips_${x}
done

#outside of script

# cat mgm_zips_TX mgm_zips_WI > mgm_zips_all