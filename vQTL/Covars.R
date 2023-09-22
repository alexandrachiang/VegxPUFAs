library(tidyverse)

setwd("/scratch/ahc87874/Fall2022/pheno/INT")

pheno <- as_tibble(read.csv("/scratch/ahc87874/Fall2022/pheno/GEMphenowKeep.csv", header = TRUE, stringsAsFactors = FALSE))

#covars - discrete - sex and age
covars <- pheno[, c(1:4)]
write.table(covars, "covarsINT.txt", row.names = FALSE, col.names = FALSE, quote = FALSE)

#qcovars - quantitative - townsend and pca
qcovars <- pheno[, c(1, 2, 5:15)]
write.table(qcovars, "qcovarsINT.txt", row.names = FALSE, col.names = FALSE, quote = FALSE)
