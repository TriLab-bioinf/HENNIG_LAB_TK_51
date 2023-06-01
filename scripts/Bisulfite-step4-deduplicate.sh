#!/bin/bash
#SBATCH --cpus-per-task=32 --mem=64g --time=24:00:00
set -o errexit

module load bismark samtools

#SAMPLE=$1
WORKING_DIR=04-filter_dedup
INPUT_DIR=03-bismark

echo '##############################################################################'
echo Running job ${SLURM_JOB_ID} for sample ${SAMPLE}
echo '##############################################################################'

if [[ ! -d ${WORKING_DIR} ]]; then
    mkdir -m 777 ${WORKING_DIR}
fi    

#filter_non_conversion -p ./${INPUT_DIR}/${SAMPLE}.bismark_bt2_pe.bam #_R1_001_val_1_bismark_bt2_pe.bam

# Remove single-end reads after filtering step above 
#samtools view -@ 30 -h ./${INPUT_DIR}/${SAMPLE}.bismark_bt2_pe.nonCG_filtered.bam | ./scripts/remove_single_reads_from_filtered_bam.pl > ./${WORKING_DIR}/${SAMPLE}.tmp.sam

#samtools view -@ 30  -hb ${WORKING_DIR}/${SAMPLE}.tmp.sam  > ./${WORKING_DIR}/${SAMPLE}.bismark_bt2_pe.nonCG_filtered.paired_only.bam

#deduplicate_bismark --bam -p ./${WORKING_DIR}/${SAMPLE}.bismark_bt2_pe.bam

rm -f ${WORKING_DIR}/${SAMPLE}.tmp.sam
deduplicate_bismark --bam -p ./${WORKING_DIR}/${SAMPLE}.bismark_bt2_pe.nonCG_filtered.paired_only.bam --output_dir ${WORKING_DIR}

touch ./${WORKING_DIR}/${SAMPLE}_${SLURM_JOB_ID}_dedup_OK.flag

