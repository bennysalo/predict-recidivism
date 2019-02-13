---
title: "Descriptive statistics"
author: "Benny Salo"
date: "2019-02-11"
output: github_document
---



```r
devtools::load_all(".")
library(dplyr)

devtools::wd()
analyzed_data <- readRDS("not_public/analyzed_data.rds")
```

Make offence variables factors. Likewise with variables representing missing information.

```r
analyzed_data <-
analyzed_data %>% 
  mutate_at(.vars = vars(starts_with("o_"), starts_with("newO_"), -newO_violent,
            ps_info_missing, ageFirst_missing),
            factor, levels = c(0,1), labels = c("No", "Yes"))
```

Edit the levels of certain variables for the purpose of the table


```r
levels(analyzed_data$openPrison) <-
  c("Closed prison", "Open prison")

levels(analyzed_data$supervisedParole) <- 
  c("No supervision", "Supervised parole")
```

Create a vector of variable names for descriptive statistics

```r
# We want to describe the variables in variable_table indicated as `num`or`cat`
# in the `Descriptives columns
vars_to_desc <- 
  variable_table$Variable[variable_table$Desciptives %in% c("num", "cat")]

# Remove superfluous variables
superfluous <- c("conditionalReleaseGranted", "conditionalReleaseSuccess")
vars_to_desc <- vars_to_desc[!(vars_to_desc %in% superfluous)]

# Create seperate vector for variables indicating new offences
newO_to_desc       <- stringr::str_subset(vars_to_desc, "^newO_")
predictors_to_desc <- vars_to_desc[!(vars_to_desc %in% newO_to_desc)]
```


```r
# Create a seperate vector for the splitby argument
spl_by <- analyzed_data[["reoff_category"]]

descriptive_stats_preds <- 
  furniture::table1(analyzed_data[predictors_to_desc],
                  splitby = spl_by, type = "full", test = TRUE)
```

```
## Error in eval(substitute(splitby), .data): object 'spl_by' not found
```

```r
descriptive_stats_csv <- 
  furniture::table1(analyzed_data[predictors_to_desc],
                  splitby = spl_by, type = "condense", 
                  test = FALSE)
```

```
## Error in eval(substitute(splitby), .data): object 'spl_by' not found
```

```r
descriptive_stats_newO <- 
  furniture::table1(analyzed_data[newO_to_desc], splitby = spl_by)
```

```
## Error in eval(substitute(splitby), .data): object 'spl_by' not found
```

Edit

```r
descriptive_stats_preds$Table1 <-
  descriptive_stats_preds$Table1 %>% 
  rename(Variable = " ",
         "No reoffence" = no_reoffence,
         "Non-violent reoffence" = reoffence_nonviolent,
         "Violent reoffence" = reoffence_violent) %>%
  mutate(Variable = stringr::str_remove(Variable, ":.*$")) %>% 
  left_join(variable_table[c("Variable", "Label")], by = "Variable") %>% 
  mutate(Variable = ifelse(is.na(Label), yes = Variable, no = Label)) %>%
  select(-Label)
```

```
## Error in .f(.x[[i]], ...): object 'no_reoffence' not found
```

```r
descriptive_stats_newO$Table1 <-
  descriptive_stats_newO$Table1 %>% 
  rename(Variable = " ",
         "No reoffence" = no_reoffence,
         "Non-violent reoffence" = reoffence_nonviolent,
         "Violent reoffence" = reoffence_violent) %>%
  mutate(Variable = stringr::str_remove(Variable, ":.*$")) %>% 
  left_join(variable_table[c("Variable", "Label")], by = "Variable") %>% 
  mutate(Variable = ifelse(is.na(Label), yes = Variable, no = Label)) %>%
  select(-Label)
```

```
## Error in .f(.x[[i]], ...): object 'no_reoffence' not found
```

```r
descriptive_stats_csv$Table1 <-
  descriptive_stats_csv$Table1 %>% 
  rename(Variable = " ",
         "No reoffence" = no_reoffence,
         "Non-violent reoffence" = reoffence_nonviolent,
         "Violent reoffence" = reoffence_violent) %>%
  mutate(Variable = stringr::str_remove(Variable, ":.*$")) %>% 
  left_join(variable_table[c("Variable", "Label")], by = "Variable") %>% 
  mutate(Variable = ifelse(is.na(Label), yes = Variable, no = Label)) %>%
  select(-Label)
```

```
## Error in eval(lhs, parent, parent): object 'descriptive_stats_csv' not found
```

Save in "/data".


```r
usethis::use_data(descriptive_stats_preds, overwrite = TRUE)
```

```
## <U+2714> Saving 'descriptive_stats_preds' to 'data/descriptive_stats_preds.rda'
```

```r
usethis::use_data(descriptive_stats_newO, overwrite = TRUE)
```

```
## <U+2714> Saving 'descriptive_stats_newO' to 'data/descriptive_stats_newO.rda'
```



```r
# Save as .csv
devtools::wd()
write.csv2(data.frame(descriptive_stats_csv), 
           "output/descriptive_stats_csv.csv") 
```

```
## Error in data.frame(descriptive_stats_csv): object 'descriptive_stats_csv' not found
```


```r
sessionInfo()
```

```
## R version 3.5.2 (2018-12-20)
## Platform: x86_64-w64-mingw32/x64 (64-bit)
## Running under: Windows >= 8 x64 (build 9200)
## 
## Matrix products: default
## 
## locale:
## [1] LC_COLLATE=Swedish_Finland.1252  LC_CTYPE=Swedish_Finland.1252   
## [3] LC_MONETARY=Swedish_Finland.1252 LC_NUMERIC=C                    
## [5] LC_TIME=Swedish_Finland.1252    
## 
## attached base packages:
## [1] stats     graphics  grDevices utils     datasets  methods   base     
## 
## other attached packages:
## [1] recidivismsl_0.0.0.9000 caret_6.0-81            ggplot2_3.1.0          
## [4] lattice_0.20-38         bindrcpp_0.2.2          dplyr_0.7.8            
## [7] magrittr_1.5            testthat_2.0.1         
## 
## loaded via a namespace (and not attached):
##  [1] nlme_3.1-137            fs_1.2.6               
##  [3] usethis_1.4.0           lubridate_1.7.4        
##  [5] devtools_2.0.1          rprojroot_1.3-2        
##  [7] tools_3.5.2             backports_1.1.3        
##  [9] utf8_1.1.4              R6_2.3.0               
## [11] rpart_4.1-13            lazyeval_0.2.1         
## [13] colorspace_1.4-0        nnet_7.3-12            
## [15] withr_2.1.2             tidyselect_0.2.5       
## [17] prettyunits_1.0.2       processx_3.2.1         
## [19] ResourceSelection_0.3-4 compiler_3.5.2         
## [21] cli_1.0.1               desc_1.2.0             
## [23] scales_1.0.0            readr_1.3.1            
## [25] callr_3.1.1             stringr_1.3.1          
## [27] digest_0.6.18           rmarkdown_1.11         
## [29] base64enc_0.1-3         pkgconfig_2.0.2        
## [31] htmltools_0.3.6         sessioninfo_1.1.1      
## [33] highr_0.7               rlang_0.3.1            
## [35] ggthemes_4.0.1          rstudioapi_0.9.0       
## [37] bindr_0.1.1             generics_0.0.2         
## [39] jsonlite_1.6            ModelMetrics_1.2.2     
## [41] Matrix_1.2-15           Rcpp_1.0.0             
## [43] munsell_0.5.0           fansi_0.4.0            
## [45] furniture_1.8.7         stringi_1.2.4          
## [47] pROC_1.13.0             yaml_2.2.0             
## [49] MASS_7.3-51.1           pkgbuild_1.0.2         
## [51] plyr_1.8.4              recipes_0.1.4          
## [53] grid_3.5.2              forcats_0.3.0          
## [55] crayon_1.3.4            splines_3.5.2          
## [57] hms_0.4.2               knitr_1.21             
## [59] ps_1.3.0                pillar_1.3.1           
## [61] reshape2_1.4.3          codetools_0.2-15       
## [63] clisymbols_1.2.0        stats4_3.5.2           
## [65] pkgload_1.0.2           glue_1.3.0             
## [67] evaluate_0.12           data.table_1.12.0      
## [69] remotes_2.0.2           foreach_1.4.4          
## [71] gtable_0.2.0            purrr_0.2.5            
## [73] tidyr_0.8.2             assertthat_0.2.0       
## [75] xfun_0.4                gower_0.1.2            
## [77] prodlim_2018.04.18      class_7.3-14           
## [79] survival_2.43-3         timeDate_3043.102      
## [81] tibble_2.0.1            iterators_1.0.10       
## [83] memoise_1.1.0           lava_1.6.4             
## [85] ipred_0.9-8
```
