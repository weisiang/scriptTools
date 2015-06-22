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
	'lvalue|l=i' => \$Lvalue;
	'rvalue|r=i' => \$Rvalue;
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
	&match($corpusLine , $segLine);	
}





sub match
{
	my $corpusLineSplite = shift @_;
	my $segLineSplite = shift @_ ; 
	my @corpusLineSplite = split /\s+/ , $corpusLineSplite;
	my @segLineSplite = split /\s+/ , $segLineSplite ; 
#	printf "%s\n%s\n" , $corpusLineSplite , $segLineSplite;
#	printf "%s\n%s\n" , $corpusLineSplite[1] , $segLineSplite[1] ;
	
	
}


if($debugFlag)
{
	printf  STDERR"seg file :%s\ncorpus file :%s\n" 
			, $segFileName , $corpusFileName;
}
