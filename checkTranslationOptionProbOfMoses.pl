#!/usr/bin/perl -w 
use strict;
use GDBM_File;

open(TranslationOption , $ARGV[0]) or die "can't open $ARGV[0]!!";
dbmopen(my %hash , $ARGV[1] , 0444) or die "can't open $ARGV[1]!!";

my $mini=0;
while((my $key , my $value)=each %hash)
{
	if($value<$mini)
	{
		$mini=$value;
	}	
}
my $unk = log((exp $mini)*0.01);

while(<TranslationOption>)
{
	my @eachLine = split /\t/ , $_;
	my $word = $eachLine[0] ;
	my $txtProob = $eachLine[1];
	my $hashProb=0;
	if(!defined $hash{$word})
	{
		$hashProb = $unk;
	}
	else
	{
		 $hashProb = $hash{$word};
	}
	printf "%s\thash : %s\ttxt : %s\n", $word , $hashProb , $txtProob;
	if((abs($hashProb)-abs($txtProob)<0.01 and abs($hashProb)-abs($txtProob)>0)  or (abs($hashProb)-abs($txtProob)>-0.01 and abs($hashProb)-abs($txtProob)<0))
	{
		print "ok!!\n";
	}
	else
	{
		print "not same!!\n";
	}
	
}
