Predicting recidivism in test set based on RITA-dimensions
================
Benny Salo
2018-07-19

Here we create /data/test\_set\_predictions\_dims.rda. It will contain predictions for the individuals in the test set produced by logistic regression models with, in turn, on of the RITA-dimensions as single predictor. With a single predictor there is no dicernable benefit from using elastic net regression or random forest models.

### Setup

``` r
rm(list = ls())
library(dplyr)
devtools::load_all(".")
```

### Load datasets

``` r
devtools::wd()
training_set <- readRDS("not_public/training_set.rds")
test_set <- readRDS("not_public/test_set.rds")
```

Create `model_grid_dim`
-----------------------

Define the levels of outcomes, predictors, and model\_type. Convert these vectors into factors with levels in the preferred order.

``` r
outcomes   <- c("reoffenceThisTerm", "newO_violent")
outcomes   <- factor(outcomes, levels = outcomes)

predictor <- c("sum_economy_problems", "sum_alcohol_problems",
                "sum_resistance_change", "sum_drug_related_probl",
                "sum_aggressiveness", "sum_employment_probl")
predictor <- factor(predictor, levels = predictor)

model_grid_dim           <- expand.grid(outcomes, predictor, 
                                    stringsAsFactors = FALSE)
colnames(model_grid_dim) <- c("lhs", "rhs")
```

Write compact model names

``` r
model_grid_dim$outc_ <- vector("character", length = nrow(model_grid_dim))

model_grid_dim$outc_[model_grid_dim$lhs == "reoffenceThisTerm"] <-
  "gen_"
model_grid_dim$outc_[model_grid_dim$lhs == "newO_violent"] <-
  "vio_"

model_grid_dim$pred <- vector("character", length = nrow(model_grid_dim))
model_grid_dim$pred[model_grid_dim$rhs == "sum_economy_problems"] <-
  "economy"
model_grid_dim$pred[model_grid_dim$rhs == "sum_alcohol_problems"] <-
  "alcohol"
model_grid_dim$pred[model_grid_dim$rhs == "sum_resistance_change"] <-
  "change"
model_grid_dim$pred[model_grid_dim$rhs == "sum_drug_related_probl"] <-
  "drugs"
model_grid_dim$pred[model_grid_dim$rhs == "sum_aggressiveness"] <-
  "aggression"
model_grid_dim$pred[model_grid_dim$rhs == "sum_employment_probl"] <-
  "employment"

model_grid_dim <- model_grid_dim %>% 
  mutate(model_name = paste0(outc_, pred)) %>% 
select(-outc_, -pred)

model_grid_dim
```

    ##                  lhs                    rhs     model_name
    ## 1  reoffenceThisTerm   sum_economy_problems    gen_economy
    ## 2       newO_violent   sum_economy_problems    vio_economy
    ## 3  reoffenceThisTerm   sum_alcohol_problems    gen_alcohol
    ## 4       newO_violent   sum_alcohol_problems    vio_alcohol
    ## 5  reoffenceThisTerm  sum_resistance_change     gen_change
    ## 6       newO_violent  sum_resistance_change     vio_change
    ## 7  reoffenceThisTerm sum_drug_related_probl      gen_drugs
    ## 8       newO_violent sum_drug_related_probl      vio_drugs
    ## 9  reoffenceThisTerm     sum_aggressiveness gen_aggression
    ## 10      newO_violent     sum_aggressiveness vio_aggression
    ## 11 reoffenceThisTerm   sum_employment_probl gen_employment
    ## 12      newO_violent   sum_employment_probl vio_employment

``` r
model_grid_dim$formula <- 
  purrr::map2(.x = model_grid_dim$lhs, 
              .y = model_grid_dim$rhs,
              .f = ~write_formula(.x, .y))
```

Train models
============

Train each model (rows) in the grid according to specifications in the grid. Save the results as a named list.

(Record how long it takes to run.)

``` r
start <- Sys.time()

trained_mods_dim <- purrr::map(
  .x = model_grid_dim$formula,
  .f = ~ glm(formula = .x, data = training_set, family = binomial)
  )

time_to_run <- Sys.time() - start
time_to_run
```

    ## Time difference of 0.104003 secs

``` r
names(trained_mods_dim) <- model_grid_dim$model_name
```

``` r
# Apply this function to all models in the list
test_set_predictions_dim <- 
  purrr::map_df(.x = trained_mods_dim, 
                .f = ~ predict.glm(.x, newdata = test_set, type = "response"))

# Add the observed outcomes
test_set_predictions_dim <- 
  test_set %>% 
  select(reoffenceThisTerm, newO_violent) %>% 
  bind_cols(test_set_predictions_dim)
```

Save and make available in /data

``` r
devtools::use_data(test_set_predictions_dim, overwrite = TRUE)
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
    ## other attached packages:
    ## [1] bindrcpp_0.2.2          recidivismsl_0.0.0.9000 dplyr_0.7.6            
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] magic_1.5-8        ddalpha_1.3.4      tidyr_0.8.1       
    ##  [4] sfsmisc_1.1-2      splines_3.5.1      foreach_1.4.4     
    ##  [7] prodlim_2018.04.18 assertthat_0.2.0   stats4_3.5.1      
    ## [10] DRR_0.0.3          yaml_2.1.19        robustbase_0.93-1 
    ## [13] ipred_0.9-6        pillar_1.2.3       backports_1.1.2   
    ## [16] lattice_0.20-35    glue_1.2.0         pROC_1.12.1       
    ## [19] digest_0.6.15      colorspace_1.3-2   recipes_0.1.3     
    ## [22] htmltools_0.3.6    Matrix_1.2-14      plyr_1.8.4        
    ## [25] psych_1.8.4        timeDate_3043.102  pkgconfig_2.0.1   
    ## [28] devtools_1.13.6    CVST_0.2-2         broom_0.4.5       
    ## [31] caret_6.0-80       purrr_0.2.5        scales_0.5.0      
    ## [34] gower_0.1.2        lava_1.6.2         tibble_1.4.2      
    ## [37] ggplot2_3.0.0      withr_2.1.2        nnet_7.3-12       
    ## [40] lazyeval_0.2.1     mnormt_1.5-5       survival_2.42-3   
    ## [43] magrittr_1.5       memoise_1.1.0      evaluate_0.10.1   
    ## [46] nlme_3.1-137       MASS_7.3-50        xml2_1.2.0        
    ## [49] dimRed_0.1.0       foreign_0.8-70     class_7.3-14      
    ## [52] ggthemes_3.5.0     tools_3.5.1        stringr_1.3.1     
    ## [55] kernlab_0.9-26     munsell_0.5.0      pls_2.6-0         
    ## [58] compiler_3.5.1     RcppRoll_0.3.0     rlang_0.2.1       
    ## [61] grid_3.5.1         iterators_1.0.9    rmarkdown_1.10    
    ## [64] testthat_2.0.0     geometry_0.3-6     gtable_0.2.0      
    ## [67] ModelMetrics_1.1.0 codetools_0.2-15   abind_1.4-5       
    ## [70] roxygen2_6.0.1     reshape2_1.4.3     R6_2.2.2          
    ## [73] lubridate_1.7.4    knitr_1.20         bindr_0.1.1       
    ## [76] commonmark_1.5     rprojroot_1.3-2    stringi_1.1.7     
    ## [79] parallel_3.5.1     Rcpp_0.12.17       rpart_4.1-13      
    ## [82] DEoptimR_1.0-8     tidyselect_0.2.4
