library(tidyverse)
library(CMplot)

setwd("/scratch/ahc87874/Fall2022/manplots")

if (FALSE) {
  #phenos <- c("w3FA_NMR", "w3FA_NMR_TFAP", "w6FA_NMR", "w6FA_NMR_TFAP", "w6_w3_ratio_NMR", "DHA_NMR", 
  #            "DHA_NMR_TFAP", "LA_NMR", "LA_NMR_TFAP", "PUFA_NMR", "PUFA_NMR_TFAP", "MUFA_NMR", 
  #            "MUFA_NMR_TFAP", "PUFA_MUFA_ratio_NMR")
  phenos <- c("w3FA_NMR_TFAP", "LA_NMR_TFAP", "w6_w3_ratio_NMR")
  suffix <- "wKeep"

  w3FA_NMR_TFAP <- as_tibble(read.table(paste("/scratch/ahc87874/Fall2022/CombinedAllCol/", "w3FA_NMR_TFAP", "x", "SSRV", suffix, "all.txt", sep = ""), 
                                 header = TRUE, stringsAsFactors = FALSE))
  LA_NMR_TFAP <- as_tibble(read.table(paste("/scratch/ahc87874/Fall2022/CombinedAllCol/", "LA_NMR_TFAP", "x", "SSRV", suffix, "all.txt", sep = ""), 
                                 header = TRUE, stringsAsFactors = FALSE))
  w6_w3_ratio_NMR <- as_tibble(read.table(paste("/scratch/ahc87874/Fall2022/CombinedAllCol/", "w6_w3_ratio_NMR", "x", "SSRV", suffix, "all.txt", sep = ""), 
                                 header = TRUE, stringsAsFactors = FALSE))
  
  w3FA_NMR_TFAP <- w3FA_NMR_TFAP %>% select(RSID, CHR, POS, robust_P_Value_Interaction)
  LA_NMR_TFAP <- LA_NMR_TFAP %>% select(RSID, CHR, POS, robust_P_Value_Interaction)
  w6_w3_ratio_NMR <- w6_w3_ratio_NMR %>% select(RSID, CHR, POS, robust_P_Value_Interaction)
  colnames(w3FA_NMR_TFAP)[4] <- "w3_Percent_P"
  colnames(LA_NMR_TFAP)[4] <- "LA_Percent_P"
  colnames(w6_w3_ratio_NMR)[4] <- "w6_w3_Ratio_P"
  
  SNPs <- full_join(w3FA_NMR_TFAP, LA_NMR_TFAP, by = c("RSID", "CHR", "POS"))
  SNPs <- full_join(SNPs, w6_w3_ratio_NMR, by = c("RSID", "CHR", "POS"))
  
  #unique(w3FA_NMR_TFAP$RSID[duplicated(w3FA_NMR_TFAP$RSID)])
  #w3FA_NMR_TFAP[w3FA_NMR_TFAP$RSID == "rs1990483", ]
  
  write.table(SNPs, file = "/scratch/ahc87874/Fall2022/manplots/PvalsforCMPlot.txt",
              sep = "\t", row.names = FALSE, quote = FALSE)
} else {
  SNPs <- as_tibble(read.table("/scratch/ahc87874/Fall2022/manplots/PvalsforCMPlot.txt", 
                               header = TRUE, stringsAsFactors = FALSE))
}

SNPs$RSID[SNPs$RSID == "9:140508031_A_G"] <- "rs34249205"

toHighlight<-list()
toHighlight[[1]]<-SNPs$RSID[SNPs$w3_Percent_P <= 5e-8]
toHighlight[[2]]<-SNPs$RSID[SNPs$LA_Percent_P <= 5e-8]
toHighlight[[3]]<-SNPs$RSID[SNPs$w6_w3_Ratio_P <= 5e-08]
toHighlight 

#https://htmlcolorcodes.com/color-picker/

#Suggested and Significant
options(bitmapType='cairo')
png(filename = "CMPlot.png", type = "cairo", width = 700, height = 700, res = 100)
CMplot(SNPs, #dataset
       plot.type = "c", #circular
       r = 1.5, #radius of circle
       col = c("grey30", "grey60"), #regular SNP colors, alternating
       cex = c(0.5, 0.5),
       cir.chr.h = 1, #width of chromosome boundary
       cir.legend.cex = 0.7, #legend text size
       cir.legend.col = "black",
       LOG10 = TRUE, #change P vals into log10
       threshold = c(5e-8, 5e-5), #significant thresholds
       threshold.col = c("darkred", "darkgreen"), #threshold line colors
       threshold.lty = c(2, 2), #threshold line types
       amplify = TRUE, #amplify significant SNPs
       #highlight = toHighlight,
       #highlight.text = unlist(toHighlight), 
       signal.line = NULL, 
       signal.cex = c(0.9, 0.9), #significant SNP size
       signal.pch = c(20, 20), #significant SNP shape
       signal.col = c("red", "green"), #significant SNP colors
       chr.labels = paste("Chr", 1:22, sep = ""), #labels for chromosomes
       outward = TRUE, #plot from inside out
       file = "jpg", #file type
       memo = "SugSig",
       dpi = 300, #resolution
       file.output = TRUE, #save as file
       width = 10,
       height = 13)
dev.off()

#Only Significant
options(bitmapType='cairo')
png(filename = "CMPlot.png", type = "cairo", width = 700, height = 700, res = 100)
CMplot(SNPs, #dataset
       plot.type = "c", #circular
       r = 1.5, #radius of circle
       col = c("grey30", "grey60"), #regular SNP colors, alternating
       cex = c(0.5, 0.5),
       cir.chr.h = 1, #width of chromosome boundary
       cir.legend.cex = 0.7, #legend text size
       cir.legend.col = "black",
       LOG10 = TRUE, #change P vals into log10
       threshold = c(5e-8), #significant thresholds
       threshold.col = c("darkred"), #threshold line colors
       threshold.lty = c(2), #threshold line types
       amplify = TRUE, #amplify significant SNPs
       #highlight = toHighlight,
       #highlight.text = unlist(toHighlight), 
       signal.line = NULL, 
       signal.cex = c(0.9), #significant SNP size
       signal.pch = c(20), #significant SNP shape
       signal.col = c("red"), #significant SNP colors
       chr.labels = paste("Chr", 1:22, sep = ""), #labels for chromosomes
       outward = TRUE, #plot from inside out
       file = "jpg", #file type
       memo = "Sig",
       dpi = 300, #resolution
       file.output = TRUE, #save as file
       width = 10,
       height = 13)
dev.off()

#Only Significant w/ colors
options(bitmapType='cairo')
png(filename = "CMPlot.png", type = "cairo", width = 700, height = 700, res = 100)
CMplot(SNPs, #dataset
       plot.type = "c", #circular
       r = 1.5, #radius of circle
       col = matrix(c("#ACBFA1", "#E6FFD7", #w3 %
                    "#A1A9BF","#D7E1FF", #LA
                    "#BFA1BA", "#FFD7F8"), #w6 w3 ratio
                    nrow = 3, byrow = TRUE),
       cex = c(0.5, 0.5),
       cir.chr.h = 1, #width of chromosome boundary
       cir.legend.cex = 0.7, #legend text size
       cir.legend.col = "black",
       LOG10 = TRUE, #change P vals into log10
       threshold = c(5e-8), #significant thresholds
       threshold.col = c("darkred"), #threshold line colors
       threshold.lty = c(2), #threshold line types
       amplify = TRUE, #amplify significant SNPs
       #highlight = toHighlight,
       #highlight.text = unlist(toHighlight), 
       signal.line = NULL, 
       signal.cex = c(1), #significant SNP size
       signal.pch = c(18), #significant SNP shape
       signal.col = c("red"), #significant SNP colors
       chr.labels = paste("Chr", 1:22, sep = ""), #labels for chromosomes
       outward = TRUE, #plot from inside out
       file = "jpg", #file type
       memo = "Colored",
       dpi = 500, #resolution
       file.output = TRUE, #save as file
       width = 10,
       height = 13)
dev.off()

#Blank plot
SNPsBlank <- SNPs %>% filter(w3_Percent_P <= 5e-8 | LA_Percent_P <= 5e-8 | w6_w3_Ratio_P <= 5e-8)
x <- c("rs1", 1, 1, 1, 1, 1)
y <- c("rs22", 22, 249222325, 1, 1, 1)

SNPsBlank <- rbind(SNPsBlank, x, y)
SNPsBlank <- SNPsBlank[5:6, ]
SNPsBlank

options(bitmapType='cairo')
png(filename = "CMPlot.png", type = "cairo", width = 700, height = 700, res = 100)
CMplot(SNPsBlank, #dataset
       plot.type = "c", #circular
       r = 1.5, #radius of circle
       col = c("#FFFFFF", "#FFFFFF"),
       cex = c(0.01, 0.01),
       lwd.axis = 0.001,
       ylim = c(0, 8),
       cir.chr.h = 1, #width of chromosome boundary
       cir.legend.cex = 0.7, #legend text size
       cir.legend.col = "black",
       LOG10 = FALSE, #change P vals into log10
       outward = TRUE, #plot from inside out
       file = "jpg", #file type
       memo = "Blank",
       dpi = 500, #resolution
       file.output = TRUE, #save as file
       width = 10,
       height = 13)
dev.off()

#Multi_tracks Rectangular-Manhattan plot
options(bitmapType='cairo')
png(filename = "MultiPlot.png", type = "cairo", width = 1000, height = 800, res = 115)
CMplot(SNPs, #dataset
       plot.type = "m",
       multracks = FALSE,
       col = c("grey30", "grey60"), #regular SNP colors, alternating
       cex = c(0.5, 0.5),
       cir.chr.h = 1, #width of chromosome boundary
       cir.legend.cex = 0.7, #legend text size
       cir.legend.col = "black",
       LOG10 = TRUE, #change P vals into log10
       threshold = c(5e-8, 5e-5), #significant thresholds
       threshold.col = c("darkred", "darkgreen"), #threshold line colors
       threshold.lty = c(1, 2), #threshold line types
       amplify = TRUE, #amplify significant SNPs
       highlight = toHighlight,
       highlight.text = toHighlight, 
       highlight.col=c("red","blue","green","purple"),
       highlight.text.col=c("red","blue","green","purple"),
       signal.line = NULL, 
       signal.cex = c(0.9, 0.9), #significant SNP size
       signal.pch = c(20, 20), #significant SNP shape
       signal.col = c("red", "green"), #significant SNP colors
       chr.labels = paste("Chr", 1:22, sep = ""), #labels for chromosomes
       outward = TRUE, #plot from inside out
       file = "jpg", #file type
       memo = "Multi",
       dpi = 300, #resolution
       file.output = TRUE, #save as file
       width = 10,
       height = 13)
dev.off()
