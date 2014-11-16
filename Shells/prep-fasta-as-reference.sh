#!/bin/bash

echo Preparing a FASTA file to use as a reference for GATK downstream processing

roots=(
WheatD/tauschii-chrom6.2
)

for x in ${roots[@]}; do

echo Creating the .dict file using Picard CreateSequenceDictionary.jar

java -jar picard-tools-1.110/CreateSequenceDictionary.jar R=$x.fa O=$x.2.dict

echo Creating the fasta index file

samtools faidx $x.fa&

done

