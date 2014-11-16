#!/bin/bash
#run from path: /data/data/yaelmaoz/TQA-TM-TS_Project/

roots=(
1
2
)

for x in ${roots[@]}; do
echo Modifying headers

echo sed 's/@HISEQ/@TQA-HISEQ/g' TQA-vs-Tauschii/fq${x}.fq 

sed 's/@HISEQ/@TQA-HISEQ/g' TQA-vs-Tauschii/fq${x}.fq > tauschii-all-R${x}.fq

echo sed 's/@HWI/@TQCs-HWI/g' Small-Sequencing-Run-AAxQQ/Unaligned_fastq-1/Sample_TQ_C/sickle_Sample_TQ_C_R${x}.fastq 
 sed 's/@HWI/@TQCs-HWI/g' Small-Sequencing-Run-AAxQQ/Unaligned_fastq-1/Sample_TQ_C/sickle_Sample_TQ_C_R${x}.fastq >> tauschii-all-R${x}.fq

echo sed 's/@HWI/@TQDs-HWI/g' Small-Sequencing-Run-AAxQQ/Unaligned_fastq-2/Sample_TQ_D/sickle_Sample_TQ_D_R${x}.fastq 
 sed 's/@HWI/@TQDs-HWI/g' Small-Sequencing-Run-AAxQQ/Unaligned_fastq-2/Sample_TQ_D/sickle_Sample_TQ_D_R${x}.fastq >> tauschii-all-R${x}.fq

#echo gunzip ~/sickle/sickle_Sample_TQ_D_R${x}.fastq.gz 
# gunzip ~/sickle/sickle_Sample_TQ_D_R${x}.fastq.gz

echo sed 's/@HWI/@TQD-HWI/g'  ~/sickle/sickle_Sample_TQ_D_R${x}.fastq
 sed 's/@HWI/@TQD-HWI/g'  ~/sickle/sickle_Sample_TQ_D_R${x}.fastq >> tauschii-all-R${x}.fq

echo sed 's/@HWI/@TQC-HWI/g' TQC-vs-Tauschii/fq${x}.fq
 sed 's/@HWI/@TQC-HWI/g' ~/TQC-preprocessing/sickle_TQ_C_R${x}_all.fastq >> tauschii-all-R${x}.fq&

done

