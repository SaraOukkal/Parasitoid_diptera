#!/bin/bash
#SBATCH -J Coverage
#SBATCH --partition=normal
#SBATCH --time=08:00:00
#SBATCH -o /beegfs/data/soukkal/StageM2/Control_genomes/results/Mapping/Coverage.out
#SBATCH -e /beegfs/data/soukkal/StageM2/Control_genomes/results/Mapping/Coverage.error

cd /beegfs/data/sbarreto/hrz/p/as_horizon-assembly_2020-11-10/tmp/dip_map/houghia_bivittata
samtools depth map.bam > /beegfs/data/soukkal/StageM2/Tachinids_genomes/results/Mapping/houghia_bivittata.cov

