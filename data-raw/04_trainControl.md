Setup of `ctrl_fun_training`
================
Benny Salo
2018-07-06

`ctrl_fun_training` is used when training the models. It is passed to `caret::train` and controls, among other things, what the type of cross-validation to use and what discrimination statistics to calculate. Via `index` we also specify what observations will be used in what fold and make training of different models directly comparable.

``` r
devtools::wd()
training_set <- readRDS("not_public/training_set.rds")
```

Create ten repeats of ten folds for cross-validation.

``` r
set.seed(120418)
ten_by_ten_folds <- 
  caret::createMultiFolds(y = training_set$reoffenceThisTerm, k = 10, times = 10)
```

Now set up the cross validation schemes using these folds.

``` r
ctrl_fun_training <- caret::trainControl(
  method = "repeatedcv",
  number = 10,
  repeats = 10,
  summaryFunction = caret::twoClassSummary,
  classProbs = TRUE,
  verboseIter = FALSE,
  savePredictions = "final",
  index = ten_by_ten_folds,
  returnData = FALSE
  )
```

``` r
devtools::use_data(ctrl_fun_training, overwrite = TRUE)
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
    ## loaded via a namespace (and not attached):
    ##  [1] Rcpp_0.12.17       lubridate_1.7.4    lattice_0.20-35   
    ##  [4] tidyr_0.8.1        class_7.3-14       assertthat_0.2.0  
    ##  [7] rprojroot_1.3-2    digest_0.6.15      ipred_0.9-6       
    ## [10] psych_1.8.4        foreach_1.4.4      R6_2.2.2          
    ## [13] plyr_1.8.4         backports_1.1.2    magic_1.5-8       
    ## [16] stats4_3.5.1       evaluate_0.10.1    ggplot2_3.0.0     
    ## [19] pillar_1.2.3       rlang_0.2.1        lazyeval_0.2.1    
    ## [22] caret_6.0-80       kernlab_0.9-26     rpart_4.1-13      
    ## [25] Matrix_1.2-14      rmarkdown_1.10     devtools_1.13.6   
    ## [28] splines_3.5.1      CVST_0.2-2         ddalpha_1.3.4     
    ## [31] gower_0.1.2        stringr_1.3.1      foreign_0.8-70    
    ## [34] munsell_0.5.0      broom_0.4.5        compiler_3.5.1    
    ## [37] pkgconfig_2.0.1    mnormt_1.5-5       dimRed_0.1.0      
    ## [40] htmltools_0.3.6    nnet_7.3-12        tidyselect_0.2.4  
    ## [43] prodlim_2018.04.18 tibble_1.4.2       DRR_0.0.3         
    ## [46] codetools_0.2-15   RcppRoll_0.3.0     dplyr_0.7.6       
    ## [49] withr_2.1.2        MASS_7.3-50        recipes_0.1.3     
    ## [52] ModelMetrics_1.1.0 grid_3.5.1         nlme_3.1-137      
    ## [55] gtable_0.2.0       magrittr_1.5       scales_0.5.0      
    ## [58] stringi_1.1.7      reshape2_1.4.3     bindrcpp_0.2.2    
    ## [61] timeDate_3043.102  robustbase_0.93-1  geometry_0.3-6    
    ## [64] pls_2.6-0          lava_1.6.2         iterators_1.0.9   
    ## [67] tools_3.5.1        glue_1.2.0         DEoptimR_1.0-8    
    ## [70] purrr_0.2.5        sfsmisc_1.1-2      abind_1.4-5       
    ## [73] parallel_3.5.1     survival_2.42-3    yaml_2.1.19       
    ## [76] colorspace_1.3-2   memoise_1.1.0      knitr_1.20        
    ## [79] bindr_0.1.1
