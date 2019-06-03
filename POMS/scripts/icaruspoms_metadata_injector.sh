#!/bin/bash
 
#Take in all of the arguments
while :; do
    case $1 in
        -h|-\?|--help)
            show_help    # Display a usage synopsis.
            exit
            ;;
        --inputfclname)       # Takes an option argument; ensure it has been specified.
            if [ "$2" ]; then
                INPUTFCLNAME="$2"
                shift
            else
                echo "$0 ERROR: inputfclname requires a non-empty option argument."
                exit 1
            fi
            ;;

        --mdfiletype)       # Takes an option argument; ensure it has been specified.
            if [ "$2" ]; then
                MDFILETYPE="$2"
                shift
            else
                echo "$0 ERROR: mdfiletype requires a non-empty option argument."
                exit 1
            fi
            ;;
        --mdfclname)       # Takes an option argument; ensure it has been specified.
            if [ "$2" ]; then
                MDFCLNAME="$2"
                shift
            else
                echo "$0 ERROR: mdfclname requires a non-empty option argument."
                exit 1
            fi
            ;;
        --mdprojectname)       # Takes an option argument; ensure it has been specified.
            if [ "$2" ]; then
                MDPROJECTNAME="$2"
                shift
            else
                echo "$0 ERROR: mdprojectname requires a non-empty option argument."
                exit 1
            fi
            ;;
        --mdprojectstage)       # Takes an option argument; ensure it has been specified.
            if [ "$2" ]; then
                MDPROJECTSTAGE="$2"
                shift
            else
                echo "$0 ERROR: mdprojectstage requires a non-empty option argument."
                exit 1
            fi
            ;;
        --mdprojectsoftware)       # Takes an option argument; ensure it has been specified.
            if [ "$2" ]; then
                MDPROJECTSOFTWARE="$2"
                shift
            else
                echo "$0 ERROR: mdprojectsoftware requires a non-empty option argument."
                exit 1
            fi
            ;;
        --mdproductionname)       # Takes an option argument; ensure it has been specified.
            if [ "$2" ]; then
                MDPRODUCTIONNAME="$2"
                shift
            else
                echo "$0 ERROR: mdproductionname requires a non-empty option argument."
                exit 1
            fi
            ;;
        --tfilemdjsonname)       # Takes an option argument; ensure it has been specified.
            if [ "$2" ]; then
                TFILEMDJSONNAME="$2"
                shift
            else
                echo "$0 ERROR: tfilemdjsonname requires a non-empty option argument."
                exit 1
            fi
            ;;
#
#        --file=?*)
#            file=${1#*=} # Delete everything up to "=" and assign the remainder.
#            ;;
#        --file=)         # Handle the case of an empty --file=
#            echo 'ERROR: "--file" requires a non-empty option argument.'
#            ;;
        -v|--verbose)
            verbose=$((verbose + 1))  # Each -v adds 1 to verbosity.
            ;;
        --)              # End of all options.
            shift
            break
            ;;
        -?*)
            printf "$0 WARN: Unknown option (ignored): %s\n" "$1" >&2
            ;;
        *)               # Default case: No more options, so break out of the loop.
            break
    esac
    shift
done

if [ -z "$INPUTFCLNAME" ]; then
  echo "$0 ERROR: inputfclname is mandatory"
  exit 2
fi

if [ -z "$MDFILETYPE" ]; then
  echo "$0 ERROR: mdfiletype is mandatory"
  exit 2
fi

if [ -z "$MDFCLNAME" ]; then
  echo "$0 ERROR: mdfclname is mandatory"
  exit 2
fi

if [ -z "$MDPROJECTNAME" ]; then
  echo "$0 ERROR: mdprojectname is mandatory"
  exit 2
fi

if [ -z "$MDPROJECTSTAGE" ]; then
  echo "$0 ERROR: mdprojectstage is mandatory"
  exit 2
fi

if [ -z "$MDPROJECTSOFTWARE" ]; then
  echo "$0 ERROR: mdprojectsoftware is mandatory"
  exit 2
fi

if [ -z "$MDPRODUCTIONNAME" ]; then
  echo "$0 ERROR: mdproductionname is mandatory"
  exit 2
fi

#Start the injection
echo -e "\n#Metadata injection by $0" >> $INPUTFCLNAME
echo "services.FileCatalogMetadataIcarus.FCLName: \"$MDFCLNAME\"" >> $INPUTFCLNAME
echo "services.FileCatalogMetadataIcarus.ProjectName: \"$MDPROJECTNAME\"" >> $INPUTFCLNAME
echo "services.FileCatalogMetadataIcarus.ProjectStage: \"$MDPROJECTSTAGE\"" >> $INPUTFCLNAME
echo "services.FileCatalogMetadataIcarus.ProjectSoftware: \"$MDPROJECTSOFTWARE\"" >> $INPUTFCLNAME
echo "services.FileCatalogMetadataIcarus.ProductionName: \"$MDPRODUCTIONNAME\"" >> $INPUTFCLNAME
#only include the TFile metadata json production if the name of the json has been specified
if [ "$TFILEMDJSONNAME" ]; then
  echo "services.TFileMetadataIcarus: @local::icarus_file_catalog_tfile" >> $INPUTFCLNAME
  echo "services.TFileMetadataIcarus.JSONFileName: \"$TFILEMDJSONNAME\"" >> $INPUTFCLNAME
  echo "services.TFileMetadataIcarus.GenerateTFileMetadata: true" >> $INPUTFCLNAME
fi
