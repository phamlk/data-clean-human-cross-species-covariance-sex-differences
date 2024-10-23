all_maxCook <- function(whole_data, data_list, subject_colname) {
  
  subject <- whole_data[[subject_colname]]
  
  output <- bind_rows(lapply(1:length(subject), function(x)
            find_maxCook(data_list, subject[x], x)))
  
  return(output)
}