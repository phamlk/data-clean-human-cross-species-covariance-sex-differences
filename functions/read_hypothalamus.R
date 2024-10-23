read_hypothalamus <- function(volume, long_name) { 
  
  vols <- read_csv(volume)
  defs <- read_csv(long_name) %>%
                       mutate(hem = ifelse(Hemisphere == "right", "r", "l")) %>%
                       mutate(longName = paste0(hem,"_", Name))
  
  vols_replace <- bind_cols(lapply(1:nrow(defs), function(x) 
                       replace_name(vols, defs[x,4], 
                       defs[x,6])))
  
  not_select <- c("l_fornix", "r_fornix", 
                  "l_mammillothalamic tract", "r_mammillothalamic tract",
                  "l_anterior commissure", "r_anterior commissure",
                  "l_diagonal band of Broca", "r_diagonal band of Broca")
  
  final <- bind_cols(vols$SUBJECT_ID, vols_replace) %>%
                     rename(Subject = '...1') %>%
                     select(-any_of(not_select)) %>%
                     mutate(Subject = 
                              as.numeric(str_replace(Subject, "sub-", "")))
  
  return(final)
  }