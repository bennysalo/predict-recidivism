Setup of `ctrl_fun_training`
================
Benny Salo
2018-07-06

`ctrl_fun_training` is used when training the models. It is passed to `caret::train` and controls, among other things, what the type of cross-validation to use and what discrimination statistics to calculate. Via `index` we also specify what observations will be used in what fold and make training of different models directly comparable.

``` r
devtools::wd()
training_set <- readRDS("not_public/training_set.rds")
```

Create ten repeats of ten folds for cross-validation.

``` r
set.seed(120418)
ten_by_ten_folds <- 
  caret::createMultiFolds(y = training_set$reoffenceThisTerm, k = 10, times = 10)
```

Now set up the cross validation schemes using these folds.

``` r
ctrl_fun_training <- caret::trainControl(
  method = "repeatedcv",
  number = 10,
  repeats = 10,
  summaryFunction = caret::twoClassSummary,
  classProbs = TRUE,
  verboseIter = FALSE,
  savePredictions = "final",
  index = ten_by_ten_folds,
  returnData = FALSE
  )
```

``` r
devtools::use_data(ctrl_fun_training, overwrite = TRUE)
```