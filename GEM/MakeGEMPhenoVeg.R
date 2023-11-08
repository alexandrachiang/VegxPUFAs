#Subset necessary columns, change to numeric 

library(tidyverse)

veg <- as_tibble(read.table("/scratch/ahc87874/Fall2022/pheno/VegPheno.txt", sep = "\t", header = TRUE, stringsAsFactors = FALSE))
phenoQCgenoQC <- as_tibble(read.table("/scratch/ahc87874/Fall2022/geno/chr22.sample", header = TRUE, stringsAsFactors = FALSE))

phase1 <- as_tibble(import("/scratch/ahc87874/Phase/pheno/phase1IIDs.csv"))
phase2 <- as_tibble(import("/scratch/ahc87874/Phase/pheno/phase2IIDs.csv"))
phasecomb <- as_tibble(import("/scratch/ahc87874/Phase/pheno/phasecombIIDs.csv"))

#Remove withdrawn participants from dataset
withdrawn <- read.csv("/scratch/ahc87874/Fall2022/pheno/withdrawn.csv", header = FALSE)
veg <- veg[!(veg$IID %in% withdrawn$V1), ]

GEMpheno <- fishoil %>% select(FID, IID, 
                               sex_f31_0_0, age_when_attended_assessment_centre_f21003_0_0, agesex,                                 ,
                               contains("genetic_principal_components_f22009_0_"), 
                               SSRV, 
                               w3FA, w3FA_TFAP, w6FA, w6FA_TFAP, w6_w3_ratio, DHA, DHA_TFAP,
                               LA, LA_TFAP, PUFA, PUFA_TFAP, MUFA, MUFA_TFAP, PUFA_MUFA_ratio)

#Rename columns and change order
covars <- c("Sex", "Age", "Townsend", "PC1", "PC2", "PC3", "PC4", "PC5", "PC6", "PC7", "PC8", "PC9", "PC10", "Vegetarian")
names(GEMpheno)[3:(2 + length(covars))] <- covars
  
#Change to numerical columns
GEMpheno2 <- GEMpheno
GEMpheno2$Sex <- as.character(GEMpheno2$Sex)
GEMpheno2$Sex <- replace(GEMpheno2$Sex, GEMpheno2$Sex == "Female", 0)
GEMpheno2$Sex <- replace(GEMpheno2$Sex, GEMpheno2$Sex == "Male", 1)
GEMpheno2$Sex <- as.numeric(GEMpheno2$Sex)
GEMpheno2$Vegetarian <- replace(GEMpheno2$Vegetarian, GEMpheno2$Vegetarian == "NonVeg", 0)
GEMpheno2$Vegetarian <- replace(GEMpheno2$Vegetarian, GEMpheno2$Vegetarian == "Veg", 1)
GEMpheno2$Vegetarian <- as.numeric(GEMpheno2$Vegetarian)

# Remove if missing genetic data or doesnt pass geno/pheno QC
phenoQCgenoQC <- phenoQCgenoQC %>% mutate(IID = ID_1, hasGenoData = TRUE) %>% select(IID, hasGenoData)
GEMpheno3 <- subset(GEMpheno2, (IID %in% phenoQCgenoQC$IID))

# Remove if missing covariate data
GEMpheno3 <- GEMpheno3 %>% filter(!is.na(Sex), !is.na(Age), !is.na(AgeSex), !is.na(PC1))
  
# Remove if missing phenotype data
GEMpheno3 <- GEMpheno3 %>% filter(!is.na(Vegetarian))

# Remove if missing all phenotypes
for (i in 1:ncol(GEMpheno3)) {
  print(names(GEMpheno3)[i])
  print(sum(is.na(GEMpheno3[, i])))
}
  
GEMpheno4 <- GEMpheno3 %>% select(w3FA, w3FA_TFAP, w6FA, w6FA_TFAP, w6_w3_ratio, DHA, DHA_TFAP, 
                                  LA, LA_TFAP, PUFA, PUFA_TFAP, MUFA, MUFA_TFAP, PUFA_MUFA_ratio)
GEMpheno5 <- GEMpheno3[rowSums(!is.na(GEMpheno4)) > 0, ]

# Subset by Phase IID
PUFAsINTcomb <- subset(GEMpheno5, (IID %in% phasecomb$IID))
PUFAsINT1 <- subset(GEMpheno5, (IID %in% phase1$IID))
PUFAsINT2 <- subset(GEMpheno5, (IID %in% phase2$IID))
  
# INT
for (i in 17:30) {
  print(names(PUFAsINTcomb)[i])
  PUFAsINTcomb[, i] <- qnorm((rank(PUFAsINTcomb[, i],na.last="keep")-0.5)/sum(!is.na(PUFAsINTcomb[, i])))
  PUFAsINT1[, i] <- qnorm((rank(PUFAsINT1[, i],na.last="keep")-0.5)/sum(!is.na(PUFAsINT1[, i])))
  PUFAsINT2[, i] <- qnorm((rank(PUFAsINT2[, i],na.last="keep")-0.5)/sum(!is.na(PUFAsINT2[, i])))
}

suffix <- "comb"
write.table(PUFAsINTcomb, file = paste("/scratch/ahc87874/FishOil/pheno/GEMphenoVeg", suffix, ".txt", sep = ""), sep = "\t", row.names = FALSE, quote = FALSE)
write.csv(PUFAsINTcomb, file = paste("/scratch/ahc87874/FishOil/pheno/GEMphenoVeg", suffix, ".csv", sep = ""), row.names = FALSE, quote = FALSE)
  
suffix <- "phase1"
write.table(PUFAsINT1, file = paste("/scratch/ahc87874/FishOil/pheno/GEMphenoVeg", suffix, ".txt", sep = ""), sep = "\t", row.names = FALSE, quote = FALSE)
write.csv(PUFAsINT1, file = paste("/scratch/ahc87874/FishOil/pheno/GEMphenoVeg", suffix, ".csv", sep = ""), row.names = FALSE, quote = FALSE)
  
suffix <- "phase2"
write.table(PUFAsINT2, file = paste("/scratch/ahc87874/FishOil/pheno/GEMphenoVeg", suffix, ".txt", sep = ""), sep = "\t", row.names = FALSE, quote = FALSE)
write.csv(PUFAsINT2, file = paste("/scratch/ahc87874/FishOil/pheno/GEMphenoVeg", suffix, ".csv", sep = ""), row.names = FALSE, quote = FALSE)
