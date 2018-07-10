Combine the best models of each type
================
Benny Salo
2018-07-10

Load the best models. That is the last updated models.

``` r
devtools::wd()
trained_mods_glm    <- readRDS("not_public/trained_mods_glm.rds")
trained_mods_glmnet <- readRDS("not_public/trained_mods_glmnet3.rds")
trained_mods_rf     <- readRDS("not_public/trained_mods_rf2.rds")
```

Combine all models.

``` r
trained_mods_all <- c(trained_mods_glm, trained_mods_glmnet, trained_mods_rf)
```

Save the combined models.

``` r
devtools::wd()
saveRDS(trained_mods_all, "not_public/trained_mods_all.rds")
```
