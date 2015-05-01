#!/bin/bash -
read -ep "key in the method of EM " method
read -ep "key in the source folder " sourceFolder
read -ep "key in the target folder " targetFolder
read -ep "key in the number of corpus " corpusAmount
read -ep "key in the language " language
read -ep "key in the threshold start " thresholdStart
read -ep "key in the threshold end " thresholdEnd
read -ep "key in the length start " lengthStart
read -ep "key in the length end " lengthEnd

for((i=$thresholdStart;i!=$thresholdEnd+1;i++))
do
	for((j=$lengthStart;j!=$lengthEnd+1;j++))
	do
		compare1="$sourceFolder/$method/$corpusAmount.$language.threshold$i/length_$j"
		compare2="$targetFolder/$method/$corpusAmount.$language.threshold$i/length_$j"
		#echo "$compare1/$corpusAmount.5"
		#echo "$compare2/$corpusAmount.5"
		sort $compare1/dbm.$language.$j > $compare1/dbm.$language.$j.sort
		sort $compare2/dbm.$language.$j > $compare2/dbm.$language.$j.sort
		echo "txt***threshold=$i	length=$j"
		diff $compare1/dbm.$language.$j.sort $compare2/dbm.$language.$j.sort
		rm $compare1/dbm.$language.$j.sort $compare2/dbm.$language.$j.sort

		echo "HASH***threshold=$i	length=$j"
		./check_dbm_hash.pl $compare1/$corpusAmount.5 $compare2/$corpusAmount.5	
		diff ./file ./file2
		rm file file2
	done
done
