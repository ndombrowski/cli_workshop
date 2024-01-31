#!/bin/bash
#SBATCH --cpus-per-task=2
#SBATCH --mem=5G

echo "Start fastqc"

fastqc data/seq_project/*/*gz -o results/fastqc  --threads 1

echo "fastqc finished"
