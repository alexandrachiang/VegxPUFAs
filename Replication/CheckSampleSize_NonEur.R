library(tidyverse)

pheno <- as_tibble(read.table("/scratch/ahc87874/Fall2022/pheno/CSRVSSRVwKeep.txt", sep = "\t", 
                                header = TRUE, stringsAsFactors = FALSE))
phenoQCgenoQC <- as_tibble(read.table("/scratch/ahc87874/Fall2022/geno/chr22.sample", 
                               header = TRUE, stringsAsFactors = FALSE))

pheno <- pheno %>% mutate(hasPCA = !is.na(genetic_principal_components_f22009_0_1))
phenoQCgenoQC <- phenoQCgenoQC %>% mutate(IID = ID_1, hasGenoData = TRUE) %>% select(IID, hasGenoData)

bothQC <- left_join(pheno, phenoQCgenoQC, by = "IID")

bothQC2 <- bothQC %>% select(FID, IID, 
                             sex_f31_0_0, age_when_attended_assessment_centre_f21003_0_0,
                             townsend_deprivation_index_at_recruitment_f189_0_0,
                             contains("genetic_principal_components_f22009_0_"), 
                             CSRV, SSRV, 
                             w3FA, w3FA_TFAP, w6FA, w6FA_TFAP, w6_w3_ratio, DHA, DHA_TFAP,
                             LA, LA_TFAP, PUFA, PUFA_TFAP, MUFA, MUFA_TFAP, PUFA_MUFA_ratio,
                             hasPCA, hasGenoData)

#Rename columns and change order
covars <- c("Sex", "Age", "Townsend", "PC1", "PC2", "PC3", "PC4", "PC5", "PC6", "PC7", "PC8", "PC9", "PC10")

names(bothQC2)[3:(2 + length(covars))] <- covars
bothQC2 <- bothQC2 %>% mutate(hasGenoData = !is.na(hasGenoData))

covars2 <- c("Sex", "Age", "Townsend")
bothQC3 <- bothQC2[complete.cases(bothQC2[, covars2]), ] #210,702

bothQC4 <- bothQC3 %>% select(hasPCA, hasGenoData)
table(bothQC4, useNA = "always")
#       hasGenoData
#hasPCA   FALSE   TRUE   <NA>
#  FALSE   4063      0      0
#  TRUE   51457 155182      0
#  <NA>       0      0      0

bothQC5 <- bothQC3 %>% filter(hasGenoData == TRUE) %>% select(CSRV, SSRV)

table(bothQC$CSRV, useNA = "always")
#NonVeg    Veg   <NA>
#202724   8243      0
table(bothQC$SSRV, useNA = "always")
#NonVeg    Veg   <NA>
#202724   3271   4972
table(bothQC5$CSRV, useNA = "always")
#NonVeg    Veg   <NA>
#149572   5610      0
table(bothQC5$SSRV, useNA = "always")
#NonVeg    Veg   <NA>
#149572   2369   3241

#Difference
#CSRV NonVeg = 53152
#CSRV Veg = 2633
#SSRV NonVeg = 53152
#SSRV Veg = 902

colSums(is.na(bothQC2)) %>% as.data.frame()
#FID                      0
#IID                      0
#Sex                      0
#Age                      0
#Townsend               265
#PC1                   4072
#PC2                   4072
#PC3                   4072
#PC4                   4072
#PC5                   4072
#PC6                   4072
#PC7                   4072
#PC8                   4072
#PC9                   4072
#PC10                  4072
#CSRV                     0
#SSRV                 4972
#w3FA                161136
#w3FA_TFAP           161136
#w6FA                161136
#w6FA_TFAP           161136
#w6_w3_ratio         161136
#DHA                 161136
#DHA_TFAP            161136
#LA                  161136
#LA_TFAP             161136
#PUFA                161136
#PUFA_TFAP           161136
#MUFA                161136
#MUFA_TFAP           161136
#PUFA_MUFA_ratio     161136
#hasPCA                   0
#hasGenoData              0

cc <- c("IID", "Sex", "Age", "Townsend", "PC1", "w3FA")
bothQC6 <- bothQC2[complete.cases(bothQC2[, cc]), ]
bothQC6 <- bothQC6 %>% filter(hasGenoData == TRUE) #37,106
#colSums(is.na(bothQC6)) %>% as.data.frame() #onlt SSRV should have NA

table(bothQC6$CSRV, useNA = "always")
#NonVeg    Veg   <NA>
# 35780   1326      0
table(bothQC6$SSRV, useNA = "always")
#NonVeg    Veg   <NA>
# 35780    568    758

#Difference
#CSRV NonVeg = 166944
#CSRV Veg = 6917
#SSRV NonVeg = 166944
#SSRV Veg = 2703
