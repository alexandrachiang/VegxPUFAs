library(tidyverse)

setwd("/scratch/ahc87874/Fall2022/Combined")

phenos <- c("DHA", "PUFA", "w3FA_TFAP", "w3FA")

suffix <- c("comb", "phase1", "phase2")

for (i in suffix) {
  print("")
  print(paste("DHA", i))
  DHAData <- as_tibble(read.table(paste("DHA", "xVegetarianVeg", i, ".txt", sep = ""), 
                                         header = TRUE, stringsAsFactors = FALSE))
  temp <- DHAData %>% filter(CHR == 8, POS == 52231394) %>% mutate(Pheno = "DHA", Phase = i) %>% select(Pheno, Phase, everything()) 
  temp %>% print(width=Inf)
  if (i == "comb") {
    allData <- temp
  } else {
    allData <- rbind(allData, temp)
  }

  print("")
  print(paste("PUFA", i))
  PUFAData <- as_tibble(read.table(paste("PUFA", "xVegetarianVeg", i, ".txt", sep = ""), 
                                         header = TRUE, stringsAsFactors = FALSE))
  temp <- PUFAData %>% filter(CHR == 2, POS == 85067224) %>% mutate(Pheno = "PUFA", Phase = i) %>% select(Pheno, Phase, everything()) 
  temp %>% print(width=Inf)
  allData <- rbind(allData, temp)
    
  print("")
  print(paste("w3FA_TFAP", i))
  w3FA_TFAPData <- as_tibble(read.table(paste("w3FA_TFAP", "xVegetarianVeg", i, ".txt", sep = ""), 
                                         header = TRUE, stringsAsFactors = FALSE))
  temp <- w3FA_TFAPData %>% filter(CHR == 8, POS == 52231394) %>% mutate(Pheno = "w3FA_TFAP", Phase = i) %>% select(Pheno, Phase, everything()) 
  temp %>% print(width=Inf)
  allData <- rbind(allData, temp)
  
  print("")
  print(paste("w3FA", i))
  w3FAData <- as_tibble(read.table(paste("w3FA", "xVegetarianVeg", i, ".txt", sep = ""), 
                                         header = TRUE, stringsAsFactors = FALSE))
  temp <- w3FAData %>% filter(CHR == 8, POS == 52486885) %>% mutate(Pheno = "w3FA_TFAP", Phase = i) %>% select(Pheno, Phase, everything()) 
  temp %>% print(width=Inf)
  allData <- rbind(allData, temp)
}

outdir <- "/scratch/ahc87874/Fall2022/Combined"
write.table(allData, paste(outdir, "MAGMASNPs.txt", sep = "/"), 
            row.names = FALSE, quote = FALSE, sep = "\t")
