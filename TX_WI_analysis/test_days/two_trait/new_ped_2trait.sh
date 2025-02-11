#this is to create the new ped for two trait


ln -s /data/breno/ped.noupg .
ln -s /data/breno/ped.noupg.sort .

ulimit -s unlimited
export OMP_STACKSIZE=1G

echo renum_2trait.par | renumf90 | tee renum_twotrait.log

awk '{print $10}' renadd04.ped | sort > ids.reduced.sort
join -1 1 -2 1 ids.reduced.sort /data/breno/ped.noupg.sort > new_ped_2trait

