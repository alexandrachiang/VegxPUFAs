library(tidyverse)

setwd("/scratch/ahc87874/Fall2022/pheno/INT")

pheno <- as_tibble(read.csv("/scratch/ahc87874/Fall2022/pheno/GEMphenowKeep.csv", header = TRUE, stringsAsFactors = FALSE))

#covars - discrete - sex
covars <- pheno[, c(1:3)]
write.table(covars, "covarsINT.txt", row.names = FALSE, col.names = FALSE, quote = FALSE)

#qcovars - quantitative - age and pca
qcovars <- pheno[, c(1, 2, 4, 6:15)] 
write.table(qcovars, "qcovarsINT.txt", row.names = FALSE, col.names = FALSE, quote = FALSE)

#doesnt matter if age is in covars or qcovars
