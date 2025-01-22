#!/bin/bash

#The purpose of this script is to create the phenotype file that we will use for the analysis, inlcuding the new columns of HTD, DIM stage, and age

while read line; do
    awk '$9=(((date -d "$3" +%s) - (date -d "$2" +%s)) / (365*86400))'
done < filtered_testday.txt


while read line; do
    echo $(((date -d "$3" +%s) - (date -d "$2" +%s)) / (365*86400))
done < filtered_testday.txt

while read line; do
    x=$(date -d "$3" +%s)
    y=$(date -d "$2" +%s)
    awk -v age=
done < filtered_testday.txt


while read line; do
    x=$(( ($(date +%s -d "$3")-$(date +%s -d "$2")) /(365*86400) ))
    awk -v age=$x '
    BEGIN{FS=OFS=" "} {
    print $0, age}'
done < filtered_testday.txt > filtered_testday2.txt

while read line; do
    x=$(echo $(( ($(date -d "$3" +%s) - $(date -d "$2" +%s)) / (365* 86400) )))
    awk -v age=$x '
    BEGIN{FS=OFS=" "} {
    $9=age}'
done < filtered_testday.txt > filtered_testday2.txt



while read line; do
    awk 'BEGIN { FS=OFS=" " }
    {
        age=$(echo $(( ($(date -d "$3" +%s) - $(date -d "$2" +%s)) / (365* 86400) )))
        print $0, age}'
    done < filtered_testday.txt > filtered_testday2.txt


echo $(( ($(date -d "$3" +%s) - $(date -d "$2" +%s)) / (365* 86400) )) filtered_testday.txt


