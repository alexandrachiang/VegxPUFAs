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

isCredible <- FALSE
keepNonVeg <- TRUE

#Load dataset
if (FALSE) {
  source('/scratch/ahc87874/Fall2022/load_UKBphenotables.R')
  ukbnames <- read.csv("ukbnames.csv")$value
  bd <- as_tibble(bd)
  names(bd) <- as.vector(ukbnames$value)
  ukb <- as_tibble(bd)
} else {
  ukb <- ukb_df("ukb34137")
  #ukb <- import("ukb34137.tsv")
  ukb <- as_tibble(ukb)
}

#Load auxillary datasets
if (FALSE) {
  NMR <- as_tibble(read.table("48364/ukb48364.tab", header = TRUE, sep = "\t")) #For phenotypes
  BSM <- as_tibble(read.table("44781/ukb44781.tab", header = TRUE, sep = "\t")) #For BMI
  Meds <- as_tibble(read.table("47434/ukb47434.tab", header = TRUE, sep = "\t")) #For Medications
  Meds2 <- as_tibble(read.table("updated_42606/ukb42606.tab", header = TRUE, sep = "\t")) #For Statins
  
  #Subset needed columns & rename
  BMI <- BSM %>% select(f.eid, f.21001.0.0) %>% as_tibble() #For BMI

  colnames(BMI) <- c("IID", "body_mass_index_f21001_0_0")
                 
  PUFAs <- NMR %>% select(f.eid, f.23444.0.0, f.23451.0.0, f.23445.0.0, f.23452.0.0, 
                          f.23459.0.0, f.23450.0.0, f.23457.0.0, f.23449.0.0, f.23456.0.0, 
                          f.23446.0.0, f.23453.0.0, f.23447.0.0, f.23454.0.0, f.23458.0.0, 
                          f.23744.0.0, f.23751.0.0, f.23745.0.0, f.23752.0.0, f.23759.0.0, 
                          f.23750.0.0, f.23757.0.0, f.23749.0.0, f.23756.0.0, f.23746.0.0, 
                          f.23753.0.0, f.23747.0.0, f.23754.0.0, f.23758.0.0) %>% as_tibble() 

  colnames(PUFAs) <- c("IID", "w3FA", "w3FA_TFAP", "w6FA", "w6FA_TFAP",	
                       "w6_w3_ratio", "DHA", "DHA_TFAP", "LA", "LA_TFAP",
                       "PUFA", "PUFA_TFAP", "MUFA", "MUFA_TFAP", "PUFA_MUFA_ratio", 
                       "w3FA_QCflag", "w3FA_TFAP_QCflag", "w6FA_QCflag", "w6FA_TFAP_QCflag", "w6_w3_ratio_QCflag",
                       "DHA_QCflag", "DHA_TFAP_QCflag",	"LA_QCflag", "LA_TFAP_QCflag", "PUFA_QCflag",
                       "PUFA_TFAP_QCflag", "MUFA_QCflag", "MUFA_TFAP_QCflag", "PUFA_MUFA_ratio_QCflag")
  
  LipidMeds <- Meds %>% select(f.eid, f.6177.0.0, f.6177.0.1, f.6177.0.2, 
                               f.6153.0.0, f.6153.0.1, f.6153.0.2, f.6153.0.3) %>% as_tibble()
  
  colnames(LipidMeds) <- c("IID", paste("medication_for_cholesterol_blood_pressure_or_diabetes_f6177_0_", 0:2, sep = ""), 
                           paste("medication_for_cholesterol_blood_pressure_diabetes_or_take_exogenous_hormones_f6153_0_", 0:3, sep = ""))
  
  
  for (i in 0:2) {
    combined <- paste("medication_combined_f6153_f6177_0", i, sep = "_")
    f6153 <- paste("medication_for_cholesterol_blood_pressure_diabetes_or_take_exogenous_hormones_f6153_0", i, sep = "_")
    f6177 <- paste("medication_for_cholesterol_blood_pressure_or_diabetes_f6177_0", i, sep = "_")
    LipidMeds[, combined] <- NA

    for (j in 1:nrow(LipidMeds)) {
      if (!is.na(LipidMeds[j, f6153])) {
        LipidMeds[j, combined] <- LipidMeds[j, f6153]
      } else {
        LipidMeds[j, combined] <- LipidMeds[j, f6177]
      }
    }
  }
  LipidMeds$medication_combined_f6153_f6177_0_3 <- LipidMeds$medication_for_cholesterol_blood_pressure_diabetes_or_take_exogenous_hormones_f6153_0_3
  
  Statins <- Meds2 %>% select(f.eid, contains("20003.0"))
  StatinCodes <- c(1141146234,1141192414,1140910632,1140888594,1140864592, 1141146138,1140861970,1140888648,1141192410, 
                   1141188146,1140861958,1140881748,1141200040)
  
  Statins <- Statins %>% mutate(treatment_medication_code_f20003_0 = ifelse(apply(Statins, 1, function(r) any(r %in% StatinCodes)) == TRUE, 1, 0)) %>% select(f.eid, treatment_medication_code_f20003_0)
  colnames(Statins) <- c("IID", "treatment_medication_code_f20003_0")
  
  #Save datasets
  write.table(BMI, file = "/scratch/ahc87874/Fall2022/pheno/BMI.txt",
              row.names = FALSE, quote = FALSE)
  write.table(PUFAs, file = "/scratch/ahc87874/Fall2022/pheno/PUFAs.txt",
              row.names = FALSE, quote = FALSE)
  write.table(LipidMeds, file = "/scratch/ahc87874/Fall2022/pheno/LipidMeds.txt",
              row.names = FALSE, quote = FALSE)
  write.table(Statins, file = "/scratch/ahc87874/Fall2022/pheno/Statins.txt",
              row.names = FALSE, quote = FALSE)
} else {
  BMI <- as_tibble(read.table("BMI.txt", header = TRUE))
  PUFAs <- as_tibble(read.table("PUFAs.txt", header = TRUE))
  LipidMeds <- as_tibble(read.table("LipidMeds.txt", header = TRUE))
  Statins <- as_tibble(read.table("Statins.txt", header = TRUE))
}

#Select necessary columns
#Need to add BMI and pheno columns
#Change to contains?
colnames(ukb)[1] <- "IID"
ukb <- ukb %>% mutate(FID = IID)

#Subset columns
ukb2 <- ukb %>% select(FID, IID, age_when_attended_assessment_centre_f21003_0_0, sex_f31_0_0, genetic_sex_f22001_0_0, 
                       ethnic_background_f21000_0_0, outliers_for_heterozygosity_or_missing_rate_f22027_0_0, 
                       sex_chromosome_aneuploidy_f22019_0_0, genetic_kinship_to_other_participants_f22021_0_0, 
                       genotype_measurement_batch_f22000_0_0, uk_biobank_assessment_centre_f54_0_0, 
                       townsend_deprivation_index_at_recruitment_f189_0_0, used_in_genetic_principal_components_f22020_0_0,
                       paste("genetic_principal_components_f22009_0_", 1:10, sep = ""),
                       starts_with(c("dayofweek_questionnaire_completed", "type_of_special_diet_followed", 
                                     "meat_consumers", "fish_consumer")),
                       oily_fish_intake_f1329_0_0, nonoily_fish_intake_f1339_0_0, processed_meat_intake_f1349_0_0,
                       poultry_intake_f1359_0_0, beef_intake_f1369_0_0, lambmutton_intake_f1379_0_0, pork_intake_f1389_0_0,
                       age_when_last_ate_meat_f3680_0_0, major_dietary_changes_in_the_last_5_years_f1538_0_0,
                       starts_with("daily_dietary_data_credible"))

#Join baskets to main data set
ukb3 <- left_join(ukb2, BMI)
ukb3 <- left_join(ukb3, PUFAs)
ukb3 <- left_join(ukb3, LipidMeds)
ukb3 <- left_join(ukb3, Statins)
#123 cols

#Remove withdrawn participants from dataset
withdrawn <-read.csv("w48818_20220222.csv", header = FALSE)
ukb3 <- ukb3[!(ukb3$IID %in% withdrawn$V1), ] #Removes 114

#Add Age^2 column
ukb3 <- ukb3 %>% mutate(age_when_attended_assessment_centre_squared = age_when_attended_assessment_centre_f21003_0_0^2) %>% 
                 select(FID, IID, starts_with("age_when_attended_assessment_centre"), everything())

#Remove participants that never answered 20086/never did a dietary survey
ukb4 <- ukb3[rowSums(is.na(ukb3[, paste("dayofweek_questionnaire_completed_f20080", 0:4, "0", sep = "_")])) != 5,]
#nrow(ukb3)
#210967 rows

#Get first answered recall survey
ukb5 <- ukb4 %>% mutate(first_instance_0 = !is.na(dayofweek_questionnaire_completed_f20080_0_0)) %>% 
  mutate(first_instance_1 = !is.na(dayofweek_questionnaire_completed_f20080_1_0) & !first_instance_0) %>% 
  mutate(first_instance_2 = !is.na(dayofweek_questionnaire_completed_f20080_2_0) & !first_instance_0 & !first_instance_1) %>% 
  mutate(first_instance_3 = !is.na(dayofweek_questionnaire_completed_f20080_3_0) & !first_instance_0 & !first_instance_1 & !first_instance_2) %>% 
  mutate(first_instance_4 = !is.na(dayofweek_questionnaire_completed_f20080_4_0) & !first_instance_0 & !first_instance_1 & !first_instance_2 & !first_instance_3)

ukb5 <- ukb5 %>% mutate(first_instance = ifelse(first_instance_0, 0, 
                                                      ifelse(first_instance_1, 1, 
                                                             ifelse(first_instance_2, 2, 
                                                                    ifelse(first_instance_3, 3, 
                                                                           ifelse(first_instance_4, 4, NA))))))

#sapply(ukb5 %>% select(contains(c("f20080", "first_instance"))), table)
#$first_instance
#    0     1     2     3     4
#70692 79599 27105 19639 13932

#--------------------------------------------------------------------------------------------------------------------------------------------------------
#Diet QC
#Should remove people who are NA for intake, not credible diet data

#Remove non-credible diet data if ever not credible in any answered survey
#ukb6 <- ukb5[rowSums(is.na(ukb4[, paste("daily_dietary_data_credible_f100026", 0:4, "0", sep = "_")])) == 5,]
#removes 3171

#Remove if not credible in first answered survey
ukb6 <- ukb5
for (i in 0:4) { #instance
  took <- paste("first_instance", i, sep = "_")
  check <- paste("is_not_credible", i, sep = "_")
  cred <- paste("daily_dietary_data_credible_f100026", i, "0", sep = "_")
  
  ukb6[, check] <- NA
  ukb6[, check][ukb5[, cred] == "No" & ukb6[, took] == TRUE] <- "NotCredible"
}
#ukb5 %>% select(contains("daily_dietary_data_credible_f100026")) %>% sapply(table)
#    daily_dietary_data_credible_f100026_0_0
#No                                      677
#    daily_dietary_data_credible_f100026_1_0
#No                                      710
#    daily_dietary_data_credible_f100026_2_0
#No                                      633
#    daily_dietary_data_credible_f100026_3_0
#No                                      670
#    daily_dietary_data_credible_f100026_4_0
#No                                      804
#ukb5 %>% select(contains("is_not_credible")) %>% sapply(table)
#is_not_credible_0.NotCredible is_not_credible_1.NotCredible
#                          676                           570
#is_not_credible_2.NotCredible is_not_credible_3.NotCredible
#                          201                           154
#is_not_credible_4.NotCredible
#                          145

ukb6[, "is_not_credible"] <- NA
for (i in 0:4) { #instance
  check <- paste("is_not_credible", i, sep="_")
  ukb6[, "is_not_credible"][ukb6[, check] == "NotCredible"] <- "NotCredible"
} #Does not remove anyone
#ukb5 <- ukb5[ukb5$is_not_credible != "NotCredible", ]
#removes 1746 not credible

#ukb6 <- ukb6 %>% filter(!is.na(oily_fish_intake_f1329_0_0) & !is.na(nonoily_fish_intake_f1339_0_0) & 
#                           !is.na(processed_meat_intake_f1349_0_0) & !is.na(poultry_intake_f1359_0_0) & 
#                           !is.na(beef_intake_f1369_0_0) & !is.na(lambmutton_intake_f1379_0_0) & 
#                           !is.na(pork_intake_f1389_0_0))
#nrow(ukb5)
#207731 removes 82

#Move to pheno qc?

#--------------------------------------------------------------------------------------------------------------------------------------------------------
#CSRV
ukbCSRV <- ukb6

#Get all participants that self-IDed as vegetarian/vegan at least once in the initial and recall surveys
ukbCSRV %>% filter(if_any(starts_with("type_of_special_diet_followed"), ~ . %in% c("Vegetarian", "Vegan")))
#9450 rows

#For each first instance, get Veg status
for (i in 0:4) { #instance
  took <- paste("first_instance", i, sep = "_")
  check <- paste("is_CSRV_vegetarian", i, sep = "_")
  ukbCSRV[, check] <- NA #initialize NA columns
  ukbCSRV[, check][ukbCSRV[, took] == TRUE] <- "NonVeg" #participant first answered in that instance
  
  for (j in 0:5) { #instance array for 20086
    inst <- paste("type_of_special_diet_followed_f20086", i, j, sep = "_")
    ukbCSRV[, check][(ukbCSRV[, inst] == "Vegetarian" | ukbCSRV[, inst] == "Vegan") & ukbCSRV[, took] == TRUE] <- "Veg" #participant is veg for that instance
    #ukbCSRV[, check][ukbCSRV[, inst] == "Vegetarian" & ukbCSRV[, took] == TRUE] <- "Veg" #participant is veg for that instance
  }
}

#ukbCSRV %>% select(contains(c("first_instance", "is_CSRV_vegetarian")))
#sapply(ukbCSRV %>% select(contains("is_CSRV_vegetarian")), table)

#Get CSRV
ukbCSRV[, "CSRV"] <- NA
for (i in 0:4) { #instance
  check <- paste("is_CSRV_vegetarian", i, sep="_")
  ukbCSRV[, "CSRV"][ukbCSRV[, check] == "Veg"] <- "Veg"
  ukbCSRV[, "CSRV"][ukbCSRV[, check] == "NonVeg"] <- "NonVeg"
}

table(ukbCSRV$CSRV)
#NonVeg    Veg
#202724   8243 withdraw, vegetarian and vegan
#Michael had 7788??

#ukbCSRV %>% select(ethnic_background_f21000_0_0, CSRV) %>% table()
#                            CSRV
#ethnic_background_f21000_0_0 NonVeg    Veg
#  Prefer not to answer          580     45
#  Do not know                    60      2
#  White                         154     11
#  Mixed                          13      1
#  Asian or Asian British          9      2
#  Black or Black British          4      1
#  Chinese                       582     14
#  Other ethnic group           1432    109
#  British                    181108   6530
#  Irish                        4943    228
#  Any other white background   7877    396
#  White and Black Caribbean     233     14
#  White and Black African       138     10
#  White and Asian               387     26
#  Any other mixed background    404     26
#  Indian                       1363    602
#  Pakistani                     325     23
#  Bangladeshi                    33      3
#  Any other Asian background    510     74
#  Caribbean                    1490     67
#  African                       965     49
#  Any other Black background     36      3

#--------------------------------------------------------------------------------------------------------------------------------------------------------
#SSRV
ukbSSRV <- ukbCSRV

#For each first instance, get Veg status for meat/fish consumption yesterday
for (i in 0:4) { #instance
  took <- paste("first_instance", i, sep = "_")
  check <- paste("is_SSRV_vegetarian", i, sep = "_")
  ukbSSRV[, check] <- NA #initialize NA columns
  
  #Check if never ate meat/fish
  meatinst <- paste("meat_consumers_f103000", i, 0, sep = "_")
  fishinst <- paste("fish_consumer_f103140", i, 0, sep = "_")
  ukbSSRV[, check][(ukbSSRV[, meatinst] == "Yes" | ukbSSRV[, fishinst] == "Yes") & ukbCSRV[, took] == TRUE] <- "NonVeg" #participant is nonveg for that instance
  ukbSSRV[, check][ukbSSRV[, meatinst] == "No" & ukbSSRV[, fishinst] == "No"  & ukbCSRV[, took] == TRUE] <- "Veg" #participant is veg for that instance
}
#sapply(ukbSSRV %>% select(contains("is_SSRV_vegetarian")), table)
#ukbSSRV %>% mutate(TestSSRV = coalesce(is_SSRV_vegetarian_0, is_SSRV_vegetarian_1, is_SSRV_vegetarian_2, is_SSRV_vegetarian_3, is_SSRV_vegetarian_4)) %>% 
#             select(TestSSRV, CSRV) %>% table()


#Additional columns to filter for diet intake taken at first instance
intake <- as.vector(names(ukbSSRV %>% select(contains("intake"))))
#There are like 84? 85? participants who are NA for these columns
ukbSSRV[, "specific_intake_0"] <- "NonVeg"
ukbSSRV[, "specific_intake_0"][(rowSums(ukbSSRV[, intake] == rep("Never", length(intake))) == 7) & 
                           (!is.na(rowSums(ukbSSRV[, intake] == rep("Never", length(intake))))), ] <- "Veg"
ukbSSRV[, "specific_intake_0"][rowSums(is.na(ukbSSRV[, intake])) > 0, ] <- NA
#table(ukbSSRV$specific_intake_0, useNA = "always")

#ukbSSRV[rowSums(ukbSSRV[, intake] == rep("Never", length(intake))) == 7,] %>% select(contains("intake"))

#for (i in 1:length(intake)) {
#  ukbSSRV[, "meat_intake_0"][ukbSSRV[, intake[i]] != "Never" | is.na(ukbSSRV[, intake[i]])] <- "NonVeg"
#}
#print(n = 50, ukbSSRV %>% select(contains("intake")))
#ukbSSRV %>% select(IID, contains("intake")) %>% filter(IID == 1013495)

#Get SSRV
ukbSSRV[, "SSRV"] <- NA
for (i in 0:4) { #instance
  check <- paste("is_SSRV_vegetarian", i, sep="_")
  ukbSSRV[, "SSRV"][ukbSSRV[, check] == "Veg"] <- "Veg"
  ukbSSRV[, "SSRV"][ukbSSRV[, check] == "NonVeg"] <- "NonVeg"
}
ukbSSRV[, "SSRV"][ukbSSRV[, "specific_intake_0"] == "NonVeg"] <- "NonVeg"

#ukbSSRV %>% select(CSRV, SSRV) %>% table()
#        SSRV
#CSRV     NonVeg    Veg
#  NonVeg 202534    190
#  Veg      3751   4492

#Take CSRV into account for SSRV
ukbSSRV[, "SSRV"][ukbSSRV[, "CSRV"] == "NonVeg"] <- "NonVeg" #Make CSRV NonVeg/SSRV Veg participants into SSRV NonVeg
ukbSSRV$SSRV[(ukbSSRV$CSRV == "Veg" & ukbSSRV$SSRV == "NonVeg")] <- NA #Remove CSRV Veg/SSRV NonVeg participants

#ukbSSRV %>% select(CSRV, SSRV) %>% table()
#        SSRV
#CSRV     NonVeg    Veg
#  NonVeg 202724      0
#  Veg         0   4492

table(ukbSSRV$SSRV, useNA = "always")
#NonVeg    Veg
#202724   4492 with intake and removed participants who were CSRV veg/SSRV nonveg

#NA if any major dietary changes in the last 5 years
if (keepNonVeg) {
  ukbSSRV$SSRV[(ukbSSRV$SSRV == "Veg" & ukbSSRV$major_dietary_changes_in_the_last_5_years_f1538_0_0 != "No") |
             (ukbSSRV$SSRV == "Veg" & is.na(ukbSSRV$major_dietary_changes_in_the_last_5_years_f1538_0_0))] <- NA
} else {
  ukbSSRV$SSRV[ukbSSRV$major_dietary_changes_in_the_last_5_years_f1538_0_0 != "No" |
             is.na(ukbSSRV$major_dietary_changes_in_the_last_5_years_f1538_0_0)] <- NA
}

#table(ukbSSRV$SSRV, useNA = "always")
#NonVeg    Veg   <NA>
#125456   3271  82240

#NA if not credible in first answered survey
#ukbSSRV %>% select(SSRV, is_not_credible) %>% table(useNA = "always")
#        is_not_credible
#SSRV     NotCredible   <NA>
#  NonVeg         930 124526
#  Veg             41   3230
#  <NA>           775  81465
if (isCredible) {
  ukbSSRV$SSRV[ukbSSRV$is_not_credible == "NotCredible"] <- NA
}
#table(ukbSSRV$SSRV, useNA = "always")
#NonVeg    Veg   <NA>
#124526   3230  83211

#ukbSSRV %>% select(ethnic_background_f21000_0_0, SSRV) %>% table()
#                            SSRV
#ethnic_background_f21000_0_0 NonVeg    Veg
#  Prefer not to answer          323     17
#  Do not know                    38      1
#  White                          80      5
#  Mixed                           4      1
#  Asian or Asian British          4      1
#  Black or Black British          2      0
#  Chinese                       383      4
#  Other ethnic group            701     22
#  British                    112454   2704
#  Irish                        2962     86
#  Any other white background   4775    124
#  White and Black Caribbean     140      6
#  White and Black African        71      1
#  White and Asian               217     12
#  Any other mixed background    219      5
#  Indian                        702    217
#  Pakistani                     144      0
#  Bangladeshi                    16      0
#  Any other Asian background    254     14
#  Caribbean                     601      7
#  African                       423      3
#  Any other Black background     13      0

#Save dataset
if (FALSE) {
  
  if (!isCredible) {
    suffix <- "woCred"
  } else if (keepNonVeg) {
    suffic <- "wKeep"
  } else {
    suffix <- ""
  }
  write.table(ukbSSRV, file = paste("/scratch/ahc87874/Fall2022/pheno/CSRVSSRV", suffix, ".txt", sep = ""),
            sep = "\t", row.names = FALSE, quote = FALSE)
                                                                                  
  write.csv(ukbSSRV, file = paste("/scratch/ahc87874/Fall2022/pheno/CSRVSSRV", suffix, ".csv", sep = ""), row.names = FALSE, quote = FALSE)
}                                                           
