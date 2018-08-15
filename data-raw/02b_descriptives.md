Descriptive statistics
================
Benny Salo
2018-08-15

``` r
devtools::load_all(".")
library(dplyr)

devtools::wd()
analyzed_data <- readRDS("not_public/analyzed_data.rds")
```

Make offence variables factors. Likewise with variables representing missing information.

``` r
analyzed_data <-
analyzed_data %>% 
  mutate_at(.vars = vars(starts_with("o_"), starts_with("newO_"), -newO_violent,
            ps_info_missing, ageFirst_missing),
            factor, levels = c(0,1), labels = c("No", "Yes"))
```

Edit the levels of certain variables for the purpose of the table

``` r
levels(analyzed_data$openPrison)       <- 
  c("Closed prison", "Open prison")
levels(analyzed_data$supervisedParole) <- 
  c("No supervision", "Supervised parole")
```

``` r
vars_to_desc <- 
  variable_table$Variable[variable_table$Desciptives %in% c("num", "cat")]

# Remove superfluous variables
superfluous <- c("conditionalReleaseGranted", "conditionalReleaseSuccess")
vars_to_desc <- vars_to_desc[!(vars_to_desc %in% superfluous)]

newO_to_desc       <- stringr::str_subset(vars_to_desc, "^newO_")
predictors_to_desc <- vars_to_desc[!(vars_to_desc %in% newO_to_desc)]

# Create a seperate vector for the splitby argument
spl_by <- analyzed_data[["reoff_category"]]

descriptive_stats_preds <- 
  furniture::table1(analyzed_data[predictors_to_desc],
                  splitby = spl_by, type = "full", test = TRUE)
```

    ## Warning in chisq.test(d$split, d[[i]]): Chi-squared approximation may be
    ## incorrect

``` r
descriptive_stats_newO <- 
  furniture::table1(analyzed_data[newO_to_desc], splitby = spl_by)
```

Edit

``` r
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

Save in "/data".

``` r
devtools::use_data(descriptive_stats_preds, overwrite = TRUE)
devtools::use_data(descriptive_stats_newO, overwrite = TRUE)
```

``` r
sessionInfo()
```

    ## R version 3.5.1 (2018-07-02)
    ## Platform: x86_64-w64-mingw32/x64 (64-bit)
    ## Running under: Windows 10 x64 (build 17134)
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
    ## [1] bindrcpp_0.2.2          dplyr_0.7.6             recidivismsl_0.0.0.9000
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] magic_1.5-8        ddalpha_1.3.4      tidyr_0.8.1       
    ##  [4] sfsmisc_1.1-2      splines_3.5.1      foreach_1.4.4     
    ##  [7] prodlim_2018.04.18 assertthat_0.2.0   stats4_3.5.1      
    ## [10] DRR_0.0.3          yaml_2.2.0         robustbase_0.93-2 
    ## [13] ipred_0.9-7        pillar_1.3.0       backports_1.1.2   
    ## [16] lattice_0.20-35    glue_1.3.0         pROC_1.12.1       
    ## [19] digest_0.6.15      colorspace_1.3-2   recipes_0.1.3     
    ## [22] htmltools_0.3.6    Matrix_1.2-14      plyr_1.8.4        
    ## [25] timeDate_3043.102  pkgconfig_2.0.1    devtools_1.13.6   
    ## [28] CVST_0.2-2         broom_0.5.0        caret_6.0-80      
    ## [31] purrr_0.2.5        scales_1.0.0       gower_0.1.2       
    ## [34] lava_1.6.3         furniture_1.7.9    tibble_1.4.2      
    ## [37] ggplot2_3.0.0      withr_2.1.2        nnet_7.3-12       
    ## [40] lazyeval_0.2.1     survival_2.42-3    magrittr_1.5      
    ## [43] crayon_1.3.4       memoise_1.1.0      evaluate_0.11     
    ## [46] nlme_3.1-137       MASS_7.3-50        xml2_1.2.0        
    ## [49] dimRed_0.1.0       class_7.3-14       ggthemes_4.0.0    
    ## [52] tools_3.5.1        data.table_1.11.4  stringr_1.3.1     
    ## [55] kernlab_0.9-27     munsell_0.5.0      pls_2.6-0         
    ## [58] compiler_3.5.1     RcppRoll_0.3.0     rlang_0.2.1       
    ## [61] grid_3.5.1         iterators_1.0.10   rmarkdown_1.10    
    ## [64] testthat_2.0.0     geometry_0.3-6     gtable_0.2.0      
    ## [67] ModelMetrics_1.2.0 codetools_0.2-15   abind_1.4-5       
    ## [70] roxygen2_6.1.0     reshape2_1.4.3     R6_2.2.2          
    ## [73] lubridate_1.7.4    knitr_1.20         bindr_0.1.1       
    ## [76] commonmark_1.5     rprojroot_1.3-2    stringi_1.2.4     
    ## [79] Rcpp_0.12.18       rpart_4.1-13       DEoptimR_1.0-8    
    ## [82] tidyselect_0.2.4
