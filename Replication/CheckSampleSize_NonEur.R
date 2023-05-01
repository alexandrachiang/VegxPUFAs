library(tidyverse)

pheno <- as_tibble(read.table("/scratch/ahc87874/Fall2022/pheno/CSRVSSRVwKeep.txt", sep = "\t", 
                                header = TRUE, stringsAsFactors = FALSE))
phenoQCgenoQC <- as_tibble(read.table("/scratch/ahc87874/Replication/geno/chr22.sample", 
                               header = TRUE, stringsAsFactors = FALSE))

pheno <- pheno %>% mutate(hasPCA = !is.na(genetic_principal_components_f22009_0_1))
phenoQCgenoQC <- phenoQCgenoQC %>% mutate(IID = ID_1, hasGenoData = TRUE) %>% select(IID, hasGenoData)

bothQC <- left_join(pheno, phenoQCgenoQC, by = "IID")

pan <- read_tsv("/scratch/ahc87874/Fall2022/pheno/all_pops_non_eur_pruned_within_pop_pc_covs.tsv")
pan <- as_tibble(pan)
pan$s <- as.integer(pan$s)
bridge <- read.table("/scratch/ahc87874/Fall2022/pheno/ukb48818bridge31063.txt")
bridge <- as_tibble(bridge)
colnames(bridge) <- c("IID", "panID")
pan2 <- pan %>% select(s, pop) %>% left_join(bridge, by = c("s" = "panID"))
bothQC <- left_join(bothQC, pan2, by = "IID")

bothQC2 <- bothQC %>% select(FID, IID,
                             sex_f31_0_0, age_when_attended_assessment_centre_f21003_0_0,
                             townsend_deprivation_index_at_recruitment_f189_0_0,
                             contains("genetic_principal_components_f22009_0_"), 
                             CSRV, SSRV, 
                             w3FA_NMR, w3FA_NMR_TFAP, w6FA_NMR, w6FA_NMR_TFAP, w6_w3_ratio_NMR, 
                             DHA_NMR, DHA_NMR_TFAP, LA_NMR, LA_NMR_TFAP, PUFA_NMR, PUFA_NMR_TFAP, 
                             MUFA_NMR, MUFA_NMR_TFAP, PUFA_MUFA_ratio_NMR,
                             hasPCA, hasGenoData, pop)

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
#  TRUE  200307   6363      0
#  <NA>       0      0      0

bothQC5 <- bothQC3 %>% filter(hasGenoData == TRUE) %>% select(CSRV, SSRV, pop)

table(bothQC$CSRV, useNA = "always")
#NonVeg    Veg   <NA>
#202750   8248      0
table(bothQC$SSRV, useNA = "always")
#NonVeg    Veg   <NA>
#202750   3271   4977
table(bothQC5$CSRV, useNA = "always")
#NonVeg    Veg   <NA>
#  5564    799      0
table(bothQC5$SSRV, useNA = "always")
#NonVeg    Veg   <NA>
#  5564    233    566

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
#SSRV                  4977
#w3FA_NMR            161158
#w3FA_NMR_TFAP       161158
#w6FA_NMR            161158
#w6FA_NMR_TFAP       161158
#w6_w3_ratio_NMR     161158
#DHA_NMR             161158
#DHA_NMR_TFAP        161158
#LA_NMR              161158
#LA_NMR_TFAP         161158
#PUFA_NMR            161158
#PUFA_NMR_TFAP       161158
#MUFA_NMR            161158
#MUFA_NMR_TFAP       161158
#PUFA_MUFA_ratio_NMR 161158
#hasPCA                   0
#hasGenoData              0
#pop                  21066

cc <- c("IID", "Sex", "Age", "Townsend", "PC1", "w3FA_NMR")
bothQC6 <- bothQC2[complete.cases(bothQC2[, cc]), ]
bothQC6 <- bothQC6 %>% filter(hasGenoData == TRUE) #37,106
#colSums(is.na(bothQC6)) %>% as.data.frame() #onlt SSRV should have NA

table(bothQC6$CSRV, useNA = "always")
#NonVeg    Veg   <NA>
#  1317    194      0
table(bothQC6$SSRV, useNA = "always")
#NonVeg    Veg   <NA>
#  1317     47    147
table(bothQC6$pop, useNA="always")
# AFR  AMR  CSA  EAS  MID <NA>
# 448  106  624  227  106    0

bothQC6 %>% select(CSRV, pop) %>% table(useNA="always")
#        pop
#CSRV     AFR AMR CSA EAS MID <NA>
#  NonVeg 431 103 460 220 103    0
#  Veg     17   3 164   7   3    0
#  <NA>     0   0   0   0   0    0
bothQC6 %>% select(SSRV, pop) %>% table(useNA="always")
#        pop
#SSRV     AFR AMR CSA EAS MID <NA>
#  NonVeg 431 103 460 220 103    0
#  Veg      1   0  45   1   0    0
#  <NA>    16   3 119   6   3    0


bothQC7 <- bothQC6 %>% filter(pop == "CSA") %>% mutate(GEM = TRUE) %>% select(IID, GEM) 
write.table(bothQC7, file = paste("/scratch/ahc87874/Replication/CSAGEMlist.txt", sep = ""),
                sep = "\t", row.names = FALSE, quote = FALSE)

#Difference
#CSRV NonVeg = 166944
#CSRV Veg = 6917
#SSRV NonVeg = 166944
#SSRV Veg = 2703
