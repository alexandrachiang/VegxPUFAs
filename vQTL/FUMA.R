#In R

library(tidyverse)
library(rio)

GEMfiles <- list.files("/scratch/ahc87874/vQTL", pattern="*.txt", full.names=TRUE)

for (i in 1:length(GEMfiles)) {
  temp <- import(GEMfiles[i])
  if (i == 1) {
    print(colnames(temp))
  }
  temp <- temp %>% select(RSID, CHR, POS, Non_Effect_Allele, Effect_Allele, AF, N_Samples, Beta_G.Vegetarian, 
                          robust_SE_Beta_G.Vegetarian, robust_P_Value_Interaction)
  write.table(temp, paste(GEMfiles[i], "reduced.txt", sep = ""), 
                    row.names = FALSE, quote = FALSE, sep = "\t")
}

#In Linux
#gzip *reducedcomb.txt

[1] "Chr"         "SNP"         "A1"          "A2"          "freq"
 [6] "bp"          "F-statistic" "df1"         "df2"         "beta"
[11] "se"          "P"           "NMISS"
