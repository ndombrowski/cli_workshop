#!/bin/bash
#SBATCH --job-name=fastp
#SBATCH --output=logs/fastp_%j.out
#SBATCH --error=logs/fastp_%j.err
#SBATCH --cpus-per-task=2
#SBATCH --mem=5G
#SBATCH --time=01:00:00

# Make conda available in the job, and activate the environment with fastp
source ~/.bashrc
conda activate fastp_1.4.0

# Make the output folder (no error if it already exists)
mkdir -p results/fastp

# Run fastp on the R1 and R2 file of each sample in samples.txt
for sample in $(cat samples.txt); do
    echo "Start fastp for: $sample"

    fastp \
        -i data/seq_project/*/${sample}_R1.fastq.gz \
        -I data/seq_project/*/${sample}_R2.fastq.gz \
        -o results/fastp/${sample}_R1.trimmed.fastq.gz \
        -O results/fastp/${sample}_R2.trimmed.fastq.gz \
        -h results/fastp/${sample}.html \
        -j results/fastp/${sample}.json \
        --thread 2
done

echo "fastp job finished on:"
date
