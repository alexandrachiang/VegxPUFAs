library(tidyverse)
source("/work/kylab/alex/Fall2022/CMPlot.R")
setwd("/scratch/ahc87874/Fall2022/manplots")

phenos <- c("Omega-6:Omega-3 Ratio", "Omega-3", "Omega-3 %", "DHA", "DHA %")
SNPs <- as_tibble(read.table("/work/kylab/adanna/ResultsforCMplot.txt", 
                                 header = TRUE, stringsAsFactors = FALSE))
colnames(SNPs)[1:3] <- c("RSID", "CHR", "POS", "w6w3Ratio", "w3", "w3Per", "DHA", "DHAPer") 

toHighlight<-list()
toHighlight[[1]]<-SNPs$RSID[SNPs$w6w3Ratio <= 5e-8]
toHighlight[[2]]<-SNPs$RSID[SNPs$w3 <= 5e-8]
toHighlight[[3]]<-SNPs$RSID[SNPs$w3Per <= 5e-08]
toHighlight[[4]]<-SNPs$RSID[SNPs$DHA <= 5e-08]
toHighlight[[5]]<-SNPs$RSID[SNPs$DHAPer <= 5e-08]
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
png(filename = "MultiPlot.png", type = "cairo", width = 1600, height = 1000, res = 100)
CMplot(SNPs, #dataset
       plot.type = "m",
       multracks = TRUE,
       col = c("#B6E997", "#97AAE7", "#E898D9"), #regular SNP colors, alternating
       cex = c(0.5, 0.5),
       cir.legend.cex = 0.7, #legend text size
       cir.legend.col = "black",  
       LOG10 = TRUE, #change P vals into log10
       threshold = c(5e-8, 5e-5), #significant thresholds
       threshold.col = c("red", "darkgray"), #threshold line colors
       threshold.lty = c(1, 2), #threshold line types
       amplify = TRUE, #amplify significant SNPs
       highlight = toHighlight,
       highlight.text = toHighlight, 
       highlight.col=c("red","blue","green","purple"),
       highlight.text.col=c("red","blue","green","purple"),
       signal.line = NULL, 
       signal.cex = c(2, 2, 2), #significant SNP size
       signal.pch = c(20, 20, 20), #significant SNP shape
       signal.col = c("#5EFF00", "#0044FF", "#FF00D4"), #significant SNP colors
       chr.labels = c(1:22), #labels for chromosomes
       main = "Manhattan Plot",
       file = "jpg", #file type
       memo = "Multi",
       dpi = 300, #resolution
       file.output = TRUE, #save as file
       width = 8,
       height = 5)
dev.off()
                               
#Multi_tracks Rectangular-Manhattan plot
options(bitmapType='cairo')
png(filename = "MultiPlot.png", type = "cairo", width = 1200, height = 600, res = 300)
CMplot(SNPs, #dataset
       plot.type = "m",
       multracks = TRUE,
       col = c("#B6E997", "#97AAE7", "#E898D9"), #regular SNP colors, alternating
       cex = c(0.5, 0.5),
       pch=16,
       cir.legend.cex = 0.7, #legend text size
       cir.legend.col = "black",
       LOG10 = TRUE, #change P vals into log10
       threshold = c(5e-5, 5e-8), #significant thresholds
       threshold.col = c("darkgray", "red"), #threshold line colors
       threshold.lty = c(2, 1), #threshold line types
       amplify = FALSE, #amplify significant SNPs
       chr.labels = c(1:22), #labels for chromosomes
       main = "Manhattan Plot",
       file = "jpg", #file type
       memo = "Multi",
       dpi = 300, #resolution
       file.output = TRUE, #save as file
       width = 12,
       height = 6)
dev.off()

