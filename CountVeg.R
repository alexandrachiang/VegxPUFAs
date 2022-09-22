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
#Pheno QC
#idk
#--------------------------------------------------------------------------------------------------------------------------------------------------------
#CSRV

ukbCSRV <- ukb3

#Get all participants that self-IDed as vegetarian/vegan at least once in the initial and recall surveys
ukbveg <- ukb %>% filter(if_any(starts_with("type_of_special_diet_followed"), ~ . %in% c("Vegetarian", "Vegan")))
#nrow(ukbveg)
#9451 rows

#For each instance, get Veg status if participant answered that survey
for (i in 0:4) { #instance
  took <- paste("dayofweek_questionnaire_completed_f20080", i, "0", sep = "_")
  check <- paste("is_CSRV_vegetarian", i, sep = "_")
  ukbCSRV[, check] <- NA #initialize NA columns
  ukbCSRV[, check][!is.na(ukbCSRV[, took])] <- "NonVeg" #participant answered in that instance
  
  for (j in 0:5) { #instance array for 20086
    inst <- paste("type_of_special_diet_followed_f20086", i, j, sep = "_")
    ukbCSRV[, check][ukbCSRV[, inst] == "Vegetarian" | ukbCSRV[, inst] == "Vegan"] <- "Veg" #participant is veg for that instance
  }
}

#Get CSRV
ukbCSRV[, "CSRV"] <- "Veg"
for (i in 0:4) { #instance
  check <- paste("is_CSRV_vegetarian", i, sep="_")
  ukbCSRV[, "CSRV"][ukbCSRV[, check] == "NonVeg"] <- "NonVeg"
}

table(ukbCSRV$CSRV)
#204140 (204172 pre-withdraw) CSRV NonVeg pre-QC
#6844 (6846 pre-withdraw) CSRV Veg pre-QC
#Michael had 5733 post-QC

ukbCSRV %>% select(starts_with("is_CSRV_vegetarian")) %>% filter_all(all_vars(!is.na(.))) 
#or ukb3 %>% select(starts_with("is_vegetarian")) %>% filter(if_all(everything(), ~ grepl("", .)))
ukbCSRV %>% select(starts_with("is_CSRV_vegetarian")) %>% filter_all(all_vars(. == "Veg"))
#5765 answered all surveys pre-QC
#182 answered Veg across all surveys pre-QC

#--------------------------------------------------------------------------------------------------------------------------------------------------------
#SSRV
ukbSSRV <- ukbCSRV

#For each instance, get Veg status for meat/fish consumption
for (i in 0:4) { #instance
  check <- paste("is_SSRV_vegetarian", i, sep = "_")
  ukbSSRV[, check] <- NA #initialize NA columns
  
  #Check if never ate meat/fish
  meatinst <- paste("meat_consumers_f103000", i, 0, sep = "_")
  fishinst <- paste("fish_consumer_f103140", i, 0, sep = "_")
  ukbSSRV[, check][ukbSSRV[, meatinst] == "Yes" | ukbSSRV[, fishinst] == "Yes"] <- "NonVeg" #participant is nonveg for that instance
  ukbSSRV[, check][ukbSSRV[, meatinst] == "No" & ukbSSRV[, fishinst] == "No"] <- "Veg" #participant is veg for that instance
}

#Initial has additional columns to filter for diet intake
intake <- as.vector(names(ukbSSRV %>% select(contains("intake"))))
#There are like 84? 85? participants who are NA for these columns, I'm assumming they're nonveg
ukbSSRV[, "meat_intake_0"] <- "Veg"
for (i in 1:length(intake)) {
  ukbSSRV[, "meat_intake_0"][ukbSSRV[, intake[i]] != "Never" | is.na(ukbSSRV[, intake[i]])] <- "NonVeg"
}
#print(n = 50, ukbSSRV %>% select(contains("intake")))
#ukbSSRV %>% select(eid, contains("intake")) %>% filter(eid == 1013495)

#Get SSRV
ukbSSRV[, "SSRV"] <- "Veg"
for (i in 0:4) { #instance
  check <- paste("is_SSRV_vegetarian", i, sep="_")
  ukbSSRV[, "SSRV"][ukbSSRV[, check] == "NonVeg"] <- "NonVeg"
}
ukbSSRV[, "SSRV"][ukbSSRV[, "meat_intake_0"] == "NonVeg"] <- "NonVeg"

#print(n = 50, ukbSSRV %>% select(contains("is_SSRV_vegetarian"), meat_intake_0, SSRV))
#ukbSSRV %>% select(eid, contains("is_SSRV_vegetarian"), meat_intake_0, SSRV)) %>% filter(eid == 1000072)
table(ukbSSRV$SSRV)
#206387 SSRV NonVeg pre-QC
#4597 SSRV Veg pre-QC

#Take CSRV into account for SSRV
ukbSSRV[, "SSRV"][ukbSSRV[, "CSRV"] == "NonVeg"] <- "NonVeg"

table(ukbSSRV$SSRV)
#206678 SSRV NonVeg pre-QC
#4306 SSRV Veg pre-QC

#Remove non-credible diet data if ever not credible in any answered survey
#select(-starts_with("daily_dietary_data_credible"), starts_with("daily_dietary_data_credible"))
ukbSSRV2 <- ukbSSRV[rowSums(is.na(ukbSSRV[, paste("daily_dietary_data_credible_f100026", 0:4, "0", sep = "_")])) == 5,]
nrow(ukbSSRV2)
#207813
#Removes 3171 participants?? ukb website says 3170?

table(ukbSSRV2$SSRV)
#? SSRV NonVeg pre-QC
#? SSRV Veg pre-QC
#Michael had ? post-QC

#--------------------------------------------------------------------------------------------------------------------------------------------------------
