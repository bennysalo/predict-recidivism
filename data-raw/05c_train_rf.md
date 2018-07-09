---
title: "Training logirandom forest stic regression models"
author: "Benny Salo"
date: "2018-04-12"
output: github_document
---

Training set is defined in 01_analyzed_data.Rmd

```r
devtools::wd()
devtools::load_all(".")
training_set <- readRDS("not_public/training_set.rds")
```

Get the part of model_grid that are logistic regression models.

```r
library(dplyr)
rf_grid <- model_grid %>% filter(model_type == "Random forest")
```

We test seven possible values for the tuning parameter mtry, including the often recommended square root of the number of predictors. We test three smaller and three bigger values in relation to this. The sequence of tested values are the number of predictors raised to the power of 1/8, 1/4, 3/8, 1/2 (i.e. the square root), 5/8, 3/4, and 7/8.

We create a new column for this argument


```r
write_mtry_seq <- function(predictor_vector) {
  n_preds  <- length(predictor_vector)
  powers   <- (1:7)/8
  mtry_seq <- as.integer(round(n_preds^powers))
}

rf_grid$mtry_seq <- 
  purrr::map(
    .x = rf_grid$rhs,
    .f = ~ write_mtry_seq(.x)
  )
```
Assertions

```r
library(assertthat)
# All entries in rf_grid$mtry_seq should be of class integer
assert_that(all(purrr::map_chr(rf_grid$mtry_seq, class) == "integer"))
```

```
## [1] TRUE
```

```r
# All entries in rf_grid$mtry_seq should have length 7.
assert_that(all(purrr::map_chr(rf_grid$mtry_seq, length) == 7))
```

```
## [1] TRUE
```

```r
# The fourth element should be the sqrt of the number of predictors
fourth  <- purrr::map_int(rf_grid$mtry_seq, 4)
n_preds <- purrr::map_int(rf_grid$rhs, length)

assert_that(all(fourth == round(sqrt(n_preds))))
```

```
## [1] TRUE
```


Train each model (rows) in the grid according to specifications in the grid. Place results in the train_result columns (previously intitiated).

(Record how long it takes to run.)

```r
start <- Sys.time()

trained_mods_rf <- 
  purrr::pmap(
    .l = list(..1 = rf_grid$rhs,
              ..2 = rf_grid$lhs,
              ..3 = rf_grid$mtry_seq),
    .f = ~ caret::train(
      x         = training_set[..1],
      y         = training_set[[..2]],
      method    = "rf",
      metric    = "ROC",
      trControl = ctrl_fun_training,
      tuneGrid  = expand.grid(mtry = ..3)
      )
    )
```

```
## Error in `[.data.frame`(training_set, ..1): undefined columns selected
```

```r
time_to_run <- Sys.time() - start
time_to_run
```

```
## Time difference of 0.002997875 secs
```
Save the results as a named list.


```r
names(trained_mods_rf) <- rf_grid$model_name
```

```
## Error in names(trained_mods_rf) <- rf_grid$model_name: object 'trained_mods_rf' not found
```



```r
devtools::wd()
saveRDS(trained_mods_rf, "not_public/trained_mods_rf.rds")
```

# Update models


```r
rf_grid$mtry_seq2 <- vector("list", nrow(rf_grid))
```



```r
plot(trained_mods_rf[[1]])
```

```
## Error in plot(trained_mods_rf[[1]]): object 'trained_mods_rf' not found
```

```r
rf_grid$mtry_seq2[[1]] <- 2
```

```r
plot(trained_mods_rf[[2]])
```

```
## Error in plot(trained_mods_rf[[2]]): object 'trained_mods_rf' not found
```

```r
rf_grid$mtry_seq2[[2]] <- c(3, 4)
```


```r
plot(trained_mods_rf[[3]])
```

```
## Error in plot(trained_mods_rf[[3]]): object 'trained_mods_rf' not found
```

```r
rf_grid$mtry_seq2[[3]] <- c(4, 5, 6)
```

```r
plot(trained_mods_rf[[4]])
```

```
## Error in plot(trained_mods_rf[[4]]): object 'trained_mods_rf' not found
```

```r
rf_grid$mtry_seq2[[4]] <- c(1, 2)
```

```r
plot(trained_mods_rf[[5]])
```

```
## Error in plot(trained_mods_rf[[5]]): object 'trained_mods_rf' not found
```

```r
rf_grid$mtry_seq2[[5]] <- c(11, 13, 15, 17, 19)
```


```r
plot(trained_mods_rf[[6]])
```

```
## Error in plot(trained_mods_rf[[6]]): object 'trained_mods_rf' not found
```

```r
rf_grid$mtry_seq2[[6]] <- c(4, 5, 6, 7, 8)
```

```r
plot(trained_mods_rf[[7]])
```

```
## Error in plot(trained_mods_rf[[7]]): object 'trained_mods_rf' not found
```

```r
rf_grid$mtry_seq2[[7]] <- c(12, 14, 16, 18, 20)
```

```r
plot(trained_mods_rf[[8]])
```

```
## Error in plot(trained_mods_rf[[8]]): object 'trained_mods_rf' not found
```

```r
rf_grid$mtry_seq2[[8]] <- c(12, 14, 16, 18, 20)
```


```r
rf_grid$mtry_seq2
```

```
## [[1]]
## [1] 2
## 
## [[2]]
## [1] 3 4
## 
## [[3]]
## [1] 4 5 6
## 
## [[4]]
## [1] 1 2
## 
## [[5]]
## [1] 11 13 15 17 19
## 
## [[6]]
## [1] 4 5 6 7 8
## 
## [[7]]
## [1] 12 14 16 18 20
## 
## [[8]]
## [1] 12 14 16 18 20
```



```r
start <- Sys.time()

trained_mods_rf2 <- 
  purrr::pmap(
    .l = list(..1 = rf_grid$rhs,
              ..2 = rf_grid$lhs,
              ..3 = rf_grid$mtry_seq2),
    .f = ~ caret::train(
      x         = training_set[..1],
      y         = training_set[[..2]],
      method    = "rf",
      metric    = "ROC",
      trControl = ctrl_fun_training,
      tuneGrid  = expand.grid(mtry = ..3)
      )
    )
```

```
## Error in `[.data.frame`(training_set, ..1): undefined columns selected
```

```r
time_to_run <- Sys.time() - start
time_to_run
```

```
## Time difference of 0.003995895 secs
```


```r
names(trained_mods_rf2) <- rf_grid$model_name
```

```
## Error in names(trained_mods_rf2) <- rf_grid$model_name: object 'trained_mods_rf2' not found
```


```r
devtools::wd()
saveRDS(trained_mods_rf2, "not_public/trained_mods_rf2.rds")
```


```r
rf_grid$mtry_seq3[[1]] <- 2
```

```r
plot(trained_mods_rf2[[2]])
```

```
## Error in plot(trained_mods_rf2[[2]]): object 'trained_mods_rf2' not found
```

```r
rf_grid$mtry_seq2[[2]] <- c(3, 4)
```


```r
plot(trained_mods_rf2[[3]])
```

```
## Error in plot(trained_mods_rf2[[3]]): object 'trained_mods_rf2' not found
```

```r
rf_grid$mtry_seq2[[3]] <- c(4, 5, 6)
```

```r
plot(trained_mods_rf2[[4]])
```

```
## Error in plot(trained_mods_rf2[[4]]): object 'trained_mods_rf2' not found
```

```r
rf_grid$mtry_seq2[[4]] <- c(1, 2)
```

```r
plot(trained_mods_rf2[[5]])
```

```
## Error in plot(trained_mods_rf2[[5]]): object 'trained_mods_rf2' not found
```

```r
rf_grid$mtry_seq2[[5]] <- c(11, 13, 15, 17, 19)
```


```r
plot(trained_mods_rf2[[6]])
```

```
## Error in plot(trained_mods_rf2[[6]]): object 'trained_mods_rf2' not found
```

```r
rf_grid$mtry_seq2[[6]] <- c(4, 5, 6, 7, 8)
```

```r
plot(trained_mods_rf2[[7]])
```

```
## Error in plot(trained_mods_rf2[[7]]): object 'trained_mods_rf2' not found
```

```r
rf_grid$mtry_seq2[[7]] <- c(12, 14, 16, 18, 20)
```

```r
plot(trained_mods_rf2[[8]])
```

```
## Error in plot(trained_mods_rf2[[8]]): object 'trained_mods_rf2' not found
```

```r
rf_grid$mtry_seq2[[8]] <- c(12, 14, 16, 18, 20)
```

