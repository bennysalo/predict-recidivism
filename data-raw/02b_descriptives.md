Descriptive statistics
================
Benny Salo
2018-07-05

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
