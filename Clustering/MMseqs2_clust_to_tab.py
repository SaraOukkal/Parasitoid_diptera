import numpy as np 
import argparse
import networkx as nx
import pandas as pd
import sys 

# Print out a message when the program is initiated.
#print('-----------------------------------------------------------------------------------\n')
#print('                        ###Convert MMseqs2 clustering format to tabular#######.\n')
#print('-----------------------------------------------------------------------------------\n')

#----------------------------------- PARSE SOME ARGUMENTS ----------------------------------------
parser = argparse.ArgumentParser(description='Allow add taxonomy informationsa blast file')
parser.add_argument("-f", "--tsv_file", help="the blast file")
parser.add_argument("-o", "--out_file", help="the output directory")
args = parser.parse_args()


#Allows to convert MMSeqs2 clustering tsv output into a tab format such as: 

#Cluster1 Seq1
#Cluster1 Seq2
#Cluster2 Seq3
#Cluster2 Seq4
#Cluster2 Seq5

#Where Seq1 and Seq2 are both in the same Cluster1 and Seq3,4 and Seq5 are in the Cluster2. 

MMseqs_tsv_file= args.tsv_file
Out_file=args.out_file


df = pd.read_csv(MMseqs_tsv_file, delimiter='\t',header=None)
df=df.rename(columns={0: "Col1", 1: "Col2"})
g = nx.from_pandas_edgelist(df, source='Col1', target='Col2', create_using=nx.Graph)

data = [[f'Cluster{i}', element] for i, component in enumerate(nx.connected_components(g), 1) for element in component]
result = pd.DataFrame(data=data, columns=['Cluster', 'Names'])


print("Total number of Clusters :", len(result['Cluster'].unique()) )
list1 = result.loc[result.Names.str.contains("\\(")].Cluster.unique() # Select Cluster containing candidate Diptera Loci
list2 = result.loc[~(result.Names.str.contains("\\("))].Cluster.unique() # Select Cluster containing virus sequences
final_list = set(list1).intersection(set(list2))

print("Total number of Clusters with a candidate loci and a virus sequence :", len(final_list) )


orphelins =  result.groupby('Cluster').size()
print("Total number of Clusters with only one viral sequence and one Diptera candidate loci :", len(orphelins.loc[orphelins==2])) 

# Filter only Cluster containing at least of candidate diptera loci and virus sequence 
result=result.loc[result.Cluster.isin(final_list)]

# Count number of Cluster containing only Diptera loci without Virus sequence
print("Total number of Clusters with candidate loci and without viral sequence :", len(np.setdiff1d(list1,list(result['Cluster']))))



result.to_csv(Out_file, sep='\t')


print("Table saved to :",Out_file)
