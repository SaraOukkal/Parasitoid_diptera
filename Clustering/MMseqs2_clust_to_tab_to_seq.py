import numpy as np 
import os 
import argparse
import networkx as nx
import pandas as pd
import sys 
from Bio import SeqIO
# Print out a message when the program is initiated.
#print('-----------------------------------------------------------------------------------\n')
#print('                        ###Convert MMseqs2 clustering format to tabular#######.\n')
#print('-----------------------------------------------------------------------------------\n')

#----------------------------------- PARSE SOME ARGUMENTS ----------------------------------------
parser = argparse.ArgumentParser(description='Allow add taxonomy informations blast file')
parser.add_argument("-f", "--tsv_file", help="the blast file")
parser.add_argument("-o", "--out_file", help="the output directory")
parser.add_argument("-aa","--aa_file", help= "the fasta file with all virus and candidate loci aa sequences")
parser.add_argument("-dna","--dna_file", help= "the fasta file with all virus and candidate loci dna sequences")
parser.add_argument("-cp","--cluster_path", help= "the cluster path were you want them to be created")
args = parser.parse_args()


#Allows to convert MMSeqs2 clustering tsv output into a tab format such as: 

#Cluster1 Seq1
#Cluster1 Seq2
#Cluster2 Seq3
#Cluster2 Seq4
#Cluster2 Seq5

#Where Seq1 and Seq2 are both in the same Cluster1 and Seq3,4 and Seq5 are in the Cluster2. 

##File examples : 
#MMseqs_tsv_file="/beegfs/data/soukkal/StageM2/Clustering/Candidate_clusters.tsv"
#AA_file="/beegfs/data/soukkal/StageM2/Clustering/Filtered_viral_loci_cat_and_refseq_virus.faa"
#cluster_path="/beegfs/data/bguinet/these/Sara_M2/Clusters/Cluster_seqs/"

# Create Cluster path if it does not exist yet 
#if not os.path.exists(cluster_path):
    #os.makedirs(cluster_path)

MMseqs_tsv_file= args.tsv_file
Out_file=args.out_file
AA_file=args.aa_file
DNA_file=args.dna_file
cluster_path=args.cluster_path

df = pd.read_csv(MMseqs_tsv_file, delimiter='\t',header=None)
df=df.rename(columns={0: "Col1", 1: "Col2"})
g = nx.from_pandas_edgelist(df, source='Col1', target='Col2', create_using=nx.Graph)

data = [[f'Cluster{i}', element] for i, component in enumerate(nx.connected_components(g), 1) for element in component]
result = pd.DataFrame(data=data, columns=['Cluster', 'Names'])

print("Total number of Clusters :", len(result['Cluster'].unique()) )
list1 = result.loc[result.Names.str.contains("\\(")].Cluster.unique() # Select Cluster containing candidate Diptera Loci
list2 = result.loc[~(result.Names.str.contains("\\("))].Cluster.unique() # Select Cluster containing virus sequences
final_list = set(list1).intersection(set(list2))

# Filter only Cluster containing at least of candidate diptera loci and virus sequence 
result=result.loc[result.Cluster.isin(final_list)]

print("Total number of Clusters with a candidate loci and a virus sequence :", len(result['Cluster'].unique()) )

small =  result.groupby('Cluster').size()
print("Total number of Clusters with only one viral sequence and one Diptera candidate loci :", len(small.loc[small==2])) 

# Count number of Cluster containing only Diptera loci without Virus sequence
print("Total number of Clusters with candidate loci and without viral sequence :", len(np.setdiff1d(list1,list(result['Cluster']))))
print("Total number of Clusters with viral sequences and without candidate loci:", len(np.setdiff1d(list2,list(result['Cluster']))))

result.to_csv(Out_file, sep='\t')

print("Table saved to :",Out_file)

# Create cluster AA files
print("Creating AA cluster files...")

record_dict =  SeqIO.to_dict(SeqIO.parse(AA_file, "fasta")) 
for cluster in result['Cluster'].unique():
	sub_result=result[result['Cluster']==cluster]
	with open (cluster_path+sub_result['Cluster'].unique()[0]+".faa","w") as output_aa:
		print("Cluster :",sub_result['Cluster'].unique()[0], "created")
		for index, row in sub_result.iterrows():
			print(">",record_dict[row['Names']].id,sep="",file=output_aa)
			print(record_dict[row['Names']].seq,file=output_aa)
print("\n")
print("All cluster AA files created in ",cluster_path, "directory")

# Create cluster DNA files
print("Creating DNA cluster files...")

record_dict =  SeqIO.to_dict(SeqIO.parse(DNA_file, "fasta")) 
for cluster in result['Cluster'].unique():
        sub_result=result[result['Cluster']==cluster]
        with open (cluster_path+sub_result['Cluster'].unique()[0]+".fna","w") as output_dna:
                print("Cluster :",sub_result['Cluster'].unique()[0], "created")
                for index, row in sub_result.iterrows():
                        print(">",record_dict[row['Names']].id,sep="",file=output_dna)
                        print(record_dict[row['Names']].seq,file=output_dna)
print("\n")
print("All cluster DNA files created in ",cluster_path, "directory")
