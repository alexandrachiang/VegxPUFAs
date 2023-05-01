library(tidyverse)
setwd("/scratch/ahc87874/Replication")
pheno <- "w3FA_NMR_TFAP"
exposure <- "SSRV"

infileall <- as_tibble(read.table(paste("/scratch/ahc87874/Replication/CombinedCSA/", pheno, "x", exposure, "alltab.txt", sep = ""), 
                                          header = TRUE, stringsAsFactors = FALSE))
                                          
#13:rs67393898 3:rs62255849 CSRV
#11:rs72880701 11:rs1817457 11:rs149996902 9:140508031_A_G/9:rs34249205 SSRV
