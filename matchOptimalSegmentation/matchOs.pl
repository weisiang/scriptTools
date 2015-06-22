#!/usr/bin/perl -w 
use strict;
use Getopt::Long;
use GDBM_File;

my $segFileName='';
my $corpusFileName='';
my $debugFlag=0;
my $Lvalue='0';
my $Rvalue='0';
Getopt::Long::GetOptions
(
	'seg|s=s' => \$segFileName,
	'corpus|c=s' => \$corpusFileName,
	'lvalue|l=i' => \$Lvalue,
	'rvalue|r=i' => \$Rvalue,
	'debug|d!' => \$debugFlag
);

open(corpusFile , "<$corpusFileName");
open(segFile , "<$segFileName");

while(<corpusFile>)
{
	my $corpusLine = $_;
	my $segLine = <segFile>;
	chomp $corpusLine;
	chomp $segLine;
	if($debugFlag){printf "%s\n%s\n", $corpusLine	, $segLine;}
	&phraseLength($corpusLine , $segLine);	
}

sub phraseLength 
{
	my $corpusLineSplite = shift @_;
	my $segLineSplite = shift @_ ; 
	my @segLineSplite = split /\s+/ , $segLineSplite ; 
	my $length;

	for(my $i=0 ; $i<=$#segLineSplite ; $i++)
	{
		if($#segLineSplite==0){$length = $segLineSplite[0]+1;} #NF==1.
		else #NF >= 2.
		{
			if($i==0)
			{
				$length = $segLineSplite[$i]+1;
			}
			else
			{
				$length = $segLineSplite[$i] -$segLineSplite[$i-1];
			}
		}
		&extract($length , $segLineSplite[$i] , $corpusLineSplite);
	}
	
}

sub extract
{
	my $length = shift ; my $index = shift ; my $sentence = shift ;

}











if($debugFlag)
{
	printf  STDERR"seg file :%s\ncorpus file :%s\n" 
			, $segFileName , $corpusFileName;
}
