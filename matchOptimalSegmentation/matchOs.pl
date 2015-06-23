#!/usr/bin/perl -w 
use strict;
use Getopt::Long;
use GDBM_File;

my $segFileName='';
my $corpusFileName='';
my $debugFlag=0;
my $Lvalue='0';
my $Rvalue='0';
my $PBLM='';
Getopt::Long::GetOptions
(
	'PBLM|P=s' => \$PBLM, 
	'seg|s=s' => \$segFileName,
	'corpus|c=s' => \$corpusFileName,
	'lvalue|l=i' => \$Lvalue,
	'rvalue|r=i' => \$Rvalue,
	'debug|d!' => \$debugFlag
);

dbmopen(my %matchSeg , "matchSeg" , 0644) or die "can't touch GDBM!";
dbmopen(my %PBLM , "$PBLM" , 0444) or die "can't open the DBM!";
open(corpusFile , "<$corpusFileName");
open(segFile , "<$segFileName");

my $lineCount=1;
while(<corpusFile>)
{
	my $corpusLine = $_;
	my $segLine = <segFile>;
	chomp $corpusLine;
	chomp $segLine;
	if($debugFlag){printf "%s\n%s\n", $corpusLine	, $segLine;}
	&phraseLength($corpusLine , $segLine , $lineCount);	
	$lineCount++;
}

&match();

sub phraseLength 
{
	my $corpusLine = shift @_;
	my $segLineSplite = shift @_ ; 
	my $lineCount = shift @_;
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
		&extract($length , $segLineSplite[$i] , $corpusLine , $lineCount);
	}
	
}

sub extract
{
	my $length = shift ; my $index = shift ; my $sentence = shift , my $lineCount = shift;
	chomp $sentence;
	my $phraseStart =  $index - $length + 1;
	my $phraseEnd = $index;
	
	
	my @sentenceSplite = split /\s+/ , $sentence ; 
	
	for(my $l=1 ; $l<=$length ; $l++)
	{
		for(my $i = $phraseStart ; $i <= $phraseEnd - $l +1 ; $i++)
		{
			my $outPhrase='';
		
			for(my $j = 0 ; $j<$l  ; $j++)
			{
				$outPhrase .= $sentenceSplite[$i+$j] . ' ';
			}
			chop $outPhrase;
			if($outPhrase ne '')
			{
				if(!defined $matchSeg{$outPhrase})
				{
					$matchSeg{$outPhrase} = 1;
				}
			}	
		}
	}
}

sub match
{
	foreach (keys %PBLM)	
	{
		my $PBLMPhrase = $_;
		while (my $seg =  keys %matchSeg)
		{
			if ($PBLMPhrase =~ $seg)	
			{
				printf "PBLM : %s\tSEG : %s\t prob : %s\n" , $PBLMPhrase , $seg , $PBLM{$PBLMPhrase};
				last;
			}
		}

	}
}









if($debugFlag)
{
	printf  STDERR"seg file :%s\ncorpus file :%s\n" 
			, $segFileName , $corpusFileName;
}
