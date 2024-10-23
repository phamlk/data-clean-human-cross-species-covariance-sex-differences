outlier_rm <- function(data, subjects_rm) {
  
  output <- data %>% filter(!Subject %in% subjects_rm)
  
  return(output)
}