descriptive-statistics.R
================
benny\_000
Tue Mar 12 05:59:08 2019

``` r
library(recidivismsl)

output_table  <- descriptive_stats_cat
names(output_table) <- c("Variable", "Level", 
                         "NoRe", "NVioVRe", "VioRe",
                         "NoRe%", "NVioVRe%", "VioRe%")
knitr::kable(output_table, digits = 1)
```

| Variable                  | Level                            |  NoRe|  NVioVRe|  VioRe|  NoRe%|  NVioVRe%|  VioRe%|
|:--------------------------|:---------------------------------|-----:|--------:|------:|------:|---------:|-------:|
| NA                        | NA                               |   748|      470|    278|   50.0|      31.4|    18.6|
| ageFirst\_missing         | 0                                |   537|      293|    240|   35.9|      19.6|    16.0|
| ageFirst\_missing         | 1                                |   211|      177|     38|   14.1|      11.8|     2.5|
| conditionalReleaseGranted | 0                                |   748|      410|    222|   50.0|      27.4|    14.8|
| conditionalReleaseGranted | 1                                |     0|       60|     56|    0.0|       4.0|     3.7|
| conditionalReleaseOutcome | Cancelled conditional release    |    40|       20|     15|    2.7|       1.3|     1.0|
| conditionalReleaseOutcome | No conditional release           |   511|      407|    241|   34.2|      27.2|    16.1|
| conditionalReleaseOutcome | Successful conditional relase    |   197|       43|     22|   13.2|       2.9|     1.5|
| conditionalReleaseSuccess | no\_cr\_or\_revoked              |   551|      427|    256|   36.8|      28.5|    17.1|
| conditionalReleaseSuccess | successful\_cr                   |   197|       43|     22|   13.2|       2.9|     1.5|
| crimeDuringSentence       | No records of crime              |   747|      415|    241|   49.9|      27.7|    16.1|
| crimeDuringSentence       | Record of crime                  |     1|       55|     37|    0.1|       3.7|     2.5|
| i\_alcCriminalActs        | 0                                |   274|      148|     42|   18.3|       9.9|     2.8|
| i\_alcCriminalActs        | 1                                |   189|      122|     75|   12.6|       8.2|     5.0|
| i\_alcCriminalActs        | 2                                |   285|      200|    161|   19.1|      13.4|    10.8|
| i\_alcEffectHealth        | 0                                |   639|      381|    235|   42.7|      25.5|    15.7|
| i\_alcEffectHealth        | 1                                |    83|       66|     30|    5.5|       4.4|     2.0|
| i\_alcEffectHealth        | 2                                |    26|       23|     13|    1.7|       1.5|     0.9|
| i\_alcEffectRelations     | 0                                |   407|      217|     97|   27.2|      14.5|     6.5|
| i\_alcEffectRelations     | 1                                |   248|      180|    119|   16.6|      12.0|     8.0|
| i\_alcEffectRelations     | 2                                |    93|       73|     62|    6.2|       4.9|     4.1|
| i\_alcEffectWork          | 0                                |   423|      208|    102|   28.3|      13.9|     6.8|
| i\_alcEffectWork          | 1                                |   224|      148|     96|   15.0|       9.9|     6.4|
| i\_alcEffectWork          | 2                                |   101|      114|     80|    6.8|       7.6|     5.3|
| i\_alcFrequency           | 0                                |   336|      170|     62|   22.5|      11.4|     4.1|
| i\_alcFrequency           | 1                                |   241|      152|    102|   16.1|      10.2|     6.8|
| i\_alcFrequency           | 2                                |   171|      148|    114|   11.4|       9.9|     7.6|
| i\_alcMotivationTreat     | 0                                |   600|      343|    177|   40.1|      22.9|    11.8|
| i\_alcMotivationTreat     | 1                                |   110|       91|     70|    7.4|       6.1|     4.7|
| i\_alcMotivationTreat     | 2                                |    38|       36|     31|    2.5|       2.4|     2.1|
| i\_alcViolence            | 0                                |   302|      174|     48|   20.2|      11.6|     3.2|
| i\_alcViolence            | 1                                |   218|      142|     73|   14.6|       9.5|     4.9|
| i\_alcViolence            | 2                                |   228|      154|    157|   15.2|      10.3|    10.5|
| i\_alcWithMeds            | 0                                |   584|      303|    140|   39.0|      20.3|     9.4|
| i\_alcWithMeds            | 1                                |    48|       49|     44|    3.2|       3.3|     2.9|
| i\_alcWithMeds            | 2                                |   116|      118|     94|    7.8|       7.9|     6.3|
| i\_attitudeHostile        | 0                                |   631|      385|    197|   42.2|      25.7|    13.2|
| i\_attitudeHostile        | 1                                |    91|       70|     65|    6.1|       4.7|     4.3|
| i\_attitudeHostile        | 2                                |    26|       15|     16|    1.7|       1.0|     1.1|
| i\_attitudeProcrime       | 0                                |   414|      184|    115|   27.7|      12.3|     7.7|
| i\_attitudeProcrime       | 1                                |   273|      215|    132|   18.2|      14.4|     8.8|
| i\_attitudeProcrime       | 2                                |    61|       71|     31|    4.1|       4.7|     2.1|
| i\_attitudeStaff          | 0                                |   658|      383|    207|   44.0|      25.6|    13.8|
| i\_attitudeStaff          | 1                                |    81|       77|     60|    5.4|       5.1|     4.0|
| i\_attitudeStaff          | 2                                |     9|       10|     11|    0.6|       0.7|     0.7|
| i\_attitudeSupervision    | 0                                |   654|      368|    218|   43.7|      24.6|    14.6|
| i\_attitudeSupervision    | 1                                |    77|       79|     45|    5.1|       5.3|     3.0|
| i\_attitudeSupervision    | 2                                |    17|       23|     15|    1.1|       1.5|     1.0|
| i\_cumpulsorySchool       | 0                                |   712|      417|    265|   47.6|      27.9|    17.7|
| i\_cumpulsorySchool       | 2                                |    36|       53|     13|    2.4|       3.5|     0.9|
| i\_dailyLifeManagement    | 0                                |   645|      348|    206|   43.1|      23.3|    13.8|
| i\_dailyLifeManagement    | 1                                |    83|       98|     50|    5.5|       6.6|     3.3|
| i\_dailyLifeManagement    | 2                                |    20|       24|     22|    1.3|       1.6|     1.5|
| i\_domViolPerp            | 0                                |   622|      381|    213|   41.6|      25.5|    14.2|
| i\_domViolPerp            | 1                                |    88|       66|     42|    5.9|       4.4|     2.8|
| i\_domViolPerp            | 2                                |    38|       23|     23|    2.5|       1.5|     1.5|
| i\_domViolVictim          | 0                                |   565|      367|    189|   37.8|      24.5|    12.6|
| i\_domViolVictim          | 1                                |    85|       72|     37|    5.7|       4.8|     2.5|
| i\_domViolVictim          | 2                                |    98|       31|     52|    6.6|       2.1|     3.5|
| i\_drugCriminalActs       | 0                                |   625|      307|    154|   41.8|      20.5|    10.3|
| i\_drugCriminalActs       | 1                                |    41|       37|     46|    2.7|       2.5|     3.1|
| i\_drugCriminalActs       | 2                                |    82|      126|     78|    5.5|       8.4|     5.2|
| i\_drugEffectHealth       | 0                                |   671|      344|    179|   44.9|      23.0|    12.0|
| i\_drugEffectHealth       | 1                                |    47|       83|     54|    3.1|       5.5|     3.6|
| i\_drugEffectHealth       | 2                                |    30|       43|     45|    2.0|       2.9|     3.0|
| i\_drugEffectRelations    | 0                                |   640|      329|    172|   42.8|      22.0|    11.5|
| i\_drugEffectRelations    | 1                                |    75|       83|     61|    5.0|       5.5|     4.1|
| i\_drugEffectRelations    | 2                                |    33|       58|     45|    2.2|       3.9|     3.0|
| i\_drugEffectWork         | 0                                |   637|      322|    174|   42.6|      21.5|    11.6|
| i\_drugEffectWork         | 1                                |    50|       56|     40|    3.3|       3.7|     2.7|
| i\_drugEffectWork         | 2                                |    61|       92|     64|    4.1|       6.1|     4.3|
| i\_drugFrequency          | 0                                |   602|      297|    145|   40.2|      19.9|     9.7|
| i\_drugFrequency          | 1                                |    66|       63|     48|    4.4|       4.2|     3.2|
| i\_drugFrequency          | 2                                |    80|      110|     85|    5.3|       7.4|     5.7|
| i\_drugHistory            | 0                                |   263|       65|     51|   17.6|       4.3|     3.4|
| i\_drugHistory            | 1                                |    60|       38|     36|    4.0|       2.5|     2.4|
| i\_drugHistory            | 2                                |   425|      367|    191|   28.4|      24.5|    12.8|
| i\_drugIntravenous        | 0                                |   629|      307|    149|   42.0|      20.5|    10.0|
| i\_drugIntravenous        | 1                                |     7|       11|      8|    0.5|       0.7|     0.5|
| i\_drugIntravenous        | 2                                |   112|      152|    121|    7.5|      10.2|     8.1|
| i\_drugMotivationTreat    | 0                                |   694|      391|    217|   46.4|      26.1|    14.5|
| i\_drugMotivationTreat    | 1                                |    38|       54|     41|    2.5|       3.6|     2.7|
| i\_drugMotivationTreat    | 2                                |    16|       25|     20|    1.1|       1.7|     1.3|
| i\_drugViolence           | 0                                |   700|      414|    198|   46.8|      27.7|    13.2|
| i\_drugViolence           | 1                                |    28|       35|     44|    1.9|       2.3|     2.9|
| i\_drugViolence           | 2                                |    20|       21|     36|    1.3|       1.4|     2.4|
| i\_eduAttitude            | 0                                |   580|      299|    185|   38.8|      20.0|    12.4|
| i\_eduAttitude            | 1                                |   124|      125|     67|    8.3|       8.4|     4.5|
| i\_eduAttitude            | 2                                |    44|       46|     26|    2.9|       3.1|     1.7|
| i\_eduNeed                | 0                                |   378|      154|     79|   25.3|      10.3|     5.3|
| i\_eduNeed                | 1                                |   245|      169|    101|   16.4|      11.3|     6.8|
| i\_eduNeed                | 2                                |   125|      147|     98|    8.4|       9.8|     6.6|
| i\_familyRelation         | 0                                |   563|      281|    174|   37.6|      18.8|    11.6|
| i\_familyRelation         | 1                                |   146|      140|     71|    9.8|       9.4|     4.7|
| i\_familyRelation         | 2                                |    39|       49|     33|    2.6|       3.3|     2.2|
| i\_financialManagement    | 0                                |   335|      106|     70|   22.4|       7.1|     4.7|
| i\_financialManagement    | 1                                |   300|      207|    117|   20.1|      13.8|     7.8|
| i\_financialManagement    | 2                                |   113|      157|     91|    7.6|      10.5|     6.1|
| i\_financialObstacles     | 0                                |   347|      115|     66|   23.2|       7.7|     4.4|
| i\_financialObstacles     | 1                                |   292|      205|    130|   19.5|      13.7|     8.7|
| i\_financialObstacles     | 2                                |   109|      150|     82|    7.3|      10.0|     5.5|
| i\_financialSituation     | 0                                |   281|       75|     43|   18.8|       5.0|     2.9|
| i\_financialSituation     | 1                                |   290|      155|    108|   19.4|      10.4|     7.2|
| i\_financialSituation     | 2                                |   177|      240|    127|   11.8|      16.0|     8.5|
| i\_housingAppropriate     | 0                                |   570|      291|    150|   38.1|      19.5|    10.0|
| i\_housingAppropriate     | 1                                |    81|       67|     52|    5.4|       4.5|     3.5|
| i\_housingAppropriate     | 2                                |    97|      112|     76|    6.5|       7.5|     5.1|
| i\_housingShortTerm       | 0                                |   558|      230|    126|   37.3|      15.4|     8.4|
| i\_housingShortTerm       | 1                                |   102|      119|     69|    6.8|       8.0|     4.6|
| i\_housingShortTerm       | 2                                |    88|      121|     83|    5.9|       8.1|     5.5|
| i\_impulsive              | 0                                |   296|      161|     47|   19.8|      10.8|     3.1|
| i\_impulsive              | 1                                |   324|      214|    118|   21.7|      14.3|     7.9|
| i\_impulsive              | 2                                |   128|       95|    113|    8.6|       6.4|     7.6|
| i\_insight                | 0                                |   323|      170|    102|   21.6|      11.4|     6.8|
| i\_insight                | 1                                |   344|      247|    147|   23.0|      16.5|     9.8|
| i\_insight                | 2                                |    81|       53|     29|    5.4|       3.5|     1.9|
| i\_instrumentalAggression | 0                                |   532|      305|    117|   35.6|      20.4|     7.8|
| i\_instrumentalAggression | 1                                |   150|      116|    100|   10.0|       7.8|     6.7|
| i\_instrumentalAggression | 2                                |    66|       49|     61|    4.4|       3.3|     4.1|
| i\_manipulative           | 0                                |   517|      308|    175|   34.6|      20.6|    11.7|
| i\_manipulative           | 1                                |   169|      118|     71|   11.3|       7.9|     4.7|
| i\_manipulative           | 2                                |    62|       44|     32|    4.1|       2.9|     2.1|
| i\_motivationChange       | 0                                |   504|      234|    148|   33.7|      15.6|     9.9|
| i\_motivationChange       | 1                                |   188|      187|    108|   12.6|      12.5|     7.2|
| i\_motivationChange       | 2                                |    56|       49|     22|    3.7|       3.3|     1.5|
| i\_othersView             | 0                                |   485|      284|    137|   32.4|      19.0|     9.2|
| i\_othersView             | 1                                |   212|      161|    114|   14.2|      10.8|     7.6|
| i\_othersView             | 2                                |    51|       25|     27|    3.4|       1.7|     1.8|
| i\_parenting              | 0                                |   588|      326|    198|   39.3|      21.8|    13.2|
| i\_parenting              | 1                                |    68|       82|     44|    4.5|       5.5|     2.9|
| i\_parenting              | 2                                |    92|       62|     36|    6.1|       4.1|     2.4|
| i\_partnerRelation        | 0                                |   626|      364|    216|   41.8|      24.3|    14.4|
| i\_partnerRelation        | 1                                |    91|       84|     39|    6.1|       5.6|     2.6|
| i\_partnerRelation        | 2                                |    31|       22|     23|    2.1|       1.5|     1.5|
| i\_peersCriminal          | 0                                |   296|       68|     49|   19.8|       4.5|     3.3|
| i\_peersCriminal          | 1                                |   337|      241|    147|   22.5|      16.1|     9.8|
| i\_peersCriminal          | 2                                |   115|      161|     82|    7.7|      10.8|     5.5|
| i\_problemSolving         | 0                                |   201|       77|     34|   13.4|       5.1|     2.3|
| i\_problemSolving         | 1                                |   426|      277|    155|   28.5|      18.5|    10.4|
| i\_problemSolving         | 2                                |   121|      116|     89|    8.1|       7.8|     5.9|
| i\_readingProblem         | 0                                |   638|      377|    215|   42.6|      25.2|    14.4|
| i\_readingProblem         | 1                                |    76|       70|     52|    5.1|       4.7|     3.5|
| i\_readingProblem         | 2                                |    34|       23|     11|    2.3|       1.5|     0.7|
| i\_remedialTeaching       | 0                                |   548|      245|    141|   36.6|      16.4|     9.4|
| i\_remedialTeaching       | 2                                |   200|      225|    137|   13.4|      15.0|     9.2|
| i\_responsibility         | 0                                |   279|      181|     91|   18.6|      12.1|     6.1|
| i\_responsibility         | 1                                |   312|      216|    125|   20.9|      14.4|     8.4|
| i\_responsibility         | 2                                |   157|       73|     62|   10.5|       4.9|     4.1|
| i\_riskSeeking            | 0                                |   370|      114|     75|   24.7|       7.6|     5.0|
| i\_riskSeeking            | 1                                |   291|      257|    139|   19.5|      17.2|     9.3|
| i\_riskSeeking            | 2                                |    87|       99|     64|    5.8|       6.6|     4.3|
| i\_socialSkills           | 0                                |   626|      385|    206|   41.8|      25.7|    13.8|
| i\_socialSkills           | 1                                |   100|       76|     59|    6.7|       5.1|     3.9|
| i\_socialSkills           | 2                                |    22|        9|     13|    1.5|       0.6|     0.9|
| i\_submissive             | 0                                |   602|      346|    219|   40.2|      23.1|    14.6|
| i\_submissive             | 1                                |   127|      102|     49|    8.5|       6.8|     3.3|
| i\_submissive             | 2                                |    19|       22|     10|    1.3|       1.5|     0.7|
| i\_workApplication        | 0                                |   618|      322|    180|   41.3|      21.5|    12.0|
| i\_workApplication        | 1                                |    71|       77|     48|    4.7|       5.1|     3.2|
| i\_workApplication        | 2                                |    59|       71|     50|    3.9|       4.7|     3.3|
| i\_workAttitude           | 0                                |   616|      306|    172|   41.2|      20.5|    11.5|
| i\_workAttitude           | 1                                |   107|      123|     74|    7.2|       8.2|     4.9|
| i\_workAttitude           | 2                                |    25|       41|     32|    1.7|       2.7|     2.1|
| i\_workHistory            | 0                                |   383|      120|     58|   25.6|       8.0|     3.9|
| i\_workHistory            | 1                                |   243|      177|    108|   16.2|      11.8|     7.2|
| i\_workHistory            | 2                                |   122|      173|    112|    8.2|      11.6|     7.5|
| newO\_againstOfficer      | 0                                |   748|      449|    234|   50.0|      30.0|    15.6|
| newO\_againstOfficer      | 1                                |     0|       21|     44|    0.0|       1.4|     2.9|
| newO\_assault             | 0                                |   748|      470|      7|   50.0|      31.4|     0.5|
| newO\_assault             | 1                                |     0|        0|    271|    0.0|       0.0|    18.1|
| newO\_autoTheft           | 0                                |   748|      410|    222|   50.0|      27.4|    14.8|
| newO\_autoTheft           | 1                                |     0|       60|     56|    0.0|       4.0|     3.7|
| newO\_damage              | 0                                |   748|      437|    215|   50.0|      29.2|    14.4|
| newO\_damage              | 1                                |     0|       33|     63|    0.0|       2.2|     4.2|
| newO\_homicide            | 0                                |   748|      470|    258|   50.0|      31.4|    17.2|
| newO\_homicide            | 1                                |     0|        0|     20|    0.0|       0.0|     1.3|
| newO\_narcotic            | 0                                |   748|      329|    182|   50.0|      22.0|    12.2|
| newO\_narcotic            | 1                                |     0|      141|     96|    0.0|       9.4|     6.4|
| newO\_other               | 0                                |   748|      465|    275|   50.0|      31.1|    18.4|
| newO\_other               | 1                                |     0|        5|      3|    0.0|       0.3|     0.2|
| newO\_otherPerson         | 0                                |   748|      439|    169|   50.0|      29.3|    11.3|
| newO\_otherPerson         | 1                                |     0|       31|    109|    0.0|       2.1|     7.3|
| newO\_otherProperty       | 0                                |   748|      394|    205|   50.0|      26.3|    13.7|
| newO\_otherProperty       | 1                                |     0|       76|     73|    0.0|       5.1|     4.9|
| newO\_robbery             | 0                                |   748|      437|    229|   50.0|      29.2|    15.3|
| newO\_robbery             | 1                                |     0|       33|     49|    0.0|       2.2|     3.3|
| newO\_sexual              | 0                                |   748|      468|    268|   50.0|      31.3|    17.9|
| newO\_sexual              | 1                                |     0|        2|     10|    0.0|       0.1|     0.7|
| newO\_theft               | 0                                |   748|      344|    158|   50.0|      23.0|    10.6|
| newO\_theft               | 1                                |     0|      126|    120|    0.0|       8.4|     8.0|
| newO\_traffic             | 0                                |   748|      299|    146|   50.0|      20.0|     9.8|
| newO\_traffic             | 1                                |     0|      171|    132|    0.0|      11.4|     8.8|
| newO\_weapon              | 0                                |   748|      409|    219|   50.0|      27.3|    14.6|
| newO\_weapon              | 1                                |     0|       61|     59|    0.0|       4.1|     3.9|
| newO\_whitecollar         | 0                                |   748|      470|    278|   50.0|      31.4|    18.6|
| o\_againstOfficer         | 0                                |   704|      420|    233|   47.1|      28.1|    15.6|
| o\_againstOfficer         | 1                                |    44|       50|     45|    2.9|       3.3|     3.0|
| o\_assault                | 0                                |   335|      161|     77|   22.4|      10.8|     5.1|
| o\_assault                | 1                                |   413|      309|    201|   27.6|      20.7|    13.4|
| o\_autoTheft              | 0                                |   683|      370|    187|   45.7|      24.7|    12.5|
| o\_autoTheft              | 1                                |    65|      100|     91|    4.3|       6.7|     6.1|
| o\_damage                 | 0                                |   667|      400|    189|   44.6|      26.7|    12.6|
| o\_damage                 | 1                                |    81|       70|     89|    5.4|       4.7|     5.9|
| o\_homicide               | 0                                |   681|      460|    261|   45.5|      30.7|    17.4|
| o\_homicide               | 1                                |    67|       10|     17|    4.5|       0.7|     1.1|
| o\_narcotic               | 0                                |   581|      334|    189|   38.8|      22.3|    12.6|
| o\_narcotic               | 1                                |   167|      136|     89|   11.2|       9.1|     5.9|
| o\_other                  | 0                                |   733|      462|    271|   49.0|      30.9|    18.1|
| o\_other                  | 1                                |    15|        8|      7|    1.0|       0.5|     0.5|
| o\_otherPerson            | 0                                |   635|      409|    171|   42.4|      27.3|    11.4|
| o\_otherPerson            | 1                                |   113|       61|    107|    7.6|       4.1|     7.2|
| o\_otherProperty          | 0                                |   638|      364|    183|   42.6|      24.3|    12.2|
| o\_otherProperty          | 1                                |   110|      106|     95|    7.4|       7.1|     6.4|
| o\_robbery                | 0                                |   681|      427|    203|   45.5|      28.5|    13.6|
| o\_robbery                | 1                                |    67|       43|     75|    4.5|       2.9|     5.0|
| o\_sexual                 | 0                                |   657|      462|    268|   43.9|      30.9|    17.9|
| o\_sexual                 | 1                                |    91|        8|     10|    6.1|       0.5|     0.7|
| o\_theft                  | 0                                |   611|      310|    136|   40.8|      20.7|     9.1|
| o\_theft                  | 1                                |   137|      160|    142|    9.2|      10.7|     9.5|
| o\_traffic                | 0                                |   601|      294|    120|   40.2|      19.7|     8.0|
| o\_traffic                | 1                                |   147|      176|    158|    9.8|      11.8|    10.6|
| o\_weapon                 | 0                                |   643|      394|    220|   43.0|      26.3|    14.7|
| o\_weapon                 | 1                                |   105|       76|     58|    7.0|       5.1|     3.9|
| o\_whitecollar            | 0                                |   698|      466|    275|   46.7|      31.1|    18.4|
| o\_whitecollar            | 1                                |    50|        4|      3|    3.3|       0.3|     0.2|
| openPrison                | closed\_prison                   |   322|      301|    209|   21.5|      20.1|    14.0|
| openPrison                | open\_prison                     |   426|      169|     69|   28.5|      11.3|     4.6|
| ps\_escapeHistory         | No escape history                |   686|      415|    231|   45.9|      27.7|    15.4|
| ps\_escapeHistory         | Unauthorized absence of any kind |    62|       55|     47|    4.1|       3.7|     3.1|
| ps\_info\_missing         | 0                                |   721|      458|    272|   48.2|      30.6|    18.2|
| ps\_info\_missing         | 1                                |    27|       12|      6|    1.8|       0.8|     0.4|
| supervisedParole          | no supervision                   |   223|      160|    103|   14.9|      10.7|     6.9|
| supervisedParole          | supervised parole                |   525|      310|    175|   35.1|      20.7|    11.7|
