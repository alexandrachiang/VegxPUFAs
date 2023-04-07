library(tidyverse)
library(qqman)

#Download FUMA MAGMA files
#Extract zip files
#Cmd Prompt cd into folder and run > ren *.out *.txt
#Rename magma.genes file

source("/work/kylab/alex/Fall2022/ManhattanCex.R")

setwd("/scratch/ahc87874/Fall2022/")

suffix <- c("wKeep")
phenos <- c("w3FA_NMR_TFAP", "w6_w3_ratio_NMR", "LA_NMR_TFAP")
exposures <- c("SSRV")

for (i in phenos) {
    GEMdir <- paste("/scratch/ahc87874/Fall2022/GEM", suffix, sep = "")

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
        write.table(infileall, paste(outdirFUMA, i, "x", j, suffix, "all.txt", sep = ""), 
                    row.names = FALSE, quote = FALSE)
      } else {
        infileall <- as_tibble(read.table(paste("/scratch/ahc87874/Fall2022/Combined/", i, "x", j, suffix, "all.txt", sep = ""), 
                                          header = TRUE, stringsAsFactors = FALSE))
	    }
      
	    infileall <- infileall %>% select(CHR, POS, robust_P_Value_Interaction, RSID)
	    colnames(infileall) <- c("CHR", "BP", "P", "SNP")

      if (i == "w3FA_NMR_TFAP") {
        phe <- "w3 %"
	infileall$SNP[infileall$SNP == "9:140508031_A_G"] <- "rs34249205"
	SNPs <- "rs34249205"
      } else if (i == "w6_w3_ratio_NMR") {
        phe <- "w6/w3 Ratio"
        SNPs <- "rs72880701"
      } else if (i == "LA_NMR_TFAP") {
        phe <- "LA %"
        SNPs <- c("rs1817457", "rs149996902")
      }
	   
      print("Manhattan")
      #Make manhattan plot
      outdirman = "/scratch/ahc87874/Fall2022/manplots/"
      png(filename = paste(outdirman, "FINAL", i, "man.png", sep = ""), type = "cairo", width = 1500, height = 525, res = 110)
      manhattancex(infileall, suggestiveline = -log10(5e-05), genomewideline = -log10(5e-08), col = c("#141a17", "#7b998a"),
                   main = paste("Manhattan Plot of", phe, "GWIS", sep = " "), annotatePval = 5e-5, ylim = c(0, -log10(1e-08)), 
                   annofontsize = 1, cex.axis = 1.3, cex.lab = 1.3, cex.main = 1.7, highlight = SNPs, 
		   highlightcol = "#ff0000", highlighttextcol = "#ff0000")
      dev.off()

      #print("QQ")
      #Make qq plot
      #outdirqq = "/scratch/ahc87874/Fall2022/qqplots/"
	    
      #png(filename = paste(outdirqq, "FINAL", i, "qq.png", sep = ""), type = "cairo", width = 600, height = 600)
      #qq(infileall$P, main = paste("Q-Q Plot of", phe, "P-Values", sep = " "))
      #dev.off()
      
      if (i == "w3FA_NMR_TFAP") {
        print("MAGMA")
        #Make MAGMA plot
        magma <-  as_tibble(read.table(paste("/scratch/ahc87874/Fall2022/FUMA/magma.genes.", i, ".txt", sep = ""), 
                                            header = TRUE, stringsAsFactors = FALSE))

        magma <- magma %>% mutate(MIDDLE = (START + STOP)/2) %>% select(CHR, MIDDLE, P, SYMBOL)
        colnames(magma) <- c("CHR", "BP", "P", "SNP")
        SNPs <- c("C9orf37", "ARRDC1")

        outdirmagma = "/scratch/ahc87874/Fall2022/MAGMAplots/"
        png(filename = paste(outdirmagma, i, "MAGMA.png", sep = ""), type = "cairo", width = 1000, height = 400, res = 115)
        manhattancex(magma, suggestiveline = FALSE, genomewideline = -log10(2.619e-6), #col = c("#15141a", "#807b99"),
                     main = paste("Manhattan Plot of", phe, "Gene-Based Test by MAGMA", sep = " "), 
                     annotatePval = -log10(2.619e-6), ylim = c(0, -log10(1e-08)), annofontsize = 1, cex.axis = 1.3, 
		     cex.lab = 1.3, cex.main = 1.7, highlight = SNPs, highlightcol = "#ff0000", highlighttextcol = "#ff0000")
        dev.off()
      }  
    } #j exposures
  } #i phenos


#Colors
#Dark 		light
##1a1a1a	#999999	#Gray
##141a17	#7b998a #Green
##15141a	#807b99	#Purple
##ff0000		Red
