Creating data/variable\_table.rda
================
Benny Salo
2018-07-05

``` r
devtools::wd()
variable_table <- 
  readr::read_delim("data-raw/variable_table.csv", 
    ";", escape_double = FALSE, trim_ws = TRUE)

devtools::use_data(variable_table, overwrite = TRUE)
```
