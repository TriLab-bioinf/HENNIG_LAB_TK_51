#################################
### START THE SWARM JOB
#################################

source config.txt

# Enter sample prefix
SAMPLE=WT1_MG_L1

########################################
# 1) step1 - fastqc report (3hr/sample)
########################################

swarm --time 30:00:00  --sbatch "--export=SAMPLE=${SAMPLE},READ_PATH=${READ_PATH}" Bisulfite-step1-fastqc.swarm

########################################
# 2) step 2 - trimming and fastqc 
########################################

swarm --time 12:00:00 --sbatch "--export=SAMPLE=${SAMPLE}" Bisulfite-step2-trimming.swarm

########################################
# 2.1) Split trimmed fastq reads
########################################

# Enter path to trimmed-reads directory
READ_PATH=`pwd -P`/02-trimming

sbatch --cpus-per-task=4 Bisulfite-step2.1-split_fastq_reads.sh ${READ_PATH} ${SAMPLE}

########################################
# 3) step 3 - Bismark 
########################################

swarm --partition=norm -t 56 --time=100:00:00 --exclusive -g 32  -v 1 --sbatch "--constraint=x2695 --export=SAMPLE=${SAMPLE},READ_PATH=${READ_PATH}/${SAMPLE}_split" Bisulfite-step3-bismark_x5.swarm

########################################
# 3.1) Merge bismark prediction files 
########################################

swarm --sbatch "--export=SAMPLE=${SAMPLE}" Bisulfite-step3.1-merge_bams.swarm

########################################
# 4) step 4 - deduplicate 
########################################

swarm -f Bisulfite-step4-deduplicate.swarm -t 40 -g 80 --time 24:00:00 --sbatch "--export=SAMPLE=${SAMPLE}"

########################################
# 5) step 5 - Bismark_methylation_extractor.
########################################

swarm -f Bisulfite-step5-methylation_extractor.swarm -t 20 -g 40 --time 100:00:00 --sbatch "--export=SAMPLE=${SAMPLE}"


