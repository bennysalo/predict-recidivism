Data used for this project
================
Benny Salo
2018-03-23

``` r
library(dplyr)
```

Load data including only males. We are not authorized to make raw data publicly available.

``` r
rm(list = ls())
FinPrisonMales <- 
  readRDS("C:/Users/benny_000/Dropbox/AAAKTUELLT/FinPrisonData/FinPrisonMales.rds")
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

Of the 748 new convictions 278 are categorized as prison terms for violent crimes.

Save data. Will not be made public.

``` r
saveRDS(analyzed_data, "analyzed_data.rds")
```
