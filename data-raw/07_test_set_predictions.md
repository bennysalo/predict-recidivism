Predicting recidivism in test set based on models trained on training set
================
Benny Salo
2018-07-11

``` r
rm(list = ls())
library(dplyr)
devtools::load_all(".")
```

Load models

``` r
devtools::wd()
trained_mods_all <- readRDS("not_public/trained_mods_all.rds")
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

# Apply this function to all models in the list
test_set_predictions <- purrr::map_df(.x = trained_mods_all, 
                                      .f = ~ predict_test_set(.x))
```

Save and make available in /data

``` r
devtools::use_data(test_set_predictions, overwrite = TRUE)
```

Print sessionInfo

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
    ## [10] DRR_0.0.3           yaml_2.1.19         robustbase_0.93-1  
    ## [13] ipred_0.9-6         pillar_1.2.3        backports_1.1.2    
    ## [16] lattice_0.20-35     glue_1.2.0          pROC_1.12.1        
    ## [19] digest_0.6.15       randomForest_4.6-14 colorspace_1.3-2   
    ## [22] recipes_0.1.3       htmltools_0.3.6     Matrix_1.2-14      
    ## [25] plyr_1.8.4          psych_1.8.4         timeDate_3043.102  
    ## [28] pkgconfig_2.0.1     devtools_1.13.6     CVST_0.2-2         
    ## [31] broom_0.4.5         caret_6.0-80        purrr_0.2.5        
    ## [34] scales_0.5.0        gower_0.1.2         lava_1.6.2         
    ## [37] tibble_1.4.2        ggplot2_3.0.0       withr_2.1.2        
    ## [40] nnet_7.3-12         lazyeval_0.2.1      mnormt_1.5-5       
    ## [43] survival_2.42-3     magrittr_1.5        memoise_1.1.0      
    ## [46] evaluate_0.10.1     nlme_3.1-137        MASS_7.3-50        
    ## [49] xml2_1.2.0          dimRed_0.1.0        foreign_0.8-70     
    ## [52] class_7.3-14        ggthemes_3.5.0      tools_3.5.1        
    ## [55] stringr_1.3.1       kernlab_0.9-26      glmnet_2.0-16      
    ## [58] munsell_0.5.0       bindrcpp_0.2.2      pls_2.6-0          
    ## [61] compiler_3.5.1      RcppRoll_0.3.0      rlang_0.2.1        
    ## [64] grid_3.5.1          iterators_1.0.9     rmarkdown_1.10     
    ## [67] testthat_2.0.0      geometry_0.3-6      gtable_0.2.0       
    ## [70] ModelMetrics_1.1.0  codetools_0.2-15    abind_1.4-5        
    ## [73] roxygen2_6.0.1      reshape2_1.4.3      R6_2.2.2           
    ## [76] lubridate_1.7.4     knitr_1.20          bindr_0.1.1        
    ## [79] commonmark_1.5      rprojroot_1.3-2     stringi_1.1.7      
    ## [82] parallel_3.5.1      Rcpp_0.12.17        rpart_4.1-13       
    ## [85] DEoptimR_1.0-8      tidyselect_0.2.4
