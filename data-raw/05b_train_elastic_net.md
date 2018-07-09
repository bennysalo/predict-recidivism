Training elastic net models
================
Benny Salo
2018-07-06

Clear environment. Load previous results from the package.

``` r
rm(list = ls())
devtools::load_all(".")
```

    ## Loading recidivismsl

Training set is defined in 01\_analyzed\_data.Rmd

``` r
devtools::wd()
training_set <- readRDS("not_public/training_set.rds")
```

Get the part of model\_grid that are elastic net models.

``` r
library(dplyr)
```

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

``` r
glmnet_grid <- model_grid %>% filter(
  model_type == "Elastic net")
```

We seem to need to use the formula method of caret::train for glmnet. (Might be because of the factors and ordinal predictors?)

We introduce a new column where we write the formula.

``` r
write_formula <- function(lhs, rhs) {
  as.formula(paste(lhs, "~",  paste(rhs, collapse = " + ")))
}

glmnet_grid$formula <- 
  purrr::map2(.x = glmnet_grid$lhs, 
              .y = glmnet_grid$rhs,
              .f = ~write_formula(.x, .y))
```

Checks. (Could be moved to a test file)

``` r
# All entries in glmnet_grid$formula should be formulas
all(purrr::map(glmnet_grid$formula, class) == "formula")
```

    ## [1] TRUE

``` r
# All formulas should include the corresponding outcome
outcome_in_formula <-
  purrr::map2_lgl(
    .x = as.character(glmnet_grid$formula),
    .y = glmnet_grid$lhs,
    .f = ~ stringr::str_detect(string = .x, pattern = .y)
    )
all(outcome_in_formula)
```

    ## [1] TRUE

``` r
# The number of plusses in the formula should equal 
# the number of predictors - 1

n_plusses <- purrr::map2_int(
  .x = as.character(glmnet_grid$formula),
  .y = glmnet_grid$lhs,
  .f = ~ stringr::str_count(string = .x, pattern = "\\+")
  ) 

n_preds <- purrr::map_dbl(.x = glmnet_grid$rhs,
                      .f = ~ length(.x))
                      

all(n_plusses == n_preds - 1)
```

    ## [1] TRUE

We are also going to want to adjust the tested values for parameter alpha. We create a new column for this. The tested values in the first run will be 0, .2, .4, .6, .8, and 1.

``` r
glmnet_grid$alpha <- vector("list", nrow(glmnet_grid))
glmnet_grid$alpha <- purrr::map(.x = glmnet_grid$alpha, 
                                .f = ~c(0, 0.2, 0.4, 0.6, 0.8, 1))
```

Checks

``` r
stopifnot(length(glmnet_grid$alpha) == 8,
          all(purrr::map(glmnet_grid$alpha, length) == 6),
          all(purrr::map(glmnet_grid$alpha, class) == "numeric"))
```

Train each model (rows) in the grid according to specifications in the grid. Place results in the train\_result columns (previously intitiated).

The values of the following two columns are varied: formula and alpha. Predictors are standarized before training to make the penalty work the same way for all predictors. A sequence between 0 and 3 is tested for tuning parameter lambda.

(Record how long it takes to run.)

``` r
start <- Sys.time()

trained_mods_glmnet <- 
  purrr::map2(
    .x = glmnet_grid$formula,
    .y = glmnet_grid$alpha,
    .f = ~ caret::train(
      form      = .x,
      data      = training_set,
      method    = "glmnet",
      family    = "binomial", # passed to glmnet, define as logistic regression
      standardize = TRUE,     # passed to glmnet, explicitly standardize  
      metric    = "ROC",
      trControl = ctrl_fun_training,
      tuneGrid  = expand.grid(alpha  = .y,
                              lambda = seq(0, 3, by = 0.02))
      )
    )
```

    ## Loading required package: lattice

    ## Loading required package: ggplot2

``` r
time_to_run <- Sys.time() - start
time_to_run
```

    ## Time difference of 1.571827 hours

Name models

``` r
names(trained_mods_glmnet) <- glmnet_grid$model_name
```

``` r
devtools::wd()
saveRDS(trained_mods_glmnet, "not_public/trained_mods_glmnet.rds")
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
    ## [10] DRR_0.0.3          yaml_2.1.19        robustbase_0.93-1 
    ## [13] ipred_0.9-6        pillar_1.2.3       backports_1.1.2   
    ## [16] glue_1.2.0         pROC_1.12.1        digest_0.6.15     
    ## [19] colorspace_1.3-2   recipes_0.1.3      htmltools_0.3.6   
    ## [22] Matrix_1.2-14      plyr_1.8.4         psych_1.8.4       
    ## [25] timeDate_3043.102  pkgconfig_2.0.1    devtools_1.13.6   
    ## [28] CVST_0.2-2         broom_0.4.5        purrr_0.2.5       
    ## [31] scales_0.5.0       gower_0.1.2        lava_1.6.2        
    ## [34] tibble_1.4.2       withr_2.1.2        nnet_7.3-12       
    ## [37] lazyeval_0.2.1     mnormt_1.5-5       survival_2.42-3   
    ## [40] magrittr_1.5       memoise_1.1.0      evaluate_0.10.1   
    ## [43] nlme_3.1-137       MASS_7.3-50        xml2_1.2.0        
    ## [46] dimRed_0.1.0       foreign_0.8-70     class_7.3-14      
    ## [49] ggthemes_3.5.0     tools_3.5.1        stringr_1.3.1     
    ## [52] kernlab_0.9-26     glmnet_2.0-16      munsell_0.5.0     
    ## [55] pls_2.6-0          compiler_3.5.1     RcppRoll_0.3.0    
    ## [58] rlang_0.2.1        grid_3.5.1         iterators_1.0.9   
    ## [61] rmarkdown_1.10     testthat_2.0.0     geometry_0.3-6    
    ## [64] gtable_0.2.0       ModelMetrics_1.1.0 codetools_0.2-15  
    ## [67] abind_1.4-5        roxygen2_6.0.1     reshape2_1.4.3    
    ## [70] R6_2.2.2           lubridate_1.7.4    knitr_1.20        
    ## [73] bindr_0.1.1        commonmark_1.5     rprojroot_1.3-2   
    ## [76] stringi_1.1.7      parallel_3.5.1     Rcpp_0.12.17      
    ## [79] rpart_4.1-13       DEoptimR_1.0-8     tidyselect_0.2.4
