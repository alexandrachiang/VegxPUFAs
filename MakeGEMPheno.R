source("/work/kylab/alex/Fall2022/CountVegFirst.R")
library(fastDummies)

#Select necessary columns
GEMpheno <- ukbSSRV %>% select(FID, IID, 
                               sex_f31_0_0, age_when_attended_assessment_centre_f21003_0_0,
                               age_when_attended_assessment_centre_squared, genotype_measurement_batch_f22000_0_0, 
                               uk_biobank_assessment_centre_f54_0_0, townsend_deprivation_index_at_recruitment_f189_0_0,
                               contains("genetic_principal_components_f22009_0_"), treatment_medication_code_f20003_0,
                               body_mass_index_f21001_0_0, medication_combined_f6153_f6177_0_0, 
                               CSRV, SSRV, 
                               w3FA_NMR, w3FA_NMR_TFAP, w6FA_NMR, w6FA_NMR_TFAP, w6_w3_ratio_NMR, DHA_NMR, DHA_NMR_TFAP,
                               LA_NMR, LA_NMR_TFAP, PUFA_NMR, PUFA_NMR_TFAP, MUFA_NMR, MUFA_NMR_TFAP, PUFA_MUFA_ratio_NMR, 
                               w3FA_NMR_QCflag, w3FA_NMR_TFAP_QCflag, w6FA_NMR_QCflag, w6FA_NMR_TFAP_QCflag, 
                               w6_w3_ratio_NMR_QCflag, DHA_NMR_QCflag, DHA_NMR_TFAP_QCflag, LA_NMR_QCflag, 
                               LA_NMR_TFAP_QCflag, PUFA_NMR_QCflag, PUFA_NMR_TFAP_QCflag, MUFA_NMR_QCflag, 
                               MUFA_NMR_TFAP_QCflag, PUFA_MUFA_ratio_NMR_QCflag)

#Rename columns and change order
covars <- c("Sex", "Age", "Age2", "Geno_batch", "Center", "Townsend", "PC1", "PC2", "PC3", "PC4", "PC5", "PC6", "PC7", 
            "PC8", "PC9", "PC10", "Statins", "BMI", "Lipid_meds")
names(GEMpheno)[3:20] <- covars

#Remove if NA for covars
GEMpheno2 <- GEMpheno[complete.cases(GEMpheno[, covars]), ]

#Dummy columns for assessment center
GEMpheno3 <- dummy_cols(GEMpheno2, select_columns = "Center")
names(GEMpheno3)[51:71] <- paste("Center", c(1:14, 16:18, 20:23), sep = "")

GEMpheno3 <- GEMpheno3 %>% select(FID, IID, Sex, Age, Age2, Geno_batch, contains("Center"), everything()) %>% 
                           select(-Center)

#write.table(GEMpheno3, file = "/scratch/ahc87874/Fall2022/GEMpheno.txt",
#            row.names = FALSE, quote = FALSE)
