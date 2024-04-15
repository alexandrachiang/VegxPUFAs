library(tidyverse)
library(qqman)

#Download FUMA MAGMA files
#Extract zip files
#Cmd Prompt cd into folder and run > ren *.out *.txt
#Rename magma.genes file

source("/work/kylab/alex/Fall2022/ManhattanCex.R")

setwd("/scratch/ahc87874/Fall2022/")

phenos <- c("w3", "w3per", "DHA", "PUFA")
exposures <- c("Vegetarian")

for (i in phenos) {
    print(paste("pheno:", i))
  
    #Make MAGMA plot
    magma <-  as_tibble(read.table(paste("/scratch/ahc87874/Fall2022/FUMA/magma.genes.", i, ".txt", sep = ""), 
                                        header = TRUE, stringsAsFactors = FALSE))

    magma <- magma %>% mutate(MIDDLE = (START + STOP)/2) %>% select(CHR, MIDDLE, P, SYMBOL)
    colnames(magma) <- c("CHR", "BP", "P", "SNP")
      
	  if (i == "PUFA") {
	      SNPs <- c("TRABD2A")
        outdirmagma = "/scratch/ahc87874/Fall2022/MAGMAplots/"
        png(filename = paste(outdirmagma, i, "MAGMA.png", sep = ""), type = "cairo", width = 1500, height = 750, res = 100)
        manhattancex(magma, suggestiveline = FALSE, genomewideline = -log10(2.619e-6), #col = colors,
                   main = paste("Manhattan Plot of", phe, "Gene-Based Test by MAGMA", sep = " "), 
                   annotatePval = 2.619e-4, ylim = c(0, -log10(1e-08)), annofontsize = 1, cex.axis = 1.3, 
                   cex.lab = 1.3, cex.main = 1.7, highlight = SNPs, highlightcol = "#ff0000", highlighttextcol = "#ff0000")
        dev.off() 
      } else {
       SNPs <- c("PXDNL")
        outdirmagma = "/scratch/ahc87874/Fall2022/MAGMAplots/"
        png(filename = paste(outdirmagma, i, "MAGMA.png", sep = ""), type = "cairo", width = 1500, height = 750, res = 100)
        manhattancex(magma, suggestiveline = FALSE, genomewideline = -log10(2.619e-6), #col = colors,
                   main = paste("Manhattan Plot of", phe, "Gene-Based Test by MAGMA", sep = " "), 
                   annotatePval = 2.619e-4, ylim = c(0, -log10(1e-08)), annofontsize = 1, cex.axis = 1.3, 
                   cex.lab = 1.3, cex.main = 1.7, highlight = SNPs, highlightcol = "#ff0000", highlighttextcol = "#ff0000")
        dev.off() 
      }
  } #i phenos


#Colors
#Dark 		light
##1a1a1a	#999999	#Gray
##141a17	#7b998a #Green
##15141a	#807b99	#Purple
##ff0000		Red
