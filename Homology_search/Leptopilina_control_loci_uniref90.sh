#!/bin/bash
#SBATCH -J mmseqs_search
#SBATCH --partition=normal
#SBATCH --cpus-per-task=10
#SBATCH --time=01:00:00
#SBATCH -o /beegfs/data/soukkal/StageM2/Hymenoptera_genomes/results/Viral_Homology_results/Control_test/Blast.out
#SBATCH -e /beegfs/data/soukkal/StageM2/Hymenoptera_genomes/results/Viral_Homology_results/Control_test/Blast.error
#SBATCH --constraint=haswell
#SBATCH --exclude=pbil-deb27

#Créer BDD query 
/beegfs/data/soukkal/TOOLS/mmseqs/bin/mmseqs createdb /beegfs/data/soukkal/StageM2/Hymenoptera_genomes/results/Viral_Homology_results/Control_test/run_mmseqs2_2/Leptopilina_loci.faa /beegfs/data/soukkal/StageM2/Hymenoptera_genomes/results/Viral_Homology_results/Control_test/run_mmseqs2_2/Leptopilina_loci

#Recherche d'homologie (utiliser le plus petit des deux en query):
/beegfs/data/soukkal/TOOLS/mmseqs/bin/mmseqs search /beegfs/data/soukkal/StageM2/Hymenoptera_genomes/results/Viral_Homology_results/Control_test/run_mmseqs2_2/Leptopilina_loci /beegfs/data/soukkal/StageM2/Databases/UniRef90_nodiptera_nohymenoptera /beegfs/data/soukkal/StageM2/Hymenoptera_genomes/results/Viral_Homology_results/Control_test/run_mmseqs2_3/result_mmseqs2 /beegfs/data/soukkal/StageM2/Hymenoptera_genomes/results/Viral_Homology_results/Control_test/run_mmseqs2_3/tpm -a -e 0.01 --threads 10 --remove-tmp-files

#Changer format de sortie des résultats: 
/beegfs/data/soukkal/TOOLS/mmseqs/bin/mmseqs convertalis --format-output 'query,qlen,tlen,target,pident,alnlen,mismatch,gapopen,qstart,qend,tstart,tend,evalue,bits,qaln,tcov' /beegfs/data/soukkal/StageM2/Hymenoptera_genomes/results/Viral_Homology_results/Control_test/run_mmseqs2_2/Leptopilina_loci /beegfs/data/soukkal/StageM2/Databases/UniRef90_nodiptera_nohymenoptera /beegfs/data/soukkal/StageM2/Hymenoptera_genomes/results/Viral_Homology_results/Control_test/run_mmseqs2_3/result_mmseqs2 /beegfs/data/soukkal/StageM2/Hymenoptera_genomes/results/Viral_Homology_results/Control_test/run_mmseqs2_3/result_mmseqs2.m8

