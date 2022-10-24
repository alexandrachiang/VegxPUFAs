#Compare our numbers with Michael's

#Load packages and set up wd
suppressMessages(library(plyr))
suppressMessages(library(dplyr))
suppressMessages(library(tidyverse))
#suppressMessages(library(ggpubr))
suppressMessages(library(ukbtools)) #<3
suppressMessages(library(rio))

#Load Michael's dataset
source('/scratch/ahc87874/Fall2022/pheno/load_UKBphenotables.R')
ukbnames <- read.csv("ukbnames.csv")

names(bd) <- ukbnames
ukb <- as_tibble(bd)

#--------------------------------------------------------------------------------------------------------------------------------------------------------
#CSRV

#Remove withdrawn participants from dataset
#Alex: Removes 114 | Michael:

#Remove participants that never answered 20086/never did a dietary survey
#Alex: 210967
#$first_instance
#    0     1     2     3     4
#70692 79599 27105 19639 13932
#Michael: 

#Get CSRV
#Alex: 
#NonVeg    Veg
#202724   8243 withdrawn, vegetarian and vegan
#Michael: 

#--------------------------------------------------------------------------------------------------------------------------------------------------------
#SSRV

#--------------------------------------------------------------------------------------------------------------------------------------------------------
#PhenoQC

#1. Genetic ethnicity = Caucasian VIA PAN UKBB
#Alex: 502413 | Michael:
#Alex: 448155 | Michael:

#Filter by Genetic ethnicity = Caucasian VIA PAN UKBB
#Alex: 426847 | Michael:

#2. Not an outlier for heterogeneity and missing genotype rate (poor quality genotype)
#Alex: 426399 | Michael:

#3. No Sex chromosome aneuploidy
#Alex: 425820 | Michael:

#4. Self-reported sex matches genetic sex
#Alex: 425649 | Michael:

#5. Do not have high degree of genetic kinship (Ten or more third-degree relatives identified)
#Alex: 425476 | Michael: 
               
#6. Does not appear in "maximum_set_of_unrelated_individuals.MF.pl"
#Alex: 356950 | Michael:

QCkeepparticipants <- bd_QC %>% select(IID)
            
#Alex: Start with 502527 participants | Michael:
#Alex: End with 356950 participants, removed 145577 | Michael:
