setwd("/scratch/ahc87874/Fall2022/alleleplots")

x <- alleles3 %>% 
  filter(!is.na(Strict)) %>% 
  group_by(rs72880701_G_T, Strict) %>% 
  summarise(
    count = n(),
    min = min(w6_w3_ratio_NMR), 
    max = max(w6_w3_ratio_NMR), 
    mean = mean(w6_w3_ratio_NMR), 
    q1 = quantile(w6_w3_ratio_NMR)[[2]], 
    median = median(w6_w3_ratio_NMR), 
    q3 = quantile(w6_w3_ratio_NMR)[[4]]) %>%
  as.data.frame() 

write.csv(x, file = "rs72880701_alleles.csv", row.names = FALSE, quote = FALSE)

x <- alleles3 %>% 
  filter(!is.na(Strict)) %>% 
  group_by(rs1817457_G_A, Strict) %>% 
  summarise(
    count = n(),
    min = min(LA_NMR_TFAP), 
    max = max(LA_NMR_TFAP), 
    mean = mean(LA_NMR_TFAP), 
    q1 = quantile(LA_NMR_TFAP)[[2]], 
    median = median(LA_NMR_TFAP), 
    q3 = quantile(LA_NMR_TFAP)[[4]]) %>%
  as.data.frame()

write.csv(x, file = "rs1817457_alleles.csv", row.names = FALSE, quote = FALSE)

x <- alleles3 %>% 
  filter(!is.na(Strict)) %>% 
  group_by(rs149996902_CT_C, Strict) %>% 
  summarise(
    count = n(),
    min = min(LA_NMR_TFAP), 
    max = max(LA_NMR_TFAP), 
    mean = mean(LA_NMR_TFAP), 
    q1 = quantile(LA_NMR_TFAP)[[2]], 
    median = median(LA_NMR_TFAP), 
    q3 = quantile(LA_NMR_TFAP)[[4]]) %>%
  as.data.frame()

write.csv(x, file = "rs149996902_alleles.csv", row.names = FALSE, quote = FALSE)

x <- alleles3 %>% 
  filter(!is.na(Strict)) %>% 
  group_by(rs34249205_A_G, Strict) %>% 
  summarise(
    count = n(),
    min = min(w3FA_NMR_TFAP), 
    max = max(w3FA_NMR_TFAP), 
    mean = mean(w3FA_NMR_TFAP), 
    q1 = quantile(w3FA_NMR_TFAP)[[2]], 
    median = median(w3FA_NMR_TFAP), 
    q3 = quantile(w3FA_NMR_TFAP)[[4]]) %>%
  as.data.frame()

write.csv(x, file = "rs34249205_alleles.csv", row.names = FALSE, quote = FALSE)
