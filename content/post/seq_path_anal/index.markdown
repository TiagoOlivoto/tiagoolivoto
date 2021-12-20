---
toc: true
title: Sequential path analysis with {metan} R package
subtitle: ''
summary: 'The new function path_analysis_seq() in {metan} can performs a sequential path analysis, a path analysis with two sets of predictors.'
author: Tiago Olivoto
date: '2021-12-19'
lastmod: '2021-12-19'
url_source: https://github.com/TiagoOlivoto/pliman
url_code: https://doi.org/10.5281/zenodo.5666820
# doi: "10.1111/2041-210X.13384"
links:
- icon: twitter
  icon_pack: fab
  name: Follow
  url: https://twitter.com/tolivoto
categories:
  - metan
tags:
  - path analysis
  - correlation
  - plant breeding
  - collinearity
  - metan
image:
  placement: 2
  caption: 'Image by TanteTati from Pixabay'
  preview_only: no
featured: no
math: true
---

<script src="https://kit.fontawesome.com/1f72d6921a.js" crossorigin="anonymous"></script>




Studying relationships among crop traits is crucial for the understanding of complex biological systems that occur in plants. Some traits develop earlier in ontogeny and affect other traits that develop later. Therefore, a sequential path analysis should be a better option to study cause-and-effect relationships where one trait affects another trait.

<i class="far fa-calendar-alt"></i> For a long time, it was on my radar to implement an option to perform sequential path analysis in `metan`. The final push into this topic was done during [Gabrielle Lombardi](https://www.linkedin.com/in/gabriellelombardi/?originalSubdomain=br)'s doctoral thesis defense, where I was participating as a member of the examination committee. Gabrielli used metan for most of her analysis and has been questioned why the sequential path analysis was done with other software. Since metan has a function to perform path analysis, I realized that it should be not so laborious to implement a routine for sequential path analysis; and here we are; better late than never! 

The function to implement path analysis in {metan} is [`path_analysis_seq()`](https://tiagoolivoto.github.io/metan/reference/path_coeff.html). To use this function, the development version of `metan` must be installed.

# Instalation


```r
devtools::install_github("TiagoOlivoto/pliman")
```


# A numerical example.

In this short post, I'll use the data `data_ge2()`, a data set for a maize multi-environment trial, as a motivating example. The BLUPs for the genotype-environment interaction will be used in the path analysis in two ways. The first will consider the analysis across environments. In the second, a sequential path analysis will be performed within each environment. 

To construct the sequential model, KW (kernel weight per ear) will be used as a the dependent trait. The first set of predictors will be TKW, NKE, and NKR. The second set of predictors will be the plant- and ear-related traits PH, EH, EL, ED, CL, and CD.


```r
library(metan)
# Registered S3 method overwritten by 'GGally':
#   method from   
#   +.gg   ggplot2
# |=========================================================|
# | Multi-Environment Trial Analysis (metan) v1.16.0        |
# | Author: Tiago Olivoto                                   |
# | Type 'citation('metan')' to know how to cite metan      |
# | Type 'vignette('metan_start')' for a short tutorial     |
# | Visit 'https://bit.ly/pkgmetan' for a complete tutorial |
# |=========================================================|
str(data_ge2)
# tibble [156 x 18] (S3: tbl_df/tbl/data.frame)
#  $ ENV : Factor w/ 4 levels "A1","A2","A3",..: 1 1 1 1 1 1 1 1 1 1 ...
#  $ GEN : Factor w/ 13 levels "H1","H10","H11",..: 1 1 1 2 2 2 3 3 3 4 ...
#  $ REP : Factor w/ 3 levels "1","2","3": 1 2 3 1 2 3 1 2 3 1 ...
#  $ PH  : num [1:156] 2.61 2.87 2.68 2.83 2.79 ...
#  $ EH  : num [1:156] 1.71 1.76 1.58 1.64 1.71 ...
#  $ EP  : num [1:156] 0.658 0.628 0.591 0.581 0.616 ...
#  $ EL  : num [1:156] 16.1 14.2 16 16.7 14.9 ...
#  $ ED  : num [1:156] 52.2 50.3 50.7 54.1 52.7 ...
#  $ CL  : num [1:156] 28.1 27.6 28.4 31.7 32 ...
#  $ CD  : num [1:156] 16.3 14.5 16.4 17.4 15.5 ...
#  $ CW  : num [1:156] 25.1 21.4 24 26.2 20.7 ...
#  $ KW  : num [1:156] 217 184 208 194 176 ...
#  $ NR  : num [1:156] 15.6 16 17.2 15.6 17.6 16.8 16.8 13.6 15.2 14.8 ...
#  $ NKR : num [1:156] 36.6 31.4 31.8 32.8 28 32.8 34.6 34.4 34.8 31.6 ...
#  $ CDED: num [1:156] 0.538 0.551 0.561 0.586 0.607 ...
#  $ PERK: num [1:156] 89.6 89.5 89.7 87.9 89.7 ...
#  $ TKW : num [1:156] 418 361 367 374 347 ...
#  $ NKE : num [1:156] 521 494 565 519 502 ...
```

## Across environments

```r
mod1 <- 
  path_coeff_seq(data_ge2,
             resp = KW,
             chain_1 = c(TKW, NKE, NKR),
             chain_2 = c(PH, EH, EL, ED, CL, CD))
# ========================================================
# Collinearity diagnosis of first chain predictors
# ========================================================
# Weak multicollinearity. 
# Condition Number: 6.214
# You will probably have path coefficients close to being unbiased. 
# ========================================================
# Collinearity diagnosis of second chain predictors
# ========================================================
# Weak multicollinearity. 
# Condition Number: 66.559
# You will probably have path coefficients close to being unbiased.

# Coefficients for the primary traits and response
plot(mod1$resp_fc)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-3-1.png" width="672" />

```r

# Coefficients for the secondary traits and response
plot(mod1$resp_sc)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-3-2.png" width="672" />

```r


# contribution to the total effects through primary traits
gmd(mod1) %>% round_cols(digits = 3)
# Class of the model: path_coeff_seq
# Variable extracted: resp_sc2
#    trait      effect    TKW    NKE    NKR residual  total
# 1     PH      direct  0.272 -0.003 -0.008    0.021  0.240
# 2     PH indirect_EH -0.038  0.012  0.013   -0.036  0.023
# 3     PH indirect_EL  0.024  0.081  0.003   -0.011  0.119
# 4     PH indirect_ED  0.025  0.366  0.006    0.002  0.395
# 5     PH indirect_CL  0.099 -0.134 -0.006    0.002 -0.043
# 6     PH indirect_CD  0.025  0.001  0.004    0.010  0.021
# 7     PH       total  0.407  0.323  0.011   -0.012  0.753
# 8     EH      direct -0.041  0.013  0.014   -0.039  0.024
# 9     EH indirect_PH  0.253 -0.003 -0.008    0.019  0.223
# 10    EH indirect_EL  0.023  0.078  0.002   -0.010  0.114
# 11    EH indirect_ED  0.024  0.349  0.005    0.002  0.376
# 12    EH indirect_CL  0.121 -0.163 -0.007    0.003 -0.053
# 13    EH indirect_CD  0.022  0.001  0.004    0.008  0.018
# 14    EH       total  0.403  0.274  0.010   -0.016  0.703
# 15    EL      direct  0.064  0.214  0.007   -0.029  0.313
# 16    EL indirect_PH  0.103 -0.001 -0.003    0.008  0.091
# 17    EL indirect_EH -0.015  0.005  0.005   -0.014  0.009
# 18    EL indirect_ED  0.015  0.213  0.003    0.001  0.230
# 19    EL indirect_CL  0.078 -0.105 -0.005    0.002 -0.034
# 20    EL indirect_CD  0.072  0.003  0.012    0.028  0.060
# 21    EL       total  0.317  0.328  0.019   -0.004  0.669
# 22    ED      direct  0.038  0.553  0.009    0.004  0.597
# 23    ED indirect_PH  0.180 -0.002 -0.005    0.014  0.158
# 24    ED indirect_EH -0.026  0.008  0.009   -0.024  0.015
# 25    ED indirect_EL  0.025  0.082  0.003   -0.011  0.121
# 26    ED indirect_CL  0.212 -0.287 -0.013    0.005 -0.092
# 27    ED indirect_CD  0.031  0.001  0.005    0.012  0.025
# 28    ED       total  0.460  0.356  0.007   -0.001  0.824
# 29    CL      direct  0.304 -0.411 -0.018    0.007 -0.132
# 30    CL indirect_PH  0.088 -0.001 -0.003    0.007  0.078
# 31    CL indirect_EH -0.016  0.005  0.005   -0.015  0.010
# 32    CL indirect_EL  0.016  0.055  0.002   -0.007  0.080
# 33    CL indirect_ED  0.027  0.386  0.006    0.003  0.416
# 34    CL indirect_CD  0.024  0.001  0.004    0.009  0.020
# 35    CL       total  0.443  0.035 -0.004    0.003  0.471
# 36    CD      direct  0.079  0.004  0.014    0.030  0.065
# 37    CD indirect_PH  0.086 -0.001 -0.003    0.007  0.076
# 38    CD indirect_EH -0.011  0.004  0.004   -0.011  0.007
# 39    CD indirect_EL  0.058  0.195  0.006   -0.026  0.285
# 40    CD indirect_ED  0.015  0.216  0.003    0.001  0.233
# 41    CD indirect_CL  0.091 -0.124 -0.005    0.002 -0.040
# 42    CD       total  0.317  0.293  0.019    0.003  0.626
```


## within environments
To perform the path analysis for each level of a factor (or combination of factors), we can use the argument `by`. In this case, I'll compute the model above for each environment in `data_ge2`.


```r
mod2 <- 
  path_coeff_seq(data_ge2,
             resp = KW,
             chain_1 = c(TKW, NKE, NKR),
             chain_2 = c(PH, EH, EL, ED, CL, CD),
             by = ENV,
             verbose = FALSE)


# contribution to the total effects through primary traits
gmd(mod2) %>% round_cols(digits = 3)
# Class of the model: group_path_seq, tbl_df, tbl, data.frame
# Variable extracted: resp_sc2
# # A tibble: 168 x 8
#    ENV   trait effect         TKW    NKE    NKR residual  total
#    <fct> <chr> <chr>        <dbl>  <dbl>  <dbl>    <dbl>  <dbl>
#  1 A1    PH    direct      -0.321  0.306 -0.003   -0.08   0.063
#  2 A1    PH    indirect_EH  0.109 -0.173  0        0.018 -0.083
#  3 A1    PH    indirect_EL  0.002 -0.002  0        0.001 -0.001
#  4 A1    PH    indirect_ED  0.021  0.032  0        0.003  0.051
#  5 A1    PH    indirect_CL -0.022  0.067  0.004    0.01   0.038
#  6 A1    PH    indirect_CD  0.123 -0.092  0.004    0.022  0.014
#  7 A1    PH    total       -0.088  0.138  0.005   -0.028  0.082
#  8 A1    EH    direct       0.256 -0.406 -0.001    0.043 -0.195
#  9 A1    EH    indirect_PH -0.136  0.13  -0.001   -0.034  0.027
# 10 A1    EH    indirect_EL -0.09   0.111 -0.002   -0.027  0.046
# # ... with 158 more rows
```

That's all!

