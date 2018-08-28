Setup of `ctrl_fun_training`
================
Benny Salo
2018-08-28

Control functions `ctrl_fun_training_1` and `ctrl_fun_training_2` are used when training the models. It is passed to `caret::train` and controls, among other things, what the type of cross-validation to use and what discrimination statistics to calculate. Via `index` we also specify what observations will be used in what fold and make training of different models directly comparable.

We create two different control functions:

`ctrl_fun_training_1` - is used for the first search for the best tuning parameters - uses only one repeat of a ten-fold cross-validation - collects ROC and logLoss through the summary function but no calibration figures

`ctrl_fun_training_2` - is used for further narrowing in on the best tuning parameters - uses ten repeats of a ten-fold cross-validation - collects ROC and logLoss and calibration figures through the summary function - is considerably slower (more than ten times)

``` r
devtools::wd()
training_set <- readRDS("not_public/training_set.rds")
```

Create ten repeats of ten folds for cross-validation.

``` r
set.seed(120418)
ten_by_ten_folds <- 
  caret::createMultiFolds(y = training_set$reoffenceThisTerm, k = 10, times = 10)

one_by_ten_folds <- 
  caret::createMultiFolds(y = training_set$reoffenceThisTerm, k = 10, times = 1)
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

The folowing summary function used code used in the caret functions and adds code to calculate Hosmer-Lemeshow chis-squared using three groups and E/O-values for those groups. This will be used in the second control function.
=================================================================================================================================================================================================================================

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

  expected <- make_table_tbl(HL_test$expected)
  observed <- make_table_tbl(HL_test$observed)

  e_o_ratios <- expected$yhat1 / observed$y1

  expect_ps <- expected$yhat1 / (expected$yhat0 + expected$yhat1)

  out <- c(ROC = rocAUC,
           logLoss = logLoss,
           HL_chisq = HL_test$statistic,
           EO_1 = e_o_ratios[1], EO_2 = e_o_ratios[2], EO_3 = e_o_ratios[3],
           e_p_1 = expect_ps[1], e_p_2 = expect_ps[2], e_p_3 = expect_ps[3],
           abs_log_eo = exp(sum(abs(log(e_o_ratios)))/3))
  
  names(out)[3] <- "HL_chisq"
  return(out)
}
```

Now set up the cross validation schemes using these folds and the summary function

``` r
ctrl_fun_training_1 <- caret::trainControl(
  method = "repeatedcv",
  number = 10,
  repeats = 1,
  summaryFunction = my_twoClassSummary_1,
  classProbs = TRUE,
  verboseIter = FALSE,
  savePredictions = "final",
  index = one_by_ten_folds,
  returnData = FALSE
  )
```

``` r
ctrl_fun_training_2 <- caret::trainControl(
  method = "repeatedcv",
  number = 10,
  repeats = 10,
  summaryFunction = my_twoClassSummary_2,
  classProbs = TRUE,
  verboseIter = FALSE,
  savePredictions = "final",
  index = ten_by_ten_folds,
  returnData = FALSE
  )
```

Save control functions

``` r
devtools::use_data(ctrl_fun_training_1, overwrite = TRUE)
devtools::use_data(ctrl_fun_training_2, overwrite = TRUE)
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
    ##  [1] Rcpp_0.12.18       lubridate_1.7.4    lattice_0.20-35   
    ##  [4] tidyr_0.8.1        class_7.3-14       assertthat_0.2.0  
    ##  [7] rprojroot_1.3-2    digest_0.6.15      ipred_0.9-7       
    ## [10] foreach_1.4.4      R6_2.2.2           plyr_1.8.4        
    ## [13] backports_1.1.2    magic_1.5-8        stats4_3.5.1      
    ## [16] evaluate_0.11      ggplot2_3.0.0      pillar_1.3.0      
    ## [19] rlang_0.2.1        lazyeval_0.2.1     caret_6.0-80      
    ## [22] data.table_1.11.4  kernlab_0.9-27     rpart_4.1-13      
    ## [25] Matrix_1.2-14      rmarkdown_1.10     devtools_1.13.6   
    ## [28] splines_3.5.1      CVST_0.2-2         ddalpha_1.3.4     
    ## [31] gower_0.1.2        stringr_1.3.1      munsell_0.5.0     
    ## [34] broom_0.5.0        compiler_3.5.1     pkgconfig_2.0.1   
    ## [37] dimRed_0.1.0       htmltools_0.3.6    nnet_7.3-12       
    ## [40] tidyselect_0.2.4   tibble_1.4.2       prodlim_2018.04.18
    ## [43] DRR_0.0.3          codetools_0.2-15   RcppRoll_0.3.0    
    ## [46] crayon_1.3.4       dplyr_0.7.6        withr_2.1.2       
    ## [49] MASS_7.3-50        recipes_0.1.3      ModelMetrics_1.2.0
    ## [52] grid_3.5.1         nlme_3.1-137       gtable_0.2.0      
    ## [55] magrittr_1.5       scales_1.0.0       stringi_1.2.4     
    ## [58] reshape2_1.4.3     bindrcpp_0.2.2     timeDate_3043.102 
    ## [61] robustbase_0.93-2  geometry_0.3-6     pls_2.6-0         
    ## [64] lava_1.6.3         iterators_1.0.10   tools_3.5.1       
    ## [67] glue_1.3.0         DEoptimR_1.0-8     purrr_0.2.5       
    ## [70] sfsmisc_1.1-2      abind_1.4-5        survival_2.42-3   
    ## [73] yaml_2.2.0         colorspace_1.3-2   memoise_1.1.0     
    ## [76] knitr_1.20         bindr_0.1.1
