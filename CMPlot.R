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
  SNPs <- as_tibble(read.table("/scratch/ahc87874/Fall2022/manplots.txt", 
                               header = TRUE, stringsAsFactors = FALSE))
}

options(bitmapType='cairo')
png(filename = "CMPlot.png", type = "cairo", width = 700, height = 700, res = 100)
CMplot(SNPs, #dataset
                  plot.type = "c", #circular
                  col = c("grey30", "grey60"), #regular SNP colors, alternating
                  cir.chr.h = 1, #width of chromosome boundary
                  cir.legend.cex = 0.7, 
                  cir.legend.col = "black",
                  threshold = c(5e-8, 5e-5), #significant thresholds
                  LOG10 = TRUE, #change P vals into log10
                  threshold.col = c("pink", "green"), #threshold line colors
                  threshold.lty = c(2, 2), #threshold line types
                  amplify = TRUE, #amplify significant SNPs
                  signal.line = 1, 
                  signal.col = c("red", "darkgreen"), #significant SNP colors
                  chr.labels = paste(1:22), #labels for chromosomes
                  outward = TRUE, #plot from inside out
                  file = "jpg", #file type
                  memo = "",
                  dpi = 300, #resolution
                  file.output = TRUE, #save as file
                  width = 10,
                  height = 10)
dev.off()

CMplot(pig60K,type="p",plot.type="c",r=0.4,col=c("grey30","grey60"),chr.labels=paste("Chr",c(1:18,"X","Y"),sep=""),
      threshold=c(1e-6,1e-4),cir.chr.h=1.5,amplify=TRUE,threshold.lty=c(1,2),threshold.col=c("red",
      "blue"),signal.line=1,signal.col=c("red","green"),chr.den.col=c("darkgreen","yellow","red"),
      bin.size=1e6,outward=FALSE,file="jpg",memo="",dpi=300,file.output=TRUE,verbose=TRUE,width=10,height=10)
