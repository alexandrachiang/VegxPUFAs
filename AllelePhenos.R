source(CountVegFirst.R)
library(rbgen)

setwd("/scratch/ahc87874/Fall2022/")

suffix <- "wKeep"

pheno <- as_tibble(read.table(paste("/scratch/ahc87874/Fall2022/pheno/GEMpheno", suffix, ".txt", sep = ""), sep = "\t", 
                                header = TRUE, stringsAsFactors = FALSE))
pheno <- pheno %>% select(-Sex, -Age, -Townsend, -starts_with("PC"))

pheno$CSRV <- as.character(pheno$CSRV)
pheno$SSRV <- as.character(pheno$SSRV)
pheno$CSRV <- replace(pheno$CSRV, pheno$CSRV == "0", "NonVeg")
pheno$CSRV <- replace(pheno$CSRV, pheno$CSRV == "1", "Veg")
pheno$SSRV <- replace(pheno$SSRV, pheno$SSRV == "0", "NonVeg")
pheno$SSRV <- replace(pheno$SSRV, pheno$SSRV == "1", "Veg")

bgen.load("/scratch/ahc87874/Fall2022/geno/chr13.bgen", rsids = "rs67393898")
"/scratch/ahc87874/Fall2022/geno/chr11.bgen", rsids = c("rs72880701", "rs1817457")
"/scratch/ahc87874/Fall2022/geno/chr9.bgen", rsids = "9:140508031_A_G"
