SumStats <- function(df) {
  means <- as.data.frame(colMeans(select_if(df, is.numeric), na.rm = TRUE))
  NAs <- as.data.frame(colSums(is.na(df)))
  
  print(nrow(means) == nrow(NAs))
  
  sumstats <- data.frame(pheno = row.names(means), means, NAs)
  names(sumstats) <- c("phenos", "means", "NAs")
  rownames(sumstats) <- NULL
  
  print(sumstats)
}
