---
title: ANOVA - conjunta
linktitle: "6. ANOVA - conjunta"
type: docs
toc: true
keep_md: yes
menu:
  gemsr:
    parent: GEMS-R
    weight: 6
weight: 6    
---

<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML" ></script>



## Anova conjunta - modelo fixo


```r
library(metan)
library(rio)
df_ge <- import("http://bit.ly/df_ge", setclass = "tbl")
joint_an <- 
    anova_joint(df_ge,
                env = ENV, 
                gen = GEN,
                rep = BLOCO,
                resp = everything(), 
                verbose = FALSE)
```

## Anova conjunta - modelo misto
### O modelo
O modelo linear mais simples e conhecido com efeito de interação usado para analisar dados em multi-ambientes é:

$$
{y_{ijk}} = {\rm {}} \mu {\rm {}} + \mathop \alpha \nolimits_i + \mathop \tau \nolimits_j + \mathop {(\alpha \tau)} \nolimits_{ij } + \mathop \gamma \nolimits_{jk} + {\rm {}} \mathop \varepsilon \nolimits_{ijk}
$$

onde \\(y_{ijk}\\) é a variável resposta (por exemplo, rendimento de grãos) observada no \\(k\\)-ésimo bloco do \\(i\\)-ésimo genótipo no \\(j\\)-ésimo ambiente (\\(i\\) = 1, 2, ..., \\(g\\); \\(j\\) = 1, 2, ..., \\(e\\); \\(k\\) = 1, 2, ..., \\(b\\)); \\(\mu\\) é a média geral; \\(\mathop \alpha \nolimits_i\\) é o efeito do \\(i\\)-ésimo genótipo; \\(\mathop \tau \nolimits_j\\) é o efeito do \\(j\\)-ésimo; \\(\mathop {(\alpha \tau)} \nolimits_{ij}\\) é o efeito de interação do \\(i\\)-ésimo genótipo com o \\(j\\)-ésimo ambiente; \\(\mathop \gamma \nolimits_{jk}\\) é o efeito do \\(k\\)-ésimo bloco dentro do \\(j\\)-ésimo ambiente; e \\(\mathop \varepsilon \nolimits_{ijk}\\) é o erro aleatório. Em um modelo de efeito misto assumindo \\({\alpha_i}\\) e \\(\mathop {(\alpha \tau)} \nolimits_{ij}\\) como efeitos aleatórios, o modelo acima pode ser reescrito como:

$$
{\bf {y = X b + Zu + \varepsilon}}
$$


onde **y** é um vetor \\(n [= \sum \nolimits_{j = 1} ^ e {(gb)]} \times 1\\) da variável de resposta \\({\bf{y}} = {\rm{ }}{\left[ {{y_{111}},{\rm{ }}{y_{112}},{\rm{ }} \ldots ,{\rm{ }}{y_{geb}}} \right]^\prime }\\); \\(\bf{b}\\) é um vetor \\((eb) \times 1\\) de efeitos fixos desconhecidos \\({\bf{b}} = [\mathop \gamma \nolimits_{11}, \mathop \gamma \nolimits_{12}, ..., \mathop \gamma \nolimits_{eb}]^\prime\\); \\(\bf{u}\\) é um vetor \\(m \[= g + ge\] \times 1\\) de efeitos aleatórios \\({\bf {u}} = {\rm {}} {\left [{{\alpha_1}, { \alpha_2}, ..., {\alpha_g}, \mathop {(\alpha \tau)} \nolimits_{11}, \mathop {(\alpha \tau)} \nolimits_{12}, ... , \mathop {(\alpha \tau)} \nolimits_{ge}} \right] ^ \prime}\\); \\(\bf{X}\\) é uma matriz de design \\(n \times (eb)\\) relacionando \\(\bf{y}\\) a \\(\bf{b}\\); \\(\bf{Z}\\) é uma matriz de design \\(n\times m\\) relacionando \\(\bf{y}\\) a \\(\bf{u}\\); \\({\bf {\varepsilon}}\\) é um vetor \\(n \times 1\\) de erros aleatórios \\({\bf {\varepsilon}} = {\rm {}} {\left \[{{y\_{111}}, {\rm {}} {y\_{112}}, {\rm {}} \ldots, {\rm {}} {y\_{geb}}} \right\] ^ \prime}\\);

Os vetores \\(\bf{b}\\) e \\(\bf{u}\\) são estimados usando a conhecida equação de modelo misto[^1].


$$
\left[ {\begin{array}{*{20}{c}}{{\bf{\hat b }}}\\{{\bf{\hat u}}}\end{array}} \right]{\bf{ = }}{\left[ {\begin{array}{*{20}{c}}{{\bf{X'}}{{\bf{R }}^{ - {\bf{1}}}}{\bf{X}}}&{{\bf{X'}}{{\bf{R }}^{ - {\bf{1}}}}{\bf{Z}}}\\{{\bf{Z'}}{{\bf{R }}^{ - {\bf{1}}}}{\bf{X}}}&{{\bf{Z'}}{{\bf{R }}^{ - {\bf{1}}}}{\bf{Z + }}{{\bf{G}}^{ - {\bf{1}}}}}\end{array}} \right]^ - }\left[ {\begin{array}{*{20}{c}}{{\bf{X'}}{{\bf{R }}^{ - {\bf{1}}}}{\bf{y}}}\\{{\bf{Z'}}{{\bf{R }}^{ - {\bf{1}}}}{\bf{y}}}\end{array}} \right]
$$


onde **G** e **R** são as matrizes de variância-covariância para o vetor de efeito aleatório **u** e o vetor residual \\({\bf{\varepsilon }}\\), respectivamente.


### A função gamem_met()

A função `gamem_met()` é usada para ajustar o modelo linear de efeitos mistos. 


```r
args(gamem_met)
## function (.data, env, gen, rep, resp, block = NULL, by = NULL, 
##     random = "gen", prob = 0.05, verbose = TRUE) 
## NULL
```

O primeiro argumento são os dados, em nosso exemplo `df_ge`. Os argumentos (`env`, `gen` e `rep`) são os nomes das colunas que contêm os níveis de ambientes, genótipos e blocos, respectivamente. O argumento (`resp`) é a variável de resposta a ser analisada . A função permite uma única variável ou um vetor de variáveis resposta. Aqui, usaremos `everything()` para analisar todas as variáveis numéricas nos dados. Por padrão, o genótipo e a interação genótipo *vs* ambiente são considerados efeitos aleatórios. Outros efeitos podem ser considerados usando o argumento `random`. O último argumento (`verbose`) controla se o código é executado silenciosamente ou não.


```r
met_mixed <-
  gamem_met(df_ge,
            env = ENV,
            gen = GEN,
            rep = BLOCO,
            resp = everything(),
            random = "gen", #Default
            verbose = TRUE) #Padrão
## Evaluating trait ALT_PLANT |====                                 | 10% 00:00:00 
Evaluating trait ALT_ESP |========                               | 20% 00:00:00 
Evaluating trait COMPES |============                            | 30% 00:00:01 
Evaluating trait DIAMES |================                        | 40% 00:00:01 
Evaluating trait COMP_SAB |===================                   | 50% 00:00:01 
Evaluating trait DIAM_SAB |=======================               | 60% 00:00:01 
Evaluating trait MGE |==============================             | 70% 00:00:02 
Evaluating trait NFIL |==================================        | 80% 00:00:02 
Evaluating trait MMG |=======================================    | 90% 00:00:02 
Evaluating trait NGE |===========================================| 100% 00:00:03 
## Method: REML/BLUP
## Random effects: GEN, GEN:ENV
## Fixed effects: ENV, REP(ENV)
## Denominador DF: Satterthwaite's method
## ---------------------------------------------------------------------------
## P-values for Likelihood Ratio Test of the analyzed traits
## ---------------------------------------------------------------------------
##     model ALT_PLANT  ALT_ESP  COMPES   DIAMES COMP_SAB DIAM_SAB      MGE
##  COMPLETE        NA       NA      NA       NA       NA       NA       NA
##       GEN  9.39e-01 1.00e+00 1.00000 2.99e-01 1.00e+00 0.757438 6.21e-01
##   GEN:ENV  1.09e-13 8.12e-12 0.00103 1.69e-08 9.62e-17 0.000429 4.92e-07
##      NFIL      MMG     NGE
##        NA       NA      NA
##  1.00e+00 1.00e+00 1.00000
##  4.88e-05 4.21e-10 0.00101
## ---------------------------------------------------------------------------
## All variables with significant (p < 0.05) genotype-vs-environment interaction
```

### Gráfico de diagnóstico para resíduos

A função genérica S3 `plot()` é usada para gerar gráficos de diagnóstico de resíduos do modelo.


```r
plot(met_mixed)
## `geom_smooth()` using formula 'y ~ x'
## `geom_smooth()` using formula 'y ~ x'
```

<img src="/tutorials/gemsr/06_conjunta_files/figure-html/unnamed-chunk-4-1.png" width="672" />

A normalidade dos efeitos aleatórios de genótipo e efeitos de interação também podem ser obtidos usando `type =" re "`.


```r
plot(met_mixed, type = "re")
```

<img src="/tutorials/gemsr/06_conjunta_files/figure-html/unnamed-chunk-5-1.png" width="960" />

### LRT

A saída `LRT` contém os testes de razão de verossimilhança para genótipo e efeitos aleatórios genótipo versus ambiente. Podemos obter esses valores com `get_model_data()`


```r
dados <- gmd(met_mixed, "lrt")
## Class of the model: waasb
## Variable extracted: lrt
```

### Componentes de variância


```r
gmd(met_mixed, "vcomp")
## Class of the model: waasb
## Variable extracted: vcomp
## # A tibble: 3 x 11
##   Group  ALT_PLANT  ALT_ESP COMPES DIAMES COMP_SAB DIAM_SAB   MGE  NFIL      MMG
##   <chr>      <dbl>    <dbl>  <dbl>  <dbl>    <dbl>    <dbl> <dbl> <dbl>    <dbl>
## 1 GEN     0.000455 7.40e-11  0      0.557     0      0.0292  30.3 0     8.54e-13
## 2 GEN:E~  0.0425   3.03e- 2  0.463  2.82      3.57   0.455  343.  0.958 1.15e+ 3
## 3 Resid~  0.0224   2.07e- 2  1.08   2.59      1.65   0.903  387.  1.64  9.18e+ 2
## # ... with 1 more variable: NGE <dbl>
plot(met_mixed, type = "vcomp")
```

<img src="/tutorials/gemsr/06_conjunta_files/figure-html/unnamed-chunk-7-1.png" width="960" />


### Parâmetros genéticos


```r
gmd(met_mixed, "genpar")
## Class of the model: waasb
## Variable extracted: genpar
## # A tibble: 9 x 11
##   Parameters     ALT_PLANT ALT_ESP COMPES DIAMES COMP_SAB DIAM_SAB     MGE  NFIL
##   <chr>              <dbl>   <dbl>  <dbl>  <dbl>    <dbl>    <dbl>   <dbl> <dbl>
## 1 Phenotypic va~   0.0654  5.11e-2  1.55  5.97      5.22    1.39   7.60e+2 2.60 
## 2 Heritability     0.00696 1.45e-9  0     0.0932    0       0.0211 3.99e-2 0    
## 3 GEIr2            0.650   5.94e-1  0.299 0.472     0.683   0.328  4.51e-1 0.368
## 4 h2mg             0.0351  7.95e-9  0     0.377     0       0.134  2.04e-1 0    
## 5 Accuracy         0.187   8.92e-5  0     0.614     0       0.366  4.52e-1 0    
## 6 rge              0.655   5.94e-1  0.299 0.521     0.683   0.335  4.70e-1 0.368
## 7 CVg              0.858   6.40e-4  0     1.51      0       1.07   3.18e+0 0    
## 8 CVr              6.03    1.07e+1  6.87  3.25      4.43    5.95   1.14e+1 7.95 
## 9 CV ratio         0.142   5.97e-5  0     0.463     0       0.180  2.80e-1 0    
## # ... with 2 more variables: MMG <dbl>, NGE <dbl>
```


Na saída acima, além dos componentes de variância para os efeitos aleatórios declarados, alguns parâmetros importantes também são mostrados.

**Heritability** é a herdabilidade em sentido amplo, \\(\mathop h \nolimits_g ^ 2\\), estimada por 

$$
\mathop h\nolimits_g^2  = \frac{\mathop {\hat\sigma} \nolimits_g^2} {\mathop {\hat\sigma} \nolimits_g^2  + \mathop {\hat\sigma} \nolimits_i^2  + \mathop {\hat\sigma} \nolimits_e^2 }
$$

onde \\(\mathop {\hat \sigma} \nolimits_g ^ 2\\) é a variância genotípica; \\(\mathop {\hat \sigma} \nolimits_i ^ 2\\) é a variância da interação genótipo *vs* ambiente; e \\(\mathop {\hat \sigma} \nolimits_e ^ 2\\) é a variância residual.

**GEIr2** é o coeficiente de determinação dos efeitos de interação, \\(\mathop r \nolimits_i ^ 2\\), estimado por

$$
\mathop r\nolimits_i^2  = \frac{\mathop {\hat\sigma} \nolimits_i^2}
{\mathop {\hat\sigma} \nolimits_g^2  + \mathop {\hat\sigma} \nolimits_i^2  + \mathop {\hat\sigma} \nolimits_e^2 }
$$

**h2mg** é a herdabilidade com base na média, \\(\mathop h \nolimits\_{gm} ^ 2\\), estimada por

$$
\mathop h\nolimits_{gm}^2  = \frac{\mathop {\hat\sigma} \nolimits_g^2}{[\mathop {\hat\sigma} \nolimits_g^2  + \mathop {\hat\sigma} \nolimits_i^2 /e + \mathop {\hat\sigma} \nolimits_e^2 /\left( {eb} \right)]}
$$

onde *e* e *b* são o número de ambientes e blocos, respectivamente;

**Accuracy** é a acurácia de seleção, *Ac*, estimada por

$$
Ac = \sqrt{\mathop h\nolimits_{gm}^2}
$$

**rge** é a correlação genótipo-ambiente, \\(\mathop r \nolimits\_{ge}\\), estimada por

$$
\mathop r\nolimits_{ge} = \frac{\mathop {\hat\sigma} \nolimits_g^2}{\mathop {\hat\sigma} \nolimits_g^2  + \mathop {\hat\sigma} \nolimits_i^2}
$$

**CVg** e **CVr** são o coeficiente de variação genotípico e o coeficiente de variação residual estimado, respectivamente, por

$$
CVg  = \left( {\sqrt {\mathop {\hat \sigma }\nolimits_g^2 } /\mu } \right) \times 100
$$

e 

$$
CVr = \left( {\sqrt {\mathop {\hat \sigma }\nolimits_e^2 } /\mu } \right) \times 100
$$


onde \\(\mu\\) é a média geral.

**CV ratio** é a razão entre o coeficiente de variação genotípico e residual.


### BLUP para genótipos


```r
met_mixed$MGE$BLUPgen
## # A tibble: 13 x 7
##     Rank GEN       Y  BLUPg Predicted    LL    UL
##    <dbl> <fct> <dbl>  <dbl>     <dbl> <dbl> <dbl>
##  1     1 H6     188.  3.08       176.  168.  184.
##  2     2 H2     187.  2.87       176.  168.  184.
##  3     3 H4     184.  2.31       175.  167.  183.
##  4     4 H1     184.  2.21       175.  167.  183.
##  5     5 H5     184.  2.19       175.  167.  183.
##  6     6 H13    180.  1.41       174.  166.  182.
##  7     7 H7     171. -0.386      173.  164.  181.
##  8     8 H3     169. -0.712      172.  164.  180.
##  9     9 H11    167. -1.16       172.  164.  180.
## 10    10 H10    164. -1.85       171.  163.  179.
## 11    11 H8     160. -2.67       170.  162.  178.
## 12    12 H12    157. -3.16       170.  162.  178.
## 13    13 H9     153. -4.12       169.  161.  177.
gmd(met_mixed, "blupg")
## Class of the model: waasb
## Variable extracted: blupg
## # A tibble: 13 x 11
##    GEN   ALT_PLANT ALT_ESP COMPES DIAMES COMP_SAB DIAM_SAB   MGE  NFIL   MMG
##    <fct>     <dbl>   <dbl>  <dbl>  <dbl>    <dbl>    <dbl> <dbl> <dbl> <dbl>
##  1 H1         2.49    1.34   15.2   50.2     29.0     15.9  175.  16.1  339.
##  2 H10        2.48    1.34   15.2   49.1     29.0     16.0  171.  16.1  339.
##  3 H11        2.48    1.34   15.2   49.2     29.0     16.0  172.  16.1  339.
##  4 H12        2.48    1.34   15.2   49.2     29.0     15.8  170.  16.1  339.
##  5 H13        2.49    1.34   15.2   49.9     29.0     16.0  174.  16.1  339.
##  6 H2         2.49    1.34   15.2   50.1     29.0     16.0  176.  16.1  339.
##  7 H3         2.49    1.34   15.2   49.5     29.0     15.9  172.  16.1  339.
##  8 H4         2.49    1.34   15.2   49.4     29.0     16.0  175.  16.1  339.
##  9 H5         2.49    1.34   15.2   49.7     29.0     16.1  175.  16.1  339.
## 10 H6         2.49    1.34   15.2   50.3     29.0     16.1  176.  16.1  339.
## 11 H7         2.48    1.34   15.2   49.5     29.0     16.0  173.  16.1  339.
## 12 H8         2.48    1.34   15.2   49.1     29.0     16.0  170.  16.1  339.
## 13 H9         2.48    1.34   15.2   48.8     29.0     16.0  169.  16.1  339.
## # ... with 1 more variable: NGE <dbl>
```

### Plotar o BLUP para genótipos


```r
a <- plot_blup(met_mixed, var = "MGE")
b <- plot_blup(met_mixed,
               var = "MGE",
               col.shape = c("gray20", "gray80"),
               plot_theme = theme_metan(grid = "y"))
arrange_ggplot(a, b, tag_levels = "a")
```

<img src="/tutorials/gemsr/06_conjunta_files/figure-html/unnamed-chunk-10-1.png" width="960" />

Esta saída mostra as médias previstas para genótipos. **BLUPg** é o efeito genotípico \\((\hat{g} \_{i})\\), que considerando dados balanceados e genótipo como efeito aleatório é estimado por

$$
\hat{g}_{i} = h_g ^ 2(\bar {y}_{i.} - \bar {y}_{..})
$$

onde \\(h_g ^ 2\\) é o efeito de encolhimento do genótipo.

**Predicted** é a média predita, dada por

$$
\hat {g}_{i} + \mu
$$

onde \\(\mu\\) é a média geral.



**LL** e **UL** são os limites inferior e superior, respectivamente, estimados por 

$$
(\hat {g}_{i} + \mu) \pm {CI}
$$

com

$$
CI = t \times \sqrt {((1-Ac) \times {\mathop \sigma \nolimits_g ^ 2)}}
$$

onde \\(t\\) é o valor *t* de Student para um teste *t* bicaudal em uma data probabilidade; \\(Ac\\) é a acurácia da seleção e \\(\mathop\sigma\nolimits_g ^2\\) é a variância genotípica.

### BLUP para combinação de genótipos X ambiente


```r
met_mixed$MGE$BLUPint
## # A tibble: 156 x 7
##    ENV   GEN   REP   BLUPg  BLUPge `BLUPg+ge` Predicted
##    <fct> <fct> <fct> <dbl>   <dbl>      <dbl>     <dbl>
##  1 A1    H1    I      2.21   0.759       2.97      204.
##  2 A1    H1    II     2.21   0.759       2.97      203.
##  3 A1    H1    III    2.21   0.759       2.97      200.
##  4 A1    H10   I     -1.85  -3.76       -5.61      196.
##  5 A1    H10   II    -1.85  -3.76       -5.61      194.
##  6 A1    H10   III   -1.85  -3.76       -5.61      192.
##  7 A1    H11   I     -1.16  -7.28       -8.45      193.
##  8 A1    H11   II    -1.16  -7.28       -8.45      191.
##  9 A1    H11   III   -1.16  -7.28       -8.45      189.
## 10 A1    H12   I     -3.16 -11.5       -14.6       187.
## # ... with 146 more rows
```

Esta saída mostra as médias previstas para cada combinação de genótipo e ambiente. **BLUPg** é o efeito genotípico descrito acima. **BLUPge** é o efeito genotípico do *i* th genótipo no *j* th ambiente \\((\hat {g}_{ij})$, que considerando dados balanceados e genótipo como efeito aleatório é estimado por:

$$
\hat {g}_{ij} = h_g ^ 2 (\bar {y}_{i.} - \bar {y}_{..}) + h_{ge} ^ 2 (y_{ij} - \bar {y}_{i.} - \bar {y}_{. j} + \bar {y}_{..})
$$

onde \\(h_{ge} ^2\\) é o efeito de encolhimento para a interação genótipo por ambiente; 

**BLUPg + ge** é \\(BLUP_g + BLUP_{ge}\\);

**Predicted** é o valor predito (\\(\hat {y}_{ij}\\)) dado por


$$
\hat{y}_{ij} = \bar{y}_{.j}+BLUP_{g+ge}
$$


[^1]: Henderson, C. R. (1975). Best linear unbiased estimation and prediction under a selection model. *Biometrics*, *31*(2), 423--447. <https://doi.org/10.2307/2529430>
