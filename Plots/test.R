#source("/work/kylab/alex/Fall2022/qqman.R")
library(tidyverse)
library(qqman)

source("/work/kylab/alex/Fall2022/ManhattanCex.R")

setwd("/scratch/ahc87874/Fall2022/")
	
phenos <- c("w3FA", "w3FA_TFAP", "MUFA_TFAP", "PUFA_MUFA_ratio")

exposures <- c("Vegetarian")

suffix <- c("combredo") #, "phase1", "phase2"

for (k in suffix) {
  print(paste("suffix:", k))

	for (i in phenos) {
    print(paste("pheno:", i))

    for (j in exposures) {
      print(paste("exposure:", j))
     
      infileall <- as_tibble(read.table(paste("/scratch/ahc87874/Fall2022/CombinedRedo/", i, "x", j, "Veg", k, ".txt", sep = ""), 
                                          header = TRUE, stringsAsFactors = FALSE))
	    
	    infileall <- infileall %>% select(CHR, POS, robust_P_Value_Interaction, RSID)
	    colnames(infileall) <- c("CHR", "BP", "P", "SNP")

      print("SNPs")	    
     
      print("Manhattan")
      #Make manhattan plot
      outdirman = "/scratch/ahc87874/Fall2022/manplotsRedo/"
      expo = "Vegetarianism"
	    
      maxy <- -log10(5e-08)
      if (newdata$P[1] < 5e-08) {
        maxy <- -log10(newdata$P[1])
      }
	    
      png(filename = paste(outdirman, k, "/", i, "x", j, "_Veg_", k, "_man.png", sep = ""), type = "cairo", width = 1200, height = 600)
      manhattancex(infileall, suggestiveline = -log10(1e-05), genomewideline = -log10(5e-08),
                   main = paste("Manhattan Plot of ", i, " x ", j, " GWIS", sep = ""), annotatePval = 1e-5, ylim = c(0, maxy + 0.15), 
                   annofontsize = 1, cex.axis = 1.3, cex.lab = 1.3, cex.main = 1.7)
      dev.off()     

      print("QQ")
      #Make qq plot
      outdirqq = "/scratch/ahc87874/Fall2022/qqplotsRedo/"
	    
      png(filename = paste(outdirqq, k, "/", i, "x", j, "_Veg_", k, "_qq.png", sep = ""), type = "cairo", width = 600, height = 600)
      qq(infileall$P, main = paste("Q-Q plot of ", i, " x ", j, " GWIS p-values", sep = ""))
      dev.off()
     
    } #j exposures
  } #i phenos
} #k suffix
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
