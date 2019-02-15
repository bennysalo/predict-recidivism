---
title: "Table 1"
date: "2019-02-15"
output: github_document
---

Mean (and standard deviation) or frequency (and percentage) for all predictors by reoffense category.

This is an extension of Table 1 in the manuscript displaying descriptive statistics for all variables.





```r
knitr::kable(descriptive_stats_preds, format = "markdown")
```



|Variable                                       |No.reoffence |Non.violent.reoffence |Violent.reoffence |Test              |P.Value |
|:----------------------------------------------|:------------|:---------------------|:-----------------|:-----------------|:-------|
|                                               |n = NA       |n = 470               |n = 278           |                  |        |
|Missing info on age at first term              |             |                      |                  |Chi Square: 47.92 |<.001   |
|No                                             |(%)          |293 (62.3%)           |240 (86.3%)       |                  |        |
|Yes                                            |(%)          |177 (37.7%)           |38 (13.7%)        |                  |        |
|Age at first term (missing replaced)           |             |                      |                  |F-Value: 28.43    |<.001   |
|Follow-up in years                             |             |                      |                  |F-Value: 0.91     |0.341   |
|Age at release                                 |             |                      |                  |F-Value: 3.72     |0.054   |
|Missing info on previous sentences             |             |                      |                  |Chi Square: 0.01  |0.925   |
|No                                             |(%)          |458 (97.4%)           |272 (97.8%)       |                  |        |
|Yes                                            |(%)          |12 (2.6%)             |6 (2.2%)          |                  |        |
|Prison terms (missing replaced)                |             |                      |                  |F-Value: 0.4      |0.53    |
|Community service terms (missing replaced)     |             |                      |                  |F-Value: 1.67     |0.197   |
|Remand terms (missing replaced)                |             |                      |                  |F-Value: 1.64     |0.2     |
|Terms for unpaid fines (missing replaced)      |             |                      |                  |F-Value: 0.31     |0.575   |
|Unlawful absence or attempt                    |             |                      |                  |Chi Square: 3.59  |0.058   |
|No escape history                              |(%)          |415 (88.3%)           |231 (83.1%)       |                  |        |
|Unauthorized absence of any kind               |(%)          |55 (11.7%)            |47 (16.9%)        |                  |        |
|Current offence: Homicide                      |             |                      |                  |Chi Square: 6.88  |0.009   |
|No                                             |(%)          |460 (97.9%)           |261 (93.9%)       |                  |        |
|Yes                                            |(%)          |10 (2.1%)             |17 (6.1%)         |                  |        |
|Current offence: Assault                       |             |                      |                  |Chi Square: 3.17  |0.075   |
|No                                             |(%)          |161 (34.3%)           |77 (27.7%)        |                  |        |
|Yes                                            |(%)          |309 (65.7%)           |201 (72.3%)       |                  |        |
|Current offence: Sexual offence                |             |                      |                  |Chi Square: 1.92  |0.165   |
|No                                             |(%)          |462 (98.3%)           |268 (96.4%)       |                  |        |
|Yes                                            |(%)          |8 (1.7%)              |10 (3.6%)         |                  |        |
|Current offence: Offence against authorities   |             |                      |                  |Chi Square: 4.36  |0.037   |
|No                                             |(%)          |420 (89.4%)           |233 (83.8%)       |                  |        |
|Yes                                            |(%)          |50 (10.6%)            |45 (16.2%)        |                  |        |
|Current offence: Other offence against person  |             |                      |                  |Chi Square: 63.82 |<.001   |
|No                                             |(%)          |409 (87%)             |171 (61.5%)       |                  |        |
|Yes                                            |(%)          |61 (13%)              |107 (38.5%)       |                  |        |
|Current offence: Robbery                       |             |                      |                  |Chi Square: 40.46 |<.001   |
|No                                             |(%)          |427 (90.9%)           |203 (73%)         |                  |        |
|Yes                                            |(%)          |43 (9.1%)             |75 (27%)          |                  |        |
|Current offence: Theft                         |             |                      |                  |Chi Square: 20.36 |<.001   |
|No                                             |(%)          |310 (66%)             |136 (48.9%)       |                  |        |
|Yes                                            |(%)          |160 (34%)             |142 (51.1%)       |                  |        |
|Current offence: Auto theft                    |             |                      |                  |Chi Square: 11.46 |<.001   |
|No                                             |(%)          |370 (78.7%)           |187 (67.3%)       |                  |        |
|Yes                                            |(%)          |100 (21.3%)           |91 (32.7%)        |                  |        |
|Current offence: Other property offence        |             |                      |                  |Chi Square: 11.42 |<.001   |
|No                                             |(%)          |364 (77.4%)           |183 (65.8%)       |                  |        |
|Yes                                            |(%)          |106 (22.6%)           |95 (34.2%)        |                  |        |
|Current offence: Criminal damage               |             |                      |                  |Chi Square: 29.58 |<.001   |
|No                                             |(%)          |400 (85.1%)           |189 (68%)         |                  |        |
|Yes                                            |(%)          |70 (14.9%)            |89 (32%)          |                  |        |
|Current offence: Narcotic offence              |             |                      |                  |Chi Square: 0.65  |0.421   |
|No                                             |(%)          |334 (71.1%)           |189 (68%)         |                  |        |
|Yes                                            |(%)          |136 (28.9%)           |89 (32%)          |                  |        |
|Current offence: Unlawful possession of weapon |             |                      |                  |Chi Square: 2.31  |0.129   |
|No                                             |(%)          |394 (83.8%)           |220 (79.1%)       |                  |        |
|Yes                                            |(%)          |76 (16.2%)            |58 (20.9%)        |                  |        |
|Current offence: Traffic offence               |             |                      |                  |Chi Square: 25.79 |<.001   |
|No                                             |(%)          |294 (62.6%)           |120 (43.2%)       |                  |        |
|Yes                                            |(%)          |176 (37.4%)           |158 (56.8%)       |                  |        |
|Current offence: White-collar offence          |             |                      |                  |Chi Square: 0     |1       |
|No                                             |(%)          |466 (99.1%)           |275 (98.9%)       |                  |        |
|Yes                                            |(%)          |4 (0.9%)              |3 (1.1%)          |                  |        |
|Current offence: Other offences                |             |                      |                  |Chi Square: 0.25  |0.618   |
|No                                             |(%)          |462 (98.3%)           |271 (97.5%)       |                  |        |
|Yes                                            |(%)          |8 (1.7%)              |7 (2.5%)          |                  |        |
|Responsibility for offence                     |             |                      |                  |Chi Square: 6.08  |0.048   |
|0                                              |(%)          |181 (38.5%)           |91 (32.7%)        |                  |        |
|1                                              |(%)          |216 (46%)             |125 (45%)         |                  |        |
|2                                              |(%)          |73 (15.5%)            |62 (22.3%)        |                  |        |
|Access to accommodation                        |             |                      |                  |Chi Square: 1.58  |0.454   |
|0                                              |(%)          |230 (48.9%)           |126 (45.3%)       |                  |        |
|1                                              |(%)          |119 (25.3%)           |69 (24.8%)        |                  |        |
|2                                              |(%)          |121 (25.7%)           |83 (29.9%)        |                  |        |
|Suitable accommodation                         |             |                      |                  |Chi Square: 4.91  |0.086   |
|0                                              |(%)          |291 (61.9%)           |150 (54%)         |                  |        |
|1                                              |(%)          |67 (14.3%)            |52 (18.7%)        |                  |        |
|2                                              |(%)          |112 (23.8%)           |76 (27.3%)        |                  |        |
|Management of daily living                     |             |                      |                  |Chi Square: 2.96  |0.227   |
|0                                              |(%)          |348 (74%)             |206 (74.1%)       |                  |        |
|1                                              |(%)          |98 (20.9%)            |50 (18%)          |                  |        |
|2                                              |(%)          |24 (5.1%)             |22 (7.9%)         |                  |        |
|Financial situation                            |             |                      |                  |Chi Square: 2.77  |0.25    |
|0                                              |(%)          |75 (16%)              |43 (15.5%)        |                  |        |
|1                                              |(%)          |155 (33%)             |108 (38.8%)       |                  |        |
|2                                              |(%)          |240 (51.1%)           |127 (45.7%)       |                  |        |
|Managing finances                              |             |                      |                  |Chi Square: 0.69  |0.708   |
|0                                              |(%)          |106 (22.6%)           |70 (25.2%)        |                  |        |
|1                                              |(%)          |207 (44%)             |117 (42.1%)       |                  |        |
|2                                              |(%)          |157 (33.4%)           |91 (32.7%)        |                  |        |
|Obstacles to budgeting                         |             |                      |                  |Chi Square: 0.75  |0.686   |
|0                                              |(%)          |115 (24.5%)           |66 (23.7%)        |                  |        |
|1                                              |(%)          |205 (43.6%)           |130 (46.8%)       |                  |        |
|2                                              |(%)          |150 (31.9%)           |82 (29.5%)        |                  |        |
|Completed compulsory school                    |             |                      |                  |Chi Square: 8.66  |0.003   |
|0                                              |(%)          |417 (88.7%)           |265 (95.3%)       |                  |        |
|2                                              |(%)          |53 (11.3%)            |13 (4.7%)         |                  |        |
|Learning problems                              |             |                      |                  |Chi Square: 2.08  |0.354   |
|0                                              |(%)          |377 (80.2%)           |215 (77.3%)       |                  |        |
|1                                              |(%)          |70 (14.9%)            |52 (18.7%)        |                  |        |
|2                                              |(%)          |23 (4.9%)             |11 (4%)           |                  |        |
|History of remedial teaching                   |             |                      |                  |Chi Square: 0.09  |0.767   |
|0                                              |(%)          |245 (52.1%)           |141 (50.7%)       |                  |        |
|2                                              |(%)          |225 (47.9%)           |137 (49.3%)       |                  |        |
|Attitude to education                          |             |                      |                  |Chi Square: 0.69  |0.708   |
|0                                              |(%)          |299 (63.6%)           |185 (66.5%)       |                  |        |
|1                                              |(%)          |125 (26.6%)           |67 (24.1%)        |                  |        |
|2                                              |(%)          |46 (9.8%)             |26 (9.4%)         |                  |        |
|Work-related qualifications                    |             |                      |                  |Chi Square: 1.91  |0.385   |
|0                                              |(%)          |154 (32.8%)           |79 (28.4%)        |                  |        |
|1                                              |(%)          |169 (36%)             |101 (36.3%)       |                  |        |
|2                                              |(%)          |147 (31.3%)           |98 (35.3%)        |                  |        |
|Employment history                             |             |                      |                  |Chi Square: 2.22  |0.33    |
|0                                              |(%)          |120 (25.5%)           |58 (20.9%)        |                  |        |
|1                                              |(%)          |177 (37.7%)           |108 (38.8%)       |                  |        |
|2                                              |(%)          |173 (36.8%)           |112 (40.3%)       |                  |        |
|Attitude to employment                         |             |                      |                  |Chi Square: 1.69  |0.43    |
|0                                              |(%)          |306 (65.1%)           |172 (61.9%)       |                  |        |
|1                                              |(%)          |123 (26.2%)           |74 (26.6%)        |                  |        |
|2                                              |(%)          |41 (8.7%)             |32 (11.5%)        |                  |        |
|Work application management                    |             |                      |                  |Chi Square: 1.35  |0.51    |
|0                                              |(%)          |322 (68.5%)           |180 (64.7%)       |                  |        |
|1                                              |(%)          |77 (16.4%)            |48 (17.3%)        |                  |        |
|2                                              |(%)          |71 (15.1%)            |50 (18%)          |                  |        |
|Relationship with family                       |             |                      |                  |Chi Square: 1.68  |0.433   |
|0                                              |(%)          |281 (59.8%)           |174 (62.6%)       |                  |        |
|1                                              |(%)          |140 (29.8%)           |71 (25.5%)        |                  |        |
|2                                              |(%)          |49 (10.4%)            |33 (11.9%)        |                  |        |
|Relationship with partner                      |             |                      |                  |Chi Square: 5.32  |0.07    |
|0                                              |(%)          |364 (77.4%)           |216 (77.7%)       |                  |        |
|1                                              |(%)          |84 (17.9%)            |39 (14%)          |                  |        |
|2                                              |(%)          |22 (4.7%)             |23 (8.3%)         |                  |        |
|Domestic violence, offender                    |             |                      |                  |Chi Square: 25.96 |<.001   |
|0                                              |(%)          |367 (78.1%)           |189 (68%)         |                  |        |
|1                                              |(%)          |72 (15.3%)            |37 (13.3%)        |                  |        |
|2                                              |(%)          |31 (6.6%)             |52 (18.7%)        |                  |        |
|Domestic violence, victim                      |             |                      |                  |Chi Square: 3.82  |0.148   |
|0                                              |(%)          |381 (81.1%)           |213 (76.6%)       |                  |        |
|1                                              |(%)          |66 (14%)              |42 (15.1%)        |                  |        |
|2                                              |(%)          |23 (4.9%)             |23 (8.3%)         |                  |        |
|Parenting skills                               |             |                      |                  |Chi Square: 0.37  |0.833   |
|0                                              |(%)          |326 (69.4%)           |198 (71.2%)       |                  |        |
|1                                              |(%)          |82 (17.4%)            |44 (15.8%)        |                  |        |
|2                                              |(%)          |62 (13.2%)            |36 (12.9%)        |                  |        |
|Criminal associates                            |             |                      |                  |Chi Square: 2.42  |0.299   |
|0                                              |(%)          |68 (14.5%)            |49 (17.6%)        |                  |        |
|1                                              |(%)          |241 (51.3%)           |147 (52.9%)       |                  |        |
|2                                              |(%)          |161 (34.3%)           |82 (29.5%)        |                  |        |
|Manipulative lifestyle                         |             |                      |                  |Chi Square: 0.99  |0.61    |
|0                                              |(%)          |308 (65.5%)           |175 (62.9%)       |                  |        |
|1                                              |(%)          |118 (25.1%)           |71 (25.5%)        |                  |        |
|2                                              |(%)          |44 (9.4%)             |32 (11.5%)        |                  |        |
|Risk-seeking behaviour                         |             |                      |                  |Chi Square: 1.54  |0.462   |
|0                                              |(%)          |114 (24.3%)           |75 (27%)          |                  |        |
|1                                              |(%)          |257 (54.7%)           |139 (50%)         |                  |        |
|2                                              |(%)          |99 (21.1%)            |64 (23%)          |                  |        |
|Easily influenced                              |             |                      |                  |Chi Square: 2.53  |0.282   |
|0                                              |(%)          |346 (73.6%)           |219 (78.8%)       |                  |        |
|1                                              |(%)          |102 (21.7%)           |49 (17.6%)        |                  |        |
|2                                              |(%)          |22 (4.7%)             |10 (3.6%)         |                  |        |
|Alcohol use frequency                          |             |                      |                  |Chi Square: 16.32 |<.001   |
|0                                              |(%)          |170 (36.2%)           |62 (22.3%)        |                  |        |
|1                                              |(%)          |152 (32.3%)           |102 (36.7%)       |                  |        |
|2                                              |(%)          |148 (31.5%)           |114 (41%)         |                  |        |
|Alcohol with medicine misuse                   |             |                      |                  |Chi Square: 14.64 |<.001   |
|0                                              |(%)          |303 (64.5%)           |140 (50.4%)       |                  |        |
|1                                              |(%)          |49 (10.4%)            |44 (15.8%)        |                  |        |
|2                                              |(%)          |118 (25.1%)           |94 (33.8%)        |                  |        |
|Alcohol-related offenses                       |             |                      |                  |Chi Square: 27.06 |<.001   |
|0                                              |(%)          |148 (31.5%)           |42 (15.1%)        |                  |        |
|1                                              |(%)          |122 (26%)             |75 (27%)          |                  |        |
|2                                              |(%)          |200 (42.6%)           |161 (57.9%)       |                  |        |
|Alcohol-induced violence                       |             |                      |                  |Chi Square: 47.54 |<.001   |
|0                                              |(%)          |174 (37%)             |48 (17.3%)        |                  |        |
|1                                              |(%)          |142 (30.2%)           |73 (26.3%)        |                  |        |
|2                                              |(%)          |154 (32.8%)           |157 (56.5%)       |                  |        |
|Effects of alcohol on daily living             |             |                      |                  |Chi Square: 4.28  |0.117   |
|0                                              |(%)          |208 (44.3%)           |102 (36.7%)       |                  |        |
|1                                              |(%)          |148 (31.5%)           |96 (34.5%)        |                  |        |
|2                                              |(%)          |114 (24.3%)           |80 (28.8%)        |                  |        |
|Effects of alcohol on health                   |             |                      |                  |Chi Square: 1.71  |0.425   |
|0                                              |(%)          |381 (81.1%)           |235 (84.5%)       |                  |        |
|1                                              |(%)          |66 (14%)              |30 (10.8%)        |                  |        |
|2                                              |(%)          |23 (4.9%)             |13 (4.7%)         |                  |        |
|Effects of alcohol on relationships            |             |                      |                  |Chi Square: 10.62 |0.005   |
|0                                              |(%)          |217 (46.2%)           |97 (34.9%)        |                  |        |
|1                                              |(%)          |180 (38.3%)           |119 (42.8%)       |                  |        |
|2                                              |(%)          |73 (15.5%)            |62 (22.3%)        |                  |        |
|Motivation to tackle alcohol misuse            |             |                      |                  |Chi Square: 7.3   |0.026   |
|0                                              |(%)          |343 (73%)             |177 (63.7%)       |                  |        |
|1                                              |(%)          |91 (19.4%)            |70 (25.2%)        |                  |        |
|2                                              |(%)          |36 (7.7%)             |31 (11.2%)        |                  |        |
|History of drug abuse                          |             |                      |                  |Chi Square: 8.54  |0.014   |
|0                                              |(%)          |65 (13.8%)            |51 (18.3%)        |                  |        |
|1                                              |(%)          |38 (8.1%)             |36 (12.9%)        |                  |        |
|2                                              |(%)          |367 (78.1%)           |191 (68.7%)       |                  |        |
|Drug use frequency                             |             |                      |                  |Chi Square: 8.8   |0.012   |
|0                                              |(%)          |297 (63.2%)           |145 (52.2%)       |                  |        |
|1                                              |(%)          |63 (13.4%)            |48 (17.3%)        |                  |        |
|2                                              |(%)          |110 (23.4%)           |85 (30.6%)        |                  |        |
|Intravenous drug use                           |             |                      |                  |Chi Square: 10.12 |0.006   |
|0                                              |(%)          |307 (65.3%)           |149 (53.6%)       |                  |        |
|1                                              |(%)          |11 (2.3%)             |8 (2.9%)          |                  |        |
|2                                              |(%)          |152 (32.3%)           |121 (43.5%)       |                  |        |
|Drug-related offenses                          |             |                      |                  |Chi Square: 14.74 |<.001   |
|0                                              |(%)          |307 (65.3%)           |154 (55.4%)       |                  |        |
|1                                              |(%)          |37 (7.9%)             |46 (16.5%)        |                  |        |
|2                                              |(%)          |126 (26.8%)           |78 (28.1%)        |                  |        |
|Drug-induced violence                          |             |                      |                  |Chi Square: 34.18 |<.001   |
|0                                              |(%)          |414 (88.1%)           |198 (71.2%)       |                  |        |
|1                                              |(%)          |35 (7.4%)             |44 (15.8%)        |                  |        |
|2                                              |(%)          |21 (4.5%)             |36 (12.9%)        |                  |        |
|Effects of drugs on daily living               |             |                      |                  |Chi Square: 2.75  |0.253   |
|0                                              |(%)          |322 (68.5%)           |174 (62.6%)       |                  |        |
|1                                              |(%)          |56 (11.9%)            |40 (14.4%)        |                  |        |
|2                                              |(%)          |92 (19.6%)            |64 (23%)          |                  |        |
|Effects of drugs on health                     |             |                      |                  |Chi Square: 9.59  |0.008   |
|0                                              |(%)          |344 (73.2%)           |179 (64.4%)       |                  |        |
|1                                              |(%)          |83 (17.7%)            |54 (19.4%)        |                  |        |
|2                                              |(%)          |43 (9.1%)             |45 (16.2%)        |                  |        |
|Effects of drugs on relationship               |             |                      |                  |Chi Square: 5.26  |0.072   |
|0                                              |(%)          |329 (70%)             |172 (61.9%)       |                  |        |
|1                                              |(%)          |83 (17.7%)            |61 (21.9%)        |                  |        |
|2                                              |(%)          |58 (12.3%)            |45 (16.2%)        |                  |        |
|Motivation to tackle drug misuse               |             |                      |                  |Chi Square: 3.05  |0.218   |
|0                                              |(%)          |391 (83.2%)           |217 (78.1%)       |                  |        |
|1                                              |(%)          |54 (11.5%)            |41 (14.7%)        |                  |        |
|2                                              |(%)          |25 (5.3%)             |20 (7.2%)         |                  |        |
|Interpersonal skills                           |             |                      |                  |Chi Square: 8.35  |0.015   |
|0                                              |(%)          |385 (81.9%)           |206 (74.1%)       |                  |        |
|1                                              |(%)          |76 (16.2%)            |59 (21.2%)        |                  |        |
|2                                              |(%)          |9 (1.9%)              |13 (4.7%)         |                  |        |
|Impulsivity and impulsive violence             |             |                      |                  |Chi Square: 45.51 |<.001   |
|0                                              |(%)          |161 (34.3%)           |47 (16.9%)        |                  |        |
|1                                              |(%)          |214 (45.5%)           |118 (42.4%)       |                  |        |
|2                                              |(%)          |95 (20.2%)            |113 (40.6%)       |                  |        |
|Instrumental aggression                        |             |                      |                  |Chi Square: 39.57 |<.001   |
|0                                              |(%)          |305 (64.9%)           |117 (42.1%)       |                  |        |
|1                                              |(%)          |116 (24.7%)           |100 (36%)         |                  |        |
|2                                              |(%)          |49 (10.4%)            |61 (21.9%)        |                  |        |
|Ability to recognise problems                  |             |                      |                  |Chi Square: 0.13  |0.937   |
|0                                              |(%)          |170 (36.2%)           |102 (36.7%)       |                  |        |
|1                                              |(%)          |247 (52.6%)           |147 (52.9%)       |                  |        |
|2                                              |(%)          |53 (11.3%)            |29 (10.4%)        |                  |        |
|Problem-solving skills                         |             |                      |                  |Chi Square: 5.76  |0.056   |
|0                                              |(%)          |77 (16.4%)            |34 (12.2%)        |                  |        |
|1                                              |(%)          |277 (58.9%)           |155 (55.8%)       |                  |        |
|2                                              |(%)          |116 (24.7%)           |89 (32%)          |                  |        |
|Understanding of other people                  |             |                      |                  |Chi Square: 10.87 |0.004   |
|0                                              |(%)          |284 (60.4%)           |137 (49.3%)       |                  |        |
|1                                              |(%)          |161 (34.3%)           |114 (41%)         |                  |        |
|2                                              |(%)          |25 (5.3%)             |27 (9.7%)         |                  |        |
|Pro-criminal attitudes                         |             |                      |                  |Chi Square: 2.33  |0.312   |
|0                                              |(%)          |184 (39.1%)           |115 (41.4%)       |                  |        |
|1                                              |(%)          |215 (45.7%)           |132 (47.5%)       |                  |        |
|2                                              |(%)          |71 (15.1%)            |31 (11.2%)        |                  |        |
|Interpersonal hostility                        |             |                      |                  |Chi Square: 12.49 |0.002   |
|0                                              |(%)          |385 (81.9%)           |197 (70.9%)       |                  |        |
|1                                              |(%)          |70 (14.9%)            |65 (23.4%)        |                  |        |
|2                                              |(%)          |15 (3.2%)             |16 (5.8%)         |                  |        |
|Attitude toward staff and authorities          |             |                      |                  |Chi Square: 5.75  |0.056   |
|0                                              |(%)          |383 (81.5%)           |207 (74.5%)       |                  |        |
|1                                              |(%)          |77 (16.4%)            |60 (21.6%)        |                  |        |
|2                                              |(%)          |10 (2.1%)             |11 (4%)           |                  |        |
|Attitude towards parole supervision            |             |                      |                  |Chi Square: 0.13  |0.938   |
|0                                              |(%)          |368 (78.3%)           |218 (78.4%)       |                  |        |
|1                                              |(%)          |79 (16.8%)            |45 (16.2%)        |                  |        |
|2                                              |(%)          |23 (4.9%)             |15 (5.4%)         |                  |        |
|Motivation to avoid reoffending                |             |                      |                  |Chi Square: 1.61  |0.448   |
|0                                              |(%)          |234 (49.8%)           |148 (53.2%)       |                  |        |
|1                                              |(%)          |187 (39.8%)           |108 (38.8%)       |                  |        |
|2                                              |(%)          |49 (10.4%)            |22 (7.9%)         |                  |        |
|Placement in open prison                       |             |                      |                  |Chi Square: 9.48  |0.002   |
|Closed prison                                  |(%)          |301 (64%)             |209 (75.2%)       |                  |        |
|Open prison                                    |(%)          |169 (36%)             |69 (24.8%)        |                  |        |
|Conditional release                            |             |                      |                  |Chi Square: 0.79  |0.673   |
|No conditional release                         |(%)          |407 (86.6%)           |241 (86.7%)       |                  |        |
|Successful conditional relase                  |(%)          |43 (9.1%)             |22 (7.9%)         |                  |        |
|Cancelled conditional release                  |(%)          |20 (4.3%)             |15 (5.4%)         |                  |        |
|Parole supervised                              |             |                      |                  |Chi Square: 0.57  |0.451   |
|No supervision                                 |(%)          |160 (34%)             |103 (37.1%)       |                  |        |
|Supervised parole                              |(%)          |310 (66%)             |175 (62.9%)       |                  |        |
|Crime during sentence                          |             |                      |                  |Chi Square: 0.28  |0.595   |
|No records of crime                            |(%)          |415 (88.3%)           |241 (86.7%)       |                  |        |
|Record of crime                                |(%)          |55 (11.7%)            |37 (13.3%)        |                  |        |
|Days to new offence                            |             |                      |                  |F-Value: 4.14     |0.042   |
|New sentence in months                         |             |                      |                  |F-Value: 52.07    |<.001   |
|Aggressiveness                                 |             |                      |                  |F-Value: 68.25    |<.001   |
|Alcohol problems                               |             |                      |                  |F-Value: 24.31    |<.001   |
|Drug problems                                  |             |                      |                  |F-Value: 10.99    |<.001   |
|Employment problems                            |             |                      |                  |F-Value: 1.69     |0.194   |
|Problems managing economy                      |             |                      |                  |F-Value: 0.29     |0.592   |
|Resistance to change                           |             |                      |                  |F-Value: 9.65     |0.002   |


