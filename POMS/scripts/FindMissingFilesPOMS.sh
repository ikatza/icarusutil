if [[ -d $ICARUSCODE_VERSION ]]; then
  setup_icaruspro ${4} e17
fi

#clear all the text files
rm *.txt

#get list of files for respective stages
ls -1 /pnfs/icarus/scratch/users/icaruspro/dropbox/mc1/poms_production/MCC1_poms_icarus_prod_${3}_${4}${5}/${1} >& ${1}.txt; 
ls -1 /pnfs/icarus/scratch/users/icaruspro/dropbox/mc1/poms_production/MCC1_poms_icarus_prod_${3}_${4}${5}/${2} >& ${2}.txt
#ls -1 /pnfs/icarus/persistent/icaruspro/poms_production/poms_icarus_prod_${3}_v08_10_01${5}/${1} >& ${1}.txt 
#ls -1 /pnfs/icarus/persistent/icaruspro/poms_production/poms_icarus_prod_${3}_${4}${5}/${2} >& ${2}.txt
#match each file uniquely to its ancestors
for l in `cat ${2}.txt`; do samweb file-lineage parents $l | tail -1 | awk '{$1=$1};1'; done >& ${2}_parents.txt; 
#for l in `cat ${2}.txt`; do samweb file-lineage ancestors $l | tail -1 | awk '{$1=$1};1'; done >& ${1}_ancestors.txt; paste --delimiter=' ' ${1}_ancestors.txt ${1}.txt >& ${1}_and_ancestors.txt 

#sort the files for finding missing files
sort -i ${1}.txt >& ${1}_sorted.txt
sort -i ${2}_parents.txt >& ${2}_parents_sorted.txt
diff ${1}_sorted.txt ${2}_parents_sorted.txt | grep '<' | awk '{print $2}' >& ${2}_missing_files.txt 

#prepare samweb definition for the list of unique files 
ltot=`wc -l ${2}_missing_files.txt | awk '{print $1}'`
l0=`expr ${ltot} - 1`
sed -i "s/${1}/file_name '${1}/" ${2}_missing_files.txt
sed -i "1,${l0}s/root/root' or/" ${2}_missing_files.txt
sed -i "${ltot}s/root/root'/" ${2}_missing_files.txt

#create samweb definition
samweb delete-definition poms_missing_${1}_${3}_${4}${5}
samweb create-definition poms_missing_${1}_${3}_${4}${5} "`cat ${2}_missing_files.txt`"
#
#don't forget to change the number of jobs to be submitted!
Njobs=`samweb count-definition-files poms_missing_${1}_${3}_${4}${5}`
#
##reminds the submitter
echo "Please include the following argument in the campaign editor for this campaign stage:"
echo "\t Dataset: poms_missing_${1}_${3}_${4}${5}"
echo "\t Osubmit.N=${Njobs}"
