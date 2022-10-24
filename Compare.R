#Compare our numbers with Michael's

#Load packages and set up wd
suppressMessages(library(plyr))
suppressMessages(library(dplyr))
suppressMessages(library(tidyverse))
#suppressMessages(library(ggpubr))
suppressMessages(library(ukbtools)) #<3
suppressMessages(library(rio))

setwd("/scratch/ahc87874/Fall2022/pheno")

#Load Michael's dataset
source('/scratch/ahc87874/Fall2022/pheno/load_UKBphenotables.R')
ukb <- as_tibble(bd)

ukbnames <- read.csv("ukbnames.csv")
names(ukb) <- ukbnames$value

#--------------------------------------------------------------------------------------------------------------------------------------------------------
#Load in UKB data with load_UKBphenotables.R, rename columns with ukbnames.csv from ukbtools, 
#run my Veg and PhenoQC scripts = same numbers

#--------------------------------------------------------------------------------------------------------------------------------------------------------
#Load in UKB data with load_UKBphenotables.R, run Michael's Veg and PhenoQC scripts
