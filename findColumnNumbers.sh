#!/bin/bash

counter=0; for item in `grep -v "#" starbeast3.log | head -1`; do counter=$(($counter+1)); echo -ne $counter; echo -ne "\t"; echo $item; done;

exit
