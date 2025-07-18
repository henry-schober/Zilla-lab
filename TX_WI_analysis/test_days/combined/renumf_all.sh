#new script to do the combined renums and phen

cat ../TX/dim_season/phen_TX_season ../WI/dim_season/phen_WI_season > phen_TX_WI_season

ln -s /data/breno/ped.noupg.sort .


ulimit -s unlimited
export OMP_STACKSIZE=1G

echo renum_all.par | renumf90 | tee renum_all.log

echo "OPTION method VCE" >>  renf90.par
echo "OPTION use yams" >> renf90.par
echo "OPTION se_covar_function H2d G_4_4_1_1/(G_4_4_1_1+G_5_5_1_1+R_1_1)" >> renf90.par


ulimit -s unlimited
export OMP_STACKSIZE=128M

echo renf90.par  | blupf90+ | tee aireml_all.log

cp aireml_all.log aireml_log