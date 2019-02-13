---
title: "Incremental validity in d"
output: html_notebook
---

## Function


```r
R2_difference_in_d <- function(better_mod, worse_mod, 
                               resamples = model_perfs_training_set1000) {
  
  data_frame(
      R2_b = resamples$values[[better_mod]],
      R2_w = resamples$values[[worse_mod]]
  ) %>% 
  mutate(better_d = calc_d_from_R2(R2_b),
         worse_d  = calc_d_from_R2(R2_w),
         diff_d   = better_d - worse_d) %>% 
  summarise(median_diff_d = median(diff_d),
            LL            = quantile(diff_d, 0.025),
            UL            = quantile(diff_d, 0.975),
            p             = mean(diff_d < 0))
}
```

## Comparing algorithm types


```r
compared_models <- model_grid %>% 
  filter(analysis == "Main analyses" & model_type != "Logistic regression") %>% 
  select(model_name) %>% 
  purrr::as_vector()


a <- data_frame(glmnet_mod = stringr::str_subset(compared_models, "glmnet"),
           rf_mod     = stringr::str_subset(compared_models, "rf")) %>% 
  mutate(glmnet_mod = paste0(glmnet_mod, "~McF_R2"),
         rf_mod     = paste0(rf_mod, "~McF_R2")) 

cbind(a, 
      purrr::map2_df(.x = a$glmnet_mod, 
                     .y = a$rf_mod, 
                     .f = ~R2_difference_in_d(.x, .y)))
```

```
##               glmnet_mod             rf_mod median_diff_d          LL
## 1 gen_rita_glmnet~McF_R2 gen_rita_rf~McF_R2  -0.032730862 -0.13105659
## 2 vio_rita_glmnet~McF_R2 vio_rita_rf~McF_R2   0.113093966 -0.03938274
## 3 gen_stat_glmnet~McF_R2 gen_stat_rf~McF_R2  -0.017041661 -0.16056691
## 4 vio_stat_glmnet~McF_R2 vio_stat_rf~McF_R2   0.031697670 -0.23266524
## 5 gen_bgnn_glmnet~McF_R2 gen_bgnn_rf~McF_R2   0.002237638 -0.09850602
## 6 vio_bgnn_glmnet~McF_R2 vio_bgnn_rf~McF_R2   0.010886785 -0.11638315
## 7 gen_allp_glmnet~McF_R2 gen_allp_rf~McF_R2   0.075287532 -0.03355958
## 8 vio_allp_glmnet~McF_R2 vio_allp_rf~McF_R2   0.012964774 -0.12922396
##          UL     p
## 1 0.1018480 0.729
## 2 1.5808823 0.082
## 3 0.2235609 0.575
## 4 2.0655987 0.462
## 5 0.1248562 0.488
## 6 0.1396502 0.441
## 7 0.1960220 0.083
## 8 0.1708430 0.437
```

## Comparing predictor sets



```r
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

b <- data_frame(incr = incremental_mod,
                base = baseline_mod) %>% 
      mutate(incr = paste0(incr, "~McF_R2"),
             base = paste0(base, "~McF_R2")) 

cbind(b, 
      purrr::map2_df(.x = b$incr, 
                     .y = b$base, 
                     .f = ~R2_difference_in_d(.x, .y))) %>% 
  mutate_at(3:6, round, 3)
```

```
##                     incr                   base median_diff_d     LL    UL
## 1 gen_stat_glmnet~McF_R2 gen_rita_glmnet~McF_R2         0.176 -0.031 0.392
## 2 gen_bgnn_glmnet~McF_R2 gen_stat_glmnet~McF_R2         0.056 -0.069 0.156
## 3 gen_allp_glmnet~McF_R2 gen_bgnn_glmnet~McF_R2         0.212  0.123 0.288
## 4 vio_stat_glmnet~McF_R2 vio_rita_glmnet~McF_R2         0.059 -0.167 0.327
## 5 vio_bgnn_glmnet~McF_R2 vio_stat_glmnet~McF_R2         0.144 -0.028 0.298
## 6 vio_allp_glmnet~McF_R2 vio_bgnn_glmnet~McF_R2         0.060 -0.008 0.104
##       p
## 1 0.052
## 2 0.160
## 3 0.000
## 4 0.293
## 5 0.048
## 6 0.038
```

