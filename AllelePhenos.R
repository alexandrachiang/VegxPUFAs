library(tidyverse)

setwd("/scratch/ahc87874/Fall2022/")

if (FALSE) {
  #---------------------------------------------------------------------------------------------------------------------------------------
  #Load pheno
  suffix <- "wKeep"

  pheno <- as_tibble(read.table(paste("/scratch/ahc87874/Fall2022/pheno/GEMpheno", suffix, ".txt", sep = ""), sep = "\t", 
                                  header = TRUE, stringsAsFactors = FALSE))
  
  cc <- c("IID", "Sex", "Age", "Townsend") #, "PC1"
  pheno <- pheno[complete.cases(pheno[, cc]), ]
  
  pheno <- pheno %>% select(-Sex, -Age, -Townsend, -starts_with("PC"))

  pheno$CSRV <- as.character(pheno$CSRV)
  pheno$SSRV <- as.character(pheno$SSRV)
  pheno$CSRV <- replace(pheno$CSRV, pheno$CSRV == "0", "NonVeg")
  pheno$CSRV <- replace(pheno$CSRV, pheno$CSRV == "1", "Veg")
  pheno$SSRV <- replace(pheno$SSRV, pheno$SSRV == "0", "NonVeg")
  pheno$SSRV <- replace(pheno$SSRV, pheno$SSRV == "1", "Veg")

  alleles <- pheno
  #---------------------------------------------------------------------------------------------------------------------------------------
  #Load geno
  alleledir <- "/scratch/ahc87874/Fall2022/alleles/"
  pgendir <- "/scratch/ahc87874/Fall2022/pgen/"
  chrs <- c(3, 9, 11, 13)

  for (i in chrs) {
    geno <- as_tibble(read_delim(paste(alleledir, "chr", i, "SNP.raw", sep = "")))
    geno <- geno %>% select(IID, starts_with("rs"), contains(":"))
    alleles <- left_join(alleles, geno)
  }

  #names(alleles)
  # [1] "FID"                 "IID"                 "CSRV"
  # [4] "SSRV"                "w3FA_NMR"            "w3FA_NMR_TFAP"
  # [7] "w6FA_NMR"            "w6FA_NMR_TFAP"       "w6_w3_ratio_NMR"
  #[10] "DHA_NMR"             "DHA_NMR_TFAP"        "LA_NMR"
  #[13] "LA_NMR_TFAP"         "PUFA_NMR"            "PUFA_NMR_TFAP"
  #[16] "MUFA_NMR"            "MUFA_NMR_TFAP"       "PUFA_MUFA_ratio_NMR"
  #[19] "rs62255849_C"        "9:140508031_A_G_G"   "rs72880701_T"
  #[22] "rs1817457_A"         "rs149996902_C"       "rs67393898_T"

  #Check major and minor alleles
  rsIDs <- c("rs62255849", "9:140508031_A_G", "rs72880701", "rs1817457", "rs149996902", "rs67393898")
  SNPs <- as_tibble(matrix(ncol = 5))
  names(SNPs) <- c("#CHROM", "POS", "ID", "REF", "ALT")
  for (i in chrs) {
    rs <- as_tibble(read_delim(paste(pgendir, "chr", i, ".pvar", sep = "")))
    SNPs <- rbind(SNPs, rs[rs$ID %in% rsIDs, ])
  } 
  SNPs <- SNPs[-1, ]
  SNPs
  #  `#CHROM`       POS ID              REF   ALT
  #     <dbl>     <dbl> <chr>           <chr> <chr>
  #1        3  24215321 rs62255849      T     C
  #2        9 140508031 9:140508031_A_G A     G
  #3       11  24685414 rs72880701      G     T
  #4       11  36945182 rs1817457       A     G #Different for Europeans, switch for major/minor
  #5       11  36953685 rs149996902     C     CT #Different for Europeans, switch for major/minor
  #6       13  98799253 rs67393898      G     T
  
  #majorallele_minorallele
  names(alleles)[(ncol(alleles) - 5):ncol(alleles)] <- c("rs62255849_T_C", "rs34249205_A_G", "rs72880701_G_T", 
                                                         "rs1817457_G_A", "rs149996902_CT_C", "rs67393898_G_T")
  
  #---------------------------------------------------------------------------------------------------------------------------------------
  #Complete cases
  #colSums(is.na(df))
  alleles <- alleles[complete.cases(alleles$w3FA_NMR), ]
  alleles <- alleles[complete.cases(alleles$rs62255849_T_C), ]
  
  #alleles %>% select(CSRV,SSRV) %>% table(useNA="always")
  #          SSRV
  #CSRV     NonVeg   Veg  <NA>
  #  NonVeg  35780     0     0
  #  Veg         0   568   758
  #  <NA>        0     0     0
  
  write.table(alleles, file = paste("/scratch/ahc87874/Fall2022/alleles/PhenoGeno.txt", sep = ""),
              sep = "\t", row.names = FALSE, quote = FALSE)
} else {
  alleles <- as_tibble(read.table("/scratch/ahc87874/Fall2022/alleles/PhenoGeno.txt", 
                                  header = TRUE, stringsAsFactors = FALSE))
}

alleles2 <- alleles

#Range for all SNPs is 0 to 2
alleles2$rs62255849_T_C = round(alleles2$rs62255849_T_C, digits = 0)
alleles2$rs34249205_A_G = round(alleles2$rs34249205_A_G, digits = 0)
alleles2$rs72880701_G_T = round(alleles2$rs72880701_G_T, digits = 0)
alleles2$rs1817457_G_A = round(alleles2$rs1817457_G_A, digits = 0)
alleles2$rs149996902_CT_C = round(alleles2$rs149996902_CT_C, digits = 0)
alleles2$rs67393898_G_T = round(alleles2$rs67393898_G_T, digits = 0)

#Get minor allele %
test <- alleles2 %>% select(starts_with("rs"))

for (i in 1:ncol(test)) {
  print(names(test)[i])
  print(table(test[, i]))
  print(round((sum(test[, i]) / (nrow(test) * 2)), digits = 4))
}
#"rs62255849_T_C"
#    0     1     2
#34755  2309    42
#0.0322
#"rs34249205_A_G"
#    0     1     2
#28419  8096   591
#0.125
#"rs72880701_G_T"
#    0     1     2
#31909  4985   212
#0.0729
#"rs1817457_G_A"
#    0     1     2
#18776 15201  3129
#0.2892
#"rs149996902_CT_C"
#    0     1     2
#18812 15170  3124
#0.2886
#"rs67393898_G_T"
#    0     1     2
#28544  8003   559
#0.1229

alleles3 <- alleles2 %>% mutate(rs62255849_T_C = ifelse(rs62255849_T_C == 0, "TT", ifelse(rs62255849_T_C == 2, "CC", "TC")),
                                rs34249205_A_G = ifelse(rs34249205_A_G == 0, "AA", ifelse(rs34249205_A_G == 2, "GG", "AG")),
                                rs72880701_G_T = ifelse(rs72880701_G_T == 0, "GG", ifelse(rs72880701_G_T == 2, "TT", "GT")),
                                rs1817457_G_A = ifelse(rs1817457_G_A == 0, "GG", ifelse(rs1817457_G_A == 2, "AA", "GA")),
                                rs149996902_CT_C = ifelse(rs149996902_CT_C == 0, "10T", ifelse(rs149996902_CT_C == 2, "8T", "9T")), #?
                                rs67393898_G_T = ifelse(rs67393898_G_T == 0, "GG", ifelse(rs67393898_G_T == 2, "TT", "GT")))

#w6_w3_ratio_NMRxCSRV = rs67393898, rs62255849
#w6_w3_ratio_NMRxSSRV = rs72880701
#LA_NMR_TFAPxSSRV = rs1817457, rs149996902
#w3FA_NMR_TFAPxSSRV = rs34249205
