---
title: Componentes de variância
linktitle: "5. Componentes de variância"
toc: true
type: docs
date: "2021/07/09"
draft: false
menu:
  gemsr:
    parent: GEMS-R
    weight: 6
weight: 6
---

<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML" ></script>



```r
library(metan)
library(rio)

# dados
df_g <- import("http://bit.ly/df_g", setclass = "tbl")
print(df_g)
## # A tibble: 39 x 12
##    GEN   BLOCO ALT_PLANT ALT_ESP COMPES DIAMES COMP_SAB DIAM_SAB   MGE  NFIL
##    <chr> <chr>     <dbl>   <dbl>  <dbl>  <dbl>    <dbl>    <dbl> <dbl> <dbl>
##  1 H1    I          3.00   1.88    15.1   50.8     31.1     15.6  191.  16.4
##  2 H1    II         2.97   1.83    15.2   52.1     31.2     15.7  197.  17.2
##  3 H1    III        2.81   1.67    14.6   52.7     32.2     15.1  177.  17.6
##  4 H10   I          2.10   0.91    16.0   46.7     27.2     17.1  151.  15.2
##  5 H10   II         2.12   1.03    14.6   46.4     26.6     15.5  152.  13.2
##  6 H10   III        1.92   1.02    16.0   47.1     26.6     16.3  177.  13.6
##  7 H11   I          2.13   1.05    14.8   46.9     27.0     15.9  169.  13.2
##  8 H11   II         2.13   1.01    16.0   47.7     28.0     16.3  168.  14  
##  9 H11   III        2.18   0.992   14.6   47.3     26.7     14.8  153.  14  
## 10 H12   I          2.15   0.982   14.3   45.3     25.7     14.8  138.  13.6
## # ... with 29 more rows, and 2 more variables: MMG <dbl>, NGE <dbl>
```

## Modelo misto
A função `gamem()` pode ser usada para analisar experimentos únicos(experimentos unilaterais) usando um modelo de efeito misto de acordo com o seguinte modelo:

$$
y_{ij} = \mu + \alpha_i + \tau_j + \varepsilon_ {ij}
$$

onde \\(y_ {ij}\\) é o valor observado para o \\(i\\)-ésimo genótipo no \\(j\\)-ésimo bloco (\\(i\\) = 1, 2, ... \\(g\\); \\(j\\) = 1, 2,..., \\(r\\)); sendo \\(g\\) e \\(r\\) o número de genótipos e blocos, respectivamente; \\(\alpha_i\\) é o efeito aleatório do genótipo \\(i\\); \\(\tau_j\\) é o efeito fixo do bloco \\(j\\); e \\(\varepsilon_ {ij}\\) é o erro aleatório associado a \\(y_{ij}\\). Neste exemplo, usaremos os dados de exemplo `df_g`.


```r
gen_mod <- 
  gamem(df_g,
        gen = GEN,
        rep = BLOCO,
        resp = everything())
## Evaluating trait ALT_PLANT |====                                 | 10% 00:00:00 
Evaluating trait ALT_ESP |========                               | 20% 00:00:00 
Evaluating trait COMPES |============                            | 30% 00:00:00 
Evaluating trait DIAMES |================                        | 40% 00:00:00 
Evaluating trait COMP_SAB |===================                   | 50% 00:00:00 
Evaluating trait DIAM_SAB |=======================               | 60% 00:00:00 
Evaluating trait MGE |==============================             | 70% 00:00:00 
Evaluating trait NFIL |==================================        | 80% 00:00:00 
Evaluating trait MMG |=======================================    | 90% 00:00:00 
Evaluating trait NGE |===========================================| 100% 00:00:01 
## Method: REML/BLUP
## Random effects: GEN
## Fixed effects: REP
## Denominador DF: Satterthwaite's method
## ---------------------------------------------------------------------------
## P-values for Likelihood Ratio Test of the analyzed traits
## ---------------------------------------------------------------------------
##     model ALT_PLANT  ALT_ESP   COMPES   DIAMES COMP_SAB DIAM_SAB      MGE
##  Complete        NA       NA       NA       NA       NA       NA       NA
##  Genotype  2.27e-12 2.36e-13 0.000224 5.95e-07 9.69e-09 0.000311 4.67e-08
##     NFIL     MMG     NGE
##       NA      NA      NA
##  0.00145 8.3e-08 0.00907
## ---------------------------------------------------------------------------
## All variables with significant (p < 0.05) genotype effect
```

A maneira mais fácil de obter os resultados do modelo acima é usando a função `gmd()`, ou seu *shortcut* `gmd()`.

### Diagnósticos do modelo

```r
plot(gen_mod, type = "res") # padrão
## `geom_smooth()` using formula 'y ~ x'
## `geom_smooth()` using formula 'y ~ x'
```

<img src="/tutorials/gemsr/05_vcomp_files/figure-html/unnamed-chunk-3-1.png" width="960" />

```r
plot(gen_mod, type = "re") # padrão
```

<img src="/tutorials/gemsr/05_vcomp_files/figure-html/unnamed-chunk-3-2.png" width="960" />

### Detalhes da análise

```r
gmd(gen_mod, "details")
## Class of the model: gamem
## Variable extracted: details
## # A tibble: 6 x 11
##   Parameters ALT_PLANT ALT_ESP COMPES DIAMES COMP_SAB DIAM_SAB MGE   NFIL  MMG  
##   <chr>      <chr>     <chr>   <chr>  <chr>  <chr>    <chr>    <chr> <chr> <chr>
## 1 Ngen       13        13      13     13     13       13       13    13    13   
## 2 OVmean     2.4619    1.3131  15.23~ 48.73~ 28.463   15.8874  168.~ 15.7~ 333.~
## 3 Min        1.814 (H~ 0.752 ~ 12.5 ~ 44.71~ 23.852 ~ 13.28 (~ 105.~ 13.2~ 226.~
## 4 Max        3.04 (H3~ 1.878 ~ 17.94~ 53.74~ 33.018 ~ 18.28 (~ 236.~ 18 (~ 451.~
## 5 MinGEN     1.9593 (~ 0.846 ~ 13.36~ 45.26~ 24.5707~ 13.88 (~ 112.~ 13.7~ 236.~
## 6 MaxGEN     2.9467 (~ 1.7953~ 17.24~ 53.19~ 32.7087~ 17.62 (~ 218.~ 17.4~ 415.~
## # ... with 1 more variable: NGE <chr>
```

### LRT

```r
gmd(gen_mod, "lrt") 
## Class of the model: gamem
## Variable extracted: lrt
## # A tibble: 10 x 8
##    VAR       model     npar logLik   AIC   LRT    Df `Pr(>Chisq)`
##    <chr>     <chr>    <dbl>  <dbl> <dbl> <dbl> <dbl>        <dbl>
##  1 ALT_PLANT Genotype     4  -22.8  53.6 49.2      1     2.27e-12
##  2 ALT_ESP   Genotype     4  -17.7  43.4 53.7      1     2.36e-13
##  3 COMPES    Genotype     4  -66.8 142.  13.6      1     2.24e- 4
##  4 DIAMES    Genotype     4  -91.7 191.  24.9      1     5.95e- 7
##  5 COMP_SAB  Genotype     4  -89.3 187.  32.9      1     9.69e- 9
##  6 DIAM_SAB  Genotype     4  -66.4 141.  13.0      1     3.11e- 4
##  7 MGE       Genotype     4 -186.  379.  29.8      1     4.67e- 8
##  8 NFIL      Genotype     4  -68.1 144.  10.1      1     1.45e- 3
##  9 MMG       Genotype     4 -202.  413.  28.7      1     8.30e- 8
## 10 NGE       Genotype     4 -203.  414.   6.81     1     9.07e- 3
```

### Componentes de variância

```r
gmd(gen_mod, "vcomp")
## Class of the model: gamem
## Variable extracted: vcomp
## # A tibble: 2 x 11
##   Group    ALT_PLANT ALT_ESP COMPES DIAMES COMP_SAB DIAM_SAB   MGE  NFIL   MMG
##   <chr>        <dbl>   <dbl>  <dbl>  <dbl>    <dbl>    <dbl> <dbl> <dbl> <dbl>
## 1 GEN         0.155  0.118    1.20    5.99     5.70    1.15  1172. 1.14  2941.
## 2 Residual    0.0128 0.00796  0.734   1.70     1.04    0.739  253. 0.941  674.
## # ... with 1 more variable: NGE <dbl>
plot(gen_mod, type = "vcomp")
```

<img src="/tutorials/gemsr/05_vcomp_files/figure-html/unnamed-chunk-6-1.png" width="960" />



### Parâmetros genéticos

```r
gmd(gen_mod, "genpar")
## Class of the model: gamem
## Variable extracted: genpar
## # A tibble: 11 x 11
##    Parameters ALT_PLANT  ALT_ESP COMPES DIAMES COMP_SAB DIAM_SAB      MGE   NFIL
##    <chr>          <dbl>    <dbl>  <dbl>  <dbl>    <dbl>    <dbl>    <dbl>  <dbl>
##  1 Gen_var       0.155   0.118    1.20   5.99     5.70     1.15  1172.     1.14 
##  2 Gen (%)      92.4    93.7     62.1   77.9     84.5     61.0     82.3   54.7  
##  3 Res_var       0.0128  0.00796  0.734  1.70     1.04     0.739  253.     0.941
##  4 Res (%)       7.62    6.30    37.9   22.1     15.5     39.0     17.7   45.3  
##  5 Phen_var      0.168   0.126    1.94   7.70     6.74     1.89  1425.     2.08 
##  6 H2            0.924   0.937    0.621  0.779    0.845    0.610    0.823  0.547
##  7 h2mg          0.973   0.978    0.831  0.913    0.942    0.824    0.933  0.784
##  8 Accuracy      0.987   0.989    0.912  0.956    0.971    0.908    0.966  0.885
##  9 CVg          16.0    26.2      7.21   5.02     8.39     6.76    20.3    6.75 
## 10 CVr           4.59    6.80     5.62   2.68     3.59     5.41     9.44   6.14 
## 11 CV ratio      3.48    3.86     1.28   1.88     2.34     1.25     2.15   1.10 
## # ... with 2 more variables: MMG <dbl>, NGE <dbl>
```



### BLUPs preditos

```r
gmd(gen_mod, "blupg")
## Class of the model: gamem
## Variable extracted: blupg
## # A tibble: 13 x 11
##    GEN   ALT_PLANT ALT_ESP COMPES DIAMES COMP_SAB DIAM_SAB   MGE  NFIL   MMG
##    <chr>     <dbl>   <dbl>  <dbl>  <dbl>    <dbl>    <dbl> <dbl> <dbl> <dbl>
##  1 H1         2.92   1.78    15.0   51.6     31.3     15.6  187.  16.8  385.
##  2 H10        2.06   0.994   15.5   46.9     26.9     16.2  160.  14.4  317.
##  3 H11        2.16   1.03    15.1   47.4     27.3     15.7  164.  14.2  341.
##  4 H12        2.10   0.904   13.7   46.9     27.3     14.2  134.  15.1  315.
##  5 H13        2.23   1.11    15.6   50.1     31.8     16.6  169.  16.6  327.
##  6 H2         2.93   1.74    15.9   52.8     32.5     16.5  215.  17.1  410.
##  7 H3         2.93   1.74    15.3   50.2     30.0     15.9  189.  15.1  395.
##  8 H4         2.84   1.62    16.3   49.3     29.6     17.0  196.  15.1  385.
##  9 H5         2.70   1.42    16.3   48.2     27.5     16.8  185.  16.0  333.
## 10 H6         2.81   1.54    16.9   51.4     27.0     17.3  212.  16.7  345.
## 11 H7         2.15   1.11    14.7   47.4     27.3     15.6  145.  15.6  295.
## 12 H8         1.97   0.856   14.0   45.6     24.8     14.6  117.  16.3  243.
## 13 H9         2.21   1.22    13.8   45.7     26.9     14.6  116.  16.4  248.
## # ... with 1 more variable: NGE <dbl>

# plotar os BLUPS (default)
plot_blup(gen_mod)
```

<img src="/tutorials/gemsr/05_vcomp_files/figure-html/unnamed-chunk-8-1.png" width="672" />

```r

# Trait MGE
plot_blup(gen_mod,
          var = "MGE",
          height.err.bar = 0,
          col.shape = c("black", "gray"),
          x.lab = "Massa de grãos por espiga (g)",
          y.lab = "Híbridos de milho")
```

<img src="/tutorials/gemsr/05_vcomp_files/figure-html/unnamed-chunk-8-2.png" width="672" />



## Modelos mistos - dentro de ambientes


```r
df_ge <- import("http://bit.ly/df_ge", setclass = "tbl")
mod_gen_whithin <- 
    gamem(df_ge,
          gen = GEN,
          rep = BLOCO,
          resp = everything(),
          by = ENV, verbose = FALSE)

gmd(mod_gen_whithin, "lrt")
## # A tibble: 40 x 9
##    ENV   VAR       model     npar logLik   AIC       LRT    Df `Pr(>Chisq)`
##    <chr> <chr>     <chr>    <dbl>  <dbl> <dbl>     <dbl> <dbl>        <dbl>
##  1 A1    ALT_PLANT Genotype     4   19.7 -31.3  2.32e- 1     1     0.630   
##  2 A1    ALT_ESP   Genotype     4   18.5 -29.0  2.13e+ 0     1     0.144   
##  3 A1    COMPES    Genotype     4  -61.5 131.  -1.42e-14     1     1       
##  4 A1    DIAMES    Genotype     4  -77.9 164.   7.96e+ 0     1     0.00478 
##  5 A1    COMP_SAB  Genotype     4  -84.4 177.   1.26e+ 1     1     0.000392
##  6 A1    DIAM_SAB  Genotype     4  -58.8 126.   1.03e- 1     1     0.748   
##  7 A1    MGE       Genotype     4 -163.  333.   2.07e+ 0     1     0.150   
##  8 A1    NFIL      Genotype     4  -80.2 168.   2.55e+ 0     1     0.110   
##  9 A1    MMG       Genotype     4 -187.  382.   3.65e+ 0     1     0.0559  
## 10 A1    NGE       Genotype     4 -205.  418.   5.29e- 1     1     0.467   
## # ... with 30 more rows
gmd(mod_gen_whithin, "vcomp")
## # A tibble: 8 x 12
##   ENV   Group    ALT_PLANT ALT_ESP COMPES DIAMES COMP_SAB DIAM_SAB    MGE  NFIL
##   <chr> <chr>        <dbl>   <dbl>  <dbl>  <dbl>    <dbl>    <dbl>  <dbl> <dbl>
## 1 A1    GEN        0.00130 0.00433 0       1.76      3.09   0.0676  100.  1.14 
## 2 A1    Residual   0.0146  0.0126  1.44    1.83      2.05   1.17    297.  2.92 
## 3 A2    GEN        0.155   0.118   1.20    5.99      5.70   1.15   1172.  1.14 
## 4 A2    Residual   0.0128  0.00796 0.734   1.70      1.04   0.739   253.  0.941
## 5 A3    GEN        0.0171  0.00501 0.0472  5.37      4.27   0.240   181.  1.18 
## 6 A3    Residual   0.0328  0.0338  0.984   2.43      1.41   0.634   280.  1.27 
## 7 A4    GEN        0       0       0.809   0.398     1.22   0.474    39.6 0.375
## 8 A4    Residual   0.0282  0.0221  0.969   4.42      2.10   1.06    717.  1.44 
## # ... with 2 more variables: MMG <dbl>, NGE <dbl>
```
