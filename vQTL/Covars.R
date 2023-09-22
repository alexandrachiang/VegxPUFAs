library(tidyverse)

setwd("/scratch/ahc87874/Fall2022/pheno/INT")

pheno <- as_tibble(read.csv("/scratch/ahc87874/Fall2022/pheno/GEMphenowKeep.csv", header = TRUE, stringsAsFactors = FALSE))

