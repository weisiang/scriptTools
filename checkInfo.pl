#!/usr/bin/perl -w
use strict;
use GDBM_File;

#create at 2015/6/7 by weisiang.
# first argument is info fil.
# 2nd is 9000gdbm.
#3th is next_word gdbm file.
#4th is dbm.en
#5th is next_word txt file.

my $verbose = 1;
open(INFO , $ARGV[0]) or die "ERROR : can't open $ARGV[0]!";
dbmopen(my %phraseProb , $ARGV[1] , 0444) or die "ERROR : can't open $ARGV[1]!";
dbmopen(my %nextWordProb , $ARGV[2] , 0444) or die "ERROR : can't open $ARGV[2]!";
my $flag =0;
my $allPhrase ; my $combineNextWord; my $lastWord; my $score;
my $unk1 = `awk -F"\t" '{print \$2}' $ARGV[3] | sort -n |awk 'NR==1{printf  ("%f",log(exp(\$1)*0.01))}'`;
my $unk2 = `awk -F"\t" '{print \$2}' $ARGV[4] | sort -n |awk 'NR==1{printf  ("%f",log(exp(\$1)*0.01))}'`;
my $line=0;
print "unk1 = $unk1	unk2=$unk2\n";
while(<INFO>)
{
    my @targetLine;

    if($_=~'TRANSLATED AS:')
    {
        $flag++;
        if($flag == 1)
        {
			$line++;
			if($verbose == 1){print "Line ... $line\n"}
            @targetLine = split ': ' , $_;
            chomp $targetLine[1];
            $allPhrase = &trim($targetLine[1]);
			&getPhraseScore($allPhrase);

        }

        else
        {
            @targetLine = split ': ' , $_;
            chomp $targetLine[1];
            my @singleWord = split ' ' , &trim($targetLine[1]);

            $lastWord = $singleWord[0] ; 

            $combineNextWord=$allPhrase;
            $combineNextWord.=' ';
            $combineNextWord.=$lastWord;

            $allPhrase = &trim($targetLine[1]);
			&getPhraseScore($allPhrase);
			&getNextWordScore($combineNextWord);
        }

    } 

	if($_=~'core=')
	{
		my @coreLine = split / |,/ ,  $_;

		if( ($score -  $coreLine[11])>0.001 or ($score -  $coreLine[11])<-0.001)
		{print "not same!! $score	$coreLine[11]\n";}
		else{print "ok!!\n";}

	if($verbose == 1){print "\nTOTAL SCORE : $score\n\n";}
	$flag=0;	
	$score=0;
	}
}
close(INFO);

sub trim
{ 
	my $s;
	$s = shift ; $s=~s/\s+$//;  $s=~s/^\s+//;  
	return $s;
}

sub getPhraseScore
{
	my $s = shift ; my $getScoreFormDbm;
	if(!defined $phraseProb{$s})
	{
		chomp $unk1;
		$getScoreFormDbm = $unk1;
		$score +=$unk1;
	}
	else
	{
		$getScoreFormDbm = $phraseProb{$s} ;
		$score += $phraseProb{$s} ;
	}

    if($verbose == 1)
    {
		chomp $getScoreFormDbm;
		print "$s\t $getScoreFormDbm\n";
    }
}

sub getNextWordScore
{
	my $s = shift ; my $getScoreFormDbm;
	if(!defined $nextWordProb{$s})
	{
		chomp $unk2;
		$getScoreFormDbm = $unk2;
		$score +=$unk2;
	}
	else
	{
		$getScoreFormDbm = $nextWordProb{$s} ; 
		$score += $nextWordProb{$s} ;
	}
    if($verbose == 1)
    {
		print "$s\t$getScoreFormDbm\n";
    }
}
