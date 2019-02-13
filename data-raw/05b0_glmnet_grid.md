Create `glmnet_grid`
================
Benny Salo
2019-02-13

Clear environment. Load previous results from the package.

``` r
rm(list = ls())
devtools::load_all(".")

library(dplyr)
```

Get the part of model\_grid that are elastic net models.

``` r
glmnet_grid <- model_grid %>% filter(
  model_type == "Elastic net")
```

We use the formula method of caret::train for glmnet (to make the script work, unknown bug for other methods).

We introduce a new column where we write the formula.

``` r
glmnet_grid$formula <- 
  purrr::map2(.x = glmnet_grid$lhs, 
              .y = glmnet_grid$rhs,
              .f = ~write_formula(.x, .y))
```

Checks:

``` r
# All entries in glmnet_grid$formula should be formulas
stopifnot(all(purrr::map(glmnet_grid$formula, class) == "formula"))

# All formulas should include the corresponding outcome
outcome_in_formula <-
  purrr::map2_lgl(
    .x = as.character(glmnet_grid$formula),
    .y = glmnet_grid$lhs,
    .f = ~ stringr::str_detect(string = .x, pattern = .y)
    )
stopifnot(all(outcome_in_formula))

# The number of plusses in the formula should equal 
# the number of predictors - 1

n_plusses <- purrr::map2_int(
  .x = as.character(glmnet_grid$formula),
  .y = glmnet_grid$lhs,
  .f = ~ stringr::str_count(string = .x, pattern = "\\+")
  ) 

n_preds <- purrr::map_dbl(.x = glmnet_grid$rhs,
                      .f = ~ length(.x))
                      

stopifnot(all(n_plusses == n_preds - 1))
```

We are also going to want to adjust the tested values for parameter alpha. We create a new column for this. The tested values in the first run will be values between 0 and 1 with an interval of 0.1.

``` r
glmnet_grid$alpha <- vector("list", nrow(glmnet_grid))
glmnet_grid$alpha <- purrr::map(.x = glmnet_grid$alpha, 
                                .f = ~seq(0, 1, by = 0.1))
```

Checks

``` r
stopifnot(length(glmnet_grid$alpha) == 8,
          all(purrr::map(glmnet_grid$alpha, length) == 11),
          all(purrr::map(glmnet_grid$alpha, class) == "numeric"))
```

Save and make available in `/data`

``` r
devtools::use_data(glmnet_grid, overwrite = TRUE)
```

    ## Warning: 'devtools::use_data' is deprecated.
    ## Use 'usethis::use_data()' instead.
    ## See help("Deprecated") and help("devtools-deprecated").

    ## <U+2714> Setting active project to 'C:/Users/benny_000/OneDrive - United Nations/z-PhD/Manuskript 2/A- R -project'
    ## <U+2714> Saving 'glmnet_grid' to 'data/glmnet_grid.rda'

Print sessionInfo

``` r
sessionInfo()
```

    ## R version 3.5.2 (2018-12-20)
    ## Platform: x86_64-w64-mingw32/x64 (64-bit)
    ## Running under: Windows 10 x64 (build 17134)
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
    ## [1] bindrcpp_0.2.2          dplyr_0.7.8             recidivismsl_0.0.0.9000
    ## [4] testthat_2.0.1         
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] pkgload_1.0.2      splines_3.5.2      foreach_1.4.4     
    ##  [4] prodlim_2018.04.18 assertthat_0.2.0   stats4_3.5.2      
    ##  [7] yaml_2.2.0         remotes_2.0.2      sessioninfo_1.1.1 
    ## [10] ipred_0.9-8        pillar_1.3.1       backports_1.1.3   
    ## [13] lattice_0.20-38    glue_1.3.0         pROC_1.13.0       
    ## [16] digest_0.6.18      colorspace_1.4-0   recipes_0.1.4     
    ## [19] htmltools_0.3.6    Matrix_1.2-15      plyr_1.8.4        
    ## [22] clisymbols_1.2.0   timeDate_3043.102  pkgconfig_2.0.2   
    ## [25] devtools_2.0.1     caret_6.0-81       purrr_0.2.5       
    ## [28] scales_1.0.0       processx_3.2.1     gower_0.1.2       
    ## [31] lava_1.6.4         furniture_1.8.7    tibble_2.0.1      
    ## [34] generics_0.0.2     ggplot2_3.1.0      usethis_1.4.0     
    ## [37] withr_2.1.2        nnet_7.3-12        lazyeval_0.2.1    
    ## [40] cli_1.0.1          survival_2.43-3    magrittr_1.5      
    ## [43] crayon_1.3.4       memoise_1.1.0      evaluate_0.12     
    ## [46] ps_1.3.0           fs_1.2.6           nlme_3.1-137      
    ## [49] MASS_7.3-51.1      forcats_0.3.0      class_7.3-14      
    ## [52] pkgbuild_1.0.2     ggthemes_4.0.1     tools_3.5.2       
    ## [55] data.table_1.12.0  prettyunits_1.0.2  stringr_1.3.1     
    ## [58] munsell_0.5.0      callr_3.1.1        compiler_3.5.2    
    ## [61] rlang_0.3.1        grid_3.5.2         iterators_1.0.10  
    ## [64] rstudioapi_0.9.0   rmarkdown_1.11     gtable_0.2.0      
    ## [67] ModelMetrics_1.2.2 codetools_0.2-15   reshape2_1.4.3    
    ## [70] R6_2.3.0           lubridate_1.7.4    knitr_1.21        
    ## [73] bindr_0.1.1        rprojroot_1.3-2    desc_1.2.0        
    ## [76] stringi_1.2.4      Rcpp_1.0.0         rpart_4.1-13      
    ## [79] tidyselect_0.2.5   xfun_0.4
