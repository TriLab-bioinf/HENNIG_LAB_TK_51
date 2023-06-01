#!/usr/bin/bash

module load seqkit
READ_PATH=$1
SAMPLE=$2

seqkit split2 --force --threads 4 -p 5 -O ${READ_PATH}/${SAMPLE}_split \
        -1 ${READ_PATH}/${SAMPLE}.R1_val_1.fq.gz \
        -2 ${READ_PATH}/${SAMPLE}.R2_val_2.fq.gz
