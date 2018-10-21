Predicting recidivism in test set based on models trained on training set
================
Benny Salo
2018-10-06

Here we create /data/test\_set\_predictions.rda. It will contain predictions for the individuals in the test set produced by the trained models. In addition we include the true observed outcomes. `test_set_predictions` will be used for calculating discimination and calibration values in the test set.

### Setup

``` r
rm(list = ls())
library(dplyr)
devtools::load_all(".")
```

Load models

``` r
devtools::wd()
trained_mods_all  <- readRDS("not_public/trained_mods_all.rds")
```

Load test set

``` r
devtools::wd()
test_set <- readRDS("not_public/test_set.rds")
```

``` r
# Create a function to extract predictions for a given model
predict_test_set<- function(model) {
  caret::predict.train(model, newdata = test_set, type = "prob")[[2]]
}
```

test\_set\_predictions
----------------------

``` r
# Apply this function to all models in the list
test_set_predictions <- purrr::map_df(.x = trained_mods_all, 
                                      .f = ~ predict_test_set(.x))

# Add the observed outcomes
test_set_predictions <- 
  test_set %>% 
  select(reoffenceThisTerm, newO_violent, reoff_category) %>% 
  bind_cols(test_set_predictions)
```

Save and make available in /data

``` r
devtools::use_data(test_set_predictions, overwrite = TRUE)
```

### Print session info

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
    ## [1] recidivismsl_0.0.0.9000 dplyr_0.7.6            
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] magic_1.5-8         ddalpha_1.3.4       tidyr_0.8.1        
    ##  [4] sfsmisc_1.1-2       splines_3.5.1       foreach_1.4.4      
    ##  [7] prodlim_2018.04.18  assertthat_0.2.0    stats4_3.5.1       
    ## [10] DRR_0.0.3           yaml_2.2.0          robustbase_0.93-2  
    ## [13] ipred_0.9-7         pillar_1.3.0        backports_1.1.2    
    ## [16] lattice_0.20-35     glue_1.3.0          pROC_1.12.1        
    ## [19] digest_0.6.16       randomForest_4.6-14 colorspace_1.3-2   
    ## [22] recipes_0.1.3       htmltools_0.3.6     Matrix_1.2-14      
    ## [25] plyr_1.8.4          timeDate_3043.102   pkgconfig_2.0.2    
    ## [28] devtools_1.13.6     CVST_0.2-2          broom_0.5.0        
    ## [31] caret_6.0-80        purrr_0.2.5         scales_1.0.0       
    ## [34] gower_0.1.2         lava_1.6.3          furniture_1.7.9    
    ## [37] tibble_1.4.2        ggplot2_3.0.0       withr_2.1.2        
    ## [40] nnet_7.3-12         lazyeval_0.2.1      survival_2.42-3    
    ## [43] magrittr_1.5        crayon_1.3.4        memoise_1.1.0      
    ## [46] evaluate_0.11       nlme_3.1-137        MASS_7.3-50        
    ## [49] xml2_1.2.0          dimRed_0.1.0        class_7.3-14       
    ## [52] ggthemes_4.0.1      tools_3.5.1         data.table_1.11.4  
    ## [55] stringr_1.3.1       kernlab_0.9-27      glmnet_2.0-16      
    ## [58] munsell_0.5.0       bindrcpp_0.2.2      pls_2.7-0          
    ## [61] compiler_3.5.1      RcppRoll_0.3.0      rlang_0.2.2        
    ## [64] grid_3.5.1          iterators_1.0.10    rmarkdown_1.10     
    ## [67] testthat_2.0.0      geometry_0.3-6      gtable_0.2.0       
    ## [70] ModelMetrics_1.2.0  codetools_0.2-15    abind_1.4-5        
    ## [73] roxygen2_6.1.0      reshape2_1.4.3      R6_2.2.2           
    ## [76] lubridate_1.7.4     knitr_1.20          bindr_0.1.1        
    ## [79] commonmark_1.5      rprojroot_1.3-2     stringi_1.2.4      
    ## [82] Rcpp_0.12.18        rpart_4.1-13        DEoptimR_1.0-8     
    ## [85] tidyselect_0.2.4
