if [[ -d $ICARUSCODE_VERSION ]]; then
  setup_icaruspro ${4} e17
fi

#clear all the text files
rm *.txt

#get list of files for respective stages
#ls -1 /pnfs/icarus/scratch/users/icaruspro/dropbox/mc1/poms_production/poms_icarus_prod_${3}_${4}${5}/${1} >& ${1}.txt; 
#ls -1 /pnfs/icarus/scratch/users/icaruspro/dropbox/mc1/poms_production/poms_icarus_prod_${3}_${4}${5}/${2} >& ${2}.txt
#ls -1 /pnfs/icarus/scratch/users/icaruspro/dropbox/mc1/poms_production/MCC1_poms_icarus_prod_${3}_${4}${5}/${1} >& ${1}.txt; 
#ls -1 /pnfs/icarus/scratch/users/icaruspro/dropbox/mc1/poms_production/MCC1_poms_icarus_prod_${3}_${4}${5}/${2} >& ${2}.txt
echo "/pnfs/icarus/scratch/users/icaruspro/dropbox/mc1/poms_production/MCC1_poms_icarus_prod_${3}_${4}${5}/${2}" 
#ls -1 /pnfs/icarus/scratch/icaruspro/poms_production/poms_icarus_prod_${3}_${4}${5}/${1} >& ${1}.txt; 
#ls -1 /pnfs/icarus/scratch/icaruspro/poms_production/poms_icarus_prod_${3}_${4}${5}/${2} >& ${2}.txt

#match each file uniquely to its ancestors
for l in `cat ${2}.txt`; do samweb file-lineage ancestors $l | tail -1 | awk '{$1=$1};1'; done >& ${2}_ancestors.txt; paste --delimiter=' ' ${2}_ancestors.txt ${2}.txt >& ${2}_and_ancestors.txt; 

#remove duplicates
sed '/^$/d' ${2}_and_ancestors.txt | awk '!a[$1]++' | awk '{print $2}' >& ${2}_files.txt

cp ${2}_files.txt  ${2}_${3}${5}_${4}.list

#prepare samweb definition for the list of unique files 
#ltot=`wc -l ${2}_files.txt | awk '{print $1}'`
#l0=`expr ${ltot} - 1`
#
#echo "Total files = ${ltot} (${l0})"
#sed -i "s/${2}/file_name '${2}/g" ${2}_files.txt
#sed -i "1,${l0}s/root/root' or/" ${2}_files.txt
#sed -i "${ltot}s/root/root'/" ${2}_files.txt


#create samweb definition
#samweb delete-definition poms_${2}_${3}_${4}${5}
#samweb create-definition poms_${2}_${3}_${4}${5} "`cat ${2}_files.txt`"

#don't forget to change the number of jobs to be submitted!
#Njobs=`samweb count-definition-files poms_${2}_${3}_${4}${5}`

#reminds the submitter
echo "Please include the following argument in the campaign editor for this campaign stage:"
echo "\t Dataset: poms_${2}_${3}_${4}${5}"
#echo "\t Osubmit.N=${Njobs}"
