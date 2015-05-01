#!/bin/bash -

path="/home/nlp/EM_LM_db_debug.en"
method="top"
folder="9000.en.threshold"
thresholdS="1"
thresholdE="20"
lengthS="2"
lengthE="7"

for((i=$thresholdS;i!=$thresholdE+1;i++))
do
	for((j=$lengthS;j!=$lengthE+1;j++))
	do
		cd $path/$method/$folder$i/length_$j
		ls | grep "debug" |xargs rm -rf
	done
done
