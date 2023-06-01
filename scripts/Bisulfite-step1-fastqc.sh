#!/bin/sh

# load modules 
module load fastqc/0.11.5

# get input files
FASTQ_1=$1
FASTQ_2=$2
LOGFILE=$3

QCDIR="01-fastqc"

if [[ ! -d $QCDIR ]]; then
    mkdir -p -m 777 $QCDIR
fi    

# run samples

#  Number of threads 
NT=${SLURM_CPUS_PER_TASK}
MEM=${SLURM_MEM_PER_NODE}

echo NUMBER OF THREADS = $NT
echo MEMORY PER NODE = $MEM

echo Processing fastq files :
echo "### "$FASTQ_1
echo "### "$FASTQ_2
		
echo 
echo "Sample start:"
TIMESTAMP=`date "+%Y-%m-%d %H:%M:%S"`
echo $TIMESTAMP
echo 

##############################
### QUALITY CONTORL FASTQC ###
##############################

echo
echo "Fastqc report ..."

fastqc -t 4 -o $QCDIR $FASTQ_1 $FASTQ_2 > $LOGFILE 2>&1

echo ""
echo "Finished quality control..."
TIMESTAMP=`date "+%Y-%m-%d %H:%M:%S"`
echo $TIMESTAMP
echo
	
		
