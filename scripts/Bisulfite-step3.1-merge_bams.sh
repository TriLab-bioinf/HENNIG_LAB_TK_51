#!/bin/bash
#SBATCH --cpus-per-task=8

LOG=./00_logs/${SAMPLE}_${SLURM_JOB_ID}_merge.log

module load samtools/1.16.1 \

WORKING_DIR='03-bismark' \

samtools merge -f -n -r -O BAM \
    -@ 8 ./${WORKING_DIR}/${SAMPLE}.bismark_bt2_pe.bam \
    ./${WORKING_DIR}/${SAMPLE}.R1_val_1.part_00{1..5}_bismark_bt2_pe.bam > ${LOG} 2>&1


