#######################
##     README        ##
#######################

Project: Bruna analysis of Dairy Cows CA vs NE
Created by: Henry Schober 9/26/24
Modified by: Henry Schober 11/8/24

You are here: Single Trait model of CA or NE

The purpose of this directory is to streamline our analysis and clean our directories compared to those on the CDCB server.

The cows in this analysis are born after 2000, and we take only the first lactation

Workflow
  1. Make sure Pedigree files and Phenotype files were made from original phenotypes and pedigree directories.
  2. Run either Pheno_cgs.sh or cgs_pheno.sh, both work but cgs_pheno.sh is a script that includes a for loop so it makes all of the phenotypes_no_small files for both states, this loop script uses the par files with capital CA or NE
  3. Then run the ssd50k_pheno.sh script, changing the script depending on the trait and state, use the renum_ID_milk.par file for this script. Really no difference compared to other par file other than different ped file and variances
  4. Then run calc_mean_sd.sh script to grab the mean for the variances