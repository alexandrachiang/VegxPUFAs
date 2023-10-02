library(tidyverse)
library(qqman)

source("/work/kylab/alex/Fall2022/ManhattanCex.R")

setwd("/scratch/ahc87874/Fall2022/")

phenos <- c("w3FA_NMR", "w3FA_NMR_TFAP", "w6FA_NMR", "w6FA_NMR_TFAP", "w6_w3_ratio_NMR", 
            "DHA_NMR", "DHA_NMR_TFAP", "LA_NMR", "LA_NMR_TFAP", "PUFA_NMR", "PUFA_NMR_TFAP",
            "MUFA_NMR", "MUFA_NMR_TFAP", "PUFA_MUFA_ratio_NMR")
types <- c("LeveneMean", "LeveneMed") #"Bartlett", "FlignerKilleen")

for (j in types) {
	for (i in phenos) {
	    dir <- "/scratch/ahc87874/Fall2022/vQTL/"
		  print(paste("type:", j))
	    print(paste("pheno:", i))

      if (TRUE) { #Combine GEM output for pheno and exposure from chr 1-22 into one data frame
        for (k in 1:22) {
          print(paste("chr:", k))
          infile <- as_tibble(read.table(paste(dir, "/", j, "/vQTL_", j, "_chr", k, "_", i, ".vqtl", sep = ""), 
                                         header = TRUE, stringsAsFactors = FALSE))

          #Subset data
          infilesub <- infile %>% select(Chr, bp, P, SNP)

          #Get qqman format
          colnames(infilesub) <- c("CHR", "BP", "P", "SNP")

          #Add to input
          if (k == 1) {
            infileall <- infilesub
          } else {
            infileall <- rbind(infileall, infilesub)
          } #ifelse
        } #k chr number

        #Save data table of all chr for pheno x exposure
        outdir = paste("/scratch/ahc87874/Fall2022/vQTL/", j, "/", sep="")
        
        write.table(infileall, paste(outdir, "vQTL_", i, "_", j, ".txt", sep = ""), 
                    row.names = FALSE, quote = FALSE)
      } else {
        infileall <- as_tibble(read.table(paste("/scratch/ahc87874/Fall2022/vQTL/", j, "/vQTL_", i, "_", j, ".txt", sep = ""), 
                                          header = TRUE, stringsAsFactors = FALSE))
	    }
      
	    #infileall <- infileall %>% select(CHR, POS, robust_P_Value_Interaction, RSID)
	    #colnames(infileall) <- c("CHR", "BP", "P", "SNP")

      infileall$P[infileall$P < 1e-20] <- 1e-20
      infileall <- infileall[complete.cases(infileall),]

      print(paste(j, i))
      print("Manhattan")
      #Make manhattan plot
      outdirman = paste("/scratch/ahc87874/Fall2022/manplots/", j, "/", sep = "")
      png(filename = paste(outdirman, "vQTL_", i, "_", j, "_man.png", sep = ""), type = "cairo", width = 1500, height = 750, res = 110)
      manhattancex(infileall, suggestiveline = -log10(5e-05), genomewideline = -log10(5e-08), #col = colors,
                   main = paste("Manhattan Plot of", i, "GWIS", sep = " "), annotatePval = 5e-5, #ylim = c(0, -log10(1e-32)), 
                   annofontsize = 1, cex.axis = 1.3, cex.lab = 1.3, cex.main = 1.7)
      dev.off()

      print("QQ")
      #Make qq plot
      outdirqq = paste("/scratch/ahc87874/Fall2022/qqplots/", j, "/", sep = "")
	    
      png(filename = paste(outdirqq, "vQTL_", i, "_", j, "_qq.png", sep = ""), type = "cairo", width = 600, height = 600)
      qq(infileall$P, main = paste("Q-Q Plot of", i, "P-Values", sep = " "))
      dev.off()
      
  } #i phenos
} #j types
