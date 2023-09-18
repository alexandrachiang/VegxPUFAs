#inverse normal transformation of phenotypes

library(tidyverse)

setwd("/scratch/ahc87874/Fall2022/pheno")

pheno <- as_tibble(read.csv("/scratch/ahc87874/Fall2022/pheno/GEMphenowKeep.csv", header = TRUE, stringsAsFactors = FALSE))
pheno2 <- pheno

for (i in 19:31) {
  pheno2[, i] <- qnorm((rank(pheno[, i],na.last="keep")-0.5)/sum(!is.na(pheno[, i])))
}

write.csv(pheno2, file = "INTpheno.csv", row.names = FALSE, quote = FALSE)

#png(filename = "pheno.png", type = "cairo", width = 700, height = 700)
#print(hist(pheno$w3FA_NMR_TFAP))
#dev.off()

#png(filename = "pheno2.png", type = "cairo", width = 700, height = 700)
#print(hist(pheno2$w3FA_NMR_TFAP))
#dev.off()
