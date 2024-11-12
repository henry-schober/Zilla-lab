#######################
##     README        ##
#######################

Project: Bruna analysis of Dairy Cows CA vs NE
Created by: Henry Schober 9/26/24
Modified by: Henry Schober 11/12/24

You are here: Single trait model of combined phenotypes of CA and NE

This directory contains the analysis of combining both the CA and NE diary cows into the same phenotype file for analysis

First lactation, Cows born after 2000

Workflow overview:
    1. First run ssd_phen_ca(ne)_1_10.sh in order to get the 10 different phenotype files containing ~40,000 animals form either ca or ne
    2. Run combining_phen.sh in order to combine the ca and ne files together for the analysis
    3. run ssd_phen_all_milk(or any other trait).sh in its respective trait directory in order to get the aireml_log files, MAKE SURE you copied over all of the phenotype files
    4. Run calc_mean_sd_2.sh in order to calculate average of variances for the combined traits 