library(tidyverse)
library(scales)

setwd("/scratch/ahc87874/Fall2022/SNPs")

phenos <- c("w3FA", "w3FA_TFAP", "w6FA", "w6FA_TFAP", "w6_w3_ratio", "DHA", 
            "DHA_TFAP", "LA", "LA_TFAP", "PUFA", "PUFA_TFAP", "MUFA", 
            "MUFA_TFAP", "PUFA_MUFA_ratio")
            
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
SigSNPs <- SigSNPs %>% arrange(P)
SigSNPs$P <- scientific(SigSNPs$P, digits = 6)
SigSNPs

#write.table(SNPsSum, file = paste("/scratch/ahc87874/Fall2022/SNPs/SNPsTable.txt", sep = ""),
#            sep = "\t", row.names = FALSE, quote = FALSE)
#write.table(SigSNPs, file = paste("/scratch/ahc87874/Fall2022/SNPs/VerySigSNPs.txt", sep = ""),
#            sep = "\t", row.names = FALSE, quote = FALSE)


infileallsig <- as_tibble(read.table("/scratch/ahc87874/Fall2022/Combined/wKeepallSigSNPs.txt", header = TRUE, stringsAsFactors = FALSE))
infileallsig %>% select(Phenotype, Exposure, CHR, POS, RSID, Effect_Allele, Non_Effect_Allele, AF, Beta_G, robust_SE_Beta_G, robust_P_Value_Interaction)

SNPs <- c("rs72880701", "rs1817457", "9:140508031_A_G", "rs149996902", "rs67393898", "rs62255849")
for (i in 1:length(SNPs)) {
  print(SNPs[i])
  #x <- infileallsig %>% filter(RSID %in% SNPs[i]) %>% select(Phenotype, Exposure, CHR, POS, RSID, Effect_Allele, Non_Effect_Allele, 
  #                                                           AF, Beta_G, robust_SE_Beta_G, robust_P_Value_Interaction) %>% print()
  x <- infileallsig %>% filter(RSID %in% SNPs[i]) %>% 
            select(Phenotype, Exposure, CHR, POS, RSID, robust_P_Value_Interaction) %>% 
            arrange(robust_P_Value_Interaction)
  x$robust_P_Value_Interaction <- scientific(as.numeric(x$robust_P_Value_Interaction), digits = 6)
  print(x)
}
