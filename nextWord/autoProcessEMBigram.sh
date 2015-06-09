#!/bin/bash -

read -ep "key in the EM path " emPath
read -ep "key in the EM method " emMethod

for((i=1 ; i<=20 ; i++))
do
	for((j=2 ; j<=7 ; j++))
	do
		folder=$emPath/$emMethod/9000.en.threshold$i/length_$j/
		cd $folder

        /home/nlp/tool/nextWord/processEMBigram.pl

done
done
