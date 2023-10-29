#Combine GEM results for all 22 chr into one file

library(tidyverse)
library(scales)

setwd("/scratch/ahc87874/FishOil/")
	
phenos <- c("w3FA_NMR", "w3FA_NMR_TFAP", "w6FA_NMR", "w6FA_NMR_TFAP", "w6_w3_ratio_NMR", "DHA_NMR", 
            "DHA_NMR_TFAP", "LA_NMR", "LA_NMR_TFAP", "PUFA_NMR", "PUFA_NMR_TFAP", "MUFA_NMR", 
            "MUFA_NMR_TFAP", "PUFA_MUFA_ratio_NMR")

exposures <- c("Fish_oil_baseline")

#Combine chr into pheno x exposure
for (i in phenos) {
    GEMdir <- "/scratch/ahc87874/FishOil/GEM"

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
        write.table(infileall, paste(outdir, i, "x", j, "alltab.txt", sep = ""), 
                    row.names = FALSE, quote = FALSE, sep = "\t")
	#write.table(infileall, paste(outdir, i, "x", j, suffix, "all.txt", sep = ""), 
        #            row.names = FALSE, quote = FALSE)
      } else {
        infileall <- as_tibble(read.table(paste("/scratch/ahc87874/FishOil/Combined/", i, "x", j, "all.txt", sep = ""), 
                                          header = TRUE, stringsAsFactors = FALSE))
      } 
    } #exposures
  } #phenos
