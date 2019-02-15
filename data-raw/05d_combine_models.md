---
title: "Combine the best models of each type"
author: "Benny Salo"
date: "2019-02-14"
output: github_document
---

Load the best models for each algorithm type. That is, the last updated models.


```r
devtools::wd()
trained_mods_glm    <- readRDS("not_public/trained_mods_glm.rds")
trained_mods_glmnet <- readRDS("not_public/trained_mods_glmnet_3_LL.rds")
trained_mods_rf     <- readRDS("not_public/trained_mods_rf_3.rds")
```

Combine all models.


```r
trained_mods_all <- c(trained_mods_glm, trained_mods_glmnet, trained_mods_rf)
```

Save the combined models.

```r
devtools::wd()
saveRDS(trained_mods_all, "not_public/trained_mods_all.rds")
```



```r
devtools::wd()
trained_mods_glm1000    <- readRDS("not_public/trained_mods_glm_4.rds")
trained_mods_glmnet1000 <- readRDS("not_public/trained_mods_glmnet_4.rds")
trained_mods_rf1000     <- readRDS("not_public/trained_mods_rf_4.rds")
```

Combine all models.


```r
trained_mods_all1000 <- c(trained_mods_glm1000, 
                          trained_mods_glmnet1000, 
                          trained_mods_rf1000)
```

Save the combined models.

```r
devtools::wd()
saveRDS(trained_mods_all1000, "not_public/trained_mods_all1000.rds")
```
