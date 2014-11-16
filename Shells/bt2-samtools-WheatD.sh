#!/bin/bash

echo "loading modules"



module load python/2.7.2
module load samtools/0.1.18
module load sickle/1.0
module load bowtie2/2.1.0
module load cutadapt/1.2.1

echo "The script for bowtie2 alignment of TQ-SampleD against T.monococcum begins now."

time perl Fastq-Bowtie2-pipeline-bt2-TQ-D-vs-wheatA.pl  2>&1 > 20140116-bt2-aln-TQ-D-to-WheatA.log

echo "Alignment is complete. Check the 20140116-bt2-aln-TQ-D-to-WheatA.log file for more information."


