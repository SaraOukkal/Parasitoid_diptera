# Parasitoid_diptera
Stage M2 


## Species: 

3 groups of species: 
- Species of interest (Tachinids) names here Tachinids 
- Negative Control (Non parasitoid diptera) named here Control
- Positif Control (Hymenoptera) named here Hymenoptera 

## Assemblies quality analysis: 

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

Perform Homology search, create candidate loci, fetch fasta aa and nt sequences, taxonomic assignation and candidate loci filtering (Snakemake): 
- Snakemake_viral_homology_Control for Control species 
- Snakemake_viral_homology_Tachinids for Tachinids species 
- Snakemake_viral_homology_Hymenoptera for Hymenoptera species 

Regroup overlapping viral hits (R): 
- Overlapping_sequences_BUSCO_Viral8loci2.R

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

## BUSCO Phylogeny: 

## Candidate loci Phylogeny: 

## Mapping: 
