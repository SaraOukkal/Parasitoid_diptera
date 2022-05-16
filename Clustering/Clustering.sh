#!/bin/bash
#SBATCH -J Clustering
#SBATCH --partition=normal
#SBATCH --cpus-per-task=30
#SBATCH --time=04:00:00
#SBATCH -o /beegfs/data/soukkal/StageM2/Clustering/Clustering.out
#SBATCH -e /beegfs/data/soukkal/StageM2/Clustering/Clustering.error
#SBATCH --constraint="skylake|haswell|broadwell"
#SBATCH --exclude=pbil-deb27

##Create DB : 
#/beegfs/data/soukkal/TOOLS/mmseqs/bin/mmseqs createdb /beegfs/data/soukkal/StageM2/Clustering/Filtered_viral_loci_cat_and_refseq_virus.faa /beegfs/data/soukkal/StageM2/Clustering/Filtered_viral_loci_cat_and_refseq_virus
##Clustering : 
#/beegfs/data/soukkal/TOOLS/mmseqs/bin/mmseqs cluster /beegfs/data/soukkal/StageM2/Clustering/Filtered_viral_loci_cat_and_refseq_virus /beegfs/data/soukkal/StageM2/Clustering/Candidate_clusters /beegfs/data/soukkal/StageM2/Clustering/Candidate_clusters_tmp --threads 30 -s 7.5 --cluster-mode 1 --cov-mode 0 -c 0.30 -e 0.001 
##Create tsv :
#/beegfs/data/soukkal/TOOLS/mmseqs/bin/mmseqs createtsv /beegfs/data/soukkal/StageM2/Clustering/Filtered_viral_loci_cat_and_refseq_virus /beegfs/data/soukkal/StageM2/Clustering/Filtered_viral_loci_cat_and_refseq_virus  /beegfs/data/soukkal/StageM2/Clustering/Candidate_clusters /beegfs/data/soukkal/StageM2/Clustering/Candidate_clusters.tsv
##Clusters to tab,  filter clusters and get one file per sequences of a cluster: 
python3 /beegfs/data/soukkal/StageM2/Parasitoid_diptera/Clustering/MMseqs2_clust_to_tab_to_seq.py -f /beegfs/data/soukkal/StageM2/Clustering/Candidate_clusters.tsv -o /beegfs/data/soukkal/StageM2/Clustering/Candidate_clusters.m8 -aa /beegfs/data/soukkal/StageM2/Clustering/Filtered_viral_loci_cat_and_refseq_virus.faa -dna /beegfs/data/soukkal/StageM2/Clustering/Filtered_viral_loci_cat_and_refseq_virus_dna.fna -cp /beegfs/data/soukkal/StageM2/Clustering/Cluster_seqs/


