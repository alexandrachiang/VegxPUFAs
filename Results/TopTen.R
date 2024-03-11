library(tidyverse)
library(qqman)

setwd("/scratch/ahc87874/Fall2022/")

allsuffix <- c("phase1", "phase2", "comb")
	
phenos <- c("w3FA", "w3FA_TFAP", "w6FA", "w6FA_TFAP", "w6_w3_ratio", "DHA", 
            "DHA_TFAP", "LA", "LA_TFAP", "PUFA", "PUFA_TFAP", "MUFA", 
            "MUFA_TFAP", "PUFA_MUFA_ratio")

exposures <- c("VegetarianVeg")

for (suffix in allsuffix) {
  print(paste("phase:", suffix))
  for (i in phenos) {

    print(paste("pheno:", i))

    for (j in exposures) {
      print(paste("exposure:", j))
      infileall <- as_tibble(read.table(paste("/scratch/ahc87874/Fall2022/Combined/", i, "x", j, suffix, ".txt", sep = ""), 
                                          header = TRUE, stringsAsFactors = FALSE))
	    
	    infileall <- infileall %>% select(CHR, POS, robust_P_Value_Interaction, RSID)
	    colnames(infileall) <- c("CHR", "BP", "P", "SNP")
      
      print("SNPs")
      #Make table of sig SNPs (P < 1e-5)
      outdirSNPs = "/scratch/ahc87874/Phase/SNPs/"
      sigSNPs <- infileall %>% filter(P <= 1e-5)
      write.table(sigSNPs, paste(outdirSNPs, i, "x", j, suffix, "sigSNPs.txt", sep = ""),
                  row.names = FALSE, quote = FALSE)

      #Make table of top 10 SNPs
      newdata <- infileall[order(infileall$P), ]
      newdata <- newdata[1:10, ]
      write.table(newdata, paste(outdirSNPs, i, "x", j, suffix, "topSNPs.txt", sep = ""),
                  row.names = FALSE, quote = FALSE)
    } #j exposures
  } #i phenos
} #suffix
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
