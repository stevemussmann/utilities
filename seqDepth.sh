#!/bin/bash

if [ $# -lt 2 ]
then

	echo "Usage: seqDepth.sh <infile> <outfile>"
	exit

fi

FILE=$1
OUT=$2

paste \
<(bcftools query -f '[%SAMPLE\t]\n' $FILE | head -1 | tr '\t' '\n') \
<(bcftools query -f '[%DP\t]\n' $FILE | awk -v OFS="\t" '{for (i=1;i<=NF;i++) if ($i != ".") {sum[i]+=1; dp[i]+=$i} } END {for (i in sum) print i, dp[i] / sum[i] }' | sort -k1,1n | cut -f 2) > $OUT

exit
