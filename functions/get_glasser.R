read_glasser <- function(volume, long_names) {
  
  vols <- read_csv(volume)
  defs <- read_csv(long_names) %>%
          mutate(to_find = paste0(tolower(LR),"h_",LR,"_", region,"_","ROI_volume")) %>%
          select(regionLongName, to_find) %>%
          mutate(to_find = str_replace(to_find, "-", "_"))
  
  vols_replace <- bind_cols(lapply(1:nrow(defs), function(x) 
                  replace_name(vols, defs[x,2], defs[x,1]))) 
  
  final <- bind_cols(vols$SUBJECT_ID, vols_replace, 
                     vols$BrainSegVolNotVent...183) %>%
           rename(Subject = `...1`, TBV = `...362`) %>%
           mutate(Subject = as.numeric(str_replace(Subject, "sub-",""))) %>%
           select(-c("Hippocampus_L", "Hippocampus_R")) 
  
  return(final)
}