#!/bin/bash

File="/beegfs/data/soukkal/StageM2/Tachinids_genomes/genomes_list.txt"
Script="/beegfs/data/soukkal/StageM2/Scripts/Mapping/Coverage.sh"
Lines=$(cat $File)

for i in $Lines
do
        sbatch $Script $i
done
