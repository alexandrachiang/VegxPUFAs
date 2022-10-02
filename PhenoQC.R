#Load packages and set up wd
suppressMessages(library(plyr))
suppressMessages(library(dplyr))
suppressMessages(library(tidyverse))
#suppressMessages(library(ggpubr))
suppressMessages(library(ukbtools)) #<3
suppressMessages(library(rio))

setwd("/scratch/ahc87874/Fall2022")
#source('/scratch/ahc87874/Fall2022/load_UKBphenotables.R')

#Load dataset
ukb <- ukb_df("ukb34137")
#ukb <- import("ukb34137.tsv")
ukb <- as_tibble(ukb)

#Remove withdrawn participants from dataset
withdrawn <-read.csv("w48818_20210809.csv", header = FALSE)
ukb <- ukb[!(ukb$eid %in% withdrawn$V1), ] #Removes 34

#--------------------------------------------------------------------------------------------------------------------------------------------------------
#Pheno QC
