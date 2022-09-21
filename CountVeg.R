# Get counts for CSRV and SSRV for the initial and recall surveys
# CSRV = self-ID vegatarian, field 20086
# SSRV = true vegetarian, field 

#Remove withdrawn at the end

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

#--------------------------------------------------------------------------------------------------------------------------------------------------------
#CSRV

#Get all participants that self-IDed as vegetarian/vegan at least once in the initial and recall surveys
ukbveg <- ukb %>% filter(if_any(starts_with("type_of_special_diet_followed"), ~ . %in% c("Vegetarian", "Vegan")))
#nrow(ukbveg)
#9454 rows

#Select 20080 and 20086
#names(ukb[,c(618:622, 763:792)])
ukb2 <- ukb %>% select(starts_with(c("eid", "dayofweek_questionnaire_completed", "type_of_special_diet_followed", "daily_dietary_data_credible")))                
#apply(ukb2, 2, table)
#41 columns

#Remove participants that never answered 20086
ukb3 <- ukb2[rowSums(is.na(ukb2[, paste("dayofweek_questionnaire_completed_f20080_", 0:4, "_0", sep = "")])) != 5,]
#nrow(ukb3)
#211018 rows

#For each instance, get Veg status if participant answered that survey
for (i in 0:4) { #instance
  took <- paste("dayofweek_questionnaire_completed_f20080_", i, "_0", sep = "")
  tot <- paste("is_vegetarian", i, sep="_")
  ukb3[, tot] <- NA #initialize NA columns
  
  ukb3[, tot][!is.na(ukb3[, took])] <- "NonVeg" #participant answered in that instance
  
  for (j in 0:5) { #instance array for 20086
    inst <- paste("type_of_special_diet_followed_f20086_", i, "_", j, sep = "")
    ukb3[, tot][ukb3[, inst] == "Vegetarian" | ukb3[, inst] == "Vegan"] <- "Veg" #participant is veg for that instance
  }
}

#Get CSRV
ukb3[, "CSRV"] <- "Veg"
for (i in 0:4) { #instance
  tot <- paste("is_vegetarian", i, sep="_")
  ukb3[, "CSRV"][ukb3[, tot] == "NonVeg"] <- "NonVeg"
}
#print(n = 50, ukb3[36:41])

table(ukb3$CSRV)
#204172 CSRV NonVeg
#6846 CSRV Veg
#Michael had 5733

ukb3 %>% select(starts_with("is_vegetarian")) %>% filter_all(all_vars(!is.na(.))) 
#or ukb3 %>% select(starts_with("is_vegetarian")) %>% filter(if_all(everything(), ~ grepl("", .)))
ukb3 %>% select(starts_with("is_vegetarian")) %>% filter_all(all_vars(. == "Veg"))
#5766 answered all surveys
#182 answered Veg across all surveys

#--------------------------------------------------------------------------------------------------------------------------------------------------------
#SSRV
#Remove non-credible diet data
#select(-starts_with("daily_dietary_data_credible"), starts_with("daily_dietary_data_credible"))

#--------------------------------------------------------------------------------------------------------------------------------------------------------
#Withdrawn
#pheno <- pheno[!(pheno$IID %in% withdrawn$V1), ]
ukb3withdrawn <- ukb3[!(ukb3$eid %in% withdrawn$V1), ]
table(ukb3withdrawn$CSRV)
#204140 CSRV NonVeg (-32)
#6844 CSRV Veg (-2)
