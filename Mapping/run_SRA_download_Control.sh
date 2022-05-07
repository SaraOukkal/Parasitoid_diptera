#!/bin/bash

File="/beegfs/data/soukkal/StageM2/Control_genomes/SRA_access_to_download.txt"
Script="/beegfs/data/soukkal/StageM2/Parasitoid_diptera/Mapping/SRA_download_Control.sh"
Lines=$(cat $File)

for SRR in $Lines
do
	sbatch $Script $SRR
done

