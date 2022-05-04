
#Script pour filtrer les loci après l'assignement taxonomique de mmseqs Taxonomy 
cd /beegfs/data/soukkal/StageM2/Tachinids_genomes/results/Viral_Homology_results/Filter_loci/

##Récupérer les noms de locus assignés à des virus: 
cat _lca.tsv | cut -f1,4 | grep "virus" | cut -f1 > Virus_loci_names.txt

##Récupérer les noms de locus non assignés (car ils ont hit sur des virus précédement, donc la unclassified = Pas dans la BDD UniRef90)
cat _lca.tsv | cut -f1,4 | grep "unclassified" | cut -f1 > Unclassified_loci_names.txtt

##Filtrer le fichier fasta d'AA : 
seqkit grep -f Virus_loci_names.txt ../Viral_loci/All_fasta_viral_loci.faa > Filtered_viral_loci.faa 

##Filtrer le fichier fasta de nucléotides :
seqkit grep -f Virus_loci_names.txt ../Viral_loci/All_fasta_viral_loci.fna  > Filtered_viral_loci.fna


