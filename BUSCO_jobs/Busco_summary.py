import pandas as pd
import numpy as np
from pandas import DataFrame
import os
import sys
import argparse


# Print out a message when the program is initiated.
print('----------------------------------------------------------------\n')
print('                        Busco_summary.\n')
print('----------------------------------------------------------------\n')

#----------------------------------- PARSE SOME ARGUMENTS ----------------------------------------
parser = argparse.ArgumentParser(description='Allow to make busco jobs for slurm')
parser.add_argument("-sum", "--summary", help="introduce the .tsv summary file")
parser.add_argument("-o", "--out",help="The ouptut path where to create the output file")
parser.add_argument("-sp", "--species", help="The species' name")

args = parser.parse_args()

# Variable that stores fasta sequences
Summary_file=args.summary
Output_file=args.out
Species=args.species

#python3 Busco_summary.py -sum /beegfs/data/bguinet/these/full_table.tsv  -o /beegfs/data/bguinet/these/Busco_summary.csv  -sp Drosophila_melanogaster

df1=pd.read_csv(Summary_file,comment="#",sep="\t",header=None)

df1.columns = ["Busco id","Status", "Sequence","Gene Start","Gene End","Strand","Score","Length","OrthoDB url","Description"]

Number_Fragmented=(df1[df1["Status"].str.contains("Fragmented")==True].shape[0])
Number_Missing=(df1[df1["Status"].str.contains("Missing")==True].shape[0])
Number_Duplicated=(df1[df1["Status"].str.contains("Duplicated")==True].shape[0])  
Number_Complete=(df1[df1["Status"].str.contains("Complete")==True].shape[0])

Number_complete_duplicated=Number_Complete+Number_Duplicated/2

Total_number=Number_complete_duplicated+Number_Fragmented+Number_Missing

df2 = pd.DataFrame(columns=("Species",'Complete', 'Duplicated', 'Fragmented','Missing','Total'))

df2=df2.append({'Species':Species,'Complete':int(Number_complete_duplicated),'Duplicated':int(Number_Duplicated/2), 'Fragmented':int(Number_Fragmented),'Missing':int(Number_Missing),'Total':int(Total_number)}, ignore_index=True)

df2.to_csv(Output_file,sep='\t',index=False)


print(df2)
