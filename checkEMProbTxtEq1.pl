#!/usr/bin/perl -w
use strict;

open(EMTxt , $ARGV[0]) or die "can open $ARGV[0]";
my $sum=0;
while(<EMTxt>)
{
	my @eachLine = split /\t/ , $_;
	$sum+=exp $eachLine[1];
}
printf "%s\n" , $sum;
