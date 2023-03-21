#!/bin/bash

# counts the number of reads in each fq.gz file in a directory and outputs counts to a file named "readCounts.txt"

OUT="readCounts.txt"

echo -ne "" > $OUT

for file in *.gz
do
        num=$((`zcat $file | wc -l`/4))
        echo -ne ${file%.fq.gz} >> $OUT
        echo -ne "\t" >> $OUT
        echo $num >> $OUT
done

exit
