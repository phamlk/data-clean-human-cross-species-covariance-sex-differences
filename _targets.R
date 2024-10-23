# setting target libraries
library(targets)

# loading custom functions for pipeline 
sapply(list.files(pattern="[.]R$", path="functions/", full.names=TRUE), source)

# setting packages required for pipeline
# configuring pipeline for more efficiency
options(tidyverse.quiet = TRUE)
tar_option_set(packages = c("tidyverse","reshape2","tidymodels",
                            "lme4"))

# data cleaning pipeline 
list(
  
  #---feed in data location----
  # glasser volume segmentations and long names 
  tar_target(glasser_dir, "data/cortical/PARC_HCP_volume.csv", format = "file"),
  tar_target(glasser_defs_dir, "data/cortical/HCP-MMP1_UniqueRegionList.csv",
             format = "file"),
  
  # freesurfer segmentations 
  tar_target(free_dir, "data/subcortical/aseg.vol.table.csv", format = "file"),
  
  # amygdala segmentations
  tar_target(l_amygdala_dir, "data/subcortical/amygdala-nuclei.lh.v12.T1.csv", 
             format = "file"),
  tar_target(r_amygdala_dir, "data/subcortical/amygdala-nuclei.rh.v12.T1.csv"), 
  
  # hypothalamus volume segmentations and long names 
  tar_target(hypothalamus_dir, "data/subcortical/Hypothalamus_volumes_1.csv", 
             format = "file"),
  tar_target(hypothalamus_defs_dir, "data/subcortical/Volumes_names-labels.csv"),
  
  # age information. also contains zygosity info 
  tar_target(age_zygo_dir, "data/cortical/HCP_demo.csv", format = "file"),
  
  
  # sex QC info
  tar_target(sex_dir, "data/subcortical/HCP_demographics_QC.csv", format = "file"),
  
  # loading subjects visually filtered by Elisa 
  tar_target(elisa_dir, "data/df_HCP_volumes_clean.RDS"),
  
  # associated euler number info 
  tar_target(euler_dir, "data/cortical/euler_number.csv", format = "file"),
  
  #---reading in non-vol information----
  
  # grab age, sex, and euler information
  tar_target(age_zygo, get_age_zygo(age_zygo_dir)),
  tar_target(elisa_vols, readRDS(elisa_dir)),
  tar_target(sex, get_sex(sex_dir, visual_qc = elisa_vols)),
  tar_target(euler, get_euler(euler_dir)),
  # reading in HCP demo but this time keep all columns to generate demographics
  # table for paper
  tar_target(hcp_demo, read_csv(age_zygo_dir)), 
  
  # ----make cortical data-----
  # read in glasser segmentation
  # glasser atlas comes with hippocampus segmentaitons, but they're very bad
  # so read_glasser function makes sure to remove those regions
  tar_target(glasser, read_glasser(glasser_dir, glasser_defs_dir)),
  
  #-----make subcortical data-----
  # reading in subcortical structures data 
  # this freesurfer segmentaiton has hippocamal regions included 
  # on ggseg brainmaps, they'll be represented on both the cortical maps 
  # and the subcortical aseg maps 
  tar_target(free, read_freesurf(free_dir)),

  # reading in hypothalamus subregion data
  tar_target(hypothalamus, read_hypothalamus(hypothalamus_dir, hypothalamus_defs_dir)),
  
  # reading in amygdala subregion data 
  tar_target(l_amygdala, read_amygdala(l_amygdala_dir)),
  tar_target(r_amygdala, read_amygdala(r_amygdala_dir)),
  
  # combine all data together 
  tar_target(whole_brain, combine_data(glasser, free, hypothalamus, l_amygdala, 
                               r_amygdala, age_zygo, sex, euler)),
  
  # combine together to make subcortical data
  tar_target(subcortical, combine_compartment(free,hypothalamus,
                                       l_amygdala, r_amygdala,
                                       age_zygo, sex, euler,
                                       whole_data = whole_brain)),
  
  # combine together to make cortical data
  tar_target(cortical, combine_compartment(glasser, age_zygo, sex, euler,
                                           whole_data = whole_brain)),
  
  # #----flagging-outliers------

  # final data sets: subcortical is missing subject 191235 and subject 138130
  # due to missing hypothalamus data
  # cortical is missing subject 150524

  tar_target(all_subj_cooksd,
             too_many_cooks(2,438, whole_brain, "Subject",
                          c("Subject", "TBV", "Age_in_Yrs", "Gender", "euler",
                            "QC_include"))),

  tar_target(subj_max_cooksd, all_maxCook(whole_brain, all_subj_cooksd,
                                          "Subject")),

  tar_target(outlier_flags, flag_outliers(subj_max_cooksd)),

  tar_target(outliers, subset(outlier_flags, outlier == TRUE)$Subject),
  
  tar_target(final, whole_brain %>% filter(!(Subject %in% outliers)) %>%
                    select(-QC_include)),

  # assign final subjects random number from 1 through total number of subjects 
  tar_target(final_subject_id_mask, final %>% select(Subject) %>%
             mutate(Subject_mask = sample(1:n()))), 
  
  # final cortical and subcortical data are the csvs that are returned 
  tar_target(final_cortical, cortical %>% filter(Subject %in% final$Subject) %>%
             select(-any_of(c("QC_include", "Mother_ID", "Father_ID",
                              "ZygositySR"))) %>%
             left_join(final_subject_id_mask) %>% mutate(Subject = Subject_mask) %>%
             select(-Subject_mask)),

  tar_target(final_subcortical, subcortical %>% filter(Subject %in% final$Subject) %>%
               select(-any_of(c("QC_include", "Mother_ID", "Father_ID",
                               "ZygositySR"))) %>% 
               left_join(final_subject_id_mask) %>% mutate(Subject = Subject_mask) %>%
               select(-Subject_mask)),
  # printing demographics 
  tar_target(demo_table, print_demographics(hcp_demo, euler, sex, final_data = final))
)