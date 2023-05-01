library(tidyverse)

setwd("/scratch/ahc87874/Replication/")
reso <- 135

if (FALSE) {
  #---------------------------------------------------------------------------------------------------------------------------------------
  #Load pheno
  pheno <- as_tibble(read.table(paste("/scratch/ahc87874/Fall2022/pheno/GEMpheno", "wKeep", ".txt", sep = ""), sep = "\t", 
                                  header = TRUE, stringsAsFactors = FALSE))
  
  cc <- c("IID", "Sex", "Age", "Townsend") #, "PC1"
  pheno <- pheno[complete.cases(pheno[, cc]), ]
  
  pheno <- pheno %>% select(-Sex, -Age, -Townsend, -starts_with("PC"))

  pheno$CSRV <- as.character(pheno$CSRV)
  pheno$SSRV <- as.character(pheno$SSRV)
  pheno$CSRV <- replace(pheno$CSRV, pheno$CSRV == "0", "NonVeg")
  pheno$CSRV <- replace(pheno$CSRV, pheno$CSRV == "1", "Veg")
  pheno$SSRV <- replace(pheno$SSRV, pheno$SSRV == "0", "NonVeg")
  pheno$SSRV <- replace(pheno$SSRV, pheno$SSRV == "1", "Veg")
  
  #GEM <- as_tibble(read.table("/scratch/ahc87874/Replication/CSAGEMlist.txt", sep = "\t", 
  #                                header = TRUE, stringsAsFactors = FALSE))
  phenoQC <- as_tibble(read.table("/scratch/ahc87874/Replication/phenoQC_CSA.txt", 
                                  header = TRUE, stringsAsFactors = FALSE))
  #GEM <- GEM %>% select(IID)
  phenoQC <- phenoQC %>% select(IID)
  #allelesGEM <- inner_join(pheno, GEM, by = "IID")
  alleles <- inner_join(pheno, phenoQC, by = "IID")
  
  #---------------------------------------------------------------------------------------------------------------------------------------
  #Load geno
  alleledir <- "/scratch/ahc87874/Replication/alleles/"
  pgendir <- "/scratch/ahc87874/Fall2022/pgen/"
  chrs <- c(9, 11)

  for (i in chrs) {
    geno <- as_tibble(read_delim(paste(alleledir, "chr", i, ".raw", sep = "")))
    geno <- geno %>% select(IID, starts_with("rs"), contains(":"))
    alleles <- left_join(alleles, geno)
  }
  
  #names(alleles)
  # [1] "FID"                 "IID"                 "CSRV"
  # [4] "SSRV"                "w3FA_NMR"            "w3FA_NMR_TFAP"
  # [7] "w6FA_NMR"            "w6FA_NMR_TFAP"       "w6_w3_ratio_NMR"
  #[10] "DHA_NMR"             "DHA_NMR_TFAP"        "LA_NMR"
  #[13] "LA_NMR_TFAP"         "PUFA_NMR"            "PUFA_NMR_TFAP"
  #[16] "MUFA_NMR"            "MUFA_NMR_TFAP"       "PUFA_MUFA_ratio_NMR"
  #[19] "9:140508031_A_G_A"   "rs72880701_G"        "rs1817457_A"
  #[22] "rs149996902_C"

  #Check major and minor alleles
  rsIDs <- c("rs62255849", "9:140508031_A_G", "rs72880701", "rs1817457", "rs149996902", "rs67393898")
  SNPs <- as_tibble(matrix(ncol = 5))
  names(SNPs) <- c("#CHROM", "POS", "ID", "REF", "ALT")
  for (i in chrs) {
    rs <- as_tibble(read_delim(paste(pgendir, "chr", i, ".pvar", sep = "")))
    SNPs <- rbind(SNPs, rs[rs$ID %in% rsIDs, ])
  } 
  SNPs <- SNPs[-1, ]
  SNPs
  #  `#CHROM`       POS ID              REF   ALT
  #     <dbl>     <dbl> <chr>           <chr> <chr>
  #2        9 140508031 9:140508031_A_G A     G
  #3       11  24685414 rs72880701      G     T
  #4       11  36945182 rs1817457       A     G
  #5       11  36953685 rs149996902     C     CT
  
  #majorallele_minorallele
  names(alleles)[(ncol(alleles) - 3):ncol(alleles)] <- c("rs34249205_A_G", "rs72880701_G_T", 
                                                         "rs1817457_A_G", "rs149996902_C_CT")
  
  #---------------------------------------------------------------------------------------------------------------------------------------
  #Complete cases
  #colSums(is.na(df))
  alleles <- alleles[complete.cases(alleles$w3FA_NMR), ]
  alleles <- alleles[complete.cases(alleles$rs34249205_A_G), ]
  
  #alleles %>% select(CSRV,SSRV) %>% table(useNA="always")
  #           SSRV
  #CSRV     NonVeg Veg <NA>
  #  NonVeg    460   0    0
  #  Veg         0  45  119
  #  <NA>        0   0    0
  
  write.table(alleles, file = paste("/scratch/ahc87874/Replication/alleles/PhenoGeno.txt", sep = ""),
              sep = "\t", row.names = FALSE, quote = FALSE)
} else {
  alleles <- as_tibble(read.table("/scratch/ahc87874/Replication/alleles/PhenoGeno.txt", 
                                  header = TRUE, stringsAsFactors = FALSE))
}

if (FALSE) {
  alleles2 <- alleles

  #Range for all SNPs is 0 to 2
  alleles2$rs34249205_A_G = round(alleles2$rs34249205_A_G, digits = 0)
  alleles2$rs72880701_G_T = round(alleles2$rs72880701_G_T, digits = 0)
  alleles2$rs1817457_A_G = round(alleles2$rs1817457_A_G, digits = 0)
  alleles2$rs149996902_C_CT = round(alleles2$rs149996902_C_CT, digits = 0)

  #Get minor allele %
  test <- alleles2 %>% select(starts_with("rs"))

  for (i in 1:ncol(test)) {
    print(names(test)[i])
    print(table(test[, i]))
    print(round((sum(test[, i]) / (nrow(test) * 2)), digits = 4))
  }
  #[1] "rs34249205_A_G"
  #  0   1   2
  # 28 158 438
  #[1] 0.8285
  
  #[1] "rs72880701_G_T"
  #  0   1   2
  #  4  32 588
  #[1] 0.9679
  
  #[1] "rs1817457_A_G"
  #  0   1   2
  #196 315 113
  #[1] 0.4335
  
  #[1] "rs149996902_C_CT"
  #  0   1   2
  #196 312 116
  #[1] 0.4359

  alleles3 <- alleles2 %>% mutate(rs34249205_A_G = ifelse(rs34249205_A_G == 0, "GG", ifelse(rs34249205_A_G == 2, "AA", "AG")),
                                  rs72880701_G_T = ifelse(rs72880701_G_T == 0, "TT", ifelse(rs72880701_G_T == 2, "GG", "GT")),
                                  rs1817457_A_G = ifelse(rs1817457_A_G == 0, "GG", ifelse(rs1817457_A_G == 2, "AA", "AG")),
                                  rs149996902_C_CT = ifelse(rs149996902_C_CT == 0, "CTCT", ifelse(rs149996902_C_CT == 2, "CC", "CCT")))

  write.table(alleles3, file = paste("/scratch/ahc87874/Replication/alleles/PhenoGeno2.txt", sep = ""),
                sep = "\t", row.names = FALSE, quote = FALSE)
} else {
  alleles3 <- as_tibble(read.table("/scratch/ahc87874/Replication/alleles/PhenoGeno2.txt", 
                                  header = TRUE, stringsAsFactors = FALSE))
}
#x <- c("CSRV", "w6_w3_ratio", "mmol ratio", "rs67393898", 
#       "CSRV", "w6_w3_ratio", "mmol ratio", "rs62255849",
#       "SSRV", "w6_w3_ratio", "mmol ratio", "rs72880701",
#       "SSRV", "LA_TFAP", "%", "rs1817457",
#       "SSRV", "LA_TFAP", "%", "rs149996902",
#       "SSRV", "w3FA_TFAP", "%", "rs34249205")

x <- c("Strict", "w6_w3_ratio_NMR", "mmol ratio", "rs72880701", "w6/w3 Ratio",
       "Strict", "LA_NMR_TFAP", "%", "rs1817457", "LA %",
       "Strict", "LA_NMR_TFAP", "%", "rs149996902", "LA %",
       "Strict", "w3FA_NMR_TFAP", "%", "rs34249205", "w3 %")

x <- matrix(x, ncol = 5, byrow = TRUE)

stderror <- function(x) sd(x)/sqrt(length(x))

names(alleles3)[names(alleles3) == "CSRV"] <- "Self-ID"
names(alleles3)[names(alleles3) == "SSRV"] <- "Strict"

alleles3$'Self-ID' <- factor(alleles3$'Self-ID', c("Veg", "NonVeg"))
alleles3$Strict <- factor(alleles3$Strict, c("Veg", "NonVeg"))

for (i in 1:nrow(x)) {
  print(x[i, ])
  phenoavg <- alleles3 %>% select(contains(x[i, ]))
  colnames(phenoavg) <- c("Exposure", "Phenotype", "Genotype")
  print(phenoavg)
  
  genofreq <- data.frame(table(phenoavg$Genotype))
  xlabs <- paste(genofreq$Var1, "\n(n=", genofreq$Freq, ")", sep = "")
  #should these be split by exposure too
  
  phenoavg <- phenoavg %>% filter(!is.na(Exposure)) %>% group_by(Exposure, Genotype) %>% summarise_at(vars(Phenotype), list(Mean = mean, StdE = stderror))
  phenoavg <- phenoavg %>% mutate(PhenoMax = Mean + StdE, PhenoMin = Mean - StdE)
  print(phenoavg)
  
  Expose <- x[i, 1]
  
  #Remove outlier
  #if (x[i, 2] == "w6_w3_ratio_NMR") {
  #  alleles3 <- alleles3 %>% filter(w6_w3_ratio_NMR < 90)
  #}
  
  alleles4 <- alleles3 %>% select(x[i, 1], x[i, 2], contains(x[i, 4]))
  alleles4 <- alleles4[complete.cases(alleles4), ]
  names(alleles4) <- c("Exposure", "Phenotype", "Genotype")
  
  #vertical
  boxp <- ggplot(alleles4) +
               geom_boxplot(aes(x = Genotype, y = Phenotype, fill = Exposure, color = Exposure), alpha = 0.7) +
               scale_fill_manual(name = "Exposure", labels = c("Veg", "NonVeg"), values = c("#00BA38", "#F8766D")) +
               scale_color_manual(name = "Exposure", labels = c("Veg", "NonVeg"), values = c("#004615", "#5D2C29")) +
               labs(title = paste("Distribution of", x[i, 5], "Levels\nby", x[i, 4], "In CSA"),
                    x = paste(x[i, 4], "Genotype"),
                    y = paste(x[i, 5], " (", x[i, 3], ")", sep = ""),
                    fill = paste("Exposure")) + 
               scale_x_discrete(labels = xlabs) + 
               theme(legend.position="bottom", plot.title = element_text(hjust = 0.5))
  
  png(filename = paste("alleleplots/", x[i, 2], "x", x[i, 1], "-", x[i, 4], "BoxPlotCSA.png", sep = ""), 
      type = "cairo", width = 600, height = 700, res = reso)
  print(boxp)
  dev.off()
  
  #horizontal
  boxp2 <- ggplot(alleles4) +
               geom_boxplot(aes(x = Genotype, y = Phenotype, fill = Exposure, color = Exposure), alpha = 0.7) +
               scale_fill_manual(name = "Exposure", labels = c("Veg", "NonVeg"), values = c("#00BA38", "#F8766D")) +
               scale_color_manual(name = "Exposure", labels = c("Veg", "NonVeg"), values = c("#004615", "#5D2C29")) +
               labs(title = paste("Distribution of", x[i, 5], "Levels\nbyy", x[i, 4], "In CSA"),
                    x = paste(x[i, 4], "Genotype"),
                    y = paste(x[i, 5], " (", x[i, 3], ")", sep = ""),
                    fill = paste("Exposure")) + 
               scale_x_discrete(labels = xlabs) + 
               theme(legend.position="bottom", plot.title = element_text(hjust = 0.5)) + 
               coord_flip()
  
  png(filename = paste("alleleplots/", x[i, 2], "x", x[i, 1], "-", x[i, 4], "BoxPlotHorizCSA.png", sep = ""), 
      type = "cairo", width = 600, height = 700, res = reso)
  print(boxp2)
  dev.off()

  #horizontal legend on side
  boxp3 <- ggplot(alleles4) +
               geom_boxplot(aes(x = Genotype, y = Phenotype, fill = Exposure, color = Exposure), alpha = 0.7) +
               scale_fill_manual(name = "Exposure", labels = c("Veg", "NonVeg"), values = c("#00BA38", "#F8766D")) +
               scale_color_manual(name = "Exposure", labels = c("Veg", "NonVeg"), values = c("#004615", "#5D2C29")) +
               labs(title = paste("Distribution of", x[i, 5], "Levels by", x[i, 4], "In CSA"),
                    x = paste(x[i, 4], "Genotype"),
                    y = paste(x[i, 5], " (", x[i, 3], ")", sep = ""),
                    fill = paste("Exposure")) + 
               scale_x_discrete(labels = xlabs) + 
               theme(legend.position="right", plot.title = element_text(hjust = 0.5)) + 
               coord_flip()
  
  png(filename = paste("alleleplots/", x[i, 2], "x", x[i, 1], "-", x[i, 4], "BoxPlotHoriz2CSA.png", sep = ""), 
      type = "cairo", width = 600, height = 700, res = reso)
  print(boxp3)
  dev.off()
}
  

#w6_w3_ratioxCSRV = rs67393898
#w6_w3_ratioxCSRV = rs62255849
#w6_w3_ratioxSSRV = rs72880701
#LA_TFAPxSSRV = rs1817457
#LA_TFAPxSSRV = rs149996902
#w3FA_TFAPxSSRV = rs34249205
