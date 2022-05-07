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

In this step we perform clustering with to gather candidate loci and viral proteins in the same clusters based on sequence homologies. 
First we need to concatenate the filtred queries loci (Control+Tachinids+Hymenoptera) with the proteins from the target (Refseq virus DB)

Mmseqs clustering + change results format with mmseqs createtsv + filter clusters (remove those with only viruses and those with more than 50 species):
- Clustering.sh 

## BUSCO Phylogeny: 

Repository : BUSCO_phylogeny 


## Candidate loci Phylogeny: 

Repository : Loci_phylogeny 

## Mapping: 

Download SRA reads (bash): 
- SRA_download_*.sh to run fastq-dump
- run_SRA_download_*.sh to run SRA_download_*.sh on the cluster for all species specified in a list

Compute coverage (bash): 
- Coverage_*.sh to run samtools depth
- run_Coverage_*.sh to run Coverage_*.sh on the cluster for all species specified in a list
