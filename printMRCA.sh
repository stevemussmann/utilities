#!/bin/bash

grep -v "#" starbeast3.log | awk '{print $1"\t"$4019"\t"$4021"\t"$4023"\t"$4025"\t"$4027}' | column -t

exit
