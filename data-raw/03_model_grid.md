Create `model_grid`
================
Benny Salo
2018-08-16

Here we create the data frame `model_grid`. It describes all the models we want to run. We will select subsets of this models grid when when training using different algorithms.

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

Define the levels of outcomes, predictors, and model\_type. Convert these vectors into factors with levels in the preferred order.

``` r
outcomes_m   <- c("General recidivism", "Violent recidivism")

predictors_m <- c("Rita-items", 
                  "Static",
                  "All at start of sentence",
                  "All including term")

model_type_m <- c("Logistic regression", 
                  "Elastic net",
                  "Random forest")
                  
analysis_m   <- c("Main analyses")


model_grid_mains  <- expand.grid(outcomes_m,
                                 predictors_m,
                                 model_type_m,
                                 analysis_m,
                                 stringsAsFactors = FALSE)
```

Create `model_grid_dims`
------------------------

``` r
outcomes_d   <- c("General recidivism", "Violent recidivism")

predictors_d <- c("Alcohol problem",
                "Resistance to change",
                "Employment problems",
                "Problems managing economy",
                "Aggressiveness",
                "Current drug use and its effects")

model_type_d  <-  "Logistic regression"

analysis_d    <-  "Dimension analyses"


model_grid_dims <- expand.grid(outcomes_d,
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

Write compact model names

``` r
#Intitate new columns
model_grid$outc_ <- vector("character", length = nrow(model_grid))
model_grid$pred_ <- vector("character", length = nrow(model_grid))
model_grid$modty <- vector("character", length = nrow(model_grid))

# Model name begins with abbreviation of outcome (gen_ or vio_)
model_grid$outc_[model_grid$outcome == "General recidivism"]     <- "gen_"
model_grid$outc_[model_grid$outcome == "Violent recidivism"]     <- "vio_"

# Continue with abbreviation of predictors
model_grid$pred_[model_grid$predictors == 
                  "Alcohol problem"]                   <- "alcohol_"
model_grid$pred_[model_grid$predictors == 
                  "Resistance to change"]              <-"change_"
model_grid$pred_[model_grid$predictors == 
                  "Employment problems"]               <- "employment_"
model_grid$pred_[model_grid$predictors == 
                  "Problems managing economy"]         <- "economy_"
model_grid$pred_[model_grid$predictors ==
                  "Aggressiveness"]                    <- "aggression_"
model_grid$pred_[model_grid$predictors == 
                  "Current drug use and its effects"]  <- "drugs_"

model_grid$pred_[model_grid$predictors == "Rita-items"]<- "rita_"
model_grid$pred_[model_grid$predictors == "Static"]    <- "stat_"
model_grid$pred_[model_grid$predictors == 
                   "All at start of sentence"]         <- "bgnn_"
model_grid$pred_[model_grid$predictors == 
                   "All including term"]               <- "allp_"

# End with model type
model_grid$modty[model_grid$model_type == "Logistic regression"] <- "glm"
model_grid$modty[model_grid$model_type == "Elastic net"]         <- "glmnet"
model_grid$modty[model_grid$model_type == "Random forest"]       <- "rf"

# Paste them together to a model name
model_grid <- model_grid %>% 
  mutate(model_name = paste0(outc_, pred_, modty)) %>% 
  # Delete auxilliary columns created above
  select(-outc_, -pred_, -modty)
```

Add columns of character strings for outcome (lhs)

``` r
# Intiate columns
model_grid$lhs <- vector("character", length = nrow(model_grid))

# Write lhs based on outcome
model_grid$lhs[model_grid$outcome == "General recidivism"] <- 
  "reoffenceThisTerm"
model_grid$lhs[model_grid$outcome == "Violent recidivism"] <- 
  "newO_violent"
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
model_grid$rhs[model_grid$predictors == "Rita-items"] <- 
  list(predset_RITA)
model_grid$rhs[model_grid$predictors == "Static"] <- 
  list(predset_static)
model_grid$rhs[model_grid$predictors == "All at start of sentence"] <-        
  list(predset_begin)
model_grid$rhs[model_grid$predictors == "All including term"] <- 
  list(predset_all)

model_grid$rhs[model_grid$predictors == "Alcohol problem"] <-
  "sum_alcohol_problems"                  
model_grid$rhs[model_grid$predictors == "Resistance to change"] <-
  "sum_alcohol_problems"
model_grid$rhs[model_grid$predictors == "Employment problems"] <-
  "sum_employment_probl"
model_grid$rhs[model_grid$predictors == "Problems managing economy"] <-
  "sum_economy_problems" 
model_grid$rhs[model_grid$predictors == "Aggressiveness"] <-
  "sum_aggressiveness"
model_grid$rhs[model_grid$predictors == "Current drug use and its effects"] <-
  "sum_current_drug_probl"
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

Save and make available in `/data`

``` r
devtools::use_data(model_grid, overwrite = TRUE)
```

Extract model names of main analyses. Used to filter out results for main analyses in /analyses\_of\_results

``` r
model_names_main <-
  model_grid %>%
  filter(analysis == "Main analyses") %>%
  select(model_name) %>% 
  purrr::as_vector(.type = "character") 

names(model_names_main) <- NULL

devtools::use_data(model_names_main, overwrite = TRUE)
```

    ## Saving model_names_main as model_names_main.rda to C:/Users/benny_000/Dropbox/AAAKTUELLT/Manuskript 2/A- R -project/data
