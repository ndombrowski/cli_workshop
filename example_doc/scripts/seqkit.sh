#!/bin/bash
#SBATCH --job-name=seqkit
#SBATCH --output=logs/seqkit_%j.out
#SBATCH --error=logs/seqkit_%j.err
#SBATCH --cpus-per-task=1
#SBATCH --mem=5G
#SBATCH --time=01:00:00

echo "seqkit job started on:"
date

seqkit stats -b -a -T -o results/seqkit/stats_raw.txt data/seq_project/*/*gz --threads 1

echo "seqkit job finished on:"
date
