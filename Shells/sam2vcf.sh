#!/bin/bash

echo Generating consensus sequences

#export PATH=$PATH:/home/username/bowtie2-2.1.0:/home/username/samtools:/home/username/samtools/bcftools:/home/username/samtools/misc

roots=(
S2A-vpoly6
)

for x in ${roots[@]}; do
	echo Sam2Bam and sort ${x}
  samtools view -Su "$x".sam | samtools sort - "$x".sorted
	echo Index Bam
  samtools index "$x".sorted.bam  
	echo Stats for ${x} alignment to virtual polyploid
  samtools flagstat "$x".sorted.bam
      echo Piling up ${x}
  samtools mpileup -A -uf virtual-polyploid-chr6.fa "$x".sorted.bam | bcftools view -cg - > "$x".orphans.vcf&
done 
