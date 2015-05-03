#!/usr/bin/perl -w
use strict;
use GDBM_File;
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
printf "unk : %s\n" , $unk;
my $count=1;
while(<Nbest>)
{
	printf "number : %s\n" , $count;
	$count++;
	my @eachLine = split /\|\|\|/ , $_;
	my $trimTxt = &trim($eachLine[1]);
	printf "%s\n" , $trimTxt;
	my @txt = split /\s/ , $trimTxt;
	#print @txt;
	chomp $eachLine[4];
	my $trimAlignment = &trim($eachLine[4]);
	printf "%s\n" , $trimAlignment;
	my @code = split /\s|=/ , $trimAlignment;
	$totalProb=0;

	for(my $i=1 ; $i<=$#code ; $i+=2)
	{
	my $prob=0;
	my $word='';
	my @wordId=();
	@wordId = split /-/ , $code[$i];	
	
		printf "wordId last index : %s\n" , $#wordId;
		for(my $j=$wordId[0] ; $j<=$wordId[$#wordId] ; $j++)
		{
=begin
			printf "\$wordId[\$#wordId] : %s\n" , $wordId[$#wordId];
			print "j=$j\n" ;
			printf "txt : %s\n", $txt[$j] ;
=cut			
			$word .= $txt[$j] . ' ';
		}
		chomp $word; chop $word;	
	if(!defined $hash{$word})
	{
		$prob=$unk;
		$totalProb+=$unk;
	}
	else
	{
		$prob=$hash{$word};
	$totalProb += $hash{$word};
	}
		printf "%s\n" , $word;
		printf "%s\n" , $prob;
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
sub trim
{
	{ my $s = shift; $s =~ s/^\s+//;   return $s;    };
}
