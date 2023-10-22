# Get counts for CSRV and SSRV for the initial and recall surveys, first response only
# CSRV = self-ID vegatarian, field 20086
# SSRV = true vegetarian, field 

#Load packages and set up wd
suppressMessages(library(plyr))
suppressMessages(library(dplyr))
suppressMessages(library(data.table))
suppressMessages(library(tidyverse))
suppressMessages(library(ukbtools)) #<3
suppressMessages(library(rio))

#Load dataset
setwd("/scratch/ahc87874/Fall2022/pheno/")

ukb <- ukb_df("ukb34137")
ukb <- as_tibble(ukb)

#Load auxillary datasets
if (FALSE) {
  setwd("/scratch/ahc87874/FishOil/pheno/673621/")
  NMR <- ukb_df("ukb673621", n_threads = "max", data.pos = 2)
  NMR <- as_tibble(NMR)
  PUFAs <- NMR %>% select(eid, contains("f23444_0_0"), contains("f23451_0_0"), contains("f23445_0_0"), contains("f23452_0_0"), 
                          contains("f23459_0_0"), contains("f23450_0_0"), contains("f23457_0_0"), contains("f23449_0_0"), 
                          contains("f23456_0_0"), contains("f23446_0_0"), contains("f23453_0_0"), contains("f23447_0_0"), 
                          contains("f23454_0_0"), contains("f23458_0_0"), contains("f23744_0_0"), contains("f23751_0_0"), 
                          contains("f23745_0_0"), contains("f23752_0_0"), contains("f23759_0_0"), contains("f23750_0_0"), 
                          contains("f23757_0_0"), contains("f23749_0_0"), contains("f23756_0_0"), contains("f23746_0_0"), 
                          contains("f23753_0_0"), contains("f23747_0_0"), contains("f23754_0_0"), contains("f23758_0_0")) %>% as_tibble() 

  colnames(PUFAs) <- c("IID", "w3FA", "w3FA_TFAP", "w6FA", "w6FA_TFAP",	
                       "w6_w3_ratio", "DHA", "DHA_TFAP", "LA", "LA_TFAP",
                       "PUFA", "PUFA_TFAP", "MUFA", "MUFA_TFAP", "PUFA_MUFA_ratio", 
                       "w3FA_QCflag", "w3FA_TFAP_QCflag", "w6FA_QCflag", "w6FA_TFAP_QCflag", "w6_w3_ratio_QCflag",
                       "DHA_QCflag", "DHA_TFAP_QCflag",	"LA_QCflag", "LA_TFAP_QCflag", "PUFA_QCflag",
                       "PUFA_TFAP_QCflag", "MUFA_QCflag", "MUFA_TFAP_QCflag", "PUFA_MUFA_ratio_QCflag")  
  
  #Save datasets
  write.csv(PUFAs, file = "/scratch/ahc87874/Fall2022/pheno/PUFAsnew.csv", row.names = FALSE, quote = FALSE)
} else {
  PUFAs <- import("/scratch/ahc87874/Fall2022/pheno/PUFAsnew.csv")
}
PUFAs <- as_tibble(PUFAs)

setwd("/scratch/ahc87874/FishOil/pheno/")

FishOil <-as_tibble(read.table("/scratch/ahc87874/FishOil/pheno/ID_fish_oil_status.txt", header = TRUE))

#Select necessary columns
colnames(ukb)[1] <- "IID"
ukb <- ukb %>% mutate(FID = IID)

#Subset columns
ukb2 <- ukb %>% select(FID, IID, age_when_attended_assessment_centre_f21003_0_0, sex_f31_0_0, genetic_sex_f22001_0_0, 
                       ethnic_background_f21000_0_0, outliers_for_heterozygosity_or_missing_rate_f22027_0_0, 
                       sex_chromosome_aneuploidy_f22019_0_0, genetic_kinship_to_other_participants_f22021_0_0, 
                       genotype_measurement_batch_f22000_0_0, uk_biobank_assessment_centre_f54_0_0, 
                       townsend_deprivation_index_at_recruitment_f189_0_0, used_in_genetic_principal_components_f22020_0_0,
                       paste("genetic_principal_components_f22009_0_", 1:10, sep = ""))

#Join baskets to main data set
ukb3 <- left_join(ukb2, PUFAs, by = "IID")
ukb3 <- left_join(ukb3, FishOil, by = c("FID", "IID"))
#123 cols

#Remove withdrawn participants from dataset
withdrawn <-read.csv("/scratch/ahc87874/Fall2022/pheno/w48818_2023-04-25.csv", header = FALSE)
ukb3 <- ukb3[!(ukb3$IID %in% withdrawn$V1), ] #Removes 114

#Add Age^2 column
ukb3 <- ukb3 %>% mutate(age_when_attended_assessment_centre_squared = age_when_attended_assessment_centre_f21003_0_0^2)

#Add Age*Sex column
ukb3 <- ukb3 %>% mutate(agesex = ifelse(sex_f31_0_0 == "Male", age_when_attended_assessment_centre_f21003_0_0, 0)) %>% 
                 select(FID, IID, starts_with("age_when_attended_assessment_centre"), agesex, everything())

#Save dataset
write.table(ukb3, file = "/scratch/ahc87874/FishOil/pheno/phenosfish.txt", sep = "\t", row.names = FALSE, quote = FALSE)
                                                                                  
write.csv(ukb3, file = "/scratch/ahc87874/FishOil/pheno/phenosfish.csv", row.names = FALSE, quote = FALSE)
