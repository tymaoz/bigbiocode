#!/usr/bin/perl
# pull-seqs-from-doc4fasta.pl
#pull fasta sequences from word file containing collection of candidate sequences and dat
use strict;
use warnings;

open (IN, "<$ARGV[0]") or die "Can't open IN file: $!";
open (OUT, ">$ARGV[1]") or die "Can't open OUT file: $!";

my $count = 0;
my $line = "";
my $fasta = 0;

while (<IN>) {
	chomp ($line = $_);
		
	if ($line =~ />/) {
		print OUT "$line\n";
		$count = 1;
		$fasta++;
		
			}

	elsif($count == 1 ){
		print  OUT "$line\n";
		$count = 2;
		}
	elsif ($count == 2 && $line =~ /[AGCT]/){
		print OUT  "$line\n";
		}
	if ($count == 2 && $line !~ /\S/){
		$count = 0;
		print "we just skipped a line and finished fasta file # $fasta\n";
				}
	else { next; }
		}	
close IN;
close OUT;
	
