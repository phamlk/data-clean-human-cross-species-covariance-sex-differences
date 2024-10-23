read_freesurf <- function(input_vol) {
  
  freesurf_select <- c("SUBJECT_ID", 
                       "Left-Cerebellum-Cortex", "Right-Cerebellum-Cortex",
                       "Left-Thalamus", "Right-Thalamus",
                       "Left-Caudate", "Right-Caudate",
                       "Left-Putamen", "Right-Putamen",
                       "Left-Pallidum", "Right-Pallidum",
                       "Brain-Stem", 
                       "Left-Amygdala", "Right-Amygdala",
                       "Left-Accumbens-area", "Right-Accumbens-area",
                       "Left-VentralDC", "Right-VentralDC",
                       "Left-Hippocampus", "Right-Hippocampus")
  
  freesurf_vols <- read_csv(input_vol) %>%
                   select(any_of(freesurf_select)) %>%
                   rename(Subject = SUBJECT_ID) %>% 
                   mutate(Subject = as.numeric(str_replace(Subject, "sub-",""))) 
  return(freesurf_vols)
}