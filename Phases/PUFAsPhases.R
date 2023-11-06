suppressMessages(library(plyr))
suppressMessages(library(dplyr))
suppressMessages(library(data.table))
suppressMessages(library(tidyverse))
suppressMessages(library(ukbtools)) #<3
suppressMessages(library(rio))

setwd("/scratch/ahc87874/Fall2022/pheno/673621/")

phase1 <- read.csv("/scratch/ahc87874/Phase/pheno/phase1IIDs.csv", header = FALSE)
phase2 <- read.csv("/scratch/ahc87874/Phase/pheno/phase2IIDs.csv", header = FALSE)
comb <- read.csv("/scratch/ahc87874/Phase/pheno/phasecombIIDs.csv", header = FALSE)

NMR <- ukb_df("ukb673621", n_threads = "max", data.pos = 2)
NMR <- as_tibble(NMR)
PUFAs <- NMR %>% select(eid, contains("f23444_0_0"), contains("f23451_0_0"), contains("f23445_0_0"), contains("f23452_0_0"), 
                        contains("f23459_0_0"), contains("f23450_0_0"), contains("f23457_0_0"), contains("f23449_0_0"), 
                        contains("f23456_0_0"), contains("f23446_0_0"), contains("f23453_0_0"), contains("f23447_0_0"), 
                        contains("f23454_0_0"), contains("f23458_0_0"), contains("f23744_0_0"), contains("f23751_0_0"), 
                        contains("f23745_0_0"), contains("f23752_0_0"), contains("f23759_0_0"), contains("f23750_0_0"), 
                        contains("f23757_0_0"), contains("f23749_0_0"), contains("f23756_0_0"), contains("f23746_0_0"), 
                        contains("f23753_0_0"), contains("f23747_0_0"), contains("f23754_0_0"), contains("f23758_0_0")) %>% as_tibble() 

colnames(PUFAs) <- c("IID", "w3FA", "w3FA_TFAP", "w6FA", "w6FA_TFAP",	
                     "w6_w3_ratio", "DHA", "DHA_TFAP", "LA", "LA_TFAP",
                     "PUFA", "PUFA_TFAP", "MUFA", "MUFA_TFAP", "PUFA_MUFA_ratio", 
                     "w3FA_QCflag", "w3FA_TFAP_QCflag", "w6FA_QCflag", "w6FA_TFAP_QCflag", "w6_w3_ratio_QCflag",
                     "DHA_QCflag", "DHA_TFAP_QCflag",	"LA_QCflag", "LA_TFAP_QCflag", "PUFA_QCflag",
                     "PUFA_TFAP_QCflag", "MUFA_QCflag", "MUFA_TFAP_QCflag", "PUFA_MUFA_ratio_QCflag")  

PUFAs1 <- subset(PUFAs, (IID %in% phase1$V1))
PUFAs2 <- subset(PUFAs, (IID %in% phase2$V1))
PUFAsINTcomb <- subset(PUFAs, (IID %in% comb$V1))

#Save datasets
write.csv(PUFAs, file = "/scratch/ahc87874/Fall2022/pheno/PUFAs.csv", row.names = FALSE, quote = FALSE)
write.csv(PUFAs1, file = "/scratch/ahc87874/Fall2022/pheno/PUFAsINT1.csv", row.names = FALSE, quote = FALSE)
write.csv(PUFAs2, file = "/scratch/ahc87874/Fall2022/pheno/PUFAsINT2.csv", row.names = FALSE, quote = FALSE)
write.csv(PUFAsINTcomb, file = "/scratch/ahc87874/Fall2022/pheno/PUFAsINTcomb.csv", row.names = FALSE, quote = FALSE)

#PUFAs <- import("/scratch/ahc87874/Fall2022/pheno/PUFAs.csv")
#PUFAsINTcomb <- import("/scratch/ahc87874/Fall2022/pheno/PUFAsINTcomb.csv")
