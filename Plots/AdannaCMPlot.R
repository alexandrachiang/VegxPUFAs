library(tidyverse)
library(RColorBrewer)
source("/work/kylab/alex/Fall2022/CMPlot.R")
setwd("/scratch/ahc87874/Fall2022/manplots/Adanna")

phenos <- c("w6w3Ratio", "w3", "w3TFAP", "DHA", "DHATFAP")
SNPs <- as_tibble(read.table("/scratch/ahc87874/Adanna/ResultsforCMplot.txt", 
                                 header = TRUE, stringsAsFactors = FALSE))
colnames(SNPs) <- c("RSID", "CHR", "POS", "w6w3Ratio", "w3", "w3TFAP", "DHA", "DHATFAP") 

toHighlight<-list()
toHighlight[[1]]<-SNPs$RSID[SNPs$w6w3Ratio <= 5e-8]
toHighlight[[2]]<-SNPs$RSID[SNPs$w3 <= 5e-8]
toHighlight[[3]]<-SNPs$RSID[SNPs$w3TFAP <= 5e-08]
toHighlight[[4]]<-SNPs$RSID[SNPs$DHA <= 5e-08]
toHighlight[[5]]<-SNPs$RSID[SNPs$DHATFAP <= 5e-08]
toHighlight 

#https://htmlcolorcodes.com/color-picker/

colors <- brewer.pal(10,"Paired")

colors_matrix <- matrix(c(rep(c(colors[2],colors[1]), 11),
                          rep(c(colors[4],colors[3]), 11),
                          rep(c(colors[6],colors[5]), 11),
                          rep(c(colors[8],colors[7]), 11),
                          rep(c(colors[10],colors[9]), 11)),
                        nrow=5, ncol=22,byrow=TRUE)

#Suggested and Significant
options(bitmapType='cairo')
png(filename = "AdannaCMPlot.png", type = "cairo", width = 1000, height = 1000, res = 110)
CMplot(SNPs, #dataset
       plot.type = "c", #circular
       r = 1.5, #radius of circle
       col = c("grey30", "grey60"), #regular SNP colors, alternating
       cex = c(0.5, 0.5),
       LOG10 = TRUE, #change P vals into log10
       threshold = c(5e-5, 5e-8), #significant thresholds
       threshold.col = c("darkgreen", "darkred"), #threshold line colors
       threshold.lty = c(2, 2), #threshold line types
       amplify = TRUE, #amplify significant SNPs
       #highlight = toHighlight,
       #highlight.text = unlist(toHighlight), 
       signal.line = NULL, 
       signal.cex = c(0.5, 0.5), #significant SNP size
       signal.pch = c(20, 20), #significant SNP shape
       signal.col = c("red", "green3"), #significant SNP colors
       chr.labels = paste("Chr", 1:22, sep = ""), #labels for chromosomes
       cir.chr.h = 1, #width of chromosome boundary
       cir.legend.cex = 0.7, #legend text size
       cir.legend.col = "black",
       outward = TRUE, #plot from inside out
       file = "jpg", #file type
       memo = "SugSig",
       dpi = 300, #resolution
       file.output = TRUE, #save as file
       width = 10,
       height = 10)
dev.off()

#Only Significant
options(bitmapType='cairo')
png(filename = "AdannaCMPlot.png", type = "cairo", width = 1000, height = 1000, res = 110)
CMplot(SNPs, #dataset
       plot.type = "c", #circular
       r = 1.5, #radius of circle
       #col = c("grey30", "grey60"), #regular SNP colors, alternating
       col = matrix(c("palegreen1", "palegreen4", #w6w3Ratio - green
                    "lightsalmon1","lightsalmon4", #w3 - orange
                    "mediumpurple1", "mediumpurple4", #w3% - purple
                    "lightgoldenrod1","lightgoldenrod4", #DHA - yellow
                    "lightblue1", "lightblue4"), #DHA% - blue
                    nrow = 5, byrow = TRUE),
       cex = c(0.5, 0.5),
       LOG10 = TRUE, #change P vals into log10
       threshold = c(5e-8), #significant thresholds
       threshold.col = c("darkred"), #threshold line colors
       threshold.lty = c(2), #threshold line types
       amplify = TRUE, #amplify significant SNPs
       signal.line = NULL, 
       signal.cex = c(0.5), #significant SNP size
       #signal.pch = c(23), #significant SNP shape
       signal.col = c("red"), #significant SNP colors
       chr.labels = paste("Chr", 1:22, sep = ""), #labels for chromosomes
       cir.chr.h = 1, #width of chromosome boundary
       cir.legend.cex = 0.7, #legend text size
       cir.legend.col = "black",
       outward = TRUE, #plot from inside out
       ylim = c(0, 23),
       file = "jpg", #file type
       memo = "Sig",
       dpi = 300, #resolution
       file.output = TRUE, #save as file
       width = 10,
       height = 10)
dev.off()

#Only Significant
options(bitmapType='cairo')
png(filename = "AdannaCMPlot.png", type = "cairo", width = 1000, height = 1000, res = 110)
CMplot(SNPs, #dataset
       plot.type = "c", #circular
       r = 1.5, #radius of circle
       #col = c("grey30", "grey60"), #regular SNP colors, alternating
       col = colors_matrix,
       cex = c(0.4, 0.4),
       LOG10 = TRUE, #change P vals into log10
       threshold = c(5e-8), #significant thresholds
       threshold.col = c("red"), #threshold line colors
       threshold.lty = c(2), #threshold line types
       amplify = TRUE, #amplify significant SNPs
       signal.line = NULL, 
       signal.cex = c(0.7), #significant SNP size
       signal.pch = c(17), #significant SNP shape
       signal.col = c("black"), #significant SNP colors
       chr.labels = paste("Chr", 1:22, sep = ""), #labels for chromosomes
       cir.chr.h = 1, #width of chromosome boundary
       cir.legend.cex = 0.7, #legend text size
       cir.legend.col = "black",
       outward = TRUE, #plot from inside out
       ylim = c(0, 23),
       file = "jpg", #file type
       memo = "SigBlack",
       dpi = 300, #resolution
       file.output = TRUE, #save as file
       width = 10,
       height = 10)
dev.off()
