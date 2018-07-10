Descriptive statistics
================
Benny Salo
2018-07-10

``` r
devtools::load_all(".")
devtools::wd()
analyzed_data <- readRDS("not_public/analyzed_data.rds")
```

Make offence variables factors. Likewise with info missing variables.

``` r
library(dplyr)
```

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

``` r
analyzed_data <-
analyzed_data %>% 
  mutate_at(.vars = vars(starts_with("o_"), ps_info_missing, ageFirst_missing),
            factor)
```

``` r
vars_to_desc <- 
  variable_table$Variable[variable_table$Desciptives %in% c("num", "cat")]


# desc_var_names <- 
#   variable_table$Label[match(vars_to_desc, variable_table$Variable)]

# No new white collar crimes. Explicitely set the levels to 0 and 1.
levels(analyzed_data$newO_whitecollar) <- c(0, 1)

descriptive_stats <- 
  furniture::table1(analyzed_data[c(vars_to_desc, "reoff_category")],
                  splitby = reoff_category, type = c("condenced"))
```

Edit

``` r
descriptive_stats$Table1 <-
  descriptive_stats$Table1 %>% 
  rename(Variable = " ",
         "No reoffence" = no_reoffence,
         "Non-violent reoffence" = reoffence_nonviolent,
         "Violent reoffence" = reoffence_violent) %>%
  mutate(Variable = stringr::str_remove(Variable, ":.*$")) %>% 
  left_join(variable_table[c("Variable", "Label")], by = "Variable") %>% 
  mutate(Variable = ifelse(is.na(Label), yes = Variable, no = Label)) %>%
  select(1:4)
```

Save in "/data".

``` r
devtools::use_data(descriptive_stats, overwrite = TRUE)
```

``` r
sessionInfo()
```

    ## R version 3.5.1 (2018-07-02)
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
    ## [1] bindrcpp_0.2.2          dplyr_0.7.6             recidivismsl_0.0.0.9000
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] magic_1.5-8        ddalpha_1.3.4      tidyr_0.8.1       
    ##  [4] sfsmisc_1.1-2      splines_3.5.1      foreach_1.4.4     
    ##  [7] prodlim_2018.04.18 assertthat_0.2.0   stats4_3.5.1      
    ## [10] DRR_0.0.3          yaml_2.1.19        robustbase_0.93-1 
    ## [13] ipred_0.9-6        pillar_1.2.3       backports_1.1.2   
    ## [16] lattice_0.20-35    glue_1.2.0         pROC_1.12.1       
    ## [19] digest_0.6.15      colorspace_1.3-2   recipes_0.1.3     
    ## [22] htmltools_0.3.6    Matrix_1.2-14      plyr_1.8.4        
    ## [25] psych_1.8.4        timeDate_3043.102  pkgconfig_2.0.1   
    ## [28] devtools_1.13.6    CVST_0.2-2         broom_0.4.5       
    ## [31] caret_6.0-80       purrr_0.2.5        scales_0.5.0      
    ## [34] gower_0.1.2        lava_1.6.2         furniture_1.7.9   
    ## [37] tibble_1.4.2       ggplot2_3.0.0      withr_2.1.2       
    ## [40] nnet_7.3-12        lazyeval_0.2.1     mnormt_1.5-5      
    ## [43] survival_2.42-3    magrittr_1.5       memoise_1.1.0     
    ## [46] evaluate_0.10.1    nlme_3.1-137       MASS_7.3-50       
    ## [49] xml2_1.2.0         dimRed_0.1.0       foreign_0.8-70    
    ## [52] class_7.3-14       ggthemes_3.5.0     tools_3.5.1       
    ## [55] stringr_1.3.1      kernlab_0.9-26     munsell_0.5.0     
    ## [58] pls_2.6-0          compiler_3.5.1     RcppRoll_0.3.0    
    ## [61] rlang_0.2.1        grid_3.5.1         iterators_1.0.9   
    ## [64] rmarkdown_1.10     testthat_2.0.0     geometry_0.3-6    
    ## [67] gtable_0.2.0       ModelMetrics_1.1.0 codetools_0.2-15  
    ## [70] abind_1.4-5        roxygen2_6.0.1     reshape2_1.4.3    
    ## [73] R6_2.2.2           lubridate_1.7.4    knitr_1.20        
    ## [76] bindr_0.1.1        commonmark_1.5     rprojroot_1.3-2   
    ## [79] stringi_1.1.7      parallel_3.5.1     Rcpp_0.12.17      
    ## [82] rpart_4.1-13       DEoptimR_1.0-8     tidyselect_0.2.4
