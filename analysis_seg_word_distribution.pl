#!/usr/bin/perl -w
use strict;
use Getopt::Long;

my $fileName='';

Getopt::Long::GetOptions
(
	'file|f=s' => \$fileName,
);

open(File , "<$fileName") or die "can't open $fileName";

while(<File>)
{
	my $eachLine = $_;
	chomp $eachLine;
	my @eachLineSplite = split /\s+/ , $eachLine;
	for(my $i=0 ; $i<=$#eachLineSplite ; $i++)
	{
		if($i==0){print $eachLineSplite[$i]+1 ."\n";}
		else{
		print $eachLineSplite[$i] - $eachLineSplite[$i-1]."\n";
		}
	}
}
