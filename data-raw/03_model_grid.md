Create `model_grid`
================
Benny Salo
2019-02-13

Here we create the data frame `model_grid`. It describes, and helps keep track of, all the models we want to run. We will select subsets of this models grid when training using different algorithms.

We first create a model grid for the main analyses and then a model grid for the analyses with single RITA-factors as predictors. We then combine these two to a single grid.

Setup. Load packages.
---------------------

``` r
rm(list = ls())
devtools::load_all(".") # Loading recidivismsl
library(dplyr)
```

Define the possible factor levels for the model characteristics:

``` r
outcomes   <- c("General recidivism", "Violent recidivism")

predictors <- c("Rita-items", 
                "Static", 
                "All at start of sentence", 
                "All including term",
                
                "Alcohol problem",
                "Resistance to change",
                "Employment problems",
                "Problems managing economy",
                "Aggressiveness",
                "Current drug use and its effects")

model_type  <- c("Logistic regression", 
                 "Elastic net", 
                 "Random forest")

analysis   <- c("Main analyses", "Dimension analyses")
```

Create `model_grid_mains`
-------------------------

``` r
analysis_m   <- c("Main analyses")

predictors_m <- c("Rita-items", 
                  "Static", 
                  "All at start of sentence", 
                  "All including term")

model_grid_mains  <- expand.grid(outcomes,
                                 predictors_m,
                                 model_type,
                                 analysis_m,
                                 stringsAsFactors = FALSE)
```

Create `model_grid_dims`
------------------------

``` r
predictors_d <- c("Alcohol problem",
                "Resistance to change",
                "Employment problems",
                "Problems managing economy",
                "Aggressiveness",
                "Current drug use and its effects")

model_type_d  <-  "Logistic regression"

analysis_d    <-  "Dimension analyses"


model_grid_dims <- expand.grid(outcomes,
                               predictors_d,
                               model_type_d,
                               analysis_d,
                               stringsAsFactors = FALSE)
```

Combine and name columns

``` r
model_grid <- dplyr::bind_rows(model_grid_mains, model_grid_dims)

colnames(model_grid) <- c("outcome", "predictors",
                          "model_type", "analysis")
```

Write a columns with compact model names of the style "outc\_pred\_modty". Start with writing three columns (outc\_, pred\_, and modty) that are later pasted to one.

``` r
#Intitate new columns
model_grid$outc_ <- vector("character", length = nrow(model_grid))
model_grid$pred_ <- vector("character", length = nrow(model_grid))
model_grid$modty <- vector("character", length = nrow(model_grid))

# Model name begins with abbreviation of outcome (gen_ or vio_)
outc_ <- c("General recidivism" = "gen_", 
           "Violent recidivism" = "vio_")

model_grid$outc_ <- outc_[model_grid$outcome]


# continues with a abbreviation for predictor set
pred_ <- c(
  "Alcohol problem" = "alcohol_",
  "Resistance to change" = "change_",
  "Employment problems" = "employment_",
  "Problems managing economy" = "economy_",
  "Aggressiveness" = "aggression_",
  "Current drug use and its effects" = "drugs_",
  "Rita-items" = "rita_",
  "Static" = "stat_",
  "All at start of sentence" = "bgnn_",
  "All including term" = "allp_"
  )

model_grid$pred_ <- pred_[model_grid$predictors]

# And ends with the model type / algorithm
modty <- c(
  "Logistic regression" = "glm",
  "Elastic net" = "glmnet",
  "Random forest" = "rf"
  )

model_grid$modty <- modty[model_grid$model_type]


# Paste them together to a model name
model_grid <- 
  model_grid %>% 
  mutate(model_name = paste0(outc_, pred_, modty)) %>% 
  # Delete auxilliary columns created above
  select(-outc_, -pred_, -modty)
```

Add columns of character strings for outcome (lhs)

``` r
# Intiate columns
model_grid$lhs <- vector("character", length = nrow(model_grid))

lhs <- c("General recidivism" = "reoffenceThisTerm",
         "Violent recidivism" = "newO_violent")

model_grid$lhs <- lhs[model_grid$outcome]
```

Add columns of character strings for predictors (rhs). First, extract sets of predictors from the predefined variable table.

``` r
predset_static <- 
  variable_table$Variable[variable_table$Role ==     "predictor_static"]

predset_RITA   <- 
  variable_table$Variable[variable_table$Role ==     "predictor_dynamic"]

predset_begin  <- 
  variable_table$Variable[variable_table$Role %in% c("predictor_static",
                                                     "predictor_dynamic")]

predset_all  <- 
  variable_table$Variable[variable_table$Role %in% c("predictor_static",
                                                     "predictor_dynamic",
                                                     "predictor_term")]
```

Then add these sets to the column `rhs` in model\_grid.

``` r
model_grid$rhs <- vector("list", length = nrow(model_grid))

rhs <- list(
  "Rita-items" = predset_RITA,
  "Static" = predset_static,
  "All at start of sentence" = predset_begin,
  "All including term" = predset_all,
  "Alcohol problem" = "sum_alcohol_problems",
  "Resistance to change" = "sum_resistance_change",
  "Employment problems" = "sum_employment_probl",
  "Problems managing economy" = "sum_economy_problems",
  "Aggressiveness" = "sum_aggressiveness",
  "Current drug use and its effects" = "sum_current_drug_probl"
)

model_grid$rhs <- rhs[model_grid$predictors]
```

Assertions

``` r
# Total rows should be:
# Main analyses:     2 outcomes x 4 predictor sets x 3 model types = 24
# Dimension analyes: 2 outcomes x 6 predictors     x 1 model type  = 12
# Total 36 rows
stopifnot(nrow(model_grid) == 36)

# Dimension analyses should have only 1 predictor
dim_an <- model_grid %>% filter(analysis == "Dimension analyses")
stopifnot(all(
  purrr::map_dbl(dim_an$rhs, length) == 1))

# When rita items are predictors there should be 52 of them
rita_an <- model_grid %>% filter(stringr::str_detect(model_name, "_rita_"))
stopifnot(all(
  purrr::map_dbl(rita_an$rhs, length) == 52))

# When static items are predictors there should be 24 of them
stat_an <- model_grid %>% filter(stringr::str_detect(model_name, "_stat_"))
stopifnot(all(
  purrr::map_dbl(stat_an$rhs, length) == 24))

# When model name has 'bgnn' in the middle the number of predictors should be 
# 52 + 24
bgnn_ans <- model_grid %>% filter(stringr::str_detect(model_name, "_bgnn_"))
stopifnot(all(
  purrr::map_dbl(bgnn_ans$rhs, length) == 52 + 24))

# When model name has 'allp' in the middle the number of predictors should be 
# 52 + 24 + 5
bgnn_ans <- model_grid %>% filter(stringr::str_detect(model_name, "_allp_"))
stopifnot(all(
  purrr::map_dbl(bgnn_ans$rhs, length) == 52 + 24 + 5))

# No missing values in any column
stopifnot(!all(purrr::map_lgl(model_grid, anyNA))) 
```

Explicitly set order of levels in factors.

``` r
model_grid <- 
  model_grid %>%
  mutate(
    outcome = 
      factor(outcome, 
             levels = c("General recidivism",
                        "Violent recidivism")), 
    predictors = 
      factor(
        predictors,
        levels = c("All including term",
                   "All at start of sentence",
                   "Static",
                   "Rita-items",
                   "Aggressiveness",
                   "Alcohol problem",
                   "Employment problems",
                   "Problems managing economy",
                   "Resistance to change")), 
    model_type = 
      factor(model_type,
             levels = c("Logistic regression",
                        "Elastic net",
                        "Random forest"))
    )
```

Save and make available in `/data`

``` r
usethis::use_data(model_grid, overwrite = TRUE)
```

    ## <U+2714> Setting active project to 'C:/Users/benny_000/OneDrive - United Nations/z-PhD/Manuskript 2/A- R -project'
    ## <U+2714> Saving 'model_grid' to 'data/model_grid.rda'

Extract model names of main analyses. Used to filter out results for main analyses in /analyses\_of\_results

``` r
model_names_main <-
  model_grid %>%
  filter(analysis == "Main analyses") %>%
  select(model_name) %>% 
  purrr::as_vector(.type = "character") 

# This should not be a named vector
names(model_names_main) <- NULL

usethis::use_data(model_names_main, overwrite = TRUE)
```

    ## <U+2714> Saving 'model_names_main' to 'data/model_names_main.rda'
