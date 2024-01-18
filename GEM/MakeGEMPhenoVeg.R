#Subset necessary columns, change to numeric 
library(tidyverse)
library(rio)

veg <- as_tibble(read.table("/scratch/ahc87874/Fall2022/pheno/VegPheno.txt", sep = "\t", header = TRUE, stringsAsFactors = FALSE))
phenoQCgenoQC <- as_tibble(read.table("/scratch/ahc87874/Fall2022/geno/chr22.sample", header = TRUE, stringsAsFactors = FALSE))

phase1 <- as_tibble(import("/scratch/ahc87874/Phase/pheno/phase1IIDs.csv")) # 117,920 rows
phase2 <- as_tibble(import("/scratch/ahc87874/Phase/pheno/phase2IIDs.csv")) # 156,205 rows
phasecomb <- as_tibble(import("/scratch/ahc87874/Phase/pheno/phasecombIIDs.csv")) # 274,121 rows

#Remove withdrawn participants from dataset
withdrawn <- read.csv("/scratch/ahc87874/Fall2022/pheno/withdrawn.csv", header = FALSE)
veg <- veg[!(veg$IID %in% withdrawn$V1), ] # 210,945 rows

GEMpheno <- veg %>% select(FID, IID, 
                               sex_f31_0_0, age_when_attended_assessment_centre_f21003_0_0, agesex,
                               contains("genetic_principal_components_f22009_0_"), 
                               SSRV, 
                               w3FA, w3FA_TFAP, w6FA, w6FA_TFAP, w6_w3_ratio, DHA, DHA_TFAP,
                               LA, LA_TFAP, PUFA, PUFA_TFAP, MUFA, MUFA_TFAP, PUFA_MUFA_ratio)

#Rename columns and change order
covars <- c("Sex", "Age", "AgeSex", "PC1", "PC2", "PC3", "PC4", "PC5", "PC6", "PC7", "PC8", "PC9", "PC10", "Vegetarian")
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

GEMpheno2 %>% filter(GEMpheno2$IID %in% phase1$IID) # 49,821 rows
GEMpheno2 %>% filter(GEMpheno2$IID %in% phase2$IID) # 63,882 rows
GEMpheno2 %>% filter(GEMpheno2$IID %in% phasecomb$IID) # 113,702 rows

for (i in 1:ncol(GEMpheno2)) {
    print(names(GEMpheno2)[i])
    print(sum(is.na(GEMpheno2[, i])))
}

# "FID" 0
# "IID" 0
# "Sex" 0
# "Age" 0
# "AgeSex" 0
# "PC1" 4071
# "PC2" 4071
# "PC3" 4071
# "PC4" 4071
# "PC5" 4071
# "PC6" 4071
# "PC7" 4071
# "PC8" 4071
# "PC9" 4071
# "PC10" 4071
# "Vegetarian" 4971
# "w3FA" 97243
# "w3FA_TFAP" 97243
# "w6FA" 97243
# "w6FA_TFAP" 97243
# "w6_w3_ratio" 97256
# "DHA" 97243
# "DHA_TFAP" 97243
# "LA" 97243
# "LA_TFAP" 97243
# "PUFA" 97243
# "PUFA_TFAP" 97243
# "MUFA" 97243
# "MUFA_TFAP" 97243
# "PUFA_MUFA_ratio" 97244

CompCase <- FALSE

if (CompCase) { 
  # Remove if missing all phenotypes
  GEMpheno3 <- GEMpheno2 %>% filter(!is.na(w3FA), !is.na(w3FA_TFAP), !is.na(w6FA), !is.na(w6FA_TFAP), 
                                    !is.na(w6_w3_ratio), !is.na(DHA), !is.na(DHA_TFAP), !is.na(LA), 
                                    !is.na(LA_TFAP), !is.na(PUFA), !is.na(PUFA_TFAP), !is.na(MUFA), 
                                    !is.na(MUFA_TFAP), !is.na(PUFA_MUFA_ratio))

  GEMpheno3 %>% filter(GEMpheno3$IID %in% phase1$IID) # 49,820 rows
  GEMpheno3 %>% filter(GEMpheno3$IID %in% phase2$IID) # 63,868 rows
  GEMpheno3 %>% filter(GEMpheno3$IID %in% phasecomb$IID) # 113,688 rows

  # Remove if missing exposure data
  GEMpheno4 <- GEMpheno3 %>% filter(!is.na(Vegetarian))

  GEMpheno4 %>% filter(GEMpheno4$IID %in% phase1$IID) # 48,682 rows
  GEMpheno4 %>% filter(GEMpheno4$IID %in% phase2$IID) # 62,417 rows
  GEMpheno4 %>% filter(GEMpheno4$IID %in% phasecomb$IID) # 111,099 rows

  # Remove if missing covariate data
  GEMpheno5 <- GEMpheno4 %>% filter(!is.na(Sex), !is.na(Age), !is.na(AgeSex), !is.na(PC1))

  GEMpheno5 %>% filter(GEMpheno5$IID %in% phase1$IID) # 48,451 rows
  GEMpheno5 %>% filter(GEMpheno5$IID %in% phase2$IID) # 61,984 rows
  GEMpheno5 %>% filter(GEMpheno5$IID %in% phasecomb$IID) # 110,435 rows
  
  # Remove if missing genetic data or doesnt pass geno/pheno QC
  phenoQCgenoQC <- phenoQCgenoQC %>% mutate(IID = ID_1, hasGenoData = TRUE) %>% select(IID, hasGenoData)
  GEMpheno6 <- subset(GEMpheno5, (IID %in% phenoQCgenoQC$IID))

  GEMpheno6 %>% filter(GEMpheno6$IID %in% phase1$IID) # 36,391 rows
  GEMpheno6 %>% filter(GEMpheno6$IID %in% phase2$IID) # 46,973 rows
  GEMpheno6 %>% filter(GEMpheno6$IID %in% phasecomb$IID) # 83,364 rows
} else {
  GEMpheno6 <- GEMpheno2
}

# Subset by Phase IID
PUFAsINT1 <- subset(GEMpheno6, (IID %in% phase1$IID)) # 36,391
PUFAsINT2 <- subset(GEMpheno6, (IID %in% phase2$IID)) # 46,973
PUFAsINTcomb <- subset(GEMpheno6, (IID %in% phasecomb$IID)) # 83,364
  
# INT
for (i in 17:30) {
  print(names(PUFAsINTcomb)[i])
  PUFAsINTcomb[, i] <- qnorm((rank(PUFAsINTcomb[, i],na.last="keep")-0.5)/sum(!is.na(PUFAsINTcomb[, i])))
  PUFAsINT1[, i] <- qnorm((rank(PUFAsINT1[, i],na.last="keep")-0.5)/sum(!is.na(PUFAsINT1[, i])))
  PUFAsINT2[, i] <- qnorm((rank(PUFAsINT2[, i],na.last="keep")-0.5)/sum(!is.na(PUFAsINT2[, i])))
}

#table(PUFAsINT1$Vegetarian)
#    0     1
#35823   568

#table(PUFAsINT2$Vegetarian)
#    0     1
#46252   721

#table(PUFAsINTcomb$Vegetarian)
#    0     1
#82075  1289

# GEM Output
# Phase 1: 36391
# Phase 2: 46984
# Comb: 83375

if (CompCase) {
  suffix <- "comb"
  write.table(PUFAsINTcomb, file = paste("/scratch/ahc87874/Fall2022/pheno/GEMphenoVeg", suffix, ".txt", sep = ""), sep = "\t", row.names = FALSE, quote = FALSE)
  write.csv(PUFAsINTcomb, file = paste("/scratch/ahc87874/Fall2022/pheno/GEMphenoVeg", suffix, ".csv", sep = ""), row.names = FALSE, quote = FALSE)
    
  suffix <- "phase1"
  write.table(PUFAsINT1, file = paste("/scratch/ahc87874/Fall2022/pheno/GEMphenoVeg", suffix, ".txt", sep = ""), sep = "\t", row.names = FALSE, quote = FALSE)
  write.csv(PUFAsINT1, file = paste("/scratch/ahc87874/Fall2022/pheno/GEMphenoVeg", suffix, ".csv", sep = ""), row.names = FALSE, quote = FALSE)
    
  suffix <- "phase2"
  write.table(PUFAsINT2, file = paste("/scratch/ahc87874/Fall2022/pheno/GEMphenoVeg", suffix, ".txt", sep = ""), sep = "\t", row.names = FALSE, quote = FALSE)
  write.csv(PUFAsINT2, file = paste("/scratch/ahc87874/Fall2022/pheno/GEMphenoVeg", suffix, ".csv", sep = ""), row.names = FALSE, quote = FALSE)
} else {
  suffix <- "combTEST"
  write.table(PUFAsINTcomb, file = paste("/scratch/ahc87874/Fall2022/pheno/GEMphenoVeg", suffix, ".txt", sep = ""), sep = "\t", row.names = FALSE, quote = FALSE)
  write.csv(PUFAsINTcomb, file = paste("/scratch/ahc87874/Fall2022/pheno/GEMphenoVeg", suffix, ".csv", sep = ""), row.names = FALSE, quote = FALSE)
    
  suffix <- "phase1TEST"
  write.table(PUFAsINT1, file = paste("/scratch/ahc87874/Fall2022/pheno/GEMphenoVeg", suffix, ".txt", sep = ""), sep = "\t", row.names = FALSE, quote = FALSE)
  write.csv(PUFAsINT1, file = paste("/scratch/ahc87874/Fall2022/pheno/GEMphenoVeg", suffix, ".csv", sep = ""), row.names = FALSE, quote = FALSE)
    
  suffix <- "phase2TEST"
  write.table(PUFAsINT2, file = paste("/scratch/ahc87874/Fall2022/pheno/GEMphenoVeg", suffix, ".txt", sep = ""), sep = "\t", row.names = FALSE, quote = FALSE)
  write.csv(PUFAsINT2, file = paste("/scratch/ahc87874/Fall2022/pheno/GEMphenoVeg", suffix, ".csv", sep = ""), row.names = FALSE, quote = FALSE)
}
