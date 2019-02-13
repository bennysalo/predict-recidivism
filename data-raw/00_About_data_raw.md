---
title: "Training models"
author: "Benny Salo"
date: "2019-02-11"
output: github_document
---

The notebooks in this folder (/data_raw) contain analyses that produces the published data.

The folder is organized according to sequntial tasks in the analyzes. Broadly tasks 1-4 are setup, task 5 is training, and task 6 and 7 are collecting results.

   1. Cleans up the data and does some checks on the distibution of follow-up time
   2. Sets up a table of the variables used. This can be used as reference but is also used to define the sets of predictors to include per model.
   3. Sets up a table of the different models trained - a model grid. Again this can be used as reference, but is also used to define the trained models in the script.
   4. Sets up the four control functions that correspond to four training steps and are used in the training scripts to define the folds and what summaries to calculate.
   5. Does the training it self. It is done in up to four steps (see below) and is diveded in
      a) logistic regression models
      b) elastic net models, and
      c) random forest models.
   6. Extracts the relevant model performance figures within the trained models and make them available publicly.
   7. Tests the preformance of the trained models on a seperate test set and make the results available.
   
   
The four training steps in task 5 are not all needed for each algoritm type. We perform all four steps only for the elastic net models. For elastic net these are as follows.
   1. Run a quick training script with 2 repeats of 4 folds to get qualifying combinations of tuning parameter alpha and lambda. Combinations that have poorer logloss values than the best model in all 8 folds are disqualified from further analyses. This speeds up the later training steps by excluding combinations that are unlikely to produce the best trained models.
   2. Run a training script with 25 repeats of 4 folds (100 folds in total) to find the tuning parameters with the best logLoss values.
   3. Rerun the chosen model based on (2) on the 100 folds in (2) with the best tuning parameters extracting calibration statistics. (The summary function that exctracts calibration statistics is slow and demands a lot of memory, thus we chose to run it only on the chosen tuning parameters.)
   4. Rerun the chosen model based on (2) on 250 repeats of 4 folds to get more reliable values that allow calculating percentile confidence intervals for discrimination statistics. (Calibration statistics are not calculated here.)



