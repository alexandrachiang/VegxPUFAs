#inverse normal transformation of phenotypes

library(tidyverse)

setwd("/scratch/ahc87874/Fall2022/pheno/INT")

pheno <- as_tibble(read.csv("/scratch/ahc87874/Fall2022/pheno/GEMphenowKeep.csv", header = TRUE, stringsAsFactors = FALSE))
pheno2 <- pheno[, 18:31]

for (i in 1:13) {
  pheno2[, i] <- qnorm((rank(pheno2[, i],na.last="keep")-0.5)/sum(!is.na(pheno2[, i])))
}

pheno3 <- cbind (pheno$FID, pheno$IID, pheno2)
names(pheno3)[1:2] <- c("FID", "IID")
write.csv(pheno3, file = "INTpheno.csv", row.names = FALSE, quote = FALSE)

for (i in 3:16) {
  phenoname <- names(pheno3)[i]
  phenolist <- pheno3[, c(1, 2, i)]
  write.table(phenolist, paste(phenoname, "INT.txt", sep = ""), row.names = FALSE, col.names = FALSE, quote = FALSE)
}

#png(filename = "pheno.png", type = "cairo", width = 700, height = 700)
#print(hist(pheno$w3FA_NMR_TFAP))
#dev.off()

#png(filename = "pheno2.png", type = "cairo", width = 700, height = 700)
#print(hist(pheno2$w3FA_NMR_TFAP))
#dev.off()
