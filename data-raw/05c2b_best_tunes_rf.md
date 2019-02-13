`best_tunes_rf`
================
Benny Salo
2019-02-12

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
    ## 1 gen_rita_rf           4            4
    ## 2 vio_rita_rf           2            2
    ## 3 gen_stat_rf           2            2
    ## 4 vio_stat_rf           3            3
    ## 5 gen_bgnn_rf           9            9
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

    ## Warning: 'devtools::use_data' is deprecated.
    ## Use 'usethis::use_data()' instead.
    ## See help("Deprecated") and help("devtools-deprecated").

    ## <U+2714> Saving 'best_tunes_rf' to 'data/best_tunes_rf.rda'

### Print sessionInfo

``` r
sessionInfo()
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
    ##  [1] recidivismsl_0.0.0.9000 purrr_0.2.5            
    ##  [3] assertthat_0.2.0        caret_6.0-81           
    ##  [5] ggplot2_3.1.0           lattice_0.20-38        
    ##  [7] bindrcpp_0.2.2          dplyr_0.7.8            
    ##  [9] magrittr_1.5            testthat_2.0.1         
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
    ## [21] glmnet_2.0-16           cli_1.0.1              
    ## [23] desc_1.2.0              scales_1.0.0           
    ## [25] randomForest_4.6-14     readr_1.3.1            
    ## [27] callr_3.1.1             stringr_1.3.1          
    ## [29] digest_0.6.18           rmarkdown_1.11         
    ## [31] base64enc_0.1-3         pkgconfig_2.0.2        
    ## [33] htmltools_0.3.6         sessioninfo_1.1.1      
    ## [35] highr_0.7               rlang_0.3.1            
    ## [37] ggthemes_4.0.1          rstudioapi_0.9.0       
    ## [39] bindr_0.1.1             generics_0.0.2         
    ## [41] jsonlite_1.6            ModelMetrics_1.2.2     
    ## [43] Matrix_1.2-15           Rcpp_1.0.0             
    ## [45] munsell_0.5.0           fansi_0.4.0            
    ## [47] furniture_1.8.7         stringi_1.2.4          
    ## [49] pROC_1.13.0             yaml_2.2.0             
    ## [51] MASS_7.3-51.1           pkgbuild_1.0.2         
    ## [53] plyr_1.8.4              recipes_0.1.4          
    ## [55] grid_3.5.2              forcats_0.3.0          
    ## [57] crayon_1.3.4            splines_3.5.2          
    ## [59] hms_0.4.2               knitr_1.21             
    ## [61] ps_1.3.0                pillar_1.3.1           
    ## [63] reshape2_1.4.3          codetools_0.2-15       
    ## [65] clisymbols_1.2.0        stats4_3.5.2           
    ## [67] pkgload_1.0.2           glue_1.3.0             
    ## [69] evaluate_0.12           data.table_1.12.0      
    ## [71] remotes_2.0.2           foreach_1.4.4          
    ## [73] gtable_0.2.0            tidyr_0.8.2            
    ## [75] xfun_0.4                gower_0.1.2            
    ## [77] prodlim_2018.04.18      class_7.3-14           
    ## [79] survival_2.43-3         timeDate_3043.102      
    ## [81] tibble_2.0.1            iterators_1.0.10       
    ## [83] memoise_1.1.0           lava_1.6.4             
    ## [85] ipred_0.9-8
