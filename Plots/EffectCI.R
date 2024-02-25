library(tidyverse)

setwd("/scratch/ahc87874/Fall2022/Combined")

phenos <- c("DHA", "PUFA", "w3FA_TFAP", "w3FA")

suffix <- c("comb", "phase1", "phase2")

for (i in suffix) {
  DHAData <- as_tibble(read.table(paste("DHA", "xVegetarianVeg", i, ".txt", sep = ""), 
                                         header = TRUE, stringsAsFactors = FALSE))

  DHAData %>% filter(CHR == 8, POS == 52231394) %>% print(width=Inf)
  
  PUFAData <- as_tibble(read.table(paste("PUFA", "xVegetarianVeg", i, ".txt", sep = ""), 
                                         header = TRUE, stringsAsFactors = FALSE))
  PUFAData %>% filter(CHR == 2, POS == 85067224) %>% print(width=Inf)
  
  w3FA_TFAPData <- as_tibble(read.table(paste("w3FA_TFAP", "xVegetarianVeg", i, ".txt", sep = ""), 
                                         header = TRUE, stringsAsFactors = FALSE))
  w3FA_TFAPData %>% filter(CHR == 8, POS == 52231394) %>% print(width=Inf)
  
  w3FAData <- as_tibble(read.table(paste("w3FA", "xVegetarianVeg", i, ".txt", sep = ""), 
                                         header = TRUE, stringsAsFactors = FALSE))
  w3FAData %>% filter(CHR == 8, POS == 52486885) %>% print(width=Inf)
}
