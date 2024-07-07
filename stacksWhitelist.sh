#!/bin/bash

# This utility script will pull the ids of loci that passed filter from the populations.snps.vcf file output from stacks
# I have only tested this on reference-aligned outputs of stacks

if [ $# -lt 2 ]
then

	echo "Usage: stacksWhitelist.sh <infile.vcf> <outfile.txt>"
	exit

fi

FILE=$1
OUT=$2

grep -v ^# $1 | awk '{print $3}' | awk -F":" '{print $1}' > $2

exit
