#!/bin/bash
#SBATCH -J filter_db
#SBATCH --partition=normal
#SBATCH --time=15:00:00
#SBATCH -o /beegfs/data/soukkal/StageM2/Control_genomes/results/Viral_Homology_results/filter_db/filter.out
#SBATCH -e /beegfs/data/soukkal/StageM2/Control_genomes/results/Viral_Homology_results/filter_db/filter.error


/beegfs/data/soukkal/TOOLS/mmseqs/bin/mmseqs filtertaxseqdb /beegfs/data/sbarreto/db/UniRef90 /beegfs/data/soukkal/StageM2/Databases/UniRef90_nodiptera --taxon-list '!7147'
echo "All diptera removed from database"

/beegfs/data/soukkal/TOOLS/mmseqs/bin/mmseqs filtertaxseqdb /beegfs/data/soukkal/StageM2/Databases/UniRef90_nodiptera /beegfs/data/soukkal/StageM2/Databases/UniRef90_nodiptera_nohymenoptera --taxon-list '!7399'
echo "All hymenoptera removed from database"


