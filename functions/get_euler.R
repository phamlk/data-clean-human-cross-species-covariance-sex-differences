get_euler <- function(euler_orig) {
  
  read_csv(euler_orig) %>% 
  mutate(SUBJECT_ID = as.numeric(gsub("sub-","",SUBJECT_ID))) %>%
  rename(Subject = SUBJECT_ID)
  
}