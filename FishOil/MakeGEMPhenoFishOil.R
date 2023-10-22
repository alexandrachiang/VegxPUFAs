#Subset necessary columns, change to numeric 

library(tidyverse)
library(fastDummies)

fishoil <- as_tibble(read.table("/scratch/ahc87874/FishOil/pheno/phenosfish.txt", sep = "\t", 
                                header = TRUE, stringsAsFactors = FALSE))

if (FALSE) { #Covars we arent using
  #Select necessary columns
  GEMpheno <- fishoil %>% select(FID, IID, 
                                 sex_f31_0_0, age_when_attended_assessment_centre_f21003_0_0,
                                 age_when_attended_assessment_centre_squared, genotype_measurement_batch_f22000_0_0, 
                                 uk_biobank_assessment_centre_f54_0_0, townsend_deprivation_index_at_recruitment_f189_0_0,
                                 contains("genetic_principal_components_f22009_0_"), treatment_medication_code_f20003_0,
                                 body_mass_index_f21001_0_0, medication_combined_f6153_f6177_0_0, 
                                 CSRV, SSRV, 
                                 w3FA, w3FA_TFAP, w6FA, w6FA_TFAP, w6_w3_ratio, DHA, DHA_TFAP,
                                 LA, LA_TFAP, PUFA, PUFA_TFAP, MUFA, MUFA_TFAP, PUFA_MUFA_ratio, 
                                 w3FA_QCflag, w3FA_TFAP_QCflag, w6FA_QCflag, w6FA_TFAP_QCflag, 
                                 w6_w3_ratio_QCflag, DHA_QCflag, DHA_TFAP_QCflag, LA_QCflag, 
                                 LA_TFAP_QCflag, PUFA_QCflag, PUFA_TFAP_QCflag, MUFA_QCflag, 
                                 MUFA_TFAP_QCflag, PUFA_MUFA_ratio_QCflag)

  #Rename columns and change order
  covars <- c("Sex", "Age", "Age2", "Geno_batch", "Center", "Townsend", "PC1", "PC2", "PC3", "PC4", "PC5", "PC6", "PC7", 
              "PC8", "PC9", "PC10", "Statins", "BMI", "Lipid_meds")

  names(GEMpheno)[3:(2 + length(covars))] <- covars

  #Remove if NA for covars
  GEMpheno2 <- GEMpheno[complete.cases(GEMpheno[, covars]), ]

  #Dummy columns for assessment center
  GEMpheno3 <- dummy_cols(GEMpheno2, select_columns = "Center")
  names(GEMpheno3)[(ncol(GEMpheno3) - 20):ncol(GEMpheno3)] <- paste("Center", c(1:14, 16:18, 20:23), sep = "")

  GEMpheno3 <- GEMpheno3 %>% select(FID, IID, Sex, Age, Age2, Geno_batch, contains("Center"), everything()) %>% 
                             select(-Center)
 
} else {
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
}
suffix <- "FishOil"
write.table(GEMpheno3, file = paste("/scratch/ahc87874/FishOil/pheno/GEMpheno", suffix, ".txt", sep = ""), sep = "\t", row.names = FALSE, quote = FALSE)

write.csv(GEMpheno3, file = paste("/scratch/ahc87874/FishOil/pheno/GEMpheno", suffix, ".csv", sep = ""), row.names = FALSE, quote = FALSE)
