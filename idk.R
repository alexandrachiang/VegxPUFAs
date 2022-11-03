onlyCSRV <- ukbSSRV[!is.na(ukbSSRV$CSRV), ] #210967 rows
onlySSRV <- ukbSSRV[!is.na(ukbSSRV$SSRV), ] #127756 rows

sex, age, age2, genotyping array, and assessment center, Townsend deprivation index, the first ten genetic principal components;  

Model 2: Model 1 + body mass index (BMI), lipid medication usage

covarsCSRV <- onlyCSRV %>% select(sex_f31_0_0, age_when_attended_assessment_centre_f21003_0_0, age_when_attended_assessment_centre_squared
genotype_measurement_batch_f22000_0_0
uk_biobank_assessment_centre_f54_0_0
townsend_deprivation_index_at_recruitment_f189_0_0
select(paste("genetic_principal_components_f22009_0_", 1:10, sep = ""))
body_mass_index_f21001_0_0
medication_for_cholesterol_blood_pressure_or_diabetes_f6177_0_0 #Only need array index 0
medication_for_cholesterol_blood_pressure_diabetes_or_take_exogenous_hormones_f6153_0_0 #Only need array index 0

sum(is.na(onlyCSRV$sex_f31_0_0)) #0
sum(is.na(onlySSRV$sex_f31_0_0)) #0

sum(is.na(onlyCSRV$age_when_attended_assessment_centre_f21003_0_0)) #0
sum(is.na(onlySSRV$age_when_attended_assessment_centre_f21003_0_0)) #0

sum(is.na(onlyCSRV$age_when_attended_assessment_centre_squared)) #0
sum(is.na(onlySSRV$age_when_attended_assessment_centre_squared)) #0

sum(is.na(onlyCSRV$genotype_measurement_batch_f22000_0_0)) #4072
sum(is.na(onlySSRV$genotype_measurement_batch_f22000_0_0)) #2311

sum(is.na(onlyCSRV$uk_biobank_assessment_centre_f54_0_0)) #0
sum(is.na(onlySSRV$uk_biobank_assessment_centre_f54_0_0)) #0

sum(is.na(onlyCSRV$townsend_deprivation_index_at_recruitment_f189_0_0)) #265
sum(is.na(onlySSRV$townsend_deprivation_index_at_recruitment_f189_0_0)) #146

pca

sum(is.na(onlyCSRV$body_mass_index_f21001_0_0)) #595
sum(is.na(onlySSRV$body_mass_index_f21001_0_0)) #317

sum(is.na(onlyCSRV$medication_for_cholesterol_blood_pressure_or_diabetes_f6177_0_0)) #116253
sum(is.na(onlySSRV$medication_for_cholesterol_blood_pressure_or_diabetes_f6177_0_0)) #68157

sum(is.na(onlyCSRV$medication_for_cholesterol_blood_pressure_diabetes_or_take_exogenous_hormones_f6153_0_0)) #94808
sum(is.na(onlySSRV$medication_for_cholesterol_blood_pressure_diabetes_or_take_exogenous_hormones_f6153_0_0)) #59604
