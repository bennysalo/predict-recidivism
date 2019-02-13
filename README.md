# Predictors of recidivism in Finland
Analyses for a study comparing the power of dynamic and static risk factors to predict recidivism in Finland. We use elastic net logistic regression and random forest as supervised learning methods and allow for the possibility that different sets of predictors work better with either algorithm. 

A preprint is available at https://psyarxiv.com/v5uq3/ . The current manuscript is a revised version that is currently being rewritten according to reviewer suggestions.

Files follow a R package structure with the following specification:

* Analyses that require data that we are not able to make public can be found in /data-raw.
* Analyses that can be run using the results we provide (in /data) can be found in /analyses_of_results. These include analyses of discrimination and calibration plus descriptive statistics for all variables. 

The manuscript specifically mentions the following to be found on these pages

* Descriptive statistics as an extension to Table 1 in the revised manuscript can be accessed through [this link](analyses_of_results/table_1_desciptive_statistics.md).
* The process for choosing tuning parameters and R packages used are documented [here](computational_details.pdf) 

(Updated 2019-02-13)


