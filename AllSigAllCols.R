library(tidyverse)

setwd("/scratch/ahc87874/Fall2022/CombinedAllCol/")

phenonames <- c("w3FA_NMR", "w3FA_NMR_TFAP", "w6FA_NMR", "w6FA_NMR_TFAP", "w6_w3_ratio_NMR", "DHA_NMR", 
            "DHA_NMR_TFAP", "LA_NMR", "LA_NMR_TFAP", "PUFA_NMR", "PUFA_NMR_TFAP", "MUFA_NMR", 
            "MUFA_NMR_TFAP", "PUFA_MUFA_ratio_NMR")
phenos <- c("w3FA", "w3FA_TFAP", "w6FA", "w6FA_TFAP", "w6_w3_ratio", "DHA", 
            "DHA_TFAP", "LA", "LA_TFAP", "PUFA", "PUFA_TFAP", "MUFA", 
            "MUFA_TFAP", "PUFA_MUFA_ratio")
            
exposures <- "SSRV"
suffix <- "wKeep"

for (i in length(phenos)) {
  print(paste("pheno:", phenos[i]))
  infile <- as_tibble(read.table(paste(phenonames[i], "x", exposures, suffix, ".txt", sep = ""), 
                                       header = TRUE, stringsAsFactors = FALSE))

  #Add to input
  if (i == 1) {
    infileall <- infilesub
  } else {
    infileall <- rbind(infileall, infilesub)
  } #ifelse  
}



outdir = "/scratch/ahc87874/Fall2022/CombinedAllCol/"
write.table(infileall, paste(outdir, "AllSigAllCols.txt", sep = ""), row.names = FALSE, quote = FALSE, sep = "\t")
