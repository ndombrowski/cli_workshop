#!/bin/bash
#SBATCH --job-name=seqkit_trimmed
#SBATCH --output=logs/seqkit_trimmed_%j.out
#SBATCH --error=logs/seqkit_trimmed_%j.err
#SBATCH --cpus-per-task=1
#SBATCH --mem=5G
#SBATCH --time=01:00:00

echo "seqkit job started on:"
date

seqkit stats -b -a -T -o results/seqkit/stats_trimmed.txt results/fastp/*trimmed.fastq.gz --threads 1

echo "seqkit job finished on:"
date
