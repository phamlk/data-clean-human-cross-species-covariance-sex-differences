read_amygdala <- function(input_vol) { 
  
  final <- read_csv(input_vol) %>% 
           select(-any_of(c("Left-Whole_amygdala", "Right-Whole_amygdala"))) %>%
           rename(Subject = SUBJECT_ID) %>% 
           mutate(Subject = as.numeric(str_replace(Subject, "sub-","")))
  
  return(final)
  }