library(tidyverse)

setwd("/scratch/ahc87874/Fall2022/Betaplots")

allsuffix <- c("", "woCred", "wKeep")
	
#phenos <- c("w3FA_NMR", "w3FA_NMR_TFAP", "w6FA_NMR", "w6FA_NMR_TFAP", "w6_w3_ratio_NMR", "DHA_NMR", 
#            "DHA_NMR_TFAP", "LA_NMR", "LA_NMR_TFAP", "PUFA_NMR", "PUFA_NMR_TFAP", "MUFA_NMR", 
#            "MUFA_NMR_TFAP", "PUFA_MUFA_ratio_NMR")
phenos <- c("w3FA_NMR_TFAP", "w6_w3_ratio_NMR", "LA_NMR_TFAP")

for (suffix in allsuffix) {
  if (suffix == "") {
    exposures <- c("CSRV", "SSRV")
  } else {
    exposures <- c("SSRV")
  }
  
  for (i in phenos) {
    GEMdir <- paste("/scratch/ahc87874/Fall2022/GEM", suffix, sep = "")

    print(paste("pheno:", i))

    for (j in exposures) {
      print(paste("exposure:", j))
      if (TRUE) { #Combine GEM output for pheno and exposure from chr 1-22 into one data frame
        for (k in 1:22) {
          print(paste("chr:", k))
          infile <- as_tibble(read.table(paste(GEMdir, i, paste(i, "x", j, "-chr", k, sep = ""), sep = "/"), 
                                         header = TRUE, stringsAsFactors = FALSE))

          #Subset data
          infilesub <- infile %>% select(CHR, POS, robust_P_Value_Interaction, starts_with("Beta_G"), RSID)

          #Add to input
          if (k == 1) {
            infileall <- infilesub
          } else {
            infileall <- rbind(infileall, infilesub)
          } #ifelse
        } #k chr number

        #Save data table of all chr for pheno x exposure
        outdirFUMA = "/scratch/ahc87874/Fall2022/Combined/"
        write.table(infileall, paste(outdirFUMA, i, "x", j, suffix, "all.txt", sep = ""), 
                    row.names = FALSE, quote = FALSE)
      } else {
        infileall <- as_tibble(read.table(paste("/scratch/ahc87874/Fall2022/Combined/", i, "x", j, suffix, "all.txt", sep = ""), 
                                          header = TRUE, stringsAsFactors = FALSE))
      } 
    } #exposures
  } #phenos
} #suffix


#-----------------------------------------------------------------------------------------------------------------
#Loop doesnt work?
suffix <- "woCred"
i <- "w3FA_NMR_TFAP"
CSRV <- as_tibble(read.table(paste("/scratch/ahc87874/Fall2022/Combined/", i, "xCSRV", "all.txt", sep = ""), 
                                            header = TRUE, stringsAsFactors = FALSE))
SSRV <- as_tibble(read.table(paste("/scratch/ahc87874/Fall2022/Combined/", i, "xSSRV", suffix, "all.txt", sep = ""), 
                                            header = TRUE, stringsAsFactors = FALSE))

CSRV <- CSRV %>% mutate(CSRVP = -log10(P))
SSRV <- SSRV %>% mutate(SSRVP = -log10(P))

Both <- inner_join(CSRV, SSRV, by = c("SNP", "CHR")) %>% arrange(desc(SSRVP))

outdir = "/scratch/ahc87874/Fall2022/Pvalplots/"
png(filename = paste(outdir, "ComparePvals_", i, suffix, ".png", sep = ""), type = "cairo", 
    width = 600, height = 600)
ggplot(Both) + 
	geom_point(aes(x = CSRVP, y = SSRVP), alpha = 0.1) +
  geom_hline(yintercept = -log10(5e-08), linetype = "dashed", color = "red") +
  geom_vline(xintercept = -log10(5e-08), linetype = "dashed", color = "red") + 
  labs(title = paste("Compare p-values of ", i, " ", suffix, sep = ""), 
       x = "CSRV",
       y = "SSRV") 
dev.off()

i <- "w6_w3_ratio_NMR"
CSRV <- as_tibble(read.table(paste("/scratch/ahc87874/Fall2022/Combined/", i, "xCSRV", "all.txt", sep = ""), 
                                            header = TRUE, stringsAsFactors = FALSE))
SSRV <- as_tibble(read.table(paste("/scratch/ahc87874/Fall2022/Combined/", i, "xSSRV", suffix, "all.txt", sep = ""), 
                                            header = TRUE, stringsAsFactors = FALSE))

CSRV <- CSRV %>% mutate(CSRVP = -log10(P))
SSRV <- SSRV %>% mutate(SSRVP = -log10(P))

Both <- inner_join(CSRV, SSRV, by = c("SNP", "CHR")) %>% arrange(desc(SSRVP))

outdir = "/scratch/ahc87874/Fall2022/Pvalplots/"
png(filename = paste(outdir, "ComparePvals_", i, suffix, ".png", sep = ""), type = "cairo", 
    width = 600, height = 600)
ggplot(Both) + 
	geom_point(aes(x = CSRVP, y = SSRVP), alpha = 0.1) +
  geom_hline(yintercept = -log10(5e-08), linetype = "dashed", color = "red") +
  geom_vline(xintercept = -log10(5e-08), linetype = "dashed", color = "red") + 
  labs(title = paste("Compare p-values of ", i, " ", suffix, sep = ""), 
       x = "CSRV",
       y = "SSRV") 
dev.off()

i <- "LA_NMR_TFAP"
CSRV <- as_tibble(read.table(paste("/scratch/ahc87874/Fall2022/Combined/", i, "xCSRV", "all.txt", sep = ""), 
                                            header = TRUE, stringsAsFactors = FALSE))
SSRV <- as_tibble(read.table(paste("/scratch/ahc87874/Fall2022/Combined/", i, "xSSRV", suffix, "all.txt", sep = ""), 
                                            header = TRUE, stringsAsFactors = FALSE))

CSRV <- CSRV %>% mutate(CSRVP = -log10(P))
SSRV <- SSRV %>% mutate(SSRVP = -log10(P))

Both <- inner_join(CSRV, SSRV, by = c("SNP", "CHR")) %>% arrange(desc(SSRVP))

outdir = "/scratch/ahc87874/Fall2022/Pvalplots/"
png(filename = paste(outdir, "ComparePvals_", i, suffix, ".png", sep = ""), type = "cairo", 
    width = 600, height = 600)
ggplot(Both) + 
	geom_point(aes(x = CSRVP, y = SSRVP), alpha = 0.1) +
  geom_hline(yintercept = -log10(5e-08), linetype = "dashed", color = "red") +
  geom_vline(xintercept = -log10(5e-08), linetype = "dashed", color = "red") + 
  labs(title = paste("Compare p-values of ", i, " ", suffix, sep = ""), 
       x = "CSRV",
       y = "SSRV") 
dev.off()


suffix <- "wKeep"
i <- "w3FA_NMR_TFAP"
CSRV <- as_tibble(read.table(paste("/scratch/ahc87874/Fall2022/Combined/", i, "xCSRV", "all.txt", sep = ""), 
                                            header = TRUE, stringsAsFactors = FALSE))
SSRV <- as_tibble(read.table(paste("/scratch/ahc87874/Fall2022/Combined/", i, "xSSRV", suffix, "all.txt", sep = ""), 
                                            header = TRUE, stringsAsFactors = FALSE))

CSRV <- CSRV %>% mutate(CSRVP = -log10(P))
SSRV <- SSRV %>% mutate(SSRVP = -log10(P))

Both <- inner_join(CSRV, SSRV, by = c("SNP", "CHR")) %>% arrange(desc(SSRVP))

outdir = "/scratch/ahc87874/Fall2022/Pvalplots/"
png(filename = paste(outdir, "ComparePvals_", i, suffix, ".png", sep = ""), type = "cairo", 
    width = 600, height = 600)
ggplot(Both) + 
	geom_point(aes(x = CSRVP, y = SSRVP), alpha = 0.1) +
  geom_hline(yintercept = -log10(5e-08), linetype = "dashed", color = "red") +
  geom_vline(xintercept = -log10(5e-08), linetype = "dashed", color = "red") + 
  labs(title = paste("Compare p-values of ", i, " ", suffix, sep = ""), 
       x = "CSRV",
       y = "SSRV") 
dev.off()

i <- "w6_w3_ratio_NMR"
CSRV <- as_tibble(read.table(paste("/scratch/ahc87874/Fall2022/Combined/", i, "xCSRV", "all.txt", sep = ""), 
                                            header = TRUE, stringsAsFactors = FALSE))
SSRV <- as_tibble(read.table(paste("/scratch/ahc87874/Fall2022/Combined/", i, "xSSRV", suffix, "all.txt", sep = ""), 
                                            header = TRUE, stringsAsFactors = FALSE))

CSRV <- CSRV %>% mutate(CSRVP = -log10(P))
SSRV <- SSRV %>% mutate(SSRVP = -log10(P))

Both <- inner_join(CSRV, SSRV, by = c("SNP", "CHR")) %>% arrange(desc(SSRVP))

outdir = "/scratch/ahc87874/Fall2022/Pvalplots/"
png(filename = paste(outdir, "ComparePvals_", i, suffix, ".png", sep = ""), type = "cairo", 
    width = 600, height = 600)
ggplot(Both) + 
	geom_point(aes(x = CSRVP, y = SSRVP), alpha = 0.1) +
  geom_hline(yintercept = -log10(5e-08), linetype = "dashed", color = "red") +
  geom_vline(xintercept = -log10(5e-08), linetype = "dashed", color = "red") + 
  labs(title = paste("Compare p-values of ", i, " ", suffix, sep = ""), 
       x = "CSRV",
       y = "SSRV") 
dev.off()

i <- "LA_NMR_TFAP"
CSRV <- as_tibble(read.table(paste("/scratch/ahc87874/Fall2022/Combined/", i, "xCSRV", "all.txt", sep = ""), 
                                            header = TRUE, stringsAsFactors = FALSE))
SSRV <- as_tibble(read.table(paste("/scratch/ahc87874/Fall2022/Combined/", i, "xSSRV", suffix, "all.txt", sep = ""), 
                                            header = TRUE, stringsAsFactors = FALSE))

CSRV <- CSRV %>% mutate(CSRVP = -log10(P))
SSRV <- SSRV %>% mutate(SSRVP = -log10(P))

Both <- inner_join(CSRV, SSRV, by = c("SNP", "CHR")) %>% arrange(desc(SSRVP))

outdir = "/scratch/ahc87874/Fall2022/Pvalplots/"
png(filename = paste(outdir, "ComparePvals_", i, suffix, ".png", sep = ""), type = "cairo", 
    width = 600, height = 600)
ggplot(Both) + 
	geom_point(aes(x = CSRVP, y = SSRVP), alpha = 0.1) +
  geom_hline(yintercept = -log10(5e-08), linetype = "dashed", color = "red") +
  geom_vline(xintercept = -log10(5e-08), linetype = "dashed", color = "red") + 
  labs(title = paste("Compare p-values of ", i, " ", suffix, sep = ""), 
       x = "CSRV",
       y = "SSRV") 
dev.off()


suffix <- ""
i <- "w3FA_NMR_TFAP"
CSRV <- as_tibble(read.table(paste("/scratch/ahc87874/Fall2022/Combined/", i, "xCSRV", "all.txt", sep = ""), 
                                            header = TRUE, stringsAsFactors = FALSE))
SSRV <- as_tibble(read.table(paste("/scratch/ahc87874/Fall2022/Combined/", i, "xSSRV", suffix, "all.txt", sep = ""), 
                                            header = TRUE, stringsAsFactors = FALSE))

CSRV <- CSRV %>% mutate(CSRVP = -log10(P))
SSRV <- SSRV %>% mutate(SSRVP = -log10(P))

Both <- inner_join(CSRV, SSRV, by = c("SNP", "CHR")) %>% arrange(desc(SSRVP))

outdir = "/scratch/ahc87874/Fall2022/Pvalplots/"
png(filename = paste(outdir, "ComparePvals_", i, suffix, ".png", sep = ""), type = "cairo", 
    width = 600, height = 600)
ggplot(Both) + 
	geom_point(aes(x = CSRVP, y = SSRVP), alpha = 0.1) +
  geom_hline(yintercept = -log10(5e-08), linetype = "dashed", color = "red") +
  geom_vline(xintercept = -log10(5e-08), linetype = "dashed", color = "red") + 
  labs(title = paste("Compare p-values of ", i, sep = ""), 
       x = "CSRV",
       y = "SSRV") 
dev.off()

i <- "w6_w3_ratio_NMR"
CSRV <- as_tibble(read.table(paste("/scratch/ahc87874/Fall2022/Combined/", i, "xCSRV", "all.txt", sep = ""), 
                                            header = TRUE, stringsAsFactors = FALSE))
SSRV <- as_tibble(read.table(paste("/scratch/ahc87874/Fall2022/Combined/", i, "xSSRV", suffix, "all.txt", sep = ""), 
                                            header = TRUE, stringsAsFactors = FALSE))

CSRV <- CSRV %>% mutate(CSRVP = -log10(P))
SSRV <- SSRV %>% mutate(SSRVP = -log10(P))

Both <- inner_join(CSRV, SSRV, by = c("SNP", "CHR")) %>% arrange(desc(SSRVP))

outdir = "/scratch/ahc87874/Fall2022/Pvalplots/"
png(filename = paste(outdir, "ComparePvals_", i, suffix, ".png", sep = ""), type = "cairo", 
    width = 600, height = 600)
ggplot(Both) + 
	geom_point(aes(x = CSRVP, y = SSRVP), alpha = 0.1) +
  geom_hline(yintercept = -log10(5e-08), linetype = "dashed", color = "red") +
  geom_vline(xintercept = -log10(5e-08), linetype = "dashed", color = "red") + 
  labs(title = paste("Compare p-values of ", i, sep = ""), 
       x = "CSRV",
       y = "SSRV") 
dev.off()

i <- "LA_NMR_TFAP"
CSRV <- as_tibble(read.table(paste("/scratch/ahc87874/Fall2022/Combined/", i, "xCSRV", "all.txt", sep = ""), 
                                            header = TRUE, stringsAsFactors = FALSE))
SSRV <- as_tibble(read.table(paste("/scratch/ahc87874/Fall2022/Combined/", i, "xSSRV", suffix, "all.txt", sep = ""), 
                                            header = TRUE, stringsAsFactors = FALSE))

CSRV <- CSRV %>% mutate(CSRVP = -log10(P))
SSRV <- SSRV %>% mutate(SSRVP = -log10(P))

Both <- inner_join(CSRV, SSRV, by = c("SNP", "CHR")) %>% arrange(desc(SSRVP))

outdir = "/scratch/ahc87874/Fall2022/Pvalplots/"
png(filename = paste(outdir, "ComparePvals_", i, suffix, ".png", sep = ""), type = "cairo", 
    width = 600, height = 600)
ggplot(Both) + 
	geom_point(aes(x = CSRVP, y = SSRVP), alpha = 0.1) +
  geom_hline(yintercept = -log10(5e-08), linetype = "dashed", color = "red") +
  geom_vline(xintercept = -log10(5e-08), linetype = "dashed", color = "red") + 
  labs(title = paste("Compare p-values of ", i, sep = ""), 
       x = "CSRV",
       y = "SSRV") 
dev.off()
