import pandas as pd



df1=pd.read_csv("/beegfs/data/soukkal/StageM2/Clustering/Candidate_clusters.m8")  
df2=pd.read_csv("/beegfs/data/soukkal/StageM2/Clustering/run_mmseqs2/result_mmseqs2.m8")  
pd.merge(df1, df2, on="movie_title")
