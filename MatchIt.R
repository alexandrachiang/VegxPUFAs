# Do I need to add other pheno columns besides PUFAs? Probably join veg status and original ukb pheno data
suppressMessages(silent <- lapply(
    c("sandwich", "lmtest", "tidyverse", "MatchIt", "forestplot", "kableExtra"),
    library, character.only = T))
table = function (..., useNA = 'always') base::table(..., useNA = useNA)

setwd("/scratch/ahc87874/Fall2022/MatchIt")
#Pheno file
tab <- as_tibble(read.csv("/scratch/ahc87874/Fall2022/pheno/GEMphenowKeep2.csv"))

#colnames(tab)
# [1] "FID"             "IID"             "Sex"             "Age"
# [5] "Townsend"        "PC1"             "PC2"             "PC3"
# [9] "PC4"             "PC5"             "PC6"             "PC7"
#[13] "PC8"             "PC9"             "PC10"            "SelfID"
#[17] "Strict"          "w3FA"            "w3FA_TFAP"       "w6FA"
#[21] "w6FA_TFAP"       "w6_w3_ratio"     "DHA"             "DHA_TFAP"
#[25] "LA"              "LA_TFAP"         "PUFA"            "PUFA_TFAP"
#[29] "MUFA"            "MUFA_TFAP"       "PUFA_MUFA_ratio"

tab2 <- tab %>% select(IID, Strict, Age, Sex, PC1:PC10, Townsend)
table(tab2$Strict)
#     0      1   <NA>
#202724   3271   4972

tab3 <- tab2[complete.cases(tab2), ] #lose 49 vegetarians
table(tab3$Strict)
#     0      1   <NA>
#198559   3222      0

#1:4 matching without replacement
match.nearest = matchit(Strict ~ Age + Sex + Townsend +
                          PC1 + PC2 + PC3 + PC4 + PC5,
                        data = tab3, distance = "glm",
                        method = "nearest",
                        replace = FALSE,
                        ratio = 4)
                        
outdir = "/scratch/ahc87874/Fall2022/MatchIt/"
png(filename = paste(outdir, "LovePlot.png", sep = ""), type = "cairo", width = 600, height = 500)
plot(summary(match.nearest))
dev.off()

