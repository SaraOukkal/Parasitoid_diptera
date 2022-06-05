import numpy as np
import pandas as pd 
from Bio import SeqIO 
import numpy as np
import sys
import argparse
from Bio import SeqIO
from statistics import mean
import random
import time
import re
import os


# Print out a message when the program is initiated.
print('-------------------------------------------------------------------------------------------\n')
print('                        Add genomic environment informations into MMseqs2 clusterised  tab.\n')
print('-------------------------------------------------------------------------------------------\n')

#----------------------------------- PARSE SOME ARGUMENTS ----------------------------------------
parser = argparse.ArgumentParser(description='Allow add taxonomy informationsa blast file')
parser.add_argument("-b", "--blast", help="The blast file in .m8 format (check the column names and modify the colname 'target' wich corresponds to the Acc_number column in the mmseqs2 software")
parser.add_argument("-s", "--species_name", help="Secies name")
parser.add_argument("-p", "--main_path",help="The main path where to find all files")
args = parser.parse_args()


#Usage : python3 Add_genomic_env_TE_cov_pvalues.py -b /beegfs/data/soukkal/StageM2/Clustering/Cluster_information.m8 -s campylocheta_wood03 -p /beegfs/data/soukkal/StageM2/

Species_name=args.species_name
blast_file=args.blast
main_path=args.main_path

#blast_file="/beegfs/data/soukkal/StageM2/Clustering/Cluster_information.m8"
#main_path="/beegfs/data/soukkal/StageM2/"

# Open the blast table
Blast_table=pd.read_csv(blast_file,sep=";")


Blast_table['Species_name']=  Blast_table['Names'].str.replace(".*\\):","")
Blast_table['Scaffold_name']=  Blast_table['Names'].str.replace(":.*","")

Blast_table=Blast_table.loc[Blast_table['Species_name']==Species_name]
Nb_scaffolds_to_analyse=len(Blast_table['Scaffold_name'].unique())

#Species_name='campylocheta_wood03'
#Change if you have different directory structures 
list_variable_paths=['Tachinids_genomes','Control_genomes','Hymenoptera_genomes']

for variable_path in list_variable_paths:
     ################
     ###Add repeat ##
     ################
     if os.path.exists(main_path+variable_path+"/results/Environment_results/ET/"+Species_name+"/result_mmseqs2.m9") :
        if os.path.exists(main_path+variable_path+"/results/Environment_results/ET/"+Species_name+"/result_mmseqs2_filtred.m8") :
                print("Adding Repeat count analysis for species : ", Species_name)
                subRepeat_tab=pd.read_table(main_path+variable_path+"/results/Environment_results/ET/"+Species_name+"/result_mmseqs2_filtred.m8",sep="\t")
                subRepeat_tab=subRepeat_tab[['query','target','qstart','qend','evalue','bits']]
        elif os.path.exists(main_path+variable_path+"/results/Environment_results/ET/"+Species_name+"/result_mmseqs2.m9") :
            print("Adding Repeat count analysis for species : ", Species_name)
            subRepeat_tab=pd.read_table(main_path+variable_path+"/results/Environment_results/ET/"+Species_name+"/result_mmseqs2.m9",sep="\t",header=None)
            subRepeat_tab.columns=['query','target','qstart','qend','evalue','bits']
            Nb_scaffolds=len(subRepeat_tab['query'].unique())
            # Keep only hits present within a scaffold with candidate EVE loci 
            list_scaffolds_to_keep=Blast_table.loc[Blast_table['Species_name']==Species_name]['Scaffold_name'].unique()
            subRepeat_tab=subRepeat_tab.loc[subRepeat_tab['query'].isin(list_scaffolds_to_keep)]
            # SAVE FILTRED ONLY IF less than 10% OF SCAFFOLDS ARE REMAINING
            if  ((len(subRepeat_tab['query'].unique()) *100) / Nb_scaffolds) < 10 :
                # Save a filtred version of the repeat results 
                subRepeat_tab.to_csv(main_path+variable_path+"/results/Environment_results/ET/"+Species_name+"/result_mmseqs2_filtred.m8",sep="\t")
                print("Filtrer file have been printed to : ",main_path+variable_path+"/results/Environment_results/ET/"+Species_name+"/result_mmseqs2_filtred.m8")
        sLength=subRepeat_tab.shape[0]
        # Add and change coordinates for minus strand hits 
        # Remove every match < 100 pb 
        subRepeat_tab['qmatchlen'] = abs(subRepeat_tab['qend'].astype(int) - subRepeat_tab['qstart'].astype(int))
        subRepeat_tab=subRepeat_tab.loc[subRepeat_tab['qmatchlen'].ge(150)]
        subRepeat_tab=subRepeat_tab.loc[subRepeat_tab['evalue'].lt(0.0000000001)]
        subRepeat_tab=subRepeat_tab.loc[subRepeat_tab['bits'].ge(50)]
        subRepeat_tab['strand']=np.where(subRepeat_tab["qstart"]>subRepeat_tab["qend"],'-','+')
        subRepeat_tab[['qstart', 'qend']] = np.sort(subRepeat_tab[['qstart', 'qend']].values, axis=1)
        m = subRepeat_tab['strand'].eq('-')
        subRepeat_tab = subRepeat_tab.sort_values(['query', 'qend', 'qstart'])
        c1 = subRepeat_tab['query'].shift() != subRepeat_tab['query']
        c2 = subRepeat_tab['qend'].shift() - subRepeat_tab['qstart'] < 0
        subRepeat_tab['overlap'] = (c1 | c2).cumsum()
        subRepeat_tab.reset_index(drop=True, inplace=True)
        # Finally, we get the row with the maximum sum in each group using groupby.
        subRepeat_tab=subRepeat_tab.sort_values(['evalue'], ascending=True).groupby('overlap').first()
        # Remove unknown TEs annotations 
        subRepeat_tab=subRepeat_tab.loc[~subRepeat_tab['target'].str.contains("Unknown")]
        # Tranform result to a count of TEs for each scaffold 
        subRepeat_tab['count_repeat'] = subRepeat_tab.groupby('query')['query'].transform('count')
        print("number of scaffold presenting TE elements : ", len(subRepeat_tab['query'].unique()),' / ',Nb_scaffolds_to_analyse)
        Blast_table_repeat = Blast_table[['Species_name','Scaffold_name']].merge(subRepeat_tab[['query','count_repeat']],right_on="query",left_on="Scaffold_name",how="outer")
        del Blast_table_repeat['query']
        Blast_table_repeat['count_repeat'] = Blast_table_repeat['count_repeat'].fillna(0)
        Blast_table_repeat = Blast_table_repeat.drop_duplicates()
        # Save the Blast file with repeat elements count 


        #############################
        ## Add cov depth pvalues  ###
        #############################
        print("\n")
        print("Adding BUSCO count analysis and pvalue cov depth for species : ", Species_name)
        # Generate pvalues for each scaffolds 
        # Open BUSCO table
        if variable_path=="Hymenoptera_genomes" :
            BUSCO_tab=pd.read_csv(main_path+variable_path+"/results/Stat_Results/"+Species_name+"/BUSCO_results/run_hymenoptera_odb10/full_table.tsv",comment="#",sep="\t",header=None)
        else: 
            BUSCO_tab=pd.read_csv(main_path+variable_path+"/results/Stat_Results/"+Species_name+"/BUSCO_results/run_diptera_odb10/full_table.tsv",comment="#",sep="\t",header=None)
        
        BUSCO_tab.columns = ["Busco id","Status", "Contig","Gene Start","Gene End","Strand","Score","Length","OrthoDB url","Description"]
        BUSCO_tab=BUSCO_tab.loc[BUSCO_tab['Status'].isin(["Complete","fragmented"])]
        # Open mapping coverage table 
        if os.path.exists(main_path+variable_path+"/results/Mapping/"+Species_name+".cov"):
            cov_tab=pd.read_csv(main_path+variable_path+"/results/Mapping/"+Species_name+".cov",sep="\t",header=None)
            cov_tab.columns=['Scaffold_name','Position','cov_depth']
            cov_tab['Median_cov_depth'] = cov_tab.groupby('Scaffold_name')['cov_depth'].transform('median')
            cov_tab['Mean_cov_depth'] = cov_tab.groupby('Scaffold_name')['cov_depth'].transform('mean')
            cov_tab= cov_tab.drop_duplicates(subset=['Scaffold_name'], keep='first')
            del cov_tab['Position']
            Mean_BUSCO_cov= cov_tab.loc[cov_tab['Scaffold_name'].isin(BUSCO_tab['Contig'])]['Mean_cov_depth'].mean()
            cov_tab['cov_depth_BUSCO']=Mean_BUSCO_cov
            list_scaff_count_cov_busco= list((cov_tab.loc[cov_tab['Scaffold_name'].isin(BUSCO_tab['Contig'])]['Mean_cov_depth']))
            cov_tab=cov_tab.loc[cov_tab['Scaffold_name'].isin(Blast_table_repeat['Scaffold_name'])]
            len_scaff_count_cov_busco=len(list_scaff_count_cov_busco)
            #Calculate scaffold containing loci candidate cov pvalues 
            cov_tab['pvalue_cov']="NA"
            for index, row in cov_tab.iterrows():
                    if row['Median_cov_depth'] > Mean_BUSCO_cov:
            	            pvalue=(sum(i > row['Median_cov_depth'] for i in list_scaff_count_cov_busco)/len_scaff_count_cov_busco)
                    else:
            	            pvalue=(sum(i < row['Median_cov_depth'] for i in list_scaff_count_cov_busco)/len_scaff_count_cov_busco)
                    cov_tab.loc[cov_tab['Scaffold_name']==row['Scaffold_name'],"pvalue_cov"]=pvalue
            print("number of scaffold presenting coverage pvalue above 0.05 : ", len(cov_tab.loc[cov_tab['pvalue_cov'].ge(0.05)]),' / ',Nb_scaffolds_to_analyse)
            print("ALL pvalue cov added ")
    
        ################
        ## Add BUSCO ###
        #################
            BUSCO_tab['count_Busco']=BUSCO_tab.groupby('Contig')['Contig'].transform('count')
            BUSCO_tab = BUSCO_tab[['Contig','count_Busco']].drop_duplicates(subset=['Contig'], keep='first')
            cov_tab_Busco=cov_tab.merge(BUSCO_tab,left_on='Scaffold_name',right_on="Contig",how="left")  
            cov_tab_Busco['count_Busco'] = cov_tab_Busco['count_Busco'].fillna(0)
            del cov_tab_Busco['Contig']
            print("number of scaffold presenting BUSCO elements : ", len(cov_tab_Busco.loc[cov_tab_Busco['count_Busco'].gt(0)]),' / ',Nb_scaffolds_to_analyse)
            # Merge all informations 
            Blast_table_repeat_busco_pvalues=Blast_table_repeat.merge(cov_tab_Busco,on="Scaffold_name",how="outer") # <- check if it works for scaffold with missing cov depth 
            # Saving the table
            Blast_table_repeat_busco_pvalues.to_csv(main_path+variable_path+"/results/Environment_results/ET/"+Species_name+"/result_mmseqs2_filtred_TE_BUSCO_cov_depth_pvalues.m8",sep=";",index=False)
            print("All results have been printed to : ",main_path+variable_path+"/results/Environment_results/ET/"+Species_name+"/result_mmseqs2_filtred_TE_BUSCO_cov_depth_pvalues.m8")

        else:
        ################
        ## Add BUSCO ###
        #################
            print (Species_name, " did not have mapping file") 
            BUSCO_tab['count_Busco']=BUSCO_tab.groupby('Contig')['Contig'].transform('count')
            BUSCO_tab = BUSCO_tab[['Contig','count_Busco']].drop_duplicates(subset=['Contig'], keep='first')
            print("number of scaffold presenting BUSCO elements : ", len(BUSCO_tab.loc[BUSCO_tab['count_Busco'].gt(0)]),' / ',Nb_scaffolds_to_analyse)
            # Merge all informations 
            BUSCO_tab = BUSCO_tab.rename(columns={'Contig': 'Scaffold_name'}) 
            Blast_table_repeat_busco=Blast_table_repeat.merge(BUSCO_tab,on="Scaffold_name")
            Blast_table_repeat_busco['Median_cov_depth'] = "NA"
            Blast_table_repeat_busco['cov_depth'] = "NA"
            Blast_table_repeat_busco['Mean_cov_depth'] = "NA"
            Blast_table_repeat_busco['cov_depth_BUSCO'] = "NA"
            Blast_table_repeat_busco['pvalue_cov'] = "NA"
            Blast_table_repeat_busco=Blast_table_repeat_busco[['Species_name','Scaffold_name','count_repeat','cov_depth','Median_cov_depth','Mean_cov_depth','cov_depth_BUSCO','pvalue_cov','count_Busco']]
            # Saving the table
            Blast_table_repeat_busco.to_csv(main_path+variable_path+"/results/Environment_results/ET/"+Species_name+"/result_mmseqs2_filtred_TE_BUSCO_cov_depth_pvalues.m8",sep=";",index=False)
            print("All results have been printed to : ",main_path+variable_path+"/results/Environment_results/ET/"+Species_name+"/result_mmseqs2_filtred_TE_BUSCO_cov_depth_pvalues.m8")   

####Create check output (to counter Snakemake problem):
start_path = '/beegfs/data/soukkal/StageM2/Genomic_environment/'
with open(start_path + Species_name + ".txt", "w") as check:
    check.write('Created file')
