print_demographics <- function(..., final_data) { 
  
  demo <- list(...) %>% reduce(inner_join, by = "Subject")
  
  demo_main <- demo %>% filter(Subject %in% final_data$Subject)
  
  demo_1 <- demo_main %>%
            group_by(Gender) %>% reframe(count = n(), 
                        mean_age = mean(Age_in_Yrs, na.rm = TRUE),
                        sd_age = sd(Age_in_Yrs, na.rm = TRUE),
                        min_age = min(Age_in_Yrs, na.rm = TRUE),
                        max_age = max(Age_in_Yrs, na.rm = TRUE),
                        
                        mean_education = mean(SSAGA_Educ, na.rm = TRUE),
                        sd_education = sd(SSAGA_Educ, na.rm = TRUE),
                        min_education = min(SSAGA_Educ, na.rm = TRUE),
                        max_education = max(SSAGA_Educ, na.rm = TRUE),
                        
                        mean_euler = mean(euler, na.rm = TRUE),
                        sd_euler = sd(euler, na.rm = TRUE),
                        min_euler = min(euler, na.rm = TRUE),
                        max_euler = max(euler, na.rm = TRUE))
  
  stats_age <- summary(lm(Age_in_Yrs~Gender, na.action = na.omit, data = demo_main))
  stats_education <- summary(lm(SSAGA_Educ~Gender, na.action = na.omit, data = demo_main))
  stats_euler <- summary(lm(euler~Gender, na.action = na.omit, data = demo_main))
    
  demo_2 <- demo_main %>% 
            group_by(Gender, ZygositySR) %>% summarise(count = n()) %>%
            filter(is.na(ZygositySR) == FALSE) %>%
            pivot_wider(id_cols = Gender, names_from = ZygositySR, values_from = count) %>%
            column_to_rownames("Gender")
            
 stats_zg <- chisq.test(demo_2)
 
 return(stats_zg)
    demo_na <- demo_main %>%
             mutate(na_age = is.na(Age_in_Yrs), 
                    na_education = is.na(SSAGA_Educ),
                    na_zg = is.na(ZygositySR)) %>% 
                    select(Gender, na_age, na_education, na_zg) %>%
             filter(na_age == TRUE | na_education == TRUE | na_zg == TRUE)
                    
  return(list(demo_1, demo_2, demo_na, stats_age, stats_education, stats_euler,
              stats_zg))               
                        
  
  }