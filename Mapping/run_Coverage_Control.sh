#!/bin/bash

File="/beegfs/data/soukkal/StageM2/Control_genomes/Access_num_with_reads.txt"
Script="/beegfs/data/soukkal/StageM2/Parasitoid_diptera/Mapping/Coverage_Control.sh"
Lines=$(cat $File)

for i in $Lines
do
        sbatch $Script $i
done
