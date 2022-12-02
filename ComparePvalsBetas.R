library(tidyverse)

setwd("/scratch/ahc87874/Fall2022/")

allsuffix <- c("", "woCred", "wKeep")
	
#phenos <- c("w3FA_NMR", "w3FA_NMR_TFAP", "w6FA_NMR", "w6FA_NMR_TFAP", "w6_w3_ratio_NMR", "DHA_NMR", 
#            "DHA_NMR_TFAP", "LA_NMR", "LA_NMR_TFAP", "PUFA_NMR", "PUFA_NMR_TFAP", "MUFA_NMR", 
#            "MUFA_NMR_TFAP", "PUFA_MUFA_ratio_NMR")
phenos <- c("w3FA_NMR_TFAP", "w6_w3_ratio_NMR", "LA_NMR_TFAP")

for (suffix in allsuffix) {
  print(suffix)
  for (i in phenos) {
    print(i)
    CSRV <- as_tibble(read.table(paste("/scratch/ahc87874/Fall2022/Combined/", i, "xCSRV", "all.txt", sep = ""), 
                                            header = TRUE, stringsAsFactors = FALSE))
    SSRV <- as_tibble(read.table(paste("/scratch/ahc87874/Fall2022/Combined/", i, "xSSRV", suffix, "all.txt", sep = ""), 
                                            header = TRUE, stringsAsFactors = FALSE))

    names(CSRV) <- c("CHR", "BP", "P", "CSRVBeta", "SNP")
    names(SSRV) <- c("CHR", "BP", "P", "SSRVBeta", "SNP")
    
    CSRV <- CSRV %>% mutate(CSRVP = -log10(P))
    SSRV <- SSRV %>% mutate(SSRVP = -log10(P))

    Both <- inner_join(CSRV, SSRV, by = c("SNP", "CHR")) %>% arrange(desc(SSRVP))

	  if (FALSE) {
      print("p-values")
      pvalplot <- ggplot(Both) + 
        geom_point(aes(x = CSRVP, y = SSRVP), alpha = 0.1) +
        geom_hline(yintercept = -log10(5e-08), linetype = "dashed", color = "red") +
        geom_vline(xintercept = -log10(5e-08), linetype = "dashed", color = "red") + 
        labs(title = paste("Compare p-values of ", i, " ", suffix, sep = ""), 
             x = "CSRV",
             y = "SSRV") 

      png(filename = paste("pvalplots/ComparePvals_", i, suffix, ".png", sep = ""), type = "cairo", width = 600, height = 600)
      print(pvalplot)
      dev.off()
    }
    
    print("betas")
    betaplot <- ggplot(Both) + 
      geom_point(aes(x = CSRVBeta, y = SSRVBeta), alpha = 0.1) +
      labs(title = paste("Compare Betas of ", i, " ", suffix, sep = ""), 
           x = "CSRV",
           y = "SSRV") 
	  
    png(filename = paste("betaplots/CompareBetas_", i, suffix, ".png", sep = ""), type = "cairo", width = 600, height = 600)
    print(betaplot)
    dev.off()
  } #i phenos
} #suffix
