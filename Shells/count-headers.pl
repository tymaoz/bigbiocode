#!/bin/bash/perl

use strict;
use warnings;

open (IN, "<tauschii-all-R2.fq") or die "Can't open file: $!\n";
open (OUT, ">headers-all-R2.txt") or die "Can't open file: $!\n";

my $TQA = 0;
my $TQD = 0;
my $TQC = 0;
my $TQDs = 0;
my $TQCs = 0;

while (<IN>){
	chomp;
	my $line = $_;
	if ($line =~ m/^\@T/ ) { #pull headers only;
		my @h = split (/-/, $line); #split header to examine sample;
		if ( $h[0] =~ "\@TQA" ) { $TQA++; print OUT "$line\n"; }
		if ( $h[0] =~ "\@TQCs" ) { $TQCs++; print OUT "$line\n"; }
		if ( $h[0] =~ "\@TQC" ) { $TQC++; print OUT "$line\n"; }
		if ( $h[0] =~ "\@TQDs" ) { $TQDs++; print OUT "$line\n"; }
		if ( $h[0] =~ "\@TQD" ) { $TQD++; print OUT "$line\n"; }
		}
	else { next; }
	}
print "Read counts for R2: TQA = $TQA \t TQC = $TQC \t TQD = $TQD \t TQCs = $TQCs \t TQDs = $TQDs \n";

	
	
