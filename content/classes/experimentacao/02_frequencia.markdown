---
title: Visualização
linktitle: "2. Distribuição de frequências"
toc: true
type: docs
date: "2022/04/22"
draft: false
df_print: paged
code_download: true
menu:
  experimentacao:
    parent: Experimentação
    weight: 3
# weight: 1
---


Uma forma de lidar com grandes conjuntos de dados e identificar informações relevantes é agrupar estes dados. O agrupamento é feito em tabelas, denominadas de distribuições de frequências. A construção de distribuição de frequências é geralmente realizada de forma distinta para variáveis discretas (distribuição por pontos) e contínuas (distribuição por classes ou intervalos).

Neste exemplo, vamos utilizar os dados coletados do comprimento, diâmetro e cor de grão de café.


```r
library(tidyverse)
```

```
## Warning: package 'tidyverse' was built under R version 4.1.3
```

```
## -- Attaching packages --------------------------------------- tidyverse 1.3.1 --
```

```
## v ggplot2 3.3.5     v purrr   0.3.4
## v tibble  3.1.6     v dplyr   1.0.8
## v tidyr   1.2.0     v stringr 1.4.0
## v readr   2.1.2     v forcats 0.5.1
```

```
## -- Conflicts ------------------------------------------ tidyverse_conflicts() --
## x dplyr::filter() masks stats::filter()
## x dplyr::lag()    masks stats::lag()
```

```r
library(rio)
```

```
## Warning: package 'rio' was built under R version 4.1.3
```

```r
library(metan)
```

```
## Registered S3 method overwritten by 'GGally':
##   method from   
##   +.gg   ggplot2
```

```
## |=========================================================|
```

```
## | Multi-Environment Trial Analysis (metan) v1.16.0        |
```

```
## | Author: Tiago Olivoto                                   |
```

```
## | Type 'citation('metan')' to know how to cite metan      |
```

```
## | Type 'vignette('metan_start')' for a short tutorial     |
```

```
## | Visit 'https://bit.ly/pkgmetan' for a complete tutorial |
```

```
## |=========================================================|
```

```
## 
## Attaching package: 'metan'
```

```
## The following object is masked from 'package:forcats':
## 
##     as_factor
```

```
## The following object is masked from 'package:dplyr':
## 
##     recode_factor
```

```
## The following object is masked from 'package:tidyr':
## 
##     replace_na
```

```
## The following objects are masked from 'package:tibble':
## 
##     column_to_rownames, remove_rownames, rownames_to_column
```

```r
library(leem) # criação dos histogramas 

# importar os dados do google sheet
df <- import("https://docs.google.com/spreadsheets/d/1JMrkppvv1BdGKVCekzZPsPYCKcgUWjxpuDlWqejc22s/edit#gid=353032103",
             dec = ",")
# mostrar os dados
knitr::kable(df)
```



| amostra| comp_grao| diam_grao|cor_grao |
|-------:|---------:|---------:|:--------|
|       1|     15.89|     11.66|vermelho |
|       2|     14.68|     11.37|vermelho |
|       3|     13.60|     11.39|vermelho |
|       4|     11.39|     11.58|vermelho |
|       5|     14.27|     10.69|vermelho |
|       6|     15.02|     11.28|vermelho |
|       7|     11.88|      8.54|vermelho |
|       8|     15.06|     10.99|amarelo  |
|       9|     15.98|     11.42|amarelo  |
|      10|     13.32|      9.38|amarelo  |
|      11|     14.64|     11.04|amarelo  |
|      12|     12.15|      9.30|amarelo  |
|      13|     15.59|     11.99|amarelo  |
|      14|     14.26|     10.47|verde    |
|      15|     12.04|      8.70|verde    |
|      16|     10.95|      8.43|verde    |
|      17|     12.88|      9.36|verde    |
|      18|     11.86|      9.10|verde    |
|      19|     14.02|      9.17|verde    |
|      20|     11.99|     10.20|verde    |
|      21|     12.77|      9.88|verde    |
|      22|     12.47|      8.53|verde    |
|      23|      9.75|      6.63|verde    |
|      24|      9.09|      7.29|verde    |
|      25|     10.47|      8.54|verde    |
|      26|     10.14|      8.32|verde    |
|      27|     11.48|      8.43|verde    |
|      28|     12.66|      9.25|verde    |


# Variáveis qualitativas e quantitativas discretas

Para exemplificar a construção de tabelas de frequências de variáveis qualitativas / quantitativas discretas, utilizaremos a variável cor do grão. Neste caso, três classes (classes naturais) estão presentes: vermelho, amarelo e verde. Assim, a construção da tabela de frequência diz respeito a contagem de observações em cada uma destas classes e o cálculo das frequências relativas e absolutas. 

## Representação tabular
Pode-se criar facilmente esta tabela de frequência combinando as funções `count()` e `mutate()` do pacote `dplyr` (parte do `tidyverse`).


```r
tab_feq <- 
  df %>%
  count(cor_grao) |>
  mutate(abs_freq = n,
         abs_freq_ac = cumsum(abs_freq),
         rel_freq = abs_freq / sum(abs_freq),
         rel_freq_ac = cumsum(rel_freq))

knitr::kable(tab_feq)
```



|cor_grao |  n| abs_freq| abs_freq_ac|  rel_freq| rel_freq_ac|
|:--------|--:|--------:|-----------:|---------:|-----------:|
|amarelo  |  6|        6|           6| 0.2142857|   0.2142857|
|verde    | 15|       15|          21| 0.5357143|   0.7500000|
|vermelho |  7|        7|          28| 0.2500000|   1.0000000|

## Representação gráfica

Para apresentar estes dados graficamente, pode-se construir um gráfico de barras, mostrando a contagem em cada classe.


```r
ggplot(df, aes(cor_grao)) + 
  geom_histogram(stat="count") +
  scale_y_continuous(breaks = 0:15) + 
  labs(x = "Cor do grão",
       y = "Número de observações") +
  theme(panel.grid.minor = element_blank())
```

```
## Warning: Ignoring unknown parameters: binwidth, bins, pad
```

<img src="/classes/experimentacao/02_frequencia_files/figure-html/unnamed-chunk-3-1.png" width="672" />



# Variáveis quantitativas
Para o caso de variáveis quantitativas contínuas (ex. `X`), precisamos agrupar os valores observados em intervalos de classe. Por exemplo, quando medimos uma altura de uma planta (ex. 1,86 m), a altura real não está limitado a segunda casa decimal. Então, a melhor forma será criar regiões (intervalos), de modo que possamos contemplar um conjunto de valores.

Um critério empírico, para definição do número de classes (\$k\$) a ser criado se baseia no número de elementos (\$n\$) na amostra. Caso (\$n\$) seja igual ou inferior a 100, calcula-se o número de classes com \$k = \sqrt{n}\$. Caso (\$n\$) seja maior que 100, calcula-se o número de classes com \$k = 5 \log_{10}(n)\$.


Após a determinação do número de classes, é necessário determinar a amplitude total (\$A\$), dada por:

$$
A = \max(X) - \min(X)
$$

Posteriormente, determina-se a amplitude da classe (\$c\$), dada por:

$$
c = \frac{A}{k - 1}
$$

Por fim, calcula-se o o limite inferior (\$LI_1\$) e superior (\$LS_1\$) da primeira classe, dados por

$$
LI_1 = min(X) - c/2\\\\
$$

$$
LS_1 = LI_1 + c
$$


O valor do limite superior não pertence a classe e será contabilizado para a próxima classe. Dizemos, então, que o conjunto é fechado a esquerda e aberto à direita. O limite inferior da segunda classe é dado pelo limite superior da primeira class (\$LI_2 = LS_1\$); o limite superior da segunda classe é dado por ($LS_2 = LI_2 + c$). Esta lógica segue até completar-se o número de classes do conjunto.

A função `freq_table()` está disponível no pacote metan e é mostrada explicitamente aqui. Ela automatiza o processo de construção de tabelas de frequências, tanto para variáveis qualitativas como quantitativas. Basta informar o conjunto de dados, a variável, e, opcionalmente, o número de classes a ser criado.



```r
freq_table
```

## Apresentação tabular

```r
frequencias <- freq_table(df, comp_grao)
knitr::kable(frequencias$freqs)
```



|class                       | abs_freq| abs_freq_ac| rel_freq| rel_freq_ac|
|:---------------------------|--------:|-----------:|--------:|-----------:|
|8.23 &#124;---  9.95        |        2|           2|     0.07|        0.07|
|9.95 &#124;---  11.67       |        5|           7|     0.18|        0.25|
|11.67 &#124;---  13.39      |       10|          17|     0.36|        0.61|
|13.39 &#124;---  15.11      |        8|          25|     0.29|        0.89|
|15.11 &#124;---&#124; 16.83 |        3|          28|     0.11|        1.00|
|Total                       |       28|          28|     1.00|        1.00|


## Apresentação gráfica


```r
freq_hist(frequencias)
```

<img src="/classes/experimentacao/02_frequencia_files/figure-html/unnamed-chunk-6-1.png" width="672" />


# Exemplos discutidos em aula
## Cor do grão do café (grupo 3)

```r
df_cor_grao <- import("https://docs.google.com/spreadsheets/d/1JMrkppvv1BdGKVCekzZPsPYCKcgUWjxpuDlWqejc22s/edit#gid=353032103",
                      dec = ",")


freq_cafe <- freq_table(df_cor_grao, var = cor_grao)
knitr::kable(freq_cafe$freqs)
```



|cor_grao | abs_freq| abs_freq_ac|  rel_freq| rel_freq_ac|
|:--------|--------:|-----------:|---------:|-----------:|
|amarelo  |        6|           6| 0.2142857|   0.2142857|
|verde    |       15|          21| 0.5357143|   0.7500000|
|vermelho |        7|          28| 0.2500000|   1.0000000|
|Total    |       28|          28| 1.0000000|   1.0000000|

```r
# criar um histograma
freq_hist(freq_cafe)
```

<img src="/classes/experimentacao/02_frequencia_files/figure-html/unnamed-chunk-7-1.png" width="672" /><img src="/classes/experimentacao/02_frequencia_files/figure-html/unnamed-chunk-7-2.png" width="672" />




## Altura da turma


```r
df_altura <- import("https://docs.google.com/spreadsheets/d/1JMrkppvv1BdGKVCekzZPsPYCKcgUWjxpuDlWqejc22s/edit#gid=1992833755") |> 
  as_numeric(Altura)

# Tabela
dist_altura <- freq_table(df_altura, var = Altura)
knitr::kable(dist_altura$freqs)
```



|class                         | abs_freq| abs_freq_ac| rel_freq| rel_freq_ac|
|:-----------------------------|--------:|-----------:|--------:|-----------:|
|154.34 &#124;---  163.67      |        3|           3|     0.15|        0.15|
|163.67 &#124;---  173         |        7|          10|     0.35|        0.50|
|173 &#124;---  182.33         |        8|          18|     0.40|        0.90|
|182.33 &#124;---&#124; 191.66 |        2|          20|     0.10|        1.00|
|Total                         |       20|          20|     1.00|        1.00|

```r
# Gráfico
freq_hist(dist_altura)
```

<img src="/classes/experimentacao/02_frequencia_files/figure-html/unnamed-chunk-8-1.png" width="672" />

