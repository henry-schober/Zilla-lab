## This file is to help figure out how the two trait analysis works Guarav.

Theres two specific scripts, one that is denoted the first half and one
denoted second half. The reason behind this is that they are both from our
very original SSD script, just split in half as you only need to run the first
half ONCE, and use the same output files for all three traits. The second
script is the most important as it contains the renumf and blupf90 commands. I
also added the parameter file that you would want to use for the renumf. Let
me know if there are any questions

## DR Fragomeni info

UPDATE FOR FRAGOMENI
    - The current main analysis script is ssd50k loop, second half, two trait. This was the main script that we used to get my original two trait analysis values
    - The ssd100k_loop script is the newest script we tried working on which included the phen files containing 40k animals from both CA and NE, this script produced our latest results
    - The most important part of the two trait par files is to remember that milk is column 19(NE) and 22(CA), fat 20(NE) and 23(CA), protein 21(NE) and 24(CA) in the phenotype files.
    - The pheno_all_clean.sh combines the Ne_phen and CA_phen data and also formats it so that it can be used in the two trait analysis.
    - Like the other analysis, the calc_twotrait scripts should be ran last in order to get the means, make sure you are using the correct log files