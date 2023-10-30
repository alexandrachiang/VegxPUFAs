#Load packages and set up wd
suppressMessages(library(plyr))
suppressMessages(library(dplyr))
suppressMessages(library(data.table))
suppressMessages(library(tidyverse))
suppressMessages(library(ukbtools)) #<3
suppressMessages(library(rio))

#Load dataset
setwd("/scratch/ahc87874/Phase/pheno/")

withdrawn <-read.csv("/scratch/ahc87874/Fall2022/pheno/w48818_2023-04-25.csv", header = FALSE)

phase1 <- as_tibble(read.table("/scratch/ahc87874/Fall2022/pheno/PUFAs.txt", header = TRUE))
phase1 <- phase1[!(phase1$IID %in% withdrawn$V1), ] 
phase1 <- phase1 %>% filter(!is.na(w3FA_NMR)) %>% select(IID)

setwd("/scratch/ahc87874/Fall2022/pheno/673621/")
phasecomb <- ukb_df("ukb673621", n_threads = "max", data.pos = 2)
phasecomb <- as_tibble(phasecomb)
phasecomb %>% select(eid, contains("f23444_0_0")) %>% head()

#phasecomb <- phasecomb %>% filter(!is.na(w3FA)) %>% select(eid)
#phasecomb <- phasecomb[!(phasecomb$eid %in% withdrawn$V1), ]
#names(phasecomb) <- "IID"
#phase2 <- subset(phasecomb, !(IID %in% phase1$IID))

#write.csv(phasecomb, file = "/scratch/ahc87874/Phase/pheno/phasecombIIDs.csv", row.names = FALSE, quote = FALSE)
