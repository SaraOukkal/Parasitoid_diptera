#!/bin/bash
#SBATCH -J mmseqs_search
#SBATCH --partition=normal
#SBATCH --cpus-per-task=10
#SBATCH --time=48:00:00
#SBATCH -o /beegfs/data/soukkal/StageM2/Clustering/run_mmseqs2/mmseqs_search_refseq_virus.out
#SBATCH -e /beegfs/data/soukkal/StageM2/Clustering/run_mmseqs2/mmseqs_search_refseq_virus.error
#SBATCH --constraint=haswell
#SBATCH --exclude=pbil-deb27

#Créer BDD query 
/beegfs/data/soukkal/TOOLS/mmseqs/bin/mmseqs createdb /beegfs/data/soukkal/StageM2/Clustering/Filtered_viral_loci_cat.faa /beegfs/data/soukkal/StageM2/Clustering/Filtered_viral_loci_cat

#Recherche d'homologie :
/beegfs/data/soukkal/TOOLS/mmseqs/bin/mmseqs search /beegfs/data/soukkal/StageM2/Clustering/Filtered_viral_loci_cat /beegfs/data/soukkal/StageM2/Databases/Refseq_viral_db_nophages_nopolydna_IVSPER /beegfs/data/soukkal/StageM2/Clustering/run_mmseqs2/result_mmseqs2 /beegfs/data/soukkal/StageM2/Clustering/run_mmseqs2/tpm -a -e 0.01 --threads 10 --remove-tmp-files

#Changer format de sortie des résultats: 
/beegfs/data/soukkal/TOOLS/mmseqs/bin/mmseqs convertalis --format-output 'query,qlen,tlen,target,pident,alnlen,mismatch,gapopen,qstart,qend,tstart,tend,evalue,bits,qaln,tcov' /beegfs/data/soukkal/StageM2/Clustering/Filtered_viral_loci_cat /beegfs/data/soukkal/StageM2/Databases/Refseq_viral_db_nophages_nopolydna_IVSPER /beegfs/data/soukkal/StageM2/Clustering/run_mmseqs2/result_mmseqs2 /beegfs/data/soukkal/StageM2/Clustering/run_mmseqs2/result_mmseqs2.m8

