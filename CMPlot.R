library(tidyverse)
library(CMPlot)

setwd("/scratch/ahc87874/Fall2022/")

#phenos <- c("w3FA_NMR", "w3FA_NMR_TFAP", "w6FA_NMR", "w6FA_NMR_TFAP", "w6_w3_ratio_NMR", "DHA_NMR", 
#            "DHA_NMR_TFAP", "LA_NMR", "LA_NMR_TFAP", "PUFA_NMR", "PUFA_NMR_TFAP", "MUFA_NMR", 
#            "MUFA_NMR_TFAP", "PUFA_MUFA_ratio_NMR")
phenos <- c("w3FA_NMR_TFAP", "LA_NMR_TFAP", "w6_w3_ratio_NMR")
suffic <- "wKeep"

w3FA_NMR_TFAP <- as_tibble(read.table(paste("/scratch/ahc87874/Fall2022/CombinedAllCol/", "w3FA_NMR_TFAP", "x", "SSRV", suffix, "all.txt", sep = ""), 
                               header = TRUE, stringsAsFactors = FALSE))
LA_NMR_TFAP <- as_tibble(read.table(paste("/scratch/ahc87874/Fall2022/CombinedAllCol/", "LA_NMR_TFAP", "x", "SSRV", suffix, "all.txt", sep = ""), 
                               header = TRUE, stringsAsFactors = FALSE))
w6_w3_ratio_NMR <- as_tibble(read.table(paste("/scratch/ahc87874/Fall2022/CombinedAllCol/", "w6_w3_ratio_NMR", "x", "SSRV", suffix, "all.txt", sep = ""), 
                               header = TRUE, stringsAsFactors = FALSE))

CMplot(pig60K,type="p",plot.type="c",r=0.4,col=c("grey30","grey60"),chr.labels=paste("Chr",c(1:18,"X","Y"),sep=""),
      threshold=c(1e-6,1e-4),cir.chr.h=1.5,amplify=TRUE,threshold.lty=c(1,2),threshold.col=c("red",
      "blue"),signal.line=1,signal.col=c("red","green"),chr.den.col=c("darkgreen","yellow","red"),
      bin.size=1e6,outward=FALSE,file="jpg",memo="",dpi=300,file.output=TRUE,verbose=TRUE,width=10,height=10)
