#!/bin/bash/perl
#catonate-fasta.pl
#

use strict;
use warnings;

open (IN, $ARGV[0]) or die "Cannot open $ARGV[0]: $!\n";

print ">TMC-Chr6-consensus\n";

while (<IN>){
	chomp;
	my $line = $_;
	if ($line =~ m/>/) {
		print "N" x 50;
		print "GATTACA";
		print "N" x 50;
		}
	else { 	print "$line"; 
		} 
	}


	

