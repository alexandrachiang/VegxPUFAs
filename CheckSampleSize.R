library(tidyverse)

phenoQC <- as_tibble(read.table("/scratch/ahc87874/Fall2022/pheno/CSRVSSRV.txt", sep = "\t", 
                                header = TRUE, stringsAsFactors = FALSE))
genoQC <- as_tibble(read.delim("/scratch/ahc87874/Fall2022/pgen/chr22.psam"))

phenoQC <- phenoQC %>% mutate(hasPCA = !is.na(genetic_principal_components_f22009_0_1))
genoQC <- genoQC %>% mutate(hasGenoData = TRUE) %>% select(IID, hasGenoData)

bothQC <- left_join(phenoQC, genoQC, by = "IID")

bothQC2 <- bothQC %>% select(FID, IID, 
                             sex_f31_0_0, age_when_attended_assessment_centre_f21003_0_0,
                             townsend_deprivation_index_at_recruitment_f189_0_0,
                             contains("genetic_principal_components_f22009_0_"), 
                             CSRV, SSRV, 
                             w3FA_NMR, w3FA_NMR_TFAP, w6FA_NMR, w6FA_NMR_TFAP, w6_w3_ratio_NMR, DHA_NMR, DHA_NMR_TFAP,
                             LA_NMR, LA_NMR_TFAP, PUFA_NMR, PUFA_NMR_TFAP, MUFA_NMR, MUFA_NMR_TFAP, PUFA_MUFA_ratio_NMR,
                             hasPCA, hasGenoData)

#Rename columns and change order
covars <- c("Sex", "Age", "Townsend", "PC1", "PC2", "PC3", "PC4", "PC5", "PC6", "PC7", "PC8", "PC9", "PC10")

names(bothQC2)[3:(2 + length(covars))] <- covars

covars <- c("Sex", "Age", "Townsend")
bothQC3 <- bothQC2[complete.cases(bothQC2[, covars]), ] #210,702

bothQC4 <- bothQC3 %>% select(hasPCA, hasGenoData)
bothQC4 %>% mutate(hasGenoData = !is.na(hasGenoData)) %>% table()
#       hasGenoData
#hasPCA   FALSE   TRUE
#  FALSE   4063      0
#  TRUE     428 206211
