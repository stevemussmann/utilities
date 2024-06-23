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
