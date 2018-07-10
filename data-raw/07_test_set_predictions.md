---
title: "Predicting recidivism in test set based on models trained on training set"
author: "Benny Salo"
date: "2018-04-18"
output: github_document
---

Load models

```r
devtools::wd()
```

```
## Changing working directory to C:/Users/benny_000/Dropbox/AAAKTUELLT/Manuskript 2/A- R -project
```

```r
trained_mods_all <- readRDS("not_public/trained_mods_all.rds")
```

```
## Error in readRDS("not_public/trained_mods_all.rds"): error reading from connection
```

Load test set

```r
devtools::wd()
test_set <- readRDS("not_public/test_set.rds")
```



```r
# Create a function to extract predictions for a given model
predict_test_set<- function(model) {
  caret::predict.train(model, newdata = test_set, type = "prob")[[2]]
}

# Apply this function to all models in the list
test_set_predictions <- purrr::map_df(.x = trained_mods_all, 
                                      .f = ~ predict_test_set(.x))
```

```
## Error in map(.x, .f, ...): object 'trained_mods_all' not found
```

```r
test_set_predictions <- test_set %>% 
  select(reoffenceThisTerm, newO_violent, 
         economy_problems, alcohol_problems, resistance_change, 
         drug_related_probl, aggressiveness, employment_probl) %>% 
  bind_cols(test_set_predictions)
```


Save and make available in /data

```r
devtools::use_data(test_set_predictions, overwrite = TRUE)
```
