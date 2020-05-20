+++
title = "Descriptive statistics in R with metan"
linktitle = "Descriptive"
date = "2020/04/03"
toc = true  # Show table of contents? true/false
type = "docs"  # Do not modify.
[menu.example]
    parent = "R package metan"
    weight = 4
+++




## Getting started

In this quick tip, I will show you how to compute descriptive statistics in R with the package [metan](https://tiagoolivoto.github.io/metan/). If the package is not yet installed, you can download the stable version from [CRAN](https://cran.r-project.org/web/packages/metan/) with:


```r
install.packages("metan")

```

Then, load it with:

```r
library(metan)
```

For the latest release notes see the [NEWS file](https://tiagoolivoto.github.io/metan/news/index.html).

## Statistics by levels of a factor
`metan` provides a simple and intuitive pipe-friendly framework for computing descriptive statistics.  A [set of functions](https://tiagoolivoto.github.io/metan/reference/utils_stats.html) can be used to compute the most used descriptive statistics quickly. In this tutorial, we will use the data example `data_ge2` to create motivating examples.

To compute the mean values for each level of the factor `GEN` we use the function `means_by()`.

```r
means_by(data_ge2, GEN)
# # A tibble: 13 x 16
#    GEN      PH    EH    EP    EL    ED    CL    CD    CW    KW    NR   NKR  CDED
#    <fct> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
#  1 H1     2.62  1.50 0.570  15.1  51.2  30.1  15.7  26.7  184.  16.6  32.2 0.588
#  2 H10    2.31  1.26 0.545  15.1  48.4  28.4  15.9  22.8  164.  15.6  32.4 0.586
#  3 H11    2.39  1.27 0.527  15.2  48.8  28.3  16.0  22.6  167.  15.6  33   0.580
#  4 H12    2.44  1.28 0.519  14.3  48.6  28.2  14.8  22.6  157.  16.3  30.4 0.582
#  5 H13    2.54  1.35 0.532  15.0  50.6  29.4  15.8  26.0  180.  17.4  31.0 0.582
#  6 H2     2.60  1.38 0.525  15.3  50.9  29.3  16.0  25.7  187.  16.7  31.9 0.574
#  7 H3     2.59  1.41 0.538  14.5  49.4  28.5  15.7  22.9  169.  15.8  31.4 0.578
#  8 H4     2.58  1.43 0.546  15.7  49.2  28.6  16.5  25.7  184.  15.5  35   0.581
#  9 H5     2.57  1.37 0.530  15.6  49.9  29.4  16.6  27.7  184.  16.1  33.9 0.588
# 10 H6     2.56  1.41 0.553  15.8  51.5  30.3  16.6  27.3  188.  16.3  32.8 0.588
# 11 H7     2.40  1.32 0.547  15.4  49.5  29.5  16.2  25.9  171.  16.2  31.4 0.597
# 12 H8     2.33  1.21 0.514  15.0  48.4  28.7  15.9  23.4  160.  15.9  31.3 0.594
# 13 H9     2.36  1.27 0.532  15.0  47.6  28.6  15.9  23.2  153.  15.5  32.5 0.601
# # ... with 3 more variables: PERK <dbl>, TKW <dbl>, NKE <dbl>
```

The following `_by()` functions are available for computing the main descriptive statistics by levels of a factor.

 - `cv_by()` For computing coefficient of variation.
 - `max_by()` For computing maximum values.
 - `means_by()` For computing arithmetic means.
 - `min_by()` For compuing minimum values.
 - `n_by()` For getting the length.
 - `sd_by()` For computing sample standard deviation.
 - `sem_by()` For computing standard error of the mean .

## Useful functions
Other useful functions are also implemented. All of them works naturally with `%>%`, handle grouped data with `group_by()` and multiple variables (all numeric variables from `.data` by default).
 
 - `av_dev()` computes the average absolute deviation.
 - `ci_mean()` computes the confidence interval for the mean.
 - `cv()` computes the coefficient of variation.
 - `freq_table()` Computes frequency fable.
 - `hm_mean()`, `gm_mean()` computes the harmonic and geometric means, respectively. The harmonic mean is the reciprocal of the arithmetic mean of the reciprocals. The geometric mean is the nth root of n products.
 - `kurt()` computes the kurtosis like used in SAS and SPSS.
 - `range_data()` Computes the range of the values.
 - `sd_amo()`, `sd_pop()` Computes sample and populational standard deviation, respectively.
 - `sem()` computes the standard error of the mean.
 - `skew()` computes the skewness like used in SAS and SPSS.
 - `sum_dev()` computes the sum of the absolute deviations.
 - `sum_sq_dev()` computes the sum of the squared deviations.
 - `var_amo()`, `var_pop()` computes sample and populational variance.
 - `valid_n()` Return the valid (not NA) length of a data.

## The wrapper function `desc_stat()`

To compute all statistics at once we can use `desc_stat()`. This is a wrapper function around the above ones and may be used to compute measures of central tendency, position, and dispersion. By default (`stats = "main"`), seven statistics (coefficient of variation, maximum, mean, median, minimum, sample standard deviation, standard error and confidence interval of the mean) are computed. Other allowed values are `"all"` to show all the statistics, `"robust"` to show robust statistics, `"quantile"` to show quantile statistics, or chose one (or more) statistics using a comma-separated vector with the statistic names, e.g., `stats = c("mean, cv")`. We can also use `hist = TRUE` to create a histogram for each variable. Here, select helpers can also be used in the argument `...`.

### All statistics for all numeric variables

```r
desc_stat(data_ge2, stats = "all")
# # A tibble: 15 x 29
#    variable  av.dev      ci    cv   gmean   hmean     iqr    kurt     mad
#    <chr>      <dbl>   <dbl> <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>
#  1 CD        0.948   0.186   7.34  15.9    15.9    1.65   -0.352   1.27  
#  2 CDED      0.0261  0.0053  5.71   0.585   0.584  0.0417  0.669   0.0312
#  3 CL        1.98    0.365   7.95  28.9    28.8    3.70   -0.748   2.63  
#  4 CW        5.21    0.99   25.2   24.0    23.0    9.19   -0.662   6.83  
#  5 ED        2.30    0.437   5.58  49.5    49.4    4.40   -0.783   3.14  
#  6 EH        0.249   0.045  21.2    1.31    1.28   0.484  -1.08    0.337 
#  7 EL        0.995   0.199   8.28  15.1    15.1    1.72   -0.0174  1.26  
#  8 EP        0.0459  0.0089 10.5    0.534   0.531  0.082  -0.369   0.0619
#  9 KW       27.2     5.18   18.9  170.    166.    46.8    -0.768  35.0   
# 10 NKE      56.0    11.5    14.2  507.    501.    85.6     0.179  63.6   
# 11 NKR       2.73    0.548  10.7   32.1    31.9    4.85   -0.116   3.56  
# 12 NR        1.30    0.259  10.2   16.0    16.0    2.4     0.240   1.78  
# 13 PERK      1.55    0.300   2.17  87.4    87.4    2.81    0.0317  2.10  
# 14 PH        0.293   0.0528 13.4    2.46    2.44   0.595  -1.17    0.431 
# 15 TKW      36.7     7.44   13.9  335.    332.    57.8     0.0313 44.8   
# # ... with 20 more variables: max <dbl>, mean <dbl>, median <dbl>, min <dbl>,
# #   n <dbl>, q2.5 <dbl>, q25 <dbl>, q75 <dbl>, q97.5 <dbl>, range <dbl>,
# #   sd.amo <dbl>, sd.pop <dbl>, se <dbl>, skew <dbl>, sum <dbl>, sum.dev <dbl>,
# #   sum.sq.dev <dbl>, valid.n <dbl>, var.amo <dbl>, var.pop <dbl>
```

### Robust statistics using select helpers

```r
data_ge2 %>%
  desc_stat(contains("N"),
            stats = "robust")
# # A tibble: 3 x 4
#   variable     n median   iqr
#   <chr>    <dbl>  <dbl> <dbl>
# 1 NKE        156   509. 85.6 
# 2 NKR        156    32   4.85
# 3 NR         156    16   2.4
```

### Quantile functions choosing variable names

```r
data_ge2 %>%
  desc_stat(PH, EH, CD, ED,
            stats = "quantile")
# # A tibble: 4 x 7
#   variable     n    min   q25 median   q75   max
#   <chr>    <dbl>  <dbl> <dbl>  <dbl> <dbl> <dbl>
# 1 CD         156 12.9   15.1   16    16.8  18.6 
# 2 ED         156 43.5   47.3   49.9  51.7  54.9 
# 3 EH         156  0.752  1.09   1.41  1.57  1.88
# 4 PH         156  1.71   2.18   2.52  2.77  3.04
```

### Create a histogram for each variable

```r
data_ge2 %>%
  desc_stat(EP, EL, CL,
            hist = TRUE)
```

<img src="/tutorials/metan/desc_stat_files/figure-html/unnamed-chunk-7-1.png" width="960" style="display: block; margin: auto;" />

```
# # A tibble: 3 x 9
#   variable    cv    max   mean median    min sd.amo     se     ci
#   <chr>    <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>
# 1 CL        7.95 34.7   29.0   28.7   23.5   2.31   0.185  0.365 
# 2 EL        8.28 17.9   15.2   15.1   11.5   1.26   0.101  0.199 
# 3 EP       10.5   0.660  0.537  0.544  0.386 0.0564 0.0045 0.0089
```

### Statistics by levels of factors
To compute the statistics for each level of a factor, use the argument `by`. In addition, it is possible to select the statistics to compute using the argument `stats`, that is a single statistic name, e.g., `"mean"`, or a a comma-separated vector of names with `"` at the beginning and end of vector only. Note that the statistic names **ARE NOT** case sensitive, i.e., both `"mean"`, `"Mean"`, or  `"MEAN"` are recognized. Comma or spaces can be used to separate the statistics' names.

* All options bellow will work:
   * `stats = c("mean, se, cv, max, min")`
   * `stats = c("mean se cv max min")`
   * `stats = c("MEAN, Se, CV max MIN")`



```r
desc_stat(data_ge2,
          contains("C"),
          stats = ("mean, se, cv, max, min"),
          by = ENV)
# # A tibble: 16 x 7
#    ENV   variable   mean     se    cv    max    min
#    <fct> <chr>     <dbl>  <dbl> <dbl>  <dbl>  <dbl>
#  1 A1    CD       16.4   0.174   6.62 18.3   14.1  
#  2 A1    CDED      0.576 0.0059  6.40  0.664  0.495
#  3 A1    CL       29.7   0.358   7.53 34.7   25.9  
#  4 A1    CW       28.3   0.906  20.0  38.5   17.8  
#  5 A2    CD       15.9   0.215   8.46 18.3   13.3  
#  6 A2    CDED      0.584 0.0054  5.80  0.694  0.507
#  7 A2    CL       28.5   0.405   8.88 33.0   23.9  
#  8 A2    CW       23.8   1.11   29.1  35.7   11.1  
#  9 A3    CD       15.8   0.151   6.00 17.6   14    
# 10 A3    CDED      0.595 0.0059  6.22  0.681  0.511
# 11 A3    CL       28.4   0.386   8.47 33.2   23.5  
# 12 A3    CW       20.8   0.818  24.6  29.6   11.5  
# 13 A4    CD       15.8   0.194   7.67 18.6   12.9  
# 14 A4    CDED      0.589 0.0036  3.81  0.631  0.542
# 15 A4    CL       29.4   0.286   6.07 32.8   25.8  
# 16 A4    CW       26.4   0.730  17.3  34.7   15.3
```
  
To compute the descriptive statistics by more than one grouping variable, we need to pass a grouped data to the argument `.data` with the function `group_by()`. Let's compute the mean, the standard error of the mean and the sample size for the variables `EP` and `EL` for all combinations of the factors `ENV` and `GEN`.


```r
data_ge2 %>% 
  group_by(ENV, GEN) %>% 
  desc_stat(EP, EL,
            stats = c("mean, se, n"))
# # A tibble: 104 x 6
#    ENV   GEN   variable   mean     se     n
#    <fct> <fct> <chr>     <dbl>  <dbl> <dbl>
#  1 A1    H1    EL       15.4   0.637      3
#  2 A1    H1    EP        0.626 0.0193     3
#  3 A1    H10   EL       16.1   0.600      3
#  4 A1    H10   EP        0.584 0.018      3
#  5 A1    H11   EL       16.6   0.475      3
#  6 A1    H11   EP        0.574 0.0147     3
#  7 A1    H12   EL       15.2   0.252      3
#  8 A1    H12   EP        0.575 0.0212     3
#  9 A1    H13   EL       14.8   0.0811     3
# 10 A1    H13   EP        0.568 0.026      3
# # ... with 94 more rows
```
