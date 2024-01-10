library(tidyverse)
library(rio)

veg <- as_tibble(read.table("/scratch/ahc87874/Fall2022/pheno/VegPheno.txt", sep = "\t", header = TRUE, stringsAsFactors = FALSE))
phenoQCgenoQC <- as_tibble(read.table("/scratch/ahc87874/Fall2022/geno/chr22.sample", header = TRUE, stringsAsFactors = FALSE))
withdrawn <- read.csv("/scratch/ahc87874/Fall2022/pheno/withdrawn.csv", header = FALSE)
veg <- veg[!(veg$IID %in% withdrawn$V1), ]

phase1 <- as_tibble(import("/scratch/ahc87874/Phase/pheno/phase1IIDs.csv")) # 117,916 rows
phase2 <- as_tibble(import("/scratch/ahc87874/Phase/pheno/phase2IIDs.csv")) # 156,205 rows
phasecomb <- as_tibble(import("/scratch/ahc87874/Phase/pheno/phasecombIIDs.csv")) # 274,121 rows

Alexphase1 <- veg %>% filter(veg$IID %in% phase1$IID) # 49,820 rows
Alexphase2 <- veg %>% filter(veg$IID %in% phase2$IID) # 63,882 rows
Alexphasecomb <- veg %>% filter(veg$IID %in% phasecomb$IID) # 113,702 rows

Aryphase1 <- as_tibble(import("/scratch/ahc87874/Phase/Aryaman/oldCohortNorm.csv")) # 49,517 rows
Aryphase2 <- as_tibble(import("/scratch/ahc87874/Phase/Aryaman/newCohortNorm.csv")) # 63,351 rows
Aryphasecomb <- as_tibble(import("/scratch/ahc87874/Phase/Aryaman/combinedNorm.csv")) # 112,868 rows

Aryphase1$IID <- Aryphase1$FID
Aryphase2$IID <- Aryphase2$FID
Aryphasecomb$IID <- Aryphasecomb$FID

test <- Alexphasecomb %>% filter(!Alexphasecomb$IID %in% Aryphasecomb$IID) # 834 rows
Aryphasecomb %>% filter(!Aryphasecomb$IID %in% Alexphasecomb$IID) # 0 rows

for (i in 1:ncol(test)) {
  print(test[1:10, i])
}
