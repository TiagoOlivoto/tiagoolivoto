---
title: Estatísticas descritivas
linktitle: "3. Estatísticas descritivas"
toc: true
type: docs
date: "2021/07/09"
draft: false
menu:
  gemsr:
    parent: GEMS-R
    weight: 4
weight: 4
---


O `metan` fornece uma estrutura simples e intuitiva, compatível com o pipe, para realizar estatísticas descritivas. Um [conjunto de funções](https://tiagoolivoto.github.io/metan/reference/utils_stats.html) pode ser usado para calcular rapidamente as estatísticas descritivas mais utilizadas.


```r
library(metan)
library(rio)

# dados
df <- import("df_ok.xlsx", setclass = "tbl")
print(df)
## # A tibble: 114 x 13
##    ENV   GEN   BLOCO ALT_PLANT ALT_ESP COMPES DIAMES COMP_SAB DIAM_SAB   MGE
##    <chr> <chr> <chr>     <dbl>   <dbl>  <dbl>  <dbl>    <dbl>    <dbl> <dbl>
##  1 AMB1  H10   I         NA       1.64   16.7   54.0     31.7     17.4  194.
##  2 AMB1  H10   II         2.79    1.71   14.9   52.7     32.0     15.5  176.
##  3 AMB1  H10   III        2.72    1.51   16.7   52.7     30.4     17.5  207.
##  4 AMB1  H11   I          2.75    1.51   17.4   51.7     30.6     18.0  217.
##  5 AMB1  H11   II         2.72    1.56   16.7   47.2     28.7     17.2  181.
##  6 AMB1  H11   III        2.77    1.67   15.8   47.9     27.6     16.4  166.
##  7 AMB1  H12   I          2.73    1.54   14.9   47.5     28.2     15.5  161.
##  8 AMB1  H12   II         2.56    1.56   15.7   49.9     29.8     16.2  188.
##  9 AMB1  H12   III        2.79    1.53   15.0   52.7     31.4     15.2  193.
## 10 AMB1  H13   I          2.74    1.6    14.6   54       32.5     15.1  205.
## # ... with 104 more rows, and 3 more variables: NFIL <dbl>, MMG <dbl>,
## #   NGE <dbl>
```

Vamos começar com um exemplo muito simples(mas amplamente usado): calcular a média de uma variável numérica (digamos, MGE) do conjunto de dados `df`. Usando a função R base `stats::mean()`, a solução seria:


```r
mean(df$MGE)
## [1] 170.7426
```

Considere que agora queremos calcular o valor médio da MGE para cada nível do fator GEN. Em outras palavras, calcular o valor médio da MGE para cada genótipo. A solução usando `stats::aggregate()` é então:


```r
aggregate(MGE ~ GEN, data = df, FUN = mean)
##    GEN      MGE
## 1   H1 172.5067
## 2  H10 157.6211
## 3  H11 164.1922
## 4  H12 153.3733
## 5  H13 189.7589
## 6   H2 194.3322
## 7   H3 176.0467
## 8   H4 180.9133
## 9   H5 180.0211
## 10  H6 194.6500
## 11  H7 160.3344
## 12  H8 150.1667
## 13  H9 146.3256
```

# Estatísticas por níveis de um fator
Usando a função `means_by()` a quantidade de código necessária é drasticamente reduzida. Para calcular a média geral para todas as variáveis numéricas de `df`, simplesmente usamos:

```r
(ov_mean <- means_by(df))
## Warning: NA values removed to compute the function. Use 'na.rm = TRUE' to
## suppress this warning.
## To remove rows with NA use `remove_rows_na()'. 
## To remove columns with NA use `remove_cols_na()'.
## # A tibble: 1 x 10
##   ALT_PLANT ALT_ESP COMPES DIAMES COMP_SAB DIAM_SAB   MGE  NFIL   MMG   NGE
##       <dbl>   <dbl>  <dbl>  <dbl>    <dbl>    <dbl> <dbl> <dbl> <dbl> <dbl>
## 1      2.46    1.31   15.2   49.4     28.9     16.0  171.  16.2  336.  508.
```

Para calcular os valores médios para cada nível do fator GEN, precisamos adicionar a variável de agrupamento `GEN` no argumento `...`

```r
(means_gen <- means_by(df, GEN))
## Warning: NA values removed to compute the function. Use 'na.rm = TRUE' to
## suppress this warning.
## To remove rows with NA use `remove_rows_na()'. 
## To remove columns with NA use `remove_cols_na()'.
## # A tibble: 13 x 11
##    GEN   ALT_PLANT ALT_ESP COMPES DIAMES COMP_SAB DIAM_SAB   MGE  NFIL   MMG
##    <chr>     <dbl>   <dbl>  <dbl>  <dbl>    <dbl>    <dbl> <dbl> <dbl> <dbl>
##  1 H1         2.56    1.44   14.9   51.2     31.2     15.6  173.  16.5  379.
##  2 H10        2.22    1.21   15.2   47.9     27.6     16.1  158.  15.3  312.
##  3 H11        2.33    1.23   15.3   47.8     27.5     16.1  164.  15.1  328.
##  4 H12        2.41    1.24   14.2   48.2     27.6     14.7  153.  16.2  310.
##  5 H13        2.53    1.33   15.3   51.5     30.1     16.1  190.  18    338.
##  6 H2         2.63    1.38   15.5   51.9     29.8     16.2  194.  17.5  363.
##  7 H3         2.64    1.43   15.2   49.7     28.9     16.2  176.  16.1  354.
##  8 H4         2.59    1.42   16.0   48.6     28.2     16.8  181.  15.1  344.
##  9 H5         2.54    1.32   15.6   49.4     28.7     16.7  180.  16    332.
## 10 H6         2.58    1.43   15.8   51.9     30.2     16.7  195.  16.7  362.
## 11 H7         2.36    1.28   14.9   49.0     29.4     15.7  160.  16.4  329.
## 12 H8         2.25    1.13   14.5   47.9     28.7     15.5  150.  16.0  317.
## 13 H9         2.38    1.27   14.7   47.3     28.5     15.7  146.  15.3  316.
## # ... with 1 more variable: NGE <dbl>
```

As seguintes funções `*_by()` estão disponíveis para calcular as principais estatísticas descritivas por níveis de um fator.

 - `cv_by()` Para calcular o coeficiente de variação.
 - `max_by()` Para calcular os valores máximos.
 - `means_by()` Para calcular a média aritmética.
 - `min_by()` Para calcular os valores mínimos.
 - `n_by()` Para obter o número de observações
 - `sd_by()` Para calcular o desvio padrão amostral.
 - `sem_by()` Para calcular o erro padrão da média.

# Funções úteis
Outras funções úteis também são implementadas. Todos eles funcionam naturalmente com `%>%`, lidam com dados agrupados com `dplyr::group_by()` e múltiplas variáveis (todas as variáveis numéricas de `.data` por padrão).
 
 - `av_dev()` calcula o desvio absoluto médio.
 - `ci_mean()` calcula o intervalo de confiança para a média.
 - `cv()` calcula o coeficiente de variação.
 - `freq_table()` Calcula uma tabela de frequência.
 - `hm_mean()`, `gm_mean()` calcula as médias harmônicas e geométricas, respectivamente. A média harmônica é o recíproco da média aritmética dos recíprocos. A média geométrica é a enésima raiz de n produtos.
 - `kurt()` calcula a curtose como usado em SAS e SPSS.
 - `range_data()` Calcula o intervalo dos valores.
 - `sd_amo()`, `sd_pop()` Calcula a amostra e o desvio padrão populacional, respectivamente.
 - `sem()` calcula o erro padrão da média.
 - `skew()` calcula o skewness (assimetria) como usado em SAS e SPSS.
 - `sum_dev()` calcula a soma dos desvios absolutos.
 - `sum_sq_dev()` calcula a soma dos desvios quadrados.
 - `var_amo()`, `var_pop()` calcula a amostra e a variância populacional.
 - `valid_n()` Retorna o comprimento válido (não `NA`).

Vamos mostrar alguns exemplos. Observe que [select helpers](https://tiagoolivoto.github.io/metan/articles/vignettes_helper.html#select-helpers) pode ser usado para selecionar variáveis com base em seus nomes/tipos.


```r
# Erro padrão da média para variáveis numéricas que contém (SAB)
df %>% sem(contains("SAB"))
## # A tibble: 1 x 2
##   COMP_SAB DIAM_SAB
##      <dbl>    <dbl>
## 1    0.232    0.109


# Intervalo de confiança 0,95 para a média
# Variáveis com largura de nome maior que 3 caracteres
# Agrupado por níveis de ENV
df %>%
  group_by(ENV) %>%
  ci_mean(width_greater_than(3))
## Warning: NA values removed to compute the function. Use 'na.rm = TRUE' to
## suppress this warning.
## To remove rows with NA use `remove_rows_na()'. 
## To remove columns with NA use `remove_cols_na()'.
## # A tibble: 3 x 8
##   ENV   ALT_PLANT ALT_ESP COMPES DIAMES COMP_SAB DIAM_SAB  NFIL
##   <chr>     <dbl>   <dbl>  <dbl>  <dbl>    <dbl>    <dbl> <dbl>
## 1 AMB1     0.0425  0.0433  0.405  0.643    0.769    0.366 0.688
## 2 AMB2     0.129   0.113   0.442  0.882    0.819    0.436 0.467
## 3 AMB3     0.0723  0.0624  0.326  0.897    0.781    0.307 0.498
```


# A função wrapper `desc_stat()`

Para calcular todas as estatísticas de uma vez, podemos usar `desc_stat()`. Esta é uma função wrapper em torno das anteriores e pode ser usada para calcular medidas de tendência central, posição e dispersão. Por padrão(`stats = "main"`), sete estatísticas (coeficiente de variação, máximo, média, mediana, mínimo, desvio padrão da amostra, erro padrão e intervalo de confiança da média) são calculados. Outros valores permitidos são `"all"` para mostrar todas as estatísticas, `"robust"` para mostrar estatísticas robustas, e `"quantil"` para mostrar estatísticas de quantis ou escolher uma (ou mais) estatísticas usando um vetor separado por vírgulas com os nomes das estatísticas, por exemplo, `stats = c("mean, cv")`. Também podemos usar `hist = TRUE` para criar um histograma para cada variável.

## Todas as estatísticas para todas as variáveis numéricas

```r
(all <- desc_stat(df, stats = "all"))
## Warning: NA values removed to compute the function. Use 'na.rm = TRUE' to
## suppress this warning.
## # A tibble: 10 x 32
##    variable  av.dev      ci    cv  gmean  hmean    iqr   kurt    mad    max
##    <chr>      <dbl>   <dbl> <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>
##  1 ALT_ESP    0.285  0.0581 23.9    1.28   1.24  0.552 -1.38   0.415   1.88
##  2 ALT_PLANT  0.348  0.07   15.2    2.42   2.41  0.68  -1.51   0.534   3.04
##  3 COMP_SAB   2.16   0.460   8.57  28.8   28.7   4.08  -0.897  2.81   34.7 
##  4 COMPES     1.01   0.232   8.25  15.1   15.1   1.74  -0.436  1.29   17.9 
##  5 DIAM_SAB   0.962  0.216   7.27  16.0   15.9   1.82  -0.605  1.32   18.3 
##  6 DIAMES     2.50   0.549   5.99  49.3   49.2   4.64  -0.961  3.51   54.9 
##  7 MGE       29.1    6.41   20.2  167.   163.   55.6   -0.884 39.8   251.  
##  8 MMG       39.5    9.31   14.9  332.   328.   65.1   -0.266 46.5   452.  
##  9 NFIL       1.39   0.325  10.8   16.1   16.0   2.4    0.148  1.78   21.2 
## 10 NGE       55.4   13.6    14.3  451.   498.   73.4    0.172 55.9   697.  
## # ... with 22 more variables: mean <dbl>, median <dbl>, min <dbl>, n <dbl>,
## #   n.valid <dbl>, n.missing <dbl>, n.unique <dbl>, ps <dbl>, q2.5 <dbl>,
## #   q25 <dbl>, q75 <dbl>, q97.5 <dbl>, range <dbl>, sd.amo <dbl>, sd.pop <dbl>,
## #   se <dbl>, skew <dbl>, sum <dbl>, sum.dev <dbl>, sum.sq.dev <dbl>,
## #   var.amo <dbl>, var.pop <dbl>
```


## Crie um histograma para cada variável

```r
stat1 <- 
  df %>% 
  desc_stat(ALT_ESP, ALT_PLANT, COMP_SAB,
            hist = TRUE)
## Warning: NA values removed to compute the function. Use 'na.rm = TRUE' to
## suppress this warning.
## Warning: Removed 1 rows containing non-finite values (stat_bin).
```

<img src="/tutorials/gemsr/03_descritiva_files/figure-html/unnamed-chunk-8-1.png" width="960" />

## Estatísticas por níveis de fatores
Para calcular as estatísticas para cada nível de um fator, use o argumento `by`. Além disso, é possível selecionar as estatísticas a serem computadas usando o argumento `stats`, que aceita um único nome de estatística, por exemplo,` "mean" `, ou um vetor de nomes separados por vírgula com` "` no início e apenas no final do vetor. Observe que os nomes das estatísticas **NÃO** diferenciam maiúsculas de minúsculas, ou seja, `"mean"`, `"Mean"` ou `"MEAN"` são reconhecidos. Vírgulas ou espaços podem ser usados separar os nomes das estatísticas.

* Todas as opções abaixo funcionarão:
   * `stats = c("mean, se, cv, max, min")`
   * `stats = c("mean se cv max min")`
   * `stats = c("MEAN, Se, CV max Min")`



```r
stats_c <-
  desc_stat(df,
            contains("C"),
            stats = ("mean, se, cv, max, min, n, n.valid"),
            by = ENV)
```

Podemos converter os resultados acima em um formato *wide* usando a função `desc_wider()`


```r
desc_wider(stats_c, mean)
## # A tibble: 3 x 3
##   ENV   COMP_SAB COMPES
##   <chr>    <dbl>  <dbl>
## 1 AMB1      29.9   15.6
## 2 AMB2      28.5   15.2
## 3 AMB3      28.4   14.7
```

Para calcular as estatísticas descritivas por mais de uma variável de agrupamento, é necessário passar os dados agrupados para o argumento `.data` com a função `group_by()`. Vamos calcular a média, o erro padrão da média e o tamanho da amostra para as variáveis `MGE` e` MMG` para todas as combinações dos fatores `ENV` e` GEN`.


```r
stats_grp <- 
  df %>% 
  group_by(ENV, GEN) %>%
  desc_stat(MGE, MMG,
            stats = c("mean, se, n"))
stats_grp
## # A tibble: 76 x 6
##    ENV   GEN   variable  mean    se     n
##    <chr> <chr> <chr>    <dbl> <dbl> <dbl>
##  1 AMB1  H10   MGE       192.  8.88     3
##  2 AMB1  H10   MMG       374. 13.9      3
##  3 AMB1  H11   MGE       188. 15.2      3
##  4 AMB1  H11   MMG       353. 16.3      3
##  5 AMB1  H12   MGE       180.  9.84     3
##  6 AMB1  H12   MMG       333.  6.06     3
##  7 AMB1  H13   MGE       219. 10.2      3
##  8 AMB1  H13   MMG       368. 26.9      3
##  9 AMB1  H2    MGE       204.  4.32     3
## 10 AMB1  H2    MMG       329. 26.6      3
## # ... with 66 more rows
```
