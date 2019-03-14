Creating data/variable\_table.rda
================
Benny Salo
2019-03-14

``` r
variable_table <- 
  readr::read_delim("variable_table.csv",
                    ";",
                    escape_double = FALSE,
                    trim_ws = TRUE)

usethis::use_data(variable_table, overwrite = TRUE)
```


