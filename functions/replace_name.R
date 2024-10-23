replace_name <- function(data, name_to_find, long_name) {
  
  dat <- data %>% 
    rename_with(~as.character(long_name), 
                any_of(contains(as.character(name_to_find)))) %>%
    select(!!sym(as.character(long_name)))
  
  return(dat)
}