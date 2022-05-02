#!/bin/bash
#SBATCH -t 24:00:00
#SBATCH --cpus-per-task=10
#SBATCH -e /beegfs/data/soukkal/StageM2/Test/Viral_homology/BUSCO_Refseq/job.error
#SBATCH -o /beegfs/data/soukkal/StageM2/Test/Viral_homology/BUSCO_Refseq/job.out
#SBATCH -J Test_homology

/beegfs/data/soukkal/TOOLS/mmseqs/bin/mmseqs search /beegfs/data/soukkal/StageM2/Databases/BUSCO_diptera_db /beegfs/data/soukkal/StageM2/Databases/Refseq_viral_db_nophages_nopolydna /beegfs/data/soukkal/StageM2/Test/Viral_homology/BUSCO_Refseq/result_mmseqs2 /beegfs/data/soukkal/StageM2/Test/Viral_homology/BUSCO_Refseq/tpm -a -s 7.5 --threads 10 --remove-tmp-files

