#!/bin/bash

File="/beegfs/data/soukkal/StageM2/Hymenoptera_genomes/SRA_access.txt"
Script="/beegfs/data/soukkal/StageM2/Scripts/Mapping/SRA_download_hymenoptera.sh"
Lines=$(cat $File)

for SRR in $Lines
do
	sbatch $Script $SRR
done

