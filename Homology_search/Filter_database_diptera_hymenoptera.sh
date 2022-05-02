#!/bin/bash
#SBATCH -J filter_db
#SBATCH --partition=normal
#SBATCH --time=15:00:00
#SBATCH -o /beegfs/data/soukkal/StageM2/Control_genomes/results/Viral_Homology_results/filter_db/filter.out
#SBATCH -e /beegfs/data/soukkal/StageM2/Control_genomes/results/Viral_Homology_results/filter_db/filter.error
#SBATCH --constraint=haswell
#SBATCH --exclude=pbil-deb27

#/beegfs/data/soukkal/TOOLS/mmseqs/bin/mmseqs createtaxdb /beegfs/data/sbarreto/db/UniRef90 tmp

/beegfs/data/soukkal/TOOLS/mmseqs/bin/mmseqs filtertaxseqdb /beegfs/data/sbarreto/db/UniRef90 /beegfs/data/soukkal/StageM2/Databases/UniRef90_nodiptera_nohymenoptera --taxon-list '!7147&&!7399'
echo "All diptera and hymenoptera removed from database"

