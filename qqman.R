library(tidyverse)
library(qqman)

phenos <- "w3FA_NMR"
exposures <- c("CSRV", "SSRV")

for (i in phenos) {
  indir = paste("/scratch/ahc87874/Fall2022/GEM/", i, sep = "")

}

for (i in 1:22) {
  infile <- as_tibble(read.table(paste(indir, paste("w3FA_NMRxCSRV-chr", i, sep=""), sep="/"), 
                      header=TRUE, stringsAsFactors=FALSE))

  #Subset data
  infile1 <- infile %>% select(CHR, POS, robust_P_Value_Interaction, RSID)

  #Get qqman format
  colnames(infile1) <- c("CHR", "BP", "P", "SNP")

  #Add to input
  if (i == 1) {
    infileall <- infile1
  } else {
    infileall <- rbind(infileall, infile1)
  }
}

outdir = "/scratch/ahc87874/Fall2022/FUMA"
#Save table of all chr for pheno x exposure
write.table(infileall, 
	paste(outdir, "/w3FA_NMRxCSRVall.txt", sep = ""),
	row.names = FALSE, quote = FALSE)

outdir = "/scratch/ahc87874/Fall2022/SNPs"
#Make table of sig SNPs (P < 1e-5)
sigSNPs <- infileall %>% filter(P <= 1e-5)
write.table(sigSNPs, 
	paste(outdir, "/w3FA_NMRxCSRVsigSNPs.txt", sep = ""),
	row.names = FALSE, quote = FALSE)
	
#Make table of top 10 SNPs
attach(infileall)
newdata <- infileall[order(P), ]
newdata <- newdata[1:10, ]
write.table(newdata, 
	paste(outdir, "/w3FA_NMRxCSRVtopSNPs.txt", sep = ""),
	row.names = FALSE, quote = FALSE)
	
pvalue <- newdata[10, 3]

#Make manhattan plot
outdir = "/scratch/ahc87874/Fall2022/manplots"
plotoutputfile<-paste(outdir, "/w3FA_NMRxCSRVman.png", sep="")

png(filename=plotoutputfile, type="cairo", width=600, height=300)
manhattan(infileall,ylim = c(0, 8.15), col = c("firebrick1", "black"), suggestiveline = T, genomewideline = T, 
          main = "Manhattan Plot of w3FA_NMRxCSRV GWIS", annotatePval = 1e-5) #"deepskyblue1"
#highlight = newdata
#firebrick1 deepskyblue1
dev.off()

#Make qq plot
outdir = "/scratch/ahc87874/Fall2022/qqplots"
plotoutputfile <- paste(outdir, "/w3FA_NMRxCSRVqq.png", sep="")

png(filename=plotoutputfile, type="cairo")
qq(infileall$P, main = "Q-Q plot of w3FA_NMRxCSRV GWIS p-values")
dev.off()

#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
#w3FA_NMR x CSRV
indir = "/scratch/ahc87874/Fall2022/GEM/w3FA_NMR"

for (i in 1:22) {
  infile <- as_tibble(read.table(paste(indir, paste("w3FA_NMRxCSRV-chr", i, sep=""), sep="/"), 
                      header=TRUE, stringsAsFactors=FALSE))
  #[1] "SNPID"
  #[2] "RSID"
  #[3] "CHR"
  #[4] "POS"
  #[5] "Non_Effect_Allele"
  #[6] "Effect_Allele"
  #[7] "N_Samples"
  #[8] "AF"
  #[9] "N_Consistent_Self_Reported_Vegetarian_across_all_24hr_1"
  #[10] "AF_Consistent_Self_Reported_Vegetarian_across_all_24hr_1"
  #[11] "N_Consistent_Self_Reported_Vegetarian_across_all_24hr_0"
  #[12] "AF_Consistent_Self_Reported_Vegetarian_across_all_24hr_0"
  #[13] "Beta_Marginal"
  #[14] "robust_SE_Beta_Marginal"
  #[15] "Beta_G.Consistent_Self_Reported_Vegetarian_across_all_24hr"
  #[16] "robust_SE_Beta_G.Consistent_Self_Reported_Vegetarian_across_all_24hr"
  #[17] "robust_P_Value_Marginal"
  #[18] "robust_P_Value_Interaction"
  #[19] "robust_P_Value_Joint"

  #Subset data
  infile1 <- infile %>% select(CHR, POS, robust_P_Value_Interaction, RSID)

  #Get qqman format
  colnames(infile1) <- c("CHR", "BP", "P", "SNP")

  #Add to input
  if (i == 1) {
    infileall <- infile1
  } else {
    infileall <- rbind(infileall, infile1)
  }
}

outdir = "/scratch/ahc87874/Fall2022/FUMA"
#Save table of all chr for pheno x exposure
write.table(infileall, 
	paste(outdir, "/w3FA_NMRxCSRVall.txt", sep = ""),
	row.names = FALSE, quote = FALSE)

outdir = "/scratch/ahc87874/Fall2022/SNPs"
#Make table of sig SNPs (P < 1e-5)
sigSNPs <- infileall %>% filter(P <= 1e-5)
write.table(sigSNPs, 
	paste(outdir, "/w3FA_NMRxCSRVsigSNPs.txt", sep = ""),
	row.names = FALSE, quote = FALSE)
	
#Make table of top 10 SNPs
attach(infileall)
newdata <- infileall[order(P), ]
newdata <- newdata[1:10, ]
write.table(newdata, 
	paste(outdir, "/w3FA_NMRxCSRVtopSNPs.txt", sep = ""),
	row.names = FALSE, quote = FALSE)
	
pvalue <- newdata[10, 3]

#Make manhattan plot
outdir = "/scratch/ahc87874/Fall2022/manplots"
plotoutputfile<-paste(outdir, "/w3FA_NMRxCSRVman.png", sep="")

png(filename=plotoutputfile, type="cairo", width=600, height=300)
manhattan(infileall,ylim = c(0, 8.15), col = c("firebrick1", "black"), suggestiveline = T, genomewideline = T, 
          main = "Manhattan Plot of w3FA_NMRxCSRV GWIS", annotatePval = 1e-5) #"deepskyblue1"
#highlight = newdata
#firebrick1 deepskyblue1
dev.off()

#Make qq plot
outdir = "/scratch/ahc87874/Fall2022/qqplots"
plotoutputfile <- paste(outdir, "/w3FA_NMRxCSRVqq.png", sep="")

png(filename=plotoutputfile, type="cairo")
qq(infileall$P, main = "Q-Q plot of w3FA_NMRxCSRV GWIS p-values")
dev.off()

#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
