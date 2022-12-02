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
  chrs <- c(3, 9, 11, 13)

  for (i in chrs) {
    geno <- as_tibble(read_delim(paste(alleledir, "chr", i, "SNP.raw", sep = "")))
    geno <- geno %>% select(IID, starts_with("rs"), contains(":"))
    alleles <- left_join(alleles, geno)
  }

  #majorallele_minorallele
  names(alleles)[(ncol(alleles) - 5):ncol(alleles)] <- c("rs62255849_T_C", "rs34249205_A_G", "rs72880701_G_T", 
                                                            "rs1817457_A_G", "rs149996902_T9_T10", "rs67393898_G_T")
  
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
