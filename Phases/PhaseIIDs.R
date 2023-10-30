#Load packages and set up wd
suppressMessages(library(plyr))
suppressMessages(library(dplyr))
suppressMessages(library(data.table))
suppressMessages(library(tidyverse))
suppressMessages(library(ukbtools)) #<3
suppressMessages(library(rio))

#Load dataset
setwd("/scratch/ahc87874/Fall2022/pheno/")



setwd("/scratch/ahc87874/Fall2022/pheno/673621/")
phasecomb <- ukb_df("ukb673621", n_threads = "max", data.pos = 2)
phasecomb <- as_tibble(phasecomb)
phasecomb <- phasecomb %>% select(eid)
                                                         
write.csv(phasecomb, file = "/scratch/ahc87874/Phase/pheno/phasecombIIDs.csv", row.names = FALSE, quote = FALSE)
