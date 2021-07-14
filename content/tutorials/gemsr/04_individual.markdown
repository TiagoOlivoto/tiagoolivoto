---
title: Anova - Individual
linktitle: "4. Anova - Individual"
toc: true
type: docs
date: "2021/07/09"
draft: false
menu:
  gemsr:
    parent: GEMS-R
    weight: 5
weight: 5
---



```r
library(metan)
library(rio)
library(emmeans)

# dados
df <- import("http://bit.ly/df_ge", setclass = "tbl")
print(df)
## # A tibble: 156 x 13
##    ENV   GEN   BLOCO ALT_PLANT ALT_ESP COMPES DIAMES COMP_SAB DIAM_SAB   MGE
##    <chr> <chr> <chr>     <dbl>   <dbl>  <dbl>  <dbl>    <dbl>    <dbl> <dbl>
##  1 A1    H1    I          2.61    1.71   16.1   52.2     28.1     16.3  217.
##  2 A1    H1    II         2.87    1.76   14.2   50.3     27.6     14.5  184.
##  3 A1    H1    III        2.68    1.58   16.0   50.7     28.4     16.4  208.
##  4 A1    H10   I          2.83    1.64   16.7   54.1     31.7     17.4  194.
##  5 A1    H10   II         2.79    1.71   14.9   52.7     32.0     15.5  176.
##  6 A1    H10   III        2.72    1.51   16.7   52.7     30.4     17.5  207.
##  7 A1    H11   I          2.75    1.51   17.4   51.7     30.6     18.0  217.
##  8 A1    H11   II         2.72    1.56   16.7   47.2     28.7     17.2  181.
##  9 A1    H11   III        2.77    1.67   15.8   47.9     27.6     16.4  166.
## 10 A1    H12   I          2.73    1.54   14.9   47.5     28.2     15.5  161.
## # ... with 146 more rows, and 3 more variables: NFIL <dbl>, MMG <dbl>,
## #   NGE <dbl>
```


## Anova individual - anova_ind()


```r
ind_an <- anova_ind(df,
                    env = ENV,
                    gen = GEN,
                    rep = BLOCO,
                    resp = everything(),
                    verbose = FALSE)
print(ind_an)
## Variable ALT_PLANT 
## ---------------------------------------------------------------------------
## Within-environment ANOVA results
## ---------------------------------------------------------------------------
## # A tibble: 4 x 15
##   ENV    MEAN   DFG    MSG    FCG      PFG   DFB     MSB   FCB   PFB   DFE
##   <chr> <dbl> <int>  <dbl>  <dbl>    <dbl> <int>   <dbl> <dbl> <dbl> <int>
## 1 A1     2.79    12 0.0185  1.27  2.98e- 1     2 0.00437 0.300 0.743    24
## 2 A2     2.46    12 0.477  37.4   1.43e-12     2 0.00747 0.585 0.565    24
## 3 A3     2.17    12 0.0840  2.56  2.39e- 2     2 0.0507  1.55  0.233    24
## 4 A4     2.52    12 0.0254  0.858 5.96e- 1     2 0.0179  0.603 0.555    24
## # ... with 4 more variables: MSE <dbl>, CV <dbl>, h2 <dbl>, AS <dbl>
## ---------------------------------------------------------------------------
## 
## 
## 
## Variable ALT_ESP 
## ---------------------------------------------------------------------------
## Within-environment ANOVA results
## ---------------------------------------------------------------------------
## # A tibble: 4 x 15
##   ENV    MEAN   DFG     MSG    FCG      PFG   DFB     MSB   FCB   PFB   DFE
##   <chr> <dbl> <int>   <dbl>  <dbl>    <dbl> <int>   <dbl> <dbl> <dbl> <int>
## 1 A1     1.58    12 0.0256   2.03  6.74e- 2     2 0.00728 0.578 0.569    24
## 2 A2     1.31    12 0.363   45.6   1.53e-13     2 0.0180  2.26  0.126    24
## 3 A3     1.08    12 0.0488   1.44  2.14e- 1     2 0.00892 0.264 0.770    24
## 4 A4     1.41    12 0.00919  0.321 9.78e- 1     2 0.0229  0.802 0.460    24
## # ... with 4 more variables: MSE <dbl>, CV <dbl>, h2 <dbl>, AS <dbl>
## ---------------------------------------------------------------------------
## 
## 
## 
## Variable COMPES 
## ---------------------------------------------------------------------------
## Within-environment ANOVA results
## ---------------------------------------------------------------------------
## # A tibble: 4 x 15
##   ENV    MEAN   DFG   MSG   FCG      PFG   DFB   MSB   FCB   PFB   DFE   MSE
##   <chr> <dbl> <int> <dbl> <dbl>    <dbl> <int> <dbl> <dbl> <dbl> <int> <dbl>
## 1 A1     15.6    12  1.03 0.623 0.802        2 0.363 0.220 0.804    24 1.65 
## 2 A2     15.2    12  4.35 5.92  0.000110     2 0.455 0.619 0.547    24 0.734
## 3 A3     14.7    12  1.13 1.14  0.373        2 0.637 0.648 0.532    24 0.984
## 4 A4     15.1    12  3.39 3.50  0.00431      2 0.409 0.422 0.660    24 0.969
## # ... with 3 more variables: CV <dbl>, h2 <dbl>, AS <dbl>
## ---------------------------------------------------------------------------
## 
## 
## 
## Variable DIAMES 
## ---------------------------------------------------------------------------
## Within-environment ANOVA results
## ---------------------------------------------------------------------------
## # A tibble: 4 x 15
##   ENV    MEAN   DFG   MSG   FCG         PFG   DFB   MSB    FCB   PFB   DFE   MSE
##   <chr> <dbl> <int> <dbl> <dbl>       <dbl> <int> <dbl>  <dbl> <dbl> <int> <dbl>
## 1 A1     51.6    12  7.10  3.88 0.00228         2 0.141 0.0772 0.926    24  1.83
## 2 A2     48.7    12 19.7  11.6  0.000000317     2 2.04  1.20   0.319    24  1.70
## 3 A3     47.9    12 18.5   7.63 0.0000138       2 5.19  2.13   0.140    24  2.43
## 4 A4     49.9    12  5.61  1.27 0.297           2 2.03  0.460  0.637    24  4.42
## # ... with 3 more variables: CV <dbl>, h2 <dbl>, AS <dbl>
## ---------------------------------------------------------------------------
## 
## 
## 
## Variable COMP_SAB 
## ---------------------------------------------------------------------------
## Within-environment ANOVA results
## ---------------------------------------------------------------------------
## # A tibble: 4 x 15
##   ENV    MEAN   DFG   MSG   FCG          PFG   DFB     MSB     FCB     PFB   DFE
##   <chr> <dbl> <int> <dbl> <dbl>        <dbl> <int>   <dbl>   <dbl>   <dbl> <int>
## 1 A1     29.7    12 11.3   5.51      1.92e-4     2 2.72    1.32    0.285      24
## 2 A2     28.5    12 18.1  17.4       5.47e-9     2 0.00937 0.00898 0.991      24
## 3 A3     28.4    12 14.2  10.1       1.18e-6     2 8.06    5.70    0.00945    24
## 4 A4     29.4    12  5.75  2.74      1.73e-2     2 0.861   0.410   0.668      24
## # ... with 4 more variables: MSE <dbl>, CV <dbl>, h2 <dbl>, AS <dbl>
## ---------------------------------------------------------------------------
## 
## 
## 
## Variable DIAM_SAB 
## ---------------------------------------------------------------------------
## Within-environment ANOVA results
## ---------------------------------------------------------------------------
## # A tibble: 4 x 15
##   ENV    MEAN   DFG   MSG   FCG      PFG   DFB    MSB    FCB   PFB   DFE   MSE
##   <chr> <dbl> <int> <dbl> <dbl>    <dbl> <int>  <dbl>  <dbl> <dbl> <int> <dbl>
## 1 A1     16.4    12  1.38  1.17 0.355        2 0.0558 0.0476 0.954    24 1.17 
## 2 A2     15.9    12  4.20  5.68 0.000153     2 0.228  0.308  0.738    24 0.739
## 3 A3     15.8    12  1.35  2.13 0.0550       2 1.27   2.01   0.156    24 0.634
## 4 A4     15.8    12  2.49  2.33 0.0372       2 0.318  0.299  0.745    24 1.06 
## # ... with 3 more variables: CV <dbl>, h2 <dbl>, AS <dbl>
## ---------------------------------------------------------------------------
## 
## 
## 
## Variable MGE 
## ---------------------------------------------------------------------------
## Within-environment ANOVA results
## ---------------------------------------------------------------------------
## # A tibble: 4 x 15
##   ENV    MEAN   DFG   MSG   FCG         PFG   DFB   MSB    FCB   PFB   DFE   MSE
##   <chr> <dbl> <int> <dbl> <dbl>       <dbl> <int> <dbl>  <dbl> <dbl> <int> <dbl>
## 1 A1     199.    12  597.  2.01     7.01e-2     2  49.8 0.168  0.846    24  297.
## 2 A2     168.    12 3770. 14.9      2.58e-8     2  46.3 0.183  0.834    24  253.
## 3 A3     147.    12  823.  2.94     1.19e-2     2 620.  2.21   0.131    24  280.
## 4 A4     177.    12  836.  1.17     3.59e-1     2  57.6 0.0803 0.923    24  717.
## # ... with 3 more variables: CV <dbl>, h2 <dbl>, AS <dbl>
## ---------------------------------------------------------------------------
## 
## 
## 
## Variable NFIL 
## ---------------------------------------------------------------------------
## Within-environment ANOVA results
## ---------------------------------------------------------------------------
## # A tibble: 4 x 15
##   ENV    MEAN   DFG   MSG   FCG      PFG   DFB   MSB   FCB   PFB   DFE   MSE
##   <chr> <dbl> <int> <dbl> <dbl>    <dbl> <int> <dbl> <dbl> <dbl> <int> <dbl>
## 1 A1     16.9    12  6.34  2.17 0.0515       2 0.529 0.181 0.836    24 2.92 
## 2 A2     15.8    12  4.35  4.63 0.000698     2 2.10  2.23  0.130    24 0.941
## 3 A3     15.8    12  4.81  3.79 0.00267      2 0.640 0.503 0.611    24 1.27 
## 4 A4     16.0    12  2.57  1.78 0.111        2 1.20  0.831 0.448    24 1.44 
## # ... with 3 more variables: CV <dbl>, h2 <dbl>, AS <dbl>
## ---------------------------------------------------------------------------
## 
## 
## 
## Variable MMG 
## ---------------------------------------------------------------------------
## Within-environment ANOVA results
## ---------------------------------------------------------------------------
## # A tibble: 4 x 15
##   ENV    MEAN   DFG   MSG   FCG       PFG   DFB    MSB    FCB    PFB   DFE   MSE
##   <chr> <dbl> <int> <dbl> <dbl>     <dbl> <int>  <dbl>  <dbl>  <dbl> <int> <dbl>
## 1 A1     360.    12 2553.  2.52   2.62e-2     2   59.5 0.0587 0.943     24 1015.
## 2 A2     334.    12 9498. 14.1    4.55e-8     2  581.  0.863  0.435     24  674.
## 3 A3     318.    12 3541.  3.48   4.53e-3     2 1172.  1.15   0.333     24 1018.
## 4 A4     343.    12 1842.  1.90   8.67e-2     2 2622.  2.71   0.0868    24  967.
## # ... with 3 more variables: CV <dbl>, h2 <dbl>, AS <dbl>
## ---------------------------------------------------------------------------
## 
## 
## 
## Variable NGE 
## ---------------------------------------------------------------------------
## Within-environment ANOVA results
## ---------------------------------------------------------------------------
## # A tibble: 4 x 15
##   ENV    MEAN   DFG   MSG   FCG     PFG   DFB   MSB   FCB   PFB   DFE   MSE
##   <chr> <dbl> <int> <dbl> <dbl>   <dbl> <int> <dbl> <dbl> <dbl> <int> <dbl>
## 1 A1     558.    12 5238.  1.43 0.220       2  897. 0.245 0.785    24 3664.
## 2 A2     505.    12 7062.  3.51 0.00430     2 2119. 1.05  0.365    24 2014.
## 3 A3     468.    12 8346.  3.48 0.00451     2 1416. 0.590 0.562    24 2399.
## 4 A4     516.    12 7430.  1.62 0.153       2 3661. 0.797 0.462    24 4595.
## # ... with 3 more variables: CV <dbl>, h2 <dbl>, AS <dbl>
## ---------------------------------------------------------------------------

# Obter dados de todas as variáveis (Coeficiente de variação)
gmd(ind_an, "CV")
## Class of the model: anova_ind
## Variable extracted: CV
## # A tibble: 4 x 11
##   ENV   ALT_PLANT ALT_ESP COMPES DIAMES COMP_SAB DIAM_SAB   MGE  NFIL   MMG
##   <chr>     <dbl>   <dbl>  <dbl>  <dbl>    <dbl>    <dbl> <dbl> <dbl> <dbl>
## 1 A1         4.32    7.12   8.22   2.62     4.82     6.60  8.64 10.1   8.84
## 2 A2         4.59    6.80   5.62   2.68     3.59     5.41  9.44  6.14  7.77
## 3 A3         8.35   17.1    6.76   3.26     4.18     5.05 11.4   7.14 10.0 
## 4 A4         6.84   12.0    6.51   4.21     4.93     6.52 15.1   7.50  9.07
## # ... with 1 more variable: NGE <dbl>

# F-máximo
gmd(ind_an, what = "FMAX")
## Class of the model: anova_ind
## Variable extracted: FMAX
##        TRAIT  F_RATIO
## 1  ALT_PLANT 2.565433
## 2    ALT_ESP 4.243447
## 3     COMPES 2.248516
## 4     DIAMES 2.593214
## 5   COMP_SAB 2.013547
## 6   DIAM_SAB 1.850996
## 7        MGE 2.840139
## 8       NFIL 3.108648
## 9        MMG 1.511961
## 10       NGE 2.281671
```


## Anova individual - gafem()

```r
ind_an2 <- gafem(df,
                gen = GEN,
                rep = BLOCO,
                resp = everything(),
                by = ENV,
                verbose = FALSE)

# Obter dados de todas as variáveis
# P-value
gmd(ind_an2, what = "Pr(>F)", verbose = FALSE)
## # A tibble: 8 x 12
##   ENV   Source ALT_PLANT  ALT_ESP   COMPES    DIAMES  COMP_SAB DIAM_SAB      MGE
##   <chr> <chr>      <dbl>    <dbl>    <dbl>     <dbl>     <dbl>    <dbl>    <dbl>
## 1 A1    REP     7.43e- 1 5.69e- 1 0.804      9.26e-1   2.85e-1 0.954     8.46e-1
## 2 A1    GEN     2.98e- 1 6.74e- 2 0.802      2.28e-3   1.92e-4 0.355     7.01e-2
## 3 A2    REP     5.65e- 1 1.26e- 1 0.547      3.19e-1   9.91e-1 0.738     8.34e-1
## 4 A2    GEN     1.43e-12 1.53e-13 0.000110   3.17e-7   5.47e-9 0.000153  2.58e-8
## 5 A3    REP     2.33e- 1 7.70e- 1 0.532      1.40e-1   9.45e-3 0.156     1.31e-1
## 6 A3    GEN     2.39e- 2 2.14e- 1 0.373      1.38e-5   1.18e-6 0.0550    1.19e-2
## 7 A4    REP     5.55e- 1 4.60e- 1 0.660      6.37e-1   6.68e-1 0.745     9.23e-1
## 8 A4    GEN     5.96e- 1 9.78e- 1 0.00431    2.97e-1   1.73e-2 0.0372    3.59e-1
## # ... with 3 more variables: NFIL <dbl>, MMG <dbl>, NGE <dbl>


# Comparação de médias (MGE dentro do ambiente 2)
model_mge_a2 <- ind_an2[[2]][[2]][["MGE"]][["model"]]
(pairwise_means <- tukey_hsd(model_mge_a2, "GEN"))
## # A tibble: 78 x 8
##    term  group1 group2 estimate conf.low conf.high   p.adj sign 
##    <chr> <chr>  <chr>     <dbl>    <dbl>     <dbl>   <dbl> <chr>
##  1 GEN   H1     H10      -28.3     -75.8     19.2  0.612   ns   
##  2 GEN   H1     H11      -24.6     -72.1     22.9  0.783   ns   
##  3 GEN   H1     H12      -56.9    -104.      -9.40 0.00972 **   
##  4 GEN   H1     H13      -19.1     -66.6     28.4  0.949   ns   
##  5 GEN   H1     H2        30.7     -16.9     78.2  0.498   ns   
##  6 GEN   H1     H3         2.75    -44.8     50.3  1.00    ns   
##  7 GEN   H1     H4         9.27    -38.3     56.8  1.00    ns   
##  8 GEN   H1     H5        -1.95    -49.5     45.6  1.00    ns   
##  9 GEN   H1     H6        26.8     -20.7     74.3  0.683   ns   
## 10 GEN   H1     H7       -44.4     -91.9      3.12 0.0829  ns   
## # ... with 68 more rows
  
# comparações de médias com o pacote emmeans
(means <- emmeans(model_mge_a2, "GEN"))
##  GEN emmean   SE df lower.CL upper.CL
##  H1     188 9.18 24    169.3      207
##  H10    160 9.18 24    141.0      179
##  H11    164 9.18 24    144.7      183
##  H12    131 9.18 24    112.3      150
##  H13    169 9.18 24    150.1      188
##  H2     219 9.18 24    199.9      238
##  H3     191 9.18 24    172.0      210
##  H4     197 9.18 24    178.5      216
##  H5     186 9.18 24    167.3      205
##  H6     215 9.18 24    196.1      234
##  H7     144 9.18 24    124.9      163
##  H8     113 9.18 24     94.0      132
##  H9     112 9.18 24     93.4      131
## 
## Results are averaged over the levels of: REP 
## Confidence level used: 0.95
plot(means,
     comparisons = TRUE,
     CIs = FALSE,
     xlab = "Massa de grãos por espiga",
     ylab = "Genótipos")
```

<img src="/tutorials/gemsr/04_individual_files/figure-html/unnamed-chunk-3-1.png" width="960" />
