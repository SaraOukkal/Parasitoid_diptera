#!/bin/bash
#SBATCH -t 24:00:00
#SBATCH --cpus-per-task=10
#SBATCH -e /beegfs/data/soukkal/StageM2/Test/Viral_homology/Refseq_Refseq/job.error
#SBATCH -o /beegfs/data/soukkal/StageM2/Test/Viral_homology/Refseq_Refseq/job.out
#SBATCH -J Test_homology
/beegfs/data/soukkal/TOOLS/mmseqs/bin/mmseqs search /beegfs/data/soukkal/StageM2/Databases/Refseq_viral_db_nophages_nopolydna_subset /beegfs/data/soukkal/StageM2/Databases/Refseq_viral_db_nophages_nopolydna_without_subset /beegfs/data/soukkal/StageM2/Test/Viral_homology/Refseq_Refseq/result_mmseqs2 /beegfs/data/soukkal/StageM2/Test/Viral_homology/Refseq_Refseq/tpm -a -s 7.5 --threads 10 --remove-tmp-files
##Formater les résultats pour avoir un seul fichier de sortie
/beegfs/data/soukkal/TOOLS/mmseqs/bin/mmseqs convertalis --format-output 'query,tlen,target,pident,alnlen,mismatch,gapopen,qstart,qend,tstart,tend,evalue,bits,qaln,tcov' /beegfs/data/soukkal/StageM2/Databases/Refseq_viral_db_nophages_nopolydna_subset /beegfs/data/soukkal/StageM2/Databases/Refseq_viral_db_nophages_nopolydna_without_subset /beegfs/data/soukkal/StageM2/Test/Viral_homology/Refseq_Refseq/result_mmseqs2 /beegfs/data/soukkal/StageM2/Test/Viral_homology/Refseq_Refseq/result_mmseqs2.m8
