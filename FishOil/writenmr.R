suppressMessages(library(plyr))
suppressMessages(library(dplyr))
suppressMessages(library(data.table))
suppressMessages(library(tidyverse))
suppressMessages(library(ukbtools)) #<3
suppressMessages(library(rio))

setwd("/scratch/ahc87874/FishOil/673621/")
  NMR <- ukb_df("ukb673621", n_threads = "max")
  NMR <- as_tibble(NMR)
  PUFAs <- NMR %>% select(f.eid, f.23444.0.0, f.23451.0.0, f.23445.0.0, f.23452.0.0, 
                          f.23459.0.0, f.23450.0.0, f.23457.0.0, f.23449.0.0, f.23456.0.0, 
                          f.23446.0.0, f.23453.0.0, f.23447.0.0, f.23454.0.0, f.23458.0.0, 
                          f.23744.0.0, f.23751.0.0, f.23745.0.0, f.23752.0.0, f.23759.0.0, 
                          f.23750.0.0, f.23757.0.0, f.23749.0.0, f.23756.0.0, f.23746.0.0, 
                          f.23753.0.0, f.23747.0.0, f.23754.0.0, f.23758.0.0) %>% as_tibble() 

  colnames(PUFAs) <- c("IID", "w3FA", "w3FA_TFAP", "w6FA", "w6FA_TFAP",	
                       "w6_w3_ratio", "DHA", "DHA_TFAP", "LA", "LA_TFAP",
                       "PUFA", "PUFA_TFAP", "MUFA", "MUFA_TFAP", "PUFA_MUFA_ratio", 
                       "w3FA_QCflag", "w3FA_TFAP_QCflag", "w6FA_QCflag", "w6FA_TFAP_QCflag", "w6_w3_ratio_QCflag",
                       "DHA_QCflag", "DHA_TFAP_QCflag",	"LA_QCflag", "LA_TFAP_QCflag", "PUFA_QCflag",
                       "PUFA_TFAP_QCflag", "MUFA_QCflag", "MUFA_TFAP_QCflag", "PUFA_MUFA_ratio_QCflag")  
  
  #Save datasets
  write.csv(PUFAs, file = "/scratch/ahc87874/Fall2022/pheno/PUFAsnew.csv", row.names = FALSE, quote = FALSE)
