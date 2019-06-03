if [[ -d $ICARUSCODE_VERSION ]]; then
  setup_icaruspro ${4} e17
fi

#clear all the text files
rm *.txt

#get list of files for respective stages
ls -1 /pnfs/icarus/scratch/users/icaruspro/dropbox/mc1/poms_production/MCC1_poms_icarus_prod_${3}_${4}${5}/${1} >& ${1}.txt; 
ls -1 /pnfs/icarus/scratch/users/icaruspro/dropbox/mc1/poms_production/MCC1_poms_icarus_prod_${3}_${4}${5}/${2} >& ${2}.txt
echo "/pnfs/icarus/scratch/users/icaruspro/dropbox/mc1/poms_production/MCC1_poms_icarus_prod_${3}_${4}${5}/${2}" 

cp ${2}.txt ${2}_${3}${5}_${4}_orig.list
 
#match each file uniquely to its ancestors
for l in `cat ${2}.txt`; do samweb file-lineage ancestors $l | tail -1 | awk '{$1=$1};1'; done >& ${2}_ancestors.txt; paste --delimiter=' ' ${2}_ancestors.txt ${2}.txt >& ${2}_and_ancestors.txt; 

#remove duplicates
sed '/^$/d' ${2}_and_ancestors.txt | awk '!a[$1]++' | awk '{print $2}' >& ${2}_files.txt
cp ${2}_files.txt  ${2}_${3}${5}_${4}.list

## get duplicated files 
## create a list of files to be deleted
diff ${2}_${3}${5}_${4}_orig.list ${2}_${3}${5}_${4}.list | grep '<' | awk '{print "/pnfs/icarus/scratch/users/icaruspro/dropbox/mc1/poms_production/MCC1_poms_icarus_prod_'${3}'_'${4}''${5}'/'${2}'/"$2}' >&  delete_${2}_${3}${5}_${4}.list
# create source script for samweb to delete the files
samweb list-definition-files poms_${2}_${3}_${4}${5} >&  ${2}_${3}${5}_${4}_orig2.list
sort -i ${2}_${3}${5}_${4}_orig2.list > ${2}_${3}${5}_${4}_orig_sorted2.list 
sort -i ${2}_${3}${5}_${4}.list > ${2}_${3}${5}_${4}_sorted2.list 
diff ${2}_${3}${5}_${4}_orig_sorted2.list ${2}_${3}${5}_${4}_sorted2.list | grep '<' | awk '{print "samweb remove-file-location " $2 " dcache:/pnfs/icarus/scratch/users/icaruspro/dropbox/mc1/poms_production/MCC1_poms_icarus_prod_'${3}'_'${4}''${5}'/'${2}'/"}' >&  remove-loc_${2}_${3}${5}_${4}2.sh
# delete files physically
rm -f `cat delete_${2}_${3}${5}_${4}.list`
# remove location from the metadata
. remove-loc_${2}_${3}${5}_${4}2.sh
# clear the remove location script 
rm remove-loc_${2}_${3}${5}_${4}2.sh

#create samweb definition w/ current files 
samweb delete-definition poms_${2}_${3}_${4}${5}
samweb create-definition poms_${2}_${3}_${4}${5} "full_path 'dcache:/pnfs/icarus/scratch/users/icaruspro/dropbox/mc1/poms_production/MCC1_poms_icarus_prod_${3}_${4}${5}/${2}'"

#reminds the submitter
echo "Please include the following argument in the campaign editor for this campaign stage:"
echo "\t Dataset: poms_${2}_${3}_${4}${5}"
#get the summary
samweb list-files --summary "defname:poms_${2}_${3}_${4}${5}" > summary_poms_${2}_${3}_${4}${5}.log
mv summary_poms_${2}_${3}_${4}${5}.log the_summary_poms_${2}_${3}_${4}${5}.log
