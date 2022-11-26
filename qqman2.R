#source("/work/kylab/alex/Fall2022/qqman.R")
library(tidyverse)
library(qqman)

source("ManhattanCex.R")

setwd("/scratch/ahc87874/Fall2022/")

suffix <- ""
#"" "woCred" "wKeep"

phenos <- c("w3FA_NMR", "w3FA_NMR_TFAP", "w6FA_NMR", "w6FA_NMR_TFAP", "w6_w3_ratio_NMR", "DHA_NMR", 
	    "DHA_NMR_TFAP", "LA_NMR", "LA_NMR_TFAP", "PUFA_NMR", "PUFA_NMR_TFAP", "MUFA_NMR", 
	    "MUFA_NMR_TFAP", "PUFA_MUFA_ratio_NMR")

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
    infileall <- as_tibble(read.table(paste("/scratch/ahc87874/Fall2022/FUMA/", i, "x", j, suffix, "all.txt", sep = ""), 
                                      header = TRUE, stringsAsFactors = FALSE))
    
    print("QQ")
    #Make qq plot
    outdirqq = "/scratch/ahc87874/Fall2022/qqplots/"
    png(filename = paste(outdirqq, i, "x", j, suffix, "qq.png", sep = ""), type = "cairo", 
        width = 600, height = 600)
    qq(infileall$P, main = paste("Q-Q plot of ", i, "x", j, " GWIS p-values", sep = ""))
    dev.off()
  } #j exposures
} #i phenos

#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
