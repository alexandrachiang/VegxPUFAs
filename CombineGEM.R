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

#Combine chr into pheno x exposure
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
Combineddir <- paste("/scratch/ahc87874/Fall2022/Combined/", sep = "")

for (suffix in allsuffix) {
  infileall <- as_tibble(matrix(ncol = 21))
  colnames(infileall) <- c("Phenotype", "Exposure", "SNPID", "RSID", "CHR", "POS", "Non_Effect_Allele", "Effect_Allele", 
                           "N_Samples", "AF", "N_Exposure_0", "AF_Exposure_0", "N_Exposure_1", "AF_Exposure_1", "Beta_Marginal",
                           "robust_SE_Beta_Marginal", "Beta_G", "robust_SE_Beta_G", "robust_P_Value_Marginal", 
                           "robust_P_Value_Interaction", "robust_P_Value_Joint")
  
  for (i in phenos) {
    print(paste("pheno:", i))

    for (j in exposures) {
      print(paste("exposure:", j))
	    
      if (j == "CSRV") {
        GEMdir <- paste("/scratch/ahc87874/Fall2022/GEM", sep = "")
      } else {
        GEMdir <- paste("/scratch/ahc87874/Fall2022/GEM", suffix, sep = "")
      }
      
      for (k in 1:22) {
        print(paste("chr:", k))
        infile <- as_tibble(read.table(paste(GEMdir, i, paste(i, "x", j, "-chr", k, sep = ""), sep = "/"), 
                                         header = TRUE, stringsAsFactors = FALSE))

        #Add to input
        if (k == 1) {
          chrall <- infile
        } else {
          chrall <- rbind(chrall, infile)
        } #ifelse
      } #k chr number
      
      colnames(chrall)[9:12] <- c("N_Exposure_0", "AF_Exposure_0", "N_Exposure_1", "AF_Exposure_1")
	    colnames(chrall)[15:16] <- c("Beta_G", "robust_SE_Beta_G")
      chrall <- chrall %>% mutate(Phenotype = i, Exposure = j) %>% select(Phenotype, Exposure, everything())
      
      infileall <- rbind(infileall, chrall)
    } #exposures
  } #phenos
  infileall <- infileall[-1, ]
  infileall$robust_P_Value_Interaction <- scientific(infileall$robust_P_Value_Interaction, digits = 6)
  infileall <- infileall %>% arrange(robust_P_Value_Interaction)
  
  outdir = "/scratch/ahc87874/Fall2022/Combined/"
  write.table(infileall, paste(outdir, suffix, "allSNPs.txt", sep = ""), 
              row.names = FALSE, quote = FALSE)
} #suffix

outdir = "/scratch/ahc87874/Fall2022/Combined/"
#Number of SNPs
print(unique(infileall$RSID))

#Number of sig SNPs
infileallsig <- infileall %>% filter(robust_P_Value_Interaction <= 1e-5)
print(nrow(infileallsig))
print(unique(infileallsig$RSID))
write.table(infileallsig, paste(outdir, suffix, "allSigSNPs.txt", sep = ""), 
            row.names = FALSE, quote = FALSE)

#Number of very sig SNPs
infileallverysig <- infileall %>% filter(robust_P_Value_Interaction <= 5e-8)
print(nrow(infileallverysig))
print(unique(infileallverysig$RSID))
write.table(infileallverysig, paste(outdir, suffix, "allVerySigSNPs.txt", sep = ""), 
            row.names = FALSE, quote = FALSE)
