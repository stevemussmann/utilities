#!/bin/bash

for file in *.md5
do
	if md5sum -c $file
	then 
		echo "Match"
	else 
		echo "NO BUENO ${file%.md5}"
	fi
done

exit
