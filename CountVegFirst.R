# Get counts for CSRV and SSRV for the initial and recall surveys
# CSRV = self-ID vegatarian, field 20086
# SSRV = true vegetarian, field 

#Load packages and set up wd
suppressMessages(library(plyr))
suppressMessages(library(dplyr))
suppressMessages(library(tidyverse))
#suppressMessages(library(ggpubr))
suppressMessages(library(ukbtools)) #<3
suppressMessages(library(rio))

setwd("/scratch/ahc87874/Fall2022")
#source('/scratch/ahc87874/Fall2022/load_UKBphenotables.R')

#Load dataset
#ukb <- ukb_df("ukb34137")
ukb <- import("ukb34137.tsv")
ukb <- as_tibble(ukb)

#Remove withdrawn participants from dataset
withdrawn <-read.csv("w48818_20210809.csv", header = FALSE)
ukb <- ukb[!(ukb$eid %in% withdrawn$V1), ] #Removes 34

#Select necessary columns
#Need to add BMI and pheno columns
#Change to contains?
ukb2 <- ukb %>% select(eid, age_when_attended_assessment_centre_f21003_0_0, sex_f31_0_0, genetic_sex_f22001_0_0, 
                       ethnic_background_f21000_0_0, outliers_for_heterozygosity_or_missing_rate_f22027_0_0, 
                       sex_chromosome_aneuploidy_f22019_0_0, genetic_kinship_to_other_participants_f22021_0_0, 
                       townsend_deprivation_index_at_recruitment_f189_0_0, uk_biobank_assessment_centre_f54_0_0, 
                       genotype_measurement_batch_f22000_0_0, 
                       starts_with(c("dayofweek_questionnaire_completed", "type_of_special_diet_followed", 
                                     "meat_consumers", "fish_consumer")),
                       oily_fish_intake_f1329_0_0, nonoily_fish_intake_f1339_0_0, processed_meat_intake_f1349_0_0,
                       poultry_intake_f1359_0_0, beef_intake_f1369_0_0, lambmutton_intake_f1379_0_0, pork_intake_f1389_0_0,
                       age_when_last_ate_meat_f3680_0_0, major_dietary_changes_in_the_last_5_years_f1538_0_0,
                       starts_with("daily_dietary_data_credible"))
#apply(ukb2, 2, table)
# columns

#Add Age^2 column
ukb2 <- ukb2 %>% mutate(age_when_attended_assessment_centre_squared = age_when_attended_assessment_centre_f21003_0_0^2) %>% 
                 select(eid, starts_with("age_when_attended_assessment_centre"), everything())

#Remove participants that never answered 20086/never did a dietary survey
ukb3 <- ukb2[rowSums(is.na(ukb2[, paste("dayofweek_questionnaire_completed_f20080", 0:4, "0", sep = "_")])) != 5,]
#nrow(ukb3)
#210984 rows

#--------------------------------------------------------------------------------------------------------------------------------------------------------
#CSRV

ukbCSRV <- ukb3

#Get first answered recall survey
ukbCSRV <- ukbCSRV %>% mutate(first_instance_0 = !is.na(dayofweek_questionnaire_completed_f20080_0_0)) %>% 
  mutate(first_instance_1 = !is.na(dayofweek_questionnaire_completed_f20080_1_0) & !first_instance_0) %>% 
  mutate(first_instance_2 = !is.na(dayofweek_questionnaire_completed_f20080_2_0) & !first_instance_0 & !first_instance_1) %>% 
  mutate(first_instance_3 = !is.na(dayofweek_questionnaire_completed_f20080_3_0) & !first_instance_0 & !first_instance_1 & !first_instance_2) %>% 
  mutate(first_instance_4 = !is.na(dayofweek_questionnaire_completed_f20080_4_0) & !first_instance_0 & !first_instance_1 & !first_instance_2 & !first_instance_3)

ukbCSRV <- ukbCSRV %>% mutate(first_instance = ifelse(first_instance_0, 0, 
                                                      ifelse(first_instance_1, 1, 
                                                             ifelse(first_instance_2, 2, 
                                                                    ifelse(first_instance_3, 3, 
                                                                           ifelse(first_instance_4, 4, NA))))))

#sapply(ukbCSRV %>% select(contains(c("f20080", "first_instance"))), table)

#For each first instance, get Veg status
for (i in 0:4) { #instance
  took <- paste("first_instance", i, sep = "_")
  check <- paste("is_CSRV_vegetarian", i, sep = "_")
  ukbCSRV[, check] <- NA #initialize NA columns
  ukbCSRV[, check][ukbCSRV[, took] == TRUE] <- "NonVeg" #participant first answered in that instance
  
  for (j in 0:5) { #instance array for 20086
    inst <- paste("type_of_special_diet_followed_f20086", i, j, sep = "_")
    #ukbCSRV[, check][(ukbCSRV[, inst] == "Vegetarian" | ukbCSRV[, inst] == "Vegan") & ukbCSRV[, took] == TRUE] <- "Veg" #participant is veg for that instance
    ukbCSRV[, check][ukbCSRV[, inst] == "Vegetarian" & ukbCSRV[, took] == TRUE] <- "Veg" #participant is veg for that instance
  }
}

#ukbCSRV %>% select(contains(c("first_instance", "is_CSRV_vegetarian")))
sapply(ukbCSRV %>% select(contains("is_CSRV_vegetarian")), table)

#Get CSRV
ukbCSRV[, "CSRV"] <- "Veg"
for (i in 0:4) { #instance
  check <- paste("is_CSRV_vegetarian", i, sep="_")
  ukbCSRV[, "CSRV"][ukbCSRV[, check] == "NonVeg"] <- "NonVeg"
}

table(ukbCSRV$CSRV)
#NonVeg    Veg
#203241   7777
