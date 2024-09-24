#This script is going to be our script that we use in order to reduce the number of daughters used in our phenotype file

#The current issue is that we have too many daughters, CA has sires with 30,000 daughters there while only 2,0000 in NE, our goal is to make it so that the number of daughters is even with each other
#Therefore, we need to take at random from CA 2,000 daughters

#Use a while read loop


#this will get us a file of the orig ID's of daughters in CA combined with their renumbered sire IDs
join -1 1 -2 2 to_keep_all sorted_id_sire_CA > sire_ID_orig_ID_keep_all_CA

while read -r Ndaughter sireID
    do
        awk -v id="$sireID" '$1== id' sire_ID_orig_ID_keep_all_CA | shuf -n $Ndaughter >> output_sireIDs
done < famous_sires_ne

#Now we just combined the output_sireIDS with the phenotype file as it contains the original daughter IDS in column 2


