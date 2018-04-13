# Predictors of recidivism in Finland
Analyses for a study comparing the power of dynamic and static risk factors to predict recidivism in Finland. We use elastic net logistic regression and random forest as supervised learning methods to allow for the possibility that different sets of predictors work better with either algorithm. This study is currently under peer review and under revision (2018-04-13).

Current version can be found as a preprint on https://psyarxiv.com/v5uq3/

I am currently restructuring the files into a R package structure for clearer presentation and better reproducibility. 

* Analyses that require data that we are not able to make public will be found in /data-raw.
* Analyses that can be run using the results we provide (in /data) will be found in /vignettes. These include analyses of predictive performance based on estimated probabilities from the different models and the observed outcome.

Analyses in their previous form is, for now, found in /analyses.
