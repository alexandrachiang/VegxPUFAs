alleles3 %>% filter(!is.na(Strict)) %>% group_by(rs34249205_A_G, Strict) %>% summarise(
count = n(),
min = min(w3FA_NMR_TFAP), 
max = max(w3FA_NMR_TFAP), 
mean = mean(w3FA_NMR_TFAP), 
quantile1 = quantile(w3FA_NMR_TFAP)[[2]], 
median = median(w3FA_NMR_TFAP), 
quantile3 = quantile(w3FA_NMR_TFAP)[[4]]) %>%
as.data.frame()
