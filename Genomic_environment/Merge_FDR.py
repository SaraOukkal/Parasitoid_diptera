import numpy as np
import pandas as pd 
from Bio import SeqIO 
import numpy as np
import sys
import argparse
from Bio import SeqIO
from statistics import mean
import os


main_path="/beegfs/data/soukkal/StageM2/"


Species_file=open(main_path+"Species_list.txt", "r") 

List_species=[]

for line in Species_file:
    List_species.append(line.strip())

list_variable_paths=['Control_genomes','Tachinids_genomes','Hymenoptera_genomes']

Counter=0

for species in List_species :
	for type in list_variable_paths : 
		if os.path.exists(main_path+type+"/results/Environment_results/ET/"+species+"/result_mmseqs2_filtred_TE_BUSCO_cov_depth_pvalues.m8") :
			Input_tab=pd.read_table(main_path+type+"/results/Environment_results/ET/"+species+"/result_mmseqs2_filtred_TE_BUSCO_cov_depth_pvalues.m8",sep=";",header=0)
			print("Merging with : ", species)
			if Counter==0 :
				Merged_tab = Input_tab
				Counter=1
			else :	
				Merged_tab = pd.concat([Merged_tab, Input_tab], axis=0)
				
				

print("Lines in Table", len(Merged_tab))


##Correct pvalues (FDR) : 

from multipy.fdr import tst


#Check which FDR to take 
list_nb=[0.1,0.09,0.08,0.07,0.06,0.05,0.04,0.03,0.02,0.01]

for i in list_nb:
    Merged_tab['FDR_pvalue_cov']=tst(Merged_tab['pvalue_cov'], q=i)
    print(i,len(Merged_tab.loc[Merged_tab['FDR_pvalue_cov'].astype(str)=="False"]))


Merged_tab['FDR_pvalue_cov']=tst(Merged_tab['pvalue_cov'], q=0.03)

For line in Merged_tab : 
    if Merged_tab['pvalue_cov']=="No_cov":
        Merged_tab['FDR_pvalue_cov']="No_cov"


Merged_tab['count_BUSCO_plus_repeat']=Merged_tab['count_BUSCO']+Merged_tab['count_repeat']
Merged_tab.loc[Merged_tab['count_BUSCO'].eq(0) & Merged_tab['FDR_pvalue_cov'].astype(str).str.contains("True"),'Scaffold_score' ]='X'
Merged_tab.loc[Merged_tab['count_repeat'].eq(0) & Merged_tab['FDR_pvalue_cov'].astype(str).str.contains("True"),'Scaffold_score']='X'

Merged_tab.loc[Merged_tab['count_BUSCO'].eq(0) & Merged_tab['FDR_pvalue_cov'].astype(str).str.contains("No_cov"),'Scaffold_score']='E'
Merged_tab.loc[Merged_tab['count_repeat'].eq(0) & Merged_tab['FDR_pvalue_cov'].astype(str).str.contains("No_cov"),'Scaffold_score']='E'

Merged_tab.loc[Merged_tab['count_BUSCO_plus_repeat'].ge(1) & Merged_tab['FDR_pvalue_cov'].astype(str).str.contains("True"),'Scaffold_score']='D'
Merged_tab.loc[Merged_tab['count_repeat'].ge(1) & Merged_tab ['FDR_pvalue_cov'].astype(str).str.contains("True"),'Scaffold_score']='D'

Merged_tab.loc[Merged_tab['count_BUSCO'].eq(0) & Merged_tab['FDR_pvalue_cov'].astype(str).str.contains("False"),'Scaffold_score']='C'
Merged_tab.loc[Merged_tab['count_repeat'].eq(0) & Merged_tab['FDR_pvalue_cov'].astype(str).str.contains("False"),'Scaffold_score']='C'

Merged_tab.loc[Merged_tab['count_BUSCO'].ge(1) & Merged_tab['FDR_pvalue_cov'].astype(str).str.contains("No_cov"),'Scaffold_score']='B'
Merged_tab.loc[Merged_tab['count_repeat'].ge(1) & Merged_tab ['FDR_pvalue_cov'].astype(str).str.contains("No_cov"),'Scaffold_score']='B'

Merged_tab.loc[Merged_tab['count_BUSCO'].ge(1) & Merged_tab['FDR_pvalue_cov'].astype(str).str.contains("False"),'Scaffold_score']='A'
Merged_tab.loc[Merged_tab['count_repeat'].ge(1) & Merged_tab ['FDR_pvalue_cov'].astype(str).str.contains("False"),'Scaffold_score']='A'

Merged_tab.to_csv(main_path+"Genomic_environment/ET_BUSCO_Cov_FDR.txt",sep=";",index=False)

