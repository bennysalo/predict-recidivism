Checking first round of glmnet models
================
Benny Salo
2018-07-09

Here we diagnose the results from trained elastic net models. The general pattern is that prediction of violent recidivism is benefited by ridge regression type penalties (alpha = 0) while prediction of general recidivism benefits from more lasso type penalties (alpha = 1).

We update our search by including the best value in this run and values not yet tested that are between the best tested value and adjacent values. In all except the first model this is a search in only one direction since the best tested values are most often either 0 or 1.

Setup
-----

``` r
devtools::load_all(".")
library(dplyr)
```

``` r
devtools::wd()
trained_mods_glmnet <- readRDS("not_public/trained_mods_glmnet.rds")
```

Initiate a list to store updated alpha values

``` r
glmnet_grid$alpha2 <- vector("list", length = nrow(glmnet_grid))
```

### Functions

Function for finding best performance per alpha value

``` r
find_best_per_alpha <- function(model_nr) {
  trained_mods_glmnet[[model_nr]]$results %>%
    group_by(alpha) %>%
    filter(ROC == max(ROC)) %>%
    select(alpha, lambda, ROC, ROCSD) %>% 
    mutate(d = calc_d_from_AUC(ROC))
}
```

Function for printing several summaries

``` r
diagnose_trained_models <- function(model_nr) {
  print(paste0("Outcome: ", glmnet_grid$outcome[model_nr], 
              ". Predictors: ", glmnet_grid$predictors[model_nr], "."))
  print("Best tuning values:")
  print(trained_mods_glmnet[[model_nr]]$bestTune)
  print("Per alpha value:")
  per_alpha_table <- find_best_per_alpha(model_nr)
  print(per_alpha_table)
  print(paste("Max - min d:", round(max(per_alpha_table$d) - 
                                      min(per_alpha_table$d), 3)))
  plot(trained_mods_glmnet[[model_nr]])
}
```

Analyses
--------

### Model 1

``` r
diagnose_trained_models(1)
```

    ## [1] "Outcome: General recidivism. Predictors: Rita."
    ## [1] "Best tuning values:"
    ##     alpha lambda
    ## 159   0.2   0.14
    ## [1] "Per alpha value:"
    ## # A tibble: 6 x 5
    ## # Groups:   alpha [6]
    ##   alpha lambda   ROC  ROCSD     d
    ##   <dbl>  <dbl> <dbl>  <dbl> <dbl>
    ## 1   0     0.64 0.754 0.0477 0.971
    ## 2   0.2   0.14 0.757 0.0465 0.984
    ## 3   0.4   0.06 0.756 0.0465 0.980
    ## 4   0.6   0.04 0.756 0.0464 0.979
    ## 5   0.8   0.04 0.754 0.0457 0.972
    ## 6   1     0.02 0.754 0.0468 0.971
    ## [1] "Max - min d: 0.013"

![](05b2_train_elastic_net_diagnose_1_files/figure-markdown_github/unnamed-chunk-6-1.png)

``` r
glmnet_grid$alpha2[[1]] <- c(seq(from = 0.05, to = 0.35, by = 0.05))
```

### Model 2

``` r
diagnose_trained_models(2)
```

    ## [1] "Outcome: Violent recidivism. Predictors: Rita."
    ## [1] "Best tuning values:"
    ##    alpha lambda
    ## 18     0   0.34
    ## [1] "Per alpha value:"
    ## # A tibble: 6 x 5
    ## # Groups:   alpha [6]
    ##   alpha lambda   ROC  ROCSD     d
    ##   <dbl>  <dbl> <dbl>  <dbl> <dbl>
    ## 1   0     0.34 0.731 0.0630 0.872
    ## 2   0.2   0.08 0.720 0.0645 0.822
    ## 3   0.4   0.1  0.718 0.0620 0.816
    ## 4   0.6   0.06 0.716 0.0626 0.807
    ## 5   0.8   0.02 0.716 0.0650 0.808
    ## 6   1     0.02 0.714 0.0648 0.799
    ## [1] "Max - min d: 0.072"

![](05b2_train_elastic_net_diagnose_1_files/figure-markdown_github/unnamed-chunk-7-1.png)

``` r
glmnet_grid$alpha2[[2]] <- c(seq(from = 0, to = 0.15, by = 0.05))
```

### Model 3

``` r
diagnose_trained_models(3)
```

    ## [1] "Outcome: General recidivism. Predictors: Static."
    ## [1] "Best tuning values:"
    ##     alpha lambda
    ## 757     1   0.02
    ## [1] "Per alpha value:"
    ## # A tibble: 6 x 5
    ## # Groups:   alpha [6]
    ##   alpha lambda   ROC  ROCSD     d
    ##   <dbl>  <dbl> <dbl>  <dbl> <dbl>
    ## 1   0     0.08 0.766 0.0470  1.03
    ## 2   0.2   0.06 0.767 0.0455  1.03
    ## 3   0.4   0.04 0.768 0.0454  1.03
    ## 4   0.6   0.02 0.768 0.0455  1.04
    ## 5   0.8   0.02 0.768 0.0453  1.04
    ## 6   1     0.02 0.768 0.0452  1.04
    ## [1] "Max - min d: 0.012"

![](05b2_train_elastic_net_diagnose_1_files/figure-markdown_github/unnamed-chunk-8-1.png)

``` r
glmnet_grid$alpha2[[3]] <- c(seq(from = 0.85, to = 1, by = 0.05))
```

### Model 4

``` r
diagnose_trained_models(4)
```

    ## [1] "Outcome: Violent recidivism. Predictors: Static."
    ## [1] "Best tuning values:"
    ##    alpha lambda
    ## 14     0   0.26
    ## [1] "Per alpha value:"
    ## # A tibble: 6 x 5
    ## # Groups:   alpha [6]
    ##   alpha lambda   ROC  ROCSD     d
    ##   <dbl>  <dbl> <dbl>  <dbl> <dbl>
    ## 1   0     0.26 0.774 0.0505  1.06
    ## 2   0.2   0.06 0.773 0.0490  1.06
    ## 3   0.4   0.04 0.770 0.0487  1.05
    ## 4   0.6   0.02 0.769 0.0493  1.04
    ## 5   0.8   0.02 0.768 0.0491  1.03
    ## 6   1     0.02 0.766 0.0490  1.03
    ## [1] "Max - min d: 0.037"

![](05b2_train_elastic_net_diagnose_1_files/figure-markdown_github/unnamed-chunk-9-1.png)

``` r
glmnet_grid$alpha2[[4]] <- c(seq(from = 0, to = 0.15, by = 0.05))
```

### Model 5

``` r
diagnose_trained_models(5)
```

    ## [1] "Outcome: General recidivism. Predictors: All at start of sentence."
    ## [1] "Best tuning values:"
    ##     alpha lambda
    ## 757     1   0.02
    ## [1] "Per alpha value:"
    ## # A tibble: 6 x 5
    ## # Groups:   alpha [6]
    ##   alpha lambda   ROC  ROCSD     d
    ##   <dbl>  <dbl> <dbl>  <dbl> <dbl>
    ## 1   0     0.44 0.783 0.0474  1.11
    ## 2   0.2   0.1  0.793 0.0452  1.16
    ## 3   0.4   0.04 0.794 0.0451  1.16
    ## 4   0.6   0.04 0.794 0.0444  1.16
    ## 5   0.8   0.02 0.795 0.0451  1.16
    ## 6   1     0.02 0.796 0.0447  1.17
    ## [1] "Max - min d: 0.062"

![](05b2_train_elastic_net_diagnose_1_files/figure-markdown_github/unnamed-chunk-10-1.png)

``` r
glmnet_grid$alpha2[[5]] <- c(seq(from = 0.85, to = 1, by = 0.05))
```

### Model 6

``` r
diagnose_trained_models(6)
```

    ## [1] "Outcome: Violent recidivism. Predictors: All at start of sentence."
    ## [1] "Best tuning values:"
    ##    alpha lambda
    ## 15     0   0.28
    ## [1] "Per alpha value:"
    ## # A tibble: 6 x 5
    ## # Groups:   alpha [6]
    ##   alpha lambda   ROC  ROCSD     d
    ##   <dbl>  <dbl> <dbl>  <dbl> <dbl>
    ## 1   0     0.28 0.792 0.0528  1.15
    ## 2   0.2   0.12 0.791 0.0505  1.14
    ## 3   0.4   0.08 0.788 0.0502  1.13
    ## 4   0.6   0.06 0.787 0.0500  1.13
    ## 5   0.8   0.04 0.786 0.0497  1.12
    ## 6   1     0.04 0.784 0.0497  1.11
    ## [1] "Max - min d: 0.037"

![](05b2_train_elastic_net_diagnose_1_files/figure-markdown_github/unnamed-chunk-11-1.png)

``` r
glmnet_grid$alpha2[[6]] <- c(seq(from = 0, to = 0.15, by = 0.05))
```

### Model 7

``` r
diagnose_trained_models(7)
```

    ## [1] "Outcome: General recidivism. Predictors: All including term."
    ## [1] "Best tuning values:"
    ##     alpha lambda
    ## 757     1   0.02
    ## [1] "Per alpha value:"
    ## # A tibble: 6 x 5
    ## # Groups:   alpha [6]
    ##   alpha lambda   ROC  ROCSD     d
    ##   <dbl>  <dbl> <dbl>  <dbl> <dbl>
    ## 1   0     0.16 0.808 0.0434  1.23
    ## 2   0.2   0.08 0.822 0.0405  1.30
    ## 3   0.4   0.04 0.825 0.0399  1.32
    ## 4   0.6   0.04 0.824 0.0392  1.32
    ## 5   0.8   0.02 0.825 0.0395  1.32
    ## 6   1     0.02 0.825 0.0389  1.32
    ## [1] "Max - min d: 0.092"

![](05b2_train_elastic_net_diagnose_1_files/figure-markdown_github/unnamed-chunk-12-1.png)

``` r
glmnet_grid$alpha2[[7]] <- c(seq(from = 0.85, to = 1, by = 0.05))
```

### Model 8

``` r
diagnose_trained_models(8)
```

    ## [1] "Outcome: Violent recidivism. Predictors: All including term."
    ## [1] "Best tuning values:"
    ##    alpha lambda
    ## 13     0   0.24
    ## [1] "Per alpha value:"
    ## # A tibble: 6 x 5
    ## # Groups:   alpha [6]
    ##   alpha lambda   ROC  ROCSD     d
    ##   <dbl>  <dbl> <dbl>  <dbl> <dbl>
    ## 1   0     0.24 0.800 0.0501  1.19
    ## 2   0.2   0.08 0.800 0.0478  1.19
    ## 3   0.4   0.04 0.797 0.0477  1.18
    ## 4   0.6   0.06 0.795 0.0487  1.16
    ## 5   0.8   0.02 0.794 0.0476  1.16
    ## 6   1     0.02 0.792 0.0480  1.15
    ## [1] "Max - min d: 0.041"

![](05b2_train_elastic_net_diagnose_1_files/figure-markdown_github/unnamed-chunk-13-1.png)

``` r
glmnet_grid$alpha2[[8]] <- c(seq(from = 0, to = 0.15, by = 0.05))
```
