# Get counts for CSRV and SSRV for the initial and recall surveys
# CSRV = self-ID vegatarian, field 20086
# SSRV = true vegetarian, field 

# SpecialDiet<-bd%>%select(f.eid, f.20086.0.0, f.20086.1.0, f.20086.2.0, f.20086.3.0, f.20086.4.0)
# Remove withdrawn at the end

suppressMessages(library(plyr))
suppressMessages(library(dplyr))
suppressMessages(library(tidyverse))
suppressMessages(library(ggpubr))
suppressMessages(library(ukbtools))
suppressMessages(library(rio))

setwd("/scratch/ahc87874/Fall2022")

#source('/scratch/ahc87874/Fall2022/load_UKBphenotables.R')

ukb <- ukb_df("ukb34137")
ukb <- as_tibble(ukb)

withdrawn <-read.csv("w48818_20210809.csv", header = FALSE)

#Get all participants that self-IDed as vegetarian/vegan at least once in the initial and recall surveys
ukbveg <- ukb %>% filter(if_any(starts_with("type_of_special_diet_followed"), ~ . %in% c("Vegetarian", "Vegan")))
#nrow(ukbveg)
#9454 rows

#Select 20080 and 20086
#names(ukb[,c(618:622, 763:792)])
ukb2 <- ukb %>% select(starts_with(c("dayofweek_questionnaire_completed", "type_of_special_diet_followed")))                
#apply(ukb2, 2, table)

#Remove participants that never answered 20086
ukb3 <- ukb2[rowSums(is.na(ukb2[,1:5])) != 5,]
#nrow(ukb3)
#211018 rows

#Check if participant took survey
# <- "Nonveg"
  
#for (j in 0:5) {
#  inst <- paste("type_of_special_diet_followed_f20086_", 0, "_", j, sep = "")
#  x[[tot]][x[, inst] == "Vegetarian" | x[, inst] == "Vegan"] <- "Veg"
#}

for (i in 0:4) { #instance
  took <- paste("dayofweek_questionnaire_completed_f20080_", i, "_0", sep = "")
  tot <- paste("is_vegetarian", i, sep="_")
  ukb3[[tot]] <- NA #initialize NA columns
  
  #new column for completed = "nonveg", else = NA
  ukb3[[tot]][!is.na(ukb3[, took])] <- "Nonveg"
  
  for (j in 0:5) { #instance array for 20086
    inst <- paste("type_of_special_diet_followed_f20086_", i, "_", j, sep = "")
    ukb3[[tot]][ukb3[, inst] == "Vegetarian" | ukb3[, inst] == "Vegan"] <- "Veg"
  }
}

ukb4 <- ukb3 %>% select(starts_with("is_vegetarian"))
ukb4 %>% filter(!if_any(everything(), ~ . %in% "Nonveg")) #2463??

x2[x2$is_vegetarian_0 != "Nonveg", ] #3884 in initial
x2 %>% filter_all(all_vars(!grepl("Nonveg", .)))
#3192 CSRV
#894 full veg across all surveys

#Michael had 5733

#pheno <- pheno[!(pheno$IID %in% withdrawn$V1), ]
