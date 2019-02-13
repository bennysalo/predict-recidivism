---
title: "Setup of `ctrl_fun_training`"
author: "Benny Salo"
date: "2019-02-11"
output: github_document
---

This script sets up four control functions to be used for the argument `trControl` in `caret::train`. This controls:

   - the number of folds and repeats to use
   - what observations should be included in those folds (via `index`, randomized once and then used consistently to allow comparisons.)
   - what summary statistics to calculate.
   
Control functions `ctrl_fun_training_1`,`_2`, `_3`, and `_4` correspond to the four steps of training (files beginning 05). 

We the control functions have the following properties:

`ctrl_fun_training_1` 
   - is used for a fast first search for the best tuning parameters
   - uses only 2 repeats of 4 folds
   - collects ROC and logLoss through the summary function but no calibration figures
   
`ctrl_fun_training_2` 
   - is used to find the tuning parameters that maximizes discrimination
   - uses 25 repeats of 4 folds
   - uses the same summary function as `ctrl_fun_training_1`

`ctrl_fun_training_3`
   - is used to calculate the calibration statistics
   - uses the same 25 * 4 folds as in `ctrl_fun_training_2`
   - includes calibration statistics in the summary function

`ctrl_fun_training_4` 
  - is used to fine tune the discrimination statistics for models with the chosen tuning parameter
  - uses 250 repeats of 4 folds
  - excludes calibration statistics, calculates a broader array of discrimination statistics
   
The following scripts has three parts:
   - Setting up folds
   - Writing summary functions
   - Combining folds, summary functions and other setting to control functions and saving them for use.
   


```r
devtools::load_all(".")
devtools::wd()
training_set <- readRDS("not_public/training_set.rds")
```

# Folds



```r
set.seed(120418)
# Earlier versions of the fold schemes (now kept for consistency in the seed)
ten_by_ten_folds <- 
  caret::createMultiFolds(y = training_set$reoffenceThisTerm, k = 10, times = 10)

one_by_ten_folds <- 
  caret::createMultiFolds(y = training_set$reoffenceThisTerm, k = 10, times = 1)

five_by_twenty_folds <- 
  caret::createMultiFolds(y = training_set$reoffenceThisTerm, k = 5, times = 20)

# The actual fold scheme used
four_folds_2_times <- 
  caret::createMultiFolds(y = training_set$reoffenceThisTerm, k = 4, times = 2)

four_folds_25_times <- 
  caret::createMultiFolds(y = training_set$reoffenceThisTerm, k = 4, times = 25)

four_folds_250_times <- 
  caret::createMultiFolds(y = training_set$reoffenceThisTerm, k = 4, times = 250)
```


# Summary functions: `my_twoClassSummary`

In the first summary function we simply combine output from two summary functions that are part of `caret`. Used in `ctrl_fun_training_1` and `_2`



```r
my_twoClassSummary_1 <- function(data, lev = NULL, model = NULL) {
  c(
    caret::twoClassSummary(data = data, lev = lev, model = model)["ROC"],
    caret::mnLogLoss(data = data, lev = lev, model = model)
    )
}
```

The following summary function uses code used in the `caret` functions and adds code to calculate Hosmer-Lemeshow chis-squared using three groups and E/O-values for those groups. This will be used in `ctrl_fun_training_3`



```r
my_twoClassSummary_2 <- function (data, lev = NULL, model = NULL)
{
  ##### Code taken from `caret::twoClassSummary`
  lvls <- levels(data$obs)
  if(length(lvls) > 2)
    stop(paste("Your outcome has", length(lvls),
               "levels. The twoClassSummary() function isn't appropriate."))
  # requireNamespaceQuietStop('ModelMetrics')
  if (!all(levels(data[, "pred"]) == lvls))
    stop("levels of observed and predicted data do not match")
  
  ##### Customized code
  observations_binary <- ifelse(data$obs == lev[2], 1, 0)
  predicted_values    <- data[, lvls[2]]
  
  rocAUC  <- ModelMetrics::auc(actual    = observations_binary,
                               predicted = predicted_values)
                               
  logLoss <- ModelMetrics::logLoss(actual    = observations_binary,
                                   predicted = predicted_values)
  
  HL_test <- ResourceSelection::hoslem.test(x = observations_binary,
                                            y = predicted_values,
                                            g = 3)

  make_table_tbl <- 
    function(my_table) {
      my_tbl <- as.data.frame(my_table)
      my_tbl <- tidyr::spread(my_tbl, key = Var2, value = Freq)
      
      my_tbl
    }
  
  expected     <- make_table_tbl(HL_test$expected)$yhat1
  
  observed_tbl <- make_table_tbl(HL_test$observed)
  observed     <- observed_tbl$y1
  totals       <- observed_tbl$y0 + observed_tbl$y1
  
  # If observed is 0, use 0.5 observations instead
  eo  <- expected / purrr::map_dbl(observed, .f = ~max(.x, 0.5))
  
  out <- c(logLoss = logLoss,
           ROC = rocAUC,
           d_AUC = calc_d_from_AUC(rocAUC),
           HL_chisq = HL_test$statistic,
           mean_abs_log_eo = mean(abs(log(eo))),
           eo_1 = eo[1], 
           eo_2 = eo[2],
           eo_3 = eo[3],
           expected_1 = expected[1], 
           expected_2 = expected[2], 
           expected_3 = expected[3],
           observed_1 = observed[1],
           observed_2 = observed[2],
           observed_3 = observed[3],
           total_1 = totals[1],
           total_2 = totals[2],
           total_3 = totals[3])
  
  names(out)[4] <- "HL_chisq"
  
  out
}
```

The third summary function also uses code from `caret`. It is customized to calculate a set of discrimination statistics and E/O ratio. Used in `ctrl_fun_training_4`.



```r
my_twoClassSummary_3 <- function (data, lev = NULL, model = NULL)
{
  lvls <- levels(data$obs)
  if(length(lvls) > 2)
    stop(paste("Your outcome has", length(lvls),
               "levels. The twoClassSummary() function isn't appropriate."))
  # requireNamespaceQuietStop('ModelMetrics')
  if (!all(levels(data[, "pred"]) == lvls))
    stop("levels of observed and predicted data do not match")
  
  # Customized code
  observations_binary <- ifelse(data$obs == lev[2], 1, 0)
  predicted_values    <- data[, lvls[2]]
  
  rocAUC  <- ModelMetrics::auc(actual    = observations_binary,
                               predicted = predicted_values)
                               
  logLoss <- ModelMetrics::logLoss(actual    = observations_binary,
                                   predicted = predicted_values)
  
  null_lglss <- null_logLoss(observed  = observations_binary)
  
  McF_R2  <- 1 - logLoss / null_lglss
  
  E_O_ratio <- sum(predicted_values) / sum(observations_binary)
  
  out <- c(logLoss = logLoss,
           ROC = rocAUC,
           d_AUC = calc_d_from_AUC(rocAUC),
           McF_R2 = McF_R2,
           E_O_ratio = E_O_ratio)
  
  out
}
```

# `ctrl_fun_training`

Now set up the cross validation schemes using these folds and the summary function



```r
ctrl_fun_training_1 <- 
  caret::trainControl(
    method = "repeatedcv",
    number = 4,
    repeats = 2,
    summaryFunction = my_twoClassSummary_1,
    classProbs = TRUE,
    verboseIter = FALSE,
    savePredictions = "final",
    four_folds_2_times,
    returnData = FALSE,
    returnResamp = "all"
    )
```



```r
ctrl_fun_training_2 <- 
  caret::trainControl(
    method = "repeatedcv",
    number = 4,
    repeats = 25,
    summaryFunction = my_twoClassSummary_1,
    classProbs = TRUE,
    verboseIter = FALSE,
    savePredictions = "final",
    index = four_folds_25_times,
    returnData = FALSE
    )
```



```r
ctrl_fun_training_3 <- 
  caret::trainControl(
    method = "repeatedcv",
    number = 4,
    repeats = 25,
    summaryFunction = my_twoClassSummary_2,
    classProbs = TRUE,
    verboseIter = FALSE,
    savePredictions = "final",
    index = four_folds_25_times,
    returnData = FALSE
    )
```


```r
ctrl_fun_training_4 <- 
  caret::trainControl(
    method = "repeatedcv",
    number = 4,
    repeats = 250,
    summaryFunction = my_twoClassSummary_3,
    classProbs = TRUE,
    verboseIter = FALSE,
    savePredictions = "final",
    index = four_folds_250_times,
    returnData = FALSE
  )
```

Save control functions

```r
usethis::use_data(ctrl_fun_training_1, overwrite = TRUE)
```

```
## <U+2714> Saving 'ctrl_fun_training_1' to 'data/ctrl_fun_training_1.rda'
```

```r
usethis::use_data(ctrl_fun_training_2, overwrite = TRUE)
```

```
## <U+2714> Saving 'ctrl_fun_training_2' to 'data/ctrl_fun_training_2.rda'
```

```r
usethis::use_data(ctrl_fun_training_3, overwrite = TRUE)
```

```
## <U+2714> Saving 'ctrl_fun_training_3' to 'data/ctrl_fun_training_3.rda'
```

```r
usethis::use_data(ctrl_fun_training_4, overwrite = TRUE)
```

```
## <U+2714> Saving 'ctrl_fun_training_4' to 'data/ctrl_fun_training_4.rda'
```


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
## [1] recidivismsl_0.0.0.9000 caret_6.0-81            ggplot2_3.1.0          
## [4] lattice_0.20-38         bindrcpp_0.2.2          dplyr_0.7.8            
## [7] magrittr_1.5            testthat_2.0.1         
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
## [21] cli_1.0.1               desc_1.2.0             
## [23] scales_1.0.0            readr_1.3.1            
## [25] callr_3.1.1             stringr_1.3.1          
## [27] digest_0.6.18           rmarkdown_1.11         
## [29] base64enc_0.1-3         pkgconfig_2.0.2        
## [31] htmltools_0.3.6         sessioninfo_1.1.1      
## [33] highr_0.7               rlang_0.3.1            
## [35] ggthemes_4.0.1          rstudioapi_0.9.0       
## [37] bindr_0.1.1             generics_0.0.2         
## [39] jsonlite_1.6            ModelMetrics_1.2.2     
## [41] Matrix_1.2-15           Rcpp_1.0.0             
## [43] munsell_0.5.0           fansi_0.4.0            
## [45] furniture_1.8.7         stringi_1.2.4          
## [47] pROC_1.13.0             yaml_2.2.0             
## [49] MASS_7.3-51.1           pkgbuild_1.0.2         
## [51] plyr_1.8.4              recipes_0.1.4          
## [53] grid_3.5.2              forcats_0.3.0          
## [55] crayon_1.3.4            splines_3.5.2          
## [57] hms_0.4.2               knitr_1.21             
## [59] ps_1.3.0                pillar_1.3.1           
## [61] reshape2_1.4.3          codetools_0.2-15       
## [63] clisymbols_1.2.0        stats4_3.5.2           
## [65] pkgload_1.0.2           glue_1.3.0             
## [67] evaluate_0.12           data.table_1.12.0      
## [69] remotes_2.0.2           foreach_1.4.4          
## [71] gtable_0.2.0            purrr_0.2.5            
## [73] tidyr_0.8.2             assertthat_0.2.0       
## [75] xfun_0.4                gower_0.1.2            
## [77] prodlim_2018.04.18      class_7.3-14           
## [79] survival_2.43-3         timeDate_3043.102      
## [81] tibble_2.0.1            iterators_1.0.10       
## [83] memoise_1.1.0           lava_1.6.4             
## [85] ipred_0.9-8
```
