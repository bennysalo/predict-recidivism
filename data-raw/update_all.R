library(knitr)

devtools::wd(path = "/data-raw")
# All setup
knit("01_analyzed_data.Rmd")
knit("02_variable_table.Rmd")
knit("03_model_grid.Rmd")
knit("04_trainControl.Rmd")

# Train models (long runtime)
knit("05a_train_logistic_regression.Rmd")
knit("05b_train_elastic_net.Rmd")
knit("05c_train_rf.Rmd")

# Output data
knit("06_model_AUCs_training_set.Rmd")
knit("07_test_set_predictions.Rmd")
