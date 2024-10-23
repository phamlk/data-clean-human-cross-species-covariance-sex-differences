get_sex <- function(sex_orig, visual_qc) {
           read_csv(sex_orig) %>% 
    select(c("Subject", "Sex", "QC_include")) %>% 
    filter(Subject %in% visual_qc$Subject) %>% 
    rename(Gender = Sex)
}