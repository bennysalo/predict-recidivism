Pseudo R-squared for Table 2
================
Benny Salo
2019-04-04

In this vignette we show how we extracted McFadden pseudo R2-values for Table 2.

Model performances in the training set are stored in the data object `model_perfs_training_set1000`. It also contains other models and measures than the ones presented in Table 2. (See the documentation for the data object.)

``` r
?model_perfs_training_set1000
#> Rendering development documentation for 'model_perfs_training_set1000'
```

Load packages.

``` r
library(recidivismsl)
library(dplyr)
```

We will extract the columns with McFadden pseudo R2 values from the 'values' element in the data object. After that we will tidy the data frame into long format and calculate for each model the median the 2.5 and 97.5 percentiles plus the proportion of values that are under 0 (interpreted as a one-sided p-value).

``` r
# Functions from dplyr used (select, mutate, group_by, summarise)
McF_tbl_cv <-
model_perfs_training_set1000$values %>% 
  # Extract columns (one for each model)
  select(Resample, ends_with(match = "McF_R2")) %>% 
  # Tidy into long format
  tidyr::gather(-Resample, key = model, value = McF_R2) %>%
  # Calculate median, percentiles and one-sided p
  group_by(model) %>% 
  summarise(median_McF_R2 = median(McF_R2),
            ci95_LL_R2    = quantile(McF_R2, probs = 0.025),
            ci95_UL_R2    = quantile(McF_R2, probs = 0.975),
            p_one_side    = mean(McF_R2 < 0)) %>% 
  # Remove ~ROC from the end of the model name
  mutate(model = stringr::str_replace(model, pattern = "~McF_R2", ""))
```
