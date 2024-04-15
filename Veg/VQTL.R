# Get counts for CSRV and SSRV for the initial and recall surveys, first response only
# CSRV = self-ID vegatarian, field 20086
# SSRV = true vegetarian, field 

#Load packages and set up wd
suppressMessages(library(plyr))
suppressMessages(library(dplyr))
suppressMessages(library(data.table))
suppressMessages(library(tidyverse))
#suppressMessages(library(ggpubr))
suppressMessages(library(ukbtools)) #<3
suppressMessages(library(rio))

setwd("/scratch/ahc87874/Fall2022/pheno")

#Load dataset
ukb <- ukb_df("ukb34137")
ukb <- as_tibble(ukb)

#Remove withdrawn participants from dataset
withdrawn <- read.csv("/scratch/ahc87874/Fall2022/pheno/withdrawn.csv", header = FALSE)
ukb <- ukb[!(ukb$eid %in% withdrawn$V1), ] #502413

#Load auxillary datasets
BMI <- as_tibble(read.table("BMI.txt", header = TRUE))
PUFAs <- as_tibble(import("/scratch/ahc87874/Fall2022/pheno/PUFAs.txt"))

PUFAs <- PUFAs[, 1:15]

colnames(ukb)[1] <- "IID"
ukb <- ukb %>% mutate(FID = IID)

#Subset columns
ukb2 <- ukb %>% select(FID, IID, age_when_attended_assessment_centre_f21003_0_0, sex_f31_0_0, 
                       paste("genetic_principal_components_f22009_0_", 1:10, sep = ""))

#Join baskets to main data set
ukb3 <- left_join(ukb2, PUFAs)
ukb3 <- left_join(ukb3, BMI)

#Add Age^2 column
ukb3 <- ukb3 %>% mutate(AgeSquared = age_when_attended_assessment_centre_f21003_0_0^2)

#Add Age*Sex column
ukb3 <- ukb3 %>% mutate(AgeSex = ifelse(sex_f31_0_0 == "Male", age_when_attended_assessment_centre_f21003_0_0, 0)) %>% 
                 select(FID, IID, starts_with("Age"), AgeSex, everything())

colnames(ukb3)[3] <- "Age"
colnames(ukb3)[6] <- "Sex"
colnames(ukb3)[7:16] <- paste("PCA", 1:10, sep="")
colnames(ukb3)[17:31] <- c("w3FA", "w3FA_TFAP", "w6FA", "w6FA_TFAP", "w6_w3_ratio", "DHA", "DHA_TFAP", "LA", 
                           "LA_TFAP", "PUFA", "PUFA_TFAP", "MUFA", "MUFA_TFAP", "PUFA_MUFA_ratio", "BMI")

#Remove if missing phenotypes
ukb4 <- ukb3
for (i in 17:31) {
  ukb4 <- ukb4[!is.na(ukb4[, i]), ]
}

write.table(ukb4, file = "/scratch/ahc87874/Fall2022/pheno/VQTLPheno.txt", sep = "\t", row.names = FALSE, quote = FALSE)
write.csv(ukb4, file = "/scratch/ahc87874/Fall2022/pheno/VQTLPheno.csv", row.names = FALSE, quote = FALSE)
