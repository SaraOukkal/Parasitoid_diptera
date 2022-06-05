

## PART1
######## Treate de file ########

#
All_information_df<- read.csv("/Users/bguinet/Desktop/Dossier_SARA/ET_BUSCO_FDR_BLAST_FILTRED_MONOP_TAXID_VIRUS.tab",sep=";",header=T,na.strings=c("","NA")) 

library(plyr)
All_information_df<-rename(All_information_df,c("Cluster" = "Clustername"))
All_information_df<-rename(All_information_df,c("Names" = "query"))
All_information_df<-rename(All_information_df,c("Genome_Composition" = "genomic_structure"))
All_information_df<-rename(All_information_df,c("Names2" = "query_bis"))
All_information_df<-rename(All_information_df,c("cov_depth" = "cov_depth_candidat"))


detachAllPackages()
library(data.table)
library(stringr)
library(randomcoloR)
library(dplyr)
library(phytools)
library(phylogram)
library(tibble)
library(fpc)
library(gplots)
library(ape)
library(rlist)
library(ggtree)

#Deal with Cluster without Events
All_information_df <- All_information_df %>%                              
  group_by(Clustername) %>%
  mutate(Nquery_in_cluster = n_distinct(query))


HSP_Cluster_lists<-c("Cluster10690",
                     "Cluster1187",
                     "Cluster12001",
                     "Cluster12184",
                     "Cluster12433",
                     "Cluster12438",
                     "Cluster13774",
                     "Cluster1569",
                     "Cluster16379",
                     "Cluster16419","Cluster18868","Cluster20668",
                     "Cluster27258",
                     "Cluster28741",
                     "Cluster30158",
                     "Cluster31624",
                     "Cluster571",
                     "Cluster641",
                     "Cluster9709",
                     "Cluster9849")
#Remove HSP Clusters 
All_information_df<-All_information_df[!All_information_df$Clustername %in% HSP_Cluster_lists,]

#Remove big clusters  without Events 
#All_information_df<-All_information_df[! (is.na(All_information_df$Event) & All_information_df$Nquery_in_cluster>2),]

Failed_clusters<- c("Cluster12433","Cluster28741", "Cluster571","Cluster12001","Cluster9709","Cluster31624","Cluster12438", 
                    "Cluster9849","Cluster12148","Cluster1187","Cluster19090","Cluster1569","Cluster16379","Cluster18868","Cluster27258","Cluster30158","Cluster13774", "Cluster12746")

All_information_df<-All_information_df[!All_information_df$Clustername %in% Failed_clusters,]

#Deal with Clusters without Event assignation but that correspond to only 2 loci 
All_information_df$Event[is.na(All_information_df$Event) & All_information_df$Nquery_in_cluster==1]<- 1

# Remaining Cluster without Events 
All_information_df[is.na(All_information_df$Event) & All_information_df$Scaffold_score %in% c('A','B','C','D'),]

Endo_parasitoid_diptera<-c("aplomyopsis_wood01",
                           "archytas_wood02",
                           "argyrochaetona_cubanadhj02",
                           "argyrophylax_albincisadhj04",
                           "argyrophylax_wood05",
                           "atacta_brasiliensisdhj01",
                           "austrophorocera_wood05",
                           "belvosia_woodley07g",
                           "belvosia_woodley10",
                           "calolydella_erasmocoronadoi",
                           "calolydella_timjamesi",
                           "campylocheta_wood03",
                           "chetogena_scutellarisdhj01",
                           "chrysoexorista_wood01dhj02",
                           "chrysoexorista_wood04",
                           "chrysotachina_wood01",
                           "chrysotachina_wood02dhj02",
                           "cordyligaster_capellii",
                           "drino_wood06dhj01",
                           "drino_wood06dhj05",
                           "genea_wood01",
                           "genea_wood03dhj01",
                           "houghia_bivittata",
                           "houghia_brevipilosa",
                           "houghia_graciloides",
                           "houghia_pallida",
                           	"hyphantrophaga_virilis",
                           "hyphantrophaga_wood11",
                           "jurinella_wood01",
                           "leschenaultia_wood15",
                           "leskia_janzen27",
                           "leskia_wood01dhj03",
                           "lixophaga_wood06",
                           "lixophaga_wood09",
                           "siphosturmia_rafaelidhj03",
                           "siphosturmia_wood02",
                           "zizyphomyia_argutadhj02","GCA_019393585.1","GCA_001855655.1","GCF_015476425.1","GCA_001855655.1","GCA_009823575.1")

Ecto_parasitoid_diptera <- c("GCA_907269105.1","GCA_003055125.1","GCA_003952975.1","GCF_000699065.1","GCA_004302925.1")

parasitoid_diptera<- c(Ecto_parasitoid_diptera,Endo_parasitoid_diptera)
# Add lifestyles 

All_information_df$lifecycle1[All_information_df$Species_name %in% Endo_parasitoid_diptera]<-"endoparasitoid"
All_information_df$lifecycle1[All_information_df$Species_name %in% Ecto_parasitoid_diptera]<-"ectoparasitoid"
All_information_df$lifecycle1[!All_information_df$Species_name %in% parasitoid_diptera]<-"freeliving"


# Arrange some unknown families by hand 

All_information_df$family[All_information_df$species=="Leptopilina_boulardi_filamentous_virus"]<-"LbFV_like"
All_information_df$family[All_information_df$species=="Leptopilina_boulardi_filamentous_virus"]<-"LbFV_like"
All_information_df$family[All_information_df$species=="Leptopilina_boulardi_filamentous_virus"]<-"LbFV_like"
All_information_df$genomic_structure[All_information_df$species=="Leptopilina_boulardi_filamentous_virus"]<-"dsDNA"


## Add best family per query 
All_information_df$family[is.na(All_information_df$family)]<-"Unknown"
All_information_df$genomic_structure[is.na(All_information_df$genomic_structure)]<-"Unknown"

# Add family to the unknown RNA seq 

Shi_RNA_classification<- read.csv("/Users/bguinet/Desktop/RNA_classification.csv",sep=";")
Shi_RNA_classification$Virus.Name..or.published.sequences.<- gsub(" (ref)","",Shi_RNA_classification$Virus.Name..or.published.sequences.)
Shi_RNA_classification$Virus.Name..or.published.sequences.<- gsub(" ","_",Shi_RNA_classification$Virus.Name..or.published.sequences.)

All_information_df$best_family_per_query2 <- Shi_RNA_classification$Classification[match(All_information_df$species, Shi_RNA_classification$Virus.Name..or.published.sequences.)]

All_information_df$best_family_per_query<- ifelse(All_information_df$best_family_per_query=="Unknown", All_information_df$best_family_per_query2, All_information_df$best_family_per_query)


All_information_df$family<- ifelse(All_information_df$family=="Unknown", All_information_df$best_family_per_query2, All_information_df$family)
All_information_df$consensus_family<- ifelse(All_information_df$consensus_family=="Unknown", All_information_df$best_family_per_query2, All_information_df$consensus_family)

## Several additional features that could improve the table 
All_information_df$genomic_structure[All_information_df$species=='Abisko_virus']<-'ssRNA'
All_information_df$family[All_information_df$species=='Abisko_virus']<-'Abisko-like'
All_information_df$consensus_family[All_information_df$species=='Abisko_virus']<-'Abisko-like'

All_information_df$genomic_structure[All_information_df$family=="Partiti-Picobirna"] <- "dsRNA"

All_information_df$genomic_structure[All_information_df$family=="Narna-Levi"] <- "ssRNA"

All_information_df$genomic_structure[All_information_df$family=="Mono-Chu"] <- "ssRNA"

All_information_df$genomic_structure[All_information_df$family=="Luteo-Sobemo"] <- "ssRNA"

All_information_df$genomic_structure[All_information_df$family=="Bunya-Arenao"] <- "ssRNA"

All_information_df$genomic_structure[All_information_df$family=="Picorna-Calici"] <- "ssRNA"

All_information_df$genomic_structure[All_information_df$family=="Tombusviridae"] <- "ssRNA"

All_information_df$genomic_structure[All_information_df$family=="Tombus-Noda"] <- "ssRNA"

All_information_df$genomic_structure[All_information_df$family=="Phenuiviridae"] <- "ssRNA"

All_information_df$genomic_structure[All_information_df$All_information_df$family=="Partiti-Picobirna"] <- "dsRNA"

All_information_df$genomic_structure[All_information_df$family=="Chuviridae"] <-"ssRNA"
All_information_df$genomic_structure[All_information_df$family=="Cruciviridae"] <-"ssDNA"

All_information_df$family[All_information_df$species=="Dipteran_anphevirus"] <- "Xinmoviridae"
All_information_df$family[All_information_df$species=="Dipteran_anphevirus"] <- "Xinmoviridae"

All_information_df$genomic_structure[All_information_df$family=="Xinmoviridae"]<-"ssRNA"
All_information_df$genomic_structure[All_information_df$family=="Lispiviridae"]<-"ssRNA"
All_information_df$genomic_structure[All_information_df$family=="Narna-Levi"]<-"ssRNA"
All_information_df$genomic_structure[All_information_df$family=="Metaviridae"]<-"dsDNA"

All_information_df$genomic_structure[All_information_df$species=="Loreto_virus"]<-"ssRNA"
All_information_df$family[All_information_df$species=="Loreto_virus"]<-"Negevirus-like"
All_information_df$family[All_information_df$species=="Loreto_virus"]<-"Negevirus-like"
All_information_df$genomic_structure[All_information_df$species=="Piura_virus"]<-"ssRNA"
All_information_df$family[All_information_df$species=="Piura_virus"]<-"Negevirus-like"

All_information_df$genomic_structure[All_information_df$family =="Hepe-Virga"] <-"ssRNA"

All_information_df$family[All_information_df$species=="Shahe_heteroptera_virus_3"]<-"Bunya-Arena"
All_information_df$genomic_structure[All_information_df$species=="Shahe_heteroptera_virus_3"]<-"ssRNA"

All_information_df$genomic_structure[All_information_df$species=="Shuangao_insect_virus_7"]<-"ssRNA"
All_information_df$family[All_information_df$species=="Shuangao_insect_virus_7"]<-"Unknown"

All_information_df$genomic_structure[All_information_df$species=="Wuhan_flea_virus" ]<-"ssRNA"
All_information_df$family[All_information_df$species=="Wuhan_flea_virus" ]<-"Unknown"

All_information_df$genomic_structure[All_information_df$species=="Wuhan_aphid_virus_1"]<-"ssRNA"
All_information_df$family[All_information_df$species=="Wuhan_aphid_virus_1"]<-"Unknown"

All_information_df$genomic_structure[All_information_df$species=="Circulifer_tenellus_virus_1"]<-"dsRNA"
All_information_df$family[All_information_df$species=="Circulifer_tenellus_virus_1"]<-"Unknown"

All_information_df$genomic_structure[All_information_df$species=="Persimmon_latent_virus"]<-"dsRNA"
All_information_df$family[All_information_df$species=="Persimmon_latent_virus"]<-"Unknown"

All_information_df$genomic_structure[All_information_df$species=="Shuangao_lacewing_virus_2"]<-"ssRNA"
All_information_df$family[All_information_df$species=="Shuangao_lacewing_virus_2"]<-"Unknown"

All_information_df$genomic_structure[All_information_df$species=="Shayang_fly_virus_4"]<-"ssRNA"
All_information_df$family[All_information_df$species=="Shayang_fly_virus_4"]<-"Unknown"

All_information_df$genomic_structure[All_information_df$species=="Spissistilus_festinus_virus_1"]<-"dsRNA"
All_information_df$family[All_information_df$species=="Spissistilus_festinus_virus_1"]<-"Unknown"

All_information_df$genomic_structure[All_information_df$species=="Spissistilus_festinus_virus_1"]<-"dsRNA"
All_information_df$family[All_information_df$species=="Spissistilus_festinus_virus_1"]<-"Unknown"

All_information_df$genomic_structure[is.na(All_information_df$genomic_structure)]<-"Unknown"

All_information_df$family[All_information_df$family == "Unknown" & All_information_df$genomic_structure =="dsRNA"]<-"Unknown"


All_information_df$consensus_genomic_structure <- NULL
All_information_df <-All_information_df %>% 
  filter(genomic_structure != "Unknown") %>%
  group_by(Clustername,Event) %>%
  arrange(evalue, desc(bits)) %>% 
  dplyr::slice(1) %>% 
  select(Clustername, Event, consensus_genomic_structure = genomic_structure) %>% 
  right_join(All_information_df, by = c("Clustername", "Event")) %>% 
  relocate(consensus_genomic_structure, .after = genomic_structure)

All_information_df$consensus_family<-NULL
All_information_df <-All_information_df %>% 
  filter(family != "Unknown") %>%
  group_by(Clustername) %>%
  arrange(evalue, desc(bits)) %>% 
  dplyr::slice(1) %>% 
  select(Clustername, consensus_family = family) %>% 
  right_join(All_information_df, by = c("Clustername")) %>% 
  relocate(consensus_family, .after = family)

All_information_df$best_family_per_Event <- NULL
All_information_df <-All_information_df %>% 
  filter(family != "Unknown") %>%
  group_by(Clustername,Event) %>%
  arrange(evalue, desc(bits)) %>% 
  dplyr::slice(1) %>% 
  select(Clustername,Event, best_family_per_Event = family) %>% 
  right_join(All_information_df, by = c("Clustername","Event")) %>% 
  relocate(best_family_per_Event, .after = family)

All_information_df$best_family_per_query <- NULL
All_information_df <-All_information_df %>% 
  filter(family != "Unknown") %>%
  group_by(query) %>%
  arrange(evalue, desc(bits)) %>% 
  dplyr::slice(1) %>% 
  select(query, best_family_per_query = family) %>% 
  right_join(All_information_df, by = c("query")) %>% 
  relocate(best_family_per_query, .after = family)


All_information_df$consensus_family[is.na(All_information_df$consensus_family)]<-"Unknown"

All_information_df$consensus_family <-  gsub('unknown', 'Unknown', All_information_df $consensus_family)


All_information_df_save<-All_information_df

# Deal with the fact you do not have dN/dS or TPM analysis 

All_information_df$Mean_dNdS<-NA
All_information_df$SE_dNdS<-NA
All_information_df$Pvalue_dNdS<-NA
All_information_df$Pvalue_dNdS<-NA
All_information_df$TPM_all<-NA
All_information_df$pseudogenized <-NA
All_information_df$FDR_pvalue_dNdS <-NA


All_information_df$genomic_structure<-as.character(All_information_df$genomic_structure)
All_information_df$family<-as.character(All_information_df$family)


All_information_df_consensus<-All_information_df 

All_information_df_consensus<-All_information_df_consensus[order(All_information_df_consensus$evalue, decreasing = F),]  

library(data.table)
Restricted_df<-All_information_df_consensus
Restricted_df <- setDT(Restricted_df)
Restricted_df_heatmap <- setDT(Restricted_df)



Restricted_df_heatmap$New_query_bis2<-Restricted_df_heatmap$query
#names(Restricted_df_heatmap)[names(Restricted_df_heatmap)=="query2"] <- "query"
Restricted_df_heatmap$query<-Restricted_df_heatmap$Species_name
#Delete the scaffolds names in the query names
#Restricted_df_heatmap[,Scaffold_name := str_extract(query,"[^:]+")]
#Restricted_df_heatmap[,query := str_extract(query,"(?<=[0-9]\\([+-]\\):)[A-z ]+")]

Restricted_df_heatmap$consensus_genomic_structure<- as.character(Restricted_df_heatmap$consensus_genomic_structure)


#Subset the dataframe per genomic structure : 
List_dsDNA_genomic_structure=c("dsDNA","dsDNA-RT")
List_ssDNA_genomic_structure=c( "ssDNA","ssDNA(+/-)","ssDNA(-)","ssDNA(+)")
List_dsRNA_genomic_structure=c("dsRNA")
List_ssRNA_genomic_structure=c("ssRNA-RT" ,"ssRNA(-)" ,"ssRNA(+)" ,"ssRNA(+/-)","ssRNA")
List_Unknown_genomic_structure=c("Unknown","NA")
List_UnknownRNA_genomic_structure=c("Unknown_RNA")

#Restricted_df_heatmap<-subset(Restricted_df_heatmap, consensus_genomic_structure %in% List_ssRNA_genomic_structure)

length(unique(Restricted_df_heatmap$Clustername))

test_df <-Restricted_df_heatmap 
          
test_df2<-test_df[test_df$Scaffold_score %in% c("A","B","C",'D'),]


remove_freeliving_clusters <- test_df %>%
  group_by(Clustername) %>%
  filter(all(grepl('X|F', Scaffold_score)))

length(unique(test_df$query_bis))
test_df <- setDT(test_df )

library(dplyr)
#Deal wit TPM data 
TPM_table<-tidyr::pivot_wider(test_df, names_from = Clustername, values_from = TPM_all,
                              values_fn = list(TPM_all = ~any(. > 1000)), values_fill = FALSE,id_cols = query)


#Merge the two info where uppercase mean that the scaffold contain several candidat loci
Env_table<-as.data.frame(test_df) 

#Fill Nas consensus families as the family of other mates 

Mode <- function(x) {
  ux <- unique(x)
  ux[which.max(tabulate(match(x, ux)))]
}

#Env_table<-Env_table %>%
#  mutate(consensus_family = as.character(consensus_family)) %>%
#  group_by(Clustername, Event) %>%
#  mutate(consensus_family = replace(consensus_family, is.na(consensus_species_family)|consensus_family %in% "unknown", 
#                                    Mode(consensus_family[consensus_family != "unknown"])))



#In order to correct Clusters where there is no phylogenies and then no Events (we add them events numbers)
Env_table$Event<-as.numeric(Env_table$Event)


Env_table$consensus_family[Env_table$consensus_family=="LbFV-like family"]<-"LbFV_like"
Env_table$best_family_per_query[Env_table$best_family_per_query=="LbFV-like family"]<-"LbFV_like"

Env_table$best_family_per_Event[Env_table$best_family_per_Event=="LbFV-like family"]<-"LbFV_like"
#print some informations 
#Number of total paralogs endogenized 
length(unique(Env_table[Env_table$Scaffold_score %in% c("A","B","C",'D'),]$query_bis))
length(unique(Env_table[Env_table$Scaffold_score %in% c("A"),]$query_bis))
length(unique(Env_table[Env_table$Scaffold_score %in% c("B"),]$query_bis))
length(unique(Env_table[Env_table$Scaffold_score %in% c("C"),]$query_bis))
length(unique(Env_table[Env_table$Scaffold_score %in% c("D"),]$query_bis))
length(unique(Env_table[Env_table$Scaffold_score %in% c("E"),]$query_bis))
length(unique(Env_table[Env_table$Scaffold_score %in% c("F"),]$query_bis))
length(unique(Env_table[Env_table$Scaffold_score %in% c("X"),]$query_bis))


length(unique(Env_table[Env_table$consensus_genomic_structure %in% c("ssRNA","dsRNA") ,]$query_bis))

length(unique(Env_table[Env_table$Scaffold_score %in% c("X","F")& Env_table$consensus_genomic_structure %in% c("ssRNA","dsRNA") ,]$query_bis))

length(unique(Env_table[Env_table$Scaffold_score %in% c("X","F") & Env_table$consensus_genomic_structure %in% c("ssRNA","dsRNA") ,]$Scaffold_name))
#
Env_table$cov_depth_BUSCO[is.na(Env_table$cov_depth_BUSCO)]<- -1
Env_table$cov_depth_BUSCO <- as.numeric(Env_table$cov_depth_BUSCO)

Env_table$cov_depth_candidat[is.na(Env_table$cov_depth_candidat)]<- -1
Env_table$cov_depth_candidat <- as.numeric(Env_table$cov_depth_candidat)

Env_table   <-Env_table[!(Env_table$Scaffold_score=="D" & Env_table$cov_depth_BUSCO > Env_table$cov_depth_candidat),]

Env_table<-Env_table[Env_table$Scaffold_score %in% c("A","B","C","D"),]
#Env_table<-Env_table[Env_table$Scaffold_score %in% c("A"),]
#Env_table<-Env_table[Env_table$Scaffold_score %in% c("X","F","E"),]

#We do that here and not only in python since we need to include only species that passed the filter 
Env_table <-Env_table %>%
  group_by(Clustername, Event) %>%
  mutate(Events_species = sprintf('[%s]', toString(query)))



## PART2 
######## Calculate Events ########



#BEGIN

detachAllPackages <- function() {
  
  basic.packages <- c("package:stats","package:graphics","package:grDevices","package:utils","package:datasets","package:methods","package:base")
  
  package.list <- search()[ifelse(unlist(gregexpr("package:",search()))==1,TRUE,FALSE)]
  
  package.list <- setdiff(package.list,basic.packages)
  
  if (length(package.list)>0)  for (package in package.list) detach(package, character.only=TRUE)
  
}

library(treeio)


expand.grid.unique <- function(x, y, include.equals=FALSE)
{
  x <- unique(x)
  
  y <- unique(y)
  
  g <- function(i)
  {
    z <- setdiff(y, x[seq_len(i-include.equals)])
    
    if(length(z)) cbind(x[i], z, deparse.level=0)
  }
  
  do.call(rbind, lapply(seq_along(x), g))
}

library(stringi)
ggname <- function (prefix, grob) {
  grob$name <- grobName(grob, prefix)
  grob
}

geom_label2 <- function(mapping = NULL, data = NULL,
                        stat = "identity", position = "identity",
                        ...,
                        parse = FALSE,
                        nudge_x = 0,
                        nudge_y = 0,
                        label.padding = unit(0.25, "lines"),
                        label.r = unit(0.15, "lines"),
                        label.size = 0.25,
                        na.rm = FALSE,
                        show.legend = NA,
                        inherit.aes = TRUE) {
  if (!missing(nudge_x) || !missing(nudge_y)) {
    if (!missing(position)) {
      stop("Specify either `position` or `nudge_x`/`nudge_y`", call. = FALSE)
    }
    
    position <- position_nudge(nudge_x, nudge_y)
  }
  
  layer(
    data = data,
    mapping = mapping,
    stat = stat,
    geom = GeomLabel2,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(
      parse = parse,
      label.padding = label.padding,
      label.r = label.r,
      label.size = label.size,
      na.rm = na.rm,
      ...
    )
  )
}

GeomLabel2 <- ggproto("GeomLabel2", Geom,
                      required_aes = c("x", "y", "label"),
                      
                      default_aes = aes(
                        colour = "black", fill = "white", size = 3.88, angle = 0,
                        hjust = 0.5, vjust = 0.5, alpha = NA, family = "", fontface = 1,
                        lineheight = 1.2
                      ),
                      
                      draw_panel = function(self, data, panel_params, coord, parse = FALSE,
                                            na.rm = FALSE,
                                            label.padding = unit(0.25, "lines"),
                                            label.r = unit(0.15, "lines"),
                                            label.size = 0.25) {
                        lab <- data$label
                        if (parse) {
                          lab <- parse(text = as.character(lab))
                        }
                        
                        data <- coord$transform(data, panel_params)
                        if (is.character(data$vjust)) {
                          data$vjust <- compute_just(data$vjust, data$y)
                        }
                        if (is.character(data$hjust)) {
                          data$hjust <- compute_just(data$hjust, data$x)
                        }
                        
                        grobs <- lapply(1:nrow(data), function(i) {
                          row <- data[i, , drop = FALSE]
                          labelGrob2(lab[i],
                                     x = unit(row$x, "native"),
                                     y = unit(row$y, "native"),
                                     just = "center",
                                     padding = label.padding,
                                     r = label.r,
                                     text.gp = gpar(
                                       col = row$colour,
                                       fontsize = row$size * .pt,
                                       fontfamily = row$family,
                                       fontface = row$fontface,
                                       lineheight = row$lineheight
                                     ),
                                     rect.gp = gpar(
                                       col = row$colour,
                                       fill = alpha(row$fill, row$alpha),
                                       lwd = label.size * .pt
                                     )
                          )
                        })
                        class(grobs) <- "gList"
                        
                        ggname("geom_label", grobTree(children = grobs))
                      },
                      
                      draw_key = draw_key_label
)

labelGrob2 <- function(label, x = unit(0.5, "npc"), y = unit(0.5, "npc"),
                       just = "center", padding = unit(0.10, "lines"), r = unit(0.1, "snpc"),
                       default.units = "npc", name = NULL,
                       text.gp = gpar(), rect.gp = gpar(fill = "white"), vp = NULL) {
  
  stopifnot(length(label) == 1)
  
  if (!is.unit(x))
    x <- unit(x, default.units)
  if (!is.unit(y))
    y <- unit(y, default.units)
  
  gTree(label = label, x = x, y = y, just = just, padding = padding, r = r,
        name = name, text.gp = text.gp, rect.gp = rect.gp, vp = vp, cl = "labelgrob2")
}

makeContent.labelgrob2 <- function(x) {
  hj <- resolveHJust(x$just, NULL)
  vj <- resolveVJust(x$just, NULL)
  
  t <- textGrob(
    x$label,
    x$x + 1 * (0.55 - hj) * unit(5, "mm"),
    x$y + 2 * (0.55 - vj) * x$padding,
    just = "center",
    gp = x$text.gp,
    name = "text"
  )
  
  r <- roundrectGrob(x$x, x$y, default.units = "native",
                     width =  1.5 * unit(max(stri_width(x$x)) + 1, "mm"),
                     height = grobHeight(t) + 2 * x$padding,
                     just = c(hj, vj),
                     r = x$r,
                     gp = x$rect.gp,
                     name = "box"
  )
  
  setChildren(x, gList(r, t))
}

detachAllPackages()

library(tidyverse)
library(pastecs)
library(ggplot2)
library(gggenes)
library(data.table)
library(stringr)
library(ape)
library(phytools)

tree = read.newick("/Users/bguinet/Desktop/Dossier_SARA/Concatenated_BUSCO_sequences.treefile")


dsDNA_tab <-Env_table
dsDNA_tab$New_query_bis<-dsDNA_tab$Species_name

dsDNA_tab$consensus_family <- dsDNA_tab$best_family_per_Event
dsDNA_tab$consensus_family[dsDNA_tab$consensus_family=="LbFV-like family"] <- "LbFV_like"
dsDNA_tab$consensus_genomic_structure[dsDNA_tab$consensus_family=="Unknown" & dsDNA_tab$family=="Unknown" & is.na(dsDNA_tab$genomic_structure)]<-"Unknown" 
dsDNA_tab$consensus_genomic_structure[dsDNA_tab$genomic_structure=="Unknown"]<-"Unknown" 
dsDNA_tab$best_family_per_query[dsDNA_tab$consensus_family=="Unknown"]<-"Unknown" 


#remove duplicates within events
dsDNA_tab<-dsDNA_tab%>%
  group_by(Clustername,Event)%>%
  distinct(query, .keep_all = TRUE)


#names(dsDNA_tab)[names(dsDNA_tab)=="query"] <- "New_query_bis"
dsDNA_tab$consensus_genomic_structure[is.na(dsDNA_tab$consensus_genomic_structure)] <- "Unknown"


#t<-dsDNA_tab[!dsDNA_tab$New_query_bis2 %in% Control_comparaison_table$query,]
dsDNA_tab<-dsDNA_tab[!duplicated(dsDNA_tab[ , c("New_query_bis","Clustername","Event")]),]


Restricted_candidat<- dsDNA_tab %>% 
  group_by(Clustername)%>% 
  mutate(query=New_query_bis2)%>%
  filter(!duplicated (New_query_bis2))%>% 
  separate(New_query_bis2, c("Scaff_name","coordinates","query1"), ":") %>%
  separate(coordinates, c("coordinates","strand"), "[(]") %>%
  mutate(strand = gsub(")", "", strand)) %>%
  separate(coordinates, c("start","end"), "-")%>%
  select(Scaff_name,consensus_family,Scaffold_score,New_query_bis,query,Clustername,Species_name,qstart,qend,target,evalue,consensus_genomic_structure,family,cov_depth_candidat,cov_depth_BUSCO,FDR_pvalue_cov,count_repeat,count_Busco,Event,Boot,Nsp,FDR_pvalue_dNdS,Pvalue_dNdS,Mean_dNdS,SE_dNdS,TPM_all,pseudogenized)

Restricted_candidat$consensus_family[is.na(Restricted_candidat$consensus_family)] <- "Unknown"
#Change the Unknow family names by adding a number for each different target Unknown since they are probably not the same virus
setDT(Restricted_candidat)[consensus_family == "Unknown", consensus_family := paste0(consensus_family, "_", .GRP), by=target]

#Now we will produce several tables (EVEs, dEVES, EVEs_event, dEVEs_event)

look_up_group <- function(one_group, lookup_list) {
  matched_list <- map(lookup_list, function(x) { intersect(x, one_group) } )
  index <- which(unlist(map(matched_list, function(x) { length(x) > 0 })))
  sort(unique(unlist(lookup_list[index])))
}


#Change the Event number by adding the clustername to it 
Restricted_candidat$Event <- paste0(Restricted_candidat$Event,"_",Restricted_candidat$Clustername)


#For events EVEs shared only 
#This script allows to group together putatives events based on the fact that EVEs are in the same scaffold or by regrouping EVEs coming from the same virus family donnor

####################################################
#Try to capture number of EVEs within shared events 
####################################################

table_noduplicate_shared_EVEs <- Restricted_candidat%>%
  group_by(Clustername,Event)%>%
  distinct(New_query_bis, .keep_all = TRUE)%>%
  mutate(nrows=n())%>%
  filter(any(nrows >=2))

table_noduplicate_shared_EVEs<-table_noduplicate_shared_EVEs[!duplicated(table_noduplicate_shared_EVEs[ , c("New_query_bis","Clustername","Event")]),]
table_noduplicate_shared_EVEs <-select(as.data.frame(table_noduplicate_shared_EVEs),'query','Clustername','New_query_bis','consensus_family','consensus_genomic_structure','Species_name','Event','Scaff_name')

#Deal with the fact that duplicated EVEs can be into different Event, the idea is just to check the boostrap value that separates two putative duplicates (g.e EVEs within same cluster and same specie)
table_noduplicate_shared_EVEs<-table_noduplicate_shared_EVEs[!duplicated(table_noduplicate_shared_EVEs[ , c("New_query_bis","Clustername","Event")]),]

#Sort two columns 
table_noduplicate_shared_EVEs <- table_noduplicate_shared_EVEs[order(table_noduplicate_shared_EVEs$New_query_bis),]  
#table_noduplicate_shared_EVEs<-table_noduplicate_shared_EVEs[!duplicated(list_df[ , c("Clustername","Event")]),]

library(dplyr)
library(tidyr)

list_all_query1 <- table_noduplicate_shared_EVEs$query

table_noduplicate_shared_EVEs  <- table_noduplicate_shared_EVEs %>% 
  group_by(Clustername, Event)  %>% 
  summarize(across(c(New_query_bis, query, consensus_family,consensus_genomic_structure,Species_name,Scaff_name), paste0, collapse = ","), .groups = "drop") %>% 
  filter(!duplicated( cbind(New_query_bis,Clustername)))  %>%
  separate_rows(New_query_bis, query, consensus_family,consensus_genomic_structure,Species_name,Scaff_name, sep = ",", convert = TRUE)

list_all_query2<- table_noduplicate_shared_EVEs$query

list_query_remove_because_redundancy<-list_all_query1[!(list_all_query1 %in% list_all_query2)]

list_df<-expand.grid(table_noduplicate_shared_EVEs$Clustername,table_noduplicate_shared_EVEs$Species_name)
colnames(list_df)<-c("Clustername","Species_name")
list_df<-list_df[!duplicated(list_df[ , c("Clustername","Species_name")]),]
list_df$present<-"yes"

list_df<-merge(select(table_noduplicate_shared_EVEs,"Clustername","Species_name"),list_df,by=c("Clustername","Species_name"),all.x = TRUE)

table_noduplicate_shared_EVEs$BootValue<-"NA"
library(ape)
library(phytools)
library(phylobase)
list_df<-list_df[!duplicated(list_df[ , c("Clustername","Species_name")]),]


# DOes not work, need to be improved for you 
#Correct Bootstrapvalues 
for(i in 1:nrow(list_df)) {
  sub_table_noduplicate_shared_EVEs<-table_noduplicate_shared_EVEs[with(table_noduplicate_shared_EVEs, Clustername == list_df$Clustername[[i]] & Species_name == list_df$Species_name[[i]]), ]
  if (length(dim(sub_table_noduplicate_shared_EVEs)) >=1 ){
    sub_table_noduplicate_shared_EVEs<-sub_table_noduplicate_shared_EVEs[!is.na(sub_table_noduplicate_shared_EVEs$Clustername), ]
    sub_table_noduplicate_shared_EVEs$query<-gsub(":","_",sub_table_noduplicate_shared_EVEs$query)
    sub_table_noduplicate_shared_EVEs$query<-gsub("\\(","_",sub_table_noduplicate_shared_EVEs$query)
    sub_table_noduplicate_shared_EVEs$query<-gsub("\\)","_",sub_table_noduplicate_shared_EVEs$query)
    sub_table_noduplicate_shared_EVEs$query<-gsub(" ","",sub_table_noduplicate_shared_EVEs$query)
    if (file.exists(paste0("/Users/bguinet/Desktop/Dossier_SARA/Cluster_phylogeny/",unique(sub_table_noduplicate_shared_EVEs$Clustername),".faa.aln.treefile"))) {
      print(i)
      PhyloTree=read.tree(paste0("/Users/bguinet/Desktop/Dossier_SARA/Cluster_phylogeny/",unique(sub_table_noduplicate_shared_EVEs$Clustername),".faa.aln.treefile"))
      PhyloTree_labels<-PhyloTree$tip.label
      tax_to_remove<-PhyloTree_labels[grepl("HSP",PhyloTree_labels)]
      tax_to_remove<-gsub("_[0-9]-HSPs.*", "",tax_to_remove)
      list_candidate<-sub_table_noduplicate_shared_EVEs$query
      if (length(tax_to_remove )> 1) {
        list_candidate<-list_candidate[!grepl(paste(tax_to_remove, collapse = "|"), list_candidate)]
      }
      if (length(list_candidate)>1){
        PhyloTree<-midpoint.root(PhyloTree)
        tryCatch({
          PhyloTree <- as(PhyloTree, "phylo4")
        }, error=function(e){})
        mm<- MRCA(PhyloTree,list_candidate)
        bootstrap_value<-names(mm)
        #print(list_candidate)
        print(bootstrap_value)
        print(list_df$Species_name[[i]])
        print(list_df$Clustername[[i]])
        table_noduplicate_shared_EVEs <-table_noduplicate_shared_EVEs%>%
          group_by(Clustername,Species_name)%>%
          mutate(BootValue = case_when(any(grepl(list_df$Clustername[[i]],Clustername) & Species_name %in% list_df$Species_name[[i]]  ) ~ bootstrap_value,TRUE ~ BootValue))
        print("Cluster7293" %in% table_noduplicate_shared_EVEs$Clustername)
      }
    }
  }
}

#Remove duplicated EVEs when the bootstrap support is below 80 
table_noduplicate_shared_EVEs$BootValue[table_noduplicate_shared_EVEs$BootValue=="Root"] <-0
table_noduplicate_shared_EVEs$BootValue[table_noduplicate_shared_EVEs$BootValue=="NA"] <- -1
table_noduplicate_shared_EVEs$BootValue <- as.numeric(table_noduplicate_shared_EVEs$BootValue)

Shared_events_splitted <- table_noduplicate_shared_EVEs[table_noduplicate_shared_EVEs$BootValue < 80 & table_noduplicate_shared_EVEs$BootValue > 0,]
#Chang the Event number for those one in order to add them within the alone Event part 
for (event in unique(Shared_events_splitted$Event)){
  sub_event_nb <- 1
  subShared_events_splitted <- Shared_events_splitted[Shared_events_splitted$Event==event,]
  for (i in unique(subShared_events_splitted$query)){
    Restricted_candidat$Event[Restricted_candidat$query==i] <- paste0(event,"_bis_",sub_event_nb)
    sub_event_nb= sub_event_nb +1
  }
}


#table_noduplicate_shared_EVEs  <- table_noduplicate_shared_EVEs[table_noduplicate_shared_EVEs$BootValue > 80 | table_noduplicate_shared_EVEs$BootValue  == -2 ,]


#Now we will map the EVEs event within the phylogeny, bu for that we need to create a dataframe where we add each Event number for each node number 
col.names = c("Node_number", "Event",'Cluster','consensus_family','Clustername','species','Nb_EVEs','Nb_EVEs_dsDNA','Nb_EVEs_ssDNA','Nb_EVEs_ssRNA','Nb_EVEs_dsRNA','Nb_EVEs_Unclassified','Nb_freeliving_EVEs','Nb_ecto_EVEs','Nb_endo_EVEs','lifecycle1')
EVEs_shared_event_noduplicate_df<- read.table(text = "",
                                              col.names = col.names)

EVEs_shared_event_noduplicate_df$lifecycle1<- as.character(EVEs_shared_event_noduplicate_df$lifecycle1)
EVEs_shared_event_noduplicate_df$consensus_family<- as.character(EVEs_shared_event_noduplicate_df$consensus_family)
EVEs_shared_event_noduplicate_df$Clustername<- as.character(EVEs_shared_event_noduplicate_df$Clustername)
EVEs_shared_event_noduplicate_df$species<- as.character(EVEs_shared_event_noduplicate_df$species)
EVEs_shared_event_noduplicate_df$Event<- as.character(EVEs_shared_event_noduplicate_df$Event)

detachAllPackages()

library(tidyverse)
library(pastecs)
library(ggplot2)
library(gggenes)
#library(gsubfn)
library(data.table)
library(stringr)



table_noduplicate_shared_EVEs <-table_noduplicate_shared_EVEs %>%
  group_by(Clustername, Event) %>%
  mutate(Events_species = sprintf('[%s]', toString(Species_name)))

table_noduplicate_shared_EVEs$Events_species2<-NA
for(i in 1:nrow(table_noduplicate_shared_EVEs)) {
  row <- table_noduplicate_shared_EVEs$Events_species[[i]]
  row<-gsub("\\[","",row)
  row<-gsub("\\]","",row)
  row<-unlist(strsplit(as.character(row),","))
  #row<-list(row)
  row<-gsub(" ","",row)
  row<-unique(row)
  row=row<-sort(row)
  #print(row)
  table_noduplicate_shared_EVEs$Events_species2[[i]]<-paste(row, collapse=',')
}



table_shared_EVEs_event<-table_noduplicate_shared_EVEs %>%
  group_by(Clustername,Event)%>%
  distinct(New_query_bis, .keep_all = TRUE)%>%
  mutate(nrows=n())%>%
  filter(any(nrows >=2))%>%
  arrange(Scaff_name,New_query_bis,consensus_family,consensus_genomic_structure,Events_species2) %>%
  # create a Group_2 which is combination of all Group for each family
  group_by(consensus_family,New_query_bis,Events_species2) %>%
  mutate(Group_2 = list(Scaff_name)) %>%
  ungroup() %>%
  # Create Group_3 which is the full combined Group for all intersect Group
  mutate(Group_3 = map(.[["Group_2"]], function(x) { look_up_group(one_group = x, lookup_list = .[["Group_2"]]) })) %>%
  # Combine all Group_3 into a Group_final
  mutate(Group_final = unlist(map(Group_3, function(x) { paste (x, collapse = ",")} ))) %>%
  mutate(Species =New_query_bis )%>%
  # Finally put them all together.
  select(Species,New_query_bis,Group_final, consensus_family,Event,Clustername,consensus_genomic_structure,Events_species2) %>%
  group_by(Group_final) %>%
  summarize(family = paste(consensus_family, collapse = ","),species=paste(unique(Species), collapse = ","),Events_species2=paste(unique(Events_species2), collapse = ","),Events=paste(unique(Event), collapse = ","),Clusters=paste(unique(Clustername), collapse = ","),consensus_genomic_structure=paste(unique(consensus_genomic_structure), collapse = ","), .groups = "drop")


setDT(table_shared_EVEs_event)

#Here we take into account the other species within an event, if for instance two virus families are within the same scaffold in SP1, then I also merge them for SP2. 
col.names = c("family","species","Events","Clusters","consensus_genomic_structure")
table_shared_EVEs_event2<- read.table(text = "",
                                      col.names = col.names)

table_shared_EVEs_event2$family<-as.character(table_shared_EVEs_event2$family)
table_shared_EVEs_event2$species<-as.character(table_shared_EVEs_event2$species)
table_shared_EVEs_event2$Events<-as.character(table_shared_EVEs_event2$Events)
table_shared_EVEs_event2$Clusters<-as.character(table_shared_EVEs_event2$Clusters)
table_shared_EVEs_event2$Events_species2<-as.character(table_shared_EVEs_event2$Events_species2)
table_shared_EVEs_event2$consensus_genomic_structure<-as.character(table_shared_EVEs_event2$consensus_genomic_structure)
#Subset the dataframe per genomic structure : 
List_dsDNA_genomic_structure=c("dsDNA","dsDNA-RT")
List_ssDNA_genomic_structure=c( "ssDNA","ssDNA(+/-)","ssDNA(-)","ssDNA(+)")
List_dsRNA_genomic_structure=c("dsRNA")
List_ssRNA_genomic_structure=c("ssRNA-RT" ,"ssRNA(-)" ,"ssRNA(+)" ,"ssRNA(+/-)","ssRNA")
List_Unknown_genomic_structure=c("Unknown","NA")
List_UnknownRNA_genomic_structure=c("Unknown_RNA")

all_lists<-list(List_dsDNA_genomic_structure,List_ssDNA_genomic_structure,List_dsRNA_genomic_structure,List_ssRNA_genomic_structure,List_Unknown_genomic_structure,List_UnknownRNA_genomic_structure)
#The idea here is to look if we wan gather in the same event within species  EVEs coming from the same event 
for(i in 1:length(all_lists)) {
  table_shared_EVEs_event_sub<-subset(table_shared_EVEs_event, consensus_genomic_structure %in% all_lists[[i]])
  #Restricted_df_heatmap<-subset(Restricted_df_heatmap, !consensus_genomic_structure %in% putatitive_list)
  #Resrict
  if(dim(table_shared_EVEs_event_sub)[1] >=1){
    print(table_shared_EVEs_event_sub)
    setDT(table_shared_EVEs_event_sub)
    table_shared_EVEs_event_sub[, family := as.character(family)]
    table_shared_EVEs_event_sub[, Events := as.character(Events)]
    table_shared_EVEs_event_sub[, Clusters := as.character(Clusters)]
    table_shared_EVEs_event_sub[, Events_species2 := as.character(Events_species2)]
    table_shared_EVEs_event_sub[, consensus_genomic_structure:= as.character(consensus_genomic_structure)]
    table_shared_EVEs_event_sub[, n := row.names(.SD) ]
    
    dt3 <- merge(table_shared_EVEs_event_sub, 
                 table_shared_EVEs_event_sub, 
                 by = "species",allow.cartesian=TRUE)[n.x >= n.y]
    
    dt3[, testfamily := length(intersect(unlist(strsplit(family.x, ",")), unlist(strsplit(family.y, ",")))) > 0, by = 1:nrow(dt3)]
    dt3[, testEventss := length(intersect(unlist(strsplit(Events.x, ",")), unlist(strsplit(Events.y, ",")))) > 0, by = 1:nrow(dt3)]
    dt3[, testEvents_species2 := length(intersect(unlist(strsplit(Events_species2.x, ",")), unlist(strsplit(Events_species2.y, ",")))) > 0, by = 1:nrow(dt3)]
    dt3[, testconsensus_genomic_structure:= length(intersect(unlist(strsplit(consensus_genomic_structure.x, ",")), unlist(strsplit(consensus_genomic_structure.y, ",")))) > 0, by = 1:nrow(dt3)]
    dt3[, testClusters := length(intersect(unlist(strsplit(Clusters.x, ",")), unlist(strsplit(Clusters.y, ",")))) > 0, by = 1:nrow(dt3)]
    
    dt3[, Events_species2 := paste0(unique(unlist(strsplit(paste(Events_species2.x, Events_species2.y, sep = ","), ","))), collapse = ","), by = 1:nrow(dt3)]
    dt3[, family := paste0(unique(unlist(strsplit(paste(family.x, family.y, sep = ","), ","))), collapse = ","), by = 1:nrow(dt3)]
    dt3[, Events := paste0(unique(unlist(strsplit(paste(Events.x, Events.y, sep = ","), ","))), collapse = ","), by = 1:nrow(dt3)]
    dt3[, consensus_genomic_structure:= paste0(unique(unlist(strsplit(paste(consensus_genomic_structure.x, consensus_genomic_structure.y, sep = ","), ","))), collapse = ","), by = 1:nrow(dt3)]
    dt3[, Clusters := paste0(unique(unlist(strsplit(paste(Clusters.x, Clusters.y, sep = ","), ","))), collapse = ","), by = 1:nrow(dt3)]
    
    dt3<-dt3[which(dt3$testClusters==TRUE & dt3$testfamily == TRUE & dt3$testClusters == TRUE & dt3$testEventss == TRUE  & dt3$testEvents_species2 & dt3$testconsensus_genomic_structure == TRUE),]
    
    dtx<-dt3[(testfamily == TRUE | testClusters == TRUE | testEventss == TRUE  |  testEvents_species2 == TRUE | testconsensus_genomic_structure ==TRUE)
             & !n.x %in% dt3[(testfamily == TRUE | testClusters== TRUE | testEventss == TRUE | testEvents_species2 == TRUE | testconsensus_genomic_structure ==TRUE ) & n.x != n.y, n.y]
             & !n.y %in% dt3[(testfamily == TRUE | testClusters == TRUE | testEventss == TRUE | testEvents_species2 ==TRUE| testconsensus_genomic_structure==TRUE) & n.x != n.y, n.x], 
             .(species, family, Events, Clusters,consensus_genomic_structure,Events_species2)]
    
    #table_shared_EVEs_event2<-rbind(table_shared_EVEs_event2,dtx)
    table_shared_EVEs_event2 <- 
      full_join(table_shared_EVEs_event2, dtx)
  }
}


#Add lifecyle 
anoleData<-read.csv("/Users/bguinet/Documents/All_informations_table_fam_busco_life_style.csv",sep=";",header=T)

anoleData<-select(anoleData,'Species_name','lifecycle1')
colnames(anoleData)<-c('species','lifecycle1')

table_shared_EVEs_event2$lifecycle1<-NULL
table_shared_EVEs_event2$lifecycle1[table_shared_EVEs_event2$species%in% Endo_parasitoid_diptera]<-"endoparasitoid"
table_shared_EVEs_event2$lifecycle1[table_shared_EVEs_event2$species %in% Ecto_parasitoid_diptera]<-"ectoparasitoid"
table_shared_EVEs_event2$lifecycle1[!table_shared_EVEs_event2$species %in% parasitoid_diptera]<-"freeliving"

#Then the table_shared_EVEs_event2 stores the events candidates for each species

#Now will gather all species from the same event 
table_shared_EVEs_event2  <- table_shared_EVEs_event2 %>%
  mutate(across(c(family, Events, Clusters,consensus_genomic_structure,lifecycle1,Events_species2), ~ strsplit(as.character(.), split = ','))) 

#Add MRCA number 

library(phytools)
table_shared_EVEs_event2$MRCA<-"NA"
for(i in 1:nrow(table_shared_EVEs_event2)) {
  row <- table_shared_EVEs_event2$Events_species2[[i]]
  #row<-gsub("\\[","",row)
  #row<-gsub("\\]","",row)
  #row<-list(row)
  #row<-gsub(" ","",row)
  row<-unlist(strsplit(as.character(row),","))
  if(length(unique(row)) >1){
    #print(row)
    MRCA_numb<-findMRCA(tree,row)
    if(length(MRCA_numb)) {
      #print(MRCA_numb)
      table_shared_EVEs_event2$MRCA[i]<-MRCA_numb
      table_shared_EVEs_event2$Events_species2[[i]]<-paste(row, collapse=',')
    }
  }
}

table_shared_EVEs_event2 <-setDT(table_shared_EVEs_event2)
collapse_rows <- function(i) {
  rows_collapse <- pmap_lgl(table_shared_EVEs_event2, function(family, Events, Clusters,consensus_genomic_structure,MRCA,Events_species2, ...) 
    any(table_shared_EVEs_event2$family[[i]] %in% family) & any(table_shared_EVEs_event2$Events[[i]] %in% Events) & any(table_shared_EVEs_event2$Clusters[[i]] %in% Clusters)& any(table_shared_EVEs_event2$consensus_genomic_structure[[i]] %in% consensus_genomic_structure) & any(table_shared_EVEs_event2$MRCA[[i]] %in% MRCA & any(table_shared_EVEs_event2$Events_species2 %in% table_shared_EVEs_event2$Events_species2)))
  table_shared_EVEs_event2 %>%
    filter(rows_collapse) %>%
    mutate(across(everything(), ~ paste(sort(unique(unlist(.))), collapse = ',')))
}


table_shared_EVEs_event<- map_dfr(1:nrow(table_shared_EVEs_event2), collapse_rows) %>% distinct

table_shared_EVEs_event$MRCA<-NULL

colnames(table_shared_EVEs_event)<-c("consensus_family","species","Events","Clusters","consensus_genomic_structure","Events_species2","lifecycle1")


#Now we will map the EVEs event within the phylogeny, bu for that we need to create a dataframe where we add each Event number for each node number 
col.names = c("Node_number", "Event",'consensus_genomic_structure','Cluster','consensus_family','Clustername','species','Nb_EVEs','Nb_EVEs_dsDNA','Nb_EVEs_ssDNA','Nb_EVEs_ssRNA','Nb_EVEs_dsRNA','Nb_EVEs_Unclassified','Nb_EVEs_dsDNA_Events','Nb_EVEs_ssDNA_Events','Nb_EVEs_ssRNA_Events','Nb_EVEs_dsRNA_Events','Nb_EVEs_Unclassified_Events','Nb_freeliving_EVEs','Nb_ecto_EVEs','Nb_endo_EVEs','Nb_freeliving_EVEs_Events','Nb_ecto_EVEs_Events','Nb_endo_EVEs_Events','lifecycle1')
EVEs_shared_event_df<- read.table(text = "",
                                  col.names = col.names)

EVEs_shared_event_df$lifecycle1<- as.character(EVEs_shared_event_df$lifecycle1)
EVEs_shared_event_df$consensus_family<- as.character(EVEs_shared_event_df$consensus_family)
EVEs_shared_event_df$Clustername<- as.character(EVEs_shared_event_df$Clustername)
EVEs_shared_event_df$species<- as.character(EVEs_shared_event_df$species)
EVEs_shared_event_df$Event<- as.character(EVEs_shared_event_df$Event)
EVEs_shared_event_df$consensus_genomic_structure<- as.character(EVEs_shared_event_df$consensus_genomic_structure)
EVEs_shared_event_df$Events_species2<- as.character(EVEs_shared_event_df$Events_species2)


library(tidyverse)
library(phytools)
for(i in 1:nrow(table_shared_EVEs_event)) {
  Nb_EVEs<-length(unlist(strsplit(as.character(table_shared_EVEs_event$Clusters[[i]]),",")))
  if(grepl("free",table_shared_EVEs_event$lifecycle1[[i]])){
    Nb_freeliving_EVEs<-length(unlist(strsplit(as.character(table_shared_EVEs_event$Clusters[[i]]),",")))
    Nb_ecto_EVEs<-0
    Nb_endo_EVEs<-0
    Nb_freeliving_EVEs_Events<-1
    Nb_ecto_EVEs_Events<-0
    Nb_endo_EVEs_Events<-0
  }
  if(grepl("endo",table_shared_EVEs_event$lifecycle1[[i]])){
    Nb_freeliving_EVEs<-0
    Nb_ecto_EVEs<-0
    Nb_endo_EVEs<-length(unlist(strsplit(as.character(table_shared_EVEs_event$Clusters[[i]]),",")))
    Nb_freeliving_EVEs_Events<-0
    Nb_ecto_EVEs_Events<-0
    Nb_endo_EVEs_Events<-1
  }
  if(grepl("ecto",table_shared_EVEs_event$lifecycle1[[i]])){
    Nb_freeliving_EVEs<-0
    Nb_ecto_EVEs<-length(unlist(strsplit(as.character(table_shared_EVEs_event$Clusters[[i]]),",")))
    Nb_endo_EVEs<-0
    Nb_freeliving_EVEs_Events<-0
    Nb_ecto_EVEs_Events<-1
    Nb_endo_EVEs_Events<-0
  }
  if(grepl("dsDNA",table_shared_EVEs_event$consensus_genomic_structure[[i]])){
    Nb_EVEs_dsDNA<-length(unlist(strsplit(as.character(table_shared_EVEs_event$Clusters[[i]]),",")))
    Nb_EVEs_ssDNA<-0
    Nb_EVEs_ssRNA<-0
    Nb_EVEs_dsRNA<-0
    Nb_EVEs_Unclassified<-0
    Nb_EVEs_dsDNA_Events<-1
    Nb_EVEs_ssDNA_Events<-0
    Nb_EVEs_ssRNA_Events<-0
    Nb_EVEs_dsRNA_Events<-0
    Nb_EVEs_Unclassified_Events<-0
  }
  if(grepl("ssDNA",table_shared_EVEs_event$consensus_genomic_structure[[i]])){
    Nb_EVEs_ssDNA<-length(unlist(strsplit(as.character(table_shared_EVEs_event$Clusters[[i]]),",")))
    Nb_EVEs_dsDNA<-0
    Nb_EVEs_ssRNA<-0
    Nb_EVEs_dsRNA<-0
    Nb_EVEs_Unclassified<-0
    Nb_EVEs_dsDNA_Events<-0
    Nb_EVEs_ssDNA_Events<-1
    Nb_EVEs_ssRNA_Events<-0
    Nb_EVEs_dsRNA_Events<-0
    Nb_EVEs_Unclassified_Events<-0
  }
  if(grepl("ssRNA",table_shared_EVEs_event$consensus_genomic_structure[[i]])){
    Nb_EVEs_ssRNA<-length(unlist(strsplit(as.character(table_shared_EVEs_event$Clusters[[i]]),",")))
    Nb_EVEs_ssDNA<-0
    Nb_EVEs_dsDNA<-0
    Nb_EVEs_dsRNA<-0
    Nb_EVEs_Unclassified<-0
    Nb_EVEs_dsDNA_Events<-0
    Nb_EVEs_ssDNA_Events<-0
    Nb_EVEs_ssRNA_Events<-1
    Nb_EVEs_dsRNA_Events<-0
    Nb_EVEs_Unclassified_Events<-0
  }
  if(grepl("dsRNA",table_shared_EVEs_event$consensus_genomic_structure[[i]])){
    Nb_EVEs_dsRNA<-length(unlist(strsplit(as.character(table_shared_EVEs_event$Clusters[[i]]),",")))
    Nb_EVEs_ssDNA<-0
    Nb_EVEs_ssRNA<-0
    Nb_EVEs_dsDNA<-0
    Nb_EVEs_Unclassified<-0
    Nb_EVEs_dsDNA_Events<-0
    Nb_EVEs_ssDNA_Events<-0
    Nb_EVEs_ssRNA_Events<-0
    Nb_EVEs_dsRNA_Events<-1
    Nb_EVEs_Unclassified_Events<-0
  }
  if(grepl("Unknown",table_shared_EVEs_event$consensus_genomic_structure[[i]])){
    Nb_EVEs_Unclassified<-length(unlist(strsplit(as.character(table_shared_EVEs_event$Clusters[[i]]),",")))
    Nb_EVEs_ssDNA<-0
    Nb_EVEs_ssRNA<-0
    Nb_EVEs_dsRNA<-0
    Nb_EVEs_dsDNA<-0
    Nb_EVEs_dsDNA_Events<-0
    Nb_EVEs_ssDNA_Events<-0
    Nb_EVEs_ssRNA_Events<-0
    Nb_EVEs_dsRNA_Events<-0
    Nb_EVEs_Unclassified_Events<-1
  }
  lifecycle1<-table_shared_EVEs_event$lifecycle1[[i]]
  Cluster<-table_shared_EVEs_event$Clusters[[i]]
  row <- table_shared_EVEs_event$Events_species2[[i]]
  family<-table_shared_EVEs_event$consensus_family[[i]]
  #row<-gsub("\\[","",row)
  #row<-gsub("\\]","",row)
  #row<-list(row)
  #row<-gsub(" ","",row)
  row<-unlist(strsplit(as.character(row),","))
  row2<-as.character(unique(row))
  row2<-as.character(row2)
  #print(row)
  if(length(unique(row)) >1){
    print(row2)
    print(Cluster)
    MRCA_numb<-findMRCA(tree,row)
    print(MRCA_numb)
    if(length(MRCA_numb)) {
      print(Cluster)
      EVEs_shared_event_df<-EVEs_shared_event_df %>% add_row(Node_number = MRCA_numb, consensus_genomic_structure= table_shared_EVEs_event$consensus_genomic_structure[[i]],Events_species2=table_shared_EVEs_event$Events_species2[[i]],Event =table_shared_EVEs_event$Events[[i]],consensus_family=as.character(family),Clustername=Cluster,species=as.character(row2),Nb_EVEs=Nb_EVEs,Nb_EVEs_dsDNA=Nb_EVEs_dsDNA,Nb_EVEs_ssDNA=Nb_EVEs_ssDNA,Nb_EVEs_ssRNA=Nb_EVEs_ssRNA,Nb_EVEs_dsRNA=Nb_EVEs_dsRNA,Nb_EVEs_Unclassified=Nb_EVEs_Unclassified,Nb_EVEs_dsDNA_Events=Nb_EVEs_dsDNA_Events,Nb_EVEs_ssDNA_Events=Nb_EVEs_ssDNA_Events,Nb_EVEs_ssRNA_Events=Nb_EVEs_ssRNA_Events,Nb_EVEs_dsRNA_Events=Nb_EVEs_dsRNA_Events,Nb_EVEs_Unclassified_Events=Nb_EVEs_Unclassified_Events,Nb_freeliving_EVEs=Nb_freeliving_EVEs,Nb_ecto_EVEs=Nb_ecto_EVEs,Nb_endo_EVEs=Nb_endo_EVEs,Nb_freeliving_EVEs_Events=Nb_freeliving_EVEs_Events,Nb_ecto_EVEs_Events=Nb_ecto_EVEs_Events,Nb_endo_EVEs_Events=Nb_endo_EVEs_Events,lifecycle1=lifecycle1)
      print(MRCA_numb)
    }
  }
  # do stuff with row
}
#########

for(i in 1:nrow(EVEs_shared_event_df)) {
  row <- EVEs_shared_event_df$Events_species2[[i]]
  row<-unlist(strsplit(as.character(row),","))
  row<-unique(row)
  row=row<-sort(row)
  #print(row)
  EVEs_shared_event_df$Events_species2[[i]]<-paste(row, collapse=',')
}



EVEs_shared_event_df<-EVEs_shared_event_df[!duplicated(EVEs_shared_event_df[c("Node_number","Event")]),]


#Count EVEs 
#Add Number EVEs
EVEs_shared_event_df$Nb_EVEs <- str_count(EVEs_shared_event_df$Event, ",")+1

#EVENTS according to lifestyles
EVEs_shared_event_df<-EVEs_shared_event_df %>% mutate (
  Nb_endo_EVEs_Events = ifelse(Nb_EVEs >= 1 & lifecycle1 %in% c('endoparasitoid'),1,0 ))
EVEs_shared_event_df<-EVEs_shared_event_df %>% mutate (
  Nb_ecto_EVEs_Events = ifelse(Nb_EVEs >= 1 & lifecycle1 %in% c('ectoparasitoid'),1,0 ))
EVEs_shared_event_df<-EVEs_shared_event_df %>% mutate (
  Nb_freeliving_EVEs_Events = ifelse(Nb_EVEs >= 1 & lifecycle1 %in% c('freeliving'),1,0 ))

#NB EVES according to lifestyles
EVEs_shared_event_df<-EVEs_shared_event_df %>% mutate (
  Nb_ecto_EVEs = ifelse(Nb_EVEs >= 1 & lifecycle1 %in% c('ectoparasitoid'),Nb_EVEs, 0 ))

EVEs_shared_event_df<-EVEs_shared_event_df %>% mutate (
  Nb_freeliving_EVEs = ifelse(Nb_EVEs >= 1 & lifecycle1 %in% c('freeliving'),Nb_EVEs, 0 ))

EVEs_shared_event_df<-EVEs_shared_event_df %>% mutate (
  Nb_endo_EVEs = ifelse(Nb_EVEs >= 1 & lifecycle1 %in% c('endoparasitoid'),Nb_EVEs, 0 ))

#NB EVES according to genomic structure
#dsDNA 
EVEs_shared_event_df<-EVEs_shared_event_df %>% mutate (
  Nb_EVEs_dsDNA = ifelse(Nb_EVEs >= 1 & consensus_genomic_structure %in% c('dsDNA'),Nb_EVEs, 0 ))
#ssDNA
EVEs_shared_event_df<-EVEs_shared_event_df %>% mutate (
  Nb_EVEs_ssDNA = ifelse(Nb_EVEs >= 1 & consensus_genomic_structure %in% c('ssDNA'),Nb_EVEs, 0 ))
#dsRNA
EVEs_shared_event_df<-EVEs_shared_event_df %>% mutate (
  Nb_EVEs_dsRNA = ifelse(Nb_EVEs >= 1 & consensus_genomic_structure %in% c('dsRNA'),Nb_EVEs, 0 ))
#ssRNA
EVEs_shared_event_df<-EVEs_shared_event_df %>% mutate (
  Nb_EVEs_ssRNA = ifelse(Nb_EVEs >= 1 & consensus_genomic_structure %in% c('ssRNA'),Nb_EVEs, 0 ))
#Unclassified 
EVEs_shared_event_df<-EVEs_shared_event_df %>% mutate (
  Nb_EVEs_Unclassified_Events = ifelse(Nb_EVEs >= 1 & consensus_genomic_structure%in% c('Unknown'),Nb_EVEs, 0 ))

#NB EVES EVENT according to genomic structure
#dsDNA
EVEs_shared_event_df<-EVEs_shared_event_df %>% mutate (
  Nb_EVEs_dsDNA_Events = ifelse(Nb_EVEs >= 1 & consensus_genomic_structure %in% c('dsDNA'),1, 0 ))
#ssDNA
EVEs_shared_event_df<-EVEs_shared_event_df %>% mutate (
  Nb_EVEs_ssDNA_Events  = ifelse(Nb_EVEs >= 1 & consensus_genomic_structure %in% c('ssDNA'),1, 0 ))
#dsRNA
EVEs_shared_event_df<-EVEs_shared_event_df %>% mutate (
  Nb_EVEs_dsRNA_Events  = ifelse(Nb_EVEs >= 1 & consensus_genomic_structure %in% c('dsRNA'),1, 0 ))
#ssRNA
EVEs_shared_event_df<-EVEs_shared_event_df %>% mutate (
  Nb_EVEs_ssRNA_Events  = ifelse(Nb_EVEs >= 1 & consensus_genomic_structure %in% c('ssRNA'),1, 0 ))
#Unclassified 
EVEs_shared_event_df<-EVEs_shared_event_df %>% mutate (
  Nb_EVEs_Unclassified_Events = ifelse(Nb_EVEs >= 1 & consensus_genomic_structure%in% c('Unknown'),1, 0 ))


#Count dEVEs 
#Add Number dEVEs
library(tidyverse)
Env_table_bis<- Env_table[!duplicated(Env_table$New_query_bis2),]
Env_table_bis<-select(Env_table_bis,"Clustername",'New_query_bis2','Event',"Mean_dNdS","Pvalue_dNdS",'FDR_pvalue_dNdS','pseudogenized','SE_dNdS','TPM_all')
Env_table_bis <-Env_table_bis %>%
  group_by(Clustername,New_query_bis2) %>%
  filter(any(FDR_pvalue_dNdS == 1 & as.numeric(as.character(Mean_dNdS))+as.numeric(as.character(SE_dNdS)) < 1 & pseudogenized ==0 | TPM_all>=1000 & pseudogenized ==0))

names(Env_table_bis)[names(Env_table_bis)=="Clustername"] <- "Clustername_bis"
names(EVEs_shared_event_df)[names(EVEs_shared_event_df)=="Event"] <- "Event_Groups"

EVEs_shared_event_df$rowname<-NULL

sub<-EVEs_shared_event_df  %>% 
  rownames_to_column()  %>% 
  mutate(Event_Groups = as.character(Event_Groups)) %>% 
  separate_rows(Event_Groups, sep = ",") %>% 
  left_join(., 
            Env_table_bis %>% 
              unite(col = "Event_Groups", Event, Clustername_bis) %>% 
              mutate(count = if_else(Mean_dNdS < 1 & Pvalue_dNdS < 0.05 | TPM_all>=159.559000 & pseudogenized ==0 ,1L, 0L))) %>%
  distinct(Event_Groups, .keep_all = TRUE) %>%
  group_by(rowname,) %>% 
  summarise(Event_Groups = paste(unique(Event_Groups), collapse = ","),
            Nb_dEVEs = sum(count, na.rm=T))

EVEs_shared_event_df$rowname <- rownames(EVEs_shared_event_df) 
EVEs_shared_event_df<- merge(x = sub, y =EVEs_shared_event_df, by = "rowname", all = TRUE)
EVEs_shared_event_df$Event_Groups.x <- NULL
EVEs_shared_event_df$Nb_dEVEs[is.na(EVEs_shared_event_df$Nb_dEVEs)] <- 0

names(EVEs_shared_event_df)[names(EVEs_shared_event_df)=="Event_Groups.y"] <- "Event"

#EVENTS according to lifestyles
EVEs_shared_event_df<-EVEs_shared_event_df %>% mutate (
  Nb_endo_dEVEs_Events = ifelse(Nb_dEVEs >= 1 & lifecycle1 %in% c('endoparasitoid'),1,0 ))
EVEs_shared_event_df<-EVEs_shared_event_df %>% mutate (
  Nb_ecto_dEVEs_Events = ifelse(Nb_dEVEs >= 1 & lifecycle1 %in% c('ectoparasitoid'),1,0 ))
EVEs_shared_event_df<-EVEs_shared_event_df %>% mutate (
  Nb_freeliving_dEVEs_Events = ifelse(Nb_dEVEs >= 1 & lifecycle1 %in% c('freeliving'),1,0 ))

#NB EVES according to lifestyles
EVEs_shared_event_df<-EVEs_shared_event_df %>% mutate (
  Nb_ecto_dEVEs = ifelse(Nb_dEVEs >= 1 & lifecycle1 %in% c('ectoparasitoid'),Nb_dEVEs, 0 ))

EVEs_shared_event_df<-EVEs_shared_event_df %>% mutate (
  Nb_freeliving_dEVEs = ifelse(Nb_dEVEs >= 1 & lifecycle1 %in% c('freeliving'),Nb_dEVEs, 0 ))

EVEs_shared_event_df<-EVEs_shared_event_df %>% mutate (
  Nb_endo_dEVEs = ifelse(Nb_dEVEs >= 1 & lifecycle1 %in% c('endoparasitoid'),Nb_dEVEs, 0 ))

#NB EVES according to genomic structure
#dsDNA 
EVEs_shared_event_df<-EVEs_shared_event_df %>% mutate (
  Nb_dEVEs_dsDNA = ifelse(Nb_dEVEs >= 1 & consensus_genomic_structure %in% c('dsDNA'),Nb_dEVEs, 0 ))
#ssDNA
EVEs_shared_event_df<-EVEs_shared_event_df %>% mutate (
  Nb_dEVEs_ssDNA = ifelse(Nb_dEVEs >= 1 & consensus_genomic_structure %in% c('ssDNA'),Nb_dEVEs, 0 ))
#dsRNA
EVEs_shared_event_df<-EVEs_shared_event_df %>% mutate (
  Nb_dEVEs_dsRNA = ifelse(Nb_dEVEs >= 1 & consensus_genomic_structure %in% c('dsRNA'),Nb_dEVEs, 0 ))
#ssRNA
EVEs_shared_event_df<-EVEs_shared_event_df %>% mutate (
  Nb_dEVEs_ssRNA = ifelse(Nb_dEVEs >= 1 & consensus_genomic_structure %in% c('ssRNA'),Nb_dEVEs, 0 ))
#Unclassified 
EVEs_shared_event_df<-EVEs_shared_event_df %>% mutate (
  Nb_dEVEs_Unclassified_Events = ifelse(Nb_dEVEs >= 1 & consensus_genomic_structure%in% c('Unknown'),Nb_dEVEs, 0 ))

#NB EVES EVENT according to genomic structure
#dsDNA
EVEs_shared_event_df<-EVEs_shared_event_df %>% mutate (
  Nb_dEVEs_dsDNA_Events = ifelse(Nb_dEVEs >= 1 & consensus_genomic_structure %in% c('dsDNA'),1, 0 ))
#ssDNA
EVEs_shared_event_df<-EVEs_shared_event_df %>% mutate (
  Nb_dEVEs_ssDNA_Events  = ifelse(Nb_dEVEs >= 1 & consensus_genomic_structure %in% c('ssDNA'),1, 0 ))
#dsRNA
EVEs_shared_event_df<-EVEs_shared_event_df %>% mutate (
  Nb_dEVEs_dsRNA_Events  = ifelse(Nb_dEVEs >= 1 & consensus_genomic_structure %in% c('dsRNA'),1, 0 ))
#ssRNA
EVEs_shared_event_df<-EVEs_shared_event_df %>% mutate (
  Nb_dEVEs_ssRNA_Events  = ifelse(Nb_dEVEs >= 1 & consensus_genomic_structure %in% c('ssRNA'),1, 0 ))
#Unclassified 
EVEs_shared_event_df<-EVEs_shared_event_df %>% mutate (
  Nb_dEVEs_Unclassified_Events = ifelse(Nb_dEVEs >= 1 & consensus_genomic_structure%in% c('Unknown'),1, 0 ))



########

#Save to count in summary : 
EVEs_shared_event_df_EVEs_count <- EVEs_shared_event_df


##################

detachAllPackages()

library(tidyverse)
library(pastecs)
library(ggplot2)
library(gggenes)
#library(gsubfn)
library(data.table)
library(stringr)


#For events EVEs alone only 
#This script allows to group together putatives events based on the fact that EVEs are in the same scaffold or by regrouping EVEs comming from the same virus family donnor


####################################################
#Try to capture number of EVEs within alone events 
####################################################

Restricted_candidat <- Restricted_candidat[order(Restricted_candidat$TPM_all, decreasing = TRUE), ]

table_noduplicate_alone_EVEs <-Restricted_candidat %>%
  group_by(Clustername,query,consensus_genomic_structure)%>%
  distinct(query, .keep_all = TRUE)%>%
  mutate(nrows=n())%>%
  filter(any(nrows <=1))

table_noduplicate_alone_EVEs<-table_noduplicate_alone_EVEs[!duplicated(table_noduplicate_alone_EVEs[ , c("query","Clustername","Event")]),]
table_noduplicate_alone_EVEs <-select(as.data.frame(table_noduplicate_alone_EVEs),'query','Clustername','New_query_bis','consensus_family','consensus_genomic_structure','Species_name','Event','Scaff_name')


#Deal with the fact that duplicated EVEs can be into different Event, the idea is just to check the boostrap value that separates two putative duplicates (g.e EVEs within same cluster and same specie)
table_noduplicate_alone_EVEs<-table_noduplicate_alone_EVEs[!duplicated(table_noduplicate_alone_EVEs[ , c("New_query_bis","Clustername","Event")]),]


list_df<-expand.grid.unique(as.character(table_noduplicate_alone_EVEs$Clustername),table_noduplicate_alone_EVEs$Species_name)
colnames(list_df)<-c("Clustername","Species_name")
list_df<-list_df[!duplicated(list_df[ , c("Clustername","Species_name")]),]
list_df<-as.data.frame(list_df)
list_df$present<-"yes"

list_df<-merge(select(table_noduplicate_alone_EVEs,"Clustername","Species_name"),list_df,by=c("Clustername","Species_name"),all.x = TRUE)

table_noduplicate_alone_EVEs$BootValue<-"NA"
library(ape)
library(phytools)
library(phylobase)
list_df<-list_df[!duplicated(list_df[ , c("Clustername","Species_name")]),]



#Still need to resolve this prt for Diptera 
#Correct Bootstrapvalues 
for(i in unique(list_df$Clustername)) {
  sub_table_noduplicate_alone_EVEs<-table_noduplicate_alone_EVEs[with(table_noduplicate_alone_EVEs, Clustername == i ), ]
  sub_table_noduplicate_alone_EVEs<-sub_table_noduplicate_alone_EVEs[!is.na(sub_table_noduplicate_alone_EVEs$Clustername), ]
  sub_table_noduplicate_alone_EVEs$query<-gsub(":","_",sub_table_noduplicate_alone_EVEs$query)
  sub_table_noduplicate_alone_EVEs$query<-gsub("\\(","_",sub_table_noduplicate_alone_EVEs$query)
  sub_table_noduplicate_alone_EVEs$query<-gsub("\\)","_",sub_table_noduplicate_alone_EVEs$query)
  sub_table_noduplicate_alone_EVEs$query<-gsub(" ","",sub_table_noduplicate_alone_EVEs$query)
  for (a in unique(sub_table_noduplicate_alone_EVEs$Event)){
    sub_sub_table_noduplicate_alone_EVEs<-sub_table_noduplicate_alone_EVEs[sub_table_noduplicate_alone_EVEs$Event == a, ]
    if (length(dim(sub_sub_table_noduplicate_alone_EVEs)) >=1 ){
      Event_number<-a
      if (file.exists(paste0("/Users/bguinet/Desktop/Dossier_SARA/Cluster_phylogeny/",unique(sub_table_noduplicate_alone_EVEs$Clustername),".faa.aln.treefile"))) {
        print(i)
        PhyloTree=read.tree(paste0("/Users/bguinet/Desktop/Dossier_SARA/Cluster_phylogeny/",unique(sub_table_noduplicate_alone_EVEs$Clustername),".faa.aln.treefile"))
        PhyloTree_labels<-PhyloTree$tip.label
        tax_to_remove<-PhyloTree_labels[grepl("HSP",PhyloTree_labels)]
        tax_to_remove<-gsub("_[0-9]-HSPs.*", "",tax_to_remove)
        list_candidate<-sub_sub_table_noduplicate_alone_EVEs$query
        tryCatch({
          PhyloTree <- as(PhyloTree, "phylo4")
        }, error=function(e){})
        tryCatch({
          mm<- MRCA(PhyloTree,list_candidate)
        }, error=function(e){})
        bootstrap_value<-names(mm)
        print(list_candidate)
        print(bootstrap_value)
        table_noduplicate_alone_EVEs$BootValue[table_noduplicate_alone_EVEs$Event==Event_number] <- bootstrap_value
      }
    }   
  }
}
for(i in 1:nrow(list_df)) {
  sub_table_noduplicate_alone_EVEs<-table_noduplicate_alone_EVEs[with(table_noduplicate_alone_EVEs, Clustername == list_df$Clustername[[i]] & Species_name == list_df$Species_name[[i]]), ]
  if (length(dim(sub_table_noduplicate_alone_EVEs)) >=1 ){
    sub_table_noduplicate_alone_EVEs<-sub_table_noduplicate_alone_EVEs[!is.na(sub_table_noduplicate_alone_EVEs$Clustername), ]
    sub_table_noduplicate_alone_EVEs$query<-gsub(":","_",sub_table_noduplicate_alone_EVEs$query)
    sub_table_noduplicate_alone_EVEs$query<-gsub("\\(","_",sub_table_noduplicate_alone_EVEs$query)
    sub_table_noduplicate_alone_EVEs$query<-gsub("\\)","_",sub_table_noduplicate_alone_EVEs$query)
    sub_table_noduplicate_alone_EVEs$query<-gsub(" ","",sub_table_noduplicate_alone_EVEs$query)
    if (file.exists(paste0("/Users/bguinet/Desktop/Dossier_SARA/Cluster_phylogeny/",unique(sub_table_noduplicate_alone_EVEs$Clustername),".faa.aln.treefile"))) {
      PhyloTree=read.tree(paste0("/Users/bguinet/Desktop/Dossier_SARA/Cluster_phylogeny/",unique(sub_table_noduplicate_alone_EVEs$Clustername),".faa.aln.treefile"))
      PhyloTree_labels<-PhyloTree$tip.label
      tax_to_remove<-PhyloTree_labels[grepl("HSP",PhyloTree_labels)]
      tax_to_remove<-gsub("_[0-9]-HSPs.*", "",tax_to_remove)
      list_candidate<-sub_table_noduplicate_alone_EVEs$query
      list_candidate<-list_candidate[!grepl(paste(tax_to_remove, collapse = "|"), list_candidate)]
      if (length(list_candidate)>1){
        PhyloTree<-midpoint.root(PhyloTree)
        tryCatch({
          PhyloTree <- as(PhyloTree, "phylo4")
        }, error=function(e){})
        mm<- MRCA(PhyloTree,list_candidate)
        bootstrap_value<-names(mm)
        #print(list_candidate)
        print(bootstrap_value)
        print(list_df$Species_name[[i]])
        print(list_df$Clustername[[i]])
        table_noduplicate_alone_EVEs<-table_noduplicate_alone_EVEs%>%
          group_by(Clustername,Species_name)%>%
          mutate(BootValue = case_when(any(grepl(list_df$Clustername[[i]],Clustername) & Species_name %in% list_df$Species_name[[i]]  ) ~ bootstrap_value,TRUE ~ BootValue))
      }
    }
  }
}

#Remove duplicated EVEs when the bootstrap support is below 80 
#table_noduplicate_alone_EVEs$BootValue[table_noduplicate_alone_EVEs$BootValue=="Root"] <-0
#table_noduplicate_alone_EVEs$BootValue[table_noduplicate_alone_EVEs$BootValue=="NA"] <- -1
#table_noduplicate_alone_EVEs$BootValue <- as.numeric(table_noduplicate_alone_EVEs$BootValue)
#table_noduplicate_alone_EVEs<-table_noduplicate_alone_EVEs[ table_noduplicate_alone_EVEs$BootValue < 80,]


#Add lifecycle 
table_noduplicate_alone_EVEs$lifecycle1<-NA

table_noduplicate_alone_EVEs$lifecycle1[table_noduplicate_alone_EVEs$Species_name %in% Endo_parasitoid_diptera]<-"endoparasitoid"
table_noduplicate_alone_EVEs$lifecycle1[table_noduplicate_alone_EVEs$Species_name %in% Ecto_parasitoid_diptera]<-"ectoparasitoid"
table_noduplicate_alone_EVEs$lifecycle1[!table_noduplicate_alone_EVEs$Species_name %in% parasitoid_diptera]<-"freeliving"


#Now we will map the EVEs event within the phylogeny, but for that we need to create a dataframe where we add each Event number for each node number 
col.names = c("Node_number", "Event",'consensus_genomic_structure','Cluster','consensus_family','Clustername','species','Nb_EVEs','Nb_EVEs_dsDNA','Nb_EVEs_ssDNA','Nb_EVEs_ssRNA','Nb_EVEs_dsRNA','Nb_EVEs_Unclassified','Nb_EVEs_dsDNA_Events','Nb_EVEs_ssDNA_Events','Nb_EVEs_ssRNA_Events','Nb_EVEs_dsRNA_Events','Nb_EVEs_Unclassified_Events','Nb_freeliving_EVEs','Nb_ecto_EVEs','Nb_endo_EVEs','Nb_freeliving_EVEs_Events','Nb_ecto_EVEs_Events','Nb_endo_EVEs_Events','lifecycle1')
EVEs_alone_event_noduplicate_df<- read.table(text = "",
                                             col.names = col.names)

EVEs_alone_event_noduplicate_df$lifecycle1<- as.character(EVEs_alone_event_noduplicate_df$lifecycle1)
EVEs_alone_event_noduplicate_df$consensus_family<- as.character(EVEs_alone_event_noduplicate_df$consensus_family)
EVEs_alone_event_noduplicate_df$Clustername<- as.character(EVEs_alone_event_noduplicate_df$Clustername)
EVEs_alone_event_noduplicate_df$species<- as.character(EVEs_alone_event_noduplicate_df$species)
EVEs_alone_event_noduplicate_df$Event<- as.character(EVEs_alone_event_noduplicate_df$Event)
EVEs_alone_event_noduplicate_df$consensus_genomic_structure<- as.character(EVEs_alone_event_noduplicate_df$consensus_genomic_structure)

library(tidyverse)
library(phytools)
for(i in 1:nrow(table_noduplicate_alone_EVEs)) {
  Nb_EVEs<-length(unlist(strsplit(as.character(table_noduplicate_alone_EVEs$Clustername[[i]]),",")))
  if(grepl("free",table_noduplicate_alone_EVEs$lifecycle1[[i]])){
    Nb_freeliving_EVEs<-1
    Nb_ecto_EVEs<-0
    Nb_endo_EVEs<-0
  }
  if(grepl("endo",table_noduplicate_alone_EVEs$lifecycle1[[i]])){
    Nb_freeliving_EVEs<-0
    Nb_ecto_EVEs<-0
    Nb_endo_EVEs<-1
  }
  if(grepl("ecto",table_noduplicate_alone_EVEs$lifecycle1[[i]])){
    Nb_freeliving_EVEs<-0
    Nb_ecto_EVEs<-1
    Nb_endo_EVEs<-0
  }
  if(grepl("dsDNA",table_noduplicate_alone_EVEs$consensus_genomic_structure[[i]])){
    Nb_EVEs_dsDNA<-1
    Nb_EVEs_ssDNA<-0
    Nb_EVEs_ssRNA<-0
    Nb_EVEs_dsRNA<-0
    Nb_EVEs_Unclassified<-0
  }
  if(grepl("ssDNA",table_noduplicate_alone_EVEs$consensus_genomic_structure[[i]])){
    Nb_EVEs_ssDNA<-1
    Nb_EVEs_dsDNA<-0
    Nb_EVEs_ssRNA<-0
    Nb_EVEs_dsRNA<-0
    Nb_EVEs_Unclassified<-0
  }
  if(grepl("ssRNA",table_noduplicate_alone_EVEs$consensus_genomic_structure[[i]])){
    Nb_EVEs_ssRNA<-1
    Nb_EVEs_ssDNA<-0
    Nb_EVEs_dsDNA<-0
    Nb_EVEs_dsRNA<-0
    Nb_EVEs_Unclassified<-0
  }
  if(grepl("dsRNA",table_noduplicate_alone_EVEs$consensus_genomic_structure[[i]])){
    Nb_EVEs_dsRNA<-1
    Nb_EVEs_ssDNA<-0
    Nb_EVEs_ssRNA<-0
    Nb_EVEs_dsDNA<-0
    Nb_EVEs_Unclassified<-0
  }
  if(grepl("Unknown",table_noduplicate_alone_EVEs$consensus_genomic_structure[[i]])){
    Nb_EVEs_Unclassified<-1
    Nb_EVEs_ssDNA<-0
    Nb_EVEs_ssRNA<-0
    Nb_EVEs_dsRNA<-0
    Nb_EVEs_dsDNA<-0
  }
  lifecycle1<-table_noduplicate_alone_EVEs$lifecycle1[[i]]
  Cluster<-table_noduplicate_alone_EVEs$Clustername[[i]]
  row <- table_noduplicate_alone_EVEs$Events_species[[i]]
  family<-table_noduplicate_alone_EVEs$consensus_family[[i]]
  consensus_genomic_structure<-table_noduplicate_alone_EVEs$consensus_genomic_structure[[i]]
  #row<-gsub("\\[","",row)
  #row<-gsub("\\]","",row)
  #row<-list(row)
  #row<-gsub(" ","",row)
  row<-table_noduplicate_alone_EVEs$Species_name[[i]]
  EVEs_alone_event_noduplicate_df<-EVEs_alone_event_noduplicate_df %>% add_row(Event = gsub('_.*','',table_noduplicate_alone_EVEs$Event[[i]]),consensus_genomic_structure=table_noduplicate_alone_EVEs$consensus_genomic_structure[[i]],consensus_family=as.character(family),Clustername=Cluster,species=as.character(row),Nb_EVEs=Nb_EVEs,Nb_EVEs_dsDNA=Nb_EVEs_dsDNA,Nb_EVEs_ssDNA=Nb_EVEs_ssDNA,Nb_EVEs_ssRNA=Nb_EVEs_ssRNA,Nb_EVEs_dsRNA=Nb_EVEs_dsRNA,Nb_EVEs_Unclassified=Nb_EVEs_Unclassified,Nb_freeliving_EVEs=Nb_freeliving_EVEs,Nb_ecto_EVEs=Nb_ecto_EVEs,Nb_endo_EVEs=Nb_endo_EVEs,lifecycle1=lifecycle1)
}

EVEs_alone_event_noduplicate_df<-EVEs_alone_event_noduplicate_df[!duplicated(EVEs_alone_event_noduplicate_df[c("Clustername","Event")]),]

detachAllPackages()

library(tidyverse)
library(pastecs)
library(ggplot2)
library(gggenes)
#library(gsubfn)
library(data.table)
library(stringr)

table_alone_EVEs_event<-table_noduplicate_alone_EVEs %>%
  group_by(Clustername,Event,consensus_genomic_structure)%>%
  distinct(New_query_bis, .keep_all = TRUE)%>%
  mutate(nrows=n())%>%
  filter(any(nrows <=1))%>%
  #select(Clustername,New_query_bis,query,Event,nrows,consensus_family)%>%
  arrange(Scaff_name,New_query_bis,consensus_family,consensus_genomic_structure) %>%
  # create a Group_2 which is combination of all Group for each family
  group_by(consensus_family,New_query_bis,consensus_genomic_structure) %>%
  mutate(Group_2 = list(Scaff_name)) %>%
  ungroup() %>%
  # Create Group_3 which is the full combined Group for all intersect Group
  mutate(Group_3 = map(.[["Group_2"]], function(x) { look_up_group(one_group = x, lookup_list = .[["Group_2"]]) })) %>%
  # Combine all Group_3 into a Group_final
  mutate(Group_final = unlist(map(Group_3, function(x) { paste (x, collapse = ",")} ))) %>%
  mutate(Species =New_query_bis )%>%
  # Finally put them all together.
  select(Species,New_query_bis,Group_final, consensus_family,Event,Clustername,consensus_genomic_structure,lifecycle1) %>%
  group_by(Group_final,consensus_genomic_structure,Species) %>%
  summarize(family = paste(consensus_family, collapse = ","),species=paste(unique(Species), collapse = ","),Events=paste(unique(Event), collapse = ","),Clusters=paste(unique(Clustername), collapse = ","),consensus_genomic_structure=paste(unique(consensus_genomic_structure), collapse = ","), .groups = "drop")


#Add lifecycle 

Families_EVEs_alone_event_df<-table(table_alone_EVEs_event$family)

Families_EVEs_alone_event_df$lifecycle1<-NA
Families_EVEs_alone_event_df$lifecycle1[Families_EVEs_alone_event_df$Species %in% Endo_parasitoid_diptera]<-"endoparasitoid"
Families_EVEs_alone_event_df$lifecycle1[Families_EVEs_alone_event_df$Species %in% Ecto_parasitoid_diptera]<-"ectoparasitoid"
Families_EVEs_alone_event_df$lifecycle1[!Families_EVEs_alone_event_df$Species %in% parasitoid_diptera]<-"freeliving"

#####

table_alone_EVEs_event$lifecycle1<-NA
table_alone_EVEs_event$lifecycle1[table_alone_EVEs_event$Species %in% Endo_parasitoid_diptera]<-"endoparasitoid"
table_alone_EVEs_event$lifecycle1[table_alone_EVEs_event$Species %in% Ecto_parasitoid_diptera]<-"ectoparasitoid"
table_alone_EVEs_event$lifecycle1[!table_alone_EVEs_event$Species %in% parasitoid_diptera]<-"freeliving"


#Add Number EVEs
table_alone_EVEs_event$Nb_EVEs <- str_count(table_alone_EVEs_event$Clusters, ",")+1


#EVENTS according to lifestyles
table_alone_EVEs_event<-table_alone_EVEs_event %>% mutate (
  Nb_endo_EVEs_Events = ifelse(Nb_EVEs >= 1 & lifecycle1 %in% c('endoparasitoid'),1,0 ))
table_alone_EVEs_event<-table_alone_EVEs_event %>% mutate (
  Nb_ecto_EVEs_Events = ifelse(Nb_EVEs >= 1 & lifecycle1 %in% c('ectoparasitoid'),1,0 ))
table_alone_EVEs_event<-table_alone_EVEs_event %>% mutate (
  Nb_freeliving_EVEs_Events = ifelse(Nb_EVEs >= 1 & lifecycle1 %in% c('freeliving'),1,0 ))
#NB EVES according to lifestyles
table_alone_EVEs_event %>% mutate (
  Nb_ecto_EVEs = ifelse(Nb_EVEs >= 1 & lifecycle1 %in% c('ectoparasitoid'),Nb_EVEs, 0 ))
table_alone_EVEs_event<-table_alone_EVEs_event %>% mutate (
  Nb_freeliving_EVEs = ifelse(Nb_EVEs >= 1 & lifecycle1 %in% c('freeliving'),Nb_EVEs, 0 ))
table_alone_EVEs_event<-table_alone_EVEs_event %>% mutate (
  Nb_endo_EVEs = ifelse(Nb_EVEs >= 1 & lifecycle1 %in% c('endoparasitoid'),Nb_EVEs, 0 ))

#NB EVEs according to genomic structure
#dsDNA 
table_alone_EVEs_event<-table_alone_EVEs_event %>% mutate (
  Nb_EVEs_dsDNA = ifelse(Nb_EVEs >= 1 & consensus_genomic_structure %in% c('dsDNA'),Nb_EVEs, 0 ))
#ssDNA
table_alone_EVEs_event<-table_alone_EVEs_event %>% mutate (
  Nb_EVEs_ssDNA = ifelse(Nb_EVEs >= 1 & consensus_genomic_structure %in% c('ssDNA'),Nb_EVEs, 0 ))
#dsRNA
table_alone_EVEs_event<-table_alone_EVEs_event %>% mutate (
  Nb_EVEs_dsRNA = ifelse(Nb_EVEs >= 1 & consensus_genomic_structure %in% c('dsRNA'),Nb_EVEs, 0 ))
#ssRNA
table_alone_EVEs_event<-table_alone_EVEs_event %>% mutate (
  Nb_EVEs_ssRNA = ifelse(Nb_EVEs >= 1 & consensus_genomic_structure %in% c('ssRNA'),Nb_EVEs, 0 ))
#Unclassified 
table_alone_EVEs_event<-table_alone_EVEs_event %>% mutate (
  Nb_EVEs_Unclassified = ifelse(Nb_EVEs >= 1 & consensus_genomic_structure%in% c('Unknown'),Nb_EVEs, 0 ))


#NB EVES EVENT according to genomic structure
#dsDNA 
table_alone_EVEs_event<-table_alone_EVEs_event %>% mutate (
  Nb_EVEs_dsDNA_Events = ifelse(Nb_EVEs >= 1 & consensus_genomic_structure %in% c('dsDNA'),1, 0 ))
#ssDNA
table_alone_EVEs_event<-table_alone_EVEs_event %>% mutate (
  Nb_EVEs_ssDNA_Events  = ifelse(Nb_EVEs >= 1 & consensus_genomic_structure %in% c('ssDNA'),1, 0 ))
#dsRNA
table_alone_EVEs_event<-table_alone_EVEs_event %>% mutate (
  Nb_EVEs_dsRNA_Events  = ifelse(Nb_EVEs >= 1 & consensus_genomic_structure %in% c('dsRNA'),1, 0 ))
#ssRNA
table_alone_EVEs_event<-table_alone_EVEs_event %>% mutate (
  Nb_EVEs_ssRNA_Events  = ifelse(Nb_EVEs >= 1 & consensus_genomic_structure %in% c('ssRNA'),1, 0 ))
#Unclassified 
table_alone_EVEs_event<-table_alone_EVEs_event %>% mutate (
  Nb_EVEs_Unclassified_Events = ifelse(Nb_EVEs >= 1 & consensus_genomic_structure%in% c('Unknown'),1, 0 ))



#Add dEVES count
library(tidyverse)
Env_table_bis<- Env_table[!duplicated(Env_table$New_query_bis2),]
Env_table_bis<-select(Env_table_bis,"Clustername",'New_query_bis2','Event',"Mean_dNdS","Pvalue_dNdS",'FDR_pvalue_dNdS','pseudogenized','SE_dNdS','TPM_all')
Env_table_bis <-Env_table_bis %>%
  group_by(Clustername,New_query_bis2) %>%
  filter(any(FDR_pvalue_dNdS == 1 & as.numeric(as.character(Mean_dNdS))+as.numeric(as.character(SE_dNdS)) < 1 & pseudogenized ==0 | TPM_all >=1000 & pseudogenized ==0))

names(Env_table_bis)[names(Env_table_bis)=="Clustername"] <- "Clustername_bis"
names(table_alone_EVEs_event)[names(table_alone_EVEs_event)=="Events"] <- "Event_Groups"

table_alone_EVEs_event$rowname<-NULL

sub<-table_alone_EVEs_event  %>% 
  rownames_to_column()  %>% 
  mutate(Event_Groups = as.character(Event_Groups)) %>% 
  separate_rows(Event_Groups, sep = ",") %>% 
  left_join(., 
            Env_table_bis %>% 
              unite(col = "Event_Groups", Event, Clustername_bis) %>% 
              mutate(count = if_else(Mean_dNdS < 1 & Pvalue_dNdS < 0.05 | TPM_all>= 1000 & pseudogenized ==0 ,1L, 0L))) %>%
  distinct(Event_Groups, .keep_all = TRUE) %>%
  group_by(rowname,) %>% 
  summarise(Event_Groups = paste(unique(Event_Groups), collapse = ","),
            Nb_dEVEs = sum(count, na.rm=T))

table_alone_EVEs_event$rowname <- rownames(table_alone_EVEs_event) 
table_alone_EVEs_event<- merge(x = sub, y =table_alone_EVEs_event, by = "rowname", all = TRUE)
table_alone_EVEs_event$Event_Groups.x <- NULL
table_alone_EVEs_event$Nb_dEVEs[is.na(table_alone_EVEs_event$Nb_dEVEs)] <- 0

names(table_alone_EVEs_event)[names(table_alone_EVEs_event)=="Event_Groups.y"] <- "Event"

#EVENTS according to lifestyles
table_alone_EVEs_event<-table_alone_EVEs_event %>% mutate (
  Nb_endo_dEVEs_Events = ifelse(Nb_dEVEs >= 1 & lifecycle1 %in% c('endoparasitoid'),1,0 ))
table_alone_EVEs_event<-table_alone_EVEs_event %>% mutate (
  Nb_ecto_dEVEs_Events = ifelse(Nb_dEVEs >= 1 & lifecycle1 %in% c('ectoparasitoid'),1,0 ))
table_alone_EVEs_event<-table_alone_EVEs_event %>% mutate (
  Nb_freeliving_dEVEs_Events = ifelse(Nb_dEVEs >= 1 & lifecycle1 %in% c('freeliving'),1,0 ))
#NB EVES according to lifestyles
table_alone_EVEs_event %>% mutate (
  Nb_ecto_dEVEs = ifelse(Nb_dEVEs >= 1 & lifecycle1 %in% c('ectoparasitoid'),Nb_dEVEs, 0 ))
table_alone_EVEs_event<-table_alone_EVEs_event %>% mutate (
  Nb_freeliving_dEVEs = ifelse(Nb_dEVEs >= 1 & lifecycle1 %in% c('freeliving'),Nb_dEVEs, 0 ))
table_alone_EVEs_event<-table_alone_EVEs_event %>% mutate (
  Nb_endo_dEVEs = ifelse(Nb_dEVEs >= 1 & lifecycle1 %in% c('endoparasitoid'),Nb_dEVEs, 0 ))

#NB dEVES according to genomic structure
#dsDNA 
table_alone_EVEs_event<-table_alone_EVEs_event %>% mutate (
  Nb_dEVEs_dsDNA = ifelse(Nb_dEVEs >= 1 & consensus_genomic_structure %in% c('dsDNA'),Nb_dEVEs, 0 ))
#ssDNA
table_alone_EVEs_event<-table_alone_EVEs_event %>% mutate (
  Nb_dEVEs_ssDNA = ifelse(Nb_dEVEs >= 1 & consensus_genomic_structure %in% c('ssDNA'),Nb_dEVEs, 0 ))
#dsRNA
table_alone_EVEs_event<-table_alone_EVEs_event %>% mutate (
  Nb_dEVEs_dsRNA = ifelse(Nb_dEVEs >= 1 & consensus_genomic_structure %in% c('dsRNA'),Nb_dEVEs, 0 ))
#ssRNA
table_alone_EVEs_event<-table_alone_EVEs_event %>% mutate (
  Nb_dEVEs_ssRNA = ifelse(Nb_dEVEs >= 1 & consensus_genomic_structure %in% c('ssRNA'),Nb_dEVEs, 0 ))
#Unclassified 
table_alone_EVEs_event<-table_alone_EVEs_event %>% mutate (
  Nb_dEVEs_Unclassified = ifelse(Nb_dEVEs >= 1 & consensus_genomic_structure%in% c('Unknown'),Nb_dEVEs, 0 ))


#NB EVES EVENT according to genomic structure
#dsDNA 
table_alone_EVEs_event<-table_alone_EVEs_event %>% mutate (
  Nb_dEVEs_dsDNA_Events = ifelse(Nb_dEVEs >= 1 & consensus_genomic_structure %in% c('dsDNA'),1, 0 ))
#ssDNA
table_alone_EVEs_event<-table_alone_EVEs_event %>% mutate (
  Nb_dEVEs_ssDNA_Events  = ifelse(Nb_dEVEs >= 1 & consensus_genomic_structure %in% c('ssDNA'),1, 0 ))
#dsRNA
table_alone_EVEs_event<-table_alone_EVEs_event %>% mutate (
  Nb_dEVEs_dsRNA_Events  = ifelse(Nb_dEVEs >= 1 & consensus_genomic_structure %in% c('dsRNA'),1, 0 ))
#ssRNA
table_alone_EVEs_event<-table_alone_EVEs_event %>% mutate (
  Nb_dEVEs_ssRNA_Events  = ifelse(Nb_dEVEs >= 1 & consensus_genomic_structure %in% c('ssRNA'),1, 0 ))
#Unclassified 
table_alone_EVEs_event<-table_alone_EVEs_event %>% mutate (
  Nb_dEVEs_Unclassified_Events = ifelse(Nb_dEVEs >= 1 & consensus_genomic_structure%in% c('Unknown'),1, 0 ))

EVEs_alone_event_df_EVEs_count<- table_alone_EVEs_event


##################

Event_alone_df <- EVEs_alone_event_df_EVEs_count
Event_shared_df <- EVEs_shared_event_df_EVEs_count 


#Lets gather EVEs and dEVES shared event resuts :

#Nb EVEs event/lifecycles 
#dsDNA
#freeliving dsDNA
Nb_EVEs_dsDNA_fl_Event<-sum(Event_alone_df[which(Event_alone_df$lifecycle1=="freeliving"),]$Nb_EVEs_dsDNA_Events,na.rm=T)+sum(Event_shared_df[which(Event_shared_df$lifecycle1=="freeliving"),]$Nb_EVEs_dsDNA_Events,na.rm=T)
#ectoparasitoide dsDNA
Nb_EVEs_dsDNA_ecto_Event<-sum(Event_alone_df[which(Event_alone_df$lifecycle1=='ectoparasitoid'),]$Nb_EVEs_dsDNA_Events,na.rm=T)+sum(Event_shared_df[which(Event_shared_df$lifecycle1=='ectoparasitoid'),]$Nb_EVEs_dsDNA_Events,na.rm=T)
#endoparasitoide dsDNA 
Nb_EVEs_dsDNA_endo_Event<-sum(Event_alone_df[which(Event_alone_df$lifecycle1=='endoparasitoid'),]$Nb_EVEs_dsDNA_Events,na.rm=T)+sum(Event_shared_df[which(Event_shared_df$lifecycle1=='endoparasitoid'),]$Nb_EVEs_dsDNA_Events,na.rm=T)
#Unknown dsDNA
Nb_EVEs_dsDNA_Unkn_Event<-sum(Event_alone_df[which(Event_alone_df$lifecycle1=="Unknown"),]$Nb_EVEs_dsDNA_Events,na.rm=T)+sum(Event_shared_df[which(Event_shared_df$lifecycle1=="Unknown"),]$Nb_EVEs_dsDNA_Events,na.rm=T)

#ssDNA
#freeliving ssDNA
Nb_EVEs_ssDNA_fl_Event<-sum(Event_alone_df[which(Event_alone_df$lifecycle1=="freeliving"),]$Nb_EVEs_ssDNA_Events,na.rm=T)+sum(Event_shared_df[which(Event_shared_df$lifecycle1=="freeliving"),]$Nb_EVEs_ssDNA_Events,na.rm=T)
#ectoparasitoide ssDNA
Nb_EVEs_ssDNA_ecto_Event<-sum(Event_alone_df[which(Event_alone_df$lifecycle1=='ectoparasitoid'),]$Nb_EVEs_ssDNA_Events,na.rm=T)+sum(Event_shared_df[which(Event_shared_df$lifecycle1=='ectoparasitoid'),]$Nb_EVEs_ssDNA_Events,na.rm=T)
#endoparasitoide ssDNA 
Nb_EVEs_ssDNA_endo_Event<-sum(Event_alone_df[which(Event_alone_df$lifecycle1=='endoparasitoid'),]$Nb_EVEs_ssDNA_Events,na.rm=T)+sum(Event_shared_df[which(Event_shared_df$lifecycle1=='endoparasitoid'),]$Nb_EVEs_ssDNA_Events,na.rm=T)
#Unknown ssDNA
Nb_EVEs_ssDNA_Unkn_Event<-sum(Event_alone_df[which(Event_alone_df$lifecycle1=="Unknown"),]$Nb_EVEs_ssDNA_Events,na.rm=T)+sum(Event_shared_df[which(Event_shared_df$lifecycle1=="Unknown"),]$Nb_EVEs_ssDNA_Events,na.rm=T)

#ssRNA
#freeliving ssRNA
Nb_EVEs_ssRNA_fl_Event<-sum(Event_alone_df[which(Event_alone_df$lifecycle1=="freeliving"),]$Nb_EVEs_ssRNA_Events,na.rm=T)+sum(Event_shared_df[which(Event_shared_df$lifecycle1=="freeliving"),]$Nb_EVEs_ssRNA_Events,na.rm=T)
#ectoparasitoide ssRNA
Nb_EVEs_ssRNA_ecto_Event<-sum(Event_alone_df[which(Event_alone_df$lifecycle1=='ectoparasitoid'),]$Nb_EVEs_ssRNA_Events,na.rm=T)+sum(Event_shared_df[which(Event_shared_df$lifecycle1=='ectoparasitoid'),]$Nb_EVEs_ssRNA_Events,na.rm=T)
#endoparasitoide ssRNA 
Nb_EVEs_ssRNA_endo_Event<-sum(Event_alone_df[which(Event_alone_df$lifecycle1=='endoparasitoid'),]$Nb_EVEs_ssRNA_Events,na.rm=T)+sum(Event_shared_df[which(Event_shared_df$lifecycle1=='endoparasitoid'),]$Nb_EVEs_ssRNA_Events,na.rm=T)
#Unknown ssRNA
Nb_EVEs_ssRNA_Unkn_Event<-sum(Event_alone_df[which(Event_alone_df$lifecycle1=="Unknown"),]$Nb_EVEs_ssRNA_Events,na.rm=T)+sum(Event_shared_df[which(Event_shared_df$lifecycle1=="Unknown"),]$Nb_EVEs_ssRNA_Events,na.rm=T)

#dsRNA
#freeliving dsRNA
Nb_EVEs_dsRNA_fl_Event<-sum(Event_alone_df[which(Event_alone_df$lifecycle1=="freeliving"),]$Nb_EVEs_dsRNA_Events,na.rm=T)+sum(Event_shared_df[which(Event_shared_df$lifecycle1=="freeliving"),]$Nb_EVEs_dsRNA_Events,na.rm=T)
#ectoparasitoide dsRNA
Nb_EVEs_dsRNA_ecto_Event<-sum(Event_alone_df[which(Event_alone_df$lifecycle1=='ectoparasitoid'),]$Nb_EVEs_dsRNA_Events,na.rm=T)+sum(Event_shared_df[which(Event_shared_df$lifecycle1=='ectoparasitoid'),]$Nb_EVEs_dsRNA_Events,na.rm=T)
#endoparasitoide dsRNA 
Nb_EVEs_dsRNA_endo_Event<-sum(Event_alone_df[which(Event_alone_df$lifecycle1=='endoparasitoid'),]$Nb_EVEs_dsRNA_Events,na.rm=T)+sum(Event_shared_df[which(Event_shared_df$lifecycle1=='endoparasitoid'),]$Nb_EVEs_dsRNA_Events,na.rm=T)
#Unknown dsRNA
Nb_EVEs_dsRNA_Unkn_Event<-sum(Event_alone_df[which(Event_alone_df$lifecycle1=="Unknown"),]$Nb_EVEs_dsRNA_Events,na.rm=T)+sum(Event_shared_df[which(Event_shared_df$lifecycle1=="Unknown"),]$Nb_EVEs_dsRNA_Events,na.rm=T)

#Unclassified
#freeliving Unclassified
Nb_EVEs_Uncla_fl_Event<-sum(Event_alone_df[which(Event_alone_df$lifecycle1=="freeliving"),]$Nb_EVEs_Unclassified_Events,na.rm=T)+sum(Event_shared_df[which(Event_shared_df$lifecycle1=="freeliving"),]$Nb_EVEs_Unclassified_Events,na.rm=T)
#ectoparasitoide Unclassified
Nb_EVEs_Uncla_ecto_Event<-sum(Event_alone_df[which(Event_alone_df$lifecycle1=='ectoparasitoid'),]$Nb_EVEs_Unclassified_Events,na.rm=T)+sum(Event_shared_df[which(Event_shared_df$lifecycle1=='ectoparasitoid'),]$Nb_EVEs_Unclassified_Events,na.rm=T)
#endoparasitoide Unclassified 
Nb_EVEs_Uncla_endo_Event<-sum(Event_alone_df[which(Event_alone_df$lifecycle1=='endoparasitoid'),]$Nb_EVEs_Unclassified_Events,na.rm=T)+sum(Event_shared_df[which(Event_shared_df$lifecycle1=='endoparasitoid'),]$Nb_EVEs_Unclassified_Events,na.rm=T)
#Unknown Unclassified
Nb_EVEs_Uncla_Unkn_Event<-sum(Event_alone_df[which(Event_alone_df$lifecycle1=="Unknown"),]$Nb_EVEs_Unclassified_Events,na.rm=T)+sum(Event_shared_df[which(Event_shared_df$lifecycle1=="Unknown"),]$Nb_EVEs_Unclassified_Events,na.rm=T)

#Nb dEVEs event/lifecycles 
#dsDNA
#freeliving dsDNA
Nb_dEVEs_dsDNA_fl_Event<-sum(Event_alone_df[which(Event_alone_df$lifecycle1=="freeliving"),]$Nb_dEVEs_dsDNA_Events,na.rm=T)+sum(Event_shared_df[which(Event_shared_df$lifecycle1=="freeliving"),]$Nb_dEVEs_dsDNA_Events,na.rm=T)
#ectoparasitoide dsDNA
Nb_dEVEs_dsDNA_ecto_Event<-sum(Event_alone_df[which(Event_alone_df$lifecycle1=='ectoparasitoid'),]$Nb_dEVEs_dsDNA_Events,na.rm=T)+sum(Event_shared_df[which(Event_shared_df$lifecycle1=='ectoparasitoid'),]$Nb_dEVEs_dsDNA_Events,na.rm=T)
#endoparasitoide dsDNA 
Nb_dEVEs_dsDNA_endo_Event<-sum(Event_alone_df[which(Event_alone_df$lifecycle1=='endoparasitoid'),]$Nb_dEVEs_dsDNA_Events,na.rm=T)+sum(Event_shared_df[which(Event_shared_df$lifecycle1=='endoparasitoid'),]$Nb_dEVEs_dsDNA_Events,na.rm=T)
#Unknown dsDNA
Nb_dEVEs_dsDNA_Unkn_Event<-sum(Event_alone_df[which(Event_alone_df$lifecycle1=="Unknown"),]$Nb_dEVEs_dsDNA_Events,na.rm=T)+sum(Event_shared_df[which(Event_shared_df$lifecycle1=="Unknown"),]$Nb_dEVEs_dsDNA_Events,na.rm=T)

#ssDNA
#freeliving ssDNA
Nb_dEVEs_ssDNA_fl_Event<-sum(Event_alone_df[which(Event_alone_df$lifecycle1=="freeliving"),]$Nb_dEVEs_ssDNA_Events,na.rm=T)+sum(Event_shared_df[which(Event_shared_df$lifecycle1=="freeliving"),]$Nb_dEVEs_ssDNA_Events,na.rm=T)
#ectoparasitoide ssDNA
Nb_dEVEs_ssDNA_ecto_Event<-sum(Event_alone_df[which(Event_alone_df$lifecycle1=='ectoparasitoid'),]$Nb_dEVEs_ssDNA_Events,na.rm=T)+sum(Event_shared_df[which(Event_shared_df$lifecycle1=='ectoparasitoid'),]$Nb_dEVEs_ssDNA_Events,na.rm=T)
#endoparasitoide ssDNA 
Nb_dEVEs_ssDNA_endo_Event<-sum(Event_alone_df[which(Event_alone_df$lifecycle1=='endoparasitoid'),]$Nb_dEVEs_ssDNA_Events,na.rm=T)+sum(Event_shared_df[which(Event_shared_df$lifecycle1=='endoparasitoid'),]$Nb_dEVEs_ssDNA_Events,na.rm=T)
#Unknown ssDNA
Nb_dEVEs_ssDNA_Unkn_Event<-sum(Event_alone_df[which(Event_alone_df$lifecycle1=="Unknown"),]$Nb_dEVEs_ssDNA_Events,na.rm=T)+sum(Event_shared_df[which(Event_shared_df$lifecycle1=="Unknown"),]$Nb_dEVEs_ssDNA_Events,na.rm=T)

#ssRNA
#freeliving ssRNA
Nb_dEVEs_ssRNA_fl_Event<-sum(Event_alone_df[which(Event_alone_df$lifecycle1=="freeliving"),]$Nb_dEVEs_ssRNA_Events,na.rm=T)+sum(Event_shared_df[which(Event_shared_df$lifecycle1=="freeliving"),]$Nb_dEVEs_ssRNA_Events,na.rm=T)
#ectoparasitoide ssRNA
Nb_dEVEs_ssRNA_ecto_Event<-sum(Event_alone_df[which(Event_alone_df$lifecycle1=='ectoparasitoid'),]$Nb_dEVEs_ssRNA_Events,na.rm=T)+sum(Event_shared_df[which(Event_shared_df$lifecycle1=='ectoparasitoid'),]$Nb_dEVEs_ssRNA_Events,na.rm=T)
#endoparasitoide ssRNA 
Nb_dEVEs_ssRNA_endo_Event<-sum(Event_alone_df[which(Event_alone_df$lifecycle1=='endoparasitoid'),]$Nb_dEVEs_ssRNA_Events,na.rm=T)+sum(Event_shared_df[which(Event_shared_df$lifecycle1=='endoparasitoid'),]$Nb_dEVEs_ssRNA_Events,na.rm=T)
#Unknown ssRNA
Nb_dEVEs_ssRNA_Unkn_Event<-sum(Event_alone_df[which(Event_alone_df$lifecycle1=="Unknown"),]$Nb_dEVEs_ssRNA_Events,na.rm=T)+sum(Event_shared_df[which(Event_shared_df$lifecycle1=="Unknown"),]$Nb_dEVEs_ssRNA_Events,na.rm=T)

#dsRNA
#freeliving dsRNA
Nb_dEVEs_dsRNA_fl_Event<-sum(Event_alone_df[which(Event_alone_df$lifecycle1=="freeliving"),]$Nb_dEVEs_dsRNA_Events,na.rm=T)+sum(Event_shared_df[which(Event_shared_df$lifecycle1=="freeliving"),]$Nb_dEVEs_dsRNA_Events,na.rm=T)
#ectoparasitoide dsRNA
Nb_dEVEs_dsRNA_ecto_Event<-sum(Event_alone_df[which(Event_alone_df$lifecycle1=='ectoparasitoid'),]$Nb_dEVEs_dsRNA_Events,na.rm=T)+sum(Event_shared_df[which(Event_shared_df$lifecycle1=='ectoparasitoid'),]$Nb_dEVEs_dsRNA_Events,na.rm=T)
#endoparasitoide dsRNA 
Nb_dEVEs_dsRNA_endo_Event<-sum(Event_alone_df[which(Event_alone_df$lifecycle1=='endoparasitoid'),]$Nb_dEVEs_dsRNA_Events,na.rm=T)+sum(Event_shared_df[which(Event_shared_df$lifecycle1=='endoparasitoid'),]$Nb_dEVEs_dsRNA_Events,na.rm=T)
#Unknown dsRNA
Nb_dEVEs_dsRNA_Unkn_Event<-sum(Event_alone_df[which(Event_alone_df$lifecycle1=="Unknown"),]$Nb_dEVEs_dsRNA_Events,na.rm=T)+sum(Event_shared_df[which(Event_shared_df$lifecycle1=="Unknown"),]$Nb_dEVEs_dsRNA_Events,na.rm=T)

#Unclassified
#freeliving Unclassified
Nb_dEVEs_Uncla_fl_Event<-sum(Event_alone_df[which(Event_alone_df$lifecycle1=="freeliving"),]$Nb_dEVEs_Unclassified_Events,na.rm=T)+sum(Event_shared_df[which(Event_shared_df$lifecycle1=="freeliving"),]$Nb_dEVEs_Unclassified_Events,na.rm=T)
#ectoparasitoide Unclassified
Nb_dEVEs_Uncla_ecto_Event<-sum(Event_alone_df[which(Event_alone_df$lifecycle1=='ectoparasitoid'),]$Nb_dEVEs_Unclassified_Events,na.rm=T)+sum(Event_shared_df[which(Event_shared_df$lifecycle1=='ectoparasitoid'),]$Nb_dEVEs_Unclassified_Events,na.rm=T)
#endoparasitoide Unclassified 
Nb_dEVEs_Uncla_endo_Event<-sum(Event_alone_df[which(Event_alone_df$lifecycle1=='endoparasitoid'),]$Nb_dEVEs_Unclassified_Events,na.rm=T)+sum(Event_shared_df[which(Event_shared_df$lifecycle1=='endoparasitoid'),]$Nb_dEVEs_Unclassified_Events,na.rm=T)
#Unknown Unclassified
Nb_dEVEs_Uncla_Unkn_Event<-sum(Event_alone_df[which(Event_alone_df$lifecycle1=="Unknown"),]$Nb_dEVEs_Unclassified_Events,na.rm=T)+sum(Event_shared_df[which(Event_shared_df$lifecycle1=="Unknown"),]$Nb_dEVEs_Unclassified_Events,na.rm=T)



###Count EVEs and create the geom_bar plot 

#Remove duplicated EVEs within events to not overestimated the number of EVEs 
dsDNA_tab_reduced <-dsDNA_tab[!duplicated(dsDNA_tab[ , c("Clustername","Event")]),]

#dsDNA
EVEs_endo_dsDNA<-nrow(dsDNA_tab_reduced[which(dsDNA_tab_reduced$lifecycle1=='endoparasitoid' & dsDNA_tab_reduced$consensus_genomic_structure =="dsDNA"),])
dEVEs_endo_dsDNA<-nrow(dsDNA_tab_reduced[which(dsDNA_tab_reduced$lifecycle1=='endoparasitoid' &  dsDNA_tab_reduced$consensus_genomic_structure =="dsDNA" & dsDNA_tab_reduced$FDR_pvalue_dNdS == 1 & as.numeric(as.character(dsDNA_tab_reduced$Mean_dNdS))&as.numeric(as.character(dsDNA_tab_reduced$SE_dNdS)) < 1 & dsDNA_tab_reduced$pseudogenized ==0 | dsDNA_tab_reduced$lifecycle1=='endoparasitoid' &  dsDNA_tab_reduced$consensus_genomic_structure =="dsDNA" & dsDNA_tab_reduced$TPM_all>=1000 & dsDNA_tab_reduced$pseudogenized ==0) ,])

EVEs_ecto_dsDNA<-nrow(dsDNA_tab_reduced[which(dsDNA_tab_reduced$lifecycle1=='ectoparasitoid' &  dsDNA_tab_reduced$consensus_genomic_structure =="dsDNA" ),])
dEVEs_ecto_dsDNA<-nrow(dsDNA_tab_reduced[which(dsDNA_tab_reduced$lifecycle1=='ectoparasitoid' &  dsDNA_tab_reduced$consensus_genomic_structure =="dsDNA" & dsDNA_tab_reduced$FDR_pvalue_dNdS == 1 & as.numeric(as.character(dsDNA_tab_reduced$Mean_dNdS))&as.numeric(as.character(dsDNA_tab_reduced$SE_dNdS)) < 1 & dsDNA_tab_reduced$pseudogenized ==0 | dsDNA_tab_reduced$lifecycle1=='ectoparasitoid' &  dsDNA_tab_reduced$consensus_genomic_structure =="dsDNA" & dsDNA_tab_reduced$TPM_all>=1000& dsDNA_tab_reduced$pseudogenized ==0) ,])

EVEs_fl_dsDNA<-nrow(dsDNA_tab_reduced[which(dsDNA_tab_reduced$lifecycle1=="freeliving" &  dsDNA_tab_reduced$consensus_genomic_structure =="dsDNA" ),])
dEVEs_fl_dsDNA<-nrow(dsDNA_tab_reduced[which(dsDNA_tab_reduced$lifecycle1=="freeliving" &  dsDNA_tab_reduced$consensus_genomic_structure =="dsDNA" & dsDNA_tab_reduced$FDR_pvalue_dNdS == 1 & as.numeric(as.character(dsDNA_tab_reduced$Mean_dNdS))&as.numeric(as.character(dsDNA_tab_reduced$SE_dNdS)) < 1 & dsDNA_tab_reduced$pseudogenized ==0 | dsDNA_tab_reduced$lifecycle1=="freeliving" &  dsDNA_tab_reduced$consensus_genomic_structure =="dsDNA" & dsDNA_tab_reduced$TPM_all>=1000& dsDNA_tab_reduced$pseudogenized ==0) ,])


#ssDNA
EVEs_endo_ssDNA<-nrow(dsDNA_tab_reduced[which(dsDNA_tab_reduced$lifecycle1=='endoparasitoid' & dsDNA_tab_reduced$consensus_genomic_structure =="ssDNA"),])
dEVEs_endo_ssDNA<-nrow(dsDNA_tab_reduced[which(dsDNA_tab_reduced$lifecycle1=='endoparasitoid' &  dsDNA_tab_reduced$consensus_genomic_structure =="ssDNA" & dsDNA_tab_reduced$FDR_pvalue_dNdS == 1 & as.numeric(as.character(dsDNA_tab_reduced$Mean_dNdS))&as.numeric(as.character(dsDNA_tab_reduced$SE_dNdS)) < 1 & dsDNA_tab_reduced$pseudogenized ==0 | dsDNA_tab_reduced$lifecycle1=='endoparasitoid' &  dsDNA_tab_reduced$consensus_genomic_structure =="ssDNA" & dsDNA_tab_reduced$TPM_all>=1000& dsDNA_tab_reduced$pseudogenized ==0) ,])

EVEs_ecto_ssDNA<-nrow(dsDNA_tab_reduced[which(dsDNA_tab_reduced$lifecycle1=='ectoparasitoid' &  dsDNA_tab_reduced$consensus_genomic_structure =="ssDNA" ),])
dEVEs_ecto_ssDNA<-nrow(dsDNA_tab_reduced[which(dsDNA_tab_reduced$lifecycle1=='ectoparasitoid' &  dsDNA_tab_reduced$consensus_genomic_structure =="ssDNA" & dsDNA_tab_reduced$FDR_pvalue_dNdS == 1 & as.numeric(as.character(dsDNA_tab_reduced$Mean_dNdS))&as.numeric(as.character(dsDNA_tab_reduced$SE_dNdS)) < 1 & dsDNA_tab_reduced$pseudogenized ==0 | dsDNA_tab_reduced$lifecycle1=='ectoparasitoid' &  dsDNA_tab_reduced$consensus_genomic_structure =="ssDNA" & dsDNA_tab_reduced$TPM_all>=1000& dsDNA_tab_reduced$pseudogenized ==0) ,])

EVEs_fl_ssDNA<-nrow(dsDNA_tab_reduced[which(dsDNA_tab_reduced$lifecycle1=="freeliving" &  dsDNA_tab_reduced$consensus_genomic_structure =="ssDNA" ),])
dEVEs_fl_ssDNA<-nrow(dsDNA_tab_reduced[which(dsDNA_tab_reduced$lifecycle1=="freeliving" &  dsDNA_tab_reduced$consensus_genomic_structure =="ssDNA" & dsDNA_tab_reduced$FDR_pvalue_dNdS == 1 & as.numeric(as.character(dsDNA_tab_reduced$Mean_dNdS))&as.numeric(as.character(dsDNA_tab_reduced$SE_dNdS)) < 1 & dsDNA_tab_reduced$pseudogenized ==0 | dsDNA_tab_reduced$lifecycle1=="freeliving" &  dsDNA_tab_reduced$consensus_genomic_structure =="ssDNA" & dsDNA_tab_reduced$TPM_all>=1000& dsDNA_tab_reduced$pseudogenized ==0) ,])



#dsRNA
EVEs_endo_dsRNA<-nrow(dsDNA_tab_reduced[which(dsDNA_tab_reduced$lifecycle1=='endoparasitoid' & dsDNA_tab_reduced$consensus_genomic_structure =="dsRNA"),])
dEVEs_endo_dsRNA<-nrow(dsDNA_tab_reduced[which(dsDNA_tab_reduced$lifecycle1=='endoparasitoid' &  dsDNA_tab_reduced$consensus_genomic_structure =="dsRNA" & dsDNA_tab_reduced$FDR_pvalue_dNdS == 1 & as.numeric(as.character(dsDNA_tab_reduced$Mean_dNdS))&as.numeric(as.character(dsDNA_tab_reduced$SE_dNdS)) < 1 & dsDNA_tab_reduced$pseudogenized ==0 | dsDNA_tab_reduced$lifecycle1=='endoparasitoid' &  dsDNA_tab_reduced$consensus_genomic_structure =="dsRNA" & dsDNA_tab_reduced$TPM_all>=1000& dsDNA_tab_reduced$pseudogenized ==0) ,])

EVEs_ecto_dsRNA<-nrow(dsDNA_tab_reduced[which(dsDNA_tab_reduced$lifecycle1=='ectoparasitoid' &  dsDNA_tab_reduced$consensus_genomic_structure =="dsRNA" ),])
dEVEs_ecto_dsRNA<-nrow(dsDNA_tab_reduced[which(dsDNA_tab_reduced$lifecycle1=='ectoparasitoid' &  dsDNA_tab_reduced$consensus_genomic_structure =="dsRNA" & dsDNA_tab_reduced$FDR_pvalue_dNdS == 1 & as.numeric(as.character(dsDNA_tab_reduced$Mean_dNdS))&as.numeric(as.character(dsDNA_tab_reduced$SE_dNdS)) < 1 & dsDNA_tab_reduced$pseudogenized ==0 | dsDNA_tab_reduced$lifecycle1=='ectoparasitoid' &  dsDNA_tab_reduced$consensus_genomic_structure =="dsRNA" & dsDNA_tab_reduced$TPM_all>=1000& dsDNA_tab_reduced$pseudogenized ==0) ,])

EVEs_fl_dsRNA<-nrow(dsDNA_tab_reduced[which(dsDNA_tab_reduced$lifecycle1=="freeliving" &  dsDNA_tab_reduced$consensus_genomic_structure =="dsRNA" ),])
dEVEs_fl_dsRNA<-nrow(dsDNA_tab_reduced[which(dsDNA_tab_reduced$lifecycle1=="freeliving" &  dsDNA_tab_reduced$consensus_genomic_structure =="dsRNA" & dsDNA_tab_reduced$FDR_pvalue_dNdS == 1 & as.numeric(as.character(dsDNA_tab_reduced$Mean_dNdS))&as.numeric(as.character(dsDNA_tab_reduced$SE_dNdS)) < 1 & dsDNA_tab_reduced$pseudogenized ==0 | dsDNA_tab_reduced$lifecycle1=="freeliving" &  dsDNA_tab_reduced$consensus_genomic_structure =="dsRNA" & dsDNA_tab_reduced$TPM_all>=1000& dsDNA_tab_reduced$pseudogenized ==0) ,])



#ssRNA
EVEs_endo_ssRNA<-nrow(dsDNA_tab_reduced[which(dsDNA_tab_reduced$lifecycle1=='endoparasitoid' & dsDNA_tab_reduced$consensus_genomic_structure =="ssRNA"),])
dEVEs_endo_ssRNA<-nrow(dsDNA_tab_reduced[which(dsDNA_tab_reduced$lifecycle1=='endoparasitoid' &  dsDNA_tab_reduced$consensus_genomic_structure =="ssRNA" & dsDNA_tab_reduced$FDR_pvalue_dNdS == 1 & as.numeric(as.character(dsDNA_tab_reduced$Mean_dNdS))&as.numeric(as.character(dsDNA_tab_reduced$SE_dNdS)) < 1 & dsDNA_tab_reduced$pseudogenized ==0 | dsDNA_tab_reduced$lifecycle1=='endoparasitoid' &  dsDNA_tab_reduced$consensus_genomic_structure =="ssRNA" & dsDNA_tab_reduced$TPM_all>=1000& dsDNA_tab_reduced$pseudogenized ==0) ,])

EVEs_ecto_ssRNA<-nrow(dsDNA_tab_reduced[which(dsDNA_tab_reduced$lifecycle1=='ectoparasitoid' &  dsDNA_tab_reduced$consensus_genomic_structure =="ssRNA" ),])
dEVEs_ecto_ssRNA<-nrow(dsDNA_tab_reduced[which(dsDNA_tab_reduced$lifecycle1=='ectoparasitoid' &  dsDNA_tab_reduced$consensus_genomic_structure =="ssRNA" & dsDNA_tab_reduced$FDR_pvalue_dNdS == 1 & as.numeric(as.character(dsDNA_tab_reduced$Mean_dNdS))&as.numeric(as.character(dsDNA_tab_reduced$SE_dNdS)) < 1 & dsDNA_tab_reduced$pseudogenized ==0 | dsDNA_tab_reduced$lifecycle1=='ectoparasitoid' &  dsDNA_tab_reduced$consensus_genomic_structure =="ssRNA" & dsDNA_tab_reduced$TPM_all>=1000& dsDNA_tab_reduced$pseudogenized ==0) ,])

EVEs_fl_ssRNA<-nrow(dsDNA_tab_reduced[which(dsDNA_tab_reduced$lifecycle1=="freeliving" &  dsDNA_tab_reduced$consensus_genomic_structure =="ssRNA" ),])
dEVEs_fl_ssRNA<-nrow(dsDNA_tab_reduced[which(dsDNA_tab_reduced$lifecycle1=="freeliving" &  dsDNA_tab_reduced$consensus_genomic_structure =="ssRNA" & dsDNA_tab_reduced$FDR_pvalue_dNdS == 1 & as.numeric(as.character(dsDNA_tab_reduced$Mean_dNdS))&as.numeric(as.character(dsDNA_tab_reduced$SE_dNdS)) < 1 & dsDNA_tab_reduced$pseudogenized ==0 | dsDNA_tab_reduced$lifecycle1=="freeliving" &  dsDNA_tab_reduced$consensus_genomic_structure =="ssRNA" & dsDNA_tab_reduced$TPM_all>=1000& dsDNA_tab_reduced$pseudogenized ==0) ,])


#Unclassified
EVEs_endo_Unclassified<-nrow(dsDNA_tab_reduced[which(dsDNA_tab_reduced$lifecycle1=='endoparasitoid' & dsDNA_tab_reduced$consensus_genomic_structure =="Unknown"),])
dEVEs_endo_Unclassified<-nrow(dsDNA_tab_reduced[which(dsDNA_tab_reduced$lifecycle1=='endoparasitoid' &  dsDNA_tab_reduced$consensus_genomic_structure =="Unknown" & dsDNA_tab_reduced$FDR_pvalue_dNdS == 1 & as.numeric(as.character(dsDNA_tab_reduced$Mean_dNdS))&as.numeric(as.character(dsDNA_tab_reduced$SE_dNdS)) < 1 & dsDNA_tab_reduced$pseudogenized ==0 | dsDNA_tab_reduced$lifecycle1=='endoparasitoid' &  dsDNA_tab_reduced$consensus_genomic_structure =="Unknown" & dsDNA_tab_reduced$TPM_all>=1000& dsDNA_tab_reduced$pseudogenized ==0) ,])

EVEs_ecto_Unclassified<-nrow(dsDNA_tab_reduced[which(dsDNA_tab_reduced$lifecycle1=='ectoparasitoid' &  dsDNA_tab_reduced$consensus_genomic_structure =="Unknown" ),])
dEVEs_ecto_Unclassified<-nrow(dsDNA_tab_reduced[which(dsDNA_tab_reduced$lifecycle1=='ectoparasitoid' &  dsDNA_tab_reduced$consensus_genomic_structure =="Unknown" & dsDNA_tab_reduced$FDR_pvalue_dNdS == 1 & as.numeric(as.character(dsDNA_tab_reduced$Mean_dNdS))&as.numeric(as.character(dsDNA_tab_reduced$SE_dNdS)) < 1 & dsDNA_tab_reduced$pseudogenized ==0 | dsDNA_tab_reduced$lifecycle1=='ectoparasitoid' &  dsDNA_tab_reduced$consensus_genomic_structure =="Unknown" & dsDNA_tab_reduced$TPM_all>=1000& dsDNA_tab_reduced$pseudogenized ==0) ,])

EVEs_fl_Unclassified<-nrow(dsDNA_tab_reduced[which(dsDNA_tab_reduced$lifecycle1=="freeliving" &  dsDNA_tab_reduced$consensus_genomic_structure =="Unknown" ),])
dEVEs_fl_Unclassified<-nrow(dsDNA_tab_reduced[which(dsDNA_tab_reduced$lifecycle1=="freeliving" &  dsDNA_tab_reduced$consensus_genomic_structure =="Unknown" & dsDNA_tab_reduced$FDR_pvalue_dNdS == 1 & as.numeric(as.character(dsDNA_tab_reduced$Mean_dNdS))&as.numeric(as.character(dsDNA_tab_reduced$SE_dNdS)) < 1 & dsDNA_tab_reduced$pseudogenized ==0 | dsDNA_tab_reduced$lifecycle1=="freeliving" &  dsDNA_tab_reduced$consensus_genomic_structure =="Unknown" & dsDNA_tab_reduced$TPM_all>=1000& dsDNA_tab_reduced$pseudogenized ==0) ,])




col.names = c("dsDNA", 'ssRNA','dsRNA',"ssDNA",'Category','Type')
Summary_table_count<- read.table(text = "",
                                 col.names = col.names)

Summary_table_count$dsDNA<-as.character(Summary_table_count$dsDNA)
Summary_table_count$ssDNA<-as.character(Summary_table_count$ssDNA)
Summary_table_count$dsRNA<-as.character(Summary_table_count$dsRNA)
Summary_table_count$ssRNA<-as.character(Summary_table_count$ssRNA)
Summary_table_count$Category<-as.character(Summary_table_count$Category)
Summary_table_count$Type<-as.character(Summary_table_count$Type)



Summary_table_count<-Summary_table_count %>%
  summarise(dsDNA = as.character(EVEs_endo_dsDNA),
            ssDNA = as.character(EVEs_endo_ssDNA),
            dsRNA = as.character(EVEs_endo_dsRNA),
            ssRNA = as.character(EVEs_endo_ssRNA),
            Type="Endoparasitoid",
            Category="EVEs")%>%
  bind_rows(Summary_table_count)

Summary_table_count<-Summary_table_count %>%
  summarise(dsDNA = as.character(dEVEs_endo_dsDNA),
            ssDNA = as.character(dEVEs_endo_ssDNA),
            dsRNA = as.character(dEVEs_endo_dsRNA),
            ssRNA = as.character(dEVEs_endo_ssRNA),
            Type="Endoparasitoid",
            Category="dEVEs")%>%
  bind_rows(Summary_table_count)


Summary_table_count<-Summary_table_count %>%
  summarise(dsDNA = as.character(EVEs_ecto_dsDNA),
            ssDNA = as.character(EVEs_ecto_ssDNA),
            dsRNA = as.character(EVEs_ecto_dsRNA),
            ssRNA = as.character(EVEs_ecto_ssRNA),
            Type="Ectoparasitoid",
            Category="EVEs")%>%
  bind_rows(Summary_table_count)

Summary_table_count<-Summary_table_count %>%
  summarise(dsDNA = as.character(dEVEs_ecto_dsDNA),
            ssDNA = as.character(dEVEs_ecto_ssDNA),
            dsRNA = as.character(dEVEs_ecto_dsRNA),
            ssRNA = as.character(dEVEs_ecto_ssRNA),
            Type="Ectoparasitoid",
            Category="dEVEs")%>%
  bind_rows(Summary_table_count)

Summary_table_count<-Summary_table_count %>%
  summarise(dsDNA = as.character(EVEs_fl_dsDNA),
            ssDNA = as.character(EVEs_fl_ssDNA),
            dsRNA = as.character(EVEs_fl_dsRNA),
            ssRNA = as.character(EVEs_fl_ssRNA),
            Type="Free-living",
            Category="EVEs")%>%
  bind_rows(Summary_table_count)

Summary_table_count<-Summary_table_count %>%
  summarise(dsDNA = as.character(dEVEs_fl_dsDNA),
            ssDNA = as.character(dEVEs_fl_ssDNA),
            dsRNA = as.character(dEVEs_fl_dsRNA),
            ssRNA = as.character(dEVEs_fl_ssRNA),
            Type="Free-living",
            Category="dEVEs")%>%
  bind_rows(Summary_table_count)

Summary_table_count<-Summary_table_count %>%
  summarise(dsDNA = as.character(dEVEs_fl_dsDNA),
            ssDNA = as.character(dEVEs_fl_ssDNA),
            dsRNA = as.character(dEVEs_fl_dsRNA),
            ssRNA = as.character(dEVEs_fl_ssRNA),
            Type="Free-living",
            Category="dEVEs")%>%
  bind_rows(Summary_table_count)

tab <- as.data.frame(melt(setDT(Summary_table_count), id.vars = c("Category", "Type"), variable.name = "C"))

tab<-tab [order(tab $Category, decreasing = F),]  

tab$Category<- factor(tab$Category, levels = c("EVEs","dEVEs"))
tab$Type<- factor(tab$Type, levels = c("Endoparasitoid","Ectoparasitoid","Free-living"))

tab$Category <- as.factor(tab$Category)
tab$Type <- as.factor(tab$Type)
tab$C <- as.factor(tab$C)
tab$value <- as.integer(tab$value)
tab<-tab[!duplicated(tab), ]
colnames(tab)<-c("Category","Lifecycle","Genomic_structure","Nb_EVEs")


tab$Nb_EVEs2 <- as.numeric(tab$Nb_EVEs2 )

library(ggrepel)


tab$Nb_EVEs2<-round(tab$Nb_EVEs2,digits=1)
ggplot(tab, aes(x = Lifecycle, y = Nb_EVEs, fill = Category)) +
  facet_wrap( ~ Genomic_structure,nrow=1,strip.position = "bottom")+ 
  geom_col(data = . %>% filter( Category=="dEVEs" & Lifecycle =="Free-living"), position = position_dodge(width = 0.9), alpha = 1,fill="#467fb3",color="black") +
  geom_col(data = . %>% filter( Category=="EVEs"& Lifecycle =="Free-living"), position = position_dodge(width = 0.9), alpha = 0.4,fill="#467fb3",color="black") +
  geom_col(data = . %>% filter( Category=="dEVEs" & Lifecycle =="Endoparasitoid"), position = position_dodge(width = 0.9), alpha = 1,fill="#06642e",color="black") +
  geom_col(data = . %>% filter( Category=="EVEs"& Lifecycle =="Endoparasitoid"), position = position_dodge(width = 0.9), alpha = 0.4,fill="#06642e",color="black") +
  geom_col(data = . %>% filter( Category=="dEVEs" & Lifecycle =="Ectoparasitoid"), position = position_dodge(width = 0.9), alpha = 1,fill="#d8be03",color="black") +
  geom_col(data = . %>% filter( Category=="EVEs"& Lifecycle =="Ectoparasitoid"), position = position_dodge(width = 0.9), alpha = 0.4,fill="#d8be03",color="black") +
  geom_label_repel(aes(label = Nb_EVEs),position = position_stack(vjust = 0.5),size = 2.75,colour = 'black',fill="white")+
  theme_classic() +
  theme(strip.placement = "outside",
        strip.background = element_blank(),
        panel.spacing.y = unit(2, "lines"))+
  theme(axis.title.x=element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank()) + ylim(0, 1400) +  ylab("Number of viral endogenized elements")

      


####

#Event plot count 
col.names = c("dsDNA", 'ssRNA','dsRNA',"ssDNA",'Category','Type')
Summary_table_count_Event<- read.table(text = "",
                                       col.names = col.names)

Summary_table_count_Event$dsDNA<-as.character(Summary_table_count_Event$dsDNA)
Summary_table_count_Event$ssDNA<-as.character(Summary_table_count_Event$ssDNA)
Summary_table_count_Event$dsRNA<-as.character(Summary_table_count_Event$dsRNA)
Summary_table_count_Event$ssRNA<-as.character(Summary_table_count_Event$ssRNA)
Summary_table_count_Event$Category<-as.character(Summary_table_count_Event$Category)
Summary_table_count_Event$Type<-as.character(Summary_table_count_Event$Type)


Summary_table_count_Event<-Summary_table_count_Event %>%
  summarise(dsDNA = as.character(Nb_EVEs_dsDNA_fl_Event),
            ssDNA = as.character(Nb_EVEs_ssDNA_fl_Event),
            dsRNA = as.character(Nb_EVEs_dsRNA_fl_Event),
            ssRNA = as.character(Nb_EVEs_ssRNA_fl_Event),
            Type="Free-living",
            Category="EVEs")%>%
  bind_rows(Summary_table_count_Event)

Summary_table_count_Event<-Summary_table_count_Event %>%
  summarise(dsDNA = as.character(Nb_dEVEs_dsDNA_fl_Event),
            ssDNA = as.character(Nb_dEVEs_ssDNA_fl_Event),
            dsRNA = as.character(Nb_dEVEs_dsRNA_fl_Event),
            ssRNA = as.character(Nb_dEVEs_ssRNA_fl_Event),
            Type="Free-living",
            Category="dEVEs")%>%
  bind_rows(Summary_table_count_Event)


Summary_table_count_Event<-Summary_table_count_Event %>%
  summarise(dsDNA = as.character(Nb_EVEs_dsDNA_ecto_Event),
            ssDNA = as.character(Nb_EVEs_ssDNA_ecto_Event),
            dsRNA = as.character(Nb_EVEs_dsRNA_ecto_Event),
            ssRNA = as.character(Nb_EVEs_ssRNA_ecto_Event),
            Type="Ectoparasitoid",
            Category="EVEs")%>%
  bind_rows(Summary_table_count_Event)

Summary_table_count_Event<-Summary_table_count_Event %>%
  summarise(dsDNA = as.character(Nb_dEVEs_dsDNA_ecto_Event),
            ssDNA = as.character(Nb_dEVEs_ssDNA_ecto_Event),
            dsRNA = as.character(Nb_dEVEs_dsRNA_ecto_Event),
            ssRNA = as.character(Nb_dEVEs_ssRNA_ecto_Event),
            Type="Ectoparasitoid",
            Category="dEVEs")%>%
  bind_rows(Summary_table_count_Event)

Summary_table_count_Event<-Summary_table_count_Event %>%
  summarise(dsDNA = as.character(Nb_EVEs_dsDNA_endo_Event),
            ssDNA = as.character(Nb_EVEs_ssDNA_endo_Event),
            dsRNA = as.character(Nb_EVEs_dsRNA_endo_Event),
            ssRNA = as.character(Nb_EVEs_ssRNA_endo_Event),
            Type="Endoparasitoid",
            Category="EVEs")%>%
  bind_rows(Summary_table_count_Event)

Summary_table_count_Event<-Summary_table_count_Event %>%
  summarise(dsDNA = as.character(Nb_dEVEs_dsDNA_endo_Event),
            ssDNA = as.character(Nb_dEVEs_ssDNA_endo_Event),
            dsRNA = as.character(Nb_dEVEs_dsRNA_endo_Event),
            ssRNA = as.character(Nb_dEVEs_ssRNA_endo_Event),
            Type="Endoparasitoid",
            Category="dEVEs")%>%
  bind_rows(Summary_table_count_Event)

library(reshape2)
library(data.table)
tab <- as.data.frame(melt(setDT(Summary_table_count_Event), id.vars = c("Category", "Type"), variable.name = "C"))

tab<-tab [order(tab $Category, decreasing = F),]  

tab$Category<- factor(tab$Category, levels = c("EVEs","dEVEs"))
tab$Type<- factor(tab$Type, levels = c("Endoparasitoid","Ectoparasitoid","Free-living"))

tab$Category <- as.factor(tab$Category)
tab$Type <- as.factor(tab$Type)
tab$C <- as.factor(tab$C)
tab$value <- as.integer(tab$value)
tab<-tab[!duplicated(tab), ]
colnames(tab)<-c("Category","Lifecycle","Genomic_structure","Nb_EVEs")

tab$sumCat[tab$Genomic_structure =="ssDNA"] <- sum(tab$Nb_EVEs[tab$Genomic_structure =="ssDNA" & tab$Category=="EVEs"]) 
tab$sumCat[tab$Genomic_structure =="dsDNA"] <- sum(tab$Nb_EVEs[tab$Genomic_structure =="dsDNA" & tab$Category=="EVEs"]) 
tab$sumCat[tab$Genomic_structure =="ssRNA"] <- sum(tab$Nb_EVEs[tab$Genomic_structure =="ssRNA" & tab$Category=="EVEs"]) 
tab$sumCat[tab$Genomic_structure =="dsRNA"] <- sum(tab$Nb_EVEs[tab$Genomic_structure =="dsRNA" & tab$Category=="EVEs"]) 

tab$sumCat2[tab$Genomic_structure =="ssDNA"] <- sum(tab$Nb_EVEs[tab$Genomic_structure =="ssDNA" & tab$Category=="dEVEs"]) 
tab$sumCat2[tab$Genomic_structure =="dsDNA"] <- sum(tab$Nb_EVEs[tab$Genomic_structure =="dsDNA" & tab$Category=="dEVEs"]) 
tab$sumCat2[tab$Genomic_structure =="ssRNA"] <- sum(tab$Nb_EVEs[tab$Genomic_structure =="ssRNA" & tab$Category=="dEVEs"]) 
tab$sumCat2[tab$Genomic_structure =="dsRNA"] <- sum(tab$Nb_EVEs[tab$Genomic_structure =="dsRNA" & tab$Category=="dEVEs"]) 

tab$Nb_EVEs2 <- tab$Nb_EVEs*100/tab$sumCat
tab$Nb_dEVEs2 <- tab$Nb_EVEs*100/tab$sumCat2
tab$Expected[tab$Lifecycle=="Free-living"]<- (41/83)*100
tab$Expected[tab$Lifecycle=="Endoparasitoid"]<- (37/83)*100
tab$Expected[tab$Lifecycle=="Ectoparasitoid"]<- (5/83)*100

library(ggrepel)


subtab1 <- tab[tab$Category == "EVEs",]
EVEs_Events_representativity <- ggplot(subtab1 , aes(x = Lifecycle, y = Nb_EVEs2, fill = Category)) +
  facet_wrap( ~ Genomic_structure,nrow=1,strip.position = "top")+ 
  geom_col(data = . %>% filter( Category=="dEVEs" & Lifecycle =="Free-living"), position = position_dodge(width = 0.9), alpha = 1,fill='#467fb3',color="black") +
  geom_col(data = . %>% filter( Category=="EVEs"& Lifecycle =="Free-living"), position = position_dodge(width = 0.9), alpha = 1,fill='#467fb3',color="black") +
  geom_col(data = . %>% filter( Category=="dEVEs" & Lifecycle =="Endoparasitoid"), position = position_dodge(width = 0.9), alpha = 1,fill='#06642e',color="black") +
  geom_col(data = . %>% filter( Category=="EVEs"& Lifecycle =="Endoparasitoid"), position = position_dodge(width = 0.9), alpha = 1,fill='#06642e',color="black") +
  geom_col(data = . %>% filter( Category=="dEVEs" & Lifecycle =="Ectoparasitoid"), position = position_dodge(width = 0.9), alpha = 1,fill='#d8be03',color="black") +
  geom_col(data = . %>% filter( Category=="EVEs"& Lifecycle =="Ectoparasitoid"), position = position_dodge(width = 0.9), alpha = 1,fill='#d8be03',color="black") +
  geom_point(size = 1.5,aes(y=Expected, shape="Exposure",fill="black"),shape=3,stroke = 1)+
  #geom_label_repel(aes(label = Nb_EVEs),position = position_stack(vjust = 0.5),size = 2.75,colour = 'black',fill="white")+
  geom_text(aes(label = Nb_EVEs,y=3),vjust = 0.1, nudge_y = .2,color="white")+  
  ylab("EVEs %")+
  theme_minimal() +
  theme(
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    axis.line = element_line(),
    axis.ticks = element_line())+ 
  theme(strip.text.x = element_text(size = 13,face="bold"))+
  theme(strip.placement = "outside",
        strip.background = element_blank(),
        panel.spacing.y = unit(2, "lines"))+
  theme(axis.title.x=element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank())+ ylim(0, 100)+ theme(legend.position = "none")+
  scale_color_manual(values=c("#d8be03","#06642e","#467fb3"))



# Fisher test 


#EVEs
#dsDNA
(test1 <- fisher.test(  as.table(rbind(c(102, 12, 78),c((37/83)*sum(102, 12, 78),	(5/83)*sum(102, 12, 78),	(41/83)*sum(102, 12, 78))) )))
#ssDNA 
(test2 <- fisher.test(  as.table(rbind(c(3, 1, 3),c((37/83)*sum(3, 1, 3),	(5/83)*sum(3, 1, 3),	(41/83)*sum(3, 1, 3))) )))
#dsRNA
(test3 <- fisher.test(  as.table(rbind(c(48, 3, 37),c((37/83)*sum(48, 1, 37),	(5/83)*sum(48, 1, 37),	(41/83)*sum(48, 1, 37))) )))
#ssRNA 
(test4 <- fisher.test(  as.table(rbind(c(24, 1, 17),c((37/83)*sum(24, 1, 17),	(5/83)*sum(24, 1, 17),	(41/83)*sum(24, 1, 17))) )))

p.adjust(c(test1$p.value, test2$p.value, test3$p.value, test4$p.value), method = "BH", n = 8)


subtab2 <- tab[tab$Category == "dEVEs",]
dEVEs_Events_representativity <- ggplot(subtab2 , aes(x = Lifecycle, y = Nb_dEVEs2, fill = Category)) +
  facet_wrap( ~ Genomic_structure,nrow=1,strip.position = "top")+ 
  geom_col(data = . %>% filter( Category=="dEVEs" & Lifecycle =="Free-living"), position = position_dodge(width = 0.9), alpha = 1,fill='#467fb3',color="black") +
  geom_col(data = . %>% filter( Category=="EVEs"& Lifecycle =="Free-living"), position = position_dodge(width = 0.9), alpha = 0.4,fill='#467fb3',color="black") +
  geom_col(data = . %>% filter( Category=="dEVEs" & Lifecycle =="Endoparasitoid"), position = position_dodge(width = 0.9), alpha = 1,fill='#06642e',color="black") +
  geom_col(data = . %>% filter( Category=="EVEs"& Lifecycle =="Endoparasitoid"), position = position_dodge(width = 0.9), alpha = 0.4,fill='#06642e',color="black") +
  geom_col(data = . %>% filter( Category=="dEVEs" & Lifecycle =="Ectoparasitoid"), position = position_dodge(width = 0.9), alpha = 1,fill='#d8be03',color="black") +
  geom_col(data = . %>% filter( Category=="EVEs"& Lifecycle =="Ectoparasitoid"), position = position_dodge(width = 0.9), alpha = 0.4,fill='#d8be03',color="black") +
  geom_point(size = 1.5,aes(y=Expected, shape="Exposure",fill="black"),shape=3,stroke = 1)+
  #geom_label_repel(aes(label = Nb_EVEs),position = position_stack(vjust = 0.5),size = 2.75,colour = 'black',fill="white")+
  geom_text(aes(label = Nb_EVEs,y=2),vjust = 0.1, nudge_y = .2,color="white") + ylim(0, 100) +  
  ylab("dEVEs %")+
  theme_minimal() +
  theme(
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    axis.line = element_line(),
    axis.ticks = element_line())+ 
  theme(strip.text.x = element_text(size = 13,face="bold"))+
  theme(strip.placement = "outside",
        strip.background = element_blank(),
        panel.spacing.y = unit(2, "lines"))+
  theme(axis.title.x=element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank())+ theme(legend.position = "none")+
  scale_color_manual(values=c("#d8be03","#06642e","#467fb3"))

library(ggpubr)
library(cowplot)
plot_grid(EVEs_Events_representativity ,dEVEs_Events_representativity,ncol=2,nrow=1,labels=LETTERS[1:2],label_size = 16)

#####

col.names = c("dsDNA", 'ssRNA','dsRNA',"ssDNA",'Unclassified','Total','Type')
Summary_table<- read.table(text = "",
                           col.names = col.names)

Summary_table$dsDNA<-as.character(Summary_table$dsDNA)
Summary_table$ssDNA<-as.character(Summary_table$ssDNA)
Summary_table$dsRNA<-as.character(Summary_table$dsRNA)
Summary_table$ssRNA<-as.character(Summary_table$ssRNA)
Summary_table$Unclassified<-as.character(Summary_table$Unclassified)
Summary_table$Total<-as.character(Summary_table$Total)
Summary_table$Type<-as.character(Summary_table$Type)


#Events_dEVEs_dsDNA <- sum(Event_alone_df$Nb_dEVEs_dsDNA_Events,na.rm=T)+sum(Event_shared_df$Nb_dEVEs_dsDNA_Events,na.rm=T)
#Events_dEVEs_ssDNA <- sum(Event_alone_df$Nb_dEVEs_ssDNA_Events,na.rm=T)+sum(Event_shared_df$Nb_dEVEs_ssDNA_Events,na.rm=T)
#Events_dEVEs_dsRNA <- sum(Event_alone_df$Nb_dEVEs_dsRNA_Events,na.rm=T)+sum(Event_shared_df$Nb_dEVEs_dsRNA_Events,na.rm=T)
#Events_dEVEs_ssRNA <- sum(Event_alone_df$Nb_dEVEs_ssRNA_Events,na.rm=T)+sum(Event_shared_df$Nb_dEVEs_ssRNA_Events,na.rm=T)
Events_dEVEs_Unclassified <- sum(Event_alone_df$Nb_dEVEs_Unclassified_Events,na.rm=T)+sum(Event_shared_df$Nb_dEVEs_Unclassified_Events,na.rm=T)


Events_dEVEs_dsDNA <-length(unique(Env_table2$ID[Env_table2$consensus_genomic_structure=="dsDNA" & Env_table2$FDR_pvalue_dNdS == 1 & as.numeric(as.character(Env_table2$Mean_dNdS))+as.numeric(as.character(Env_table2$SE_dNdS)) < 1 & Env_table2$pseudogenized ==0 | Env_table2$consensus_genomic_structure=="dsDNA" &Env_table2$TPM_all>=1000 & Env_table2$pseudogenized ==0]))-1
Events_dEVEs_ssDNA <-length(unique(Env_table2$ID[Env_table2$consensus_genomic_structure=="ssDNA" & Env_table2$FDR_pvalue_dNdS == 1 & as.numeric(as.character(Env_table2$Mean_dNdS))+as.numeric(as.character(Env_table2$SE_dNdS)) < 1 & Env_table2$pseudogenized ==0 | Env_table2$consensus_genomic_structure=="ssDNA" &Env_table2$TPM_all>=1000 & Env_table2$pseudogenized ==0]))-1
Events_dEVEs_ssRNA <- length(unique(Env_table2$ID[Env_table2$consensus_genomic_structure=="ssRNA" & Env_table2$FDR_pvalue_dNdS == 1 & as.numeric(as.character(Env_table2$Mean_dNdS))+as.numeric(as.character(Env_table2$SE_dNdS)) < 1 & Env_table2$pseudogenized ==0 | Env_table2$consensus_genomic_structure=="ssRNA" &Env_table2$TPM_all>=1000 & Env_table2$pseudogenized ==0]))-1
Events_dEVEs_dsRNA <- length(unique(Env_table2$ID[Env_table2$consensus_genomic_structure=="dsRNA" & Env_table2$FDR_pvalue_dNdS == 1 & as.numeric(as.character(Env_table2$Mean_dNdS))+as.numeric(as.character(Env_table2$SE_dNdS)) < 1 & Env_table2$pseudogenized ==0 | Env_table2$consensus_genomic_structure=="dsRNA" &Env_table2$TPM_all>=1000 & Env_table2$pseudogenized ==0]))-1




#Add dEVEs Event count 
Summary_table<-Summary_table %>%
  summarise(dsDNA = paste0(Events_dEVEs_dsDNA,"(",Nb_dEVEs_dsDNA_fl_Event,",",Nb_dEVEs_dsDNA_endo_Event,",",Nb_dEVEs_dsDNA_ecto_Event,",",Nb_dEVEs_dsDNA_Unkn_Event,")"),
            ssDNA = paste0(Events_dEVEs_ssDNA,"(",Nb_dEVEs_ssDNA_fl_Event,",",Nb_dEVEs_ssDNA_endo_Event,",",Nb_dEVEs_ssDNA_ecto_Event,",",Nb_dEVEs_ssDNA_Unkn_Event,")"),
            dsRNA = paste0(Events_dEVEs_dsRNA,"(",Nb_dEVEs_dsRNA_fl_Event,",",Nb_dEVEs_dsRNA_endo_Event,",",Nb_dEVEs_dsRNA_ecto_Event,",",Nb_dEVEs_dsRNA_Unkn_Event,")"),
            ssRNA = paste0(Events_dEVEs_ssRNA,"(",Nb_dEVEs_ssRNA_fl_Event,",",Nb_dEVEs_ssRNA_endo_Event,",",Nb_dEVEs_ssRNA_ecto_Event,",",Nb_dEVEs_ssRNA_Unkn_Event,")"),
            Unclassified = paste0(Events_dEVEs_Unclassified,"(",Nb_dEVEs_Uncla_fl_Event,",",Nb_dEVEs_Uncla_endo_Event,",",Nb_dEVEs_Uncla_ecto_Event,",",Nb_dEVEs_Uncla_Unkn_Event,")"),
            Type="dEVEs_Events")%>%
  bind_rows(Summary_table)

#Add EVEs Event count 


Events_EVEs_ssDNA <-length(unique(Env_table2$ID[Env_table2$consensus_genomic_structure=="ssDNA" ]))-1
Events_EVEs_dsDNA <-length(unique(Env_table2$ID[Env_table2$consensus_genomic_structure=="dsDNA" ]))-1
Events_EVEs_ssRNA <-length(unique(Env_table2$ID[Env_table2$consensus_genomic_structure=="ssRNA" ]))-1
Events_EVEs_dsRNA <-length(unique(Env_table2$ID[Env_table2$consensus_genomic_structure=="dsRNA" ]))-1





Events_EVEs_Unclassified <- sum(Event_alone_df$Nb_EVEs_Unclassified_Events,na.rm=T)+sum(Event_shared_df$Nb_EVEs_Unclassified_Events,na.rm=T)

Summary_table<-Summary_table %>%
  summarise(dsDNA = paste0(Events_EVEs_dsDNA,"(",Nb_EVEs_dsDNA_fl_Event,",",Nb_EVEs_dsDNA_endo_Event,",",Nb_EVEs_dsDNA_ecto_Event,",",Nb_EVEs_dsDNA_Unkn_Event,")"),
            ssDNA = paste0(Events_EVEs_ssDNA,"(",Nb_EVEs_ssDNA_fl_Event,",",Nb_EVEs_ssDNA_endo_Event,",",Nb_EVEs_ssDNA_ecto_Event,",",Nb_EVEs_ssDNA_Unkn_Event,")"),
            dsRNA = paste0(Events_EVEs_dsRNA,"(",Nb_EVEs_dsRNA_fl_Event,",",Nb_EVEs_dsRNA_endo_Event,",",Nb_EVEs_dsRNA_ecto_Event,",",Nb_EVEs_dsRNA_Unkn_Event,")"),
            ssRNA = paste0(Events_EVEs_ssRNA,"(",Nb_EVEs_ssRNA_fl_Event,",",Nb_EVEs_ssRNA_endo_Event,",",Nb_EVEs_ssRNA_ecto_Event,",",Nb_EVEs_ssRNA_Unkn_Event,")"),
            Unclassified = paste0(Events_EVEs_Unclassified,"(",Nb_EVEs_Uncla_fl_Event,",",Nb_EVEs_Uncla_endo_Event,",",Nb_EVEs_Uncla_ecto_Event,",",Nb_EVEs_Uncla_Unkn_Event,")"),
            Type="EVEs_Events")%>%
  bind_rows(Summary_table)


##########


#Add dEVEs count


dsDNA_tab_reduced<- dsDNA_tab_reduced[!is.na(dsDNA_tab_reduced$Species_name),]


library(dplyr)


NB_dEVEs_dsDNA <- nrow(filter (dsDNA_tab_reduced, consensus_genomic_structure %in% c("dsDNA") &   Mean_dNdS < 1 & SE_dNdS < 1 & pseudogenized ==0 | consensus_genomic_structure %in% c("dsDNA") & TPM_all > 1000 ))
NB_dEVEs_ssDNA <- nrow(filter (dsDNA_tab_reduced, consensus_genomic_structure %in% c("ssDNA") &   Mean_dNdS < 1 & SE_dNdS < 1 & pseudogenized ==0 | consensus_genomic_structure %in% c("ssDNA") & TPM_all > 1000 ))
NB_dEVEs_dsRNA <- nrow(filter (dsDNA_tab_reduced, consensus_genomic_structure %in% c("dsRNA") &   Mean_dNdS < 1 & SE_dNdS < 1 & pseudogenized ==0 | consensus_genomic_structure %in% c("dsRNA") & TPM_all > 1000 ))
NB_dEVEs_ssRNA <- nrow(filter (dsDNA_tab_reduced, consensus_genomic_structure %in% c("ssRNA") &   Mean_dNdS < 1 & SE_dNdS < 1 & pseudogenized ==0 | consensus_genomic_structure %in% c("ssRNA") & TPM_all > 1000 ))
NB_dEVEs_Unknown<- nrow(filter (dsDNA_tab_reduced, consensus_genomic_structure %in% c("Unknown") &   Mean_dNdS < 1 & SE_dNdS < 1 & pseudogenized ==0 | consensus_genomic_structure %in% c("Unknown") & TPM_all > 1000 ))


Summary_table<-Summary_table %>%
  summarise(dsDNA = as.character(NB_dEVEs_dsDNA),
            ssDNA = as.character(NB_dEVEs_ssDNA),
            dsRNA = as.character(NB_dEVEs_dsRNA),
            ssRNA = as.character(NB_dEVEs_ssRNA),
            Unclassified = as.character(NB_dEVEs_Unknown),
            Type="dEVEs")%>%
  bind_rows(Summary_table)
#Add EVEs count


NB_EVEs_dsDNA <- nrow(filter (dsDNA_tab_reduced, consensus_genomic_structure %in% c("dsDNA") ))
NB_EVEs_ssDNA <- nrow(filter (dsDNA_tab_reduced, consensus_genomic_structure %in% c("ssDNA") ))
NB_EVEs_dsRNA <- nrow(filter (dsDNA_tab_reduced, consensus_genomic_structure %in% c("dsRNA") ))
NB_EVEs_ssRNA <- nrow(filter (dsDNA_tab_reduced, consensus_genomic_structure %in% c("ssRNA") ))
NB_EVEs_Unknown<- nrow(filter (dsDNA_tab_reduced, consensus_genomic_structure %in% c("Unknown")))


Summary_table<-Summary_table %>%
  summarise(dsDNA = as.character(NB_EVEs_dsDNA),
            ssDNA = as.character(NB_EVEs_ssDNA),
            dsRNA = as.character(NB_EVEs_dsRNA),
            ssRNA = as.character(NB_EVEs_ssRNA),
            Unclassified = as.character(NB_EVEs_Unknown),
            Type="EVEs")%>%
  bind_rows(Summary_table)
#Add total 
Summary_table$Total<-as.numeric(gsub("\\(.*","",Summary_table$dsDNA))+as.numeric(gsub("\\(.*","",Summary_table$ssDNA))+as.numeric(gsub("\\(.*","",Summary_table$dsRNA))+as.numeric(gsub("\\(.*","",Summary_table$ssRNA))+as.numeric(gsub("\\(.*","",Summary_table$Unclassified))



library(gridExtra)
pdf("/Users/bguinet/Desktop/Papier_scientifique/Table_count_summary_freeliving.pdf", height=11, width=10)
grid.table(Summary_table)
dev.off()

library(tidyverse)
library(ggrepel)
library(forcats)
library(dplyr)

###################
###Paper output ###
##################

Event_all_df <- rbind(Event_alone_df[c('Event')],Event_shared_df[c('Event')])
Event_all_df$ID <- seq.int(nrow(Event_all_df))
library(dplyr)
library(tidyr) # unnest, separate

Env_table2<-Env_table #[c("New_query_bis2","Clustername","target","Event","Boot","Species_name","pident","alnlen","evalue","bits","Scaffold_length_x","best_family_per_query","family","species","genomic_structure","Scaffold_score","Scaffold_score2","GC_content_scaffold","pvalue_gc","cov_depth_BUSCO","cov_depth_candidat","pvalue_cov","count_repeat","count_eucaryote","Number_viral_loci","Number_busco_loci","Gene.names","Protein.names","Gene.ontology..GO.","consensus_Protein_names","consensus_Gene_names","consensus_Domain_description","Gene.ontology..biological.process.","Gene.ontology..molecular.function.","Gene.ontology..cellular.component.","Gene.ontology.IDs","Pfam_acc","Hmmscan_evalue","Domain_description","Synteny_Windows","Synteny_Nb_HSPs","Synteny_Tot_alnlen","NSPtot","Nviraltot","Mean_dNdS","Pvalue_dNdS","SE_dNdS","FDR_pvalue_dNdS","pseudogenized","ORF_perc","len_ORF","start_ORF","end_ORF","perc_tlen_alnlen","sequence","Events_species","lifecycle1")]
length(unique(Env_table2[Env_table2$best_family_per_query =="Parvoviridae",]$query))

Env_table2$Event <- as.integer(Env_table2$Event)

Event_all_df<-Event_all_df %>%
  mutate(Event = strsplit(Event, "[ ,]+")) %>%
  unnest(Event) %>%
  separate(Event, into = c("Event", "Clustername")) %>%
  mutate(Event = as.integer(Event))

Env_table2<-merge(x = Event_all_df, y = Env_table2, by = c("Clustername","Event"), all = TRUE)

Env_table2<-Env_table2[!Env_table2$New_query_bis2 %in% list_query_remove_because_redundancy,]

Env_table2$Event <- as.character(Env_table2$Event)

Env_table2 <-Env_table2[c("New_query_bis2","consensus_Protein_names","consensus_Domain_description","Gene.ontology..GO.")]%>%
  #filter(!is.na(Protein.names)) %>%
  pivot_longer(cols = -New_query_bis2) %>%
  filter(!is.na(value) & value != "Uncharacterized protein") %>%
  group_by(New_query_bis2) %>%
  summarise(Consensus_function= first(value)) %>%
  ungroup() %>%
  right_join(Env_table2) %>%
  rowwise() %>%
  mutate(Consensus_function= replace(Consensus_function, is.na(Consensus_function), consensus_Protein_names)) %>%
  relocate(Consensus_function, .after = Gene.ontology..GO.) %>%
  arrange(New_query_bis2)

Env_table2 <-Env_table2 %>% 
  group_by(Clustername,Event) %>%
  slice(1) %>% 
  select(Clustername, Event, Consensus_function_Event = Consensus_function) %>% 
  right_join(Env_table2, by = c("Clustername", "Event")) %>% 
  relocate(Consensus_function_Event, .after = Consensus_function)

Env_table2<-Env_table2[!is.na(Env_table2$ID),]


#Set consensus family per ID Events 
Env_table2 <- Env_table2%>% 
  group_by(ID) %>%
  add_count(best_family_per_query) %>%
  top_n(1, n) %>%
  distinct(consensus_family_ID = best_family_per_query) %>%
  right_join(Env_table2)

#Change Porseoliae to Unknown 
Env_table2$Species_name[grepl("Unknown_species",Env_table2$New_query_bis2)]<-"Unknown_sp"

#Change Campopleginae 
Env_table2$family[grepl("Pichon",Env_table2$target) & Env_table2$Species_name =="Campopleginae" ] <- "IVSPERs"
Env_table2$best_family_per_query[grepl("Pichon",Env_table2$target) & Env_table2$Species_name =="Campopleginae" ] <- "IVSPERs"


Env_table2<-Env_table2[!duplicated(Env_table2[c("New_query_bis2","Event")]),]




##### Part3 create plots #####


######################################################
#Create histogram plots 

#dsDNA hitmap 
library("tidyverse")


Event_alone_df$Nb_EVEs_dsDNA[ grepl( "3_Cluster24469", Event_alone_df$Event)] <- 4

type1<-append(Event_alone_df$Nb_EVEs_dsDNA , Event_shared_df$Nb_EVEs_dsDNA)
type2<-append(Event_alone_df$Nb_dEVEs_dsDNA, Event_shared_df$Nb_dEVEs_dsDNA)
type2[type2>=1]<-1

list1<- list(EVEs = type1, dEVEs = type2)


grp <- factor(with(list1, fct_collapse(as.character(EVEs), 
                                       `>=5` = as.character(EVEs)[EVEs >=5])), levels = c(0:4, ">=5"))
v1 <- table(grp)
v2 <- tapply(list1$dEVEs, grp, FUN = sum)
dsDNA_hist_df<- bind_rows(list(EVEs = stack(v1)[2:1], dEVEs = stack(v2)[2:1]), .id = 'type') %>% 
  filter(ind != '0')

dsDNA_hist_df[dsDNA_hist_df==0] <- NA
dsDNA_hist <- ggplot(data = dsDNA_hist_df, 
                     aes(x = ind, y = values, fill = factor(type, levels = c("EVEs","dEVEs")))) + 
  geom_bar(width = 0.65,
           stat = 'identity',
           position = 'identity',color="black",size=0.2)+
  #geom_label_repel(aes(label = values),
  #position = position_stack(vjust = 0.5),
  #size = 2.75,
  # colour = 'white')
  ggtitle("dsDNA") +
  theme_minimal() +
  theme(
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    axis.line = element_line(),
    axis.ticks = element_line())+
  ylab("Number of Events") + xlab("Number of EVEs within Events")+
  scale_fill_manual(values = c("#FFD460","#F07B3F"))+ 
  theme(plot.title = element_text( face = "bold"))+ coord_cartesian(ylim=c(0,150))+
  theme(legend.title=element_blank()) +
  theme(
    axis.title.y = element_text(size = 17))+
  scale_y_continuous(breaks = scales::pretty_breaks(n = 20))+
  theme(axis.title.x=element_blank())

#dsRNA hitmap 
type1<-append(Event_alone_df$Nb_EVEs_dsRNA , Event_shared_df$Nb_EVEs_dsRNA)
type2<-append(Event_alone_df$Nb_dEVEs_dsRNA, Event_shared_df$Nb_dEVEs_dsRNA)
type2[type2>=1]<-1

list1<- list(EVEs = type1, dEVEs = type2)
grp <- factor(with(list1, fct_collapse(as.character(EVEs), 
                                       `>=5` = as.character(EVEs)[EVEs >=5])), levels = c(0:4, ">=5"))
v1 <- table(grp)
v2 <- tapply(list1$dEVEs, grp, FUN = sum)
dsRNA_hist_df<- bind_rows(list(EVEs = stack(v1)[2:1], dEVEs = stack(v2)[2:1]), .id = 'type') %>% 
  filter(ind != '0')

dsRNA_hist_df[dsRNA_hist_df==0] <- NA
dsRNA_hist <- ggplot(data = dsRNA_hist_df, 
                     aes(x = ind, y = values, fill = factor(type, levels = c("EVEs","dEVEs")))) + 
  geom_bar(width = 0.65,
           stat = 'identity',
           position = 'identity',color="black",size=0.2)+ #geom_label_repel(aes(label = values),
  #position = position_stack(vjust = 0.5),
  #size = 2.75,
  # colour = 'white')
  ggtitle("dsRNA") +
  theme_minimal() +
  theme(
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    axis.line = element_line(),
    axis.ticks = element_line())+
  ylab("Number of Events") + xlab("Number of EVEs within Events")+
  scale_fill_manual(values = c("#FFD460","#F07B3F"))+ 
  theme(plot.title = element_text( face = "bold"))+coord_cartesian(ylim=c(0,150))+
  theme(legend.title=element_blank())+theme(
    axis.title.y = element_blank())+
  scale_y_continuous(breaks = scales::pretty_breaks(n = 20))+
  theme(axis.title.x=element_blank())

#ssDNA hitmap 
type1<-append(Event_alone_df$Nb_EVEs_ssDNA , Event_shared_df$Nb_EVEs_ssDNA)
type2<-append(Event_alone_df$Nb_dEVEs_ssDNA, Event_shared_df$Nb_dEVEs_ssDNA)
type2[type2>=1]<-1

list1<- list(EVEs = type1, dEVEs = type2)
grp <- factor(with(list1, fct_collapse(as.character(EVEs), 
                                       `>=5` = as.character(EVEs)[EVEs >=5])), levels = c(0:4, ">=5"))
v1 <- table(grp)
v2 <- tapply(list1$dEVEs, grp, FUN = sum)
ssDNA_hist_df<- bind_rows(list(EVEs = stack(v1)[2:1], dEVEs = stack(v2)[2:1]), .id = 'type') %>% 
  filter(ind != '0')

ssDNA_hist_df[ssDNA_hist_df==0] <- NA
ssDNA_hist <- ggplot(data = ssDNA_hist_df, 
                     aes(x = ind, y = values, fill = factor(type, levels = c("EVEs","dEVEs")))) + 
  geom_bar(width = 0.65,
           stat = 'identity',
           position = 'identity',color="black",size=0.2)+ #geom_label_repel(aes(label = values),
  #position = position_stack(vjust = 0.5),
  #size = 2.75,
  # colour = 'white')
  ggtitle("ssDNA") +
  theme_minimal() +
  theme(
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    axis.line = element_line(),
    axis.ticks = element_line())+
  ylab("Number of Events") + xlab("Number of EVEs within Events")+
  scale_fill_manual(values = c("#FFD460","#F07B3F"))+
  theme(plot.title = element_text( face = "bold"))+ coord_cartesian(ylim=c(0,150))+
  theme(legend.title=element_blank())+theme(
    axis.title.y = element_blank())+
  scale_y_continuous(breaks = scales::pretty_breaks(n = 20))+
  theme(axis.title.x=element_blank())



#ssRNA hitmap 
type1<-append(Event_alone_df$Nb_EVEs_ssRNA , Event_shared_df$Nb_EVEs_ssRNA)
type2<-append(Event_alone_df$Nb_dEVEs_ssRNA, Event_shared_df$Nb_dEVEs_ssRNA)
type2[type2>=1]<-1

list1<- list(EVEs = type1, dEVEs = type2)
grp <- factor(with(list1, fct_collapse(as.character(EVEs), 
                                       `>=5` = as.character(EVEs)[EVEs >=5])), levels = c(0:4, ">=5"))
v1 <- table(grp)
v2 <- tapply(list1$dEVEs, grp, FUN = sum)
ssRNA_hist_df<- bind_rows(list(EVEs = stack(v1)[2:1], dEVEs = stack(v2)[2:1]), .id = 'type') %>% 
  filter(ind != '0')


ssRNA_hist_df[ssRNA_hist_df==0] <- NA
ssRNA_hist <- ggplot(data = ssRNA_hist_df, 
                     aes(x = ind, y = values, fill = factor(type, levels = c("EVEs","dEVEs")))) + 
  geom_bar(width = 0.65,
           stat = 'identity',
           position = 'identity',color="black",size=0.2)+ #geom_label_repel(aes(label = values),
  #position = position_stack(vjust = 0.5),
  #size = 2.75,
  # colour = 'white')
  ggtitle("ssRNA") +
  ylab("Number of Events") + xlab("Number of EVEs within Events")+ 
  theme_minimal() +
  theme(
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    axis.line = element_line(),
    axis.ticks = element_line())+
  scale_fill_manual(values = c("#FFD460","#F07B3F"))+ 
  theme(plot.title = element_text( face = "bold"))+ coord_cartesian(ylim=c(0,150))+
  theme(legend.title=element_blank()) +theme(
    axis.title.y = element_blank())+
  scale_y_continuous(breaks = scales::pretty_breaks(n = 20))+
  theme(axis.title.x=element_blank())



library(ggridges)
library(ggpubr)
library(MASS)
#test 

ssRNA_hist_df$structure<- "ssRNA"
dsRNA_hist_df$structure<- "dsRNA"
ssDNA_hist_df$structure<- "ssDNA"
dsDNA_hist_df$structure<- "dsDNA"
All_hist_df <- rbind(ssRNA_hist_df,dsRNA_hist_df,ssDNA_hist_df,dsDNA_hist_df)

All_hist_df$ind=factor(All_hist_df$ind,levels=c("1","2","3","4",">=5"))
All_hist_df$structure=factor(All_hist_df$structure,levels=c("dsDNA","ssDNA","dsRNA","ssRNA"))


ggplot(All_hist_df, aes(x = ind, y = values, fill = factor(type, levels = c("EVEs","dEVEs")))) +
  geom_bar(stat = 'identity', position = 'stack',color="black",size=0.2) +   facet_grid(~ structure) + 
  scale_fill_manual(values = c("#FFD460", "#F07B3F")) + 
  theme(panel.background = element_rect(fill = 'white'))+
  ylab("Numumber of Events") + xlab("Number of EVEs/dEVEs within Events") + theme(axis.text.y = element_text( color="black",size=10))+
  theme_minimal() +
  theme(
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    axis.line = element_line(),
    axis.ticks = element_line())+ 
  theme(text = element_text(size=17)) + theme(strip.text.x = element_text(size = 13,face="bold"))+ 
  theme(strip.text.y = element_text(size = 13,face="bold"))+
  theme(axis.title.x=element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank())


library(grid)
Nb_EVES_distribution_plot<-ggarrange(dsDNA_hist,ssDNA_hist,dsRNA_hist,ssRNA_hist,ncol=4, common.legend = TRUE, legend="right")
Nb_EVES_distribution_plot<-annotate_figure(Nb_EVES_distribution_plot,
                                           bottom = textGrob("Number of Endogenous Viral Elements (EVEs) and domesticated EVEs (dEVEs) within Events", gp = gpar(cex = 1.3)))

#dev.print(device = pdf, file = paste0("/Users/bguinet/Desktop/Papier_scientifique/Hist_EVEs_dEVEs_count.pdf"), width = 10,height=10)


### Create plot with EVEs Event distriubution within each genomic structurees 


#Create barplot with expected number to be found for each genomic structure categories


Nb_EVE_dsDNA=length(unique((Env_table2bis[Env_table2bis$genomic_structure=="dsDNA",]$New_query_bis2)))
Nb_EVE_ssDNA=length(unique((Env_table2bis[Env_table2bis$genomic_structure=="ssDNA",]$New_query_bis2)))
Nb_EVE_dsRNA=length(unique((Env_table2bis[Env_table2bis$genomic_structure=="dsRNA",]$New_query_bis2)))
Nb_EVE_ssRNA=length(unique((Env_table2bis[Env_table2bis$genomic_structure=="ssRNA",]$New_query_bis2)))

Nb_dEVE_dsDNA<-0
Nb_dEVE_ssDNA<-0
Nb_dEVE_dsRNA<-0
Nb_dEVE_ssRNA<-0

Events_EVEs_ssDNA <-length(unique(Env_table2$ID[Env_table2$consensus_genomic_structure=="ssDNA" ]))-1
Events_EVEs_dsDNA <-length(unique(Env_table2$ID[Env_table2$consensus_genomic_structure=="dsDNA" ]))-1
Events_EVEs_ssRNA <-length(unique(Env_table2$ID[Env_table2$consensus_genomic_structure=="ssRNA" ]))-1
Events_EVEs_dsRNA <-length(unique(Env_table2$ID[Env_table2$consensus_genomic_structure=="dsRNA" ]))-1

Events_dEVEs_ssDNA <-0
Events_dEVEs_dsDNA <-0
Events_dEVEs_ssRNA <-0
Events_dEVEs_dsRNA <-0

Genomic_structures <- c("dsDNA", "ssDNA", "dsRNA", "ssRNA","dsDNA", "ssDNA", "dsRNA", "ssRNA","dsDNA", "ssDNA", "dsRNA", "ssRNA","dsDNA", "ssDNA", "dsRNA", "ssRNA")
Type<-c("EVEs","EVEs","EVEs","EVEs","dEVEs","dEVEs","dEVEs","dEVEs","EVEs_Event","EVEs_Event","EVEs_Event","EVEs_Event","dEVEs_Event","dEVEs_Event","dEVEs_Event","dEVEs_Event")
value <- c(Nb_EVE_dsDNA,Nb_EVE_ssDNA,Nb_EVE_dsRNA,Nb_EVE_ssRNA,
           Nb_dEVE_dsDNA,Nb_dEVE_ssDNA,Nb_dEVE_dsRNA,Nb_dEVE_ssRNA,
           Events_EVEs_dsDNA,Events_EVEs_ssDNA,Events_EVEs_dsRNA,Events_EVEs_ssRNA,
           Events_dEVEs_dsDNA,Events_dEVEs_ssDNA,Events_dEVEs_dsRNA,Events_dEVEs_ssRNA)

ssRNA_perc <- 537*100/867
dsRNA_perc <- 67*100/867
dsDNA_perc <- 119*100/867
ssDNA_perc <- 61*100/867
Expected_NB<- c( ((sum(Nb_EVE_dsDNA,Nb_EVE_ssDNA,Nb_EVE_dsRNA,Nb_EVE_ssRNA)*dsDNA_perc)/100), 
                 ((sum(Nb_EVE_dsDNA,Nb_EVE_ssDNA,Nb_EVE_dsRNA,Nb_EVE_ssRNA)*ssDNA_perc)/100),
                 ((sum(Nb_EVE_dsDNA,Nb_EVE_ssDNA,Nb_EVE_dsRNA,Nb_EVE_ssRNA)*dsRNA_perc)/100),
                 ((sum(Nb_EVE_dsDNA,Nb_EVE_ssDNA,Nb_EVE_dsRNA,Nb_EVE_ssRNA)*ssRNA_perc)/100))
Expected_Events<- c( ((sum(Events_EVEs_dsDNA,Events_EVEs_ssDNA,Events_EVEs_dsRNA,Events_EVEs_ssRNA)*dsDNA_perc)/100), 
                     ((sum(Events_EVEs_dsDNA,Events_EVEs_ssDNA,Events_EVEs_dsRNA,Events_EVEs_ssRNA)*ssDNA_perc)/100),
                     ((sum(Events_EVEs_dsDNA,Events_EVEs_ssDNA,Events_EVEs_dsRNA,Events_EVEs_ssRNA)*dsRNA_perc)/100),
                     ((sum(Events_EVEs_dsDNA,Events_EVEs_ssDNA,Events_EVEs_dsRNA,Events_EVEs_ssRNA)*ssRNA_perc)/100))

Summary_table2 <- data.frame(Genomic_structures,Type,value,Expected_NB,Expected_Events)

Bar_plot_NB<-Summary_table2[!grepl("Event",Summary_table2$Type),] %>%
  ggplot( aes(y=value, x=factor(Genomic_structures , levels = c("dsDNA", "ssDNA", "dsRNA", "ssRNA")) ,fill=factor(Type, levels = c("dEVEs","EVEs")),label=Genomic_structures)) + 
  geom_bar(stat="identity",position = "identity",color="black",size=0.2)+
  geom_point(size = 1.5,aes(y=Expected_NB, shape="Exposure",fill="black",stroke = 1),shape=3)+
  scale_fill_manual(values = c("EVEs"="#FFD460","dEVEs"="#F07B3F"))+  theme_minimal() +
  theme(
    panel.grid.major.x  = element_blank(),
    panel.grid.minor.x = element_blank(),
    axis.line = element_line(),
    axis.ticks = element_line())+
  ylab("Number of EVEs") + xlab("Viral genomic structures") +
  theme(axis.text.y = element_text( color="black",size=9))+ 
  theme(legend.position = "none") +scale_y_continuous(breaks = scales::pretty_breaks(n = 10))+
  theme(
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    axis.line = element_line(),
    axis.ticks = element_line())+ 
  theme(text = element_text(size=17)) + theme(strip.text.x = element_text(size = 13,face="bold"))+
  theme(axis.text.y = element_text( color="black",size=10))+theme(axis.title.x = element_blank()) 

Bar_plot_EVENT<-Summary_table2[grepl("Event",Summary_table2$Type),] %>%
  ggplot( aes(y=value, x=factor(Genomic_structures , levels = c("dsDNA", "ssDNA", "dsRNA", "ssRNA")),fill=factor(Type, levels = c("dEVEs_Event","EVEs_Event")),label=Genomic_structures)) + 
  geom_bar(stat="identity",position = "identity",color="black",size=0.2)+
  geom_point(size = 1.5,aes(y=Expected_Events, shape="Exposure",fill="black",stroke = 1),shape=3)+
  scale_fill_manual(values = c("EVEs_Event"="#FFD460","dEVEs_Event"="#F07B3F"))+  theme_minimal() +
  theme(
    panel.grid.major.x  = element_blank(),
    panel.grid.minor.x = element_blank(),
    axis.line = element_line(),
    axis.ticks = element_line())+
  ylab("Number of Events") + xlab("Viral genomic structures") + 
  theme(axis.text.y = element_text( color="black",size=9))+
  theme(legend.position = "none") +scale_y_continuous(breaks = scales::pretty_breaks(n = 20))+
  theme(
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    axis.line = element_line(),
    axis.ticks = element_line())+ 
  theme(text = element_text(size=17)) + theme(strip.text.x = element_text(size = 13,face="bold"))+
  theme(axis.text.y = element_text( color="black",size=10))+theme(axis.title.x = element_blank()) 

library(ggpubr)
Bar_plot_EVENT_NB<-ggarrange(Bar_plot_NB,Bar_plot_EVENT,ncol=1)

####
library(forcats)
library(ggplot2)
library(ggtext)
library(ggnewscale)
#Get consensus Families dEVEs Event count 
Env_table2<-Env_table2[order(Env_table2$TPM_all, decreasing = TRUE),]  


Families_EVEs_event<- Env_table2[!duplicated(Env_table2[ c("ID")]),]

Families_EVEs_event<-Families_EVEs_event[!Families_EVEs_event$consensus_family_ID=="Unclassified",]


Families_dEVEs_event <- Families_EVEs_event[Families_EVEs_event$FDR_pvalue_dNdS == 1 & as.numeric(as.character(Families_EVEs_event$Mean_dNdS))+as.numeric(as.character(Families_EVEs_event$SE_dNdS)) < 1 & Families_EVEs_event$pseudogenized ==0 | Families_EVEs_event$TPM_all>=1000 & Families_EVEs_event$pseudogenized ==0,]

Families_EVEs_event<-as.data.frame(table(Families_EVEs_event$consensus_family_ID))

Families_dEVEs_event <-as.data.frame(table(Families_dEVEs_event$consensus_family_ID))
EVEs_dEVEs_table_family<-Families_EVEs_event
#Families_dEVEs_event<-Families_dEVEs_event %>% add_row(Var1 = "Unknown", Freq = 0)

#EVEs_dEVEs_table_family<-merge(x = Families_EVEs_event, y = Families_dEVEs_event, by = "Var1", all = TRUE)

EVEs_dEVEs_Familiescount<-reshape2::melt(EVEs_dEVEs_table_family , id=c("Var1"))

colnames(EVEs_dEVEs_Familiescount) <- c("family",'variable','value')

##Add genomic structure for coloring 
sub_fam_tab<-Env_table[!duplicated(Env_table$family),]
sub_fam_tab<-sub_fam_tab[c("family","genomic_structure")]



EVEs_dEVEs_Familiescount<-merge(sub_fam_tab,EVEs_dEVEs_Familiescount,by="family")
EVEs_dEVEs_Familiescount$genomic_structure[EVEs_dEVEs_Familiescount$family=="Unclassified_ssDNA"]<-"ssDNA"
EVEs_dEVEs_Familiescount$value[is.na(EVEs_dEVEs_Familiescount$value)] <- 0
EVEs_dEVEs_Familiescount$variable<-gsub("Freq.x","EVEs",EVEs_dEVEs_Familiescount$variable)
EVEs_dEVEs_Familiescount$variable<-gsub("Freq.y","dEVEs",EVEs_dEVEs_Familiescount$variable)

EVEs_dEVEs_Familiescount$genomic_structure[EVEs_dEVEs_Familiescount$best_family_per_query=="Partiti-Picobirna"]<-"dsRNA"
EVEs_dEVEs_Familiescount$genomic_structure[EVEs_dEVEs_Familiescount$best_family_per_query=="Luteo-Sobemo"]<-"ssRNA"

axis_color <- dplyr::distinct(EVEs_dEVEs_Familiescount, family, genomic_structure) %>% 
  tibble::deframe()

color_list<- c("EVEs"="#FFD460","dEVEs"="#F07B3F")

EVEs_dEVEs_Familiescount$genomic_structure <- factor(EVEs_dEVEs_Familiescount$genomic_structure,      # Reordering group factor levels
                                                     levels = c("dsDNA", "ssDNA", "dsRNA", "ssRNA"))


List_inset_viruses<-c("Polyomaviridae","Asfarviridae","Mypoviridae (-) ","Lispivirida (-) ","Phasmaviridae","Marseilleviridae","IVSPERs","Artoviridae (-) ","Circoviridae","Chuviridae (-) ","Xinmoviridae","Nyamiviridae","Marseivviridae","Chuviridae",
                      "Apis_filamentous-like","Astroviridae","Aspiviridae","Benyviridae","Hepeviridae","Alphatetraviridae","Togaviridae","Bastrovirus","Birnavirdae","Bunyavirales","Arenaviridae","Cystoviridae","Endornaviridae","Flaviviridae","Hypoviridae","Leviviridae","Mononegavirales","Jingchuvirales","Narnaviridae","Botourmiaviridae","Nidovirales","Partitiviridae",
                      "Cruciviridae","Amalgaviridae","Picobirnaviridae","Orthomyxoviridae","Permutotetraviridae","Potyviridae",
                      "Picornavirales","Solinviviridaes","Caliciviridae","Marnaviridae","Qinviridae","Solemoviridae","Luteoviridae",
                      "Alvernaviridae","Reoviridae","Tombusviridae","Nodaviridae","Sinaivirus","Carmotetraviridae","Luteoviridae","Totiviridae","Chrysoviridae","Megabirnaviridae","Quadriviridae","Botybirnavirus","Tymovirales","Virgaviridae","Togaviridae","Bromoviridae","Closteroviridae","Idaeovirus","Weivirus","LbFV_like","Nudiviridae","Bidnaviridae","Parvoviridae",
                      "Hytrosaviridae","Ascoviridae","Retroviridae","Nyamiviridae (-) ","Partitiviridae","Birnaviridae","Plasmaviridae","Rhabdoviridae","Dicistroviridae","Iflaviridae","Permutotetraviridae","Flaviviridae","Negevirus","Nodaviridae","Noravirus","Baculoviridae","Iridoviridae","AmFV-like","Poxviridae","Mesoviridae","Bunyaviridae","Mesoniviridae","Sarthroviridae",
                      "Solinviviridae","Peribunyaviridae","Phenuiviridae","Orthomyxoviridae (-) ","Peribunyaviridae (-) ","Phasmaviridae (-) ","Phenuiviridae (-) ","Qinviridae (-) ","Rhabdoviridae (-) ","Tombusviridae (+) ","Xinmoviridae (-) ","Luteo-Sobemo (+) ","Tombus-Noda (+) ","Abisko","Partiti-Picobirna","Mono-Chu (-) ","Narna-Levi (+) ","Bunya-Arena (-) ","Negevirus-like (+) ","Hepe-Virga (+) ","Bornaviridae (-) ","Tymoviridae (-) ","Abisko-like (+) ")



EVEs_dEVEs_Familiescount$family[EVEs_dEVEs_Familiescount$family=="Mono-Chu"] <- "Mono-Chu (-) "
EVEs_dEVEs_Familiescount$family[EVEs_dEVEs_Familiescount$family=="Artoviridae"] <- "Artoviridae (-) "
EVEs_dEVEs_Familiescount$family[EVEs_dEVEs_Familiescount$family=="Narna-Levi"] <- "Narna-Levi (+) "
EVEs_dEVEs_Familiescount$family[EVEs_dEVEs_Familiescount$family=="Picorna-Calici"] <- "Picorna-Calici (+) "
EVEs_dEVEs_Familiescount$family[EVEs_dEVEs_Familiescount$family=="Hepe-Virga"] <- "Hepe-Virga (+) "
EVEs_dEVEs_Familiescount$family[EVEs_dEVEs_Familiescount$family=="Tombus-Noda"] <- "Tombus-Noda (+) "
EVEs_dEVEs_Familiescount$family[EVEs_dEVEs_Familiescount$family=="Lispiviridae"] <- "Lispivirida (-) "
EVEs_dEVEs_Familiescount$family[EVEs_dEVEs_Familiescount$family=="Mypoviridae"] <- "Mypoviridae (-) "
EVEs_dEVEs_Familiescount$family[EVEs_dEVEs_Familiescount$family=="Nyamiviridae"] <- "Nyamiviridae (-) "
EVEs_dEVEs_Familiescount$family[EVEs_dEVEs_Familiescount$family=="Orthomyxoviridae"] <- "Orthomyxoviridae (-) "
EVEs_dEVEs_Familiescount$family[EVEs_dEVEs_Familiescount$family=="Bunya-Arena"] <- "Bunya-Arena (-) "
EVEs_dEVEs_Familiescount$family[EVEs_dEVEs_Familiescount$family=="Phasmaviridae"] <- "Phasmaviridae (-) "
EVEs_dEVEs_Familiescount$family[EVEs_dEVEs_Familiescount$family=="Phenuiviridae"] <- "Phenuiviridae (-) "
EVEs_dEVEs_Familiescount$family[EVEs_dEVEs_Familiescount$family=="Qinviridae"] <- "Qinviridae (-) "
EVEs_dEVEs_Familiescount$family[EVEs_dEVEs_Familiescount$family=="Rhabdoviridae"] <- "Rhabdoviridae (-) "
EVEs_dEVEs_Familiescount$family[EVEs_dEVEs_Familiescount$family=="Tombusviridae"] <- "Tombusviridae (+) "
EVEs_dEVEs_Familiescount$family[EVEs_dEVEs_Familiescount$family=="Xinmoviridae"] <- "Xinmoviridae (-) "
EVEs_dEVEs_Familiescount$family[EVEs_dEVEs_Familiescount$family=="Tymoviridae"] <- "Tymoviridae (+) "
EVEs_dEVEs_Familiescount$family[EVEs_dEVEs_Familiescount$family=="Bornaviridae"] <- "Bornaviridae (-) "
EVEs_dEVEs_Familiescount$family[EVEs_dEVEs_Familiescount$family=="Chuviridae"] <- "Chuviridae (-) "
EVEs_dEVEs_Familiescount$family[EVEs_dEVEs_Familiescount$family=="Luteo-Sobemo"] <- "Luteo-Sobemo (+) "
EVEs_dEVEs_Familiescount$family[EVEs_dEVEs_Familiescount$family=="Abisko-like"] <- "Abisko-like (+) "
EVEs_dEVEs_Familiescount$family[EVEs_dEVEs_Familiescount$family=="Peribunyaviridae"] <- "Peribunyaviridae (-) "
EVEs_dEVEs_Familiescount$family[EVEs_dEVEs_Familiescount$family=="Negevirus-like"] <- "Negevirus-like (+) "
EVEs_dEVEs_Familiescount$Insect <- ""
for (i in 1:nrow(EVEs_dEVEs_Familiescount)){
  if (EVEs_dEVEs_Familiescount$family[i] %in% List_inset_viruses){
    print(EVEs_dEVEs_Familiescount$family[i])
    EVEs_dEVEs_Familiescount$Insect[i] <- "*"
  }
}


EVEs_dEVEs_Familiescount$family<- paste0(EVEs_dEVEs_Familiescount$family,EVEs_dEVEs_Familiescount$Insect)


EVEs_dEVEs_Familiescount$value2 <- EVEs_dEVEs_Familiescount$value 
EVEs_dEVEs_Familiescount$value2[EVEs_dEVEs_Familiescount$variable=="dEVEs"]<-0
EVEs_dEVEs_Familiescount$family <- reorder(EVEs_dEVEs_Familiescount$family, EVEs_dEVEs_Familiescount$value2)


#Get percentage EVE identity of non-insect virus families 
mean(Env_table2[!duplicated(Env_table2[c('Clustername','Event')]),][Env_table2[!duplicated(Env_table2[c('Clustername','Event')]),]$family%in% c("Caulimoviridae","Nimaviridae" ,"Tymoviridae","Genomoviridae","Herpesviridae"  ,"Papillomaviridae","Phycodnaviridae") ,]$pident,na.rm=T)
min(Env_table2[!duplicated(Env_table2[c('Clustername','Event')]),][Env_table2[!duplicated(Env_table2[c('Clustername','Event')]),]$family %in% c("Caulimoviridae","Nimaviridae" ,"Tymoviridae","Genomoviridae","Herpesviridae"  ,"Papillomaviridae","Phycodnaviridae") ,]$pident,na.rm=T)
max(Env_table2[!duplicated(Env_table2[c('Clustername','Event')]),][Env_table2[!duplicated(Env_table2[c('Clustername','Event')]),]$family %in% c("Caulimoviridae","Nimaviridae" ,"Tymoviridae","Genomoviridae","Herpesviridae"  ,"Papillomaviridae","Phycodnaviridae") ,]$pident,na.rm=T)

#View(Env_table2[!duplicated(Env_table2[c('Clustername','Event')]),][Env_table2[!duplicated(Env_table2[c('Clustername','Event')]),]$best_family_per_query %in% c("Caulimoviridae","Nimaviridae" ,"Tymoviridae","Genomoviridae","Herpesviridae"  ,"Papillomaviridae","Phycodnaviridae") ,])

median(Env_table2[!duplicated(Env_table2[c('Clustername','Event')]),][Env_table2[!duplicated(Env_table2[c('Clustername','Event')]),]$family %in% c("Caulimoviridae","Nimaviridae" ,"Tymoviridae","Genomoviridae","Herpesviridae"  ,"Papillomaviridae","Phycodnaviridae"),]$evalue)
min(Env_table2[!duplicated(Env_table2[c('Clustername','Event')]),][Env_table2[!duplicated(Env_table2[c('Clustername','Event')]),]$family %in% c("Caulimoviridae","Nimaviridae" ,"Tymoviridae","Genomoviridae","Herpesviridae"  ,"Papillomaviridae","Phycodnaviridae"),]$evalue)
max(Env_table2[!duplicated(Env_table2[c('Clustername','Event')]),][Env_table2[!duplicated(Env_table2[c('Clustername','Event')]),]$family %in% c("Caulimoviridae","Nimaviridae" ,"Tymoviridae","Genomoviridae","Herpesviridae"  ,"Papillomaviridae","Phycodnaviridae"),]$evalue)


#Test different between families 

EVEs_dEVEs_Familiescount$genomic_structure[grepl("Tymo",EVEs_dEVEs_Familiescount$family)] <- "ssRNA"

Bar_plot_families<-ggplot(EVEs_dEVEs_Familiescount,aes(x = factor(family),y = value,fill=variable))+
  facet_grid(genomic_structure ~ . , scales="free_y",space="free") + 
  geom_bar(stat="identity",position = "identity",color="black",size=0.2)+
  geom_bar(data = EVEs_dEVEs_Familiescount[EVEs_dEVEs_Familiescount$variable=="dEVEs",], aes(y = value, x = family),
           stat = "identity", colour = "black",size=0.2)+
  scale_fill_manual(values = c("#FFD460"))+
  theme_bw() + 
  theme(axis.text.x=element_text(angle=0,hjust=0.5))+  coord_flip() +theme(
    panel.grid.major.y  = element_blank(),
    panel.grid.minor.y = element_blank(),
    axis.line = element_line(),
    axis.ticks = element_line())+
  theme(strip.text.y = element_text(size = 7,angle=0,face="bold"))+
  theme(axis.text.y = element_blank())+ ylab("Number of Events") + xlab("Viral families") + theme(axis.text.y = element_text( color="black",size=12))+
  theme(legend.position="none")+
  scale_y_continuous(breaks=seq(0,75,5)) +
  theme(axis.text.y = element_text(hjust=0.95))+
  theme(
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    axis.line = element_line(),
    axis.ticks = element_line())+ 
  theme(text = element_text(size=17)) + theme(strip.text.x = element_text(size = 13,face="bold"))+
  theme(axis.text.y = element_text(face = "italic"))


# Combine all plots 
library(cowplot)
ggarrange(
  ggarrange(Bar_plot_EVENT_NB,Bar_plot_families, ncol = 2, widths =c(1,2)),
  Nb_EVES_distribution_plot,nrow = 2, heights  =c(2,1))+
  draw_plot_label(label = c("A", "B","C", "D"), size = 15,
                  x = c(0, 0,0.35, 0), y = c(1, 0.69,1, 0.37))

