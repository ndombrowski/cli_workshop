#!/bin/bash
#SBATCH --job-name=seqkit_job
#SBATCH --output=logs/seqkit_%j.out
#SBATCH --error=logs/seqkit_%j.err
#SBATCH --cpus-per-task=2
#SBATCH --mem=5G

#activate dependencies
source ~/.bashrc
mamba activate seqkit_2.6.1

#run seqkit
echo "Start seqkit"

seqkit stats -a -To results/seqkit/seqkit_stats.tsv data/seq_project/*/*.gz --threads 2

echo "seqkit finished"

