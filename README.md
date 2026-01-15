# utilities
random scripts for processing genetic data that don't fit in my other repositories

## missingData.sh
Returns the proportion of missing data per individual for a VCF file. Requires bcftools to be installed on your system. Command line arguments are position based, with the first position being the input file and the second being the output file. For example:
```
./missingData.sh input.vcf output.missing.txt
```

## seqDepth.sh
Similar to missingData.sh. Returns the sequencing depth per individual for a VCF file that includes the 'DP' field. Requires bcftools to be installed on your system. Command line arguments are position based, with the first position being the input file and the second being the output file. For example:
```
./seqDepth.sh input.vcf output.depth.txt
```

## findColumnNumbers.sh
Returns the column numbers from a large starbeast3 log file. For example, the following command would provide the column numbers of the columns pertaining to estimated node ages:
```
./findColumnNumbers.sh | grep mrca.age
```

## printMRCA.sh
Returns the content of only the desired columns from a large starbeast3 log file. Modify the numbers in the print statement to change the columns that are printed. The script can then be executed with:
```
./printMRCA.sh | less -S
```

## extractLeastMissing.pl
Returns a population map of the individuals from a vcf file that have the least missing data for each population. Requires output of missingData.sh as input parameter for `-f`. Script might malfunction if value set for `-s` is greater than the number of samples in the smallest population in data file.
```
./extractLeastMissing.pl -f missing.txt -m allSamples.map.txt
```

## countRestrictionCutSites.pl
Returns the number of times a restriction cut site appears in a genome, when given a genome in fasta format and a restriction cut site sequence (e.g., CTGCAG for PstI).
```
./countRestrictionCutSites.pl -f ReferenceGenome.fasta -r CTGCAG
```
## md5check.sh
Download this script to a folder containing a set of files and their md5 hashes. Run the script as shown below:
```
./md5check.sh
```

## popSumSeqStats.pl
Calculates summary stats per population for outputs of seqDepth.sh and missingData.sh scripts
```
./popSumSeqStats.pl -f missing.txt -m popmap.txt -o popMissing.txt
```
