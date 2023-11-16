#source("/work/kylab/alex/Fall2022/qqman.R")
library(tidyverse)
library(qqman)

source("ManhattanCex.R")

setwd("/scratch/ahc87874/FishOil/")
	
phenos <- c("w3FA", "w3FA_TFAP", "w6FA", "w6FA_TFAP", "w6_w3_ratio", "DHA", 
            "DHA_TFAP", "LA", "LA_TFAP", "PUFA", "PUFA_TFAP", "MUFA", 
            "MUFA_TFAP", "PUFA_MUFA_ratio")
phenos <- c("w3FA")
exposures <- c("Fish_oil_baseline")

suffix <- c("comb", "phase1", "phase2")

for (k in suffix) {
  print(paste("suffix:", m))

	for (i in phenos) {
    print(paste("pheno:", i))

    for (j in exposures) {
      print(paste("exposure:", j))
     
      infileall <- as_tibble(read.table(paste("/scratch/ahc87874/FishOil/Combined/", i, "x", j, "FishOil", k, ".txt", sep = ""), 
                                          header = TRUE, stringsAsFactors = FALSE))
	    
	    infileall <- infileall %>% select(CHR, POS, robust_P_Value_Interaction, RSID)
	    colnames(infileall) <- c("CHR", "BP", "P", "SNP")

      print("SNPs")
      #Make table of sig SNPs (P < 1e-5)
      outdirSNPs = "/scratch/ahc87874/FishOil/SNPs/"
      sigSNPs <- infileall %>% filter(P <= 1e-5)
      write.table(sigSNPs, paste(outdirSNPs, i, "x", j, k, "sigSNPs.txt", sep = ""),
                  row.names = FALSE, quote = FALSE)
  
      #Make table of top 10 SNPs
      newdata <- infileall[order(infileall$P), ]
      newdata <- newdata[1:10, ]
      write.table(newdata, paste(outdirSNPs, i, "x", j, k, "topSNPs.txt", sep = ""),
                  row.names = FALSE, quote = FALSE)
  
      pvalue <- newdata$P[10]
            
      print("Manhattan")
      #Make manhattan plot
      outdirman = "/scratch/ahc87874/FishOil/manplots/"
      expo = "Fish Oil"
	    
      maxy <- -log10(5e-08)
      if (newdata$P[1] < 5e-08) {
        maxy <- -log10(newdata$P[1])
      }
	    
      png(filename = paste(outdirman, i, "x", j, "_FishOil_", k, "_man.png", sep = ""), type = "cairo", width = 1200, height = 600)
      manhattancex(infileall, suggestiveline = -log10(1e-05), genomewideline = -log10(5e-08),
                   main = paste("Manhattan Plot of ", i, " x ", expo, " GWIS", sep = ""), annotatePval = 1e-5, ylim = c(0, maxy + 0.15), 
                   annofontsize = 1, cex.axis = 1.3, cex.lab = 1.3, cex.main = 1.7)
      dev.off()     

      print("QQ")
      #Make qq plot
      outdirqq = "/scratch/ahc87874/FishOil/qqplots/"
	    
      png(filename = paste(outdirqq, i, "x", j, "_FishOil_", k, "_qq.png", sep = ""), type = "cairo", width = 600, height = 600)
      qq(infileall$P, main = paste("Q-Q plot of ", i, " x ", expo, " GWIS p-values", sep = ""))
      dev.off()
     
    } #j exposures
  } #i phenos
} #k suffix
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
