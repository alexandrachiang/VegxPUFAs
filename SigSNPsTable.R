library(tidyverse)
library(scales)

setwd("/scratch/ahc87874/Fall2022/SNPs")

phenos <- c("w3FA_NMR", "w3FA_NMR_TFAP", "w6FA_NMR", "w6FA_NMR_TFAP", "w6_w3_ratio_NMR", "DHA_NMR", 
            "DHA_NMR_TFAP", "LA_NMR", "LA_NMR_TFAP", "PUFA_NMR", "PUFA_NMR_TFAP", "MUFA_NMR", 
            "MUFA_NMR_TFAP", "PUFA_MUFA_ratio_NMR")
            
suffix <- c("wKeep")

SigSNPs <- as_tibble(cbind(rep(phenos, each = 2), 
                               rep(c("CSRV", "SSRV"), times = length(phenos)), 
                               data.frame(matrix(ncol = 3, nrow = 2 * length(phenos)))))
names(SigSNPs) <- c("Phenotype", "Exposure", "p1eneg5", "p5eneg8", "Smallestp")

for (i in 1:length(phenos)) {
  CSRV <- as_tibble(read.table(paste("/scratch/ahc87874/Fall2022/Combined/", phenos[i], "xCSRV", "all.txt", sep = ""), 
                                            header = TRUE, stringsAsFactors = FALSE))
  SSRV <- as_tibble(read.table(paste("/scratch/ahc87874/Fall2022/Combined/", phenos[i], "xSSRV", suffix, "all.txt", sep = ""), 
                                            header = TRUE, stringsAsFactors = FALSE))
  names(CSRV) <- c("CHR", "BP", "P", "CSRVBeta", "SNP")
  names(SSRV) <- c("CHR", "BP", "P", "SSRVBeta", "SNP")
  
  SigSNPs$p1eneg5[1 + 2 * (i - 1)] <- CSRV %>% filter(P <= 1e-5) %>% nrow()
  SigSNPs$p1eneg5[2 + 2 * (i - 1)] <- SSRV %>% filter(P <= 1e-5) %>% nrow()
  SigSNPs$p5eneg8[1 + 2 * (i - 1)] <- CSRV %>% filter(P <= 5e-8) %>% nrow()
  SigSNPs$p5eneg8[2 + 2 * (i - 1)] <- SSRV %>% filter(P <= 5e-8) %>% nrow()
  SigSNPs$Smallestp[1 + 2 * (i - 1)] <- scientific(min(CSRV$P, na.rm = TRUE), digits = 5)
  SigSNPs$Smallestp[2 + 2 * (i - 1)] <- scientific(min(SSRV$P, na.rm = TRUE), digits = 5)
}

SigSNPs
