# Predictors of recidivism in Finland
Analyses for a study comparing the power of dynamic and static risk factors to predict recidivism in Finland. We use elastic net logistic regression and random forest as supervised learning methods to allow for the possibility that different sets of predictors work better with either algorithm. 

A preprint is available at https://psyarxiv.com/v5uq3/ . The current manuscript is a revised version that is currently being rewritten according to reviewer suggestions.

Files follow a R package structure with the following specification:

* Analyses that require data that we are not able to make public can be found in /data-raw.
* Analyses that can be run using the results we provide (in /data) can be found in /analyses_of_results. These include analyses of discrimination and calibration plus descriptive statistics for all variables. The descriptive statistics as an extention to Table 2 in the revised manuscript can be accessed through [this link](analyses_of_results/descriptive_statistics.md).


