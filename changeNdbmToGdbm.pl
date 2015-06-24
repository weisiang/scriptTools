#!/usr/bin/perl -w
use strict;
use GDBM_File;

dbmopen(my %hash , "9000gdbm" , 0644) or die "can't touch 100 dbm ";
open(NdbmFile , $ARGV[0] ) or die "can't open  $ARGV[0]!!";
while(<NdbmFile>)
{
	my	@eachline = split /\t/ , $_;
	if(!defined $hash{$eachline[0]})
	{
		$hash{$eachline[0]} = $eachline[1];
	}
	else
	{
		printf "%s\t%s", $eachline[0] ,$eachline[1];
	}
}
