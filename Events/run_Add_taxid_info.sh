#!/bin/bash
#SBATCH -J taxadb
#SBATCH --partition=normal
#SBATCH --time=10:00:00
#SBATCH -o /beegfs/data/soukkal/StageM2/Events/tax.out
#SBATCH -e /beegfs/data/soukkal/StageM2/Events/tax.error

python3 Add_taxid_info.py -blst Mmseqs2 -b /beegfs/data/soukkal/StageM2/Clustering/run_mmseqs2/result_mmseqs2.m8 -d /beegfs/data/bguinet/taxadb2/taxadb.sqlite -o /beegfs/data/soukkal/StageM2/Events/Target_taxid.m8

