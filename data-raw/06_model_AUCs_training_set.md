Extracting model performances in the training set
================
Benny Salo
2018-08-16

Here we extract the model performances in the seperate folds in the 10 x 10 folds in the training data. - the main models of all algoritm types and,

These are numbers that we can make public and therfore store in /data

``` r
devtools::wd()
trained_mods_all  <- readRDS("not_public/trained_mods_all.rds")
```

Creating `model_AUCs_training_set`

Extract the model performances in the 10 x 10 folds in the training data

``` r
model_AUCs_training_set      <- caret::resamples(trained_mods_all)
```

Save and make available via /data

``` r
devtools::use_data(model_AUCs_training_set, overwrite = TRUE)
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
    ## loaded via a namespace (and not attached):
    ##  [1] Rcpp_0.12.18       lubridate_1.7.4    lattice_0.20-35   
    ##  [4] tidyr_0.8.1        class_7.3-14       glmnet_2.0-16     
    ##  [7] assertthat_0.2.0   rprojroot_1.3-2    digest_0.6.15     
    ## [10] ipred_0.9-7        foreach_1.4.4      R6_2.2.2          
    ## [13] plyr_1.8.4         backports_1.1.2    magic_1.5-8       
    ## [16] stats4_3.5.1       evaluate_0.11      ggplot2_3.0.0     
    ## [19] pillar_1.3.0       rlang_0.2.1        lazyeval_0.2.1    
    ## [22] caret_6.0-80       data.table_1.11.4  kernlab_0.9-27    
    ## [25] rpart_4.1-13       Matrix_1.2-14      rmarkdown_1.10    
    ## [28] devtools_1.13.6    splines_3.5.1      CVST_0.2-2        
    ## [31] ddalpha_1.3.4      gower_0.1.2        stringr_1.3.1     
    ## [34] munsell_0.5.0      broom_0.5.0        compiler_3.5.1    
    ## [37] pkgconfig_2.0.1    dimRed_0.1.0       htmltools_0.3.6   
    ## [40] nnet_7.3-12        tidyselect_0.2.4   tibble_1.4.2      
    ## [43] prodlim_2018.04.18 DRR_0.0.3          codetools_0.2-15  
    ## [46] RcppRoll_0.3.0     crayon_1.3.4       dplyr_0.7.6       
    ## [49] withr_2.1.2        MASS_7.3-50        recipes_0.1.3     
    ## [52] ModelMetrics_1.2.0 grid_3.5.1         nlme_3.1-137      
    ## [55] gtable_0.2.0       magrittr_1.5       scales_1.0.0      
    ## [58] stringi_1.2.4      reshape2_1.4.3     bindrcpp_0.2.2    
    ## [61] timeDate_3043.102  robustbase_0.93-2  geometry_0.3-6    
    ## [64] pls_2.6-0          lava_1.6.3         iterators_1.0.10  
    ## [67] tools_3.5.1        glue_1.3.0         DEoptimR_1.0-8    
    ## [70] purrr_0.2.5        sfsmisc_1.1-2      abind_1.4-5       
    ## [73] survival_2.42-3    yaml_2.2.0         colorspace_1.3-2  
    ## [76] memoise_1.1.0      knitr_1.20         bindr_0.1.1
