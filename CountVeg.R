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

#invitation_to_complete_online_24hour_recall_dietary_questionnaire_acceptance

#Get all participants that self-IDed as vegetarian/vegan at least once in the initial and recall surveys
ukbveg <- ukb %>% filter(if_any(starts_with("type_of_special_diet_followed"), ~ . %in% c("Vegetarian", "Vegan")))
#9454 rows

x <- ukb %>% select((starts_with(c("invitation_to_complete_online_24hour_recall_dietary_questionnaire_acceptance", "type_of_special_diet_followed"))))                   
#apply(x, 2, table)

#How to check for initial?
for (i in 1:4) {
  rec <- paste("invitation_to_complete_online_24hour_recall_dietary_questionnaire_acceptance_f110001_", i, "_0", sep = "")
  varname <- paste("total", i, sep="_")
  x[[varname]] <- NA
  
  #new column for completed = "nonveg", else = NA
  x[[varname]][x[, rec] == "Completed"] <- "Nonveg"
  
  for (j in 0:5) {
    inst <- paste("type_of_special_diet_followed_f20086_", i, "_", j, sep = "")
    x[[total]][x[, inst] == "Vegetarian" | x[, inst] == "Vegan"] <- "Veg"
  }
}

#add up to find average of veg responses

#pheno <- pheno[!(pheno$IID %in% withdrawn$V1), ]
