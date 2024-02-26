library(tidyverse)

setwd("/scratch/ahc87874/Fall2022/")
reso <- 135

if (FALSE) {
  #---------------------------------------------------------------------------------------------------------------------------------------
  #Load pheno
  suffix <- "combRAW" #Not normalized

  pheno <- as_tibble(read.table(paste("/scratch/ahc87874/Fall2022/pheno/GEMphenoVeg", suffix, ".txt", sep = ""), 
                                  header = TRUE, stringsAsFactors = FALSE))
  
  pheno <- pheno %>% select(-Sex, -Age, -AgeSex, -starts_with("PC"))

  pheno$Vegetarian <- as.character(pheno$Vegetarian)
  pheno$Vegetarian <- replace(pheno$Vegetarian, pheno$Vegetarian == "0", "NonVeg")
  pheno$Vegetarian <- replace(pheno$Vegetarian, pheno$Vegetarian == "1", "Veg")

  alleles <- pheno
  #---------------------------------------------------------------------------------------------------------------------------------------
  #Load geno
  alleledir <- "/scratch/ahc87874/Fall2022/alleles/"
  pgendir <- "/scratch/ahc87874/Fall2022/pgen/"
  chrs <- c(2, 8)

  for (i in chrs) {
    geno <- as_tibble(read_delim(paste(alleledir, "chr", i, "SNP_Comb.raw", sep = "")))
    geno <- geno %>% select(IID, starts_with("rs"), contains(":"))
    alleles <- left_join(alleles, geno)
  }

  #names(alleles)
  # [1] "FID"             "IID"             "Vegetarian"      "w3FA"
  # [5] "w3FA_TFAP"       "w6FA"            "w6FA_TFAP"       "w6_w3_ratio"
  # [9] "DHA"             "DHA_TFAP"        "LA"              "LA_TFAP"
  #[13] "PUFA"            "PUFA_TFAP"       "MUFA"            "MUFA_TFAP"
  #[17] "PUFA_MUFA_ratio" "rs80103778_C"    "rs4873543_A"     "rs6985833_G"

  #Check major and minor alleles
  rsIDs <- c("rs80103778_C", "rs4873543_A", "rs6985833_G")
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
  #1        3  24215321 rs62255849      T     C
  #2        9 140508031 9:140508031_A_G A     G
  #3       11  24685414 rs72880701      G     T
  #4       11  36945182 rs1817457       A     G #Different for Europeans, switch for major/minor
  #5       11  36953685 rs149996902     C     CT #Different for Europeans, switch for major/minor
  #6       13  98799253 rs67393898      G     T

  #RSID	      CHR	POS	    Non_Effect_Allele	Effect_Allele
  #rs80103778	2	85067224	C	G
  #rs4873543	8	52231394	A	G
  #rs6985833	8	52486885	G	T

  #majorallele_minorallele
  names(alleles)[(ncol(alleles) - 2):ncol(alleles)] <- c("rs80103778_G_C", "rs4873543_G_A", "rs6985833_T_G")
  
  #---------------------------------------------------------------------------------------------------------------------------------------
  #Complete cases
  #colSums(is.na(df))
  #alleles <- alleles[complete.cases(alleles$w3FA), ]
  #alleles <- alleles[complete.cases(alleles$rs62255849_T_C), ]
  
  write.table(alleles, file = paste("/scratch/ahc87874/Fall2022/alleles/PhenoGenoComb.txt", sep = ""),
              sep = "\t", row.names = FALSE, quote = FALSE)
} else {
  alleles <- as_tibble(read.table("/scratch/ahc87874/Fall2022/alleles/PhenoGenoComb.txt", 
                                  header = TRUE, stringsAsFactors = FALSE))
}

if (FALSE) {
  alleles2 <- alleles

  #Range for all SNPs is 0 to 2
  alleles2$rs80103778_G_C = round(alleles2$rs80103778_G_C, digits = 0)
  alleles2$rs4873543_G_A = round(alleles2$rs4873543_G_A, digits = 0)
  alleles2$rs6985833_T_G = round(alleles2$rs6985833_T_G, digits = 0)

  #Get minor allele %
  test <- alleles2 %>% select(starts_with("rs"))

  for (i in 1:ncol(test)) {
    print(names(test)[i])
    print(table(test[, i]))
    print(round((sum(test[, i]) / (nrow(test) * 2)), digits = 4))
  }
  #[1] "rs80103778_G_C"
  #rs80103778_G_C
  #    0     1     2
  #69454 13238   672
  #[1] 0.0875
  #[1] "rs4873543_G_A"
  #rs4873543_G_A
  #    0     1     2
  #45264 32296  5804
  #[1] 0.2633
  #[1] "rs6985833_T_G"
  #rs6985833_T_G
  #    0     1     2
  #42549 33981  6834
  #[1] 0.2858

  #0 = homozygous major/ref
  #0 = homozygous minor/alt
  
  alleles3 <- alleles2 %>% mutate(rs80103778_G_C = ifelse(rs80103778_G_C == 0, "GG", ifelse(rs80103778_G_C == 2, "CC", "GC")),
                                  rs4873543_G_A = ifelse(rs4873543_G_A == 0, "GG", ifelse(rs4873543_G_A == 2, "AA", "GA")),
                                  rs6985833_T_G = ifelse(rs6985833_T_G == 0, "TT", ifelse(rs6985833_T_G == 2, "GG", "TG")))

  #alleles3 %>% select(rs1817457_G_A, rs149996902_CT_C) %>% table()
  #             rs149996902_CT_C
  #rs1817457_G_A    CC   CCT  CTCT
  #           AA  3073    53     3
  #           GA    51 15000   150
  #           GG     0   117 18659

  write.table(alleles3, file = paste("/scratch/ahc87874/Fall2022/alleles/PhenoGenoComp2.txt", sep = ""),
                sep = "\t", row.names = FALSE, quote = FALSE)
} else {
  alleles3 <- as_tibble(read.table("/scratch/ahc87874/Fall2022/alleles/PhenoGenoComp2.txt", 
                                  header = TRUE, stringsAsFactors = FALSE))
}
#x <- c("CSRV", "w6_w3_ratio", "mmol ratio", "rs67393898", 
#       "CSRV", "w6_w3_ratio", "mmol ratio", "rs62255849",
#       "SSRV", "w6_w3_ratio", "mmol ratio", "rs72880701",
#       "SSRV", "LA_TFAP", "%", "rs1817457",
#       "SSRV", "LA_TFAP", "%", "rs149996902",
#       "SSRV", "w3FA_TFAP", "%", "rs34249205")

x <- c("DHA", "mmol/l", "rs4873543", "DHA",
       "PUFA", "mmol/l	", "rs80103778", "PUFA",
       "w3FA_TFAP", "%", "rs4873543", "w3 %",
       "w3FA", "mmol/l	", "rs6985833", "w3")

x <- matrix(x, ncol = 4, byrow = TRUE)

stderror <- function(x) sd(x)/sqrt(length(x))

alleles3$Vegetarian <- factor(alleles3$Vegetarian, c("Veg", "NonVeg"))
alleles3$rs80103778_G_C <- factor(alleles3$rs80103778_G_C, c("GG", "GC", "CC"))
alleles3$rs4873543_G_A <- factor(alleles3$rs4873543_G_A, c("GG", "GA", "AA"))
alleles3$rs6985833_T_G <- factor(alleles3$rs6985833_T_G, c("TT", "TG", "GG"))

##########################################################################################
for (i in 1:nrow(x)) {
  print(x[i, ])
  phenoavg <- alleles3 %>% select(contains(x[i, ]))
  colnames(phenoavg) <- c("Exposure", "Phenotype", "Genotype")
  print(phenoavg)
  
  genofreq <- data.frame(table(phenoavg$Genotype[!is.na(phenoavg$Exposure)]))
  xlabs <- paste(genofreq$Var1, "\n(n=", genofreq$Freq, ")", sep = "")
  #should these be split by exposure too
  
  phenoavg <- phenoavg %>% filter(!is.na(Exposure)) %>% group_by(Exposure, Genotype) %>% summarise_at(vars(Phenotype), list(Mean = mean, StdE = stderror))
  phenoavg <- phenoavg %>% mutate(PhenoMax = Mean + StdE, PhenoMin = Mean - StdE)
  print(phenoavg)
  
  Expose <- x[i, 1]
  
  avgplot <- ggplot(phenoavg) + 
               geom_bar(aes(x = Genotype, y = Mean, fill = Exposure), color = "black", stat = "identity", position = position_dodge(), alpha = 0.7) +
               geom_errorbar(aes(x = Genotype, ymin = PhenoMin, ymax = PhenoMax, fill = Exposure), colour = "black", width = 0.3, 
                             position = position_dodge(0.9), stat = "identity") + 
               scale_fill_manual(values = c("#00BA38", "#F8766D")) +
               labs(title = paste("Average", x[i, 5], "Levels\nby", x[i, 4]),
                    x = paste(x[i, 4], "Genotype"),
                    y = paste(x[i, 5], " (", x[i, 3], ")", sep = ""),
                    fill = paste(Expose, "Exposure")) + 
               scale_x_discrete(labels = xlabs) + 
               coord_cartesian(ylim = c(min(phenoavg$PhenoMin) - 0.5, max(phenoavg$PhenoMax) + 0.5))
               
  png(filename = paste("alleleplotsComb/", x[i, 2], "x", x[i, 1], "-", x[i, 4], ".png", sep = ""), type = "cairo", width = 700, height = 700)
  print(avgplot)
  dev.off()
  
  alleles4 <- alleles3 %>% select(x[i, 1], x[i, 2], contains(x[i, 4]))
  alleles4 <- alleles4[complete.cases(alleles4), ]
  names(alleles4) <- c("Exposure", "Phenotype", "Genotype")
  
  #medNonVeg <- signif(median(alleles4$TotalCholesterol[pheno$CSRV=="Non-Vegetarian"], na.rm=TRUE), digits = 5)
  #medVeg <- signif(median(alleles4$TotalCholesterol[pheno$CSRV=="Vegetarian"], na.rm=TRUE), digits = 5)
  
  #vertical
  boxp <- ggplot(alleles4) +
               geom_boxplot(aes(x = Genotype, y = Phenotype, fill = Exposure, color = Exposure), alpha = 0.7) +
               scale_fill_manual(name = "Exposure", labels = c("Veg", "NonVeg"), values = c("#00BA38", "#F8766D")) +
               scale_color_manual(name = "Exposure", labels = c("Veg", "NonVeg"), values = c("#004615", "#5D2C29")) +
               labs(title = paste("Distribution of", x[i, 5], "Levels\nby", x[i, 4]),
                    x = paste(x[i, 4], "Genotype"),
                    y = paste(x[i, 5], " (", x[i, 3], ")", sep = ""),
                    fill = paste("Exposure")) + 
               scale_x_discrete(labels = xlabs) + 
               theme(legend.position="bottom", plot.title = element_text(hjust = 0.5))
  
  png(filename = paste("alleleplotsComb/", x[i, 2], "x", x[i, 1], "-", x[i, 4], "BoxPlot.png", sep = ""), 
      type = "cairo", width = 700, height = 700, res = reso)
  print(boxp)
  dev.off()
  
  #horizontal
  boxp2 <- ggplot(alleles4) +
               geom_boxplot(aes(x = Genotype, y = Phenotype, fill = Exposure, color = Exposure), alpha = 0.7) +
               scale_fill_manual(name = "Exposure", labels = c("Veg", "NonVeg"), values = c("#00BA38", "#F8766D")) +
               scale_color_manual(name = "Exposure", labels = c("Veg", "NonVeg"), values = c("#004615", "#5D2C29")) +
               labs(title = paste("Distribution of", x[i, 5], "Levels\nby", x[i, 4]),
                    x = paste(x[i, 4], "Genotype"),
                    y = paste(x[i, 5], " (", x[i, 3], ")", sep = ""),
                    fill = paste("Exposure")) + 
               scale_x_discrete(labels = xlabs) + 
               theme(legend.position="bottom", plot.title = element_text(hjust = 0.5)) + 
               coord_flip()
  
  png(filename = paste("alleleplotsComb/", x[i, 2], "x", x[i, 1], "-", x[i, 4], "BoxPlotHoriz.png", sep = ""), 
      type = "cairo", width = 700, height = 700, res = reso)
  print(boxp2)
  dev.off()

  #horizontal legend on side
  boxp3 <- ggplot(alleles4) +
               geom_boxplot(aes(x = Genotype, y = Phenotype, fill = Exposure, color = Exposure), alpha = 0.7) +
               scale_fill_manual(name = "Exposure", labels = c("Veg", "NonVeg"), values = c("#00BA38", "#F8766D")) +
               scale_color_manual(name = "Exposure", labels = c("Veg", "NonVeg"), values = c("#004615", "#5D2C29")) +
               labs(title = paste("Distribution of", x[i, 5], "Levels\nby", x[i, 4]),
                    x = paste(x[i, 4], "Genotype"),
                    y = paste(x[i, 5], " (", x[i, 3], ")", sep = ""),
                    fill = paste("Exposure")) + 
               scale_x_discrete(labels = xlabs) + 
               theme(legend.position="right", plot.title = element_text(hjust = 0.5)) + 
               coord_flip()
  
  png(filename = paste("alleleplotsComb/", x[i, 2], "x", x[i, 1], "-", x[i, 4], "BoxPlotHoriz2.png", sep = ""), 
      type = "cairo", width = 700, height = 700, res = reso)
  print(boxp3)
  dev.off()
}
  

#w6_w3_ratioxCSRV = rs67393898
#w6_w3_ratioxCSRV = rs62255849
#w6_w3_ratioxSSRV = rs72880701
#LA_TFAPxSSRV = rs1817457
#LA_TFAPxSSRV = rs149996902
#w3FA_TFAPxSSRV = rs34249205
