#!/usr/bin/bash
set -o errexit

if [[ -z $1 ]]; then
    echo Please enter one of the following options:          
    echo "###" 1: Run fastqc
    echo "###" 2: Run trimming
    echo "###" 2.1: Run split-reads
    echo "###" 3: Run bismark
    echo "###" 3.1: Merge bismark bam files
    echo "###" 4: Deduplicate reads
    echo "###" 5: Bismark_methylation_extractor
    exit
fi

STEP=$1

source config.txt

#################################
### START THE SWARM JOB
#################################

if [[ ! -z $2 ]]; then
    SAMPLE_FILE=$2
    echo '#####################################'
    echo Processing sample file ${SAMPLE_FILE}.
    echo '#####################################'
fi

# Make LOG_DIR if not present
if [[ ! -d ${LOG_DIR} ]]; then
    mkdir ${LOG_DIR}
fi    

for prefix in `cat ${SAMPLE_FILE}`; do

    # Enter sample prefix
    SAMPLE=${prefix}

    case ${STEP} in
        
        1)   
        ########################################
        # 1) step1 - fastqc report (3hr/sample)
        ########################################
        swarm  --logdir ${LOG_DIR} --job-name step1-fastqc
              --time 30:00:00 \
              --sbatch "--export=SAMPLE=${SAMPLE},READ_PATH=${READ_PATH},LOG_DIR=${LOG_DIR}" \
            ./scripts/Bisulfite-step1-fastqc.swarm
        ;;
        2)
        ########################################
        # 2) step 2 - trimming 
        ########################################
        swarm --logdir ${LOG_DIR} --job-name step2-trimming \
              --time 12:00:00 \
              --sbatch "--export=SAMPLE=${SAMPLE},READ_PATH=${READ_PATH},LOG_DIR=${LOG_DIR}" \
              ./scripts/Bisulfite-step2-trimming.swarm
        ;;
        2.1)
        ########################################
        # 2.1) Split trimmed fastq reads
        ########################################

        # Enter path to trimmed-reads directory
        READ_PATH=`pwd -P`/02-trimming
        sbatch --cpus-per-task=4 ./scripts/Bisulfite-step2.1-split_fastq_reads.sh ${READ_PATH} ${SAMPLE}
        ;;
        3)
        ########################################
        # 3) step 3 - Bismark 
        ########################################
        SPLIT_READS=./02-trimming/${SAMPLE}_split
        swarm --logdir ${LOG_DIR} --job-name bismark -v 1 --sbatch "--export=SAMPLE=${SAMPLE},SPLIT_PATH=${SPLIT_READS},LOG_DIR=${LOG_DIR}" \
              ./scripts/Bisulfite-step3-bismark_x5.swarm
        ;;
        3.1)
        ########################################
        # 3.1) Merge bismark prediction files 
        ########################################
        sbatch --export=SAMPLE=${SAMPLE} ./scripts/Bisulfite-step3.1-merge_bams.sh
        ;;
        4)
        ########################################
        # 4) step 4 - deduplicate 
        ########################################
        sbatch --export=SAMPLE=${SAMPLE} ./scripts/Bisulfite-step4-deduplicate.sh 
        ;;
        5)
        ########################################
        # 5) step 5 - Bismark_methylation_extractor.
        ########################################
        sbatch --export=SAMPLE=${SAMPLE} ./scripts/Bisulfite-step5-methylation_extractor.sh
        ;;
        *)
        echo Please enter one of the following options:
        echo "###" 1: Run fastqc
        echo "###" 2: Run trimming
        echo "###" 2.1: Run split-reads
        echo "###" 3: Run bismark
        echo "###" 3.1: Merge bismark bam files
        echo "###" 4: Deduplicate reads
        echo "###" 5: Bismark_methylation_extractor
        exit
        ;;        
    esac
done

