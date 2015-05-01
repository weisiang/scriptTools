#!/usr/bin/perl -w
use strict;

dbmopen(my %compareSource , $ARGV[0] ,0644) or die "can't open the compare source hash table";
dbmopen(my %compareTarget , $ARGV[1] ,0644) or die "can;t open the compare targete hash table";

open (txt1 ,">>file");
open (txt2 ,">>file2");

foreach (sort keys %compareSource)
{
	printf	txt1 ("%s\t%s\n", $_ , $compareSource{$_});
}

foreach (sort keys %compareTarget)
{
	printf txt2 ("%s\t%s\n", $_ , $compareTarget{$_});
}

close(txt1);
close(txt2);
