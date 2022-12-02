library(tidyverse)

phenoQC <- as_tibble(read.table("/scratch/ahc87874/Fall2022/pheno/CSRVSSRVwKeep.txt", sep = "\t", 
                                header = TRUE, stringsAsFactors = FALSE))
genoQC <- as_tibble(read.delim("/scratch/ahc87874/Fall2022/geno/chr22.sample"))

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
bothQC2 <- bothQC2 %>% mutate(hasGenoData = !is.na(hasGenoData))

covars2 <- c("Sex", "Age", "Townsend")
bothQC3 <- bothQC2[complete.cases(bothQC2[, covars2]), ] #210,702

bothQC4 <- bothQC3 %>% select(hasPCA, hasGenoData)
table(bothQC4, useNA = "always")
#       hasGenoData
#hasPCA   FALSE   TRUE
#  FALSE   4063      0
#  TRUE     428 206211

bothQC5 <- bothQC3 %>% filter(hasGenoData == TRUE) %>% select(CSRV, SSRV)

table(bothQC$CSRV, useNA = "always")
#NonVeg    Veg   <NA>
#202724   8243      0
table(bothQC$SSRV, useNA = "always")
#NonVeg    Veg   <NA>
#124526   3230  83211
table(bothQC5$CSRV, useNA = "always")
#NonVeg    Veg   <NA>
#198150   8061      0
table(bothQC5$SSRV, useNA = "always")
#NonVeg    Veg   <NA>
#121862   3172  81177

#Difference
#CSRV NonVeg = 4574
#CSRV Veg = 182
#SSRV NonVeg = 2664
#SSRV Veg = 58

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
#SSRV                 83211
#w3FA_NMR            161136
#w3FA_NMR_TFAP       161136
#w6FA_NMR            161136
#w6FA_NMR_TFAP       161136
#w6_w3_ratio_NMR     161136
#DHA_NMR             161136
#DHA_NMR_TFAP        161136
#LA_NMR              161136
#LA_NMR_TFAP         161136
#PUFA_NMR            161136
#PUFA_NMR_TFAP       161136
#MUFA_NMR            161136
#MUFA_NMR_TFAP       161136
#PUFA_MUFA_ratio_NMR 161136
#hasPCA                   0
#hasGenoData              0

cc <- c("IID", "Sex", "Age", "Townsend", "PC1", "w3FA_NMR")
bothQC6 <- bothQC2[complete.cases(bothQC2[, cc]), ] #49,528
#colSums(is.na(bothQC6)) %>% as.data.frame() #onlt SSRV should have NA

table(bothQC6$CSRV, useNA = "always")
#NonVeg    Veg   <NA>
# 47627   1901      0
table(bothQC6$SSRV, useNA = "always")
#NonVeg    Veg   <NA>
# 47627    769   1132

#Difference
#CSRV NonVeg = 155097
#CSRV Veg = 6342
#SSRV NonVeg = 95309
#SSRV Veg = 2475
