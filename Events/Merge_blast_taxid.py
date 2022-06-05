import numpy as np
import pandas as pd  
import os

Blast=pd.read_table("/beegfs/data/soukkal/StageM2/Events/ET_BUSCO_FDR_BLAST_FILTRED_MONOP.tab",sep=";",header=0)
Blast.drop_duplicates(subset=None, keep='first', inplace=False, ignore_index=False)

Target=pd.read_table("/beegfs/data/soukkal/StageM2/Events/Target_info.m8",sep=";",header=0)
Target.drop_duplicates(subset=None, keep='first', inplace=False, ignore_index=False)
  
Blast_2=pd.merge(Blast, Target, on=["target", "target"], how='left')

Blast_2.to_csv("/beegfs/data/soukkal/StageM2/Events/ET_BUSCO_FDR_BLAST_FILTRED_MONOP_TAXID.tab",sep=";",index=False))
