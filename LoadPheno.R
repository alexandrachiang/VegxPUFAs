# Get counts for CSRV and SSRV for the initial and recall surveys
# CSRV = self-ID vegatarian, field 20086
# SSRV = true vegetarian, field 

suppressMessages(library(plyr))
suppressMessages(library(dplyr))
suppressMessages(library(tidyverse))
suppressMessages(library(ggpubr))
suppressMessages(library(RNOmni))

setwd("/scratch/ahc87874/Fall2022")

source('/scratch/ahc87874/Fall2022/load_UKBphenotables.R')
withdrawn<-read.csv("w48818_20210809.csv", header = FALSE)

pheno <- pheno[!(pheno$IID %in% withdrawn$V1), ]


pheno<-bd%>%select(f.eid, f.21003.0.0, f.31.0.0, 
                   f.189.0.0,
                   f.54.0.0, f.22000.0.0
                    )

colnames(pheno)<-c("IID", "Age", "Sex",  
                   "Townsend",
                   "Assessment_center", "Geno_batch"
                    )
