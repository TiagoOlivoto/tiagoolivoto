---
title: ANOVA - DIC
linktitle: "7. Delineamento de Blocos Casualizados"
toc: true
type: docs
date: "2022/02/10"
draft: false
df_print: paged
code_download: true
menu:
  experimentacao:
    parent: Experimentação
    weight: 8
---


# Pacotes

```r
library(tidyverse)  # manipulação de dados
library(metan)      # estatísticas descritivas
library(rio)        # importação/exportação de dados
library(emmeans)    # comparação de médias
library(AgroR)      # casualização e ANOVA
library(ExpDes.pt)
```


# Delineamento de Blocos Completos Casualizados (DBC)

No Delineamento de Blocos Completos Casualizados uma restrição na casualização é imposta visando agrupar unidades experimentais uniformes dentro de um bloco, de maneira que a heterogeneidade da área experimental fique entre os blocos. O bloqueamento tem como objetivo reduzir o erro experimental, *"transferindo"* parte do erro experimental para efeito de bloco. 

## Características

* Utiliza apenas os princípios de repetição e casualização;
* Os tratamentos são alocados nas parcelas de forma inteiramente casual, sem nenhum tipo de bloqueamento.
* Exige que o material experimental e a área experimental sejam uniformes.
Ele geralmente é mais utilizado em experimentos nos quais as condições experimentais podem ser bastante controladas (por exemplo em laboratórios);


## Vantagens
* Controla as diferenças que ocorrem nas condições ambientais, de um bloco para outro;
* Pode haver heterogeneidade conhecida na área, desde que a alocação dos blocos seja feita de forma correta
* A variação entre blocos é isolada, logo, reduzindo a variância residual


## Desvantagens
* Devido a inclusão de mais uma fonte de variação no modelo, há uma redução nos graus de liberdade do erro.

* Como exige-se homogeneidade dentro dos blocos, o número de tratamentos pode ficar limitado, visto que quanto maior é o bloco, mais difícil manter a sua homogeneidade.




## Casualização
Para realizar a casualização em um experimento em DBC, pode-se utilizar a função [`sketch`](https://agronomiar.github.io/AgroR_Tutorial/fun%C3%A7%C3%A3o-para-croqui-experimental.html#delineamento-inteiramente-casualizado) do pacote agroR. Neste exemplo, simulo a casualização de três tratamentos em um ensaio conduzido em delineamento de blocos completos casualizados com quatro repetições (`r`). Apenas para fins didáticos, é apresentada também a casualização em DIC.


```r
trats <- c("50", "70", "100")

# casualização em DIC
sketch(trats, r = 4, pos = "line")
```

<img src="/classes/experimentacao/07_dbc_files/figure-html/unnamed-chunk-2-1.png" width="672" />

```r
# casualização em DBC
sketch(trats, r = 4, design = "DBC", pos = "line")
```

<img src="/classes/experimentacao/07_dbc_files/figure-html/unnamed-chunk-2-2.png" width="672" />



# Conjunto de dados

O conjunto de dados utilizado neste exemplo é oriundo de um experimento que avaliou caracteres qualitativos e quantitativos de chicória sob diferentes níveis de sombreamento

>OLIVOTO, T.; ELLI, E. F.; SCHMIDT, D.; CARON, B. O.; DE SOUZA, V. Q. Photosynthetic photon flux density levels affect morphology and bromatology in *Cichorium endivia* L. var. *latifolia* grown in a hydroponic system. **Scientia Horticulturae**, v. 230, p. 178–185, 2018. Disponível em: https://doi.org/10.1016/j.scienta.2017.11.031

Para fins didáticos, a área foliar (AF, cm$^2$) e a matéria seca por planta (MST, g planta$^{-1}$) mensuradas aos 35 dias após a implantação são apresentadas aqui.

Para importação, utiliza-se a função `import()` do pacote `rio`. A função `as_factor` converte as primeiras duas colunas para fator.



```r
url <- "http://bit.ly/df_biostat_exp"
df_dbc <- import(url, sheet = "DIC-DBC", setclass = "tbl")
df_dbc <- as_factor(df_dbc, 1:2)
```

No seguinte gráfico, apresento as médias para tratamentos e blocos. Neste caso, observa-se que o bloco 1 apresenta uma média relativamente superior aos outros blocos, sugerindo que o efeito de bloco poderá ser significativo neste caso.


```r
trat <- plot_bars(df_dbc, RAD, MST)
bloco <- plot_bars(df_dbc, REP, MST)
arrange_ggplot(trat, bloco)
```

<img src="/classes/experimentacao/07_dbc_files/figure-html/unnamed-chunk-4-1.png" width="672" />


# Verificação de outliers
A função `inspect` do pacote `metan` é utilizada para inspecionar o conjunto de dados. Com esta função, é possível identificar possíveis outliers, bem como valores faltantes.


```r
inspect(df_dbc, plot = TRUE)
## # A tibble: 5 x 9
##   Variable Class   Missing Levels Valid_n     Min  Median     Max Outlier
##   <chr>    <chr>   <chr>   <chr>    <int>   <dbl>   <dbl>   <dbl>   <dbl>
## 1 RAD      factor  No      3           12   NA      NA      NA         NA
## 2 REP      factor  No      4           12   NA      NA      NA         NA
## 3 AF_M2    numeric No      -           12    3.65    5.28    6.12       0
## 4 AF       numeric No      -           12 3648.   5287.   6118.         0
## 5 MST      numeric No      -           12   10.7    13.6    16.9        0
```

<img src="/classes/experimentacao/07_dbc_files/figure-html/unnamed-chunk-5-1.png" width="672" />


# Estatística descritiva 

A função `desc_stat()` do pacote `metan` computa estatísticas descritivas para os dois caracteres numéricos (AF e MST).


```r
desc_stat(df_dbc)
## # A tibble: 3 x 9
##   variable    cv     max    mean  median     min  sd.amo      se      ci
##   <chr>    <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>
## 1 AF        14.7 6118.   5144.   5287.   3648.   755.    218.    479.   
## 2 AF_M2     14.6    6.12    5.14    5.28    3.65   0.753   0.217   0.478
## 3 MST       16.0   16.9    13.7    13.6    10.7    2.20    0.634   1.40
```



# Análise de variância
## Modelo estatístico


O modelo do DBC é dado por

$$
{Y_{ij}} = m + {b_j} + {t_i} + {\varepsilon _{ij}}
$$

Onde \$m\$ é a média geral do experimento, \$b_j\$ é o efeito de bloco, \$t_i\$ é o efeito de tratamentos e \$\epsilon_{ij}\$ é o erro experimental.

## Análise de variância
A análise de variância é computada no software R utilizando a função `aov()`. Considerando o Delineamento de Blocos Casualizados (DBC), as duas fontes de variação incluídas no modelo são a de tratamento (`RAD`) e bloco (`REP`).



```r
anova <- aov(MST ~ RAD + REP, data = df_dbc)
summary(anova)
##             Df Sum Sq Mean Sq F value   Pr(>F)    
## RAD          2  45.06  22.529  138.78 9.47e-06 ***
## REP          3   7.07   2.356   14.51  0.00371 ** 
## Residuals    6   0.97   0.162                     
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```


## Comparação de médias
A análise de variância revelou efeito de tratamento significativo. Nesse caso, segue-se realizando uma análise de comparação múltipla de médias. Podemos realizar a comparação par-a-par utilizando a função `pwpm()` do pacote `emmeans`. Neste exemplo, o teste Tukey é utilizado.

Neste exemplo, utilizaremos a função `emmeans` para realizar a comparação de médias pelo teste Tukey. Nesta abordagem, a avaliação da significância das médias de dois tratamentos é dada pela sobreposição das flechas de cada tratamento. Se dois tratamentos apresentam setas que se sobrepõem (considerando o eixo x), assume-se que estes tratamentos são estatisticamente diferentes um do outro.

Apenas para fins de comparação, incluirei a comparação de médias considerando o modelo DIC. Observe que a redução da estimativa do erro experimental considerando o delineamento DBC fez com que 


```r
anova_dic <- aov(MST ~ RAD, data = df_dbc)
medias_dic <- emmeans(anova_dic, ~ RAD)

medias_dbc <- emmeans(anova, ~ RAD)

plot_dic <- 
  plot(medias_dic,
       CIs = FALSE, # remove os intervalos de confiança das médias
       comparisons = TRUE) # insere setas para comparação de médias (Tukey)

plot_dbc <- 
  plot(medias_dbc,
       CIs = FALSE, # remove os intervalos de confiança das médias
       comparisons = TRUE) # insere setas para comparação de médias (Tukey)

arrange_ggplot(plot_dbc,
               plot_dic,
               ncol = 1,
               tag_levels = "a")
```

<div class="figure">
<img src="/classes/experimentacao/07_dbc_files/figure-html/unnamed-chunk-8-1.png" alt="Comparações entre pares de médias com base no teste Tukey considerando o delineamento inteiramente casualizado (a) e o delineamento de blocos casualizados (b)" width="672" />
<p class="caption">Figure 1: Comparações entre pares de médias com base no teste Tukey considerando o delineamento inteiramente casualizado (a) e o delineamento de blocos casualizados (b)</p>
</div>


# Pacote AgroR

No pacote [agroR](https://agronomiar.github.io/AgroR_Tutorial/delineamento-em-blocos-casualizados-1.html), a análise de variância neste delineamento pode ser realizada com a função `DBC()`.


```r
with(df_dbc,
     DBC(RAD, REP, MST))
```

<img src="/classes/experimentacao/07_dbc_files/figure-html/unnamed-chunk-9-1.png" width="672" />

```
## 
## -----------------------------------------------------------------
## Normality of errors
## -----------------------------------------------------------------
##                          Method Statistic   p.value
##  Shapiro-Wilk normality test(W) 0.9445588 0.5592776
## 
## 
## -----------------------------------------------------------------
## Homogeneity of Variances
## -----------------------------------------------------------------
##                               Method Statistic   p.value
##  Bartlett test(Bartlett's K-squared) 0.4182676 0.8112867
## 
## 
## -----------------------------------------------------------------
## Independence from errors
## -----------------------------------------------------------------
##                  Method Statistic   p.value
##  Durbin-Watson test(DW)  1.521488 0.1169862
## 
## 
## -----------------------------------------------------------------
## Additional Information
## -----------------------------------------------------------------
## 
## CV (%) =  2.94
## R-squared =  0.9
## Mean =  13.7232
## Median =  13.5946
## Possible outliers =  No discrepant point
## 
## -----------------------------------------------------------------
## Analysis of Variance
## -----------------------------------------------------------------
##           Df     Sum Sq    Mean.Sq   F value        Pr(F)
## trat       2 45.0579657 22.5289828 138.78145 9.473392e-06
## bloco      3  7.0667049  2.3555683  14.51061 3.707071e-03
## Residuals  6  0.9740055  0.1623343                       
## 
## 
## -----------------------------------------------------------------
## Multiple Comparison Test
## -----------------------------------------------------------------
##         resp groups
## 100 15.94093      a
## 70  14.00834      b
## 50  11.22022      c
```

<img src="/classes/experimentacao/07_dbc_files/figure-html/unnamed-chunk-9-2.png" width="672" />



# Notas da aula prática

```r
url <- "http://bit.ly/df_biostat_exp"
df_af <- import(url, sheet = "DIC-DBC")
df_af <- as_factor(df_af, 1:2)

tabela <- 
  df_af %>% 
  make_mat(RAD, REP, AF_M2) %>% 
  row_col_sum()

tabela
```

```
##              1     2     3     4 row_sums
## 50        5.02  3.65  3.93  4.71    17.31
## 70        6.12  5.61  5.11  4.98    21.82
## 100       5.46  5.55  5.72  5.87    22.60
## col_sums 16.60 14.81 14.76 15.56    61.73
```

```r
# ExpDes
with(df_af, dbc(RAD, REP, AF_M2))
```

```
## ------------------------------------------------------------------------
## Quadro da analise de variancia
## ------------------------------------------------------------------------
##            GL     SQ      QM     Fc   Pr>Fc
## Tratamento  2 4.0777 2.03886 8.6546 0.01706
## Bloco       3 0.7397 0.24656 1.0466 0.43768
## Residuo     6 1.4135 0.23558               
## Total      11 6.2309                       
## ------------------------------------------------------------------------
## CV = 9.44 %
## 
## ------------------------------------------------------------------------
## Teste de normalidade dos residuos 
## valor-p:  0.03513576 
## ATENCAO: a 5% de significancia, os residuos nao podem ser considerados normais!
## ------------------------------------------------------------------------
## 
## ------------------------------------------------------------------------
## Teste de homogeneidade de variancia 
## valor-p:  0.9731437 
## De acordo com o teste de oneillmathews a 5% de significancia, as variancias podem ser consideradas homogeneas.
## ------------------------------------------------------------------------
## 
## Teste de Tukey
## ------------------------------------------------------------------------
## Grupos Tratamentos Medias
## a 	 100 	 5.65 
## a 	 70 	 5.455 
##  b 	 50 	 4.3275 
## ------------------------------------------------------------------------
```

```r
# AgroR
with(df_af, DBC(RAD, REP, AF_M2))
```

```
## 
## -----------------------------------------------------------------
## Normality of errors
## -----------------------------------------------------------------
##                          Method Statistic    p.value
##  Shapiro-Wilk normality test(W) 0.8484538 0.03513576
```

```
## As the calculated p-value is less than the 5% significance level, H0 is rejected. Therefore, errors do not follow a normal distribution
```

```
## 
## -----------------------------------------------------------------
## Homogeneity of Variances
## -----------------------------------------------------------------
##                               Method   Statistic   p.value
##  Bartlett test(Bartlett's K-squared) 0.003188021 0.9984073
```

```
## As the calculated p-value is greater than the 5% significance level, hypothesis H0 is not rejected. Therefore, the variances can be considered homogeneous
```

```
## 
## -----------------------------------------------------------------
## Independence from errors
## -----------------------------------------------------------------
##                  Method Statistic    p.value
##  Durbin-Watson test(DW)  1.327161 0.06425358
```

```
## As the calculated p-value is greater than the 5% significance level, hypothesis H0 is not rejected. Therefore, errors can be considered independent
```

```
## 
## -----------------------------------------------------------------
## Additional Information
## -----------------------------------------------------------------
## 
## CV (%) =  9.44
## R-squared =  0.81
## Mean =  5.1442
## Median =  5.285
## Possible outliers =  No discrepant point
## 
## -----------------------------------------------------------------
## Analysis of Variance
## -----------------------------------------------------------------
##           Df    Sum Sq   Mean.Sq  F value      Pr(F)
## trat       2 4.0777167 2.0388583 8.654612 0.01705573
## bloco      3 0.7396917 0.2465639 1.046622 0.43767865
## Residuals  6 1.4134833 0.2355806
```

```
## As the calculated p-value, it is less than the 5% significance level. The hypothesis H0 of equality of means is rejected. Therefore, at least two treatments differ
```

```
## 
## -----------------------------------------------------------------
## Multiple Comparison Test
## -----------------------------------------------------------------
##       resp groups
## 100 5.6500      a
## 70  5.4550      a
## 50  4.3275      b
```

```
## 
## Your analysis is not valid, suggests using a non-parametric 
## test and try to transform the data
```

<img src="/classes/experimentacao/07_dbc_files/figure-html/unnamed-chunk-10-1.png" width="672" /><img src="/classes/experimentacao/07_dbc_files/figure-html/unnamed-chunk-10-2.png" width="672" />

```r
# AgroR - DIC
with(df_af, DIC(RAD, AF_M2))
```

```
## 
## -----------------------------------------------------------------
## Normality of errors
## -----------------------------------------------------------------
##                          Method Statistic   p.value
##  Shapiro-Wilk normality test(W) 0.9615261 0.8053778
```

```
## As the calculated p-value is greater than the 5% significance level, hypothesis H0 is not rejected. Therefore, errors can be considered normal
```

```
## 
## -----------------------------------------------------------------
## Homogeneity of Variances
## -----------------------------------------------------------------
##                               Method Statistic   p.value
##  Bartlett test(Bartlett's K-squared)  3.411877 0.1816019
```

```
## As the calculated p-value is greater than the 5% significance level,hypothesis H0 is not rejected. Therefore, the variances can be considered homogeneous
```

```
## 
## -----------------------------------------------------------------
## Independence from errors
## -----------------------------------------------------------------
##                  Method Statistic  p.value
##  Durbin-Watson test(DW)  1.537837 0.056558
```

```
## As the calculated p-value is greater than the 5% significance level, hypothesis H0 is not rejected. Therefore, errors can be considered independent
```

```
## 
## -----------------------------------------------------------------
## Additional Information
## -----------------------------------------------------------------
## 
## CV (%) =  9.51
## R-squared =  0.89
## Mean =  5.1442
## Median =  5.285
## Possible outliers =  No discrepant point
## 
## -----------------------------------------------------------------
## Analysis of Variance
## -----------------------------------------------------------------
##           Df   Sum Sq   Mean.Sq  F value       Pr(F)
## trat       2 4.077717 2.0388583 8.522171 0.008382645
## Residuals  9 2.153175 0.2392417
```

```
## As the calculated p-value, it is less than the 5% significance level.The hypothesis H0 of equality of means is rejected. Therefore, at least two treatments differ
```

```
## 
## 
## -----------------------------------------------------------------
## Multiple Comparison Test
## -----------------------------------------------------------------
##       resp groups
## 100 5.6500      a
## 70  5.4550      a
## 50  4.3275      b
```

```
## 
```

<img src="/classes/experimentacao/07_dbc_files/figure-html/unnamed-chunk-10-3.png" width="672" /><img src="/classes/experimentacao/07_dbc_files/figure-html/unnamed-chunk-10-4.png" width="672" />


