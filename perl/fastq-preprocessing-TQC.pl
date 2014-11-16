#!/bin/bash/perl
#Fastq-Bowtie2-pipeline-mod.pl
#This is the modified script of the original Fastq-Bowtie2-pipeline-mod.pl script.
#This script has been modified such that it can continue with the bowtie2 alignment following
#a memory allocation error which caused the script to stop running after the sickle step.
#The original script is intended to read in the fastq files obtained from the sequencing center, 
#unzip them, catonate them, trim them according to their quality scores and align them 
#to a reference genome, generate bam and bai files for visualizing the coverage and then
#running a basic statistics package to look at the quality of the alignment.

use strict;
use warnings;

#system("module load samtools/0.1.18");
#system("module load bowtie2/2.1.0");
#system "module load bwa/0.7.4";
#system("module load sickle/1.0");
#system("module load cutadapt/1.2.1");

##################################################################
#Definitions
#my $input = "/home/labs/plant-sciences/yaelmaoz/TQA-TM-TS_Project/131126_SN808_0155_BD27N9ACXX/testdir";
#my $input = "/home/labs/plant-sciences/yaelmaoz/TQA-TM-TS_Project/131126_SN808_0155_BD27N9ACXX/Unaligned_fastq/";
my $input = "/data/data/yaelmaoz/TQA-TM-TS_Project/fastq/Aligned_fastq/Sample_TQ_C/";
my $OUTPUT = "./";
my $reference = "/home/labs/plant-sciences/yaelmaoz/TQA-TM-TS_Project";
my $sam = "aln-bt2_20140104_TQ-A-vs-wheatD-chrom.sam";
my $bam = "aln-bt2_20140104_TQ-A-vs-wheatD-chrom.bam";
my $bai = "aln-bt2_20140104_TQ-A-vs-wheatD-chrom.bai";
my $flagstat = "aln-bt2_20140104_TQ-A-vs-wheatD-chrom.flagstat";
my $threads = "12";
###################################################################

print "pwd";
system "pwd";

#opendir(DIR,$input) or die "couldn't open $input: $!\n";
#my @samples = grep { $_ ne '.' && $_ ne '..' } readdir DIR;;



#closedir(DIR);
#my @samples = "ls -1 $input";
#print @samples;
#print "\n";

=pod
my $index = "";
my $remainder = "";
##Identify the bowtie2 index name for running bowtie2
opendir(REF,$reference) or die "couldn't open $reference: $!\n";
my @ref = grep { /\.bt2$/ } readdir REF;
closedir(REF);
for ($ref[1]){
  ($index, $remainder) = split (/\./, $ref[1], 2);
	print "\n The index file being used is: $index\n";
}
=cut


my $fq1 = "fq1.fq";
my $fq2 = "fq2.fq";
my $fq_s = "fq_s.fq";

#foreach my $sample (@samples) {
#	chomp ($sample);
	my $sample = "TQ_C";
	my $out1 = "TQ_C_R1_all\.fastq";
	my $out2 = "TQ_C_R2_all\.fastq";
=pod	
	my $testgz = "$input/$sample/";
	opendir(SAM,$testgz) or die "can't open $testgz: $!\n";
	#	print "This is the testgz files: $testgz\n";
	my @file = grep { $_ ne '.' && $_ ne '..' } readdir SAM;
	#	print "$file[1]\n";
	if ( $file[1] =~ /\.gz$/ ){ #for compressed files;
	print "zcat $input/$sample/*R1* > $out1\n";
	system "zcat $input/$sample/*R1* > $out1\n";

	print "zcat $input/$sample/*R2* > $out2\n";
	system "zcat $input/$sample/*R2* > $out2\n";
	}
	
#	else { #for files which are not compressed;
	print "cat $input/$sample/*R1_all\.fastq > $out1\n";
	system "cat $input/$sample/*R1_all\.fastq > $out1\n";

	print "cat $input/$sample/*R2_all\.fastq > $out2\n";
	system "cat $input/$sample/*R2_all\.fastq > $out2\n";
#	}
=cut
	my @adaptors = ("-a AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGTAGATCTCGGTGGTCGCC", "-a GATCGGAAGAGCACACGTCTGAACTCCAGTCACCTTGTAATCTCGTATGC", "-a AGATCGGAAGAGCACACGTCTGAACTCCAGTCACCTTGTAATCTCGTATG",
                 "-a GATCGGAAGAGCACACGTCTGAACTCCAGTCACTGACCAATCTCGTATGC", "-a GATCGGAAGAGCACACGTCTGAACTCCAGTCACATCACGATCTCGTATGC", "-a GATCGGAAGAGCACACGTCTGAACTCCAGTCACCGATGTATCTCGTATGC",
"-a AGATCGGAAGAGCACACGTCTGAACTCCAGTCACCGATGTATCTCGTATG");


          print "time cutadapt @adaptors -O 30 --discard -m 50 $out1 -o  cutadapt_$out1\n";
          system "time cutadapt @adaptors -O 30 --discard -m 50 $out1 -o  cutadapt_$out1\n";

           print "time cutadapt @adaptors -O 30 --discard -m 50 $out2 -o  cutadapt_$out2\n";
          system "time cutadapt @adaptors -O 30 --discard -m 50 $out2 -o  cutadapt_$out2\n";

  print "time sickle pe -f cutadapt_$out1 -r cutadapt_$out2 -t sanger -o sickle_$out1 -p sickle_$out2 -s single_$sample.fastq -l 50 -x\n";
  system "time sickle pe -f cutadapt_$out1 -r cutadapt_$out2 -t sanger -o sickle_$out1 -p sickle_$out2 -s single_$sample.fastq -l 50 -x\n";

  #concatenate single, left and rigth files for trinity
#  print "cat sickle_$out1 >> $fq1\n";
#  print "cat sickle_$out2 >> $fq2\n";
#  print "cat  single_$sample.fastq >>  $fq_s\n";

#  system "cat sickle_$out1 >> $fq1\n";
#  system "cat sickle_$out2 >> $fq2\n";
#  system "cat  single_$sample.fastq >>  $fq_s\n";

=pod  
  #align reads to reference genome
  print "time bowtie2 -x $index -1 $fq1 -2 $fq2 -p $threads -S $sam\n";
  system "time bowtie2 -x $index -1 $fq1 -2 $fq2 -p $threads -S $sam\n";
  
  #samtools converts sam to bam and sorts the bam via a pipe
  print "time samtools view -bS $sam | samtools sort - $bam\n";
  system "time samtools view -bS $sam | samtools sort - $bam\n";
  
  #index the bam file
  print "time samtools index $bam $bai\n";
  system "time samtools index $bam $bai\n";
  
  #run the statistics of the alignment
  print "time samtools flatstat $bam > $flagstat\n";
  system "time samtools flagstat $bam > $flagstat\n";
=cut
#}

