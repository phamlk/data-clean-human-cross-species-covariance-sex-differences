subject_cooksd <- function(data, subject_colname, to_exclude, fixed_column) {
  
  id <- data %>% select(any_of(subject_colname))
  
  data_excluded <- data %>% select(-(all_of(to_exclude)))

  all_cooks <- bind_cols(lapply(1:ncol(data_excluded), function(x)
                         cooksd_pairwise(data_input = data_excluded,
                         fixed_col = fixed_column,
                         moving_col = colnames(data_excluded)[x])))


  output <- bind_cols(id, all_cooks)
  
  return(output)
}