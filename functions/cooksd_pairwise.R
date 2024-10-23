cooksd_pairwise <- function(data_input, fixed_col, moving_col) {
  
  moving_col <- paste("`", moving_col, "`", sep = "")
  fixed_col <- paste("`", fixed_col, "`", sep = "")
  
  if(moving_col != fixed_col) { 
    
  mod <- lm(reformulate(moving_col, fixed_col), data = data_input)
  
  cooksd <- cooks.distance(mod)
  }
  
  else(
  
  cooksd <- rep(NA, length(id))
  
  )
  
  output <- data.frame(cooksd = cooksd) %>% 
            rename(!!moving_col:= cooksd)
  
  return(output)
}
