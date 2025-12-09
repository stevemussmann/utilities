#!/bin/bash

# Define variables used in ascp command
ASPERA_KEY="aspera.openssh" # enter path to aspera key file
SOURCE_FILE="cpm_upload/" # directory that you will upload to SRA
DIR="personal_ncbi_directory" # replace this with your directory assigned by NCBI
REMOTE_DEST="subasp@upload.ncbi.nlm.nih.gov:uploads/${DIR}"
MAX_RETRIES=100 # maximum number of retries
RETRY_DELAY=120 # delay between retries in seconds

for ((i=1; i<=MAX_RETRIES; i++)); do
    echo "Attempt $i of $MAX_RETRIES: Running ascp command..."
    ascp -i $ASPERA_KEY -QT -l100m -k1 -d $SOURCE_FILE $REMOTE_DEST
    
    # Check the exit status of the previous command ($?)
    if [ $? -eq 0 ]; then
        echo "transfer succeeded on attempt $i."
        exit 0 # Exit with success status
    else
        echo "transfer failed on attempt $i. Retrying in $RETRY_DELAY seconds..."
        sleep "$RETRY_DELAY"
    fi
done

echo "transfer failed after $MAX_RETRIES attempts. Exiting."

exit 1 # Exit with failure status

