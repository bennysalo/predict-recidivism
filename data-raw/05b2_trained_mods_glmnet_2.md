---
title: "Training second round of elastic net models"
author: "Benny Salo"
date: "2019-02-14"
output: github_document
---

Clear environment. Load previous results from the package.

```r
rm(list = ls())
devtools::load_all(".")
```

```
## Loading recidivismsl
```

Training set is defined in 01_analyzed_data.Rmd

```r
devtools::wd()
training_set <- readRDS("not_public/training_set.rds")
```


Train each model (rows) in the grid according to specifications in the grid. 

The values of the following two columns are varied: formula and alpha.
Predictors are standarized before training to make the penalty work the same way for all predictors. A sequence between 0 and 3 is tested for tuning parameter lambda.

The run is identical to the first run except for the updated alpha values. 



```r
glmnet_grid <- full_join(glmnet_grid, qual_tunes_glmnet, by = "model_name")
```


(Record how long it takes to run.)

```r
start <- Sys.time()

trained_mods_glmnet_2 <-      # new name for new set of results
  purrr::map2(
    .x = glmnet_grid$formula,
    .y = glmnet_grid$tuning_params,  # updated
    .f = ~ caret::train(
      form      = .x,
      data      = training_set,
      method    = "glmnet",
      family    = "binomial", # passed to glmnet, define as logistic regression
      standardize = TRUE,     # passed to glmnet, explicitly standardize  
      metric    = "logLoss",
      trControl = ctrl_fun_training_2,
      tuneGrid  = as.data.frame(.y) # can't be class tibble
      )
    )
    

    
time_to_run <- Sys.time() - start
time_to_run
```

```
## Time difference of 55.25585 mins
```
Name models


```r
names(trained_mods_glmnet_2) <- glmnet_grid$model_name
```



```r
devtools::wd()
saveRDS(trained_mods_glmnet_2, "not_public/trained_mods_glmnet_2.rds")
```

### Print sessionInfo


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


