#run blupf90+ without the VCE option
#get fsmou bull ids

awk '$8>100'  renadd04.ped | awk '{print $1,$10}' | sort +0 -1 > famous_xref

#get all ebvs

awk '$2==4' solutions | awk '{print $3,$4}' | sort +0 -1 > ebvs

#join ebvs and famous bulls

join -1 1 -2 1 famous_xref ebvs | awk '{print $2,$3}' | sort +0 -1 > famous_ebv_TX

#repeat from Wisconsin

join -1 1 -2 1 famous_ebv_TX famous_ebv_WI > famous_ebv_all #if you only have 45 in this one, 
#lets decrease number of daughters until we have about 100 bulls with a minimum of 30 daughters 
