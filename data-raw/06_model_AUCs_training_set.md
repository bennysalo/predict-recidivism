Extracting model performances in the training set
================
Benny Salo
2018-07-10

``` r
devtools::wd()
trained_mods_all <- readRDS("not_public/trained_mods_all.rds")
```

Creating `model_AUCs_training_set`

Extract the model performances in the 10 x 10 folds in the training data

``` r
model_AUCs_training_set <- caret::resamples(trained_mods_all)
```

Save and make available via /data

``` r
devtools::use_data(model_AUCs_training_set, overwrite = TRUE)
```
