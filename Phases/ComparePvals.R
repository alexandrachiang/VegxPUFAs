suppressMessages(library(plyr))
suppressMessages(library(dplyr))
suppressMessages(library(gridExtra))
suppressMessages(library(tidyverse))
suppressMessages(library(ukbtools)) #<3
suppressMessages(library(rio))

setwd("/scratch/ahc87874/Phase/plots")

indir <- "/scratch/ahc87874/Fall2022/Combined/"

phenos <- c("w3FA", "w3FA_TFAP", "DHA", "PUFA", 
            "w6FA", "w6FA_TFAP", "w6_w3_ratio",  
            "DHA_TFAP", "LA", "LA_TFAP", "PUFA_TFAP", "MUFA", 
            "MUFA_TFAP", "PUFA_MUFA_ratio")

for (i in phenos) {
  phase1 <- import(paste(indir, i, "xVegetarianVegphase1.txt", sep = ""))
  phase2 <- import(paste(indir, i, "xVegetarianVegphase2.txt", sep = ""))
  comb <- import(paste(indir, i, "xVegetarianVegcomb.txt", sep = ""))

  comb <- comb %>% select(RSID, robust_P_Value_Interaction)
  colnames(comb) <- c("SNP", "P.comb")

  phase1 <- phase1 %>% select(robust_P_Value_Interaction)
  colnames(phase1) <- c("P.p1")

  phase2 <- phase2 %>% select(robust_P_Value_Interaction)
  colnames(phase2) <- c("P.p2")
  
  pvals <- as_tibble(cbind(comb, phase1, phase2))

  pvals$P.comb <- -log10(pvals$P.comb)
  pvals$P.p1 <- -log10(pvals$P.p1)
  pvals$P.p2 <- -log10(pvals$P.p2)

  png(filename = paste(i, "1vsComb.png", sep = "_"), type = "cairo", width = 1000, height = 1000)
  ggplot(pvals, aes(x=P.p1, y=P.comb)) +
    geom_point(alpha = 0.1) + 
    labs(title = paste(i, "Phase 1 vs Combined P-values"), x = "Phase 1", y = "Combined")
  dev.off()
  
  png(filename = paste(i, "2vsComb.png", sep = "_"), type = "cairo", width = 1000, height = 1000)
  ggplot(pvals, aes(x=P.p2, y=P.comb)) +
    geom_point(alpha = 0.1) + 
    labs(title = paste(i, "Phase 2 vs Combined P-values"), x = "Phase 2", y = "Combined")
  dev.off()
  
  png(filename = paste(i, "1vs2.png", sep = "_"), type = "cairo", width = 1000, height = 1000)
  ggplot(pvals, aes(x=P.p1, y=P.p2)) +
    geom_point(alpha = 0.1) + 
    labs(title = paste(i, "Phase 1 vs Phase 2 P-values"), x = "Phase 1", y = "Phase 2")
  dev.off()
}
