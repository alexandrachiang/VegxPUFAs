library(tidyverse)
library(rio)

setwd("/scratch/ahc87874/Fall2022/Combined")

phenos <- c("DHA", "PUFA", "w3FA_TFAP", "w3FA")
exposure <- c("Veg", "NonVeg")

for (i in exposure) {
  GEMdir <- paste("/scratch/ahc87874/Fall2022/GEMBeta", i, sep = "")
  
  print("")
  print(paste("DHA", i))
  DHAData <- as_tibble(read.table(paste(GEMdir, "DHA", "DHAxVegetarian-chr8", sep = "/"), 
                                         header = TRUE, stringsAsFactors = FALSE, fill = TRUE))
  temp <- DHAData %>% filter(CHR == 8, POS == 52231394) %>% mutate(Pheno = "DHA", Exposure = i) %>% select(Pheno, Phase, everything()) 
  temp %>% print(width=Inf)
  if (i == "Veg") {
    allData <- temp
  } else {
    allData <- rbind(allData, temp)
  }

  print("")
  print(paste("PUFA", i))
  PUFAData <- as_tibble(read.table(paste(GEMdir, "PUFA", "PUFAxVegetarian-chr2", sep = "/"), 
                                         header = TRUE, stringsAsFactors = FALSE, fill = TRUE))
  temp <- PUFAData %>% filter(CHR == 2, POS == 85067224) %>% mutate(Pheno = "PUFA", Exposure = i) %>% select(Pheno, Phase, everything()) 
  temp %>% print(width=Inf)
  allData <- rbind(allData, temp)
    
  print("")
  print(paste("w3FA_TFAP", i))
  w3FA_TFAPData <- as_tibble(read.table(paste(GEMdir, "w3FA_TFAP", "w3FA_TFAPxVegetarian-chr8", sep = "/"), 
                                         header = TRUE, stringsAsFactors = FALSE, fill = TRUE))
  temp <- w3FA_TFAPData %>% filter(CHR == 8, POS == 52231394) %>% mutate(Pheno = "w3FA_TFAP", Exposure = i) %>% select(Pheno, Phase, everything()) 
  temp %>% print(width=Inf)
  allData <- rbind(allData, temp)
  
  print("")
  print(paste("w3FA", i))
  w3FAData <- as_tibble(read.table(paste(GEMdir, "w3FA", "w3FAxVegetarian-chr8", sep = "/"), 
                                         header = TRUE, stringsAsFactors = FALSE, fill = TRUE))
  temp <- w3FAData %>% filter(CHR == 8, POS == 52486885) %>% mutate(Pheno = "w3FA", Exposure = i) %>% select(Pheno, Phase, everything()) 
  temp %>% print(width=Inf)
  allData <- rbind(allData, temp)
}

outdir <- "/scratch/ahc87874/Fall2022/Combined"
write.table(allData, paste(outdir, "MAGMASNPsBeta.txt", sep = "/"), 
            row.names = FALSE, quote = FALSE, sep = "\t")
write.csv(allData, file = paste(outdir, "MAGMASNPsBeta.csv", sep = "/"), row.names = FALSE, quote = FALSE)
