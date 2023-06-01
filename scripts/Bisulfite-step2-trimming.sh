#!/bin/sh
#SWARM --threads-per-process 8 --gb-per-process 16

# load modules 
module load trimgalore fastqc

# get input files

FASTQ_1=$1
FASTQ_2=$2
LOGFILE=$3

# run samples

# Number of threads
NT=${SLURM_CPUS_PER_TASK}
MEM=${SLURM_MEM_PER_NODE}

echo NUMEBR OF THREADS = $NT
echo MEMORY PER NODE   = $MEM

echo Processing reads:
echo "### "$FASTQ_1
echo "### "$FASTQ_2

echo ""
echo "Sample start:"
TIMESTAMP=`date "+%Y-%m-%d %H:%M:%S"`
echo $TIMESTAMP
echo ""

#########################
### TRIMMING & FASTQC ###
#########################

DIR="02-trimming"

if [[ ! -d ${DIR} ]]; then
	mkdir -p -m 777 $DIR
fi

echo ""
echo "Trim galore report ..."

	trim_galore --cores 8 --paired --fastqc_args "--threads 4" -o $DIR $FASTQ_1 $FASTQ_2 > $LOGFILE 2>&1

echo ""
echo "Finished trimming..."
TIMESTAMP=`date "+%Y-%m-%d %H:%M:%S"`
echo $TIMESTAMP
echo ""
