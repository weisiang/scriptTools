#!/usr/bin/perl -w 
use strict;
use Getopt::Long;
use GDBM_File;

my $segFileName='';
my $corpusFileName='';
my $debugFlag=0;

Getopt::Long::GetOptions
(
	'seg|s=s' => \$segFileName,
	'corpus|c=s' => \$corpusFileName,
	'debug|d!' => \$debugFlag
);

open(corpusFile , "<$corpusFileName");
open(segFile , "<$segFileName");

while(<corpusFile>)
{
	my $corpusLine = $_;
	my $segLine = <segFile>;
	printf "%s%s", $corpusLine	, $segLine;
}








if($debugFlag)
{
	printf  STDERR"seg file :%s\ncorpus file :%s\n" 
			, $segFileName , $corpusFileName;
}
