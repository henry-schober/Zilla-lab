#Script to compare the top 30 bulls

sort +1 -2 -nr ebvs_CA_milk_famous | head -30 > ebvs_CA_milk_top30
sort +1 -2 -nr ebvs_NE_milk_famous | head -30 > ebvs_NE_milk_top30

sort +0 -1 ebvs_CA_milk_top30 > sorted_CA_milk
sort +0 -1 ebvs_NE_milk_top30 > sorted_NE_milk

join -1 1 -2 1 sorted_CA_milk sorted_NE_milk > ebvs_milk

wc -l ebvs_milk

#fat

sort +1 -2 -nr ebvs_CA_fat_famous | head -30 > ebvs_CA_fat_top30
sort +1 -2 -nr ebvs_NE_fat_famous | head -30 > ebvs_NE_fat_top30

sort +0 -1 ebvs_CA_fat_top30 > sorted_CA_fat
sort +0 -1 ebvs_NE_fat_top30 > sorted_NE_fat

join -1 1 -2 1 sorted_CA_fat sorted_NE_fat > ebvs_fat

wc -l ebvs_fat

#protein

sort +1 -2 -nr ebvs_CA_protein_famous | head -30 > ebvs_CA_protein_top30
sort +1 -2 -nr ebvs_NE_protein_famous | head -30 > ebvs_NE_protein_top30

sort +0 -1 ebvs_CA_protein_top30 > sorted_CA_protein
sort +0 -1 ebvs_NE_protein_top30 > sorted_NE_protein

join -1 1 -2 1 sorted_CA_protein sorted_NE_protein > ebvs_protein

wc -l ebvs_protein

