---
title: metan v1.5.1 on CRAN
author: Tiago Olivoto
date: '2020-04-27'
slug: metan-v1-5-1-on-cran
categories:
  - metan
tags:
  - biometical models
  - metan
  - Experimental statistics
  - genotype-environment interaction
subtitle: ''
summary: 'Find out the changes made in the v1.5.1 of metan package'
authors: []
lastmod: '2020-04-27T13:12:14-03:00'
featured: no
image:
  caption: ''
  focal_point: ''
  preview_only: no
projects: []
---

## Overview

The version v1.5.1 of the R package `metan` in now on [CRAN](https://cran.r-project.org/web/packages/metan/). This is a patch release that fixes a bug with the example of the function [`plot.fai_blup()`](https://tiagoolivoto.github.io/metan/reference/plot.fai_blup.html). Minor improvments were made in the functions [`plot_bars()`](https://tiagoolivoto.github.io/metan/reference/barplots.html) and [`plot_factbars()`](https://tiagoolivoto.github.io/metan/reference/barplots.html)


## Barplots
 [`plot_bars()`](https://tiagoolivoto.github.io/metan/reference/barplots.html) and [`plot_factbars()`](https://tiagoolivoto.github.io/metan/reference/barplots.html) now align vertically the labels to the error bars (when present) instead the plot bar.


```r
library(metan)
plot_bars(data_g, GEN, PH, lab.bar = letters[1:13])
```

<img src="/post/2020-04-27-metan-v1-5-1-on-cran_files/figure-html/unnamed-chunk-1-1.png" width="960" />



## fai_blup()
* `fai_blup()` now returns the eigenvalues and explained variance for each axis and variables into columns instead row names.


```r
mod <- waasb(data_ge,
             env = ENV,
             gen = GEN,
             rep = REP,
             resp = c(GY, HM))
```

```
## Method: REML/BLUP
```

```
## Random effects: GEN, GEN:ENV
```

```
## Fixed effects: ENV, REP(ENV)
```

```
## Denominador DF: Satterthwaite's method
```

```
## ---------------------------------------------------------------------------
## P-values for Likelihood Ratio Test of the analyzed traits
## ---------------------------------------------------------------------------
##     model       GY       HM
##  COMPLETE       NA       NA
##       GEN 1.11e-05 5.07e-03
##   GEN:ENV 2.15e-11 2.27e-15
## ---------------------------------------------------------------------------
## All variables with significant (p < 0.05) genotype-vs-environment interaction
```

```r
FAI <- fai_blup(mod,
                SI = 15,
                DI = c('max, max'),
                UI = c('min, min'))
```

```
## Class of the model: waasb
```

```
## Variable extracted: blupg
```

```
## 
## -----------------------------------------------------------------------------------
## Principal Component Analysis
## -----------------------------------------------------------------------------------
##     eigen.values cumulative.var
## PC1    1.1046076       55.23038
## PC2    0.8953924      100.00000
## 
## -----------------------------------------------------------------------------------
## Factor Analysis
## -----------------------------------------------------------------------------------
##           FA1 comunalits
## GY -0.7431714  0.5523038
## HM  0.7431714  0.5523038
## 
## -----------------------------------------------------------------------------------
## Comunalit Mean: 0.5523038 
## Selection differential
## -----------------------------------------------------------------------------------
##    Factor        Xo        Xs          SD     SDperc
## GY      1  2.674242  2.594199 -0.08004274 -2.9931005
## HM      1 48.088286 48.005568 -0.08271774 -0.1720122
## 
## -----------------------------------------------------------------------------------
## Selected genotypes
## G4 G9
## -----------------------------------------------------------------------------------
```

```r
print(FAI$eigen)
```

```
## # A tibble: 2 x 3
##   PC    eigen.values cumulative.var
##   <chr>        <dbl>          <dbl>
## 1 PC1          1.10            55.2
## 2 PC2          0.895          100
```

```r
print(FAI$canonical.loadings)
```

```
## # A tibble: 2 x 2
##   Variable    FA1
##   <chr>     <dbl>
## 1 GY       -0.673
## 2 HM        0.673
```


Find out more about `metan` at https://tiagoolivoto.github.io/metan/


