# Parasitoid_diptera
Stage M2 

## Species: 

3 groups of species: 
- Species of interest (Tachinids) names here Tachinids 
- Negative Control (Non parasitoid diptera) named here Control
- Positif Control (Hymenoptera) named here Hymenoptera 

First genome assemblies of negative and positive controls were downloaded from ncbi. 
Genome assemblies of tachinids were produced by the team. 

## Assemblies quality analysis: 

The quality of the assembly of these genomes should be assessed through descriptive statistics and the prevalence of BUSCO genes

Repository : BUSCO_jobs 

Perform BUSCO and QUAST analysis (Snakemake):
- Snakemake_BUSCO_QUAST_Control for Control species on Diptera_odb10 dataset 
- Snakemake_BUSCO_QUAST_Tachinids for Tachinids species on Diptera_odb10 dataset 
- Snakemake_BUSCO_QUAST_Hymenoptera for Hymenoptera species on Hymenoptera_odb10 dataset 

Perform BUSCO analysis only (Snakemake):
- Snakemake_BUSCO_Hymenoptera_diptera for Hymenoptera species on Diptera_odb10 dataset (To root the Phylogenetic tree)

Sum up BUSCO results in an easily readable file (Python): 
- Busco_summary.py

## Homology search: 
### First homology search: 

Repository : Homology_search

Download Refseq virus database: https://www.ncbi.nlm.nih.gov/nuccore/?term=Viruses[Organism]%20NOT%20cellular%20organisms[ORGN]%20NOT%20wgs[PROP]%20NOT%20gbdiv%20syn[prop]%20AND%20(srcdb_refseq[PROP]%20OR%20nuccore%20genome%20samespecies[Filter]) 

Perform Homology search, create candidate loci, fetch fasta aa and nt sequences, taxonomic assignation and candidate loci filtering (Snakemake): 
- Snakemake_viral_homology_Control for Control species 
- Snakemake_viral_homology_Tachinids for Tachinids species 
- Snakemake_viral_homology_Hymenoptera for Hymenoptera species 

WARNING: on Pbil-deb cluster, mmseqs does not run on all nodes, you should specify : --constraint="skylake|haswell|broadwell" and --exclude=pbil-deb27

Regroup overlapping viral hits (R): 
- Overlapping_sequences_BUSCO_Viral_loci2.R

Extract and translate loci (Python): 
- Extract_and_translate_loci.py called by Snakemake_viral_homology_*

### Filter candidate loci:

This step is added to the previous Snakemake (Snakemake_viral_homology_*)

Create and filter Uniref90 database (bash): 
- Filter_database_diptera_hymenoptera.sh

Specifically perform Taxonomic assignation with mmseqs easy-taxonomy tool (bash): 
- Tax_assignation.sh for Control species 
- Tax_assignation_Tach.sh for Tachinids species 
- Tax_assignation_hymeno.sh for Hymenoptera species  

Specifically filter candidate loci (bash): 
- Filter_loci_Control.sh
- Filter_loci_Hymeno.sh
- Filter_loci_Tach.sh

## Clustering: 

Repository : Clustering 

In this step we perform clustering to gather candidate loci and viral proteins in the same clusters based on sequence homologies. 
First we need to concatenate the filtred queries loci (Control+Tachinids+Hymenoptera) with the proteins from the target (Refseq virus DB)

Mmseqs clustering + change results format with mmseqs createtsv + filter clusters (remove those with only viruses and those with more than 50 species):
- Clustering.sh 

Clustering.sh contains 4 steps : 
- It creates query and target databases with mmseqs createdb
- It performs the clustering with mmseqs cluster
- It create a tsv file with mmseqs createtsv
- It filters clusters based on composition criteria and creates a fasta file per cluster with the python script MMseqs2_clust_to_tab_to_seq.py 

## BUSCO Phylogeny: 

Repository : BUSCO_phylogeny 

Creates a species phylogeny based on 586 BUSCO genes : 
- Snakemake Snakefile_BUSCO_phylogeny_sara

## Candidate loci Phylogeny: 

Repository : Clustering

First it aligns sequences from each cluster, then it groups HSP together, and realigns the clusters with HSP. The second step is to generate the phylogenies from each cluster. 

- Snakemake_Cluster_ali_phylo

## Genomic environement analysis : 
### Mapping: 

Download SRA reads (bash): 
- SRA_download_*.sh to run fastq-dump
- run_SRA_download_*.sh to run SRA_download_*.sh on the cluster for all species specified in a list

### Coverage : 

Compute coverage for each genomic position (bash): 
- Coverage_*.sh to run samtools depth
- run_Coverage_*.sh to run Coverage_*.sh on the cluster for all species specified in a list

### Transposable elements : 

This step is based on homology search to highlight the presence of transposables elements on insect genomes. 
- Snakemake_ET_search_Control
- Snakemake_ET_search_Hymeno
- Snakemake_ET_search_Tach

### Scaffold coverage and presence of BUSCO and/or transposable elements :

-  Snakemake_Env rules Add_genomic_env_TE_cov_pvalues.py on each genome 
-  Add_genomic_env_TE_cov_pvalues.py creates the null coverage distribution and tests whether each scaffold containing a candidate locus is part of the insect genome
-  Merge_FDR.py Merges results for each genomes to one table and corrects pvalues for multiple tests (False discovery rate). 

## Monophyly analysis: 

Monophyly is analyzed in each cluster to form monophyletic events of viral elements endogenization within the species tree. 

-  Monophyletic_assessment.R 

