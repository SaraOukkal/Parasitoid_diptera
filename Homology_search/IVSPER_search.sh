#!/bin/bash
#SBATCH -J IVSPER
#SBATCH --partition=normal
#SBATCH --time=10:00:00
#SBATCH -o /beegfs/data/soukkal/StageM2/IVSPER.out
#SBATCH -e /beegfs/data/soukkal/StageM2/IVSPER.error
#SBATCH --constraint=haswell
#SBATCH --exclude=pbil-deb27

#Script blast des IVSPER sur les loci candidats :

##Créer bdd IVSPER : 
/beegfs/data/soukkal/TOOLS/mmseqs/bin/mmseqs createdb /beegfs/data/soukkal/StageM2/Databases/IVSPER.fa /beegfs/data/soukkal/StageM2/Databases/IVSPER 

##Créer bdd loci viraux :
###Controles:
/beegfs/data/soukkal/TOOLS/mmseqs/bin/mmseqs createdb /beegfs/data/soukkal/StageM2/Control_genomes/results/Viral_Homology_results/Viral_loci/All_fasta_viral_loci.faa /beegfs/data/soukkal/StageM2/Control_genomes/results/Viral_Homology_results/Viral_loci/All_fasta_viral_loci_mmseqs2_db
###Tachinaires:
/beegfs/data/soukkal/TOOLS/mmseqs/bin/mmseqs createdb /beegfs/data/soukkal/StageM2/Tachinids_genomes/results/Viral_Homology_results/Viral_loci/All_fasta_viral_loci.faa /beegfs/data/soukkal/StageM2/Tachinids_genomes/results/Viral_Homology_results/Viral_loci/All_fasta_viral_loci_mmseqs2_db
###Hymenoptères: 
/beegfs/data/soukkal/TOOLS/mmseqs/bin/mmseqs createdb /beegfs/data/soukkal/StageM2/Hymenoptera_genomes/results/Viral_Homology_results/Viral_loci/All_fasta_viral_loci.faa /beegfs/data/soukkal/StageM2/Hymenoptera_genomes/results/Viral_Homology_results/Viral_loci/All_fasta_viral_loci_mmseqs2_db


##Lancer mmseqs search : 
###Controles:
/beegfs/data/soukkal/TOOLS/mmseqs/bin/mmseqs search /beegfs/data/soukkal/StageM2/Databases/IVSPER /beegfs/data/soukkal/StageM2/Control_genomes/results/Viral_Homology_results/Viral_loci/All_fasta_viral_loci_mmseqs2_db /beegfs/data/soukkal/StageM2/Control_genomes/results/Viral_Homology_results/Filter_loci/run_mmseqs2/result_mmseqs2 /beegfs/data/soukkal/StageM2/Control_genomes/results/Viral_Homology_results/Filter_loci/run_mmseqs2/tpm -a -s 7.5 --threads 10 --remove-tmp-files
###Tachinaires:
/beegfs/data/soukkal/TOOLS/mmseqs/bin/mmseqs search /beegfs/data/soukkal/StageM2/Databases/IVSPER /beegfs/data/soukkal/StageM2/Tachinids_genomes/results/Viral_Homology_results/Viral_loci/All_fasta_viral_loci_mmseqs2_db /beegfs/data/soukkal/StageM2/Tachinids_genomes/results/Viral_Homology_results/Filter_loci/run_mmseqs2/result_mmseqs2 /beegfs/data/soukkal/StageM2/Tachinids_genomes/results/Viral_Homology_results/Filter_loci/run_mmseqs2/tpm -a -s 7.5 --threads 10 --remove-tmp-files
###Hymenoptera: 
/beegfs/data/soukkal/TOOLS/mmseqs/bin/mmseqs search /beegfs/data/soukkal/StageM2/Databases/IVSPER /beegfs/data/soukkal/StageM2/Hymenoptera_genomes/results/Viral_Homology_results/Viral_loci/All_fasta_viral_loci_mmseqs2_db /beegfs/data/soukkal/StageM2/Hymenoptera_genomes/results/Viral_Homology_results/Filter_loci/run_mmseqs2/result_mmseqs2 /beegfs/data/soukkal/StageM2/Hymenoptera_genomes/results/Viral_Homology_results/Filter_loci/run_mmseqs2/tpm -a -s 7.5 --threads 10 --remove-tmp-files

##Lancer mmseqs convertalis : 
###Controles:
/beegfs/data/soukkal/TOOLS/mmseqs/bin/mmseqs convertalis --format-output 'query,qlen,tlen,target,pident,alnlen,mismatch,gapopen,qstart,qend,tstart,tend,evalue,bits,qaln,tcov' /beegfs/data/soukkal/StageM2/Databases/IVSPER /beegfs/data/soukkal/StageM2/Control_genomes/results/Viral_Homology_results/Viral_loci/All_fasta_viral_loci_mmseqs2_db /beegfs/data/soukkal/StageM2/Control_genomes/results/Viral_Homology_results/Filter_loci/run_mmseqs2/result_mmseqs2 /beegfs/data/soukkal/StageM2/Control_genomes/results/Viral_Homology_results/Filter_loci/run_mmseqs2/result_mmseqs2.m8
###Tachinaires:
/beegfs/data/soukkal/TOOLS/mmseqs/bin/mmseqs convertalis --format-output 'query,qlen,tlen,target,pident,alnlen,mismatch,gapopen,qstart,qend,tstart,tend,evalue,bits,qaln,tcov' /beegfs/data/soukkal/StageM2/Databases/IVSPER /beegfs/data/soukkal/StageM2/Tachinids_genomes/results/Viral_Homology_results/Viral_loci/All_fasta_viral_loci_mmseqs2_db /beegfs/data/soukkal/StageM2/Tachinids_genomes/results/Viral_Homology_results/Filter_loci/run_mmseqs2/result_mmseqs2 /beegfs/data/soukkal/StageM2/Tachinids_genomes/results/Viral_Homology_results/Filter_loci/run_mmseqs2/result_mmseqs2.m8
###Hyménoptères: 
/beegfs/data/soukkal/TOOLS/mmseqs/bin/mmseqs convertalis --format-output 'query,qlen,tlen,target,pident,alnlen,mismatch,gapopen,qstart,qend,tstart,tend,evalue,bits,qaln,tcov' /beegfs/data/soukkal/StageM2/Databases/IVSPER /beegfs/data/soukkal/StageM2/Hymenoptera_genomes/results/Viral_Homology_results/Viral_loci/All_fasta_viral_loci_mmseqs2_db /beegfs/data/soukkal/StageM2/Hymenoptera_genomes/results/Viral_Homology_results/Filter_loci/run_mmseqs2/result_mmseqs2 /beegfs/data/soukkal/StageM2/Hymenoptera_genomes/results/Viral_Homology_results/Filter_loci/run_mmseqs2/result_mmseqs2.m8
