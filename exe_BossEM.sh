#!/bin/bash -

#this script created at 2015/3/17 by weisiang
#for auto training bosh both EM(top and sum).

cd /home/nlp/EM_Segment_sum
./auto_EM.sh < ./feed.txt
cd /home/nlp/EM_Segment_top
./auto_EM.sh < ./feed.txt 
