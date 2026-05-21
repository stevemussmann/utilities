#!/bin/bash

# enter probe file name
PROBE="Sfo_GTseq242_ProbeSeqs_v2.1.csv"

# enter final output file name
OUT="p117_genos.csv"

# you don't need to change the commands file name
COMS="commands.txt"


# check if GNU parallel is installed and exit with an error if it is not.
if command -v parallel &> /dev/null; then
    echo "GNU parallel is installed."
else
    echo "GNU parallel is not installed."
	echo "run \"sudo apt-get install parallel\" to install."
	exit 1
fi

# delete commands file if it already exists
if [ -f $COMS ]
then
	rm $COMS
fi

# write GTseq_Genotyper_v3.pl commands to the $COMS file
for i in *.fastq
do 
	echo "GTseq_Genotyper_v3.pl $PROBE $i > ${i%.*}.genos" >> $COMS
done

# send GTseq_Genotyper_v3.pl commands to GNU parallel
cat $COMS | parallel

# run GTseq_GenoCompile_v3.pl
GTseq_GenoCompile_v3.pl > $OUT

exit
