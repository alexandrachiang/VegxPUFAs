library(tidyverse)
library(rio)

veg <- as_tibble(read.table("/scratch/ahc87874/Fall2022/pheno/VegPheno.txt", sep = "\t", header = TRUE, stringsAsFactors = FALSE))
phenoQCgenoQC <- as_tibble(read.table("/scratch/ahc87874/Fall2022/geno/chr22.sample", header = TRUE, stringsAsFactors = FALSE))
withdrawn <- read.csv("/scratch/ahc87874/Fall2022/pheno/withdrawn.csv", header = FALSE)
veg <- veg[!(veg$IID %in% withdrawn$V1), ]
veg <- veg[, c(1:6, 16:25, 27:41)]

phase1 <- as_tibble(import("/scratch/ahc87874/Phase/pheno/phase1IIDs.csv")) # 117,920 rows
phase2 <- as_tibble(import("/scratch/ahc87874/Phase/pheno/phase2IIDs.csv")) # 156,205 rows
phasecomb <- as_tibble(import("/scratch/ahc87874/Phase/pheno/phasecombIIDs.csv")) # 274,121 rows

Alexphase1 <- veg %>% filter(veg$IID %in% phase1$IID) # 49,821 rows
Alexphase2 <- veg %>% filter(veg$IID %in% phase2$IID) # 63,882 rows
Alexphasecomb <- veg %>% filter(veg$IID %in% phasecomb$IID) # 113,702 rows

#complete for phenos
Alexphase1 %>% filter(!is.na(w3FA)) # 49,820 rows
Alexphase2 %>% filter(!is.na(w3FA)) # 63,882 rows
Alexphasecomb %>% filter(!is.na(w3FA)) # 113,702 rows

#complete for IIDs, covers, SSRV, and phenos
sum(complete.cases(Alexphase1)) # 48,451
sum(complete.cases(Alexphase2)) # 61,984
sum(complete.cases(Alexphasecomb)) # 110,435

#Post-GEM
# Phase 1 36391
# Phase 2 
# Combined 

Aryphase1 <- as_tibble(import("/scratch/ahc87874/Phase/Aryaman/oldCohortNorm.csv")) # 49,517 rows
Aryphase2 <- as_tibble(import("/scratch/ahc87874/Phase/Aryaman/newCohortNorm.csv")) # 63,351 rows
Aryphasecomb <- as_tibble(import("/scratch/ahc87874/Phase/Aryaman/combinedNorm.csv")) # 112,868 rows

Aryphase1$IID <- Aryphase1$FID
Aryphase2$IID <- Aryphase2$FID
Aryphasecomb$IID <- Aryphasecomb$FID

