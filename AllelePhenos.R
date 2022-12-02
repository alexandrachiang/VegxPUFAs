library(tidyverse)

setwd("/scratch/ahc87874/Fall2022/")

suffix <- "wKeep"

#---------------------------------------------------------------------------------------------------------------------------------------
#Load pheno
pheno <- as_tibble(read.table(paste("/scratch/ahc87874/Fall2022/pheno/GEMpheno", suffix, ".txt", sep = ""), sep = "\t", 
                                header = TRUE, stringsAsFactors = FALSE))
pheno <- pheno %>% select(-Sex, -Age, -Townsend, -starts_with("PC"))

pheno$CSRV <- as.character(pheno$CSRV)
pheno$SSRV <- as.character(pheno$SSRV)
pheno$CSRV <- replace(pheno$CSRV, pheno$CSRV == "0", "NonVeg")
pheno$CSRV <- replace(pheno$CSRV, pheno$CSRV == "1", "Veg")
pheno$SSRV <- replace(pheno$SSRV, pheno$SSRV == "0", "NonVeg")
pheno$SSRV <- replace(pheno$SSRV, pheno$SSRV == "1", "Veg")

combined <- pheno
#---------------------------------------------------------------------------------------------------------------------------------------
#Load geno
alleledir <- "/scratch/ahc87874/Fall2022/alleles/"
chrs <- c(3, 9, 11, 13)

for (i in chrs) {
  geno <- as_tibble(read_delim(paste(alleledir, "chr", i, "SNP.raw", sep = "")))
  geno <- geno %>% select(IID, starts_with("rs"), contains(":"))
  combined <- left_join(combined, geno)
}

#majorallele_minorallele
names(combined)[(ncol(combined) - 5):ncol(combined)] <- c("rs62255849_T_C", "rs34249205_A_G", "rs72880701_G_T", 
                                                          "rs1817457_A_G", "rs149996902_T9_T10", "rs67393898_G_T")
