---
title: Experimentos Fatoriais
linktitle: "3. FATORIAIS"
toc: true
type: docs
date: "2022/02/10"
draft: false
df_print: paged
code_download: true
menu:
  experimentacao:
    parent: Experimentação
    weight: 4
weight: 3
---

# Pacotes

```r
library(tidyverse)
library(metan)      # estatísticas descritivas
library(rio)        # importação/exportação de dados
library(emmeans)    # comparação de médias
library(AgroR)      # casualização e ANOVA
```


# Experimentos fatoriais

Experimentos fatoriais são muito comuns nas ciências agrárias, pois permitem o estudo de dois ou mais fatores em um mesmo experimento. Diversas são as vantagens em se conduzir um experimento deste tipo. Dentre elas, podemos citar a redução de custos, quando comparado à realizar um experimento para cada fator, a otimização da área experimental e dos tratos culturais, bem como a possibilidade de identificar o efeito de dois ou mais fatores sobre a magnitude da variável resposta. Esta é, talvez, a principal vantagem destes experimentos. Ao memo tempo, no entanto, é a fonte de um dos maiores desafios encontrados no meio acadêmico. O surgimento de uma terceira fonte de variação, conhecida por interação.


## Casualização


```r
sketch(trat= c("A1", "A2"),
       trat1 = c("B1", "B2", "B3"),
       design = "FAT2DBC",
       r = 4)
```

<img src="/classes/experimentacao/03_fatorial_files/figure-html/unnamed-chunk-2-1.png" width="672" />



## Tipos de interação

```r
# sem interação
dfsi <- tribble(
  ~GEN, ~FONTEN, ~RG,
  "Híbrido 1","Ureia",   5.7,
  "Híbrido 1","Nitrato", 6.8,
  "Híbrido 2","Ureia",   8.2,
  "Híbrido 2","Nitrato", 9.3)
p1 <-
  plot_factbars(dfsi, GEN, FONTEN, resp = RG,
                ylab = expression(paste("RG (Mg ",ha^-1, ")")),
                y.expand = 0.2,
                size.text = 16,
                values = TRUE,
                errorbar = F,
                xlab = "Híbrido",
                legend.position = c(0.2, 0.89)) +
  ggtitle("Ausência de interação")
```

```
## Warning in qt(level/2 + 0.5, n() - 1): NaNs produzidos

## Warning in qt(level/2 + 0.5, n() - 1): NaNs produzidos

## Warning in qt(level/2 + 0.5, n() - 1): NaNs produzidos

## Warning in qt(level/2 + 0.5, n() - 1): NaNs produzidos
```

```r
# interação simples
df_is <- tribble(
  ~GEN, ~FONTEN, ~RG,
  "Híbrido 1","Ureia",   4.5,
  "Híbrido 1","Nitrato", 1.9,
  "Híbrido 2","Ureia",   11,
  "Híbrido 2","Nitrato", 5.3)


p2 <-
  plot_factbars(df_is, GEN, FONTEN, resp = RG,
                ylab = expression(paste("RG (Mg ",ha^-1, ")")),
                y.expand = 0.2,
                size.text = 16,
                errorbar = F,
                values = TRUE,
                xlab = "Híbrido",
                legend.position = c(0.2, 0.89)) +
  ggtitle("Interação simples")
```

```
## Warning in qt(level/2 + 0.5, n() - 1): NaNs produzidos

## Warning in qt(level/2 + 0.5, n() - 1): NaNs produzidos

## Warning in qt(level/2 + 0.5, n() - 1): NaNs produzidos

## Warning in qt(level/2 + 0.5, n() - 1): NaNs produzidos
```

```r
# interação complexa
df_ic <- tribble(
  ~GEN, ~FONTEN, ~RG,
  "Híbrido 1","Ureia",   4.1,
  "Híbrido 1","Nitrato", 1.4,
  "Híbrido 2","Ureia",   6.2,
  "Híbrido 2","Nitrato", 8.4)

p3 <-
  plot_factbars(df_ic, GEN, FONTEN, resp = RG,
                ylab = expression(paste("RG (Mg ",ha^-1, ")")),
                y.expand = 0.2,
                size.text = 16,
                errorbar = F,
                values = TRUE,
                xlab = "Híbrido",
                legend.position = c(0.2, 0.89)) +
  ggtitle("Interação complexa")
```

```
## Warning in qt(level/2 + 0.5, n() - 1): NaNs produzidos

## Warning in qt(level/2 + 0.5, n() - 1): NaNs produzidos

## Warning in qt(level/2 + 0.5, n() - 1): NaNs produzidos

## Warning in qt(level/2 + 0.5, n() - 1): NaNs produzidos
```

```r
arrange_ggplot(p1, p2, p3, guides = "collect")
```

<img src="/classes/experimentacao/03_fatorial_files/figure-html/unnamed-chunk-3-1.png" width="960" />


## Modelo estatístico 
Vamos considerar como exemplo, um experimento que avaliou a influencia de dois fatores, digamos \$\alpha\$ e \$\tau\$, em uma determinada variável resposta. O modelo estatístico considerado neste tipo de experimento é:

$$
{y_{ijk}} = {\rm{ }}\mu {\rm{ }} + {\rm{ }}\mathop \beta \nolimits_{k}  + \mathop \alpha \nolimits_i  + \mathop \tau \nolimits_j  + \mathop {(\alpha \tau )}\nolimits_{ij}  + {\rm{ }}\mathop \varepsilon \nolimits_{ijk}
$$

onde \${y_{ijk}}\$ é o valor observado da combinação do *i*-ésimo nível do fator \$\alpha\$ com o *j*-ésimo nível do fator \$\tau\$ no *k*-ésimo bloco; \$\mu\$ é a média geral; \$\mathop \beta \nolimits_{k}\$ é o efeito do bloco *k*; \$\mathop \alpha \nolimits_i\$ é o efeito do *i*-ésimo nível de \$\alpha\$ ; \$\mathop \tau \nolimits_j\$ é o efeito do *j*-ésimo nível de \$\tau\$ ; \$\mathop {(\alpha \tau )}\nolimits_{ij}\$ é o efeito da interação do *i*-ésimo nível de \$\alpha\$ com o *j*-ésimo nível de \$\tau\$; e \$\mathop \varepsilon \nolimits_{ijk}\$ é o erro aleatório associado a \${y_{ijk}}\$, assumindo \$\mathop \varepsilon \nolimits_{ijk} \mathop \cap \limits^{iid} N(0,\mathop \sigma \nolimits^2 )\$.

Basicamente, estes fatores podem ser divididos em dois tipos: qualitativos e quantitativos. Um fator qualitativo é, como o nome já diz, relacionado a *qualidade*, ou seja, diferentes em tipo, mas não em quantidade. Como exemplo, podemos citar cultivares, defensivos agrícolas, práticas de manejo, etc. Um fator quantitativo, por outro lado, é caracterizado pela *quantidade* utilizada no experimento. Podemos citar, por exemplo, doses de adubação. Cabe ressaltar que o termo *fatorial* não indica um delineamento experimental, mas uma forma de arranjo de tratamentos na área parcela. Estes experimentos podem ser conduzidos tanto em DIC quanto DBC. Assim, em cada repetição/bloco, o tratamento a ser aplicado é a combinação dos níveis dos dois fatores.


## Conjunto de dados

O conjunto de dados utilizado neste exemplo é adaptado de OLIVOTO et al. (2016) sendo oriundo de um experimento que testou o efeito de diferentes parcelamentos de nitrogênio (N) associado ao uso de enxofre (S) na produtividade, componentes do rendimento e qualidade reológica da farinha de trigo.

>OLIVOTO, T. et al. Sulfur and nitrogen effects on industrial quality and grain yield of wheat. **Revista de Ciências Agroveterinárias**, v. 15, n. 1, p. 24–33, 2016. Disponível em: [https://doi.org/10.5965/223811711512016024](https://doi.org/10.5965/223811711512016024)

Os tratamentos consistiram da combinação de três níveis de parcelamento de N (DA: 100% no duplo anel; AF+DA: 50% no afilhamento + 50% no duplo anel; DA+ES: 50% no afilhamento + 50% no espigamento) e dois níveis de enxofre (S+: com enxofre; S-: sem enxofre).

Para fins didáticos, a extensibilidade da massa (L, mm) é utilizada. Para importação, utiliza-se a função `import()` do pacote `rio`. A função `as_factor` converte as primeiras três colunas para fator.



```r
url <- "http://bit.ly/df_biostat_exp"
df_fat <- import(url, sheet = "FAT1_CI2", setclass = "tbl")
df_fat <- as_factor(df_fat, 1:3)
```

No seguinte gráfico, apresento as médias observadas da extensibilidade nos diferentes tratamentos. 


```r
plot_factbars(df_fat, NIT, ENX, resp = L)
```

<img src="/classes/experimentacao/03_fatorial_files/figure-html/unnamed-chunk-5-1.png" width="672" />


## Verificação de outliers
A função `inspect` do pacote `metan` é utilizada para inspecionar o conjunto de dados. Com esta função, é possível identificar possíveis outliers, bem como valores faltantes.


```r
inspect(df_fat, plot = TRUE)
## # A tibble: 4 x 9
##   Variable Class   Missing Levels Valid_n   Min Median   Max Outlier
##   <chr>    <chr>   <chr>   <chr>    <int> <dbl>  <dbl> <dbl>   <dbl>
## 1 ENX      factor  No      2           24    NA   NA      NA      NA
## 2 NIT      factor  No      3           24    NA   NA      NA      NA
## 3 REP      factor  No      4           24    NA   NA      NA      NA
## 4 L        numeric No      -           24    67   78.5    96       0
```

<img src="/classes/experimentacao/03_fatorial_files/figure-html/unnamed-chunk-6-1.png" width="672" />


## Estatística descritiva 

A função `desc_stat()` do pacote `metan` computa estatísticas descritivas para a variável L.


```r
desc_stat(df_fat)
## # A tibble: 1 x 9
##   variable    cv   max  mean median   min sd.amo    se    ci
##   <chr>    <dbl> <dbl> <dbl>  <dbl> <dbl>  <dbl> <dbl> <dbl>
## 1 L         10.5    96  80.4   78.5    67   8.43  1.72  3.56
```


## Análise de variância

A análise de variância é computada no software R utilizando a função `aov()`. Considerando o Delineamento de Blocos Casualizados (DBC), as três fontes de variação incluídas no modelo são a de enxofre (`ENX`), nitrogênio (`NIT`) e bloco (`REP`). Note que todos os termos (efeito principal e interação) podem ser declarados quando se utiliza `ENX*NIT`; também é possível indicar termos específicos no modelo.



```r
# opção 1
anova <- aov(L ~ ENX*NIT + REP, data = df_fat)
# modelo idêntico, indicando os termos explicitamente
anova <- aov(L ~ ENX + NIT + ENX:NIT + REP, data = df_fat)
summary(anova)
##             Df Sum Sq Mean Sq F value   Pr(>F)    
## ENX          1  287.0   287.0  14.655  0.00165 ** 
## NIT          2  739.0   369.5  18.865 8.04e-05 ***
## REP          3   10.5     3.5   0.178  0.90965    
## ENX:NIT      2  305.3   152.7   7.795  0.00477 ** 
## Residuals   15  293.8    19.6                     
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```


## Comparação de médias
A análise de variância revelou efeito significativo da interação. Nesse caso, segue-se comparando as médias do fator nitrogênio dentro de cada nível do fator enxofre e do enxofre dentro de cada nível do fator nitrogênio. Para isso, utilizo o pacote `emmeans` (teste Tukey). Nesta abordagem, a avaliação da significância das médias de dois tratamentos é dada pela sobreposição das flechas de cada tratamento. Se dois tratamentos apresentam setas que se sobrepõem (considerando o eixo x), assume-se que estes tratamentos são estatisticamente diferentes um do outro.



```r
medias_fat <- emmeans(anova, ~ NIT | ENX)
plot(medias_fat,
     CIs = FALSE, # remove os intervalos de confiança das médias
     comparisons = TRUE) # insere setas para comparação de médias (Tukey)
```

<img src="/classes/experimentacao/03_fatorial_files/figure-html/unnamed-chunk-9-1.png" width="672" />


## Pacote AgroR

No pacote [agroR](https://agronomiar.github.io/AgroR_Tutorial/delineamento-em-blocos-casualizados-1.html), a análise de variância neste delineamento pode ser realizada com a função `FAT2DBC()`.


```r
with(df_fat,
     FAT2DBC(ENX, NIT, REP, L))
## 
## -----------------------------------------------------------------
## Normality of errors
## -----------------------------------------------------------------
##                          Method Statistic    p.value
##  Shapiro-Wilk normality test(W)  0.922206 0.06536118
## 
## 
## -----------------------------------------------------------------
## Homogeneity of Variances
## -----------------------------------------------------------------
##                               Method Statistic  p.value
##  Bartlett test(Bartlett's K-squared)  2.459752 0.782544
## 
## 
## -----------------------------------------------------------------
## Independence from errors
## -----------------------------------------------------------------
##                  Method Statistic    p.value
##  Durbin-Watson test(DW)  1.659457 0.03557374
## 
## 
## -----------------------------------------------------------------
## Additional Information
## -----------------------------------------------------------------
## 
## CV (%) =  5.51
## Mean =  80.375
## Median =  78.5
## Possible outliers =  No discrepant point
## 
## -----------------------------------------------------------------
## Analysis of Variance
## -----------------------------------------------------------------
##               Df    Sum Sq    Mean.Sq    F value        Pr(F)
## Fator1         1 287.04167 287.041667 14.6553680 1.645485e-03
## Fator2         2 739.00000 369.500000 18.8654092 8.038974e-05
## bloco          3  10.45833   3.486111  0.1779889 9.096501e-01
## Fator1:Fator2  2 305.33333 152.666667  7.7946391 4.774361e-03
## Residuals     15 293.79167  19.586111                        
## 
## -----------------------------------------------------------------
## 
## Significant interaction: analyzing the interaction
## 
## -----------------------------------------------------------------
## 
## -----------------------------------------------------------------
## Analyzing  F1  inside of each level of  F2
## -----------------------------------------------------------------
##                        Df Sum Sq Mean Sq F value    Pr(>F)    
## bloco                   3  10.46    3.49  0.1780 0.9096501    
## Fator2                  2 739.00  369.50 18.8654 8.039e-05 ***
## Fator2:Fator1           3 592.38  197.46 10.0815 0.0006909 ***
##   Fator2:Fator1: DA     1 406.13  406.13 20.7354 0.0003805 ***
##   Fator2:Fator1: AF+DA  1  15.12   15.12  0.7722 0.3933874    
##   Fator2:Fator1: DA+ES  1 171.12  171.12  8.7371 0.0098160 ** 
## Residuals              15 293.79   19.59                      
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## -----------------------------------------------------------------
## Analyzing  F2  inside of the level of  F1
## -----------------------------------------------------------------
## 
##                     Df  Sum Sq Mean Sq F value    Pr(>F)    
## bloco                3   10.46    3.49  0.1780  0.909650    
## Fator1               1  287.04  287.04 14.6554  0.001645 ** 
## Fator1:Fator2        4 1044.33  261.08 13.3300 7.897e-05 ***
##   Fator1:Fator2: S+  2  997.17  498.58 25.4560 1.508e-05 ***
##   Fator1:Fator2: S-  2   47.17   23.58  1.2041  0.327368    
## Residuals           15  293.79   19.59                      
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

<img src="/classes/experimentacao/03_fatorial_files/figure-html/unnamed-chunk-10-1.png" width="672" />

```
## 
## -----------------------------------------------------------------
## Final table
## -----------------------------------------------------------------
##         DA   AF+DA   DA+ES
## S+ 93.2 aA 71.5 aB 86.8 aA
## S- 79.0 bA 74.2 aA 77.5 bA
```




# Parcelas subdivididas

Experimentos fatoriais são úteis devido a possibilidade de se testar dois ou mais fatores em um mesmo experimento. Uma desvantagem deste tipo de experimento é que cada bloco deve receber todos os tratamentos, ou seja, todas as combinações dos níveis dos dois fatores. Assim, o número de parcelas no experimento e consequentemente o tamanho da área experimental crese drastricamente na medida em que são incluídos fatores ou níveis de fatores no experimento. Uma maneira de se contornar isto, é a condução de experimentos em parcelas subdivididas.

Parcelas subdivididas são um caso especial de estrutura de tratamentos fatorial em que um fator é alocado na parcela principal e outro fator é alocado na subparcela. Este tipo de estrutura de tratamentos pode ser utilizada quando um fator é de dificil instalação em pequenas parcelas, como por exemplo, a semeadura mecanizada ou um sistema de irrigação, e o segundo fator pode ser alocado em parcelas mais pequenas, como um doses de nitrogênio, por exemplo.

Diferentemente do modelo fatorial tradicional, o modelo estatístico para análise de experimentos em parcelas subdivididas conta com mais uma fonte de variação. Vamos considerar como exemplo, um experimento que avaliou a influência de dois fatores, digamos \$\alpha\$ e \$\tau\$, em uma determinada variável resposta, agora, conduzido em parcelas subivididas, onde o fator \$\alpha\$ foi alocado na parcela principal e o fator \$\tau\$ alocado na subparcela. O modelo estatístico considerado neste tipo de experimento é:

$$
{y_{ijk}} = {\rm{ }}\mu {\rm{ }} + {\rm{ }}\mathop \alpha \nolimits_i + \mathop \beta \nolimits_{k} + \mathop \eta \nolimits_{ik}  +\mathop \tau \nolimits_j  + \mathop {(\alpha \tau )}\nolimits_{ij}  + {\rm{ }}\mathop \varepsilon \nolimits_{ijk}
$$

onde \${y_{ijk}}\$ é a variável resposta observada; \$\mu\$ é a média geral; \$\mathop \alpha \nolimits_i\$ é o efeito do *i*-ésimo nível de \$\alpha\$ ; \$\mathop \beta \nolimits_{k}\$ é o efeito do bloco *k*; \$\mathop \eta \nolimits_{ik}\$ é o erro de parcela, mais conhecido como erro a; assumido \$\mathop \varepsilon \nolimits_{ijk} \mathop \cap \limits^{iid} N(0,\mathop \sigma \nolimits_\eta^2 )\$; \$\mathop \tau \nolimits_j\$ é o efeito do *j*-ésimo nível de \$\tau\$ ; \$\mathop {(\alpha \tau )}\nolimits_{ij}\$ é o efeito da interação do *i*-ésimo nível de \$\alpha\$ com o *j*-ésimo nível de \$\tau\$; e \$\mathop \varepsilon \nolimits_{ijk}\$ é o erro da subparcela, mais conhecido como erro b, assumindo \$\mathop \varepsilon \nolimits_{ijk} \mathop \cap \limits^{iid} N(0,\mathop \sigma \nolimits^2 )\$.

## Casualização


```r
sketch(trat= c("A1", "A2"),
       trat1 = c("B1", "B2", "B3"),
       design = "PSUBDBC",
       r = 4)
```

<img src="/classes/experimentacao/03_fatorial_files/figure-html/unnamed-chunk-11-1.png" width="672" />


## Análise de variância
Considerando o mesmo conjunto de dados do exemplo anterior e assumindo que o enxofre estava casualizado nas parcelas principais e o nitrogênio nas subparcelas, a análise de variância no software R é computada conforme segue

```r
anova_psub <- aov(L ~ ENX*NIT + Error(REP/ENX), data = df_fat)
summary(anova_psub)
```

```
## 
## Error: REP
##           Df Sum Sq Mean Sq F value Pr(>F)
## Residuals  3  10.46   3.486               
## 
## Error: REP:ENX
##           Df Sum Sq Mean Sq F value Pr(>F)  
## ENX        1 287.04  287.04   18.94 0.0224 *
## Residuals  3  45.46   15.15                 
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Error: Within
##           Df Sum Sq Mean Sq F value   Pr(>F)    
## NIT        2  739.0   369.5  17.855 0.000253 ***
## ENX:NIT    2  305.3   152.7   7.377 0.008142 ** 
## Residuals 12  248.3    20.7                     
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```




## Pacote AgroR

No pacote [agroR](https://agronomiar.github.io/AgroR_Tutorial/delineamento-em-blocos-casualizados-1.html), a análise de variância neste delineamento pode ser realizada com a função `PSUBDBC()`.


```r
with(df_fat,
     PSUBDBC(ENX, NIT, REP, L))
## 
## -----------------------------------------------------------------
## Normality of errors
## -----------------------------------------------------------------
##                          Method Statistic    p.value
##  Shapiro-Wilk normality test(W)  0.922206 0.06536118
## 
## 
## 
## -----------------------------------------------------------------
## Homogeneity of Variances
## -----------------------------------------------------------------
## Plot
##                               Method Statistic   p.value
##  Bartlett test(Bartlett's K-squared) 0.6768708 0.4106663
## 
## 
## ----------------------------------------------------
## Split-plot
##                               Method Statistic   p.value
##  Bartlett test(Bartlett's K-squared)  1.817323 0.4030634
## 
## 
## ----------------------------------------------------
## Interaction
##                               Method Statistic  p.value
##  Bartlett test(Bartlett's K-squared)  2.459752 0.782544
## 
## 
## -----------------------------------------------------------------
## Additional Information
## -----------------------------------------------------------------
## 
## CV1 (%) =  4.84
## CV2 (%) =  5.66
## Mean =  80.375
## Median =  78.5
## 
## -----------------------------------------------------------------
## Analysis of Variance
## -----------------------------------------------------------------
##         Df Sum Sq    Mean Sq    F value    Pr(>F) 
## F1       1 287.04167 287.041667 18.9431714 0.022  
## Block    3  10.45833   3.486111  0.2300642 0.871  
## Error A  3  45.45833  15.152778                   
## F2       2 739.00000 369.500000 17.8550336 p<0.001
## F1 x F2  2 305.33333 152.666667  7.3771812 0.008  
## Error B 12 248.33333  20.694444                   
## -----------------------------------------------------------------
## Significant interaction: analyzing the interaction
## -----------------------------------------------------------------
## Analyzing  F1  inside of each level of  F2
## -----------------------------------------------------------------
##                      GL       SQ        QM        Fc  p.value
## F1 : F2 DA      1.00000 406.1250 406.12500 21.548268 0.000343
## F1 : F2 AF+DA   1.00000  15.1250  15.12500  0.802506 0.384898
## F1 : F2 DA+ES   1.00000 171.1250 171.12500  9.079587 0.008963
## Combined error 14.57876 274.7691  18.84722                   
## 
## -----------------------------------------------------------------
## Analyzing  F2  inside of the level of  F1
## -----------------------------------------------------------------
##             GL        SQ        QM        Fc  p.value
## F2 : F1 S+   2 997.16667 498.58333 24.092617  6.3e-05
## F2 : F1 S-   2  47.16667  23.58333  1.139597 0.352262
## Error b     12 248.33333  20.69444
```

<img src="/classes/experimentacao/03_fatorial_files/figure-html/unnamed-chunk-13-1.png" width="672" />

```
## 
## -----------------------------------------------------------------
## Final table
## -----------------------------------------------------------------
##         DA   AF+DA   DA+ES
## S+ 93.2 aA 71.5 aB 86.8 aA
## S- 79.0 bA 74.2 aA 77.5 bA
```


# Exemplos de experimentos fatoriais
## Coberturas de solo e doses de nitrogênio (efeito na massa de cobertura de inverno) {#experimento1}

O delineamento experimental utilizado foi o delineamento de blocos casualizados com parcelas subdivididas em esquema fatorial 4x2 com quatro repetições. quatro espécies: aveia preta cv. BRS 139 (Neblina), com densidade de 120 kg ha$^{-1}$ de semente; triticale cv. BRS SATURNO, com densidade de 160 kg ha$^{-1}$ de semente e centeio cv. BRS PROGRESSO, com densidade de 160 kg ha$^{-1}$ de semente, além do pousio, com presença de diferentes plantas que se desenvolvem nesta época (três espécies de gramíneas); com dois manejos de nitrogênio (com ou sem N em cobertuta). Os tratamentos foram alocados na área experimental em formato de parcelas subdivididas. Na parcela principal foram alocadas as espécies nas subparcela o manejo de nitrogênio. Nas parcelas que receberam N utilizou-se como fonte a ureia (45% de N) na dose de 100 kg ha$^{-1}$.

### Pacotes e dados
Assumindo que todos estão instalados, é só carregar com


```r
library(rio) # importar e exportar arquivos
library(ExpDes.pt) # fazer anova
```

```
## Warning: package 'ExpDes.pt' was built under R version 4.1.1
```

```r
library(metan) # gráficos
library(tidyverse) # manipulação de dados e gráficos

# dados
url <- "http://bit.ly/df_biostat_exp"
df_cobmassa <- import(url, sheet = "COBERTURA_N_MASSA", setclass = "tbl")
df_cobmassa <- as_factor(df_cobmassa, 1:3)

# Apenas para mostrar a estrutura dos dados
df_cobmassa
```

```
## # A tibble: 32 x 6
##    NITROGENIO ESPECIE     REP       MV    MS   MSR
##    <fct>      <fct>       <fct>  <dbl> <dbl> <dbl>
##  1 Sem N      Aveia Preta 1     17939. 3640.  53.2
##  2 Sem N      Aveia Preta 2     20738. 4190. 709. 
##  3 Sem N      Aveia Preta 3     37780  6958. 688  
##  4 Sem N      Aveia Preta 4     15448  3055.  98  
##  5 Sem N      Centeio     1     30836. 7001. 347. 
##  6 Sem N      Centeio     2     22246  5540  246. 
##  7 Sem N      Centeio     3     12422  3330. 169. 
##  8 Sem N      Centeio     4     15220. 3797. 213. 
##  9 Sem N      Triticale   1     14700. 2989. 268. 
## 10 Sem N      Triticale   2     19146. 3652. 399. 
## # ... with 22 more rows
```



### Estatistica descritiva



```r
desc_stat(df_cobmassa, stats = c("min, mean, max"))
```

```
## # A tibble: 3 x 4
##   variable    min   mean    max
##   <chr>     <dbl>  <dbl>  <dbl>
## 1 MS       1576.   5053.  7573.
## 2 MSR        53.2   373.   738 
## 3 MV       6413.  25210. 45076.
```



### ANOVA {#modanova}


O modelo considerado para este exemplo de parcela subdivididas é o seguinte


$$
{y_{ijk}} = {\rm{ }}\mu {\rm{ }} + {\rm{ }}\mathop \alpha \nolimits_i + \mathop \beta \nolimits_{k} + \mathop \eta \nolimits_{ik}  +\mathop \tau \nolimits_j  + \mathop {(\alpha \tau )}\nolimits_{ij}  + {\rm{ }}\mathop \varepsilon \nolimits_{ijk}
$$

onde \${y_{ijk}}\$ é a variável resposta observada; \$\mu\$ é a média geral; \$\mathop \alpha \nolimits_i\$ é o efeito do \$i\$-ésimo nível do fator espécie de cobertura ; \$\mathop \beta \nolimits_{k}\$ é o efeito do bloco \$k\$; \$\mathop \eta \nolimits_{ik}\$ é o erro de parcela, mais conhecido como erro a; \$\mathop \tau \nolimits_j\$ é o efeito do \$j\$-ésimo nível do fator nitrogênio; \$\mathop {(\alpha \tau )}\nolimits_{ij}\$ é o efeito da interação do \$i\$-ésimo nível do fator espécie com o \$j\$-ésimo nível do fator nitrogênio; e \$\mathop \varepsilon \nolimits_{ijk}\$ é o erro da subparcela, mais conhecido como erro b.


#### Massa verde (MV) por ha

**ANOVA** 

```r
with(df_cobmassa,
     psub2.dbc(fator1 = ESPECIE,
               fator2 = NITROGENIO,
               bloco = REP,
               resp = MV,
               fac.names = c("ESPECIE", "NITROGENIO"))
)
```

```
## ------------------------------------------------------------------------
## Legenda:
## FATOR 1 (parcela):  ESPECIE 
## FATOR 2 (subparcela):  NITROGENIO 
## ------------------------------------------------------------------------
## 
## ------------------------------------------------------------------------
## Quadro da analise de variancia
## ------------------------------------------------------------------------
##                    GL         SQ        QM      Fc  Pr(>Fc)    
## ESPECIE             3  416543558 138847853  1.2283 0.354965    
## Bloco               3   77123097  25707699  0.2274 0.875004    
## Erro a              9 1017377902 113041989                     
## NITROGENIO          1  743336547 743336547 20.7774 0.000657 ***
## ESPECIE*NITROGENIO  3   86334790  28778264  0.8044 0.515204    
## Erro b             12  429314110  35776176                     
## Total              31 2770030005                               
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## ------------------------------------------------------------------------
## CV 1 = 42.17338 %
## CV 2 = 23.72551 %
## 
## Interacao nao significativa: analisando os efeitos simples
## ------------------------------------------------------------------------
## ESPECIE
## De acordo com o teste F, as medias desse fator sao estatisticamente iguais.
## ------------------------------------------------------------------------
##        Niveis   Medias
## 1 Aveia Preta 30469.15
## 2     Centeio 24084.35
## 3      Pousio 20441.70
## 4   Triticale 25846.80
## ------------------------------------------------------------------------
## NITROGENIO
## Teste de Tukey
## ------------------------------------------------------------------------
## Grupos Tratamentos Medias
## a 	 Com N 	 30030.17 
##  b 	 Sem N 	 20390.83 
## ------------------------------------------------------------------------
```


**GRÁFICO**

Como somente foi observado efeito significativo para o fator nitrogênio, prossegue-se com a comparação de médias para o efeito de N, conforme resultado do Teste Tukey acima. Neste gráfico, as barras mostram a média e as barras de erro, o erro padrão da média. Apenas para apresentação, incluo também a média do fator cobertura de solo, sem as letras pois o seu efeito não foi significativo, segundo a ANOVA.



```r
pn_mv <- 
plot_bars(df_cobmassa,
          x = NITROGENIO,
          y = MV,
          lab.bar = c("a", "b"),
          xlab = "Aplicação de Nitrogênio (N)",
          ylab = "Matéria verde (kg/ha)")

pcob_mv <- 
  plot_bars(df_cobmassa,
            x = ESPECIE,
            y = MV,
            xlab = "Espécies",
            ylab = "Matéria verde (kg/ha)") +
  geom_hline(yintercept = mean(df_cobmassa$MV))

# organiza os gráficos
arrange_ggplot(pn_mv, pcob_mv)
```

<img src="/classes/experimentacao/03_fatorial_files/figure-html/unnamed-chunk-17-1.png" width="960" />





#### Massa seca (MS) por ha

**ANOVA** 

```r
with(df_cobmassa,
     psub2.dbc(fator1 = ESPECIE,
               fator2 = NITROGENIO,
               bloco = REP,
               resp = MS,
               fac.names = c("ESPECIE", "NITROGENIO"))
)
```

```
## ------------------------------------------------------------------------
## Legenda:
## FATOR 1 (parcela):  ESPECIE 
## FATOR 2 (subparcela):  NITROGENIO 
## ------------------------------------------------------------------------
## 
## ------------------------------------------------------------------------
## Quadro da analise de variancia
## ------------------------------------------------------------------------
##                    GL       SQ       QM     Fc Pr(>Fc)  
## ESPECIE             3 11614132  3871377 1.0190 0.42877  
## Bloco               3  1466451   488817 0.1287 0.94066  
## Erro a              9 34191281  3799031                 
## NITROGENIO          1 14139498 14139498 8.1851 0.01433 *
## ESPECIE*NITROGENIO  3  1476172   492057 0.2848 0.83542  
## Erro b             12 20729720  1727477                 
## Total              31 83617255                          
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## ------------------------------------------------------------------------
## CV 1 = 38.57428 %
## CV 2 = 26.01163 %
## 
## Interacao nao significativa: analisando os efeitos simples
## ------------------------------------------------------------------------
## ESPECIE
## De acordo com o teste F, as medias desse fator sao estatisticamente iguais.
## ------------------------------------------------------------------------
##        Niveis  Medias
## 1 Aveia Preta 5402.25
## 2     Centeio 5647.55
## 3      Pousio 4065.85
## 4   Triticale 5095.85
## ------------------------------------------------------------------------
## NITROGENIO
## Teste de Tukey
## ------------------------------------------------------------------------
## Grupos Tratamentos Medias
## a 	 Com N 	 5717.6 
##  b 	 Sem N 	 4388.15 
## ------------------------------------------------------------------------
```


**GRÁFICO**

Como somente foi observado efeito significativo para o fator nitrogênio, prossegue-se com a comparação de médias para o efeito de N, conforme resultado do Teste Tukey acima. Apenas para apresentação, incluo também a média do fator cobertura de solo, sem as letras pois o seu efeito não foi significativo, segundo a ANOVA.



```r
pn_ms <- 
  plot_bars(df_cobmassa,
            x = NITROGENIO,
            y = MS,
            lab.bar = c("a", "b"),
            xlab = "Aplicação de Nitrogênio (N)",
            ylab = "Matéria seca (kg/ha)")

pcob_ms <- 
  plot_bars(df_cobmassa,
            x = ESPECIE,
            y = MS,
            xlab = "Espécies",
            ylab = "Matéria seca (kg/ha)") +
  geom_hline(yintercept = mean(df_cobmassa$MS))

# organiza os gráficos
arrange_ggplot(pn_ms, pcob_ms)
```

<img src="/classes/experimentacao/03_fatorial_files/figure-html/unnamed-chunk-19-1.png" width="960" />







#### Massa seca de raiz (MSR) por ha

**ANOVA** 

```r
with(df_cobmassa,
     psub2.dbc(fator1 = ESPECIE,
               fator2 = NITROGENIO,
               bloco = REP,
               resp = MSR,
               fac.names = c("ESPECIE", "NITROGENIO"))
)
```

```
## ------------------------------------------------------------------------
## Legenda:
## FATOR 1 (parcela):  ESPECIE 
## FATOR 2 (subparcela):  NITROGENIO 
## ------------------------------------------------------------------------
## 
## ------------------------------------------------------------------------
## Quadro da analise de variancia
## ------------------------------------------------------------------------
##                    GL      SQ     QM      Fc  Pr(>Fc)    
## ESPECIE             3  160868  53623  0.9543 0.454941    
## Bloco               3  217735  72578  1.2916 0.335534    
## Erro a              9  505724  56192                     
## NITROGENIO          1  141512 141512 21.4205 0.000582 ***
## ESPECIE*NITROGENIO  3   44728  14909  2.2568 0.134138    
## Erro b             12   79277   6606                     
## Total              31 1149844                            
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## ------------------------------------------------------------------------
## CV 1 = 63.48783 %
## CV 2 = 21.76891 %
## 
## Interacao nao significativa: analisando os efeitos simples
## ------------------------------------------------------------------------
## ESPECIE
## De acordo com o teste F, as medias desse fator sao estatisticamente iguais.
## ------------------------------------------------------------------------
##        Niveis Medias
## 1 Aveia Preta  405.7
## 2     Centeio  365.6
## 3      Pousio  264.4
## 4   Triticale  457.8
## ------------------------------------------------------------------------
## NITROGENIO
## Teste de Tukey
## ------------------------------------------------------------------------
## Grupos Tratamentos Medias
## a 	 Com N 	 439.875 
##  b 	 Sem N 	 306.875 
## ------------------------------------------------------------------------
```


**GRÁFICO**

Como somente foi observado efeito significativo para o fator nitrogênio, prossegue-se com a comparação de médias para o efeito de N, conforme resultado do Teste Tukey acima. Apenas para apresentação, incluo também a média do fator cobertura de solo, sem as letras pois o seu efeito não foi significativo, segundo a ANOVA.



```r
pn_msr <- 
  plot_bars(df_cobmassa,
            x = NITROGENIO,
            y = MSR,
            lab.bar = c("a", "b"),
            xlab = "Aplicação de Nitrogênio (N)",
            ylab = "Massa seca de raiz (kg/ha)")

pcob_msr <- 
  plot_bars(df_cobmassa,
            x = ESPECIE,
            y = MSR,
            xlab = "Espécies",
            ylab = "Massa seca de raiz (kg/ha)") +
  geom_hline(yintercept = mean(df_cobmassa$MSR))

# organiza os gráficos
arrange_ggplot(pn_msr, pcob_msr)
```

<img src="/classes/experimentacao/03_fatorial_files/figure-html/unnamed-chunk-21-1.png" width="960" />







## Coberturas de solo e doses de nitrogênio (efeito na cultura da soja)
Os tratamentos e delineamentos são descritos no [exemplo anterior](#experimento1). Aqui, são analisados os dados observados na cultura da soja, semeada na resteva de cada tratamento (combinação de N e espécies de cobertura) 

### Pacotes e dados
Assumindo que todos estão instalados, é só carregar com

```r
library(rio) # importar e exportar arquivos
library(ExpDes.pt) # fazer anova
library(metan) # gráficos
library(tidyverse) # manipulação de dados e gráficos

# dados
url <- "http://bit.ly/df_biostat_exp"
df_cobsoja <- import(url, sheet = "COBERTURA_N_SOJA", setclass = "tbl")
df_cobsoja <- as_factor(df_cobsoja, 1:3)

# Apenas para mostrar a estrutura dos dados
df_cobsoja
```

```
## # A tibble: 32 x 8
##    ESPECIE     NITROGENIO REP      MR    NL   NGL   MMG    RG
##    <fct>       <fct>      <fct> <dbl> <dbl> <dbl> <dbl> <dbl>
##  1 Aveia Preta Sem N      R1     15    30    2.25   180 3547.
##  2 Aveia Preta Sem N      R2     14.6  40.8  2.55   190 4117.
##  3 Aveia Preta Sem N      R3     13.2  34.6  2.6    170 3381.
##  4 Aveia Preta Sem N      R4     13    37.6  2.52   160 3733.
##  5 Centeio     Sem N      R1     15.2  38.6  2.15   180 3819.
##  6 Centeio     Sem N      R2     13    40.6  2.1    170 1739.
##  7 Centeio     Sem N      R3     14.4  37.6  2.48   180 3928.
##  8 Centeio     Sem N      R4     13    38    2.39   150 3339.
##  9 Triticale   Sem N      R1     13.6  35.6  2.46   210 4400 
## 10 Triticale   Sem N      R2     13.6  32.2  2.42   200 4378.
## # ... with 22 more rows
```


### Estatistica descritiva



```r
desc_stat(df_cobsoja, stats = c("min, mean, max"))
```

```
## # A tibble: 5 x 4
##   variable    min    mean     max
##   <chr>     <dbl>   <dbl>   <dbl>
## 1 MMG      150     178.    210   
## 2 MR        10      14.5    17   
## 3 NGL        1.97    2.43    2.82
## 4 NL        22.6    38.6    53.2 
## 5 RG       675    3288.   4861.
```



### ANOVA
O modelo considerado é descrito no [exemplo anterior](#modanova).

#### Variável número de legumes por planta (NL)

**ANOVA** 

```r
with(df_cobsoja,
     fat2.dbc(fator1 = ESPECIE,
              fator2 = NITROGENIO,
              bloco = REP,
              resp = NL,
              fac.names = c("ESPECIE", "NITROGENIO"))
)
```

```
## ------------------------------------------------------------------------
## Legenda:
## FATOR 1:  ESPECIE 
## FATOR 2:  NITROGENIO 
## ------------------------------------------------------------------------
## 
## 
## Quadro da analise de variancia
## ------------------------------------------------------------------------
##                    GL      SQ QM     Fc   Pr>Fc
## Bloco               3   18.72  6 0.1640 0.91940
## ESPECIE             3  148.99  5 1.3051 0.29904
## NITROGENIO          1    2.76  3 0.0726 0.79027
## ESPECIE*NITROGENIO  3  430.67  2 3.7724 0.02607
## Residuo            21  799.15  4               
## Total              31 1400.30  1               
## ------------------------------------------------------------------------
## CV = 16 %
## 
## ------------------------------------------------------------------------
## Teste de normalidade dos residuos (Shapiro-Wilk)
## valor-p:  0.5520582 
## De acordo com o teste de Shapiro-Wilk a 5% de significancia, os residuos podem ser considerados normais.
## ------------------------------------------------------------------------
## 
## 
## 
## Interacao significativa: desdobrando a interacao
## ------------------------------------------------------------------------
## 
## Desdobrando  ESPECIE  dentro de cada nivel de  NITROGENIO 
## ------------------------------------------------------------------------
## ------------------------------------------------------------------------
## Quadro da analise de variancia
## ------------------------------------------------------------------------
##                          GL         SQ        QM     Fc  Pr.Fc
## Bloco                     3   18.72375   6.24125  0.164 0.9194
## NITROGENIO                1    2.76125   2.76125 0.0726 0.7903
## ESPECIE:NITROGENIO Com N  3  513.04000 171.01333 4.4939 0.0138
## ESPECIE:NITROGENIO Sem N  3   66.62750  22.20917 0.5836 0.6323
## Residuo                  21  799.14625  38.05458              
## Total                    31 1400.29875  45.17093              
## ------------------------------------------------------------------------
## 
## 
## 
##  ESPECIE  dentro do nivel  Com N  de  NITROGENIO 
## ------------------------------------------------------------------------
## Teste de Tukey
## ------------------------------------------------------------------------
## Grupos Tratamentos Medias
## a 	 1 	 44.65 
## a 	 2 	 43.55 
## ab 	 4 	 36.55 
##  b 	 3 	 30.65 
## ------------------------------------------------------------------------
## 
## 
##  ESPECIE  dentro do nivel  Sem N  de  NITROGENIO 
## 
## De acordo com o teste F, as medias desse fator sao estatisticamente iguais.
## ------------------------------------------------------------------------
##   Niveis Medias
## 1      1  35.75
## 2      2  38.70
## 3      3  41.30
## 4      4  37.30
## ------------------------------------------------------------------------
## 
## 
## 
## Desdobrando  NITROGENIO  dentro de cada nivel de  ESPECIE 
## ------------------------------------------------------------------------
## ------------------------------------------------------------------------
## Quadro da analise de variancia
## ------------------------------------------------------------------------
##                                GL         SQ        QM     Fc  Pr.Fc
## Bloco                           3   18.72375   6.24125  0.164 0.9194
## ESPECIE                         3  148.99375  49.66458 1.3051  0.299
## NITROGENIO:ESPECIE Aveia Preta  1  158.42000 158.42000  4.163 0.0541
## NITROGENIO:ESPECIE Centeio      1   47.04500  47.04500 1.2363 0.2788
## NITROGENIO:ESPECIE Pousio       1  226.84500 226.84500  5.961 0.0236
## NITROGENIO:ESPECIE Triticale    1    1.12500   1.12500 0.0296 0.8651
## Residuo                        21  799.14625  38.05458              
## Total                          31 1400.29875  45.17093              
## ------------------------------------------------------------------------
## 
## 
## 
##  NITROGENIO  dentro do nivel  Aveia Preta  de  ESPECIE 
## 
## De acordo com o teste F, as medias desse fator sao estatisticamente iguais.
## ------------------------------------------------------------------------
##   Niveis Medias
## 1      1  44.65
## 2      2  35.75
## ------------------------------------------------------------------------
## 
## 
##  NITROGENIO  dentro do nivel  Centeio  de  ESPECIE 
## 
## De acordo com o teste F, as medias desse fator sao estatisticamente iguais.
## ------------------------------------------------------------------------
##   Niveis Medias
## 1      1  43.55
## 2      2  38.70
## ------------------------------------------------------------------------
## 
## 
##  NITROGENIO  dentro do nivel  Pousio  de  ESPECIE 
## ------------------------------------------------------------------------
## Teste de Tukey
## ------------------------------------------------------------------------
## Grupos Tratamentos Medias
## a 	 2 	 41.3 
##  b 	 1 	 30.65 
## ------------------------------------------------------------------------
## 
## 
##  NITROGENIO  dentro do nivel  Triticale  de  ESPECIE 
## 
## De acordo com o teste F, as medias desse fator sao estatisticamente iguais.
## ------------------------------------------------------------------------
##   Niveis Medias
## 1      1  36.55
## 2      2  37.30
## ------------------------------------------------------------------------
```

**GRÁFICO**

Como não a houve diferença para os efeitos principais (ESPECIE E NITROGÊNIO) mas deu interação entre estes fatores, vamos apresentar um gráfico mostrando essa interação. No gráfico, letras maiúsculas comparam as espécies dentro de cada manejo de N e minúsculas comparam o manejo de N dentro de cada espécie. As barras mostram a média e as barras de erro, o erro padrão da média.


```r
plot_factbars(df_cobsoja, ESPECIE, NITROGENIO,
              resp = NL,
              lab.bar = c("Aa", "Aa", "Aa", "Aa", "Bb", "Aa", "ABa", "Aa"),
              y.expand = 0.1,
              xlab = "Espécie",
              ylab = "Número de legumes por planta")
```

<img src="/classes/experimentacao/03_fatorial_files/figure-html/unnamed-chunk-25-1.png" width="672" />





#### Variável número de grãos por legume (NGL)

**ANOVA** 

```r
with(df_cobsoja,
     fat2.dbc(fator1 = ESPECIE,
              fator2 = NITROGENIO,
              bloco = REP,
              resp = NGL,
              fac.names = c("ESPECIE", "NITROGENIO"))
)
```

```
## ------------------------------------------------------------------------
## Legenda:
## FATOR 1:  ESPECIE 
## FATOR 2:  NITROGENIO 
## ------------------------------------------------------------------------
## 
## 
## Quadro da analise de variancia
## ------------------------------------------------------------------------
##                    GL      SQ QM     Fc    Pr>Fc
## Bloco               3 0.19640  5 2.3475 0.101764
## ESPECIE             3 0.14872  4 1.7776 0.182257
## NITROGENIO          1 0.08405  6 3.0138 0.097208
## ESPECIE*NITROGENIO  3 0.14872  3 1.7776 0.182257
## Residuo            21 0.58565  2                
## Total              31 1.16355  1                
## ------------------------------------------------------------------------
## CV = 6.88 %
## 
## ------------------------------------------------------------------------
## Teste de normalidade dos residuos (Shapiro-Wilk)
## valor-p:  0.3640228 
## De acordo com o teste de Shapiro-Wilk a 5% de significancia, os residuos podem ser considerados normais.
## ------------------------------------------------------------------------
## 
## Interacao nao significativa: analisando os efeitos simples
## ------------------------------------------------------------------------
## ESPECIE
## De acordo com o teste F, as medias desse fator sao estatisticamente iguais.
## ------------------------------------------------------------------------
##        Niveis  Medias
## 1 Aveia Preta 2.42250
## 2     Centeio 2.32875
## 3      Pousio 2.44375
## 4   Triticale 2.52000
## ------------------------------------------------------------------------
## NITROGENIO
## De acordo com o teste F, as medias desse fator sao estatisticamente iguais.
## ------------------------------------------------------------------------
##   Niveis Medias
## 1  Com N 2.4800
## 2  Sem N 2.3775
## ------------------------------------------------------------------------
```

> COMO NÃO DEU DIFERENÇA SIGNIFICATIVA PARA NENHUM FATOR, PODE-SE APENAS APRESENTAR O GRÁFICO, MAS SEM DISCUTIR DIFERENÇAS ENTRE OS TRATAMENTOS/N



```r
plot_factbars(df_cobsoja, ESPECIE, NITROGENIO,
              resp = NGL,
              y.expand = 0.1,
              xlab = "Espécie",
              ylab = "Número de grãos por legume")
```

<img src="/classes/experimentacao/03_fatorial_files/figure-html/unnamed-chunk-27-1.png" width="672" />



#### Variável massa de mil grãos (MMG)

**ANOVA** 

```r
with(df_cobsoja,
     fat2.dbc(fator1 = ESPECIE,
              fator2 = NITROGENIO,
              bloco = REP,
              resp = MMG,
              fac.names = c("ESPECIE", "NITROGENIO"))
)
```

```
## ------------------------------------------------------------------------
## Legenda:
## FATOR 1:  ESPECIE 
## FATOR 2:  NITROGENIO 
## ------------------------------------------------------------------------
## 
## 
## Quadro da analise de variancia
## ------------------------------------------------------------------------
##                    GL     SQ QM     Fc   Pr>Fc
## Bloco               3 3409.4  2 6.5107 0.00275
## ESPECIE             3 1309.4  5 2.5004 0.08733
## NITROGENIO          1   28.1  4 0.1611 0.69218
## ESPECIE*NITROGENIO  3  209.4  6 0.3998 0.75454
## Residuo            21 3665.6  3               
## Total              31 8621.9  1               
## ------------------------------------------------------------------------
## CV = 7.4 %
## 
## ------------------------------------------------------------------------
## Teste de normalidade dos residuos (Shapiro-Wilk)
## valor-p:  0.858878 
## De acordo com o teste de Shapiro-Wilk a 5% de significancia, os residuos podem ser considerados normais.
## ------------------------------------------------------------------------
## 
## Interacao nao significativa: analisando os efeitos simples
## ------------------------------------------------------------------------
## ESPECIE
## De acordo com o teste F, as medias desse fator sao estatisticamente iguais.
## ------------------------------------------------------------------------
##        Niveis Medias
## 1 Aveia Preta 176.25
## 2     Centeio 171.25
## 3      Pousio 188.75
## 4   Triticale 177.50
## ------------------------------------------------------------------------
## NITROGENIO
## De acordo com o teste F, as medias desse fator sao estatisticamente iguais.
## ------------------------------------------------------------------------
##   Niveis  Medias
## 1  Com N 177.500
## 2  Sem N 179.375
## ------------------------------------------------------------------------
```

> COMO NÃO DEU DIFERENÇA SIGNIFICATIVA PARA NENHUM FATOR, PODE-SE APENAS APRESENTAR O GRÁFICO, MAS SEM DISCUTIR DIFERENÇAS ENTRE OS TRATAMENTOS/N



```r
plot_factbars(df_cobsoja, ESPECIE, NITROGENIO,
              resp = MMG,
              y.expand = 0.1,
              xlab = "Espécie",
              ylab = "Massa de mil grãos (g)")
```

<img src="/classes/experimentacao/03_fatorial_files/figure-html/unnamed-chunk-29-1.png" width="672" />


#### Variável RG

**ANOVA** 

```r
with(df_cobsoja,
     fat2.dbc(fator1 = ESPECIE,
              fator2 = NITROGENIO,
              bloco = REP,
              resp = RG,
              fac.names = c("ESPECIE", "NITROGENIO"))
)
```

```
## ------------------------------------------------------------------------
## Legenda:
## FATOR 1:  ESPECIE 
## FATOR 2:  NITROGENIO 
## ------------------------------------------------------------------------
## 
## 
## Quadro da analise de variancia
## ------------------------------------------------------------------------
##                    GL       SQ QM      Fc   Pr>Fc
## Bloco               3  9602221  4 1.97873 0.14806
## ESPECIE             3   219192  6 0.04517 0.98689
## NITROGENIO          1   461200  5 0.28512 0.59897
## ESPECIE*NITROGENIO  3  3950128  2 0.81400 0.50045
## Residuo            21 33969089  3                
## Total              31 48201830  1                
## ------------------------------------------------------------------------
## CV = 38.68 %
## 
## ------------------------------------------------------------------------
## Teste de normalidade dos residuos (Shapiro-Wilk)
## valor-p:  0.1875762 
## De acordo com o teste de Shapiro-Wilk a 5% de significancia, os residuos podem ser considerados normais.
## ------------------------------------------------------------------------
## 
## Interacao nao significativa: analisando os efeitos simples
## ------------------------------------------------------------------------
## ESPECIE
## De acordo com o teste F, as medias desse fator sao estatisticamente iguais.
## ------------------------------------------------------------------------
##        Niveis   Medias
## 1 Aveia Preta 3368.403
## 2     Centeio 3305.556
## 3      Pousio 3150.000
## 4   Triticale 3327.778
## ------------------------------------------------------------------------
## NITROGENIO
## De acordo com o teste F, as medias desse fator sao estatisticamente iguais.
## ------------------------------------------------------------------------
##   Niveis   Medias
## 1  Com N 3167.882
## 2  Sem N 3407.986
## ------------------------------------------------------------------------
```


> COMO NÃO DEU DIFERENÇA SIGNIFICATIVA PARA NENHUM FATOR, PODE-SE APENAS APRESENTAR O GRÁFICO, MAS SEM DISCUTIR DIFERENÇAS ENTRE OS TRATAMENTOS/N



```r
plot_factbars(df_cobsoja, ESPECIE, NITROGENIO,
              resp = RG,
              y.expand = 0.1,
              xlab = "Espécie",
              ylab = "RG (kg/ha)")
```

<img src="/classes/experimentacao/03_fatorial_files/figure-html/unnamed-chunk-31-1.png" width="672" />
