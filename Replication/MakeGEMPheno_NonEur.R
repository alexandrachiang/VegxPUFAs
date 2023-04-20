#Subset necessary columns, change to numeric 

library(tidyverse)
library(fastDummies)
#source("/work/kylab/alex/Fall2022/CountVegFirst.R")

ukbSSRV <- as_tibble(read.table(paste("/scratch/ahc87874/Fall2022/pheno/CSRVSSRVwKeep.txt", sep = ""), sep = "\t", 
                                header = TRUE, stringsAsFactors = FALSE))

  GEMpheno <- ukbSSRV %>% select(FID, IID, 
                                 sex_f31_0_0, age_when_attended_assessment_centre_f21003_0_0,
                                 townsend_deprivation_index_at_recruitment_f189_0_0,
                                 contains("genetic_principal_components_f22009_0_"), 
                                 CSRV, SSRV, 
                                 w3FA, w3FA_TFAP, w6FA, w6FA_TFAP, w6_w3_ratio, DHA, DHA_TFAP,
                                 LA, LA_TFAP, PUFA, PUFA_TFAP, MUFA, MUFA_TFAP, PUFA_MUFA_ratio)

  #Rename columns and change order
  covars <- c("Sex", "Age", "Townsend", "PC1", "PC2", "PC3", "PC4", "PC5", "PC6", "PC7", "PC8", "PC9", "PC10")

  names(GEMpheno)[3:(2 + length(covars))] <- covars
  
  #Change to numerical columns
  GEMpheno2 <- GEMpheno
  GEMpheno2$Sex <- as.character(GEMpheno2$Sex)
  GEMpheno2$Sex <- replace(GEMpheno2$Sex, GEMpheno2$Sex == "Female", 0)
  GEMpheno2$Sex <- replace(GEMpheno2$Sex, GEMpheno2$Sex == "Male", 1)
  GEMpheno2$Sex <- as.numeric(GEMpheno2$Sex)
  GEMpheno2$CSRV <- replace(GEMpheno2$CSRV, GEMpheno2$CSRV == "NonVeg", 0)
  GEMpheno2$CSRV <- replace(GEMpheno2$CSRV, GEMpheno2$CSRV == "Veg", 1)
  GEMpheno2$CSRV <- as.numeric(GEMpheno2$CSRV)
  GEMpheno2$SSRV <- replace(GEMpheno2$SSRV, GEMpheno2$SSRV == "NonVeg", 0)
  GEMpheno2$SSRV <- replace(GEMpheno2$SSRV, GEMpheno2$SSRV == "Veg", 1)
  GEMpheno2$SSRV <- as.numeric(GEMpheno2$SSRV)

  GEMpheno3 <- GEMpheno2
  #Remove if NA for covars
  #GEMpheno3 <- GEMpheno2[complete.cases(GEMpheno2[, covars]), ] #206,639

write.table(GEMpheno3, file = paste("/scratch/ahc87874/Replication/GEMpheno.txt", sep = ""), sep = "\t", row.names = FALSE, quote = FALSE)

write.csv(GEMpheno3, file = paste("/scratch/ahc87874/Replication/GEMpheno.csv", sep = ""), row.names = FALSE, quote = FALSE)
