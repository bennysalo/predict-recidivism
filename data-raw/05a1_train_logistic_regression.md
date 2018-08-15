Training logistic regression models
================
Benny Salo
2018-08-15

Load `recidivismsl` which contains `model_grid`.

``` r
devtools::load_all(".")
```

    ## Loading recidivismsl

Training set is defined in 01\_analyzed\_data.Rmd

``` r
devtools::wd()
training_set <- readRDS("not_public/training_set.rds")
```

Get the part of model\_grid that are logistic regression models.

``` r
library(dplyr)
glm_grid <- model_grid %>% filter(model_type == "Logistic regression")
```

Train each model (rows) in the grid according to specifications in the grid. Save the results as a named list.

(Record how long it takes to run.)

``` r
start <- Sys.time()

trained_mods_glm <- purrr::map2(
  .x = glm_grid$rhs,
  .y = glm_grid$lhs,
  .f = ~ caret::train(
    x         = training_set[.x],
    y         = training_set[[.y]],
    method    = "glm",
    family    = "binomial",
    metric    = "ROC",
    trControl = ctrl_fun_training
    )
  )
```

    ## Warning: glm.fit: fitted probabilities numerically 0 or 1 occurred

    ## Warning: glm.fit: fitted probabilities numerically 0 or 1 occurred

    ## Warning: glm.fit: fitted probabilities numerically 0 or 1 occurred

    ## Warning: glm.fit: fitted probabilities numerically 0 or 1 occurred

    ## Warning: glm.fit: fitted probabilities numerically 0 or 1 occurred

    ## Warning: glm.fit: fitted probabilities numerically 0 or 1 occurred

    ## Warning: glm.fit: fitted probabilities numerically 0 or 1 occurred

    ## Warning: glm.fit: fitted probabilities numerically 0 or 1 occurred

    ## Warning: glm.fit: fitted probabilities numerically 0 or 1 occurred

    ## Warning: glm.fit: fitted probabilities numerically 0 or 1 occurred

    ## Warning: glm.fit: fitted probabilities numerically 0 or 1 occurred

    ## Warning: glm.fit: fitted probabilities numerically 0 or 1 occurred

    ## Warning: glm.fit: fitted probabilities numerically 0 or 1 occurred

    ## Warning: glm.fit: fitted probabilities numerically 0 or 1 occurred

    ## Warning: glm.fit: fitted probabilities numerically 0 or 1 occurred

    ## Warning: glm.fit: fitted probabilities numerically 0 or 1 occurred

    ## Warning: glm.fit: fitted probabilities numerically 0 or 1 occurred

    ## Warning: glm.fit: fitted probabilities numerically 0 or 1 occurred

    ## Warning: glm.fit: fitted probabilities numerically 0 or 1 occurred

    ## Warning: glm.fit: fitted probabilities numerically 0 or 1 occurred

    ## Warning: glm.fit: fitted probabilities numerically 0 or 1 occurred

    ## Warning: glm.fit: fitted probabilities numerically 0 or 1 occurred

    ## Warning: glm.fit: fitted probabilities numerically 0 or 1 occurred

    ## Warning: glm.fit: fitted probabilities numerically 0 or 1 occurred

``` r
time_to_run <- Sys.time() - start
time_to_run
```

    ## Time difference of 9.525014 mins

``` r
names(trained_mods_glm) <- glm_grid$model_names
```

``` r
devtools::wd()
saveRDS(trained_mods_glm, "not_public/trained_mods_glm.rds")
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
    ## [1] caret_6.0-80            ggplot2_3.0.0           lattice_0.20-35        
    ## [4] bindrcpp_0.2.2          dplyr_0.7.6             recidivismsl_0.0.0.9000
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] magic_1.5-8        ddalpha_1.3.4      tidyr_0.8.1       
    ##  [4] sfsmisc_1.1-2      splines_3.5.1      foreach_1.4.4     
    ##  [7] prodlim_2018.04.18 assertthat_0.2.0   stats4_3.5.1      
    ## [10] DRR_0.0.3          yaml_2.2.0         robustbase_0.93-2 
    ## [13] ipred_0.9-7        pillar_1.3.0       backports_1.1.2   
    ## [16] glue_1.3.0         pROC_1.12.1        digest_0.6.15     
    ## [19] colorspace_1.3-2   recipes_0.1.3      htmltools_0.3.6   
    ## [22] Matrix_1.2-14      plyr_1.8.4         timeDate_3043.102 
    ## [25] pkgconfig_2.0.1    devtools_1.13.6    CVST_0.2-2        
    ## [28] broom_0.5.0        purrr_0.2.5        scales_1.0.0      
    ## [31] gower_0.1.2        lava_1.6.3         furniture_1.7.9   
    ## [34] tibble_1.4.2       withr_2.1.2        nnet_7.3-12       
    ## [37] lazyeval_0.2.1     survival_2.42-3    magrittr_1.5      
    ## [40] crayon_1.3.4       memoise_1.1.0      evaluate_0.11     
    ## [43] nlme_3.1-137       MASS_7.3-50        xml2_1.2.0        
    ## [46] dimRed_0.1.0       class_7.3-14       ggthemes_4.0.0    
    ## [49] tools_3.5.1        data.table_1.11.4  stringr_1.3.1     
    ## [52] kernlab_0.9-27     munsell_0.5.0      pls_2.6-0         
    ## [55] compiler_3.5.1     RcppRoll_0.3.0     rlang_0.2.1       
    ## [58] grid_3.5.1         iterators_1.0.10   rmarkdown_1.10    
    ## [61] testthat_2.0.0     geometry_0.3-6     gtable_0.2.0      
    ## [64] ModelMetrics_1.2.0 codetools_0.2-15   abind_1.4-5       
    ## [67] roxygen2_6.1.0     reshape2_1.4.3     R6_2.2.2          
    ## [70] lubridate_1.7.4    knitr_1.20         bindr_0.1.1       
    ## [73] commonmark_1.5     rprojroot_1.3-2    stringi_1.2.4     
    ## [76] Rcpp_0.12.18       rpart_4.1-13       DEoptimR_1.0-8    
    ## [79] tidyselect_0.2.4
