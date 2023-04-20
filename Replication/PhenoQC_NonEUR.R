#Phenotype QC w/o Caucasians

#Load packages and set up wd
suppressMessages(library(plyr))
suppressMessages(library(dplyr))
suppressMessages(library(tidyverse))
#suppressMessages(library(ggpubr))
suppressMessages(library(ukbtools)) #<3
suppressMessages(library(rio))

setwd("/scratch/ahc87874/Fall2022/pheno")
#source('/scratch/ahc87874/Fall2022/pheno/load_UKBphenotables.R')

#Load dataset
ukb <- ukb_df("ukb34137")
#ukb <- import("ukb34137.tsv")
ukb <- as_tibble(ukb)

#setwd("/scratch/ahc87874/Fall2022/pheno/48364")
#ukbNMR <- as_tibble(ukb_df("ukb48364"))

ukbNMR <- as_tibble(read.table("/scratch/ahc87874/Fall2022/pheno/48364/ukb48364.tab",
                    header=TRUE, sep="\t"))

setwd("/scratch/ahc87874/Fall2022/pheno")

#--------------------------------------------------------------------------------------------------------------------------------------------------------
#Remove withdrawn participants from dataset
withdrawn <-read.csv("w48818_20220222.csv", header = FALSE)
ukb <- ukb[!(ukb$eid %in% withdrawn$V1), ] #502413

pan <- read_tsv("all_pops_non_eur_pruned_within_pop_pc_covs.tsv")
pan <- as_tibble(pan)
pan$s <- as.integer(pan$s)
table(pan$pop, useNA = "always")

bridge <- read.table("ukb48818bridge31063.txt")
bridge <- as_tibble(bridge)
colnames(bridge) <- c("IID", "panID")

pan2 <- pan %>% select(s, pop) %>% left_join(bridge, by = c("s" = "panID"))

#--------------------------------------------------------------------------------------------------------------------------------------------------------
#Pheno QC

#Generate a list of participants who pass the following QC criteria:
#1. Genetic ethnicity = Caucasian VIA PAN UKBB
#2. Not an outlier for heterogeneity and missing genotype rate (poor quality genotype)
#3. No Sex chromosome aneuploidy
#4. Self-reported sex matches genetic sex
#5. Do not have high degree of genetic kinship (Ten or more third-degree relatives identified)
#6. Does not appear in "maximum_set_of_unrelated_individuals.MF.pl"

#bd_QC<- bd %>% select(f.eid, f.31.0.0, f.22001.0.0, f.21000.0.0,
#                      f.22027.0.0, f.22019.0.0,
#                      f.22021.0.0)

bd_QC <- ukb %>% select(eid, sex_f31_0_0, genetic_sex_f22001_0_0, ethnic_background_f21000_0_0,
                        outliers_for_heterozygosity_or_missing_rate_f22027_0_0, sex_chromosome_aneuploidy_f22019_0_0,
                        genetic_kinship_to_other_participants_f22021_0_0)

colnames(bd_QC) <- c("IID", "Sex", "Genetic_Sex", "Race",
                     "Outliers_for_het_or_missing", "SexchrAneuploidy",
                     "Genetic_kinship")

#1. Genetic ethnicity = Caucasian VIA PAN UKBB
#Join UKB cols with with Pan UKBB
bd_QC <- as_tibble(bd_QC) #502413
bd_QC <- bd_QC %>% inner_join(pan2, by = "IID") #448155

#Filter by Genetic ethnicity != Caucasian VIA PAN UKBB
bd_QC <- bd_QC[bd_QC$pop != "EUR" & bd_QC$Race != "White" & bd_QC$Race != "Any other white background" & bd_QC$Race != "British", ] #20279

#2. Not an outlier for heterogeneity and missing genotype rate (poor quality genotype)
bd_QC <- bd_QC %>%
    filter(is.na(Outliers_for_het_or_missing) | Outliers_for_het_or_missing != "Yes") #426399 

#3. No Sex chromosome aneuploidy
bd_QC <- bd_QC %>%
    filter(is.na(SexchrAneuploidy) | SexchrAneuploidy != "Yes") #425820 

#4. Self-reported sex matches genetic sex
#If Sex does not equal genetic sex, exclude participant
bd_QC <- bd_QC[bd_QC$Sex == bd_QC$Genetic_Sex, ] #425649 

#5. Do not have high degree of genetic kinship (Ten or more third-degree relatives identified)
bd_QC <- bd_QC %>%
    filter(is.na(Genetic_kinship) |
               Genetic_kinship != "Ten or more third-degree relatives identified") #425476 
               
#6. Does not appear in "maximum_set_of_unrelated_individuals.MF.pl"
#Filter related file by those in QC
relatives <- read.table("ukb48818_rel_s488282.dat", header=T)

#From maximum_set_of_unrelated_individuals.MF.pl output:
max_unrelated <- read.table("ukb48818_rel_s488282_output.dat")
max_unrelated <- as.integer(unlist(max_unrelated))
bd_QC <- bd_QC %>% filter(!IID %in% max_unrelated) #356950

QCkeepparticipants <- bd_QC %>% mutate(FID = IID) %>% select(FID, IID)

write.table(QCkeepparticipants, file = "/scratch/ahc87874/Replication/phenoQC_NonEur.txt",
            row.names = FALSE, quote = FALSE)
            
#Start with 502527 participants
#End with 18,866 participants, removed 

#table(bd_QC$Race)
#       Prefer not to answer                Do not know
#                       271                         61
#                     White                      Mixed
#                         0                         13
#    Asian or Asian British     Black or Black British
#                        23                         18
#                   Chinese         Other ethnic group
#                      1434                       2421
#                   British                      Irish
#                         0                          1
#Any other white background  White and Black Caribbean
#                         0                        111
#   White and Black African            White and Asian
#                        80                        123
#Any other mixed background                     Indian
#                       286                       4962
#                 Pakistani                Bangladeshi
#                      1571                        193
#Any other Asian background                  Caribbean
#                      1317                       3479
#                   African Any other Black background
#                      2206                         76

