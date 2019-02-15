---
title: "Checking first round of glmnet models"
author: "Benny Salo"
date: "2019-02-14"
output: github_document
---

Here we choose the tuning parameter combinations (alpha and lambda) that result in a better logLoss value in at least one of the 8 resamples than the model that performs best on average. A win followed by seven more wins only happen in 1/(2^7) = 0.8% of cases by chance. Tuning parameter combinations that do not meet this threshold are not tested further. Tuning parameter combinations with at least one "win" over the best combination(by mean logLoss) are tested with more repeats.

## Setup


```r
devtools::load_all(".")
library(dplyr)
```

Load trained models

```r
devtools::wd()
trained_mods_glmnet_1 <- readRDS("not_public/trained_mods_glmnet_1.rds")
```

Write a function to get qualified tuning parameters.

```r
get_qual_tune_params_LL <- function(trained_mod) {
  # Get the performance per resample using the best tuning parameters
  LL_resamp_by_bestTune <-
    trained_mod$bestTune %>%
    left_join(trained_mod$resample, by = c("alpha", "lambda")) %>%
    select(Resample, logLoss)
  
  # Get the performance per resample in all tested models
  LL_resamp_by_tuneID <- trained_mod$resample %>%
    # Create a "id" column consisting of alpha and lambda values
    mutate(id = paste(alpha, lambda)) %>%
    select(-ROC,-alpha,-lambda) %>%
    # Transpose to give every model seperate column. One row per resample.
    tidyr::spread(id, logLoss)
  
  # Compare all models to the best
  LL_resamp_by_tuneID %>% 
    # Exclude first column (Resample) and compare all other columns to the
    # column for the best model. Gives TRUE if lower (better) logLoss than best
    # tuning parameters
    mutate_at(-1., ~ . < LL_resamp_by_bestTune$logLoss) %>%
    # calculate percentage better 
    summarise_at(-1, sum) %>%
    # transpose to give a seperate row to each model. Single column for
    # number of resamples where this model performs better than best tuned
    # model
    tidyr::gather(tuning_params, value = n_better) %>%
    # remove models that were never better
    filter(n_better > 0) %>%
    # Create a vector with the tuning parameter ids
    select(tuning_params) %>%
    purrr::as_vector() %>%
    # Seperate back into a seperate alpha and lambda value
    stringr::str_split(pattern = " ", simplify = TRUE) %>%
    # Coerse to a data frame and give appropriate column names.
    as_data_frame() %>%
    transmute(alpha = as.numeric(V1), lambda = as.numeric(V2))
}
```

Write a function to get qualified tuning parameters.

```r
get_qual_tune_params_AUC <- function(trained_mod) {
  # Get the performance per resample using the best tuning parameters
  AUC_resamp_by_bestTune <-
    trained_mod$results %>%
    filter(ROC == max(ROC)) %>% 
    select(alpha, lambda) %>% 
    left_join(trained_mod$resample, by = c("alpha", "lambda")) %>%
    select(Resample, ROC)
  
  # Get the performance per resample in all tested models
  AUC_resamp_by_tuneID <- trained_mod$resample %>%
    # Create a "id" column consisting of alpha and lambda values
    mutate(id = paste(alpha, lambda)) %>%
    select(-logLoss,-alpha,-lambda) %>%
    # Transpose to give every model seperate column. One row per resample.
    tidyr::spread(id, ROC)
  
  # Compare all models to the best
  AUC_resamp_by_tuneID %>% 
    # Exclude first column (Resample) and compare all other columns to the
    # column for the best model. Gives TRUE if lower (better) logLoss than best
    # tuning parameters
    mutate_at(-1., ~ . > AUC_resamp_by_bestTune$ROC) %>%
    # calculate percentage better 
    summarise_at(-1, sum) %>%
    # transpose to give a seperate row to each model. Single column for
    # number of resamples where this model performs better than best tuned
    # model
    tidyr::gather(tuning_params, value = n_better) %>%
    # remove models that were never better
    filter(n_better > 0) %>%
    # Create a vector with the tuning parameter ids
    select(tuning_params) %>%
    purrr::as_vector() %>%
    # Seperate back into a seperate alpha and lambda value
    stringr::str_split(pattern = " ", simplify = TRUE) %>%
    # Coerse to a data frame and give appropriate column names.
    as_data_frame() %>%
    transmute(alpha = as.numeric(V1), lambda = as.numeric(V2))
}
```



Apply these two functions.

```r
start <- Sys.time()
  qual_tunes_LL  <- purrr::map(trained_mods_glmnet_1, get_qual_tune_params_LL)
  Sys.time() - start
```

```
## Time difference of 2.339476 mins
```

```r
  start <- Sys.time()
  qual_tunes_AUC <- purrr::map(trained_mods_glmnet_1, get_qual_tune_params_AUC)
  Sys.time() - start
```

```
## Time difference of 2.341411 mins
```

```r
  qual_tunes_glmnet <- data_frame(
    model_name    = names(trained_mods_glmnet_1),
    tuning_params = purrr::map2(qual_tunes_LL, qual_tunes_AUC, union))
```


Check the range of the tuning parameters


```r
get_tune_range <- function(tune_grid) {
  tune_grid %>% 
    summarise(min(alpha), max(alpha), min(lambda), max(lambda), n_comb = n())
}

purrr::map_df(qual_tunes_LL, get_tune_range)
```

```
## # A tibble: 8 x 5
##   `min(alpha)` `max(alpha)` `min(lambda)` `max(lambda)` n_comb
##          <dbl>        <dbl>         <dbl>         <dbl>  <int>
## 1            0            1          0             1       381
## 2            0            1          0             1       252
## 3            0            1          0             0.37    129
## 4            0            1          0             0.47    133
## 5            0            1          0             0.96    206
## 6            0            1          0.01          1       218
## 7            0            1          0             0.21     88
## 8            0            1          0             1       208
```

```r
purrr::map_df(qual_tunes_AUC, get_tune_range)
```

```
## # A tibble: 8 x 5
##   `min(alpha)` `max(alpha)` `min(lambda)` `max(lambda)` n_comb
##          <dbl>        <dbl>         <dbl>         <dbl>  <int>
## 1            0            1          0              1      377
## 2            0            1          0              1      382
## 3            0            1          0              1      353
## 4            0            1          0              1      373
## 5            0            1          0              1      387
## 6            0            1          0.01           1      343
## 7            0            1          0              0.7    245
## 8            0            1          0              1      339
```

```r
purrr::map_df(qual_tunes_glmnet$tuning_params, get_tune_range)
```

```
## # A tibble: 8 x 5
##   `min(alpha)` `max(alpha)` `min(lambda)` `max(lambda)` n_comb
##          <dbl>        <dbl>         <dbl>         <dbl>  <int>
## 1            0            1          0              1      408
## 2            0            1          0              1      382
## 3            0            1          0              1      353
## 4            0            1          0              1      373
## 5            0            1          0              1      387
## 6            0            1          0.01           1      344
## 7            0            1          0              0.7    245
## 8            0            1          0              1      339
```



Save and make available in `/data`

```r
devtools::use_data(qual_tunes_glmnet, overwrite = TRUE)
```

```
## Warning: 'devtools::use_data' is deprecated.
## Use 'usethis::use_data()' instead.
## See help("Deprecated") and help("devtools-deprecated").
```

```
## <U+2714> Saving 'qual_tunes_glmnet' to 'data/qual_tunes_glmnet.rda'
```

Test whether the model with the best ROC-value is included


```r
is_best_tune_ROC_included <- function(trained_mod, tune_params_df) {
  # get a single row data frame with alpha and lambda for best ROC
  trained_mod$results %>%
  filter(ROC == max(ROC)) %>%
  select(alpha, lambda) %>%
  # Check that the intersection of this and the new tuning parameter df is not
  # empty
  intersect(tune_params_df) %>%
  nrow() != 0
}

purrr::map2(.x = trained_mods_glmnet_1,
            .y = qual_tunes_glmnet$tuning_params,
            .f = ~is_best_tune_ROC_included(.x, .y))
```

```
## $gen_rita_glmnet
## [1] TRUE
## 
## $vio_rita_glmnet
## [1] TRUE
## 
## $gen_stat_glmnet
## [1] TRUE
## 
## $vio_stat_glmnet
## [1] FALSE
## 
## $gen_bgnn_glmnet
## [1] TRUE
## 
## $vio_bgnn_glmnet
## [1] TRUE
## 
## $gen_allp_glmnet
## [1] TRUE
## 
## $vio_allp_glmnet
## [1] TRUE
```



Print sessionInfo

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
##  [1] recidivismsl_0.0.0.9000 assertthat_0.2.0       
##  [3] caret_6.0-81            lattice_0.20-38        
##  [5] bindrcpp_0.2.2          ggplot2_3.1.0          
##  [7] dplyr_0.7.8             testthat_2.0.1         
##  [9] purrr_0.2.5             magrittr_1.5           
## 
## loaded via a namespace (and not attached):
##  [1] nlme_3.1-137            fs_1.2.6               
##  [3] xopen_1.0.0             usethis_1.4.0          
##  [5] lubridate_1.7.4         devtools_2.0.1         
##  [7] rprojroot_1.3-2         tools_3.5.2            
##  [9] backports_1.1.3         utf8_1.1.4             
## [11] R6_2.3.0                rpart_4.1-13           
## [13] lazyeval_0.2.1          colorspace_1.4-0       
## [15] nnet_7.3-12             withr_2.1.2            
## [17] ResourceSelection_0.3-4 tidyselect_0.2.5       
## [19] prettyunits_1.0.2       processx_3.2.1         
## [21] compiler_3.5.2          glmnet_2.0-16          
## [23] cli_1.0.1               xml2_1.2.0             
## [25] desc_1.2.0              scales_1.0.0           
## [27] randomForest_4.6-14     readr_1.3.1            
## [29] callr_3.1.1             commonmark_1.7         
## [31] stringr_1.3.1           digest_0.6.18          
## [33] pkgconfig_2.0.2         sessioninfo_1.1.1      
## [35] highr_0.7               rlang_0.3.1            
## [37] ggthemes_4.0.1          rstudioapi_0.9.0       
## [39] bindr_0.1.1             generics_0.0.2         
## [41] ModelMetrics_1.2.2      Matrix_1.2-15          
## [43] Rcpp_1.0.0              munsell_0.5.0          
## [45] fansi_0.4.0             furniture_1.8.7        
## [47] stringi_1.2.4           pROC_1.13.0            
## [49] yaml_2.2.0              MASS_7.3-51.1          
## [51] pkgbuild_1.0.2          plyr_1.8.4             
## [53] recipes_0.1.4           grid_3.5.2             
## [55] forcats_0.3.0           crayon_1.3.4           
## [57] splines_3.5.2           hms_0.4.2              
## [59] knitr_1.21              ps_1.3.0               
## [61] pillar_1.3.1            reshape2_1.4.3         
## [63] codetools_0.2-15        clisymbols_1.2.0       
## [65] stats4_3.5.2            pkgload_1.0.2          
## [67] glue_1.3.0              evaluate_0.12          
## [69] data.table_1.12.0       remotes_2.0.2          
## [71] foreach_1.4.4           gtable_0.2.0           
## [73] rcmdcheck_1.3.2         tidyr_0.8.2            
## [75] xfun_0.4                gower_0.1.2            
## [77] prodlim_2018.04.18      roxygen2_6.1.1         
## [79] class_7.3-14            survival_2.43-3        
## [81] timeDate_3043.102       tibble_2.0.1           
## [83] iterators_1.0.10        memoise_1.1.0          
## [85] lava_1.6.4              ipred_0.9-8
```


We could also do the following:

Here we diagnose the results from trained elastic net models. The general pattern is that prediction of violent recidivism is benefited by ridge regression type penalties (alpha = 0) while prediction of general recidivism benefits from more lasso type penalties (alpha = 1). 

We tabulate the best tuning values (alpha and lambda) based on logLoss and ROC and their corresponding AUC-values.


