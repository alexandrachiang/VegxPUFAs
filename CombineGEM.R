library(tidyverse)
library(scales)

setwd("/scratch/ahc87874/Fall2022/")

#allsuffix <- c("", "woCred", "wKeep")
allsuffix <- c("wKeep")
	
phenos <- c("w3FA_NMR", "w3FA_NMR_TFAP", "w6FA_NMR", "w6FA_NMR_TFAP", "w6_w3_ratio_NMR", "DHA_NMR", 
            "DHA_NMR_TFAP", "LA_NMR", "LA_NMR_TFAP", "PUFA_NMR", "PUFA_NMR_TFAP", "MUFA_NMR", 
            "MUFA_NMR_TFAP", "PUFA_MUFA_ratio_NMR")

exposures <- c("CSRV", "SSRV")
#phenos <- c("w3FA", "w3FA_TFAP", "w6FA", "w6FA_TFAP", "w6_w3_ratio", "DHA", 
#            "DHA_TFAP", "LA", "LA_TFAP", "PUFA", "PUFA_TFAP", "MUFA", 
#            "MUFA_TFAP", "PUFA_MUFA_ratio")
#phenos <- c("w3FA_TFAP", "w6_w3_ratio", "LA_TFAP")

for (suffix in allsuffix) {
  #if (suffix == "") {
  #  
  #} else {
  #  exposures <- c("SSRV")
  #}
  
  for (i in phenos) {
    GEMdir <- paste("/scratch/ahc87874/Fall2022/GEM", suffix, sep = "")

    print(paste("pheno:", i))

    for (j in exposures) {
      print(paste("exposure:", j))
      if (TRUE) { #Combine GEM output for pheno and exposure from chr 1-22 into one data frame
        for (k in 1:22) {
          print(paste("chr:", k))
          infile <- as_tibble(read.table(paste(GEMdir, i, paste(i, "x", j, "-chr", k, sep = ""), sep = "/"), 
                                         header = TRUE, stringsAsFactors = FALSE))

          #Subset data
          infilesub <- infile %>% select(CHR, POS, robust_P_Value_Interaction, starts_with("Beta_G"), RSID)

          #Add to input
          if (k == 1) {
            infileall <- infilesub
          } else {
            infileall <- rbind(infileall, infilesub)
          } #ifelse
        } #k chr number

        #Save data table of all chr for pheno x exposure
        outdir = "/scratch/ahc87874/Fall2022/Combined/"
        write.table(infileall, paste(outdir, i, "x", j, suffix, "all.txt", sep = ""), 
                    row.names = FALSE, quote = FALSE)
      } else {
        infileall <- as_tibble(read.table(paste("/scratch/ahc87874/Fall2022/Combined/", i, "x", j, suffix, "all.txt", sep = ""), 
                                          header = TRUE, stringsAsFactors = FALSE))
      } 
    } #exposures
  } #phenos
} #suffix

#Combine all results into one df
exposures <- c("CSRV", "SSRV")

for (suffix in allsuffix) {
  infileall <- as_tibble(matrix(ncol = 7))
  colnames(infileall) <- c("Phenotype", "Exposure", "CHR", "POS", "robust_P_Value_Interaction", "Beta_G", "RSID")
  
  for (i in phenos) {
    Combineddir <- paste("/scratch/ahc87874/Fall2022/Combined/", sep = "")

    print(paste("pheno:", i))

    for (j in exposures) {
      print(paste("exposure:", j))
      
	    if (j == "CSRV") {
        infile <- as_tibble(read.table(paste(Combineddir, i, "x", j, "all.txt", sep = ""), 
                                     header = TRUE, stringsAsFactors = FALSE))
      } else {
        infile <- as_tibble(read.table(paste(Combineddir, i, "x", j, suffix, "all.txt", sep = ""), 
                                     header = TRUE, stringsAsFactors = FALSE))
      }
	    colnames(infile)[4] <- "Beta_G"
      infile <- infile %>% mutate(Phenotype = i, Exposure = j) %>% select(Phenotype, Exposure, everything())
      
      infileall <- rbind(infileall, infile)
    } #exposures
  } #phenos
  infileall <- infileall[-1, ]
  infileall$robust_P_Value_Interaction <- scientific(infileall$robust_P_Value_Interaction, digits = 6)
  infileall <- infileall %>% arrange(robust_P_Value_Interaction)
  
  outdir = "/scratch/ahc87874/Fall2022/Combined/"
  write.table(outdir, paste(outdirFUMA, i, "x", j, suffix, "all.txt", sep = ""), 
              row.names = FALSE, quote = FALSE)
} #suffix
