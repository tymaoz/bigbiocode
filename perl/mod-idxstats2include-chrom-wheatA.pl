#!/bin/bash/perl
#mod-header2include-chrom.pl
#This script is intended to read in a fasta file and a tab-delimited file and use the information from the tab-delimited file to modify the header.
#In this case, we are appending to the header (e.g. "scaffold671") the chromosome to which it has been mapped and the number of genes on this scaffold.

use strict;
use warnings;

open (DATA, "</data/yaelmaoz/TQA-TM-TS_Project/wheatA-scaffold-to-chromosome-bins.txt") or die "Could not open genome chromosome mapping data: $!\n";
#open (DATA, "<data.txt") or die "Could not open data file: $!\n";
open (IDXSTAT, "<$ARGV[0]") or die "Could not open $ARGV[0] Idxstat file: $!\n";
#open (IDXSTAT, "<aln-bt2_20140110_S2-A-vs-wheatA-chrom.idxstats.txt") or die "Could not open Idxstat file: $!\n";
#open (FASTA, "<fasta.txt") or die "Could not open test fasta file: $!\n";
my %hash;


while (<DATA>)
{
chomp;
	if ($_ =~ "scafold"){ #skip header - scafold is spelled incorrectly on purpose;
		next;
						}
	else {
		my ($scaf, $len, $chrom) = split /\t/;
		foreach ($scaf) {
			my $key = "$scaf";
			$hash{$key} = $chrom;
			}
		}
}

while (<IDXSTAT>){

my $line = $_;
	chomp ($line);
	my ($contig, $rest) = split /\t/;
		#print "$contig\n";
		if ( defined $hash{$contig} ) {
			print "$line \t $hash{$contig}\n";
			#print "$hash{$contig}\n";				}
		#else { print "$line \t N/A \n"; }
		}
				
}
