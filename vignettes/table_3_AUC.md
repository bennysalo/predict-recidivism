---
title: "Table 2"
date: "2019-02-15"
output: github_document
---

Table 2 displays the Estimated test discimination and Conditional test discimination of the Elastic net models for all predictor sets. For single dimensions the model is ordinary univariate logistic regression.



## Setup


```r
devtools::load_all(".")
library(dplyr)
library(ggplot2)
```



## Discrimination in cross validated training set: `auc_tbl_cv`

The discrimination varies widely over the 1000 cross-validation sets for all models. We are interested in the means and percentile confidence interval.

(This is similar to a bootstrap except that we explicitely specify the number of observations, and base rate for the outcome in each validation set. All observations are also used as part of a validation set the same number of times.)

The mean is calculated by first transforming AUC-values to logits of the AUC-values, then taking the mean and tranforiming it back to a AUC-value. Confidence intervals are simply the percentiles 2.5 and 97.5 of the 1000 AUC-values.


```r
# Functions from dplyr used (select, mutate, group_by, summarise)
auc_tbl_cv <-
model_perfs_training_set1000$values %>% 
  select(Resample, ends_with(match = "ROC")) %>% 
  tidyr::gather(-Resample, key = model, value = ROC) %>%
  mutate(logit_ROC = log(ROC / (1-ROC))) %>% 
  group_by(model) %>% 
  summarise(mean_logit  = mean(logit_ROC),
            mean_auc_cv = exp(mean_logit)  / (1 + exp(mean_logit)),
            ci95_LL_cv    = quantile(ROC, probs = 0.025),
            ci95_UL_cv   = quantile(ROC, probs = 0.975)) %>% 
  # Remove the column `mean_logit` 
  select(-mean_logit) %>% 
  # Remove ~ROC from the end of the model name
  mutate(model = stringr::str_replace(model, pattern = "~ROC", ""))
```
The data frame `auc_tbl_cv` contains the mean AUC with 95% confidence intervals for all models in the model grid. 

## Discrimination in test set: `auc_tbl_ts`

Using the package `pROC` we can calculate the AUC with confidence intervals. For this we need the observed outcomes and the predicted probabilities. The predicted probabilities are included in the package in the data frame `test_set_predictions` (in the /data folder).

We use bootstrap to calculate the confidence intervals which means this chunk takes a few minutes to run.

```r
# Get the names of predictions of violent and generalised recidivism seperately.
model_names_G <- stringr::str_subset(names(test_set_predictions), 
                                     pattern = "gen_") 
model_names_V <- stringr::str_subset(names(test_set_predictions), 
                                     pattern = "vio_") 

# Do ROC analysis using predictions with the relevant outcome
# First all predictions of general recidivism
# (ts stands for 'test set')
roc_list_ts_G <- 
  purrr::map(.x = test_set_predictions[model_names_G],
             .f = ~ pROC::roc(test_set_predictions$reoffenceThisTerm, .x))

# Then all predictions of violent recidivism
roc_list_ts_V <- 
  purrr::map(.x = test_set_predictions[model_names_V],
             .f = ~ pROC::roc(test_set_predictions$newO_violent, .x))

# Combine the two lists
roc_list_ts   <- c(roc_list_ts_G, roc_list_ts_V)

# Bootstrap confidence intervals for all AUC-values
set.seed(2803)
auc_ci_list   <- 
  purrr::map(roc_list_ts,
             .f = ~ pROC::ci.auc(.x,
             method = "bootstrap",
             progress = "none"))
```
The results are at this point stored in a list (`auc_ci_list`). The following chunk places them in data_frame that we call `auc_tbl_ts`


```r
#(_ts stands for "test set")
# Create a function to extract auc and its confidence interval
get_ci <- function(ci.auc_result) {
  data_frame(auc_ts      = ci.auc_result[2], 
             ci95_LL_ts = ci.auc_result[1], 
             ci95_UL_ts = ci.auc_result[3])
}

# Apply this function to all results in 'the 'auc_tbl_ts'
auc_tbl_ts <- purrr::map_df(auc_ci_list, get_ci)

# Amend the data frame with the names of the models
auc_tbl_ts <- data.frame(model = names(auc_ci_list), auc_tbl_ts,
                         stringsAsFactors = FALSE)
```

## Join tables `auc_tbl_cv` and `auc_tbl_ts`
We join the tables with AUC-values in *training set* and *test set* and then join these to the descriptive columns i model_grid.


```r
model_desc <- model_grid[c("model_name", "outcome", 
                           "predictors", "model_type")]

auc_tbl <- dplyr::full_join(auc_tbl_cv, auc_tbl_ts, by = "model") %>% 
  full_join(model_desc, auc_tbl, by = c("model" = "model_name"))
```

We add to this table figures for Cohen's d calculated from AUC using a formula in Table 1 in Ruscio (2008): $d = \sqrt2 \phi^{-1}CL$ where CL refers to "Common Language Effect Size" which in this case is the same as AUC and $\phi^{-1}$ is the inverse of the normal cumulative distribution function (i.e. the z-score that correspond to a cumulative percentage in a normal distribution). 

This is the formula assuming equal group sizes. This assumption does not hold for violent recidivism but retains the property of AUC of not being affected by base rates and thus makes comparison between violent and general recidivism more straight forward. 

Cohen's d has the advantage over AUC in that it is an effect size that is linear. With that I mean that the difference between d = 0.1 and d = 0.2 is the same as the difference between d = 1.1 and d = 1.2. On the contrary, the difference between AUC = 0.60 and AUC = 0.65 is smaller than the difference between AUC = 0.90 and AUC = 0.95. This makes d more convinient for comparisons between pairs of models.

The function below can be used to transform any AUC value to Cohen's d.


```r
calc_d_from_AUC <- function(AUC) {
  sqrt(2) * qnorm(AUC) 
}
```

We add Cohen's d calculated from the mean AUC in the training set and the estimated AUC in the test set.


```r
auc_tbl <- auc_tbl %>% 
  mutate(d_cv = calc_d_from_AUC(mean_auc_cv),
         d_ts = calc_d_from_AUC(auc_ts))
```
Sort the columns and then the rows according to outcome, predictors, model_type


```r
auc_tbl <- auc_tbl %>% 
  select(outcome, predictors, model_type, 
         mean_auc_cv, ci95_LL_cv, ci95_UL_cv, d_cv,
         auc_ts, ci95_LL_ts, ci95_UL_ts, d_ts, 
         model) %>% 
  arrange(outcome, predictors, model_type)
```



The `auc_tbl`now contains discimination values for all 36 models. In Table 2 we display the ealstic net models and the logistic regression models with simgle RITA-dimensions. We filter `auc_tbl` accordingly.


```r
table2_models <- model_grid %>% 
  filter(model_type == "Elastic net" | analysis == "Dimension analyses") %>% 
  select(model_name) %>% 
  purrr::as_vector()


# Filter auc_tbl
table_2 <- filter(auc_tbl, model %in% table2_models)
```

We edit Table 2 below. Remove the model_nbame column and round AUC values to 3 decimal places and d-values to two decimal places. 



```r
table_2 <- table_2 %>% 
  mutate_at(.vars = vars(mean_auc_cv, ci95_LL_cv, ci95_UL_cv, 
                         auc_ts, ci95_LL_ts, ci95_UL_ts), 
            .funs = round, digits = 3) %>% 
  mutate_at(.vars = vars(d_cv, d_ts), .funs = round, digits = 2) %>% 
  select(-model_type, -model) %>% 
  arrange(outcome)
  

table_2
```

```
## # A tibble: 20 x 10
##    outcome predictors mean_auc_cv ci95_LL_cv ci95_UL_cv  d_cv auc_ts
##    <fct>   <fct>            <dbl>      <dbl>      <dbl> <dbl>  <dbl>
##  1 Genera~ All inclu~       0.829      0.787      0.866  1.34  0.823
##  2 Genera~ All at st~       0.795      0.746      0.839  1.16  0.775
##  3 Genera~ Static           0.782      0.733      0.824  1.1   0.738
##  4 Genera~ Rita-items       0.744      0.691      0.793  0.93  0.755
##  5 Genera~ Aggressiv~       0.602      0.546      0.656  0.36  0.632
##  6 Genera~ Alcohol p~       0.613      0.56       0.667  0.41  0.647
##  7 Genera~ Employmen~       0.682      0.628      0.734  0.67  0.709
##  8 Genera~ Current d~       0.631      0.581      0.679  0.47  0.655
##  9 Genera~ Problems ~       0.721      0.669      0.769  0.83  0.737
## 10 Genera~ Resistanc~       0.622      0.568      0.675  0.44  0.647
## 11 Violen~ All inclu~       0.815      0.767      0.862  1.27  0.771
## 12 Violen~ All at st~       0.802      0.751      0.852  1.2   0.761
## 13 Violen~ Static           0.775      0.717      0.826  1.07  0.788
## 14 Violen~ Rita-items       0.75       0.689      0.805  0.95  0.697
## 15 Violen~ Aggressiv~       0.705      0.643      0.766  0.76  0.668
## 16 Violen~ Alcohol p~       0.666      0.598      0.728  0.6   0.621
## 17 Violen~ Employmen~       0.647      0.578      0.709  0.54  0.596
## 18 Violen~ Current d~       0.646      0.578      0.714  0.53  0.629
## 19 Violen~ Problems ~       0.647      0.583      0.707  0.53  0.63 
## 20 Violen~ Resistanc~       0.622      0.551      0.689  0.44  0.623
## # ... with 3 more variables: ci95_LL_ts <dbl>, ci95_UL_ts <dbl>,
## #   d_ts <dbl>
```

Print

```r
knitr::kable(table_2)
```



|outcome            |predictors                       | mean_auc_cv| ci95_LL_cv| ci95_UL_cv| d_cv| auc_ts| ci95_LL_ts| ci95_UL_ts| d_ts|
|:------------------|:--------------------------------|-----------:|----------:|----------:|----:|------:|----------:|----------:|----:|
|General recidivism |All including term               |       0.829|      0.787|      0.866| 1.34|  0.823|      0.771|      0.865| 1.31|
|General recidivism |All at start of sentence         |       0.795|      0.746|      0.839| 1.16|  0.775|      0.723|      0.825| 1.07|
|General recidivism |Static                           |       0.782|      0.733|      0.824| 1.10|  0.738|      0.677|      0.789| 0.90|
|General recidivism |Rita-items                       |       0.744|      0.691|      0.793| 0.93|  0.755|      0.697|      0.807| 0.98|
|General recidivism |Aggressiveness                   |       0.602|      0.546|      0.656| 0.36|  0.632|      0.569|      0.694| 0.48|
|General recidivism |Alcohol problem                  |       0.613|      0.560|      0.667| 0.41|  0.647|      0.586|      0.707| 0.53|
|General recidivism |Employment problems              |       0.682|      0.628|      0.734| 0.67|  0.709|      0.651|      0.765| 0.78|
|General recidivism |Current drug use and its effects |       0.631|      0.581|      0.679| 0.47|  0.655|      0.599|      0.707| 0.56|
|General recidivism |Problems managing economy        |       0.721|      0.669|      0.769| 0.83|  0.737|      0.678|      0.790| 0.90|
|General recidivism |Resistance to change             |       0.622|      0.568|      0.675| 0.44|  0.647|      0.583|      0.707| 0.53|
|Violent recidivism |All including term               |       0.815|      0.767|      0.862| 1.27|  0.771|      0.703|      0.835| 1.05|
|Violent recidivism |All at start of sentence         |       0.802|      0.751|      0.852| 1.20|  0.761|      0.691|      0.826| 1.01|
|Violent recidivism |Static                           |       0.775|      0.717|      0.826| 1.07|  0.788|      0.726|      0.844| 1.13|
|Violent recidivism |Rita-items                       |       0.750|      0.689|      0.805| 0.95|  0.697|      0.624|      0.769| 0.73|
|Violent recidivism |Aggressiveness                   |       0.705|      0.643|      0.766| 0.76|  0.668|      0.590|      0.743| 0.61|
|Violent recidivism |Alcohol problem                  |       0.666|      0.598|      0.728| 0.60|  0.621|      0.544|      0.701| 0.44|
|Violent recidivism |Employment problems              |       0.647|      0.578|      0.709| 0.54|  0.596|      0.512|      0.679| 0.34|
|Violent recidivism |Current drug use and its effects |       0.646|      0.578|      0.714| 0.53|  0.629|      0.555|      0.712| 0.47|
|Violent recidivism |Problems managing economy        |       0.647|      0.583|      0.707| 0.53|  0.630|      0.546|      0.708| 0.47|
|Violent recidivism |Resistance to change             |       0.622|      0.551|      0.689| 0.44|  0.623|      0.542|      0.705| 0.44|




### Print sessionInfo

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
## [1] recidivismsl_0.0.0.9000 caret_6.0-81            lattice_0.20-38        
## [4] bindrcpp_0.2.2          ggplot2_3.1.0           dplyr_0.7.8            
## [7] testthat_2.0.1          purrr_0.2.5             magrittr_1.5           
## 
## loaded via a namespace (and not attached):
##  [1] pkgload_1.0.2      tidyr_0.8.2        splines_3.5.2     
##  [4] foreach_1.4.4      prodlim_2018.04.18 assertthat_0.2.0  
##  [7] highr_0.7          stats4_3.5.2       yaml_2.2.0        
## [10] remotes_2.0.2      sessioninfo_1.1.1  ipred_0.9-8       
## [13] pillar_1.3.1       backports_1.1.3    glue_1.3.0        
## [16] pROC_1.13.0        digest_0.6.18      colorspace_1.4-0  
## [19] recipes_0.1.4      htmltools_0.3.6    Matrix_1.2-15     
## [22] plyr_1.8.4         timeDate_3043.102  pkgconfig_2.0.2   
## [25] devtools_2.0.1     scales_1.0.0       processx_3.2.1    
## [28] gower_0.1.2        lava_1.6.4         furniture_1.8.7   
## [31] tibble_2.0.1       generics_0.0.2     usethis_1.4.0     
## [34] withr_2.1.2        nnet_7.3-12        lazyeval_0.2.1    
## [37] cli_1.0.1          survival_2.43-3    crayon_1.3.4      
## [40] memoise_1.1.0      evaluate_0.12      ps_1.3.0          
## [43] fansi_0.4.0        fs_1.2.6           nlme_3.1-137      
## [46] MASS_7.3-51.1      forcats_0.3.0      class_7.3-14      
## [49] pkgbuild_1.0.2     ggthemes_4.0.1     tools_3.5.2       
## [52] data.table_1.12.0  prettyunits_1.0.2  stringr_1.3.1     
## [55] munsell_0.5.0      callr_3.1.1        compiler_3.5.2    
## [58] rlang_0.3.1        grid_3.5.2         iterators_1.0.10  
## [61] rstudioapi_0.9.0   rmarkdown_1.11     gtable_0.2.0      
## [64] ModelMetrics_1.2.2 codetools_0.2-15   reshape2_1.4.3    
## [67] R6_2.3.0           lubridate_1.7.4    knitr_1.21        
## [70] utf8_1.1.4         bindr_0.1.1        rprojroot_1.3-2   
## [73] desc_1.2.0         stringi_1.2.4      Rcpp_1.0.0        
## [76] rpart_4.1-13       tidyselect_0.2.5   xfun_0.4
```


