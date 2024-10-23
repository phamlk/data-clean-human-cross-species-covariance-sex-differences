data_stats <- function(data) {
  
  print(paste0("Number of subjects: ", nrow(data),
              "; Number of males: ", nrow(subset(data, Gender == "M")),
              "; Number of females: ", nrow(subset(data, Gender == "F")),
              "; Mean age: ", mean(data$Age_in_Yrs),
              "; SD age: ", sd(data$Age_in_Yrs)))
  
}