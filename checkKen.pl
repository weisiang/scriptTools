#!/usr/bin/perl -w
use strict;
use GDBM_File;

open(Ken , $ARGV[0]) or die "can't open $ARGV[0]!!";
dbmopen(my %hash , $ARGV[1] , 0444) or die "can't open  $ARGV[1]!!";

my $unk=0; my $mini=0;
while((my $key , my $value)=each %hash)
{
        if($value<=$mini){$mini=$value;}
}
$unk=log((exp $mini)*0.01);
printf "%s\n" , $unk;
my $prob=0 ; 
while(<Ken>)
{
	my @eachLine = split /::|\t/ , $_;
	my $txt = &trim($eachLine[0]);
	if(!defined $hash{$txt})
	{
		$prob = $unk	
	}
	else{$prob = $hash{$txt} ; }
	printf "%s\t%s\n" , $txt , $eachLine[2]; 
	
        if((abs($prob)-abs($eachLine[2])<0.01 and abs($prob)-abs($eachLine[2])>0)  or (abs($prob)-abs($eachLine[2])>-0.01 and abs($prob)-abs($eachLine[2])<0))
        {
                print "ok!!\n";
        }
        else{print "not same!!\n";}

}
sub trim
{
	my $s = shift ; $s=~s/\s+$//; return $s;
}
