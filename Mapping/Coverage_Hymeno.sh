#!/bin/bash
#SBATCH -J Coverage
#SBATCH --partition=normal
#SBATCH --time=08:00:00
#SBATCH -o /beegfs/data/soukkal/StageM2/Hymenoptera_genomes/results/Mapping/Coverage.out
#SBATCH -e /beegfs/data/soukkal/StageM2/Hymenoptera_genomes/results/Mapping/Coverage.error

cd /beegfs/data/sbarreto/hrz/p/as_horizon-assembly_2020-11-10/tmp/dip_map/$1
samtools depth map.bam > /beegfs/data/soukkal/StageM2/Hymenoptera_genomes/results/Mapping/$1.cov
