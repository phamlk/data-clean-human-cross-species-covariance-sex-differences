combine_data <- function(...){ 
           list(...) %>% 
                reduce(inner_join, by ='Subject') %>%
           select(-any_of(c("lh_euler", "rh_euler"))) %>%
           filter(euler > -217 & QC_include == 1) %>% 
           distinct(Mother_ID, .keep_all = TRUE) %>% ungroup() %>% 
           distinct(Father_ID, .keep_all = TRUE) %>% 
           select(-any_of(c("ZygositySR","Mother_ID","Father_ID","flag"))) %>%
           relocate(TBV, .before = Age_in_Yrs) 
                      
}