### HENNIG_LAB_TK_51

The BS-seq pipeline is run with the script *run_BSseq_workflow.sh* as follows:
```
run_BSseq_workflow.sh <step number> [config file]
```
Where available step options are:

 1:   Run fastqc
 2:   Run trimming
 2.1: Run split-reads
 3:   Run bismark
 3.1: Merge bismark bam files
 4:   Deduplicate reads
 5:   Bismark_methylation_extractor

Each step requires the previous step to have been run successfully.  


