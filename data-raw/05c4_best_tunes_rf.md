`best_tunes_rf`
================
Benny Salo
2018-09-19

Here we create the object `best_tunes_rf`. It is a data frame with three columns: `model_name`, `best_for_LL`, and `best_for_AUC`. The data frame ha 8 rows - one for each model. The column `best_for_LL` is a list of single row data frames containing the best tuning parameters miminizing log loss. Simililarily `best_for_AUC` is a list of data frames containing the tuning parameters maximizing AUC. These tuning paramters are used in "trained\_models\_glmnet\_3" to train final models and record calibration statistics.

Setup
-----

``` r
rm(list = ls())
devtools::load_all(".")
library(dplyr)
```

``` r
devtools::wd()
trained_mods_rf_2 <- readRDS("not_public/trained_mods_rf_2.rds")
```

``` r
get_best_tune_AUC <- function(trained_mod) {
  trained_mod$results %>%
    filter(ROC == max(ROC)) %>%
    select(mtry) 
}



best_tunes_rf <- data_frame(
  model_name   = names(trained_mods_rf_2),
  best_for_LL  = unlist(purrr::map(trained_mods_rf_2, "bestTune")),
  best_for_AUC = unlist(purrr::map(trained_mods_rf_2, get_best_tune_AUC))
)

best_tunes_rf
```

    ## # A tibble: 8 x 3
    ##   model_name  best_for_LL best_for_AUC
    ##   <chr>             <int>        <int>
    ## 1 gen_rita_rf           3            3
    ## 2 vio_rita_rf           2            2
    ## 3 gen_stat_rf           2            2
    ## 4 vio_stat_rf           3            3
    ## 5 gen_bgnn_rf          13           13
    ## 6 vio_bgnn_rf           9            9
    ## 7 gen_allp_rf          27           27
    ## 8 vio_allp_rf          13           13

Check that the best mtry for a model is the same regardless if it we are maximising AUC or minimizing log loss (LL).

``` r
stopifnot(
  all(
    best_tunes_rf$best_for_LL == best_tunes_rf$best_for_AUC
    ))
```

``` r
best_tunes_rf <- data_frame(
  model_name   = names(trained_mods_rf_2),
  best_for_LL  = purrr::map(trained_mods_rf_2, "bestTune")
)
```

Save and make available in `/data`

``` r
devtools::use_data(best_tunes_rf, overwrite = TRUE)
```

### Print sessionInfo

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
    ## [19] digest_0.6.16      colorspace_1.3-2   recipes_0.1.3     
    ## [22] htmltools_0.3.6    Matrix_1.2-14      plyr_1.8.4        
    ## [25] timeDate_3043.102  pkgconfig_2.0.2    devtools_1.13.6   
    ## [28] CVST_0.2-2         broom_0.5.0        caret_6.0-80      
    ## [31] purrr_0.2.5        scales_1.0.0       gower_0.1.2       
    ## [34] lava_1.6.3         furniture_1.7.9    tibble_1.4.2      
    ## [37] ggplot2_3.0.0      withr_2.1.2        nnet_7.3-12       
    ## [40] lazyeval_0.2.1     cli_1.0.0          survival_2.42-3   
    ## [43] magrittr_1.5       crayon_1.3.4       memoise_1.1.0     
    ## [46] evaluate_0.11      fansi_0.3.0        nlme_3.1-137      
    ## [49] MASS_7.3-50        xml2_1.2.0         dimRed_0.1.0      
    ## [52] class_7.3-14       ggthemes_4.0.1     tools_3.5.1       
    ## [55] data.table_1.11.4  stringr_1.3.1      kernlab_0.9-27    
    ## [58] munsell_0.5.0      pls_2.7-0          compiler_3.5.1    
    ## [61] RcppRoll_0.3.0     rlang_0.2.2        grid_3.5.1        
    ## [64] iterators_1.0.10   rmarkdown_1.10     testthat_2.0.0    
    ## [67] geometry_0.3-6     gtable_0.2.0       ModelMetrics_1.2.0
    ## [70] codetools_0.2-15   abind_1.4-5        roxygen2_6.1.0    
    ## [73] reshape2_1.4.3     R6_2.2.2           lubridate_1.7.4   
    ## [76] knitr_1.20         utf8_1.1.4         bindr_0.1.1       
    ## [79] commonmark_1.5     rprojroot_1.3-2    stringi_1.2.4     
    ## [82] Rcpp_0.12.18       rpart_4.1-13       DEoptimR_1.0-8    
    ## [85] tidyselect_0.2.4
