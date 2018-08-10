Data used for this project
================
Benny Salo
2018-08-09

``` r
devtools::load_all(".")
library(dplyr)
```

Load raw data. At this point we are not authorized to make raw data publicly available. `FinPrisonMales.rds` includes only males.

Update data file in "/not\_public"

``` r
devtools::wd()
source("not_public/get_copy_of_FinPrisonData.R")
```

``` r
rm(list = ls())
devtools::wd()
FinPrisonMales <- 
  readRDS("not_public/FinPrisonData.rds") %>% 
  filter(gender == "male")

stopifnot(sum(FinPrisonMales$gender == "male") == nrow(FinPrisonMales))
```

We define a violent crime as crimes that belong to the homicide or assault categories. Other offence categories include offences that are violent and offences that are not violent. In many cases the violent forms are also coded as assault.

We create variables for new violent crime

``` r
analyzed_data <- 
  FinPrisonMales %>% 
  mutate(newO_violent = as.factor(ifelse(newO_homicide == 1 | newO_assault == 1, 
                                         "new_violent_crime", 
                                         "no_crime_or_not_violent")),
         newO_violent = relevel(newO_violent, ref ="no_crime_or_not_violent"))


table(analyzed_data$newO_violent)
```

    ## 
    ## no_crime_or_not_violent       new_violent_crime 
    ##                    1218                     278

``` r
table(analyzed_data$newO_violent)/nrow(analyzed_data)
```

    ## 
    ## no_crime_or_not_violent       new_violent_crime 
    ##               0.8141711               0.1858289

Of the 748 new convictions 278 are categorized as prison terms for violent crimes.

For descriptive statistics we also want a variable that represents category of reoffending as a single variable with levels "no reoffence", "non-violent reoffence", and "violent reoffence".

``` r
# Get indices
no_reoff_i      <- 
  which(analyzed_data$reoffenceThisTerm == "not_in_prison")

non_vio_reoff_i <- 
  which(analyzed_data$reoffenceThisTerm == "new_prison_sentence" &
          analyzed_data$newO_violent == "no_crime_or_not_violent")

vio_reoff_i     <-
  which(analyzed_data$newO_violent == "new_violent_crime")

# Assert that all rows are accounted for
assertthat::assert_that(
  identical(sort(c(no_reoff_i, non_vio_reoff_i, vio_reoff_i)),
            1:nrow(analyzed_data))
)
```

    ## [1] TRUE

``` r
analyzed_data$reoff_category[no_reoff_i]      <- "no_reoffence"
analyzed_data$reoff_category[non_vio_reoff_i] <- "reoffence_nonviolent"
analyzed_data$reoff_category[vio_reoff_i]     <- "reoffence_violent"

analyzed_data$reoff_category <- factor(analyzed_data$reoff_category)
```

Check follow-up time
====================

Compare distributions in follow-up time between those who committed a new crime and those who did not.

``` r
followUp_G_yes <- analyzed_data[
  analyzed_data$reoffenceThisTerm == "new_prison_sentence",
  "followUpYears"]

followUp_G_no <- analyzed_data[
  analyzed_data$reoffenceThisTerm == "not_in_prison",
  "followUpYears"]

followUp_V_yes <- analyzed_data[
  analyzed_data$newO_violent == "new_violent_crime",
  "followUpYears"]

followUp_V_no <- analyzed_data[
  analyzed_data$newO_violent == "no_crime_or_not_violent",
  "followUpYears"]
  
  
qqplot(followUp_G_yes, followUp_G_no)
```

![](01_analyzed_data_files/figure-markdown_github/unnamed-chunk-6-1.png)

``` r
qqplot(followUp_V_yes, followUp_V_no)
```

![](01_analyzed_data_files/figure-markdown_github/unnamed-chunk-6-2.png)

The similarity of distributions is close to perfect for general recidivism and very good for violent recidivism.

Check means and standard deviations

``` r
analyzed_data %>% 
  group_by(reoffenceThisTerm) %>% 
  summarise(M = mean(followUpYears),
            SD = sd(followUpYears))
```

    ## # A tibble: 2 x 3
    ##   reoffenceThisTerm       M    SD
    ##   <fct>               <dbl> <dbl>
    ## 1 not_in_prison        3.66  1.04
    ## 2 new_prison_sentence  3.65  1.05

``` r
analyzed_data %>% 
  group_by(newO_violent) %>% 
  summarise(M = mean(followUpYears),
            SD = sd(followUpYears))
```

    ## # A tibble: 2 x 3
    ##   newO_violent                M    SD
    ##   <fct>                   <dbl> <dbl>
    ## 1 no_crime_or_not_violent  3.65  1.04
    ## 2 new_violent_crime        3.70  1.05

Time to offence
===============

``` r
median(analyzed_data$daysToNewO, na.rm = TRUE) 
```

    ## [1] 101.8333

``` r
max(analyzed_data$daysToNewO, na.rm = TRUE) 
```

    ## [1] 1321

``` r
sum(analyzed_data$daysToNewO <= 365, na.rm = TRUE) /748
```

    ## [1] 0.8395722

``` r
# Proportion under 1 year
median(analyzed_data$followUpYears)
```

    ## [1] 3.687886

``` r
min(analyzed_data$followUpYears)
```

    ## [1] 0.4928142

``` r
max(analyzed_data$followUpYears)
```

    ## [1] 5.828885

Split data into a training set and a test set
=============================================

``` r
set.seed(3010)
four_folds   <- caret::createFolds(y = analyzed_data$reoffenceThisTerm, k = 4)

training_set <- analyzed_data[!(1:nrow(analyzed_data) %in% four_folds[[4]]), ]
test_set     <- analyzed_data[ (1:nrow(analyzed_data) %in% four_folds[[4]]), ]

nrow(training_set)
```

    ## [1] 1122

``` r
nrow(test_set)
```

    ## [1] 374

Save data for later use.
========================

Will not be made public.

``` r
devtools::wd()
saveRDS(analyzed_data, "not_public/analyzed_data.rds")
saveRDS(training_set, "not_public/training_set.rds")
saveRDS(test_set,     "not_public/test_set.rds")
```

Display sessionInfo.

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
    ## [10] DRR_0.0.3          yaml_2.2.0         robustbase_0.93-2 
    ## [13] ipred_0.9-6        pillar_1.3.0       backports_1.1.2   
    ## [16] lattice_0.20-35    glue_1.3.0         pROC_1.12.1       
    ## [19] digest_0.6.15      colorspace_1.3-2   recipes_0.1.3     
    ## [22] htmltools_0.3.6    Matrix_1.2-14      plyr_1.8.4        
    ## [25] timeDate_3043.102  pkgconfig_2.0.1    devtools_1.13.6   
    ## [28] CVST_0.2-2         broom_0.5.0        caret_6.0-80      
    ## [31] purrr_0.2.5        scales_0.5.0       gower_0.1.2       
    ## [34] lava_1.6.2         tibble_1.4.2       ggplot2_3.0.0     
    ## [37] withr_2.1.2        nnet_7.3-12        lazyeval_0.2.1    
    ## [40] cli_1.0.0          survival_2.42-3    magrittr_1.5      
    ## [43] crayon_1.3.4       memoise_1.1.0      evaluate_0.11     
    ## [46] fansi_0.2.3        nlme_3.1-137       MASS_7.3-50       
    ## [49] xml2_1.2.0         dimRed_0.1.0       class_7.3-14      
    ## [52] ggthemes_4.0.0     tools_3.5.1        stringr_1.3.1     
    ## [55] kernlab_0.9-26     munsell_0.5.0      pls_2.6-0         
    ## [58] compiler_3.5.1     RcppRoll_0.3.0     rlang_0.2.1       
    ## [61] grid_3.5.1         iterators_1.0.10   rmarkdown_1.10    
    ## [64] testthat_2.0.0     geometry_0.3-6     gtable_0.2.0      
    ## [67] ModelMetrics_1.1.0 codetools_0.2-15   abind_1.4-5       
    ## [70] roxygen2_6.1.0     reshape2_1.4.3     R6_2.2.2          
    ## [73] lubridate_1.7.4    knitr_1.20         utf8_1.1.4        
    ## [76] bindr_0.1.1        commonmark_1.5     rprojroot_1.3-2   
    ## [79] stringi_1.1.7      Rcpp_0.12.18       rpart_4.1-13      
    ## [82] DEoptimR_1.0-8     tidyselect_0.2.4
