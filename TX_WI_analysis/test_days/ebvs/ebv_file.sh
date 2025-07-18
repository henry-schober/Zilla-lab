#these are the commands I am using to get the ebv file
#
#
awk '{print $8, $10}' renadd04.ped | awk '$1>80' > orig_ID_#D_TX

#same thing for WI
awk '{print $8, $10}' renadd04.ped | awk '$1>80' > orig_ID_#D_WI

sort +1 -2 orig_ID_#D_TX > sorted_#D_TX
sort +1 -2 orig_ID_#D_WI > sorted_#D_WI
#then join 
join -1 1 -2 2 high_acc_bull_id sorted_#D_TX > TX_ID_#D

join -1 1 -2 2 high_acc_bull_id sorted_#D_WI > WI_ID_#D

join -1 1 -2 1 WI_ID_#D TX_ID_#D > IDS_#D

#same thing for WI


join -1 1 -2 1 temp1 IDS_#D > ebvs_temp

awk '{print $1, $7, $8, $2, $4, $3, $6, $5}' ebvs_temp > ebv_final
