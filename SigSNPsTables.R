library(tidyverse)
library(scales)

setwd("/scratch/ahc87874/Fall2022/SNPs")

phenos <- c("w3FA_NMR", "w3FA_NMR_TFAP", "w6FA_NMR", "w6FA_NMR_TFAP", "w6_w3_ratio_NMR", "DHA_NMR", 
            "DHA_NMR_TFAP", "LA_NMR", "LA_NMR_TFAP", "PUFA_NMR", "PUFA_NMR_TFAP", "MUFA_NMR", 
            "MUFA_NMR_TFAP", "PUFA_MUFA_ratio_NMR")
            
suffix <- c("wKeep")

SNPsSum <- as_tibble(cbind(rep(phenos, each = 2), 
                               rep(c("CSRV", "SSRV"), times = length(phenos)), 
                               data.frame(matrix(ncol = 3, nrow = 2 * length(phenos)))))
names(SNPsSum) <- c("Phenotype", "Exposure", "p1eneg5", "p5eneg8", "Smallestp")

SigSNPs <- as_tibble(matrix(ncol = 7))
names(SigSNPs) <- c("Pheno", "Exposure", "CHR", "BP", "P", "Beta", "SNP")

for (i in 1:length(phenos)) {
  CSRV <- as_tibble(read.table(paste("/scratch/ahc87874/Fall2022/Combined/", phenos[i], "xCSRV", "all.txt", sep = ""), 
                                            header = TRUE, stringsAsFactors = FALSE))
  SSRV <- as_tibble(read.table(paste("/scratch/ahc87874/Fall2022/Combined/", phenos[i], "xSSRV", suffix, "all.txt", sep = ""), 
                                            header = TRUE, stringsAsFactors = FALSE))
  names(CSRV) <- c("CHR", "BP", "P", "Beta", "SNP")
  names(SSRV) <- c("CHR", "BP", "P", "Beta", "SNP")
  
  SNPsSum$p1eneg5[1 + 2 * (i - 1)] <- CSRV %>% filter(P <= 1e-5) %>% nrow()
  SNPsSum$p1eneg5[2 + 2 * (i - 1)] <- SSRV %>% filter(P <= 1e-5) %>% nrow()
  SNPsSum$p5eneg8[1 + 2 * (i - 1)] <- CSRV %>% filter(P <= 5e-8) %>% nrow()
  SNPsSum$p5eneg8[2 + 2 * (i - 1)] <- SSRV %>% filter(P <= 5e-8) %>% nrow()
  SNPsSum$Smallestp[1 + 2 * (i - 1)] <- scientific(min(CSRV$P, na.rm = TRUE), digits = 6)
  SNPsSum$Smallestp[2 + 2 * (i - 1)] <- scientific(min(SSRV$P, na.rm = TRUE), digits = 6)

  if (SNPsSum$p5eneg8[1 + 2 * (i - 1)] != 0) {
    x <- CSRV %>% filter(P <= 5e-8) %>% mutate(Pheno = phenos[i], Exposure = "CSRV") %>% select(Pheno, Exposure, everything())
    SigSNPs <- rbind(SigSNPs, x)
  }
  
  if (SNPsSum$p5eneg8[2 + 2 * (i - 1)] != 0) {
    x <- SSRV %>% filter(P <= 5e-8) %>% mutate(Pheno = phenos[i], Exposure = "SSRV") %>% select(Pheno, Exposure, everything())
    SigSNPs <- rbind(SigSNPs, x)
  }
}

SNPsSum
SigSNPs <- SigSNPs[-1, ]
SigSNPs$P <- scientific(SigSNPs$P, digits = 6)
SigSNPs

#write.table(SNPsSum, file = paste("/scratch/ahc87874/Fall2022/SNPs/SNPsTable.txt", sep = ""),
#            sep = "\t", row.names = FALSE, quote = FALSE)
#write.table(SigSNPs, file = paste("/scratch/ahc87874/Fall2022/SNPs/VerySigSNPs.txt", sep = ""),
#            sep = "\t", row.names = FALSE, quote = FALSE)
