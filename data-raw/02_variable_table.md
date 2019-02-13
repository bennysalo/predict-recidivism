---
title: "Creating data/variable_table.rda"
author: "Benny Salo"
date: "2019-02-11"
output: github_document
---


```r
variable_table <- 
  readr::read_delim("variable_table.csv",
                    ";",
                    escape_double = FALSE,
                    trim_ws = TRUE)

usethis::use_data(variable_table, overwrite = TRUE)
```

```
## <U+2714> Saving 'variable_table' to 'data/variable_table.rda'
```

