library(tidyverse)
library(qqman)

source("/work/kylab/alex/Fall2022/ManhattanCex.R")

setwd("/scratch/ahc87874/Fall2022/")

Bartlett <- as_tibble(read.table("/scratch/ahc87874/Fall2022/vQTL/old/vQTL_PUFA_NMR_TFAP_Bartlett.txt", header = TRUE, stringsAsFactors = FALSE))
LeveneMean <- as_tibble(read.table("/scratch/ahc87874/Fall2022/vQTL/old/vQTL_PUFA_NMR_TFAP_LeveneMean.txt", header = TRUE, stringsAsFactors = FALSE))
LeveneMed <- as_tibble(read.table("/scratch/ahc87874/Fall2022/vQTL/old/vQTL_PUFA_NMR_TFAP_LeveneMed.txt", header = TRUE, stringsAsFactors = FALSE))

BvsMean <- plot()
