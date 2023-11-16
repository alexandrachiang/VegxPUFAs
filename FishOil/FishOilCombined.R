#Combine GEM results for all 22 chr into one file

library(tidyverse)
library(scales)

setwd("/scratch/ahc87874/FishOil/")
	
phenos <- c("w3FA", "w3FA_TFAP", "w6FA", "w6FA_TFAP", "w6_w3_ratio", "DHA", "DHA_TFAP", "LA", 
	    "LA_TFAP", "PUFA", "PUFA_TFAP", "MUFA", "MUFA_TFAP", "PUFA_MUFA_ratio")
phenos <- c("w3FA")
exposures <- c("Fish_oil_baseline")

suffix <- c("comb", "phase1", "phase2")

#Combine chr into pheno x exposure
for (m in suffix) {
  for (i in phenos) {
    GEMdir <- paste("/scratch/ahc87874/FishOil/GEM", m, sep = "")

    print(paste("pheno:", i))

    for (j in exposures) {
      print(paste("exposure:", j))
      if (TRUE) { #Combine GEM output for pheno and exposure from chr 1-22 into one data frame
        for (k in 1:22) {
          print(paste("chr:", k))
          infile <- as_tibble(read.table(paste(GEMdir, i, paste(i, "x", j, "-chr", k, sep = ""), sep = "/"), 
                                         header = TRUE, stringsAsFactors = FALSE))

          #Subset data
          infilesub <- infile

          #Add to input
          if (k == 1) {
            infileall <- infilesub
          } else {
            infileall <- rbind(infileall, infilesub)
          } #ifelse
        } #k chr number

        #Save data table of all chr for pheno x exposure
        outdir = "/scratch/ahc87874/FishOil/Combined/"
        write.table(infileall, paste(outdir, i, "x", j, "FishOil", m, ".txt", sep = ""), 
                    row.names = FALSE, quote = FALSE, sep = "\t")
      } else {
        infileall <- as_tibble(read.table(paste("/scratch/ahc87874/FishOil/Combined/", i, "x", j, "FishOil", m, ".txt", sep = ""), 
                                          header = TRUE, stringsAsFactors = FALSE))
      } 
    } #exposures
  } #phenos
} #suffix
