find_maxCook <- function(df_list, subject_id, x) {
  
  # Extract the first row of each data frame
  first_rows <- sapply(df_list, function(df) df[-1][x, ])
  
  # Find the maximum value among the first row elements
  max_value <- max(unlist(first_rows), na.rm = TRUE)
  
  output <- data.frame(Subject = subject_id,
                       max_cooksd = max_value)
  
  return(output)
  
}