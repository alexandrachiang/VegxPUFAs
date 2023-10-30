#Subset necessary columns, change to numeric 

library(tidyverse)
library(fastDummies)

fishoil <- as_tibble(read.table("/scratch/ahc87874/FishOil/pheno/phenosfish.txt", sep = "\t", 
                                header = TRUE, stringsAsFactors = FALSE))
phase1 <- as_tibble(import("/scratch/ahc87874/Phase/pheno/phase1IIDs.csv"))
phase2 <- as_tibble(import("/scratch/ahc87874/Phase/pheno/phase2IIDs.csv"))

GEMpheno <- fishoil %>% select(FID, IID, 
                               sex_f31_0_0, age_when_attended_assessment_centre_f21003_0_0, agesex,                                 ,
                               contains("genetic_principal_components_f22009_0_"), 
                               Fish_oil_baseline, 
                               w3FA, w3FA_TFAP, w6FA, w6FA_TFAP, w6_w3_ratio, DHA, DHA_TFAP,
                               LA, LA_TFAP, PUFA, PUFA_TFAP, MUFA, MUFA_TFAP, PUFA_MUFA_ratio)

#Rename columns and change order
covars <- c("Sex", "Age", "AgeSex", "PC1", "PC2", "PC3", "PC4", "PC5", "PC6", "PC7", "PC8", "PC9", "PC10")
names(GEMpheno)[3:(2 + length(covars))] <- covars
  
#Change to numerical columns
GEMpheno2 <- GEMpheno
GEMpheno2$Sex <- as.character(GEMpheno2$Sex)
GEMpheno2$Sex <- replace(GEMpheno2$Sex, GEMpheno2$Sex == "Female", 0)
GEMpheno2$Sex <- replace(GEMpheno2$Sex, GEMpheno2$Sex == "Male", 1)
GEMpheno2$Sex <- as.numeric(GEMpheno2$Sex)

GEMpheno3 <- GEMpheno2
  #Remove if NA for covars
  #GEMpheno3 <- GEMpheno2[complete.cases(GEMpheno2[, covars]), ] #206,639

suffix <- "comb"
write.table(GEMpheno3, file = paste("/scratch/ahc87874/FishOil/pheno/GEMphenoFishOil", suffix, ".txt", sep = ""), sep = "\t", row.names = FALSE, quote = FALSE)
write.csv(GEMpheno3, file = paste("/scratch/ahc87874/FishOil/pheno/GEMphenoFishOil", suffix, ".csv", sep = ""), row.names = FALSE, quote = FALSE)

suffix <- "phase1"
GEMphenophase1 <- subset(GEMpheno3, (IID %in% phase1$IID))
write.table(GEMphenophase1, file = paste("/scratch/ahc87874/FishOil/pheno/GEMphenoFishOil", suffix, ".txt", sep = ""), sep = "\t", row.names = FALSE, quote = FALSE)
write.csv(GEMphenophase1, file = paste("/scratch/ahc87874/FishOil/pheno/GEMphenoFishOil", suffix, ".csv", sep = ""), row.names = FALSE, quote = FALSE)

suffix <- "phase2"
GEMphenophase2 <- subset(GEMpheno3, (IID %in% phase2$IID))
write.table(GEMphenophase1, file = paste("/scratch/ahc87874/FishOil/pheno/GEMphenoFishOil", suffix, ".txt", sep = ""), sep = "\t", row.names = FALSE, quote = FALSE)
write.csv(GEMphenophase1, file = paste("/scratch/ahc87874/FishOil/pheno/GEMphenoFishOil", suffix, ".csv", sep = ""), row.names = FALSE, quote = FALSE)
