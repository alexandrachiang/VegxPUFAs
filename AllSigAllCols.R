library(tidyverse)

setwd("/scratch/ahc87874/Fall2022/CombinedAllCol/")

if (FALSE) {
  phenonames <- c("w3FA_NMR", "w3FA_NMR_TFAP", "w6FA_NMR", "w6FA_NMR_TFAP", "w6_w3_ratio_NMR", "DHA_NMR", 
                  "DHA_NMR_TFAP", "LA_NMR", "LA_NMR_TFAP", "PUFA_NMR", "PUFA_NMR_TFAP", "MUFA_NMR", 
                  "MUFA_NMR_TFAP", "PUFA_MUFA_ratio_NMR")
  phenos <- c("w3FA", "w3FA_TFAP", "w6FA", "w6FA_TFAP", "w6_w3_ratio", "DHA", 
              "DHA_TFAP", "LA", "LA_TFAP", "PUFA", "PUFA_TFAP", "MUFA", 
              "MUFA_TFAP", "PUFA_MUFA_ratio")

  exposures <- "SSRV"
  suffix <- "wKeep"
  dir <- "/scratch/ahc87874/Fall2022/CombinedAllCol"

  for (i in 1:length(phenos)) {
    print(paste("pheno:", phenos[i]))
    infile <- as_tibble(read.table(paste(dir, paste(phenonames[i], "x", exposures, suffix, "all.txt", sep = ""), sep = "/"), 
                                         header = TRUE, stringsAsFactors = FALSE))

    infile <- infile %>% mutate(Pheno = phenos[i], Expose = exposures) %>% select(SNPID, RSID, Pheno, Expose, everything())

    infileSuggest <- infile %>% filter(robust_P_Value_Interaction <= 5e-5)
    infileSignif <- infile %>% filter(robust_P_Value_Interaction <= 5e-8)

    #Add to input
    if (i == 1) {
      AllSuggest <- infileSuggest
      AllSignif <- infileSignif
    } else {
      AllSuggest <- rbind(AllSuggest, infileSuggest)
      AllSignif <- rbind(AllSignif, infileSignif)
    } #ifelse  
  }

  outdir = "/scratch/ahc87874/Fall2022/CombinedAllCol/"
  write.table(AllSuggest, paste(outdir, "AllSuggestAllCols.txt", sep = ""), row.names = FALSE, quote = FALSE, sep = "\t")
  write.table(AllSignif, paste(outdir, "AllSignificantAllCols.txt", sep = ""), row.names = FALSE, quote = FALSE, sep = "\t")
} else {
  outdir = "/scratch/ahc87874/Fall2022/CombinedAllCol/"
  AllSuggest <- as_tibble(read.table(paste(outdir, "AllSuggestAllCols.txt", sep = ""), 
                                     header = TRUE, stringsAsFactors = FALSE))
  AllSignif <- as_tibble(read.table(paste(outdir, "AllSignificantAllCols.txt", sep = ""), 
                                    header = TRUE, stringsAsFactors = FALSE))
  
  nrow(AllSuggest)
  #4068
  length(unique(AllSuggest$RSID))
  #2603
  table(AllSuggest$Pheno)
  #      DHA        DHA_TFAP              LA         LA_TFAP            MUFA
  #       93             178             261             189             307
  #MUFA_TFAP            PUFA PUFA_MUFA_ratio       PUFA_TFAP            w3FA
  #      243             284             339             382             329
  #w3FA_TFAP            w6FA       w6FA_TFAP     w6_w3_ratio
  #      239             250             462             512
  
  nrow(AllSignif)
  #4
  length(unique(AllSignif$RSID))
  #4
  table(AllSignif$Pheno)
  #LA_TFAP   w3FA_TFAP w6_w3_ratio
  #      2           1           1
}
