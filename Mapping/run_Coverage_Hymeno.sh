#!/bin/bash

File="/beegfs/data/soukkal/StageM2/Hymenoptera_genomes/Access_num.txt"
Script="/beegfs/data/soukkal/StageM2/Parasitoid_diptera/Mapping/Coverage_Hymeno.sh"
Lines=$(cat $File)

for i in $Lines
do
        sbatch $Script $i
done
