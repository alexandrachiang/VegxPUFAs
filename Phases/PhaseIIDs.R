#Load packages and set up wd
suppressMessages(library(plyr))
suppressMessages(library(dplyr))
suppressMessages(library(data.table))
suppressMessages(library(tidyverse))
suppressMessages(library(ukbtools)) #<3
suppressMessages(library(rio))

#Load dataset
setwd("/scratch/ahc87874/Phase/pheno/")

withdrawn <-read.csv("/scratch/ahc87874/Fall2022/pheno/withdrawn.csv", header = FALSE)

phase1 <- as_tibble(read.table("/scratch/ahc87874/Fall2022/pheno/PUFAs.txt", header = TRUE))
#phase1 <- phase1[!(phase1$IID %in% withdrawn$V1), ] 
phase1 <- phase1 %>% filter(!is.na(w3FA_NMR)) %>% select(IID)

setwd("/scratch/ahc87874/Fall2022/pheno/673621/")
ukb673621 <- ukb_df("ukb673621", n_threads = "max", data.pos = 2)
phasecomb <- as_tibble(ukb673621)
phasecomb <- phasecomb %>% filter(!is.na(omega3_fatty_acids_f23444_0_0)) %>% select(eid)
names(phasecomb) <- "IID"
phasecomb <- phasecomb[!(phasecomb$IID %in% withdrawn$V1), ]

phase2 <- subset(phasecomb, !(IID %in% phase1$IID))
phase1 <- subset(phase1, (IID %in% phasecomb$IID)) #Remove 4 people that no longer have NMR data

phasecomb <- phasecomb[!(phasecomb$IID %in% withdrawn$V1), ]
phase1 <- phase1[!(phase1$IID %in% withdrawn$V1), ]
phase2 <- phase2[!(phase2$IID %in% withdrawn$V1), ]

print(paste("phase1:", nrow(phase1))) #117926
print(paste("phase2:", nrow(phase2))) #156205
print(paste("phasecomb:", nrow(phasecomb))) #274121

write.csv(phase1, file = "/scratch/ahc87874/Phase/pheno/phase1IIDs.csv", row.names = FALSE, quote = FALSE)
write.csv(phase2, file = "/scratch/ahc87874/Phase/pheno/phase2IIDs.csv", row.names = FALSE, quote = FALSE)
write.csv(phasecomb, file = "/scratch/ahc87874/Phase/pheno/phasecombIIDs.csv", row.names = FALSE, quote = FALSE)
