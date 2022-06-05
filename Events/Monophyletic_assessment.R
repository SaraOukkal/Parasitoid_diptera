#!/usr/bin/env Rscript
library(ape)
library(phangorn)
library(seqinr)
library(tidytree)
library(ggplot2)
library(dplyr)
library(phytools)

args <- commandArgs(TRUE)
# test if there is at least one argument: if not, return an error
if (length(args)==0) {
  stop("Please, add a file with one specie name / line and the path /path/Project/", call.=FALSE)
}

#Revoir ordre des arguments 
Tree_file <- args[1] #The Species phylogenetic tree
Cluster_directory <- args[2] #The directory where are found all the cluster file with the extension .treefile
monophylyprop <- args[3] # The monophylyprop option determines how monophyletic a species group in the cluster tree should be in the species tree. 1 = 100% monoph. 0.6 = at least 60% monoph.
Output_table_file <- args[4] #The Outpute file with full directory
Blast_table_scores <- args[5] #The table with scores
taxo <- args[7]

taxo<-read.table("/Users/bguinet/Desktop/Monophyletic_assessment/Species_tab.txt", header=T,sep="\t")
Tree_file<-'/Users/bguinet/Desktop/Monophyletic_assessment/Concatenated_BUSCO_sequences.treefile'
Blast_table_scores<-"/Users/bguinet/Desktop/Monophyletic_assessment/ET_BUSCO_Cov_FDR_blast.txt"
Cluster_directory<-"/Users/bguinet/Desktop/Monophyletic_assessment/"
Output_table_file <-"/Users/bguinet/Desktop/Monophyletic_assessment/Monophyletic_assesment.tab"

sptr<-read.tree(Tree_file)
sptr$node.label[which(sptr$node.label=="")]<-"100/100"


#Function to test inclusion of one partition inside another

isincludedin<-function(arr, clan) {
  arr1<-clan[arr[1],]
  arr2<-clan[arr[2],]
  return(min(arr2-arr1)!="-1")
}

##transform species tree int a matrix
spmat<-t(do.call(cbind, lapply(lapply(subtrees(sptr), function(x) x$tip.label),function(a,b) is.element(b,a),b=sptr$tip.label)))+0
colnames(spmat)<-sptr$tip.label
rownames(spmat)<-sptr$node.label
mat2<-matrix(0,ncol=Ntip(sptr), nrow=Ntip(sptr))
diag(mat2)<-1
rownames(mat2)<-rep("100/100", Ntip(sptr))
spmat<-rbind(mat2, spmat)
##get all clustr names

##get all clustr names


testinspmat<-function(sps,spmat) {
  max(apply(spmat[,sps],1,sum))
}

filtermonoph<-function(monoph,clans,spmat,thres,cluster) {
  sps<-unique(names(which(clans[monoph,]==1)))
  print(sps)
  sub<-which(apply(spmat[,sps,drop=F],1,sum)==length(sps))
  nbdesccontainingsps<-apply(spmat[sub,,drop=F],1,sum)
  #Allow a lower threshold when only 4 taxa within the monophyletic group
  small_nbdesccontainingsps <- nbdesccontainingsps[nbdesccontainingsps<5]
  prop<-length(sps)/nbdesccontainingsps
  small_prop <- length(sps)/small_nbdesccontainingsps
  if(length(small_prop[small_prop>0.60]>=0.60)>=1){
    if(length(small_prop[small_prop>0.80]>=0.60)==0){
      print(paste0(sps,cluster))
    }
  }
  if(length(small_prop[small_prop>0.60]>=0.60)>=1){
    return(max(small_prop)>=0.60)
  }else{
    return(max(prop)>=thres)
  }
}




Blast_table<-read.csv(Blast_table_scores ,sep=";",h=T)
Blast_table$label<- gsub("):","__",Blast_table$Names)
Blast_table$label<- gsub("\\(","_",Blast_table$label)
Blast_table$label<- gsub(":","_",Blast_table$label)
Blast_table$label<- gsub("\\+","_",Blast_table$label)
Blast_table$label<- gsub("____","_+__",Blast_table$label)
#Remove duplicate keep first 
Blast_table<-Blast_table %>% distinct(label, .keep_all = TRUE)

level<-"Famille"
GetClades<-function(cluster="/Users/bguinet/Desktop/these/Cluster_phylogeny_filtred/Cluster0_AA.dna.treefile", level="Famille",monophylyprop=0.8,otherwise = NA) {
  #read gene tree
  #cluster<-"Cluster76.faa.aln.treefile"
  gntr<-read.tree(paste0(Cluster_directory,cluster))
  gntr<- unroot( gntr)
  gntr2<-as_tibble(gntr)
  #Merge with scaffold score
  gntr2<-left_join(fortify(gntr2), fortify(select(Blast_table,'label','Scaffold_score')), by=c('label'))
  toMatch <- c("A","B","C","D")
  if (length(unique (grep(paste(toMatch,collapse="|"), gntr2$Scaffold_score, value=TRUE)))>=1) {
    
    gntr2$label<-paste0("_",gntr2$Scaffold_score,"_",gntr2$label)
    gntr2$label<-gsub("_NA_","",gntr2$label)
    gntr2<-left_join(as_tibble(gntr, ladderize = FALSE),select(gntr2,-c(,"parent",'branch.length','Scaffold_score')) , by = c("node" = "node"))
    gntr2$label.x<-NULL
    names(gntr2)[names(gntr2)=="label.y"] <- "label"
    #If X to E, then remove __ to _ in order to not pass the filter
    nb <- 1
    label_list<-c()
    for (i in gntr2$label){
      if (nchar(i) > 4) {
        label_list[[nb]] <-i
        nb <- nb + 1
      }
    }
    i <- grepl( "(_X_|_F_|_E_)", label_list )
    label_list <- gsub( "____", "_+__", label_list )
    
    label_list[i] <- gsub( "__", "_", label_list[i] )
    #Remove letters 
    label_list<-sub("_A_", "",label_list)
    label_list<-sub("_B_", "",label_list)
    label_list<-sub("_C_", "",label_list)
    label_list<-sub("_D_", "",label_list)
    label_list<-sub("_E_", "",label_list)
    label_list<-sub("_F_", "",label_list)
    label_list<-sub("_X_", "",label_list)
    gntr$tip.label <-label_list
    
    
    if (length(label_list[grepl('__', label_list)])>=1000000){
      RES <- data.frame(matrix(ncol = 7, nrow = 0))
      #provide column names
      colnames(RES) <- c('Cluster', 'Event', 'Nloc','Nsp', 'Nsp_MRCA','Tips4dNdS.array', 'Boot')
      Nloc<-1
      Nsp<-1
      Nsp_MRCA<-1
      Cluster<-gsub(".faa.aln.treefile","",cluster)
      Tips4dNdS.array<-list(label_list[grepl('__', label_list)])[[1]][[1]]
      Boot<-NA
      RES<-cbind(Cluster, Event, Nloc,Nsp, Nsp_MRCA,Tips4dNdS.array, Boot)
      RES$Event
      RES<-RES[!duplicated(RES), ]
      
      return(RES)
    }else{
    
    #Remove letters 
    #prepare clans
    cl2<-getClans(gntr)
    #add rownames if missing
    if (is.null(rownames(cl2))) rownames(cl2)<-rep("-1", nrow(cl2))
    #	sizebipar<-apply(cl2,1,sum)
    nam<-colnames(cl2)
    spnam<-unlist(lapply(strsplit(colnames(cl2), "__"), function(x) x[2]))
    if (sum(!is.na(spnam))>0){
      #rename clans based on the taxonomic level chosen
      nam2<-taxo[,level][match(spnam,taxo$Nom_arbre)]
      nam2<-as.character(nam2)
      nam2[is.na(nam2)]<-"Virus"
      cl3<-cl2
      cl4<-cl2
      colnames(cl3)<-nam2
      colnames(cl4)<-spnam
      testMonophyly<-apply(cl3,1, function(x) unique(names(x[x==1])))
      monophgroups<-which(unlist(lapply(testMonophyly, function(x) (length(x)==1)&x[1]!="Virus")))
      ##We only keep monoph groups that are monophyletic (or almost, depending on monophylyprop)
      monophgroups<-monophgroups[sapply(monophgroups, filtermonoph, clans=cl4,spmat=spmat,thres=monophylyprop,cluster=cluster)]
      
      #issue 
      if (length(monophgroups)==1) clades<-monophgroups 
      ##now we remove groups included in others, to only keep the largest ones.
      else {
        allcompare<-cbind(rep(monophgroups, each=length(monophgroups)), rep(monophgroups, length(monophgroups)))
        allcompare<-allcompare[(allcompare[,1]-allcompare[,2])!=0,] ##remùove self comparison
        getinclusions<-apply(allcompare,1,isincludedin,clan=cl2) #is group of column 1 included in group of colmumn two
        toremove<-unique(allcompare[getinclusions,1])
        tokeep<-setdiff(monophgroups, toremove)
        clades<-monophgroups[match(tokeep,monophgroups)]
      }
      
      #PREPARE DATA FOR OUTPUT
      Cluster<-rep(strsplit(cluster, ".fa")[[1]][1], length(clades))
      Cluster<-gsub("\\..*","",Cluster)
      Cluster_name<-strsplit(cluster, ".fa")[[1]][1]
      Cluster_name<-gsub("\\..*","",Cluster_name)
      #Cluster_name<-sub('\\..*', "", Cluster_name)
      Event<-1:length(clades) #as YOU did
      Nloc<--array() #nb of species in each monoph clade
      Nsp<-array()
      Nsp_MRCA<-array() #size of the smallest clade containing these species in the species tree
      Tips4dNdS<-apply(cl2[clades,,drop=FALSE],1,function(x) names(x[x==1])) #C'est une liste, plus pratique pour caluler ensuite le dNdS?
      
      ##CALCUL DNDS.
      #alignment_file <- paste("/beegfs/data/bguinet/M2/dNdS_calculation/",Cluster_name,".codon.fa.aln",sep="")
      #alignment<-read.alignment(alignment_file,'fasta')
      #kaks_matrix<-kaks(alignment, verbose =F, debug = FALSE, forceUpperCase = TRUE)
      #omega<-kaks_matrix$ka/kaks_matrix$ks
      #omega<-as.matrix(omega)
      #write.table(omega, file=paste0("/beegfs/data/bguinet/M2/dNdS_calculation/",Cluster_name,"_kaks_matrix"), sep = "\t")
      
      Tips4dNdS.array<-apply(cl2[clades,,drop=FALSE],1,function(x) paste("[",paste(paste("'",names(x[x==1]),"'",sep=""),collapse=","),"]",sep="")) #idem en mode caractères
      Boot<-names(clades) #tout simplement.
      Family<-unlist(testMonophyly[clades])
      for (i in 1:length(clades)) {
        speciesinclade<-spnam[cl2[clades[i],]==1]
        Nsp[i]<-length(unique(speciesinclade))
        Nloc[i]<-length(speciesinclade)
        if (Nsp[i]>1) {
          Nsp_MRCA[i]<-length(Descendants(sptr, getMRCA(sptr,unique(speciesinclade)), type="tips")[[1]])
        }
        else {
          Nsp_MRCA[i]<-1 #should be 1?
        }
      }	
      RES<-cbind(Cluster, Event, Nloc,Nsp, Nsp_MRCA,Tips4dNdS.array, Boot)
      rownames(RES)<-NULL
      return(RES)
    }
  
    else {
      RES<-NULL
      RES<-cbind(Cluster, Event, Nloc,Nsp, Nsp_MRCA,Tips4dNdS.array, Boot)
      return(RES)
    }
    }
  }
}


setwd("/Users/bguinet/Desktop/Monophyletic_assessment/")
clus<-list.files(pattern = "\\.faa.aln.treefile")
#clus


clus<- clus[clus !="Cluster32135.faa.aln.treefile"] #<- to big


RESULT<-NULL
for (i in 1:length(clus)) {
  print(paste(i,clus[i],sep=" - "))
  RESULT<-rbind(RESULT, GetClades(clus[i],"Famille",0.8))
}

write.table(RESULT,Output_table_file,sep=";")





