combine_compartment <- function(..., whole_data) { 
  
  list(...) %>% 
    reduce(inner_join, by ='Subject') %>%
    select(-any_of(c("lh_euler", "rh_euler"))) %>%
    filter(Subject %in% whole_data$Subject) 
  
  }