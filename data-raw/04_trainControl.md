Setup of `ctrl_fun_training`
================
Benny Salo
2018-10-07

Control functions `ctrl_fun_training_1` and `ctrl_fun_training_2` are used when training the models. It is passed to `caret::train` and controls, among other things, what the type of cross-validation to use and what discrimination statistics to calculate. Via `index` we also specify what observations will be used in what fold and make training of different models directly comparable.

We create two different control functions:

`ctrl_fun_training_1` - is used for the first search for the best tuning parameters - uses only one repeat of a ten-fold cross-validation - collects ROC and logLoss through the summary function but no calibration figures

`ctrl_fun_training_2` - is used for further narrowing in on the best tuning parameters - uses ten repeats of a ten-fold cross-validation - collects ROC and logLoss and calibration figures through the summary function - is considerably slower (more than ten times)

``` r
devtools::load_all(".")
devtools::wd()
training_set <- readRDS("not_public/training_set.rds")
```

Create ten repeats of ten folds for cross-validation.

``` r
set.seed(120418)
# Earlier versions
ten_by_ten_folds <- 
  caret::createMultiFolds(y = training_set$reoffenceThisTerm, k = 10, times = 10)

one_by_ten_folds <- 
  caret::createMultiFolds(y = training_set$reoffenceThisTerm, k = 10, times = 1)

five_by_twenty_folds <- 
  caret::createMultiFolds(y = training_set$reoffenceThisTerm, k = 5, times = 20)

# Current fold scheme used
four_folds_2_times <- 
  caret::createMultiFolds(y = training_set$reoffenceThisTerm, k = 4, times = 2)

four_folds_25_times <- 
  caret::createMultiFolds(y = training_set$reoffenceThisTerm, k = 4, times = 25)

four_folds_250_times <- 
  caret::createMultiFolds(y = training_set$reoffenceThisTerm, k = 4, times = 250)
```

We write custom made summary functions. We select ROC from caret::twoClassSummary (and disregard sensitivity and specificity, at cutoff 0.5, also provided by that function) and the logLoss from caret::mnLogLoss. This will be used in the first control function.

``` r
my_twoClassSummary_1 <- function(data, lev = NULL, model = NULL) {
  c(
    caret::twoClassSummary(data = data, lev = lev, model = model)["ROC"],
    caret::mnLogLoss(data = data, lev = lev, model = model)
    )
}
```

The following summary function uses code used in the caret functions and adds code to calculate Hosmer-Lemeshow chis-squared using three groups and E/O-values for those groups. This will be used in the third control function.

``` r
my_twoClassSummary_2 <- function (data, lev = NULL, model = NULL)
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
  HL_test <- ResourceSelection::hoslem.test(x = observations_binary,
                                            y = predicted_values,
                                            g = 3)

  make_table_tbl <- function(my_table) {
    my_tbl <- as.data.frame(my_table)
    my_tbl <- tidyr::spread(my_tbl, key = Var2, value = Freq)
    return(my_tbl)
  }
  expected <- make_table_tbl(HL_test$expected)$yhat1
  
  observed_tbl <- make_table_tbl(HL_test$observed)
  observed <- observed_tbl$y1
  totals   <- observed_tbl$y0 + observed_tbl$y1
  # If observed is 0, use 0.5 observations instead
  eo       <- expected / purrr::map_dbl(observed, .f = ~max(.x, 0.5))
  

  # e_o_ratios <- expected$yhat1 / observed$y1

  # expect_ps <- expected$yhat1 / (expected$yhat0 + expected$yhat1)

  # out <- c(ROC = rocAUC,
  #          logLoss = logLoss,
  #          HL_chisq = HL_test$statistic,
  #          EO_1 = e_o_ratios[1], EO_2 = e_o_ratios[2], EO_3 = e_o_ratios[3],
  #          e_p_1 = expect_ps[1], e_p_2 = expect_ps[2], e_p_3 = expect_ps[3],
  #          mean_abs_log_eo = mean(abs(log(e_o_ratios)))
  #          )
  
  
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
           total_3 = totals[3]
           
           )
  
  names(out)[4] <- "HL_chisq"
  return(out)
}
```

``` r
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
           

  return(out)
}
```

Now set up the cross validation schemes using these folds and the summary function

``` r
ctrl_fun_training_1 <- caret::trainControl(
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

``` r
ctrl_fun_training_2 <- caret::trainControl(
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

``` r
ctrl_fun_training_3 <- caret::trainControl(
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

``` r
ctrl_fun_training_4 <- caret::trainControl(
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

``` r
devtools::use_data(ctrl_fun_training_1, overwrite = TRUE)
devtools::use_data(ctrl_fun_training_2, overwrite = TRUE)
devtools::use_data(ctrl_fun_training_3, overwrite = TRUE)
devtools::use_data(ctrl_fun_training_4, overwrite = TRUE)
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
    ## [1] recidivismsl_0.0.0.9000
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] magic_1.5-8        ddalpha_1.3.4      tidyr_0.8.1       
    ##  [4] sfsmisc_1.1-2      splines_3.5.1      foreach_1.4.4     
    ##  [7] prodlim_2018.04.18 assertthat_0.2.0   stats4_3.5.1      
    ## [10] DRR_0.0.3          yaml_2.2.0         robustbase_0.93-2 
    ## [13] ipred_0.9-7        pillar_1.3.0       backports_1.1.2   
    ## [16] lattice_0.20-35    glue_1.3.0         pROC_1.12.1       
    ## [19] digest_0.6.16      colorspace_1.3-2   recipes_0.1.3     
    ## [22] htmltools_0.3.6    Matrix_1.2-14      plyr_1.8.4        
    ## [25] timeDate_3043.102  pkgconfig_2.0.2    devtools_1.13.6   
    ## [28] CVST_0.2-2         broom_0.5.0        caret_6.0-80      
    ## [31] purrr_0.2.5        scales_1.0.0       gower_0.1.2       
    ## [34] lava_1.6.3         furniture_1.7.9    tibble_1.4.2      
    ## [37] ggplot2_3.0.0      withr_2.1.2        nnet_7.3-12       
    ## [40] lazyeval_0.2.1     survival_2.42-3    magrittr_1.5      
    ## [43] crayon_1.3.4       memoise_1.1.0      evaluate_0.11     
    ## [46] nlme_3.1-137       MASS_7.3-50        xml2_1.2.0        
    ## [49] dimRed_0.1.0       class_7.3-14       ggthemes_4.0.1    
    ## [52] tools_3.5.1        data.table_1.11.4  stringr_1.3.1     
    ## [55] kernlab_0.9-27     munsell_0.5.0      bindrcpp_0.2.2    
    ## [58] pls_2.7-0          compiler_3.5.1     RcppRoll_0.3.0    
    ## [61] rlang_0.2.2        grid_3.5.1         iterators_1.0.10  
    ## [64] rmarkdown_1.10     testthat_2.0.0     geometry_0.3-6    
    ## [67] gtable_0.2.0       ModelMetrics_1.2.0 codetools_0.2-15  
    ## [70] abind_1.4-5        roxygen2_6.1.0     reshape2_1.4.3    
    ## [73] R6_2.2.2           lubridate_1.7.4    knitr_1.20        
    ## [76] dplyr_0.7.6        bindr_0.1.1        commonmark_1.5    
    ## [79] rprojroot_1.3-2    stringi_1.2.4      Rcpp_0.12.18      
    ## [82] rpart_4.1-13       DEoptimR_1.0-8     tidyselect_0.2.4
