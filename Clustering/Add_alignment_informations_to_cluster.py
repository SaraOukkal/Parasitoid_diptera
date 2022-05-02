
#!/usr/bin/python
import pandas as pd
import numpy as np
import sys 
import argparse
import os
import subprocess


# Print out a message when the program is initiated.
print('----------------------------------------------------------------\n')
print('             Add alignment informations to cluster  .\n')
print('----------------------------------------------------------------\n')

#----------------------------------- PARSE SOME ARGUMENTS ----------------------------------------
parser = argparse.ArgumentParser(description='Allow to make mmseqs jobs for slurm')
parser.add_argument("-c", "--Cluster_file", help="The cluster file")
parser.add_argument("-r", "--Relaxed_file", help="The relaxed output from mmseqs2 analysis")
parser.add_argument("-o", "--out",help="The ouptut files")

args = parser.parse_args()

Cluster_file=args.Cluster_file
Relaxed_file=args.Relaxed_file
Output_file=args.out

print("Open Relaxed file...")
Relaxed=pd.read_csv(Relaxed_file,sep="\t",header=None)
Relaxed.columns=["query","target","pident","alnlen","mismatch","gapopen","qstart","qend","tstart","tend","evalue","bits","tlen"]
print("Open Cluster file...")
Clusters=pd.read_csv(Cluster_file,sep="\t")
print(Clusters)
try:
	Clusters.columns = ["0","Clustername","Names"]
except:
	Clusters=Clusters[["Clusternames","Names"]]
	Clusters.columns = ["Clustername","Names"]
#Cluster_and_Relaxed=pd.merge(Relaxed,Clusters,how='inner', left_on='query', right_on='Names').drop_duplicates(subset='query')

x = Relaxed.merge(Clusters, left_on="query", right_on="Names")
y = Relaxed.merge(Clusters, left_on="target", right_on="Names")

Cluster_and_Relaxed = x.merge(y, on=["query", "target", "Clustername"])


Cluster_and_Relaxed=Cluster_and_Relaxed[["Clustername","query","target","pident_x","alnlen_x","mismatch_x","gapopen_x","qstart_x","qend_x","tstart_x","tend_x","evalue_x","bits_x","tlen_x"]]
Cluster_and_Relaxed.columns=["Clustername","query","target","pident","alnlen","mismatch","gapopen","qstart","qend","tstart","tend","evalue","bits","tlen"]

Cluster_and_Relaxed=Cluster_and_Relaxed[["Clustername","query","target","pident","alnlen","mismatch","gapopen","qstart","qend","tstart","tend","evalue","bits","tlen"]]
Cluster_and_Relaxed.to_csv(Output_file,sep=";")

print("Cluster informations added with alignment informations\n")
print("Output file written to : ",Output_file)

print("Nb remaining clusters :", len(Cluster_and_Relaxed['Clustername'].unique()),"/", len(Clusters['Clustername'].unique()))
print("Nb remaining queries :", len(Cluster_and_Relaxed['query'].unique()),"/", len(Clusters.loc[Clusters['Names'].str.contains(":")]['Names'].unique()))
print("Nb remaining viral seq :", len(Cluster_and_Relaxed['target'].unique()),"/", len(Clusters.loc[~Clusters['Names'].str.contains(":")]['Names'].unique()))

"""
Filtred_Cluster_table=pd.read_csv(Input_file,sep="\t")
Filtred_Cluster_table.drop('Unnamed: 0', axis=1, inplace=True)
Filtred_Cluster_table.columns=['Cluster','Names']
Filtred_Cluster_table[['scaffold','strand','Species']] = Filtred_Cluster_table.Names.str.split(':', expand=True)
Filtred_Cluster_table.strand = Filtred_Cluster_table.strand.str.replace('\(-\)','')
Filtred_Cluster_table.strand = Filtred_Cluster_table.strand.str.replace('\(\+\)','')
Filtred_Cluster_table[['start','end']] = Filtred_Cluster_table.strand.str.split('-', expand=True)
Filtred_Cluster_table.drop('strand', axis=1, inplace=True)
#Filtred_Cluster_table=Filtred_Cluster_table.dropna(axis=0, subset=['Species'])
Filtred_Cluster_table['start']=Filtred_Cluster_table['start'].fillna(0).astype(int)
Filtred_Cluster_table['start']-=1

Filtred_Cluster_table1 = Filtred_Cluster_table[Filtred_Cluster_table.Names.str.contains('(', regex=False)]
Filtred_Cluster_table2 = Filtred_Cluster_table[~Filtred_Cluster_table.Names.str.contains('(', regex=False)][['Cluster', 'Names']]

Filtred_Cluster_table=pd.merge(left=Filtred_Cluster_table1, right=Filtred_Cluster_table2, on='Cluster').rename(columns={"Names_x": "Names", "Names2": "Names2"}) 


#Open all the Filtred_Cluster_table

Species_name_file="/beegfs/data/bguinet/these/Species_genome_names.txt"

list_of_names1=[]
for names in open(Species_name_file,"r"):
  list_of_names1.append(names)
list_of_names2=[]
for names in list_of_names1:
 list_of_names2.append(names.replace("\n", ""))

Filtred_Cluster_table2 = pd.DataFrame(columns=(['Cluster', 'Names_x', 'scaffold', 'Species_x', 'start', 'end', 'Names2', 'query', 'target', 'pident', 'alnlen', 'mismatch', 'gapopen', 'qstart', 'qend', 'qlen', 'tstart', 'tend', 'tlen', 'evalue', 'bits', 'Species_y']))
for names in list_of_names2:
  table=pd.DataFrame()
  Sub_Filtred_Cluster_table=Filtred_Cluster_table.loc[Filtred_Cluster_table['Species']==names]
  sub_list=[]
  for i in Filtred_Cluster_table['scaffold']:
    sub_list.append(i)
  table=pd.read_csv("/beegfs/data/bguinet/these/Genomes/"+names+"/run_mmseqs2_V/result_mmseqs2.m8",sep="\t",header=None)
  table.columns=["query","target","pident","alnlen","mismatch","gapopen","qstart","qend","qlen","tstart","tend","tlen","evalue","bits"]
  table = table[table[table.columns[0]].isin(sub_list)]
  table['Species']=names
  #print( Filtred_Cluster_table)
  #print(table)
  Filtred_Cluster_table_merged = pd.merge(Filtred_Cluster_table,table, how = 'inner', left_on = ['scaffold','Names_y'], right_on = ['query','target'])
  #print("Fil",Filtred_Cluster_table_merged)
  Filtred_Cluster_table_merged[['qstart','qend','start','end']]=Filtred_Cluster_table_merged[['qstart','qend','start','end']].astype(int)
  result = Filtred_Cluster_table_merged[((Filtred_Cluster_table_merged.qstart >= Filtred_Cluster_table_merged.start) & (Filtred_Cluster_table_merged.qend <= Filtred_Cluster_table_merged.end))]
  #print("res",result)
  Filtred_Cluster_table2=pd.concat([Filtred_Cluster_table2, result], ignore_index=True)
  #print("Fi2",Filtred_Cluster_table2)
  print(names)

print("TheFile",Filtred_Cluster_table2)

Filtred_Cluster_table2=Filtred_Cluster_table2.drop(['Names_x','scaffold','query','Species_x','Names2','start','end','Species_y','Names_y'], axis=1)

print(Filtred_Cluster_table2)
print(list(Filtred_Cluster_table2))
Filtred_Cluster_table2.columns=(['Clusternames', 'target', 'pident', 'alnlen', 'mismatch', 'gapopen', 'qstart', 'qend', 'qlen', 'tstart', 'tend', 'tlen', 'evalue', 'bits','query'])

 
#Remove within clusters candidat with low evalue compared to the lowest evalue of a candidate (here 0.0097 for Fopius)

#We remove every hits below the threshold of the smallest control 
Filtred_Cluster_table2=Filtred_Cluster_table2.sort_values(['evalue'], ascending=[True])

print("THEFILE2",Filtred_Cluster_table2)
print("Removing of each loci within cluster with Evalue under 0.0097")
#Filtred_Cluster_table2=Filtred_Cluster_table2.loc[Filtred_Cluster_table2['evalue'].lt(0.0097)]

Filtred_Cluster_table2.to_csv(Output_file,sep=";")

print("Final output of clusternames with alignment informations written to : ",Output_file)
"""
