#This script isn't meant to be run, its just somewhere I put my command line one liners in order to remember what I did


#goal of next couple of lines is to get the bulls that have genetic information from the renadd file, and then out of these bulls, only take high accuracy ones (80+ daughters)

#genotyped if have >10 in 6th column of renadd file
awk '$6 >= 10' renadd06.ped > gen_renadd

#high accuracy bulls
awk '$8>=80' gen_renadd > high_acc_gen_bulls #in TX we only get 514 high accuracy bulls, 834 in WI


