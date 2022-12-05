library(tidyverse)

setwd("/scratch/ahc87874/Fall2022/")

#allsuffix <- c("", "woCred", "wKeep")
allsuffix <- c("wKeep")
	
#phenos <- c("w3FA", "w3FA_TFAP", "w6FA", "w6FA_TFAP", "w6_w3_ratio", "DHA", 
#            "DHA_TFAP", "LA", "LA_TFAP", "PUFA", "PUFA_TFAP", "MUFA", 
#            "MUFA_TFAP", "PUFA_MUFA_ratio")
#phenos <- c("w3FA_TFAP", "w6_w3_ratio", "LA_TFAP")

for (suffix in allsuffix) {
  #if (suffix == "") {
  #  exposures <- c("CSRV", "SSRV")
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
for (suffix in allsuffix) {
  infileall <- as_tibble(matrix(ncol = ))
  
  for (i in phenos) {
    Combineddir <- paste("/scratch/ahc87874/Fall2022/Combined/", sep = "")

    print(paste("pheno:", i))

    for (j in exposures) {
      print(paste("exposure:", j))
	    
	    infile <- as_tibble(read.table(paste(Combineddir, i, "x", j, suffix, "all.txt", sep = ""), 
                                         header = TRUE, stringsAsFactors = FALSE))
      infile <- infile %>% mutate()
      
      infileall <- rbind(infileall, infile)
    } #exposures
  } #phenos
  outdir = "/scratch/ahc87874/Fall2022/Combined/"
  write.table(outdir, paste(outdirFUMA, i, "x", j, suffix, "all.txt", sep = ""), 
              row.names = FALSE, quote = FALSE)
} #suffix
