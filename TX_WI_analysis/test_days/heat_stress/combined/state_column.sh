#just to add a column containing 35(WI) or 74(TX) 

awk '{
    if ($6 ~ /^74/) {
        $15 = 74 
    } else if ($6 ~ /^35/) {
        $15 = 35
    }
    print
}' OFS=' ' phen_all_season_hl > phen_all_combined_hl