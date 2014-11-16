#!/bin/bash

echo Generating consensus sequences

#export PATH=$PATH:/home/username/bowtie2-2.1.0:/home/username/samtools:/home/username/samtools/bcftools:/home/username/samtools/misc

roots=(
aln-TMC-pe-bwa-mem-6A
)

for x in ${roots[@]}; do
	echo Sam2Bam and sort ${x}
#  samtools view -Su "$x".sam | samtools sort - "$x".sorted
        echo Piling up ${x}
 # samtools mpileup -A -uf WheatA/urartu6.fa "$x".sorted.bam | bcftools view -cg - > "$x".orphans.vcf
	echo VCFutils ${x} 
 cat WheatA/urartu6.fa | vcf-consensus "$x".orphans.vcf > "$x"_cons.all.fa&
done 
