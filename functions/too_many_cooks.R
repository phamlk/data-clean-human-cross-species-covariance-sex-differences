too_many_cooks <- function(first_vol_col_number, last_vol_col_number, data,
                           subject_colname,to_exclude) { 
  
          output <- lapply(first_vol_col_number:last_vol_col_number, function(x)
                    subject_cooksd(data, subject_colname, 
                                   to_exclude, 
                    colnames(data)[x]))
          
          return(output)
}