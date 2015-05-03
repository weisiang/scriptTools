#!/bin/bash -

read -ep "key in the EM path " emPath
read -ep "key in the EM method " emMethod

for((i=1 ; i<=20 ; i++))
do
	for((j=2 ; j<=7 ; j++))
	do
		folder=$emPath/$emMethod/9000.en.threshold$i/length_$j/
		cd $folder
		/home/nlp/tool/changeNdbmToGdbm.pl $folder/dbm.en.$j

		/home/nlp/tool/showGdm.pl $folder/9000gdbm |sort -n > temp_gdbm

		sort -n $folder/dbm.en.$j > temp_dbm
		diff temp_gdbm temp_dbm
		rm -rf temp_gdbm temp_dbm
done
done
