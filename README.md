# utilities
random scripts for processing genetic data that don't fit in my other repositories

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
