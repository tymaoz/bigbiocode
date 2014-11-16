#!/bin/bash

echo Generating consensus sequences

#export PATH=$PATH:/home/username/bowtie2-2.1.0:/home/username/samtools:/home/username/samtools/bcftools:/home/username/samtools/misc

roots=(
TM-all-aligned_trimmed-reads_urartu6
)

for x in ${roots[@]}; do
#	echo unzip ${x}
#  gunzip $x.sam.gz
	echo SortSam
# java -Djava.io.tmpdir=`pwd`/tmp -jar picard-tools-1.110/SortSam.jar INPUT=$x.sam OUTPUT=$x.picard.sorted.bam SORT_ORDER=coordinate
	echo MarkDuplicates
# java -Djava.io.tmpdir=`pwd`/tmp -jar picard-tools-1.110/MarkDuplicates.jar INPUT=$x.picard.sorted.bam OUTPUT=$x.picard.dedup.bam METRICS_FILE=metricsTQall.txt
	echo IndexBam - output *dedup.bai
# java -Djava.io.tmpdir=`pwd`/tmp  -jar picard-tools-1.110/BuildBamIndex.jar INPUT=$x.picard.dedup.bam
 #	echo Add ReadGroups to BAM
 #	java -Xmx2g -jar ~/picard-tools-1.110/AddOrReplaceReadGroups.jar INPUT=$x.sorted.bam OUTPUT=$x.withgroups.sorted.bam SORT_ORDER=coordinate RGID=TMC RGLB=TMC2013 RGPL=illumina RGPU=201310 RGSM=TM-C RGCN=INCPM RGPI=100
#	echo Local Realignment around Indels
#	java -Xmx4g -jar GATK/GenomeAnalysisTK.jar -T RealignerTargetCreator -R ~/WheatA/urartu6.fa -I $x.picard.dedup.bam -o target_intervals.list
	echo Realign at Targets near Indels
	java -Xmx5g -Djava.io.tmpdir=`pwd`/tmp -jar GATK/GenomeAnalysisTK.jar -T IndelRealigner -R ~/WheatA/urartu6.fa -I $x.picard.dedup.bam -targetIntervals target_intervals.list -o $x.realignedBam.bam
	echo Call Variants with GATK
	java -Xmx5g -Djava.io.tmpdir=`pwd`/tmp -jar GATK/GenomeAnalysisTK.jar -T UnifiedGenotyper -R ~/WheatA/urartu6.fa -I $x.realignedBam.bam -ploidy 2 -glm BOTH -stand_call_conf 30 -stand_emit_conf 10 -o $x.GATKvariants.vcf
	echo Alternate Reference Maker
	java -Xmx5g -Djava.io.tmpdir=`pwd`/tmp -jar GATK/GenomeAnalysisTK.jar -T FastaAlternateReferenceMaker -l ERROR -R ~/WheatA/urartu6.fa -o $x.gatk-cons.fa --variant $x.GATKvariants.vcf&
########SAMTOOLS*PIPELINE################
#	echo Sam2Bam and sort ${x}
#  samtools view -Su "$x".sam | samtools sort - "$x".sorted
#        echo Piling up ${x}
 # samtools mpileup -A -uf WheatA/urartu6.fa "$x".sorted.bam | bcftools view -cg - > "$x".orphans.vcf
#	echo VCFutils ${x} 
#  perl ~/perl/vcfutils2fa.pl vcf2fq $x.orphans.vcf > $x.orphans.cons2.fa
#	echo MegaBlastn ${x}
#  blastn -db ../Triticum_aestivum.IWGSP1.22.cdna.all -query "$x".orphans.cons.fa -out "$x".orphans.cons.vs.TritAest.cdna.txt -evalue 1e-6 -max_target_seqs 10 -num_threads 5 -outfmt 7
done 
