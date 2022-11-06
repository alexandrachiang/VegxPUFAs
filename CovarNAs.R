onlyCSRV <- ukbSSRV[!is.na(ukbSSRV$CSRV), ] #210967 rows
onlySSRV <- ukbSSRV[!is.na(ukbSSRV$SSRV), ] #127756 rows

#Model 1: sex, age, age2, genotyping array, and assessment center, Townsend deprivation index, the first ten genetic principal components;  
#Model 2: Model 1 + body mass index (BMI), lipid medication usage

covarsCSRV <- onlyCSRV %>% select(sex_f31_0_0, age_when_attended_assessment_centre_f21003_0_0, 
                                  age_when_attended_assessment_centre_squared, genotype_measurement_batch_f22000_0_0,
                                  uk_biobank_assessment_centre_f54_0_0, townsend_deprivation_index_at_recruitment_f189_0_0,
                                  paste("genetic_principal_components_f22009_0_", 1:10, sep = ""), body_mass_index_f21001_0_0,
                                  medication_combined_f6153_f6177_0_0, CSRV)

covarsSSRV <- onlySSRV %>% select(sex_f31_0_0, age_when_attended_assessment_centre_f21003_0_0, 
                                  age_when_attended_assessment_centre_squared, genotype_measurement_batch_f22000_0_0,
                                  uk_biobank_assessment_centre_f54_0_0, townsend_deprivation_index_at_recruitment_f189_0_0,
                                  paste("genetic_principal_components_f22009_0_", 1:10, sep = ""), body_mass_index_f21001_0_0,
                                  medication_combined_f6153_f6177_0_0, SSRV)

colSums(is.na(covarsCSRV))
#sex_f31_0_0
#0
#age_when_attended_assessment_centre_f21003_0_0
#0
#age_when_attended_assessment_centre_squared
#0
#genotype_measurement_batch_f22000_0_0
#4072
#uk_biobank_assessment_centre_f54_0_0
#0
#townsend_deprivation_index_at_recruitment_f189_0_0
#265
#genetic_principal_components_f22009_0_1
#4072
#genetic_principal_components_f22009_0_2
#4072
#genetic_principal_components_f22009_0_3
#4072
#genetic_principal_components_f22009_0_4
#4072
#genetic_principal_components_f22009_0_5
#4072
#genetic_principal_components_f22009_0_6
#4072
#genetic_principal_components_f22009_0_7
#4072
#genetic_principal_components_f22009_0_8
#4072
#genetic_principal_components_f22009_0_9
#4072
#genetic_principal_components_f22009_0_10
#4072
#body_mass_index_f21001_0_0
#595
#medication_combined_f6153_f6177_0_0
#94
#CSRV
#0

colSums(is.na(covarsSSRV))
#sex_f31_0_0
#0
#age_when_attended_assessment_centre_f21003_0_0
#0
#age_when_attended_assessment_centre_squared
#0
#genotype_measurement_batch_f22000_0_0
#2311
#uk_biobank_assessment_centre_f54_0_0
#0
#townsend_deprivation_index_at_recruitment_f189_0_0
#146
#genetic_principal_components_f22009_0_1
#311
#genetic_principal_components_f22009_0_2
#2311
#genetic_principal_components_f22009_0_3
#2311
#genetic_principal_components_f22009_0_4
#2311
#genetic_principal_components_f22009_0_5
#2311
#genetic_principal_components_f22009_0_6
#2311
#genetic_principal_components_f22009_0_7
#2311
#genetic_principal_components_f22009_0_8
#2311
#genetic_principal_components_f22009_0_9
#2311
#genetic_principal_components_f22009_0_10
#2311
#body_mass_index_f21001_0_0
#317
#medication_combined_f6153_f6177_0_0
#5
#SSRV
#0

onlyCSRVNonVeg <- covarsCSRV %>% filter(CSRV == "NonVeg") %>% select(-CSRV) #202724 rows
onlyCSRVVeg <- covarsCSRV %>% filter(CSRV == "Veg") %>% select(-CSRV) #8243 rows
onlySSRVNonVeg <- covarsSSRV %>% filter(SSRV == "NonVeg") %>% select(-SSRV) #124526 rows
onlySSRVVeg <- covarsSSRV %>% filter(SSRV == "Veg") %>% select(-SSRV) #3230 rows

sum(complete.cases(onlyCSRVNonVeg)) #198001, removed 4723 CSRV NonVeg
sum(complete.cases(onlyCSRVVeg)) #8039, removed 204 CSRV Veg
sum(complete.cases(onlySSRVNonVeg)) #121848, removed 2678 SSRV NonVeg
sum(complete.cases(onlySSRVVeg)) #3168, removed 62 SSRV Veg

#Removes 4927 total
#206040 left
