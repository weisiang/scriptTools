#!/usr/bin/perl -w
use strict;
=begin
	first argument is nbest file
	2nd argument is hash table i.g. 9000.5
=cut
open(Nbest , $ARGV[0]) or die "can't open $ARGV[0]";

dbmopen( my %hash , $ARGV[1] , 0444) or die "can't open $ARGV[1]";
my $totalProb=0;
my $unk=0; my $mini=0;
while((my $key , my $value)=each %hash)
{
	if($value<=$mini){$mini=$value;}		
}
$unk=log((exp $mini)*0.01);	
printf "%s\n" , $unk;
while(<Nbest>)
{
	my @eachLine = split /\|\|\|/ , $_;
	#printf "%s\n" , $eachLine[1];
	my @txt = split /\s/ , $eachLine[1];
	#print @txt;
	chomp $eachLine[4];
	my @code = split /\s|=/ , $eachLine[4];
	#printf "%s\n" , $eachLine[4];
	my $word='';
	$totalProb=0;
	for(my $i=2 ; $i<=$#code ; $i+=2)
	{
		my @wordId = split /-/ , $code[$i];	
	
		#print $#wordId;
		for(my $j=0 ; $j<=$#wordId ; $j++)
		{
			$word .= $txt[$wordId[$j]+1].' ';
		}
		chomp $word; chop $word;	
	if(!defined $hash{$word})
	{
		$totalProb+=$unk;
	}
	else
	{
	$totalProb += $hash{$word};
	}
	$word='';
	}	
	my $nbestProb = $eachLine[2];
	my @eachProb = split /:|\s/ , $nbestProb;
	my @reduceProb = split $eachProb[12];

	printf "%s\t%s\t" , abs $totalProb ,abs $eachProb[12];
	if((abs($totalProb)-abs($eachProb[12])<0.01 and abs($totalProb)-abs($eachProb[12])>0)  or (abs($totalProb)-abs($eachProb[12])>-0.01 and abs($totalProb)-abs($eachProb[12])<0))
	{
		print "ok!!\n";
	}
	else{print "not same!!\n";}
}
