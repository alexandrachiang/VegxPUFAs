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
PUFAs <- import("/scratch/ahc87874/Fall2022/pheno/PUFAsINT.csv")
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
