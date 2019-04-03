Incremental validity in Cohen's d
================
Benny Salo
2019-04-02

In this vignette we show how we used the results from the 1000 resamples in the training set to compare the overall performance of a two competing models. The comparisons are of two types: - for the models with the same predictor set but using different algorithms (elastic net vs. random forest) - for models using elastic net between models with an incremetally larger set of predictors. (These results are presented in Table 2.)

We use McFadden's pseudo R-squared as a measure of overall performance but transform these values to d before vomparing models.

``` r
library(recidivismsl)
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
```

Function
--------

We will use this function to compare an incremental model to a simpler model. It will: - extract the columns in the `values`element of `model_perfs_training_set1000` that refer to the McFadden pseudo R2 values for the incremental (`incr_mod`) and the simpler models (`simpler_mod`). (It will do this via using column names that are specified later.) - transform these R2 values to d. (See `?calc_d_from_R2()`) - calculate the median, percetiles 2.5 and 97.5, and the proportion of cases when the difference is 0 or negative (interpreted as a one-sided p\_value)

``` r
R2_difference_in_d <- function(incr_mod, simpler_mod, 
                               resamples = model_perfs_training_set1000) {
  
  data_frame(R2_b = resamples$values[[incr_mod]],
             R2_w = resamples$values[[simpler_mod]]) %>% 
    mutate(incr_d = calc_d_from_R2(R2_b),
           simpler_d  = calc_d_from_R2(R2_w),
           diff_d     = incr_d - simpler_d) %>%
    summarise(median_diff_d = median(diff_d),
              LL            = quantile(diff_d, 0.025),
              UL            = quantile(diff_d, 0.975),
              p_one_sided   = mean(diff_d <= 0))
}
```

Comparing algorithm types
-------------------------

Create a data frame with pairs of models to compare: corresponding elastic net (glmnet) and random forest (rf) models.

``` r
compared_models <- 
  model_grid %>% 
  filter(analysis == "Main analyses" & model_type != "Logistic regression") %>% 
  select(model_name) %>% 
  purrr::as_vector()


model_pairs_algo <- 
  data_frame(glmnet_mod = stringr::str_subset(compared_models, "glmnet"),
             rf_mod     = stringr::str_subset(compared_models, "rf")) %>%
  mutate(glmnet_mod = paste0(glmnet_mod, "~McF_R2"),
         rf_mod     = paste0(rf_mod, "~McF_R2")) 
#> Warning: `data_frame()` is deprecated, use `tibble()`.
#> This warning is displayed once per session.
```

Make the comparisons.

``` r
purrr::map2_df(.x = model_pairs_algo$glmnet_mod, 
               .y = model_pairs_algo$rf_mod, 
               .f = ~R2_difference_in_d(.x, .y)) %>% 
  # Bind in columns with compared models
  bind_cols(model_pairs_algo, .) %>% 
  # Clean up model names
  mutate_at(c("glmnet_mod", "rf_mod"), ~stringr::str_remove(., "~McF_R2"))
#> # A tibble: 8 x 6
#>   glmnet_mod      rf_mod      median_diff_d      LL    UL p_one_sided
#>   <chr>           <chr>               <dbl>   <dbl> <dbl>       <dbl>
#> 1 gen_rita_glmnet gen_rita_rf      -0.0327  -0.131  0.102       0.729
#> 2 vio_rita_glmnet vio_rita_rf       0.113   -0.0394 1.58        0.082
#> 3 gen_stat_glmnet gen_stat_rf      -0.0170  -0.161  0.224       0.575
#> 4 vio_stat_glmnet vio_stat_rf       0.0317  -0.233  2.07        0.462
#> 5 gen_bgnn_glmnet gen_bgnn_rf       0.00224 -0.0985 0.125       0.488
#> 6 vio_bgnn_glmnet vio_bgnn_rf       0.0109  -0.116  0.140       0.441
#> 7 gen_allp_glmnet gen_allp_rf       0.0753  -0.0336 0.196       0.083
#> 8 vio_allp_glmnet vio_allp_rf       0.0130  -0.129  0.171       0.437
```

Comparing predictor sets
------------------------

Create a data frame with pairs of models to compare: models with same outcome and incremental predictor sets.

``` r
incremental_mod <- c("gen_stat_glmnet",
                     "gen_bgnn_glmnet",
                     "gen_allp_glmnet",
                     
                     "vio_stat_glmnet",
                     "vio_bgnn_glmnet",
                     "vio_allp_glmnet")

baseline_mod    <- c("gen_rita_glmnet",
                     "gen_stat_glmnet",
                     "gen_bgnn_glmnet",
                     
                     "vio_rita_glmnet",
                     "vio_stat_glmnet",
                     "vio_bgnn_glmnet")
```

Make the comparisons.

``` r
model_pairs_preds <- 
  data_frame(incr = incremental_mod,
             base = baseline_mod) %>% 
      mutate(incr = paste0(incr, "~McF_R2"),
             base = paste0(base, "~McF_R2")) 

purrr::map2_df(.x = model_pairs_preds$incr, 
               .y = model_pairs_preds$base, 
               .f = ~R2_difference_in_d(.x, .y)) %>% 
  bind_cols(model_pairs_preds, .) %>% 
  mutate_at(c("incr", "base"), ~stringr::str_remove(., "~McF_R2"))
#> # A tibble: 6 x 6
#>   incr            base            median_diff_d       LL    UL p_one_sided
#>   <chr>           <chr>                   <dbl>    <dbl> <dbl>       <dbl>
#> 1 gen_stat_glmnet gen_rita_glmnet        0.176  -0.0307  0.392       0.052
#> 2 gen_bgnn_glmnet gen_stat_glmnet        0.0562 -0.0687  0.156       0.16 
#> 3 gen_allp_glmnet gen_bgnn_glmnet        0.212   0.123   0.288       0    
#> 4 vio_stat_glmnet vio_rita_glmnet        0.0586 -0.167   0.327       0.293
#> 5 vio_bgnn_glmnet vio_stat_glmnet        0.144  -0.0276  0.298       0.048
#> 6 vio_allp_glmnet vio_bgnn_glmnet        0.0598 -0.00784 0.104       0.038
```
