#!/bin/bash
#SBATCH --partition=norm --cpus-per-task=20 --mem=40g --time=100:00:00
set -o errexit

module load bismark samtools

if [[ ! -z $1 ]]; then
    SAMPLE=$1
fi

LOG=./00_logs/STEP_5_${SAMPLE}_${SLURM_JOB_ID}.log

echo '##############################################################################'
echo Running job ${SLURM_JOB_ID} for sample ${SAMPLE}
echo '##############################################################################'

cd ./03-bismark

bismark_methylation_extractor -p --no_overlap --comprehensive --gzip --bedGraph --cytosine_report --genome_folder /vf/db/bismark/mm10/ --parallel 8 ../04-filter_dedup/${SAMPLE}.bismark_bt2_pe.nonCG_filtered.paired_only.deduplicated.bam > ../${LOG} 2>&1

touch ${SAMPLE}_${SLURM_JOB_ID}_bm_meth_extr_OK.flag

# Copy reports to current working dir
cp ../04-filter_dedup/${SAMPLE}.*_report.txt .

bismark2report
touch ${SAMPLE}_${SLURM_JOB_ID}_bm_report_OK.flag

bismark2summary
touch ${SAMPLE}_${SLURM_JOB_ID}_bm_summary_OK.flag


