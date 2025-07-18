#Script to preprocess the phenotype files to include Heat load and THI
#

#some pseudo code

awk '{
    if ($2 < 65) {
        $15 = 0
    } else {
        $15 = $2 - 65
    }
    print
}' OFS=' ' phen_WI_THI > phen_WI_test

# some more processing to make sure we have the correct reads

awk '$14>=0' phen_WI_season_test |  awk '$8>=5' > phen_WI_season_hl

