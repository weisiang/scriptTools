#!/usr/bin/perl -w
use strict;
use GDBM_File;

my $countFileT="9000_count_EMT"; #log formate.
my $countFileG="9000_count_EMG"; #exp formate.
my $denominator ="9000_count_denominator_EMG"; #exp formate.
my $nextWord ="9000_EM_NextWord_EMG"; #log formate. max value is 0.

system ("rm -rf $countFileT $denominator $nextWord $countFileG");
system ("/home/nlp/tool/showNdbm.pl 9000_count.5> $countFileT");

open(countFileT , $countFileT) or die "can't open countFileT !!";
dbmopen(my %denominator , $denominator , 0644) or die "can't touch $denominator gdbm file!!" ; 
dbmopen(my %nextWord , $nextWord , 0644) or die "can't touch $nextWord gdbm file!!" ; 
dbmopen(my %countFileG , $countFileG , 0644) or die "can't touch $countFileG gdbm file!!" ; 

while(<countFileT>)
{
	my @splitEachLine = split /\t/ , $_;
	chomp $splitEachLine[1];
        chop $splitEachLine[1];	
	$countFileG{$splitEachLine[0]}= exp $splitEachLine[1];
}
seek(countFileT , 0, 0);

while(<countFileT>)
{
	my $history = '';
	my @splitEachLine = split /\t/ , $_;
	my @splitTxt = split /\s+/ , $splitEachLine[0];

	chomp $splitEachLine[1];
	chop $splitEachLine[1];

	if($#splitTxt>=1)
	{
		for(my $i=0 ; $i!=$#splitTxt ;$i++)
		{
			$history.=$splitTxt[$i].' ';
		}
		my $afterTrim = &trim($history);
		
		if(!defined $denominator{$afterTrim})
		{
			$denominator{$afterTrim} = $countFileG{$splitEachLine[0]};
		}
		else
		{
			$denominator{$afterTrim} += $countFileG{$splitEachLine[0]};

		}
		#printf "%s\t%s\t%s\n" , $splitEachLine[0] , log $countFileG{$splitEachLine[0]} , log $denominator{$afterTrim};
	}
}

seek(countFileT , 0, 0);
while(<countFileT>)
{
	my $history ='';
	my @splitEachLine = split /\t/ , $_;
	my @splitTxt = split /\s+/ , $splitEachLine[0];
	chomp $splitEachLine[1];
	chop $splitEachLine[1];
	if($#splitTxt>=1)
        {
                for(my $i=0 ; $i!=$#splitTxt ;$i++)
                {
                        #printf "txt : %s\n" , $splitTxt[$i];
                        #printf "size : %s\n" , $#splitTxt;
                        $history.=$splitTxt[$i].' ';
                }
                my $afterTrim = &trim($history);

                if(!defined $denominator{$afterTrim})
                {
			print "not defined!!\n";
                }
                else
                {
			my $bigram;
			$bigram = $countFileG{$splitEachLine[0]} / $denominator{$afterTrim};
			$nextWord{$splitEachLine[0]} = log $bigram;

                }
        }
	
	
}
system("/home/nlp/tool/showGdbm.pl 9000_EM_NextWord_EMG > 9000_EM_NextWord_EMT");

sub trim
{
	my $s = shift; $s=~ s/\s+$//; 
	return $s;
}
