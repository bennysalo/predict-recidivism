---
title: "Table 2 - Pseudo R2"
date: "2018-09-24"
output: github_document
---


```r
devtools::load_all(".")
```

```
## Loading recidivismsl
```

```r
library(dplyr)
library(caret)
```

```
## Loading required package: lattice
```

```
## 
## Attaching package: 'caret'
```

```
## The following object is masked from 'package:purrr':
## 
##     lift
```



```r
# Functions from dplyr used (select, mutate, group_by, summarise)
McF_tbl_cv <-
model_perfs_training_set1000$values %>% 
  select(Resample, ends_with(match = "McF_R2")) %>% 
  tidyr::gather(-Resample, key = model, value = McF_R2) %>%
  # mutate(logit_R2 = log(McF_R2 / (1-McF_R2))) %>% 
  group_by(model) %>% 
  summarise(median_McF_R2 = median(McF_R2),
            ci95_LL_R2    = quantile(McF_R2, probs = 0.025),
            ci95_UL_R2   = quantile(McF_R2, probs = 0.975),
            p_one_side   = mean(McF_R2 < 0)) %>% 
  # # Remove the column `mean_logit` 
  # select(-mean_logit) %>% 
  # Remove ~ROC from the end of the model name
  mutate(model = stringr::str_replace(model, pattern = "~McF_R2", ""))
```


```r
model_desc <- model_grid[c("model_name", "outcome", 
                           "predictors", "model_type", "analysis")]


table_2 <- full_join(model_desc, McF_tbl_cv, by = c("model_name" = "model")) %>% 
  filter(model_type == "Elastic net" | analysis == "Dimension analyses") %>% 
  arrange(outcome, desc(analysis), predictors) %>% 
  select(-model_name, -analysis, -model_type) %>% 
  mutate_at(.vars = vars(3:5), round, 3)
```




```r
knitr::kable(table_2)
```



|outcome            |predictors                | median_McF_R2| ci95_LL_R2| ci95_UL_R2| p_one_side|
|:------------------|:-------------------------|-------------:|----------:|----------:|----------:|
|General recidivism |All including term        |         0.270|      0.207|      0.322|      0.000|
|General recidivism |All at start of sentence  |         0.203|      0.137|      0.259|      0.000|
|General recidivism |Static                    |         0.187|      0.115|      0.240|      0.000|
|General recidivism |Rita-items                |         0.133|      0.070|      0.184|      0.000|
|General recidivism |Aggressiveness            |         0.022|     -0.006|      0.042|      0.052|
|General recidivism |Alcohol problem           |         0.027|     -0.003|      0.049|      0.040|
|General recidivism |Employment problems       |         0.065|      0.014|      0.102|      0.009|
|General recidivism |Problems managing economy |         0.106|      0.051|      0.155|      0.003|
|General recidivism |Resistance to change      |         0.029|     -0.006|      0.051|      0.054|
|General recidivism |NA                        |         0.050|      0.003|      0.079|      0.019|
|Violent recidivism |All including term        |         0.198|      0.127|      0.263|      0.000|
|Violent recidivism |All at start of sentence  |         0.181|      0.109|      0.245|      0.000|
|Violent recidivism |Static                    |         0.139|      0.077|      0.187|      0.000|
|Violent recidivism |Rita-items                |         0.120|      0.057|      0.175|      0.000|
|Violent recidivism |Aggressiveness            |         0.078|      0.016|      0.128|      0.008|
|Violent recidivism |Alcohol problem           |         0.047|     -0.005|      0.082|      0.037|
|Violent recidivism |Employment problems       |         0.031|     -0.013|      0.060|      0.092|
|Violent recidivism |Problems managing economy |         0.038|     -0.007|      0.070|      0.056|
|Violent recidivism |Resistance to change      |         0.025|     -0.019|      0.053|      0.116|
|Violent recidivism |NA                        |         0.041|     -0.012|      0.080|      0.051|




```r
test_metrics <- c("logLoss", "d_AUC", "McF_R2") 


my_diff <- function(model_vector) {
  diff(model_perfs_training_set1000, 
     models = model_vector,
     metric = test_metrics,
     adjustment = "none")
}


qet_quantiles_test <- 
  function(model_vector, metric = "logLoss", 
           sided = "two", Bonf_cor_n = 1, alpha = 0.05) {
    
  lim <- alpha / Bonf_cor_n
  if(sided == "two") {
    prob_lims <- c(lim/2, 1 - lim/2)
  } else if (sided == "lower") {
    prob_lims <- lim 
  } else if (sided == "upper") {
    prob_lims <- 1- lim 
  }  else {
    print('argument sided should be "two", "lower", or "upper"')
  }
  
  my_diff.resamples <- my_diff(c(model_vector))
  analyzed_difs     <- my_diff.resamples$difs[[metric]]
  
  comp     <- c("comparison" = paste(my_diff.resamples$models[1], " - ",
                                     my_diff.resamples$models[2]))
  metric   <- c("metric" = metric)

  median_dif <- c("median_dif" = round(median(analyzed_difs), 4))
  
  CI       <- round(quantile(analyzed_difs, probs = prob_lims), 3)

  # Uncorrected p
  p_1      <- min(mean(analyzed_difs > 0), mean(analyzed_difs < 0))

  p_2      <- p_1 + mean(analyzed_difs > (2 * abs(median_dif)))

  out <- c(metric, median_dif, CI, "p(1s_uncor.)" = p_1, "p(2s_uncor.)" = p_2)
  print(comp)
  print(out)
}
```


```r
qet_quantiles_test(c("gen_allp_glmnet", "gen_bgnn_glmnet"), metric = "McF_R2")
```

```
##                            comparison 
## "gen_allp_glmnet  -  gen_bgnn_glmnet" 
##       metric   median_dif         2.5%        97.5% p(1s_uncor.) 
##     "McF_R2"     "0.0682"       "0.04"      "0.092"          "0" 
## p(2s_uncor.) 
##          "0"
```

```r
qet_quantiles_test(c("gen_bgnn_glmnet", "gen_stat_glmnet"), metric = "McF_R2")          
```

```
##                            comparison 
## "gen_bgnn_glmnet  -  gen_stat_glmnet" 
##       metric   median_dif         2.5%        97.5% p(1s_uncor.) 
##     "McF_R2"     "0.0176"     "-0.022"      "0.048"       "0.16" 
## p(2s_uncor.) 
##      "0.313"
```

```r
qet_quantiles_test(c("gen_stat_glmnet", "gen_rita_glmnet"), metric = "McF_R2")
```

```
##                            comparison 
## "gen_stat_glmnet  -  gen_rita_glmnet" 
##       metric   median_dif         2.5%        97.5% p(1s_uncor.) 
##     "McF_R2"     "0.0533"     "-0.009"      "0.114"      "0.052" 
## p(2s_uncor.) 
##      "0.097"
```


```r
qet_quantiles_test(c("vio_allp_glmnet", "vio_bgnn_glmnet"), metric = "McF_R2")
```

```
##                            comparison 
## "vio_allp_glmnet  -  vio_bgnn_glmnet" 
##       metric   median_dif         2.5%        97.5% p(1s_uncor.) 
##     "McF_R2"     "0.0187"     "-0.002"      "0.033"      "0.038" 
## p(2s_uncor.) 
##      "0.039"
```

```r
qet_quantiles_test(c("vio_bgnn_glmnet", "vio_stat_glmnet"), metric = "McF_R2")          
```

```
##                            comparison 
## "vio_bgnn_glmnet  -  vio_stat_glmnet" 
##       metric   median_dif         2.5%        97.5% p(1s_uncor.) 
##     "McF_R2"     "0.0441"     "-0.009"      "0.088"      "0.048" 
## p(2s_uncor.) 
##      "0.075"
```

```r
qet_quantiles_test(c("vio_stat_glmnet", "vio_rita_glmnet"), metric = "McF_R2")
```

```
##                            comparison 
## "vio_stat_glmnet  -  vio_rita_glmnet" 
##       metric   median_dif         2.5%        97.5% p(1s_uncor.) 
##     "McF_R2"     "0.0169"     "-0.048"       "0.09"      "0.293" 
## p(2s_uncor.) 
##      "0.625"
```

