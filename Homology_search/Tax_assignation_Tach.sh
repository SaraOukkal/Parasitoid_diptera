#!/bin/bash
#SBATCH -J Tax_assignation
#SBATCH --partition=bigmem
#SBATCH --cpus-per-task=20
#SBATCH --mem=220G
#SBATCH --time=72:00:00
#SBATCH -o /beegfs/data/soukkal/StageM2/Tachinids_genomes/results/Viral_Homology_results/Filter_loci/Taxonomy.out
#SBATCH -e /beegfs/data/soukkal/StageM2/Tachinids_genomes/results/Viral_Homology_results/Filter_loci/Taxonomy.error
#SBATCH --constraint="skylake|haswell|broadwell"
#SBATCH --exclude=pbil-deb27


/beegfs/data/soukkal/TOOLS/mmseqs/bin/mmseqs easy-taxonomy /beegfs/data/soukkal/StageM2/Tachinids_genomes/results/Viral_Homology_results/Viral_loci/Candidate_viral_loci_and_viral_protein.aa /beegfs/data/soukkal/StageM2/Databases/UniRef90_nodiptera_nohymenoptera /beegfs/data/soukkal/StageM2/Tachinids_genomes/results/Viral_Homology_results/Filter_loci/ /beegfs/data/soukkal/StageM2/Tachinids_genomes/results/Viral_Homology_results/Filter_loci/tmp_files --tax-lineage 1 --threads 20 

