#!/bin/sh
#$ -S /bin/sh
set -o errexit

module load bismark

DIR=03-bismark
if [[ ! -d $DIR ]]; then
    mkdir -p -m 777 $DIR
fi

FASTQ1=$1
FASTQ2=$2
SAMPLE=$3
LOG_DIR=$4
LOG=${LOG_DIR}/${SAMPLE}.${SLURM_JOB_ID}.bismark.log

echo '##############################################################################'
echo Running job ${SLURM_JOB_ID} for sample ${SAMPLE}
echo '##############################################################################'

# NON DIRECTIONAL
#time bismark   --unmapped --non_directional -p 3 -n 1 --parallel 4  --temp_dir . --output_dir .  /fdb/bismark/mm10/ -1 ${FASTQ1} -2 ${FASTQ2} > ${LOG} 2>&1

# DIRECTIONAL
bismark -p 3 -n 1 --parallel 4 --temp_dir /lscratch/${SLURM_JOB_ID}/ --output_dir ${DIR} /fdb/bismark/mm10/ -1 ${FASTQ1} -2 ${FASTQ2} > ${LOG} 2>&1

touch ./${DIR}/${SAMPLE}_${SLURM_JOB_ID}_bismark_OK.flag

# _R1_001_val_1.part_001.fq.gz1
