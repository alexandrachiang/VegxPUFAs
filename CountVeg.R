# Get counts for CSRV and SSRV for the initial and recall surveys
# CSRV = self-ID vegatarian, field 20086
# SSRV = true vegetarian, field 

# SpecialDiet<-bd%>%select(f.eid, f.20086.0.0, f.20086.1.0, f.20086.2.0, f.20086.3.0, f.20086.4.0)
# Remove withdrawn at the end

suppressMessages(library(plyr))
suppressMessages(library(dplyr))
suppressMessages(library(tidyverse))
suppressMessages(library(ggpubr))
suppressMessages(library(ukbtools))
suppressMessages(library(rio))

setwd("/scratch/ahc87874/Fall2022")

#source('/scratch/ahc87874/Fall2022/load_UKBphenotables.R')

ukb <- ukb_df("ukb34137")
ukb <- as_tibble(ukb)

withdrawn <-read.csv("w48818_20210809.csv", header = FALSE)

#Get all participants that self-IDed as vegetarian/vegan at least once in the recall surveys
ukbveg <- ukb %>% filter(if_any(starts_with("f.20086."), ~ . %in% c("Vegetarian", "Vegan")))


pheno <- pheno[!(pheno$IID %in% withdrawn$V1), ]
