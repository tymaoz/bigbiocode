#!/bin/bash

echo Generating consensus sequences

#export PATH=$PATH:/home/username/bowtie2-2.1.0:/home/username/samtools:/home/username/samtools/bcftools:/home/username/samtools/misc

roots=(
aln-TMC-pe-bwa-mem-6A
)

for x in ${roots[@]}; do
#	echo Sam2Bam and sort ${x}
#  samtools view -Su "$x".sam | samtools sort - "$x".sorted
#        echo Piling up ${x}
 # samtools mpileup -A -uf WheatA/urartu6.fa "$x".sorted.bam | bcftools view -cg - > "$x".orphans.vcf
	echo VCFutils ${x} 
  perl ~/perl/vcfutils2fa.pl vcf2fq $x.orphans.vcf > $x.orphans.cons2.fa
#	echo MegaBlastn ${x}
#  blastn -db ../Triticum_aestivum.IWGSP1.22.cdna.all -query "$x".orphans.cons.fa -out "$x".orphans.cons.vs.TritAest.cdna.txt -evalue 1e-6 -max_target_seqs 10 -num_threads 5 -outfmt 7&
done 
