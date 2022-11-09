#source("/work/kylab/alex/Fall2022/qqman.R")
library(tidyverse)
library(qqman)

setwd("/scratch/ahc87874/Fall2022/")

phenos <- c("w3FA_NMR")
exposures <- c("CSRV", "SSRV")

for (i in phenos) {
  GEMdir <- "/scratch/ahc87874/Fall2022/GEM"
  print(paste("pheno:", i))
  
  for (j in exposures) {
    print(paste("exposure:", j))
    if (FALSE) { #Combine GEM output for pheno and exposure from chr 1-22 into one data frame
      for (k in 1:22) {
        print(paste("chr:", k))
        infile <- as_tibble(read.table(paste(GEMdir, i, paste(i, "x", j, "-chr", k, sep = ""), sep = "/"), 
                                       header = TRUE, stringsAsFactors = FALSE))

        #Subset data
        infilesub <- infile %>% select(CHR, POS, robust_P_Value_Interaction, RSID)

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
      outdirFUMA = "/scratch/ahc87874/Fall2022/FUMA/"
      write.table(infileall, paste(outdirFUMA, i, "x", j, "all.txt", sep = ""), 
                  row.names = FALSE, quote = FALSE)
    } else {
      infileall <- as_tibble(read.table(paste("/scratch/ahc87874/Fall2022/FUMA/", i, "x", j, "all.txt", sep = ""), 
                                        header = TRUE, stringsAsFactors = FALSE))
    }
    
	  print("SNPs")
    #Make table of sig SNPs (P < 1e-5)
    outdirSNPs = "/scratch/ahc87874/Fall2022/SNPs/"
    sigSNPs <- infileall %>% filter(P <= 1e-5)
    write.table(sigSNPs, paste(outdirSNPs, i, "x", j, "sigSNPs.txt", sep = ""),
                row.names = FALSE, quote = FALSE)
    
    #Make table of top 10 SNPs
    newdata <- infileall[order(infileall$P), ]
    newdata <- newdata[1:10, ]
    write.table(newdata, paste(outdirSNPs, i, "x", j, "topSNPs.txt", sep = ""),
                row.names = FALSE, quote = FALSE)

    pvalue <- newdata$P[10]
    
    print("Manhattan")
    #Make manhattan plot
    outdirman = "/scratch/ahc87874/Fall2022/manplots/"
    if (j == "CSRV") {
      exposurecol <- "firebrick1"
    } else if (j == "SSRV") {
      exposurecol <- "deepskyblue1"
    }
    maxy <- -log10(5e-08)
    if (newdata$P[1] < 5e-08) {
      maxy <- -log10(newdata$P[1])
    }
    png(filename = paste(outdirman, i, "x", j, "man.png", sep = ""), type = "cairo", 
        width = 600, height = 300)
    manhattan(infileall, col = c(exposurecol, "black"), suggestiveline = -log10(1e-05), genomewideline = -log10(5e-08),  
              main = paste("Manhattan Plot of ", i, "x", j, " GWIS", sep = ""), annotatePval = 1e-5, ylim = c(0, maxy + 0.15))
    #highlight = newdata
    dev.off()
    
    print("QQ")
    #Make qq plot
    outdirqq = "/scratch/ahc87874/Fall2022/qqplots/"
    png(filename = paste(outdirqq, i, "x", j, "qq.png", sep = ""), type = "cairo", 
        width = 600, height = 600)
    qq(infileall$P, main = paste("Q-Q plot of ", i, "x", j, " GWIS p-values", sep = ""))
    dev.off()
  } #j exposures
} #i phenos

#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
