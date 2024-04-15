#In R

library(tidyverse)
library(rio)

GEMfiles <- list.files("/scratch/ahc87874/vQTL", pattern="*.txt", full.names=TRUE)

for (i in 1:length(GEMfiles)) {
  temp <- as_tibble(import(GEMfiles[i]))
  if (i == 1) {
    print(colnames(temp))
  }
  colnames(temp) <- c("CHR", "RSID", "Non_Effect_Allele", "Effect_Allele", "AF", "POS", "Fstat", "df1", "df2", "Beta", "SE", "P_Value", "N_Samples")
  temp <- temp %>% select(RSID, CHR, POS, Non_Effect_Allele, Effect_Allele, AF, N_Samples, Beta, 
                          SE, P_Value)
  write.table(temp, paste(GEMfiles[i], "reduced.txt", sep = ""), 
                    row.names = FALSE, quote = FALSE, sep = "\t")
}

#In Linux
#gzip *reducedcomb.txt

[1] "Chr"         "SNP"         "A1"          "A2"          "freq"
 [6] "bp"          "F-statistic" "df1"         "df2"         "beta"
[11] "se"          "P"           "NMISS"
