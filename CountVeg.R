# Get counts for CSRV and SSRV for the initial and recall surveys
# CSRV = self-ID vegatarian, field 20086
# SSRV = true vegetarian, field 

#Load packages and set up wd
suppressMessages(library(plyr))
suppressMessages(library(dplyr))
suppressMessages(library(tidyverse))
suppressMessages(library(ggpubr))
suppressMessages(library(ukbtools)) #<3
suppressMessages(library(rio))

setwd("/scratch/ahc87874/Fall2022")
#source('/scratch/ahc87874/Fall2022/load_UKBphenotables.R')

#Load dataset
ukb <- ukb_df("ukb34137")
ukb <- as_tibble(ukb)

#Remove withdrawn participants from dataset
withdrawn <-read.csv("w48818_20210809.csv", header = FALSE)
ukb <- ukb[!(ukb$eid %in% withdrawn$V1), ]

#Select necessary columns
#Need to add BMI, SSRV, and pheno columns
ukb2 <- ukb %>% select(eid, age_when_attended_assessment_centre_f21003_0_0, sex_f31_0_0, genetic_sex_f22001_0_0, 
                       ethnic_background_f21000_0_0, outliers_for_heterozygosity_or_missing_rate_f22027_0_0, 
                       sex_chromosome_aneuploidy_f22019_0_0, genetic_kinship_to_other_participants_f22021_0_0, 
                       townsend_deprivation_index_at_recruitment_f189_0_0, uk_biobank_assessment_centre_f54_0_0, 
                       genotype_measurement_batch_f22000_0_0, 
                       starts_with(c("dayofweek_questionnaire_completed", "type_of_special_diet_followed", "daily_dietary_data_credible")))
#apply(ukb2, 2, table)
# columns

#Add Age^2 column
ukb2 <- ukb2 %>% mutate(age_when_attended_assessment_centre_squared = age_when_attended_assessment_centre_f21003_0_0^2) %>% 
                 select(eid, starts_with("age_when_attended_assessment_centre"), everything())

#Remove participants that never answered 20086/never did a dietary survey
ukb3 <- ukb2[rowSums(is.na(ukb2[, paste("dayofweek_questionnaire_completed_f20080", 0:4, "0", sep = "_")])) != 5,]
#nrow(ukb3)
#211018 rows

#--------------------------------------------------------------------------------------------------------------------------------------------------------
#Pheno QC
#idk
#--------------------------------------------------------------------------------------------------------------------------------------------------------
#CSRV

ukbCSRV <- ukb3

#Get all participants that self-IDed as vegetarian/vegan at least once in the initial and recall surveys
ukbveg <- ukb %>% filter(if_any(starts_with("type_of_special_diet_followed"), ~ . %in% c("Vegetarian", "Vegan")))
#nrow(ukbveg)
#9454 rows

#For each instance, get Veg status if participant answered that survey
for (i in 0:4) { #instance
  took <- paste("dayofweek_questionnaire_completed_f20080", i, "0", sep = "_")
  tot <- paste("is_vegetarian", i, sep = "_")
  ukbCSRV[, tot] <- NA #initialize NA columns
  
  ukbCSRV[, tot][!is.na(ukbCSRV[, took])] <- "NonVeg" #participant answered in that instance
  
  for (j in 0:5) { #instance array for 20086
    inst <- paste("type_of_special_diet_followed_f20086", i, j, sep = "_")
    ukbCSRV[, tot][ukbCSRV[, inst] == "Vegetarian" | ukbCSRV[, inst] == "Vegan"] <- "Veg" #participant is veg for that instance
  }
}

#Get CSRV
ukbCSRV[, "CSRV"] <- "Veg"
for (i in 0:4) { #instance
  tot <- paste("is_vegetarian", i, sep="_")
  ukbCSRV[, "CSRV"][ukbCSRV[, tot] == "NonVeg"] <- "NonVeg"
}
#print(n = 50, ukb3[36:41])

table(ukbCSRV$CSRV)
#204172 CSRV NonVeg pre-QC
#6846 CSRV Veg pre-QC
#Michael had 5733 post-QC

ukbCSRV %>% select(starts_with("is_vegetarian")) %>% filter_all(all_vars(!is.na(.))) 
#or ukb3 %>% select(starts_with("is_vegetarian")) %>% filter(if_all(everything(), ~ grepl("", .)))
ukbCSRV %>% select(starts_with("is_vegetarian")) %>% filter_all(all_vars(. == "Veg"))
#5766 answered all surveys pre-QC
#182 answered Veg across all surveys pre-QC

#names(ukb3)
# [1] "eid"
# [2] "dayofweek_questionnaire_completed_f20080_0_0"
# [7] "type_of_special_diet_followed_f20086_0_0"
# [37] "daily_dietary_data_credible_f100026_0_0"
# [42] "is_vegetarian_0"
# [47] "CSRV"

#--------------------------------------------------------------------------------------------------------------------------------------------------------
#SSRV
ukbSSRV <- ukbCSRV

#Remove non-credible diet data if ever not credible in any answered survey
#select(-starts_with("daily_dietary_data_credible"), starts_with("daily_dietary_data_credible"))
idk2 <- idk[rowSums(!is.na(idk[, paste("daily_dietary_data_credible_f100026", 0:4, "0", sep = "_")])) > 0,]
#Removes ? participants

#--------------------------------------------------------------------------------------------------------------------------------------------------------
#Withdrawn
#pheno <- pheno[!(pheno$IID %in% withdrawn$V1), ]
ukbCSRVwithdrawn <- ukbCSRV[!(ukbCSRV$eid %in% withdrawn$V1), ]
table(ukbCSRVwithdrawn$CSRV) #OLD
#204140 CSRV NonVeg (-32)
#6844 CSRV Veg (-2)
