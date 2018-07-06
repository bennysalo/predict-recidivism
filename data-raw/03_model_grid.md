Create `model_grid`
================
Benny Salo
2018-07-06

Setup. Load packages.
---------------------

``` r
devtools::load_all(".") # Loading recidivismsl
library(dplyr)
```

Create `model_grid`
-------------------

Define the levels of outcomes, predictors, and model\_type. Convert these vectors into factors with levels in the preferred order.

``` r
outcomes   <- c("General recidivism", "Violent recidivism")
outcomes   <- factor(outcomes, levels = outcomes)

predictors <- c("Rita", "Static", "All at start of sentence", 
                "All including term")
predictors <- factor(predictors, levels = predictors)

model_type <- c("Logistic regression", "Elastic net", "Random forest")
model_type <- factor(model_type, levels = model_type)                   

model_grid           <- expand.grid(outcomes, predictors, model_type, 
                                    stringsAsFactors = FALSE)
colnames(model_grid) <- c("outcome", "predictors", "model_type")
```

Write compact model names

``` r
model_grid$outc_ <- vector("character", length = nrow(model_grid))
model_grid$pred_ <- vector("character", length = nrow(model_grid))
model_grid$modty <- vector("character", length = nrow(model_grid))

model_grid$outc_[model_grid$outcome == "General recidivism"]     <- "gen_"
model_grid$outc_[model_grid$outcome == "Violent recidivism"]     <- "vio_"

model_grid$pred_[model_grid$predictors == "Static"]              <- "stat_"
model_grid$pred_[model_grid$predictors == "Rita"]                <- "rita_"
model_grid$pred_[model_grid$predictors == "All at start of sentence"] <- 
                                                                    "bgnn_"
model_grid$pred_[model_grid$predictors == "All including term"]  <- "allp_"

model_grid$modty[model_grid$model_type == "Logistic regression"] <- "glm"
model_grid$modty[model_grid$model_type == "Elastic net"]         <- "glmnet"
model_grid$modty[model_grid$model_type == "Random forest"]       <- "rf"

model_grid <- model_grid %>% 
  mutate(model_name = paste0(outc_, pred_, modty)) %>% 
  select(-outc_, -pred_, -modty)
```

Add columns of character strings for outcome (lhs)

``` r
model_grid$lhs <- vector("character", length = nrow(model_grid))
model_grid$lhs[model_grid$outcome == "General recidivism"] <- "reoffenceThisTerm"
model_grid$lhs[model_grid$outcome == "Violent recidivism"] <- "newO_violent"
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
model_grid$rhs[model_grid$predictors == "Static"] <- list(predset_static)
model_grid$rhs[model_grid$predictors == "Rita"]   <- list(predset_RITA)
model_grid$rhs[model_grid$predictors == "All at start of sentence"] <- 
                                                     list(predset_begin)
model_grid$rhs[model_grid$predictors == "All including term"] <- 
                                                     list(predset_all)
```

Initiate a column of class `list` to store the results in.

``` r
model_grid$train_result <- vector("list", length = nrow(model_grid))
```

Save and make available in `/data`

``` r
devtools::use_data(model_grid, overwrite = TRUE)
```