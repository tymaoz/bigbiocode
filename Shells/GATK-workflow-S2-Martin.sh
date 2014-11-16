#!/bin/bash

#echo Generating consensus sequences

#export PATH=$PATH:/home/username/bowtie2-2.1.0:/home/username/samtools:/home/username/samtools/bcftools:/home/username/samtools/misc

roots=(
S2
)

#module load jdk
#module load GATK
#module load samtools
#module load bwa
#module load picard-tools

for x in ${roots[@]}; do
	#echo Map and Mark duplicates read group: @RG\tID:tauschiiALL\tSM:sample1\tPL:illumina\tLB:lib1\tPU:unit1
#	echo bwa mem -M -R '<read group info>' -p tauschii-chrom6 $x-R1.fq $x-R2.fq : $x.sam
	bwa mem -t 20 -M -R '@RG\tID:S2-all\tSM:sample1\tPL:illumina\tLB:lib1\tPU:unit1' 131201_BGI_wheat_A_D_combined_pseudochr.fasta ~/fastq/$x-all-R1.fastq.gz ~/fastq/$x-all-R2.fastq.gz > $x.sam
	echo SortSam
 java -Xmx10g -Djava.io.tmpdir=`pwd`/tmp -jar ~/picard-tools-1.110/SortSam.jar INPUT= $x.sam OUTPUT= $x.picard.sorted.bam SORT_ORDER=coordinate TMP_DIR=`pwd`/tmp
	echo MarkDuplicates
 java -Xmx10g -Djava.io.tmpdir=`pwd`/tmp -jar ~/picard-tools-1.110/MarkDuplicates.jar INPUT= $x.picard.sorted.bam OUTPUT= $x.picard.dedup.bam METRICS_FILE=metricsS2-Martin.txt TMP_DIR=`pwd`/tmp
	echo IndexBam - output *dedup.bai
 java -Xmx10g -jar ~/picard-tools-1.110/BuildBamIndex.jar INPUT= $x.picard.dedup.bam&
 ##	echo Add ReadGroups to BAM
 ##	java -Xmx4g -jar ~/picard-tools-1.110/AddOrReplaceReadGroups.jar INPUT=$x.sorted.bam OUTPUT=$x.withgroups.sorted.bam SORT_ORDER=coordinate RGID=TQD RGLB=TQD2013 RGPL=illumina RGPU=201310 RGSM=TQ-D RGCN=INCPM RGPI=100
#	echo 
#	echo Call Variants with GATK
#	echo Local Realignment around Indels
#	java -Xmx5g -Djava.io.tmpdir=`pwd`/tmp -jar GATK/GenomeAnalysisTK.jar -T RealignerTargetCreator -R 131201_BGI_wheat_A_D_combined_pseudochr.fasta -I $x.picard.dedup.bam -o $x.target_intervals.list
#	echo Realign at Targets near Indels
#	java -Xmx5g -Djava.io.tmpdir=`pwd`/tmp -jar GATK/GenomeAnalysisTK.jar -T IndelRealigner -R 131201_BGI_wheat_A_D_combined_pseudochr.fasta -I $x.picard.dedup.bam -targetIntervals $x.target_intervals.list -o $x.realignedBam.bam
#	echo Call Variants with GATK
#	java -Xmx5g -Djava.io.tmpdir=`pwd`/tmp -jar GATK/GenomeAnalysisTK.jar -T UnifiedGenotyper -R 131201_BGI_wheat_A_D_combined_pseudochr.fasta -I $x.realignedBam.bam -ploidy 2 -glm BOTH -stand_call_conf 30 -stand_emit_conf 10 -o $x.GATKvariants.vcf
#	echo Alternate Reference Maker
#	java -Xmx5g  -Djava.io.tmpdir=`pwd`/tmp -jar GATK/GenomeAnalysisTK.jar -T FastaAlternateReferenceMaker -l ERROR -R 131201_BGI_wheat_A_D_combined_pseudochr.fasta -o $x.gatk-cons.fa --variant $x.GATKvariants.vcf

#	java -Xmx4g -jar ~/../shays/GATK/GenomeAnalysisTK.jar -T UnifiedGenotyper -R ~/WheatD/tauschii-chrom6.2.fa -I $x.withgroups.sorted.bam -L 20 -ploidy 2 -glm BOTH -stand_call_conf 30 -stand_emit_conf 10 -o raw_TQD_GATKvariants.vcf
#	echo Alternate Reference Maker
#	java -Xmx4g -jar ~/../shays/GATK/GenomeAnalysisTK.jar -T FastaAlternateReferenceMaker -l ERROR -R ~/WheatD/tauschii-chrom6.2.fa -o TQD-chrm6.gatk-cons.fa --variant raw_TQD_GATKvariants.vcf&
########SAMTOOLS*PIPELINE################
#	echo Sam2Bam and sort ${x}
#  samtools view -Su "$x".sam | samtools sort - "$x".sorted
#        echo Piling up ${x}
#  samtools mpileup -A -uf WheatA/urartu6.fa "$x".sorted.bam | bcftools view -cg - > "$x".orphans.vcf
#	echo VCFutils ${x} 
#  perl ~/perl/vcfutils2fa.pl vcf2fq $x.orphans.vcf > $x.orphans.cons2.fa
#	echo MegaBlastn ${x}
#  blastn -db ../Triticum_aestivum.IWGSP1.22.cdna.all -query "$x".orphans.cons.fa -out "$x".orphans.cons.vs.TritAest.cdna.txt -evalue 1e-6 -max_target_seqs 10 -num_threads 5 -outfmt 7
done 
