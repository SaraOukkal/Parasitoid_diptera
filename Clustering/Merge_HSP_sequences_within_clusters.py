from Bio import SeqIO
import re
import argparse
import pandas as pd
import os
import collections
from itertools import combinations
import itertools
from collections import defaultdict 
from shutil import copyfile

# Print out a message when the program is initiated.
print('----------------------------------------------------------------\n')
print('                        Merge_HSP_sequences_within_clusters.\n')
print('----------------------------------------------------------------\n')

#----------------------------------- PARSE SOME ARGUMENTS ----------------------------------------
parser = argparse.ArgumentParser(description='Allow to detect and contact Hsp sequences within an alignment')
parser.add_argument("-d", "--directory", help="The directory where to find all clusters directories")
parser.add_argument("-e", "--extension",help="The extension of the alignment files to test for Hsp")
parser.add_argument("-t", "--table_HSP",help="The HSP table with all informations ")

args = parser.parse_args()

#Ex usage: python3 Merge_HSP_sequences_within_clusters.py  -d /beegfs/data/bguinet/these/Sara_M2/Alignment_phylogeny_test -e .aa.aln


# Variable that stores fasta sequences

alignment_directory=args.directory
alignment_directory=alignment_directory+"/Cluster_alignments/"
seqs_directory=args.directory
seqs_directory=seqs_directory+"/Cluster_seqs/"


HSP_table=args.table_HSP


extension=args.extension
#Open a dataframe that will store the HSPs number for each loci 
HSP_data = pd.DataFrame(columns=['Loci_names', 'HSP_name', 'HSP_number'])

HSP_number=0

for filename in os.listdir(alignment_directory):
        if filename.endswith(extension): 
                input_file=filename #The alignment file
                columns=['locus_name']
                df1 = pd.DataFrame(columns=columns)
                df1 = df1.fillna(0)
                d =[]
                records = SeqIO.to_dict(SeqIO.parse(alignment_directory+input_file, 'fasta'))
                for seq_record in SeqIO.parse(alignment_directory+input_file, "fasta"):
                        d.append({'locus_name':seq_record.id})
                dataframe_names=pd.DataFrame(d)
                dataframe_names=dataframe_names.sort_values(by=['locus_name'])
                #Then put all these sequence into a new fasta file 
                list1=[]
                list2=[]
                #with open("file_test", "a") as filetest:
                for index, row in dataframe_names.iterrows():
                        list1.append(records[row['locus_name']].id)
                        list2.append(re.sub(r'[\d]+[-]+[\d]+', '',records[row['locus_name']].id))
                #Display duplicated sequences 
                HSP_sequences=[item for item, count in collections.Counter(list2).items() if count > 1]
                #Do it only if there is at least one candidate for a HSP
                liste_of_hsp=[]
                connected = {}
                if len(HSP_sequences) > 0: 
                        try: 
                            #Create a list of candidate hsp (sequences that are in the same scaffolds)
                            for i in list1:
                                    if re.sub(r'[\d]+[-]+[\d]+', '',i) in HSP_sequences:
                                            liste_of_hsp.append(i)
                            #Here the idea is to create a dictionanry composed of key wich are the group of candidat HSp and their name as value
                            func = lambda x:re.sub(r'[\d]+[-]+[\d]+', '', x)
                            l = sorted(liste_of_hsp, key=func)
                            d = {'key%s' % i: list(g) for i, (k,g) in enumerate(itertools.groupby(l, func))}
                            #Here we will iterate over each keys in order to decide if the sequences inside are rather HSp of duplicates. 
                            for group, elements in d.items():
                                    list_of_hsp=[]
                                    for element1, element2 in combinations(elements, 2):
                                            n = len(records[element1].seq)
                                            if len(records[element2].seq) != n:
                                                    raise ValueError
                                            count_alpha=0
                                            count_gap=0.000000001 #"To avoid divizion by zero"
                                            for c1,c2 in zip(records[element1].seq, records[element2].seq):
                                                    if c1.isalpha()==True and c2.isalpha()==True:
                                                            count_alpha+=1
                                                    if c1.isalpha()==True and c2.isalpha()==False:
                                                            count_gap+=1
                                                    if c1.isalpha()==False and c2.isalpha()==True:
                                                            count_gap+=1
                                            ratio = count_alpha / count_gap 
                                            print(ratio,filename)
                                            if ratio < 0.20: #If less than 10% of the alignment is without nothing, then it should be an HSP
                                                    connected.setdefault(element1, {element1}).add(element2)
                                                    connected.setdefault(element2, {element2}).add(element1)
                            if len(connected) > 0: 
                                    # Search components with DFS
                                    result = []
                                    visited = set()
                                    for elem, conn in  connected.items():
                                            if elem in visited:
                                                    continue
                                            visited.add(elem)
                                            conn = set(conn)
                                            pending = list(conn)
                                            while pending:
                                                    subelem = pending.pop()
                                                    if subelem in visited:
                                                            continue
                                                    visited.add(subelem)
                                                    subconn = connected[subelem]
                                                    conn.update(subconn)
                                                    pending.extend(subconn)
                                            result.append(conn)
                                    #Allow to sort the values in order to concatenate in the proper coordinates
                                    [sorted(y, key=lambda item: tuple(map(int, re.findall(r'\d+', item)))) for y in result]
                                    #Transforme the set into a list
                                    new_list=[]
                                    for i in result:
                                            new_list.append(list(i))
                                    candidate_list=[]
                                    for i in range(len(new_list)):
                                            for element in new_list[i]:
                                                    candidate_list.append(element)
                                    print(candidate_list)
                                    #Focus on non-candidate sequences: 
                                    Fasta_sequences_not_candidates=[]
                                    for i in list1:
                                            if i not in str(candidate_list):
                                                    Fasta_sequences_not_candidates.append(i)
                                    print("Fasta",Fasta_sequences_not_candidates)
                                    #The idea now is to overwrite the fasta file in order to save the new fasta sequences (concatenated)      
                                    #First we will remove sequence that are in the original fasta file, to do so we will get their name :
                                    ffile = SeqIO.parse(alignment_directory+input_file, "fasta")
                                    header_set = set(line.strip() for line in open(alignment_directory+input_file))
                                    res = defaultdict(list)
                                    HSP_number+=1
                                    for sublist in new_list:
                                            print("1",sublist)
                                            if any("_-__" in s for s in sublist):
                                                    sublist.sort(reverse = True)
                                            if any("_+__" in s for s in sublist):
                                                    sublist.sort(reverse = False)
                                            print("2",sublist)
                                    print("Modifying aa sequence as well...")
                                    res = defaultdict(list)
                                    print("Saving to : ",seqs_directory+re.sub(r'.aa.aln','aa_HSP', filename))
                                    with open(seqs_directory+re.sub(r'.aa.aln','aa_HSP', filename), "w") as f :
                                            records = SeqIO.to_dict(SeqIO.parse(alignment_directory+input_file, "fasta")) 
                                            for sublist in new_list:
                                                    for i in sublist:
                                                            res[re.sub(r'[\d]+[-]+[\d]+', str(len(sublist))+"-HSPs",records[i].id)].append(records[i].seq)
                                            for i in Fasta_sequences_not_candidates:
                                                    print(">",records[i].id,sep="",file=f)
                                                    print(records[i].seq,sep="",file=f)
                                    print("res",res)
                                    with open(seqs_directory+re.sub(r'.aa.aln','aa_HSP', filename), "a") as f :
                                            for k,v in sorted(res.items()):
                                                    print("k1",k)
                                                    print(">",k,sep="",file=f)
                                                    for i in v:
                                                            print(i,sep="",file=f)
                                                            print("v1",v)
                                    #save ancient file 
                                    #copyfile(alignment_directory+input_file,seqs_directory+input_file+"_saved")
                                    #Nucleotides 
                                    print("Modifying dna sequence as well...")
                                    res = defaultdict(list)
                                    print("Saving to : ",seqs_directory+re.sub(r'.aa.aln','dna_HSP', filename))
                                    with open(seqs_directory+re.sub(r'.aa.aln','dna_HSP', filename), "w") as f :
                                            records = SeqIO.to_dict(SeqIO.parse(seqs_directory+re.sub(r'.aa.aln','.dna', filename),'fasta')) 
                                            for sublist in new_list:
                                                    for i in sublist:
                                                            print(i,k,records[i].id)
                                                            res[re.sub(r'[\d]+[-]+[\d]+', str(len(sublist))+"-HSPs",records[i].id)].append(records[i].seq)
                                                            HSP_data=HSP_data.append({"Loci_names": str(i),"HSP_name":  str(k),"HSP_number":HSP_number}, ignore_index=True)
                                            for k,v in sorted(res.items()):
                                                    print("k2",k)
                                                    print(">",k,sep="",file=f)
                                                    for i in v:
                                                            print("v2",v)
                                                            print(i,sep="",file=f)
                                            for i in Fasta_sequences_not_candidates:
                                                    print(">",records[i].id,sep="",file=f)
                                                    print(records[i].seq,sep="",file=f)
                                    #save ancient file 
                                    #copyfile(seqs_directory+re.sub(r'.aa.aln','.dna'), seqs_directory+re.sub(r'.aa.aln','.dna_saved'))
                            else: 
                                    print("no HSP found for the cluster: ",filename)
                        except:
                            continue
                else: 
                                print("no HSP found for the cluster: ",filename)
        else:
                continue


print(HSP_data)
HSP_data.to_csv(HSP_table,sep=";",index=False)
