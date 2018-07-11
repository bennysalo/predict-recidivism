Training random forest models
================
Benny Salo
2018-07-10

Training set is defined in 01\_analyzed\_data.Rmd

``` r
devtools::wd()
devtools::load_all(".")
training_set <- readRDS("not_public/training_set.rds")
```

Train each model (rows) in the grid according to specifications in the grid. Place results in the train\_result columns (previously intitiated).

(Record how long it takes to run.)

``` r
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

    ## Loading required package: lattice

    ## Loading required package: ggplot2

``` r
time_to_run <- Sys.time() - start
time_to_run
```

    ## Time difference of 4.590966 hours

Save the results as a named list.

``` r
names(trained_mods_rf) <- rf_grid$model_name
```

``` r
devtools::wd()
saveRDS(trained_mods_rf, "not_public/trained_mods_rf.rds")
```
