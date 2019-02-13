---
title: "`trained_mods_rf_2`"
author: "Benny Salo"
date: "2019-02-12"
output: github_document
---

Training set is defined in 01_analyzed_data.Rmd

```r
rm(list = ls())
devtools::wd()
devtools::load_all(".")
training_set <- readRDS("not_public/training_set.rds")
```


Train each model (rows) in the grid according to specifications in the grid. 

(Record how long it takes to run.)

```r
start <- Sys.time()

trained_mods_rf_2 <-                    # new list of results
  purrr::pmap(
    .l = list(..1 = rf_grid$rhs,
              ..2 = rf_grid$lhs,
              ..3 = rf_grid$mtry_seq), # updated with new sets of mtry values
    .f = ~ caret::train(
      x         = training_set[..1],
      y         = training_set[[..2]],
      method    = "rf",
      metric    = "ROC",
      trControl = ctrl_fun_training_2,
      tuneGrid  = expand.grid(mtry = ..3)
      )
    )

time_to_run <- Sys.time() - start
time_to_run
```

```
## Time difference of 4.310348 hours
```
Save the results as a named list.


```r
names(trained_mods_rf_2) <- rf_grid$model_name
```



```r
devtools::wd()
saveRDS(trained_mods_rf_2, "not_public/trained_mods_rf_2.rds")
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
```
