#!/usr/bin/perl -w
use strict;
use GDBM_File;

dbmopen(my %hash , $ARGV[0] , 0666) or die "can't touch gdbm file!!" ; 
%hash=();
