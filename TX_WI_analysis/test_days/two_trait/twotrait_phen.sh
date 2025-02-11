#this file is to be ran only to create the pheno file for two trait model

#texas in column 14
awk '{print $0, 0, $8}' phen_TX > TX_phen_2

#wisconsin in column 13
awk '{print $0, $8, 0}' phen_WI > WI_phen_2

cat WI_phen_2 TX_phen_2 > twotrait_phen_WI_TX