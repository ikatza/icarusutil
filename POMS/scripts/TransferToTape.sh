if [ ! -d  /pnfs/icarus/archive/sam_managed_users/icaruspro/data/mc/ ]; then
  mkdir /pnfs/icarus/archive/sam_managed_users/icaruspro/data/mc/
fi
if [ ! -d  /pnfs/icarus/archive/sam_managed_users/icaruspro/data/mc/$1 ]; then
  mkdir /pnfs/icarus/archive/sam_managed_users/icaruspro/data/mc/$1
fi 
if [ ! -d  /pnfs/icarus/archive/sam_managed_users/icaruspro/data/mc/$1/root ]; then 
  mkdir /pnfs/icarus/archive/sam_managed_users/icaruspro/data/mc/$1/root 
fi
if [ ! -d  /pnfs/icarus/archive/sam_managed_users/icaruspro/data/mc/$1/root/SBNworkshop2019 ]; then 
  mkdir /pnfs/icarus/archive/sam_managed_users/icaruspro/data/mc/$1/root/SBNworkshop2019 
fi

if [ ! -d /pnfs/icarus/archive/sam_managed_users/icaruspro/data/mc/$1/root/SBNworkshop2019/$2 ]; then
  mkdir /pnfs/icarus/archive/sam_managed_users/icaruspro/data/mc/$1/root/SBNworkshop2019/$2
fi
if [ ! -d /pnfs/icarus/archive/sam_managed_users/icaruspro/data/mc/$1/root/SBNworkshop2019/$2/MCC1.1 ]; then 
  mkdir /pnfs/icarus/archive/sam_managed_users/icaruspro/data/mc/$1/root/SBNworkshop2019/$2/MCC1.1
fi
if [ ! -d /pnfs/icarus/archive/sam_managed_users/icaruspro/data/mc/$1/root/SBNworkshop2019/$2/MCC1.1/v08_13_02 ]; then
  mkdir /pnfs/icarus/archive/sam_managed_users/icaruspro/data/mc/$1/root/SBNworkshop2019/$2/MCC1.1/v08_13_02
fi

for f in `ls -1 /pnfs/icarus/scratch/users/icaruspro/dropbox/mc1/poms_production/MCC1_poms_icarus_prod_$2_v08_13_02/$1/`; do
  if [ ! -e /pnfs/icarus/archive/sam_managed_users/icaruspro/data/mc/$1/root/SBNworkshop2019/$2/MCC1.1/v08_13_02/$f ]; then
    ifdh cp /pnfs/icarus/scratch/users/icaruspro/dropbox/mc1/poms_production/MCC1_poms_icarus_prod_$2_v08_13_02/$1/$f /pnfs/icarus/archive/sam_managed_users/icaruspro/data/mc/$1/root/SBNworkshop2019/$2/MCC1.1/v08_13_02/
  fi
  #run=`lar -c eventdump.fcl -s /pnfs/icarus/scratch/users/icaruspro/dropbox/mc1/poms_production/MCC1_poms_icarus_prod_$2_v08_13_02/$1/$f -n 1 | grep "subRun" | awk '{print $7}'`
  #echo "run number = $run"
  samweb add-file-location $f enstore:/pnfs/icarus/archive/sam_managed_users/icaruspro/data/mc/$1/root/SBNworkshop2019/$2/MCC1.1/v08_13_02
done
