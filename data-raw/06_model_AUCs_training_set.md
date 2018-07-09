---
title: "Extracting model performances in the training set"
author: "Benny Salo"
date: "2018-04-13"
output: github_document
---


```r
devtools::wd()
trained_mods_glm    <- readRDS("not_public/trained_mods_glm.rds")
trained_mods_glmnet <- readRDS("not_public/trained_mods_glmnet3.rds")
```

```
## Error in readRDS("not_public/trained_mods_glmnet3.rds"): error reading from connection
```

```r
trained_mods_rf     <- readRDS("not_public/trained_mods_rf2.rds")
```

Combine all models


```r
trained_mods_all <- c(trained_mods_glm, trained_mods_glmnet, trained_mods_rf)
```

```
## Error in eval(expr, envir, enclos): object 'trained_mods_glmnet' not found
```

Save the combined models (used in 07)

```r
devtools::wd()
```

```
## Changing working directory to C:/Users/benny_000/Dropbox/AAAKTUELLT/Manuskript 2/A- R -project
```

```r
saveRDS(trained_mods_all, "not_public/trained_mods_all.rds")
```

```
## Error in saveRDS(trained_mods_all, "not_public/trained_mods_all.rds"): object 'trained_mods_all' not found
```


Extract the model performances in the 10 x 10 folds in the training data

```r
model_AUCs_training_set <- caret::resamples(trained_mods_all)
```

```
## Error in caret::resamples(trained_mods_all): object 'trained_mods_all' not found
```

Save and make available via /data

```r
devtools::use_data(model_AUCs_training_set)
```

```
## Error: model_AUCs_training_set.rda already exists in C:/Users/benny_000/Dropbox/AAAKTUELLT/Manuskript 2/A- R -project/data. Use overwrite = TRUE to overwrite
```

