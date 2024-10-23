flag_outliers <- function(data) {
  
  output <- data %>% mutate(z = (max_cooksd - 
                                 mean(max_cooksd))*sd(max_cooksd)) %>% 
               mutate(outlier = ifelse(z >= 3, TRUE, FALSE)) 
  
  return(output)
  
}
