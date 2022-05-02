#!/bin/bash
#SBATCH -J fastq_dump
#SBATCH --partition=normal
#SBATCH --time=15:00:00
#SBATCH -o /beegfs/data/soukkal/StageM2/Hymenoptera_genomes/reads/fastq_dump.out
#SBATCH -e /beegfs/data/soukkal/StageM2/Hymenoptera_genomes/reads/fastq_dump.error

module load sratoolkit/2.9.0

fastq-dump $1 ---split-3 --skip-technical -outdir /beegfs/data/soukkal/StageM2/Hymenoptera_genomes/reads/
