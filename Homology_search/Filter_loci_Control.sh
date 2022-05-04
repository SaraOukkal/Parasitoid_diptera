
#Script pour filtrer les loci après l'assignement taxonomique de mmseqs Taxonomy 

##Récupérer les noms de locus assignés à des virus: 
cat _lca.tsv | cut -f1,4 | grep "virus" | cut -f1 > Virus_loci_names.txt

##Récupérer les noms de locus non assignés (car ils ont hit sur des virus précédement, donc la unclassified = Pas dans la BDD UniRef90)
cat _lca.tsv | cut -f1,4 | grep "unclassified" | cut -f1 > Unclassified_loci_names.txt

##Concaténer les deux listes : 
cat Virus_loci_names.txt Unclassified_loci_names.txt >> Unclassified_and_virus_loci_names.txt

##Filtrer le fichier fasta d'AA : 
seqkit grep -f Unclassified_and_virus_loci_names.txt ../Viral_loci/Candidate_viral_loci_and_viral_protein.aa > Filtered_loci_unclassified_virus.faa 

##Filtrer le fichier fasta de nucléotides :
seqkit grep -f Unclassified_and_virus_loci_names.txt ../Viral_loci/All_fasta_viral_loci.fna  > Filtered_loci_unclassified_virus.fna


