library(tidyverse)
library(qqman)

source("/work/kylab/alex/Fall2022/ManhattanCex.R")

setwd("/scratch/ahc87874/FishOil/")
	
i <- c("w3FA")
j <- c("Fish_oil_baseline")

k <- c("comb")
infileall <- as_tibble(read.table(paste("/scratch/ahc87874/FishOil/Combined/", i, "x", j, "FishOil", k, ".txt", sep = ""), 
                                  header = TRUE, stringsAsFactors = FALSE))
infileall <- infileall %>% select(RSID, robust_P_Value_Interaction)
colnames(infileall) <- c("SNP", "P.comb")
comb <- infileall

k <- c("phase1")
infileall <- as_tibble(read.table(paste("/scratch/ahc87874/FishOil/Combined/", i, "x", j, "FishOil", k, ".txt", sep = ""), 
                                  header = TRUE, stringsAsFactors = FALSE))
infileall <- infileall %>% select(robust_P_Value_Interaction)
colnames(infileall) <- c("P.p1")
phase1 <- infileall

k <- c("phase2")
infileall <- as_tibble(read.table(paste("/scratch/ahc87874/FishOil/Combined/", i, "x", j, "FishOil", k, ".txt", sep = ""), 
                                  header = TRUE, stringsAsFactors = FALSE))
infileall <- infileall %>% select(robust_P_Value_Interaction)
colnames(infileall) <- c("P.p2")
phase2 <- infileall

pvals <- as_tibble(cbind(comb, phase1, phase2))

pvals$P.comb <- -log10(pvals$P.comb)
pvals$P.p1 <- -log10(pvals$P.p1)
pvals$P.p2 <- -log10(pvals$P.p2)

png(filename = "1vsComb.png", type = "cairo", width = 1000, height = 1000)
ggplot(pvals, aes(x=P.p1, y=P.comb)) +
  geom_point(alpha = 0.1) + 
  labs(title = "Phase 1 vs Combined P-values", x = "Phase 1", y = "Combined")
dev.off()

png(filename = "2vsComb.png", type = "cairo", width = 1000, height = 1000)
ggplot(pvals, aes(x=P.p2, y=P.comb)) +
  geom_point(alpha = 0.1) + 
  labs(title = "Phase 2 vs Combined P-values", x = "Phase 2", y = "Combined")
dev.off()

png(filename = "1vs2.png", type = "cairo", width = 1000, height = 1000)
ggplot(pvals, aes(x=P.p1, y=P.p2)) +
  geom_point(alpha = 0.1) + 
  labs(title = "Phase 1 vs Phase 2 P-values", x = "Phase 1", y = "Phase 2")
dev.off()
