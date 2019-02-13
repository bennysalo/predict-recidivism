Descriptive statistics
================
Benny Salo
2019-02-13

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
levels(analyzed_data$openPrison) <-
  c("Closed prison", "Open prison")

levels(analyzed_data$supervisedParole) <- 
  c("No supervision", "Supervised parole")
```

Create a vector of variable names for descriptive statistics

``` r
# We want to describe the variables in variable_table indicated as `num`or`cat`
# in the `Descriptives columns
vars_to_desc <- 
  variable_table$Variable[variable_table$Desciptives %in% c("num", "cat")]

# Remove superfluous variables
superfluous  <- c("conditionalReleaseGranted", "conditionalReleaseSuccess")
vars_to_desc <- vars_to_desc[!(vars_to_desc %in% superfluous)]

# Vector for variables that have a _mr version (missing replaced)
non_mr_versions <- stringr::str_extract(vars_to_desc, pattern = "^.*(?=_mr$)")
non_mr_versions <- non_mr_versions[!is.na(non_mr_versions)]

# Create seperate vector for variables indicating new offences
newO_to_desc       <- stringr::str_subset(vars_to_desc, "^newO_")


predictors_to_desc <- 
  vars_to_desc[!(vars_to_desc %in% c(newO_to_desc, non_mr_versions))]
```

``` r
# Create a seperate vector for the splitby argument
spl_by <- analyzed_data[["reoff_category"]]

descriptive_stats_preds <- 
  furniture::table1(analyzed_data[predictors_to_desc],
                    splitby = spl_by, type = "full", test = TRUE)
```

    ## Breusch-Pagan Test of Heteroskedasticity suggests `var.equal = FALSE` in oneway.test() for: ageFirstSentence_mr

    ## Breusch-Pagan Test of Heteroskedasticity suggests `var.equal = FALSE` in oneway.test() for: followUpYears

    ## Warning in chisq.test(d$split, d[[i]]): Chi-squared approximation may be
    ## incorrect

    ## Breusch-Pagan Test of Heteroskedasticity suggests `var.equal = FALSE` in oneway.test() for: daysToNewO

    ## Breusch-Pagan Test of Heteroskedasticity suggests `var.equal = FALSE` in oneway.test() for: newSentenceMonths

``` r
descriptive_stats_csv <- 
  furniture::table1(analyzed_data[predictors_to_desc], 
                    splitby = spl_by, type = "condense", test = FALSE)
```

``` r
descriptive_stats_newO <- 
  furniture::table1(analyzed_data[newO_to_desc], splitby = spl_by)
```

    ## Warning in table1.data.frame(analyzed_data[newO_to_desc], splitby = spl_by): Not all variables have at least 2 unique values. Functionality of the following will be limited:
    ##  -- type = 'condense' will not work
    ##  -- test = TRUE will not work

Edit table

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

Save in "/data".

``` r
usethis::use_data(descriptive_stats_preds, overwrite = TRUE)
```


``` r
usethis::use_data(descriptive_stats_newO, overwrite = TRUE)
```

    ## <U+2714> Saving 'descriptive_stats_newO' to 'data/descriptive_stats_newO.rda'

``` r
# Save as .csv
devtools::wd()
write.csv2(data.frame(descriptive_stats_csv), 
           "output/descriptive_stats_csv.csv") 
```

``` r
sessionInfo()
```

    ## R version 3.5.2 (2018-12-20)
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
    ## [1] bindrcpp_0.2.2          dplyr_0.7.8             recidivismsl_0.0.0.9000
    ## [4] testthat_2.0.1         
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] pkgload_1.0.2      splines_3.5.2      foreach_1.4.4     
    ##  [4] prodlim_2018.04.18 assertthat_0.2.0   stats4_3.5.2      
    ##  [7] yaml_2.2.0         remotes_2.0.2      sessioninfo_1.1.1 
    ## [10] ipred_0.9-8        pillar_1.3.1       backports_1.1.3   
    ## [13] lattice_0.20-38    glue_1.3.0         pROC_1.13.0       
    ## [16] digest_0.6.18      colorspace_1.4-0   recipes_0.1.4     
    ## [19] htmltools_0.3.6    Matrix_1.2-15      plyr_1.8.4        
    ## [22] clisymbols_1.2.0   timeDate_3043.102  pkgconfig_2.0.2   
    ## [25] devtools_2.0.1     caret_6.0-81       purrr_0.2.5       
    ## [28] scales_1.0.0       processx_3.2.1     gower_0.1.2       
    ## [31] lava_1.6.4         furniture_1.8.7    tibble_2.0.1      
    ## [34] generics_0.0.2     ggplot2_3.1.0      usethis_1.4.0     
    ## [37] withr_2.1.2        nnet_7.3-12        lazyeval_0.2.1    
    ## [40] cli_1.0.1          survival_2.43-3    magrittr_1.5      
    ## [43] crayon_1.3.4       memoise_1.1.0      evaluate_0.12     
    ## [46] ps_1.3.0           fs_1.2.6           nlme_3.1-137      
    ## [49] MASS_7.3-51.1      forcats_0.3.0      class_7.3-14      
    ## [52] pkgbuild_1.0.2     ggthemes_4.0.1     tools_3.5.2       
    ## [55] data.table_1.12.0  prettyunits_1.0.2  stringr_1.3.1     
    ## [58] munsell_0.5.0      callr_3.1.1        compiler_3.5.2    
    ## [61] rlang_0.3.1        grid_3.5.2         iterators_1.0.10  
    ## [64] rstudioapi_0.9.0   rmarkdown_1.11     gtable_0.2.0      
    ## [67] ModelMetrics_1.2.2 codetools_0.2-15   reshape2_1.4.3    
    ## [70] R6_2.3.0           lubridate_1.7.4    knitr_1.21        
    ## [73] bindr_0.1.1        rprojroot_1.3-2    desc_1.2.0        
    ## [76] stringi_1.2.4      Rcpp_1.0.0         rpart_4.1-13      
    ## [79] tidyselect_0.2.5   xfun_0.4
