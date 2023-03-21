#!/bin/bash

# downloads genome from genbank when provided the URL. e.g.:
# ./downloadGenome.sh https://ftp.ncbi.nlm.nih.gov/genomes/genbank/vertebrate_other/Squalius_cephalus/latest_assembly_versions/GCA_022829025.1_ASM2282902v1/

PTH=`echo $1 | sed 's/https/rsync/g'`

SPEC=`echo $PTH | awk -F"/" '{print $7}'`
GBNK=`echo $PTH | awk -F"/" '{print $9}'`

mkdir -p $SPEC/$GBNK

rsync --copy-links --recursive --times --verbose $PTH $SPEC/$GBNK/

exit
