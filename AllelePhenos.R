source(CountVegFirst.R)
library(rbgen)

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

#---------------------------------------------------------------------------------------------------------------------------------------
#Load geno
alleledir <- "/scratch/ahc87874/Fall2022/alleles/"

chr13 <- as_tibble(read_delim(paste(alleledir, "chr13.raw", sep = ""), header = TRUE)
11 9 3
