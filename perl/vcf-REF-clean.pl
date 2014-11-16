#!/bin/bash/perl
#VCR-REF-clean.pl
#

use strict;
#use FileHandle;
use warnings;

#my $VCF = $ARGV[0]
#my $fh = new FileHandle;

open (IN, "<$ARGV[0]") or die ("Cannot open $ARGV[0]: $!\n");
while(<IN>) {
	chomp;
	if(/^\#/) {print; next;}
	my @c = split(/\t/);
	my $REF = $c[3];
	if ($REF =~ m/^:/){
		$REF =~ s/://;
		print;
		}
	else { print; }
	}




