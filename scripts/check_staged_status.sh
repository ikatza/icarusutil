# Simple tool to check the staging of a dataset

# Help message for usage instructions
if [[ $1 == "-h" ]] 
then
    echo ""
    echo "This script checks a definition to see how much of it is staged."
    echo "Usage:"
    echo "    check_staged_status.sh <DEFNAME> <SKIP LEVEL>"
    echo ""
    echo "Necessary Parameters:"
    echo "DEFNAME = samweb defintion name"
    echo ""
    echo "Optional parameters:"
    echo "SKIP LEVEL = number of files to skip over, meant to speed up a bit. Default=1"
    exit
fi

# Check skip level. If not used, set to 1.
skipLevel=$2
if [ -z $skipLevel ]
then
    skipLevel=1
fi

# Make sure a definition is given
checkDefname=$1
if [ -z $checkDefname ]
then
    echo "No definition given! Printing help (-h) message and exiting..."
    echo ""

    echo ""
    echo "This script checks a definition to see how much of it is staged."
    echo "Usage:"
    echo "    check_staged_status.sh <DEFNAME> <SKIP LEVEL>"
    echo ""
    echo "Necessary Parameters:"
    echo "DEFNAME = samweb defintion name"
    echo ""
    echo "Optional parameters:"
    echo "SKIP LEVEL = number of files to skip over, meant to speed up a bit. Default=1"
    exit
fi

echo ""
echo ""
echo -n "Testing staged status for definition: "
echo -n $1
echo -n " with skip level "
echo $skipLevel

# Check if a temp file already exists with the name
if [ -e check_staged_status_tmp_test_${1}.txt ]
then
    echo ""
    echo ""
    echo -n "The tmp file for this check, "
    echo -n check_staged_status_tmp_test_${1}.txt
    echo ", already exists. Please (re)move this file and try again."
    exit 1
fi

# Get the list of files
samweb -e icarus list-files "defname: $1" >> check_staged_status_tmp_test_${1}.txt

countOnlineAndNearline=0
totalFiles=0
checkedFiles=0

# Loop through files and check
echo ""
echo -n "Checking "
while read -r inFilename
do
    if [ $((${totalFiles}%10)) == 0 ]
    then
	echo -n "."
    fi
    if [ $((${totalFiles}%${skipLevel})) != 0 ]
    then
	totalFiles=$((${totalFiles}+1))
	continue
    fi
    # GET THE LOCATION FOR THE FILE
    fileloc=`samweb -e icarus locate-file $inFilename | grep enstore`
    enstorelocFirst=${fileloc#*enstore:}
    enstorelocSecond=${enstorelocFirst%(*}
    enstoreloc=${enstorelocSecond}/
    # CHECK THE STATUS
    status=`cat "${enstoreloc}.(get)(${inFilename})(locality)"`
    if [[ $status == *"ONLINE_AND_NEARLINE"* ]]
    then
	countOnlineAndNearline=$((${countOnlineAndNearline}+1))
    fi
    checkedFiles=$((${checkedFiles}+1))
    totalFiles=$((${totalFiles}+1))
done < check_staged_status_tmp_test_${1}.txt

# Print out the results
echo ""
echo ""
echo -n "Total Files: "
echo -n $totalFiles
echo -n " (Checked: "
echo -n $checkedFiles
echo -n ")"

fracStaged=$((${countOnlineAndNearline}/${checkedFiles}))

echo ""
echo -n "Of checked files, "
echo -n $countOnlineAndNearline
echo -n " staged ("
echo -n $((fracStaged*100))
echo "%)"

# Clean up the tmp file we generated
rm check_staged_status_tmp_test_${1}.txt