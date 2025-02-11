#this is the renumf file to run the two trait analysis

ln -s /data/breno/ped.noupg .

ulimit -s unlimited
export OMP_STACKSIZE=1G

echo renum_2trait.par | renumf90 | tee renum_twotrait.log


#for aireml
echo "OPTION method VCE" >>  renf90.par
echo "OPTION use yams" >> renf90.par
echo "OPTION maxrounds 50" >> renf90.par
echo "OPTION se_covar_function H2d_WI G_4_4_1_1/(G_4_4_1_1+G_5_5_1_1+R_1_1)" >> renf90.par
echo "OPTION se_covar_function H2d_TX G_4_4_2_2/(G_4_4_2_2+G_5_5_2_2+R_2_2)" >> renf90.par
echo "OPTION se_covar_function rg12 G_4_4_1_2/(G_4_4_1_1*G_4_4_2_2)**0.5" >> renf90.par


ulimit -s unlimited
export OMP_STACKSIZE=128M

echo renf90.par  | blupf90+ | tee aireml_twotrait.log

cp aireml_twotrait.log aireml_log