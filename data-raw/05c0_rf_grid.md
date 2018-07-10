Create `rf_grid`
================
Benny Salo
2018-07-10

``` r
library(dplyr)
devtools::load_all(".")
```

Get the part of model\_grid that are random forest models.

``` r
rf_grid <- model_grid %>% filter(model_type == "Random forest")
```

In the first run we test seven possible values for the tuning parameter `mtry`, including the often recommended square root of the number of predictors. We test three smaller and three bigger values in relation to this. The sequence of tested values are the number of predictors raised to the power of 1/8, 1/4, 3/8, 1/2 (i.e. the square root), 5/8, 3/4, and 7/8.

We create a new column for this argument

``` r
write_mtry_seq <- function(predictor_vector) {
  n_preds  <- length(predictor_vector)
  powers   <- (1:7)/8
  mtry_seq <- as.integer(round(n_preds^powers))
}

rf_grid$mtry_seq <- 
  purrr::map(
    .x = rf_grid$rhs,
    .f = ~ write_mtry_seq(.x)
  )
```

Assertions

``` r
library(assertthat)
# All entries in rf_grid$mtry_seq should be of class integer
assert_that(all(purrr::map_chr(rf_grid$mtry_seq, class) == "integer"))
```

    ## [1] TRUE

``` r
# All entries in rf_grid$mtry_seq should have length 7.
assert_that(all(purrr::map_chr(rf_grid$mtry_seq, length) == 7))
```

    ## [1] TRUE

``` r
# The fourth element should be the sqrt of the number of predictors
fourth  <- purrr::map_int(rf_grid$mtry_seq, 4)
n_preds <- purrr::map_int(rf_grid$rhs, length)

assert_that(all(fourth == round(sqrt(n_preds))))
```

    ## [1] TRUE

Save and make available in `/data`

``` r
devtools::use_data(rf_grid, overwrite = TRUE)
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
    ## [1] assertthat_0.2.0        bindrcpp_0.2.2          recidivismsl_0.0.0.9000
    ## [4] dplyr_0.7.6            
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] magic_1.5-8        ddalpha_1.3.4      tidyr_0.8.1       
    ##  [4] sfsmisc_1.1-2      splines_3.5.1      foreach_1.4.4     
    ##  [7] prodlim_2018.04.18 stats4_3.5.1       DRR_0.0.3         
    ## [10] yaml_2.1.19        robustbase_0.93-1  ipred_0.9-6       
    ## [13] pillar_1.2.3       backports_1.1.2    lattice_0.20-35   
    ## [16] glue_1.2.0         pROC_1.12.1        digest_0.6.15     
    ## [19] colorspace_1.3-2   recipes_0.1.3      htmltools_0.3.6   
    ## [22] Matrix_1.2-14      plyr_1.8.4         psych_1.8.4       
    ## [25] timeDate_3043.102  pkgconfig_2.0.1    devtools_1.13.6   
    ## [28] CVST_0.2-2         broom_0.4.5        caret_6.0-80      
    ## [31] purrr_0.2.5        scales_0.5.0       gower_0.1.2       
    ## [34] lava_1.6.2         tibble_1.4.2       ggplot2_3.0.0     
    ## [37] withr_2.1.2        nnet_7.3-12        lazyeval_0.2.1    
    ## [40] mnormt_1.5-5       survival_2.42-3    magrittr_1.5      
    ## [43] memoise_1.1.0      evaluate_0.10.1    nlme_3.1-137      
    ## [46] MASS_7.3-50        xml2_1.2.0         dimRed_0.1.0      
    ## [49] foreign_0.8-70     class_7.3-14       ggthemes_3.5.0    
    ## [52] tools_3.5.1        stringr_1.3.1      kernlab_0.9-26    
    ## [55] munsell_0.5.0      pls_2.6-0          compiler_3.5.1    
    ## [58] RcppRoll_0.3.0     rlang_0.2.1        grid_3.5.1        
    ## [61] iterators_1.0.9    rmarkdown_1.10     testthat_2.0.0    
    ## [64] geometry_0.3-6     gtable_0.2.0       ModelMetrics_1.1.0
    ## [67] codetools_0.2-15   abind_1.4-5        roxygen2_6.0.1    
    ## [70] reshape2_1.4.3     R6_2.2.2           lubridate_1.7.4   
    ## [73] knitr_1.20         bindr_0.1.1        commonmark_1.5    
    ## [76] rprojroot_1.3-2    stringi_1.1.7      parallel_3.5.1    
    ## [79] Rcpp_0.12.17       rpart_4.1-13       DEoptimR_1.0-8    
    ## [82] tidyselect_0.2.4
