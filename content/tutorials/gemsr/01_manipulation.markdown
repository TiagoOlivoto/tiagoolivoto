---
title: Manipulação de dados
linktitle: "1. Manipulação de dados"
toc: true
type: docs
date: "2021/07/09"
draft: false
df_print: paged
code_download: true
menu:
  gemsr:
    parent: GEMS-R
    weight: 2
weight: 1
---

## Pacotes

```r
library(tidyverse)  # manipulação de dados
## -- Attaching packages --------------------------------------- tidyverse 1.3.1 --
## v ggplot2 3.3.5     v purrr   0.3.4
## v tibble  3.1.2     v dplyr   1.0.7
## v tidyr   1.1.3     v stringr 1.4.0
## v readr   1.4.0     v forcats 0.5.1
## -- Conflicts ------------------------------------------ tidyverse_conflicts() --
## x dplyr::filter() masks stats::filter()
## x dplyr::lag()    masks stats::lag()
library(metan)
## Registered S3 method overwritten by 'GGally':
##   method from   
##   +.gg   ggplot2
## |=========================================================|
## | Multi-Environment Trial Analysis (metan) v1.14.0        |
## | Author: Tiago Olivoto                                   |
## | Type 'citation('metan')' to know how to cite metan      |
## | Type 'vignette('metan_start')' for a short tutorial     |
## | Visit 'https://bit.ly/pkgmetan' for a complete tutorial |
## |=========================================================|
## 
## Attaching package: 'metan'
## The following object is masked from 'package:forcats':
## 
##     as_factor
## The following object is masked from 'package:dplyr':
## 
##     recode_factor
## The following object is masked from 'package:tidyr':
## 
##     replace_na
## The following objects are masked from 'package:tibble':
## 
##     column_to_rownames, remove_rownames, rownames_to_column
library(rio)        # importação/exportação de dados
```


## Formatar strings

A função `tidy_strings()` pode ser usada para organizar strings de caracteres colocando todas as palavras em maiúsculas, substituindo qualquer espaço, tabulação, caracteres de pontuação por `_` e colocando `_` entre maiúsculas e minúsculas.

### Um exemplo simples
Suponha que tenhamos uma string de caracteres, digamos, `str = c("Env1", "env 1", "env.1")`. Por definição, `str` deve representar um nível único em testes de melhoramento de plantas, por exemplo, ambiente 1, mas na verdade tem três níveis.

```r
str <- c ("Env1", "env 1", "env.1")
str %>% factor() %>% levels()
## [1] "env 1" "env.1" "Env1"
```


```r
tidy_strings(str)
## [1] "ENV_1" "ENV_1" "ENV_1"
```
Excelente! Agora temos o nível único que deveríamos ter antes.

### Mais exemplos
Todos os itens a seguir serão convertidos para `" ENV_1 "`.

```r
messy_env <- c ("ENV 1", "Env 1", "Env1", "env1", "Env.1", "Env_1")
tidy_strings(messy_env)
## [1] "ENV_1" "ENV_1" "ENV_1" "ENV_1" "ENV_1" "ENV_1"
```

Todos os itens a seguir serão traduzidos em `" GEN _ * "`.

```r
messy_gen <- c ("GEN1", "gen 2", "Gen.3", "gen-4", "Gen_5", "GEN_6")
tidy_strings(messy_gen)
## [1] "GEN_1" "GEN_2" "GEN_3" "GEN_4" "GEN_5" "GEN_6"
```

Todos os itens a seguir serão traduzidos para `" ENV_GEN "`

```r
messy_int <- c ("EnvGen", "Env_Gen", "env gen", "Env Gen", "ENV.GEN", "ENV_GEN")
tidy_strings(messy_int)
## [1] "ENV_GEN" "ENV_GEN" "ENV_GEN" "ENV_GEN" "ENV_GEN" "ENV_GEN"
```



### Organize data.frames
Também podemos organizar strings de um data.frame. Por padrão, o caractere separador é `_`. Para alterar esse padrão, use o argumento `sep`.

```r
df <- tibble(Env = messy_env,
             gen = messy_gen,
             Env_Gen = interaction(Env, gen),
             y = rnorm(6, 300, 10))
df
## # A tibble: 6 x 4
##   Env   gen   Env_Gen         y
##   <chr> <chr> <fct>       <dbl>
## 1 ENV 1 GEN1  ENV 1.GEN1   303.
## 2 Env 1 gen 2 Env 1.gen 2  292.
## 3 Env1  Gen.3 Env1.Gen.3   303.
## 4 env1  gen-4 env1.gen-4   295.
## 5 Env.1 Gen_5 Env.1.Gen_5  312.
## 6 Env_1 GEN_6 Env_1.GEN_6  278.
tidy_strings(df, sep = "")
## # A tibble: 6 x 4
##   Env   gen   Env_Gen      y
##   <chr> <chr> <chr>    <dbl>
## 1 ENV1  GEN1  ENV1GEN1  303.
## 2 ENV1  GEN2  ENV1GEN2  292.
## 3 ENV1  GEN3  ENV1GEN3  303.
## 4 ENV1  GEN4  ENV1GEN4  295.
## 5 ENV1  GEN5  ENV1GEN5  312.
## 6 ENV1  GEN6  ENV1GEN6  278.
```



## Conjunto de dados


```r
# Dados "bagunçados"
df_messy <- import("df_messy.xlsx", setclass = "tbl")
print(df_messy)
## # A tibble: 114 x 13
##    env   Gen   BLOCO `Alt plant` `Alt Esp` COMPES DIAMES CompSab DiamSab   Mge
##    <chr> <chr> <dbl>       <dbl>     <dbl>  <dbl>  <dbl>   <dbl>   <dbl> <dbl>
##  1 Amb 1 H10       1        0         1.64   16.7   54.0    31.7    17.4  194.
##  2 <NA>  <NA>      2        2.79      1.71   14.9   52.7    32.0    15.5  176.
##  3 <NA>  <NA>      3        2.72      1.51   16.7   52.7    30.4    17.5  207.
##  4 <NA>  H11       1        2.75      1.51   17.4   51.7    30.6    18.0  217.
##  5 <NA>  <NA>      2        2.72      1.56   16.7   47.2    28.7    17.2  181.
##  6 <NA>  <NA>      3        2.77      1.67   15.8   47.9    27.6    16.4  166.
##  7 <NA>  H12       1        2.73      1.54   14.9   47.5    28.2    15.5  161.
##  8 <NA>  <NA>      2        2.56      1.56   15.7   49.9    29.8    16.2  188.
##  9 <NA>  <NA>      3        2.79      1.53   15.0   52.7    31.4    15.2  193.
## 10 <NA>  H13       1        2.74      1.6    14.6   54      32.5    15.1  205.
## # ... with 104 more rows, and 3 more variables: Nfil <dbl>, MMG <chr>,
## #   NGE <dbl>
```






```r
df_tidy <- 
  df_messy %>% 
  tidy_colnames() %>% # formata nomes das variáveis
  fill_na() %>%  # preenche NAs
  tidy_strings(sep = "") # formata strings

print(df_tidy)
## # A tibble: 114 x 13
##    ENV   GEN   BLOCO ALT_PLANT ALT_ESP COMPES DIAMES COMP_SAB DIAM_SAB   MGE
##    <chr> <chr> <dbl>     <dbl>   <dbl>  <dbl>  <dbl>    <dbl>    <dbl> <dbl>
##  1 AMB1  H10       1      0       1.64   16.7   54.0     31.7     17.4  194.
##  2 AMB1  H10       2      2.79    1.71   14.9   52.7     32.0     15.5  176.
##  3 AMB1  H10       3      2.72    1.51   16.7   52.7     30.4     17.5  207.
##  4 AMB1  H11       1      2.75    1.51   17.4   51.7     30.6     18.0  217.
##  5 AMB1  H11       2      2.72    1.56   16.7   47.2     28.7     17.2  181.
##  6 AMB1  H11       3      2.77    1.67   15.8   47.9     27.6     16.4  166.
##  7 AMB1  H12       1      2.73    1.54   14.9   47.5     28.2     15.5  161.
##  8 AMB1  H12       2      2.56    1.56   15.7   49.9     29.8     16.2  188.
##  9 AMB1  H12       3      2.79    1.53   15.0   52.7     31.4     15.2  193.
## 10 AMB1  H13       1      2.74    1.6    14.6   54       32.5     15.1  205.
## # ... with 104 more rows, and 3 more variables: NFIL <dbl>, MMG <chr>,
## #   NGE <dbl>

# exportar os dados 'arrumados'
# export(df_tidy, "df_tidy.xlsx")
```



## Utilitários para linhas e colunas
### Adicionar colunas e linhas
As funções `add_cols()` e `add_rows()` podem ser usadas para adicionar colunas e linhas, respectivamente, a um data.frame. Também é possível adicionar uma coluna com base nos dados existentes. Observe que os argumentos `.after` e` .before` são usados para selecionar a posição da(s) nova(s) coluna(s). Isso é particularmente útil para colocar variáveis da mesma categoria juntas.


```r
df_tidy2 <- 
  add_cols(df_tidy,
           ALT_PLANT_CM = ALT_PLANT * 100,
           .after = ALT_PLANT)
```

### Selecionar ou remover colunas e linhas
As funções `select_cols()` e `select_rows()` podem ser usadas para selecionar colunas e linhas, respectivamente de um quadro de dados.


```r
select_cols(df_tidy, ENV, GEN)
## # A tibble: 114 x 2
##    ENV   GEN  
##    <chr> <chr>
##  1 AMB1  H10  
##  2 AMB1  H10  
##  3 AMB1  H10  
##  4 AMB1  H11  
##  5 AMB1  H11  
##  6 AMB1  H11  
##  7 AMB1  H12  
##  8 AMB1  H12  
##  9 AMB1  H12  
## 10 AMB1  H13  
## # ... with 104 more rows
select_rows(df_tidy, 1:3)
## # A tibble: 3 x 13
##   ENV   GEN   BLOCO ALT_PLANT ALT_ESP COMPES DIAMES COMP_SAB DIAM_SAB   MGE
##   <chr> <chr> <dbl>     <dbl>   <dbl>  <dbl>  <dbl>    <dbl>    <dbl> <dbl>
## 1 AMB1  H10       1      0       1.64   16.7   54.0     31.7     17.4  194.
## 2 AMB1  H10       2      2.79    1.71   14.9   52.7     32.0     15.5  176.
## 3 AMB1  H10       3      2.72    1.51   16.7   52.7     30.4     17.5  207.
## # ... with 3 more variables: NFIL <dbl>, MMG <chr>, NGE <dbl>
```

As colunas numéricas podem ser selecionadas usando a função `select_numeric_cols()`. Colunas não numéricas são selecionadas com `select_non_numeric_cols()`.


```r
select_numeric_cols(df_tidy)
## # A tibble: 114 x 10
##    BLOCO ALT_PLANT ALT_ESP COMPES DIAMES COMP_SAB DIAM_SAB   MGE  NFIL   NGE
##    <dbl>     <dbl>   <dbl>  <dbl>  <dbl>    <dbl>    <dbl> <dbl> <dbl> <dbl>
##  1     1      0       1.64   16.7   54.0     31.7     17.4  194.  15.6  519.
##  2     2      2.79    1.71   14.9   52.7     32.0     15.5  176.  17.6  502.
##  3     3      2.72    1.51   16.7   52.7     30.4     17.5  207.  16.8  525.
##  4     1      2.75    1.51   17.4   51.7     30.6     18.0  217.  16.8  525.
##  5     2      2.72    1.56   16.7   47.2     28.7     17.2  181.  13.6  501.
##  6     3      2.77    1.67   15.8   47.9     27.6     16.4  166.  15.2  513.
##  7     1      2.73    1.54   14.9   47.5     28.2     15.5  161.  14.8  480.
##  8     2      2.56    1.56   15.7   49.9     29.8     16.2  188.  17.2  586.
##  9     3      2.79    1.53   15.0   52.7     31.4     15.2  193.  20    594 
## 10     1      2.74    1.6    14.6   54       32.5     15.1  205.  20    628.
## # ... with 104 more rows


# Implementação dplyr
select(df_tidy, where(is.numeric))
## # A tibble: 114 x 10
##    BLOCO ALT_PLANT ALT_ESP COMPES DIAMES COMP_SAB DIAM_SAB   MGE  NFIL   NGE
##    <dbl>     <dbl>   <dbl>  <dbl>  <dbl>    <dbl>    <dbl> <dbl> <dbl> <dbl>
##  1     1      0       1.64   16.7   54.0     31.7     17.4  194.  15.6  519.
##  2     2      2.79    1.71   14.9   52.7     32.0     15.5  176.  17.6  502.
##  3     3      2.72    1.51   16.7   52.7     30.4     17.5  207.  16.8  525.
##  4     1      2.75    1.51   17.4   51.7     30.6     18.0  217.  16.8  525.
##  5     2      2.72    1.56   16.7   47.2     28.7     17.2  181.  13.6  501.
##  6     3      2.77    1.67   15.8   47.9     27.6     16.4  166.  15.2  513.
##  7     1      2.73    1.54   14.9   47.5     28.2     15.5  161.  14.8  480.
##  8     2      2.56    1.56   15.7   49.9     29.8     16.2  188.  17.2  586.
##  9     3      2.79    1.53   15.0   52.7     31.4     15.2  193.  20    594 
## 10     1      2.74    1.6    14.6   54       32.5     15.1  205.  20    628.
## # ... with 104 more rows


select_non_numeric_cols(df_tidy)
## # A tibble: 114 x 3
##    ENV   GEN   MMG  
##    <chr> <chr> <chr>
##  1 AMB1  H10   37961
##  2 AMB1  H10   34688
##  3 AMB1  H10   39403
##  4 AMB1  H11   37665
##  5 AMB1  H11   36066
##  6 AMB1  H11   3218 
##  7 AMB1  H12   34484
##  8 AMB1  H12   32833
##  9 AMB1  H12   32536
## 10 AMB1  H13   33437
## # ... with 104 more rows


# Implementação dplyr
select(df_tidy, where(~!is.numeric(.x)))
## # A tibble: 114 x 3
##    ENV   GEN   MMG  
##    <chr> <chr> <chr>
##  1 AMB1  H10   37961
##  2 AMB1  H10   34688
##  3 AMB1  H10   39403
##  4 AMB1  H11   37665
##  5 AMB1  H11   36066
##  6 AMB1  H11   3218 
##  7 AMB1  H12   34484
##  8 AMB1  H12   32833
##  9 AMB1  H12   32536
## 10 AMB1  H13   33437
## # ... with 104 more rows
```

Podemos selecionar a primeira ou última coluna rapidamente com `select_first_col()` e `select_last_col()`, respectivamente.


```r
select_first_col(df_tidy)
## # A tibble: 114 x 1
##    ENV  
##    <chr>
##  1 AMB1 
##  2 AMB1 
##  3 AMB1 
##  4 AMB1 
##  5 AMB1 
##  6 AMB1 
##  7 AMB1 
##  8 AMB1 
##  9 AMB1 
## 10 AMB1 
## # ... with 104 more rows
select_last_col(df_tidy)
## # A tibble: 114 x 1
##      NGE
##    <dbl>
##  1  519.
##  2  502.
##  3  525.
##  4  525.
##  5  501.
##  6  513.
##  7  480.
##  8  586.
##  9  594 
## 10  628.
## # ... with 104 more rows
```


Para remover colunas ou linhas, use `remove_cols()` e `remove_rows()`.

```r
remove_cols(df_tidy, ENV, GEN)
## # A tibble: 114 x 11
##    BLOCO ALT_PLANT ALT_ESP COMPES DIAMES COMP_SAB DIAM_SAB   MGE  NFIL MMG  
##    <dbl>     <dbl>   <dbl>  <dbl>  <dbl>    <dbl>    <dbl> <dbl> <dbl> <chr>
##  1     1      0       1.64   16.7   54.0     31.7     17.4  194.  15.6 37961
##  2     2      2.79    1.71   14.9   52.7     32.0     15.5  176.  17.6 34688
##  3     3      2.72    1.51   16.7   52.7     30.4     17.5  207.  16.8 39403
##  4     1      2.75    1.51   17.4   51.7     30.6     18.0  217.  16.8 37665
##  5     2      2.72    1.56   16.7   47.2     28.7     17.2  181.  13.6 36066
##  6     3      2.77    1.67   15.8   47.9     27.6     16.4  166.  15.2 3218 
##  7     1      2.73    1.54   14.9   47.5     28.2     15.5  161.  14.8 34484
##  8     2      2.56    1.56   15.7   49.9     29.8     16.2  188.  17.2 32833
##  9     3      2.79    1.53   15.0   52.7     31.4     15.2  193.  20   32536
## 10     1      2.74    1.6    14.6   54       32.5     15.1  205.  20   33437
## # ... with 104 more rows, and 1 more variable: NGE <dbl>
# Implementação dplyr
select(df_tidy, -c(ENV, GEN))
## # A tibble: 114 x 11
##    BLOCO ALT_PLANT ALT_ESP COMPES DIAMES COMP_SAB DIAM_SAB   MGE  NFIL MMG  
##    <dbl>     <dbl>   <dbl>  <dbl>  <dbl>    <dbl>    <dbl> <dbl> <dbl> <chr>
##  1     1      0       1.64   16.7   54.0     31.7     17.4  194.  15.6 37961
##  2     2      2.79    1.71   14.9   52.7     32.0     15.5  176.  17.6 34688
##  3     3      2.72    1.51   16.7   52.7     30.4     17.5  207.  16.8 39403
##  4     1      2.75    1.51   17.4   51.7     30.6     18.0  217.  16.8 37665
##  5     2      2.72    1.56   16.7   47.2     28.7     17.2  181.  13.6 36066
##  6     3      2.77    1.67   15.8   47.9     27.6     16.4  166.  15.2 3218 
##  7     1      2.73    1.54   14.9   47.5     28.2     15.5  161.  14.8 34484
##  8     2      2.56    1.56   15.7   49.9     29.8     16.2  188.  17.2 32833
##  9     3      2.79    1.53   15.0   52.7     31.4     15.2  193.  20   32536
## 10     1      2.74    1.6    14.6   54       32.5     15.1  205.  20   33437
## # ... with 104 more rows, and 1 more variable: NGE <dbl>
remove_rows(df_tidy, 1:2, 5:8)
## # A tibble: 108 x 13
##    ENV   GEN   BLOCO ALT_PLANT ALT_ESP COMPES DIAMES COMP_SAB DIAM_SAB   MGE
##    <chr> <chr> <dbl>     <dbl>   <dbl>  <dbl>  <dbl>    <dbl>    <dbl> <dbl>
##  1 AMB1  H10       3      2.72    1.51   16.7   52.7     30.4     17.5  207.
##  2 AMB1  H11       1      2.75    1.51   17.4   51.7     30.6     18.0  217.
##  3 AMB1  H12       3      2.79    1.53   15.0   52.7     31.4     15.2  193.
##  4 AMB1  H13       1      2.74    1.6    14.6   54       32.5     15.1  205.
##  5 AMB1  H13       2      2.64    1.37   14.8   53.7     31.0     15.5  239.
##  6 AMB1  H13       3      2.93    1.77   14.9   52.7     30.1     15.8  212.
##  7 AMB1  H2        1      2.55    1.22   15.1   51.7     27.7     15.3  198.
##  8 AMB1  H2        2      2.9     1.41   15.1   51.5     26.0     16    212.
##  9 AMB1  H2        3      2.92    1.39   14.8   52.6     26.0     15.1  202.
## 10 AMB1  H3        1      3.04    1.43   15.0   51.7     25.9     16.6  210.
## # ... with 98 more rows, and 3 more variables: NFIL <dbl>, MMG <chr>, NGE <dbl>
```


### Concatenar colunas
A função `concatetate()` pode ser usada para concatenar várias colunas de um data.frame. Ela retorna o data.frame com todas as colunas originais em `.data` mais a variável concatenada, após a última coluna(por padrão), ou em qualquer posição ao usar os argumentos` .before` ou `.after`.



```r
concatenate(df_tidy, ENV, GEN, BLOCO, .after = BLOCO, new_var = FATORES)
## # A tibble: 114 x 14
##    ENV   GEN   BLOCO FATORES   ALT_PLANT ALT_ESP COMPES DIAMES COMP_SAB DIAM_SAB
##    <chr> <chr> <dbl> <chr>         <dbl>   <dbl>  <dbl>  <dbl>    <dbl>    <dbl>
##  1 AMB1  H10       1 AMB1_H10~      0       1.64   16.7   54.0     31.7     17.4
##  2 AMB1  H10       2 AMB1_H10~      2.79    1.71   14.9   52.7     32.0     15.5
##  3 AMB1  H10       3 AMB1_H10~      2.72    1.51   16.7   52.7     30.4     17.5
##  4 AMB1  H11       1 AMB1_H11~      2.75    1.51   17.4   51.7     30.6     18.0
##  5 AMB1  H11       2 AMB1_H11~      2.72    1.56   16.7   47.2     28.7     17.2
##  6 AMB1  H11       3 AMB1_H11~      2.77    1.67   15.8   47.9     27.6     16.4
##  7 AMB1  H12       1 AMB1_H12~      2.73    1.54   14.9   47.5     28.2     15.5
##  8 AMB1  H12       2 AMB1_H12~      2.56    1.56   15.7   49.9     29.8     16.2
##  9 AMB1  H12       3 AMB1_H12~      2.79    1.53   15.0   52.7     31.4     15.2
## 10 AMB1  H13       1 AMB1_H13~      2.74    1.6    14.6   54       32.5     15.1
## # ... with 104 more rows, and 4 more variables: MGE <dbl>, NFIL <dbl>,
## #   MMG <chr>, NGE <dbl>
```

Para eliminar as variáveis existentes e manter apenas a coluna concatenada, use o argumento `drop = TRUE`. Para usar `concatenate()` dentro de uma determinada função como `add_cols()` use o argumento `pull = TRUE` para puxar os resultados para um vetor.

```r
concatenate(df_tidy, ENV, GEN, BLOCO, drop = TRUE) %>% head()
## # A tibble: 6 x 1
##   new_var   
##   <chr>     
## 1 AMB1_H10_1
## 2 AMB1_H10_2
## 3 AMB1_H10_3
## 4 AMB1_H11_1
## 5 AMB1_H11_2
## 6 AMB1_H11_3
concatenate(df_tidy, ENV, GEN, BLOCO, pull = TRUE) %>% head()
## [1] "AMB1_H10_1" "AMB1_H10_2" "AMB1_H10_3" "AMB1_H11_1" "AMB1_H11_2"
## [6] "AMB1_H11_3"
```


### Obtendo níveis
Para obter os níveis e o número de níveis de um fator, as funções `get_levels()` e `get_level_size()` podem ser usadas.


```r
get_levels(df_tidy, ENV)
## [1] "AMB1" "AMB2" "AMB3"
get_level_size(df_tidy, ENV)
## # A tibble: 3 x 13
##   ENV     GEN BLOCO ALT_PLANT ALT_ESP COMPES DIAMES COMP_SAB DIAM_SAB   MGE
##   <chr> <int> <int>     <int>   <int>  <int>  <int>    <int>    <int> <int>
## 1 AMB1     36    36        36      36     36     36       36       36    36
## 2 AMB2     39    39        39      39     39     39       39       39    39
## 3 AMB3     39    39        39      39     39     39       39       39    39
## # ... with 3 more variables: NFIL <int>, MMG <int>, NGE <int>
```


## Utilitários para números e strings
### Arredondando valores
A função `round_cols()` arredonda uma coluna selecionada ou um data.frame completo para o número especificado de casas decimais (padrão 0). Se nenhuma variável for informada, todas as variáveis numéricas serão arredondadas.


```r
round_cols(df_tidy, digits = 1)
## # A tibble: 114 x 13
##    ENV   GEN   BLOCO ALT_PLANT ALT_ESP COMPES DIAMES COMP_SAB DIAM_SAB   MGE
##    <chr> <chr> <dbl>     <dbl>   <dbl>  <dbl>  <dbl>    <dbl>    <dbl> <dbl>
##  1 AMB1  H10       1       0       1.6   16.7   54       31.7     17.4  194.
##  2 AMB1  H10       2       2.8     1.7   14.9   52.7     32       15.5  176.
##  3 AMB1  H10       3       2.7     1.5   16.7   52.7     30.4     17.5  207.
##  4 AMB1  H11       1       2.8     1.5   17.4   51.7     30.6     18    217.
##  5 AMB1  H11       2       2.7     1.6   16.7   47.2     28.7     17.2  181.
##  6 AMB1  H11       3       2.8     1.7   15.8   47.9     27.6     16.4  166.
##  7 AMB1  H12       1       2.7     1.5   14.9   47.5     28.2     15.5  161 
##  8 AMB1  H12       2       2.6     1.6   15.7   49.9     29.9     16.2  188 
##  9 AMB1  H12       3       2.8     1.5   15     52.7     31.4     15.2  192.
## 10 AMB1  H13       1       2.7     1.6   14.6   54       32.5     15.1  205.
## # ... with 104 more rows, and 3 more variables: NFIL <dbl>, MMG <chr>,
## #   NGE <dbl>
```

Alternativamente, selecione variáveis para arredondar.

```r
round_cols(df_tidy, ALT_PLANT:COMPES, digits = 0)
## # A tibble: 114 x 13
##    ENV   GEN   BLOCO ALT_PLANT ALT_ESP COMPES DIAMES COMP_SAB DIAM_SAB   MGE
##    <chr> <chr> <dbl>     <dbl>   <dbl>  <dbl>  <dbl>    <dbl>    <dbl> <dbl>
##  1 AMB1  H10       1         0       2     17   54.0     31.7     17.4  194.
##  2 AMB1  H10       2         3       2     15   52.7     32.0     15.5  176.
##  3 AMB1  H10       3         3       2     17   52.7     30.4     17.5  207.
##  4 AMB1  H11       1         3       2     17   51.7     30.6     18.0  217.
##  5 AMB1  H11       2         3       2     17   47.2     28.7     17.2  181.
##  6 AMB1  H11       3         3       2     16   47.9     27.6     16.4  166.
##  7 AMB1  H12       1         3       2     15   47.5     28.2     15.5  161.
##  8 AMB1  H12       2         3       2     16   49.9     29.8     16.2  188.
##  9 AMB1  H12       3         3       2     15   52.7     31.4     15.2  193.
## 10 AMB1  H13       1         3       2     15   54       32.5     15.1  205.
## # ... with 104 more rows, and 3 more variables: NFIL <dbl>, MMG <chr>,
## #   NGE <dbl>
```

### Extraindo e substituindo números

As funções `extract_number()` e `replace_number()` podem ser usadas para extrair ou substituir números. Como exemplo, iremos extrair o número de cada genótipo em `df_tidy`. Por padrão, os números extraídos são colocados como uma nova variável chamada `new_var` após a última coluna dos dados.


```r
extract_number(df_tidy, GEN)
## # A tibble: 114 x 13
##    ENV     GEN BLOCO ALT_PLANT ALT_ESP COMPES DIAMES COMP_SAB DIAM_SAB   MGE
##    <chr> <dbl> <dbl>     <dbl>   <dbl>  <dbl>  <dbl>    <dbl>    <dbl> <dbl>
##  1 AMB1     10     1      0       1.64   16.7   54.0     31.7     17.4  194.
##  2 AMB1     10     2      2.79    1.71   14.9   52.7     32.0     15.5  176.
##  3 AMB1     10     3      2.72    1.51   16.7   52.7     30.4     17.5  207.
##  4 AMB1     11     1      2.75    1.51   17.4   51.7     30.6     18.0  217.
##  5 AMB1     11     2      2.72    1.56   16.7   47.2     28.7     17.2  181.
##  6 AMB1     11     3      2.77    1.67   15.8   47.9     27.6     16.4  166.
##  7 AMB1     12     1      2.73    1.54   14.9   47.5     28.2     15.5  161.
##  8 AMB1     12     2      2.56    1.56   15.7   49.9     29.8     16.2  188.
##  9 AMB1     12     3      2.79    1.53   15.0   52.7     31.4     15.2  193.
## 10 AMB1     13     1      2.74    1.6    14.6   54       32.5     15.1  205.
## # ... with 104 more rows, and 3 more variables: NFIL <dbl>, MMG <chr>,
## #   NGE <dbl>
```

Para substituir os números de uma determinada coluna por uma substituição especificada, use `replace_number()`. Por padrão, os números são substituídos por "".


```r
replace_number(df_tidy,
               BLOCO,
               pattern  = "1",
               replacement  = "Rep_1")
## # A tibble: 114 x 13
##    ENV   GEN   BLOCO ALT_PLANT ALT_ESP COMPES DIAMES COMP_SAB DIAM_SAB   MGE
##    <chr> <chr> <chr>     <dbl>   <dbl>  <dbl>  <dbl>    <dbl>    <dbl> <dbl>
##  1 AMB1  H10   Rep_1      0       1.64   16.7   54.0     31.7     17.4  194.
##  2 AMB1  H10   2          2.79    1.71   14.9   52.7     32.0     15.5  176.
##  3 AMB1  H10   3          2.72    1.51   16.7   52.7     30.4     17.5  207.
##  4 AMB1  H11   Rep_1      2.75    1.51   17.4   51.7     30.6     18.0  217.
##  5 AMB1  H11   2          2.72    1.56   16.7   47.2     28.7     17.2  181.
##  6 AMB1  H11   3          2.77    1.67   15.8   47.9     27.6     16.4  166.
##  7 AMB1  H12   Rep_1      2.73    1.54   14.9   47.5     28.2     15.5  161.
##  8 AMB1  H12   2          2.56    1.56   15.7   49.9     29.8     16.2  188.
##  9 AMB1  H12   3          2.79    1.53   15.0   52.7     31.4     15.2  193.
## 10 AMB1  H13   Rep_1      2.74    1.6    14.6   54       32.5     15.1  205.
## # ... with 104 more rows, and 3 more variables: NFIL <dbl>, MMG <chr>,
## #   NGE <dbl>
```

### Extraindo, substituindo e removendo strings
As funções `extract_string()` e `replace_string()` são usadas no mesmo contexto de `extract_number()` e `replace_number()`, mas para lidar com strings.


```r
extract_string(df_tidy, GEN)
## # A tibble: 114 x 13
##    ENV   GEN   BLOCO ALT_PLANT ALT_ESP COMPES DIAMES COMP_SAB DIAM_SAB   MGE
##    <chr> <chr> <dbl>     <dbl>   <dbl>  <dbl>  <dbl>    <dbl>    <dbl> <dbl>
##  1 AMB1  H         1      0       1.64   16.7   54.0     31.7     17.4  194.
##  2 AMB1  H         2      2.79    1.71   14.9   52.7     32.0     15.5  176.
##  3 AMB1  H         3      2.72    1.51   16.7   52.7     30.4     17.5  207.
##  4 AMB1  H         1      2.75    1.51   17.4   51.7     30.6     18.0  217.
##  5 AMB1  H         2      2.72    1.56   16.7   47.2     28.7     17.2  181.
##  6 AMB1  H         3      2.77    1.67   15.8   47.9     27.6     16.4  166.
##  7 AMB1  H         1      2.73    1.54   14.9   47.5     28.2     15.5  161.
##  8 AMB1  H         2      2.56    1.56   15.7   49.9     29.8     16.2  188.
##  9 AMB1  H         3      2.79    1.53   15.0   52.7     31.4     15.2  193.
## 10 AMB1  H         1      2.74    1.6    14.6   54       32.5     15.1  205.
## # ... with 104 more rows, and 3 more variables: NFIL <dbl>, MMG <chr>,
## #   NGE <dbl>
```

Para substituir strings, podemos usar a função `replace_strings()`.

```r
replace_string(df_tidy,
               GEN,
               pattern = "H",
               replacement  = "GEN_")
## # A tibble: 114 x 13
##    ENV   GEN    BLOCO ALT_PLANT ALT_ESP COMPES DIAMES COMP_SAB DIAM_SAB   MGE
##    <chr> <chr>  <dbl>     <dbl>   <dbl>  <dbl>  <dbl>    <dbl>    <dbl> <dbl>
##  1 AMB1  GEN_10     1      0       1.64   16.7   54.0     31.7     17.4  194.
##  2 AMB1  GEN_10     2      2.79    1.71   14.9   52.7     32.0     15.5  176.
##  3 AMB1  GEN_10     3      2.72    1.51   16.7   52.7     30.4     17.5  207.
##  4 AMB1  GEN_11     1      2.75    1.51   17.4   51.7     30.6     18.0  217.
##  5 AMB1  GEN_11     2      2.72    1.56   16.7   47.2     28.7     17.2  181.
##  6 AMB1  GEN_11     3      2.77    1.67   15.8   47.9     27.6     16.4  166.
##  7 AMB1  GEN_12     1      2.73    1.54   14.9   47.5     28.2     15.5  161.
##  8 AMB1  GEN_12     2      2.56    1.56   15.7   49.9     29.8     16.2  188.
##  9 AMB1  GEN_12     3      2.79    1.53   15.0   52.7     31.4     15.2  193.
## 10 AMB1  GEN_13     1      2.74    1.6    14.6   54       32.5     15.1  205.
## # ... with 104 more rows, and 3 more variables: NFIL <dbl>, MMG <chr>,
## #   NGE <dbl>
```


### metan > GÊNES
Para remover todas as strings de um quadro de dados, use `remove_strings()`.

```r
remove_strings(df_tidy)
## # A tibble: 114 x 13
##      ENV   GEN BLOCO ALT_PLANT ALT_ESP COMPES DIAMES COMP_SAB DIAM_SAB   MGE
##    <dbl> <dbl> <dbl>     <dbl>   <dbl>  <dbl>  <dbl>    <dbl>    <dbl> <dbl>
##  1     1    10     1      0       1.64   16.7   54.0     31.7     17.4  194.
##  2     1    10     2      2.79    1.71   14.9   52.7     32.0     15.5  176.
##  3     1    10     3      2.72    1.51   16.7   52.7     30.4     17.5  207.
##  4     1    11     1      2.75    1.51   17.4   51.7     30.6     18.0  217.
##  5     1    11     2      2.72    1.56   16.7   47.2     28.7     17.2  181.
##  6     1    11     3      2.77    1.67   15.8   47.9     27.6     16.4  166.
##  7     1    12     1      2.73    1.54   14.9   47.5     28.2     15.5  161.
##  8     1    12     2      2.56    1.56   15.7   49.9     29.8     16.2  188.
##  9     1    12     3      2.79    1.53   15.0   52.7     31.4     15.2  193.
## 10     1    13     1      2.74    1.6    14.6   54       32.5     15.1  205.
## # ... with 104 more rows, and 3 more variables: NFIL <dbl>, MMG <dbl>,
## #   NGE <dbl>
```


### metan > Selegen

```r
df_selegen <- 
  df_to_selegen_54(df_tidy,
                   env = ENV,
                   gen = GEN,
                   rep = BLOCO)
## The data `df_tidy` has been arranged according to the `ENV` and `BLOCO` columns.
print(df_selegen)
## # A tibble: 114 x 17
##    ENV   PARCELA GEN   REP   REPETICAO   OBS BLOCO ALT_PLANT ALT_ESP COMPES
##    <chr>   <int> <chr> <chr> <chr>     <dbl> <dbl>     <dbl>   <dbl>  <dbl>
##  1 AMB1        1 H10   1     AMB1_H10      1     1      0       1.64   16.7
##  2 AMB1        2 H11   1     AMB1_H11      1     1      2.75    1.51   17.4
##  3 AMB1        3 H12   1     AMB1_H12      1     1      2.73    1.54   14.9
##  4 AMB1        4 H13   1     AMB1_H13      1     1      2.74    1.6    14.6
##  5 AMB1        5 H2    1     AMB1_H2       1     1      2.55    1.22   15.1
##  6 AMB1        6 H3    1     AMB1_H3       1     1      3.04    1.43   15.0
##  7 AMB1        7 H4    1     AMB1_H4       1     1      3.02    1.82   16.5
##  8 AMB1        8 H5    1     AMB1_H5       1     1      2.9     1.58   16.0
##  9 AMB1        9 H6    1     AMB1_H6       1     1      2.9     1.59   17.1
## 10 AMB1       10 H7    1     AMB1_H7       1     1      2.87    1.56   16.6
## # ... with 104 more rows, and 7 more variables: DIAMES <dbl>, COMP_SAB <dbl>,
## #   DIAM_SAB <dbl>, MGE <dbl>, NFIL <dbl>, MMG <chr>, NGE <dbl>
```


## Dividir/juntar conjunto de dados

```r
df_list <- split_factors(df_tidy, ENV)
df_list
## $AMB1
## # A tibble: 36 x 12
##    GEN   BLOCO ALT_PLANT ALT_ESP COMPES DIAMES COMP_SAB DIAM_SAB   MGE  NFIL
##    <chr> <dbl>     <dbl>   <dbl>  <dbl>  <dbl>    <dbl>    <dbl> <dbl> <dbl>
##  1 H10       1      0       1.64   16.7   54.0     31.7     17.4  194.  15.6
##  2 H10       2      2.79    1.71   14.9   52.7     32.0     15.5  176.  17.6
##  3 H10       3      2.72    1.51   16.7   52.7     30.4     17.5  207.  16.8
##  4 H11       1      2.75    1.51   17.4   51.7     30.6     18.0  217.  16.8
##  5 H11       2      2.72    1.56   16.7   47.2     28.7     17.2  181.  13.6
##  6 H11       3      2.77    1.67   15.8   47.9     27.6     16.4  166.  15.2
##  7 H12       1      2.73    1.54   14.9   47.5     28.2     15.5  161.  14.8
##  8 H12       2      2.56    1.56   15.7   49.9     29.8     16.2  188.  17.2
##  9 H12       3      2.79    1.53   15.0   52.7     31.4     15.2  193.  20  
## 10 H13       1      2.74    1.6    14.6   54       32.5     15.1  205.  20  
## # ... with 26 more rows, and 2 more variables: MMG <chr>, NGE <dbl>
## 
## $AMB2
## # A tibble: 39 x 12
##    GEN   BLOCO ALT_PLANT ALT_ESP COMPES DIAMES COMP_SAB DIAM_SAB   MGE  NFIL
##    <chr> <dbl>     <dbl>   <dbl>  <dbl>  <dbl>    <dbl>    <dbl> <dbl> <dbl>
##  1 H1        1      3       1.88   15.1   50.8     31.1     15.6  191.  16.4
##  2 H1        2      2.97    1.83   15.2   52.1     31.2     15.7  197.  17.2
##  3 H1        3      2.81    1.67   14.6   52.7     32.2     15.1  177.  17.6
##  4 H10       1      2.1     0.91   16.0   46.7     27.2     17.1  151.  15.2
##  5 H10       2      2.12    1.03   14.6   46.4     26.6     15.5  152.  13.2
##  6 H10       3      1.92    1.02   16.0   47.1     26.6     16.3  177.  13.6
##  7 H11       1      2.13    1.05   14.8   47.0     27.0     15.9  169.  13.2
##  8 H11       2      2.13    1.01   16.0   47.7     28.0     16.3  168.  14  
##  9 H11       3      2.18    0.99   14.6   47.3     26.7     14.8  153.  14  
## 10 H12       1      2.15    0.98   14.3   45.3     25.7     14.8  138.  13.6
## # ... with 29 more rows, and 2 more variables: MMG <chr>, NGE <dbl>
## 
## $AMB3
## # A tibble: 39 x 12
##    GEN   BLOCO ALT_PLANT ALT_ESP COMPES DIAMES COMP_SAB DIAM_SAB   MGE  NFIL
##    <chr> <dbl>     <dbl>   <dbl>  <dbl>  <dbl>    <dbl>    <dbl> <dbl> <dbl>
##  1 H1        1      2.11    1.05   15.7   49.9     30.5     16.6  164.  15.6
##  2 H1        2      2.2     1.09   13.7   49.2     30.5     14.7  130.  16.4
##  3 H1        3      2.29    1.15   15.1   52.6     31.7     16.2  176   15.6
##  4 H10       1      1.79    0.89   13.9   44.1     26.2     15.0  116.  14.8
##  5 H10       2      2.05    1.03   13.6   43.9     23.5     14.4  118.  16  
##  6 H10       3      2.27    1.11   14.5   43.7     24.6     16.1  128.  15.2
##  7 H11       1      1.71    0.81   15.5   45.2     25.0     16.7  140.  15.6
##  8 H11       2      2.09    1.06   12.2   46.9     26.5     14.3  114.  16.8
##  9 H11       3      2.5     1.44   15.0   49.0     27.5     15.2  168.  16.4
## 10 H12       1      2.52    1.52   14.4   49.2     28.4     15    153.  16.4
## # ... with 29 more rows, and 2 more variables: MMG <chr>, NGE <dbl>
## 
## attr(,"ptype")
## # A tibble: 0 x 12
## # ... with 12 variables: GEN <chr>, BLOCO <dbl>, ALT_PLANT <dbl>,
## #   ALT_ESP <dbl>, COMPES <dbl>, DIAMES <dbl>, COMP_SAB <dbl>, DIAM_SAB <dbl>,
## #   MGE <dbl>, NFIL <dbl>, MMG <chr>, NGE <dbl>
## attr(,"class")
## [1] "split_factors"
rbind_fill_id(df_list, .id = "AMBIENTE")
## # A tibble: 114 x 13
##    AMBIENTE GEN   BLOCO ALT_PLANT ALT_ESP COMPES DIAMES COMP_SAB DIAM_SAB   MGE
##    <chr>    <chr> <dbl>     <dbl>   <dbl>  <dbl>  <dbl>    <dbl>    <dbl> <dbl>
##  1 AMB1     H10       1      0       1.64   16.7   54.0     31.7     17.4  194.
##  2 AMB1     H10       2      2.79    1.71   14.9   52.7     32.0     15.5  176.
##  3 AMB1     H10       3      2.72    1.51   16.7   52.7     30.4     17.5  207.
##  4 AMB1     H11       1      2.75    1.51   17.4   51.7     30.6     18.0  217.
##  5 AMB1     H11       2      2.72    1.56   16.7   47.2     28.7     17.2  181.
##  6 AMB1     H11       3      2.77    1.67   15.8   47.9     27.6     16.4  166.
##  7 AMB1     H12       1      2.73    1.54   14.9   47.5     28.2     15.5  161.
##  8 AMB1     H12       2      2.56    1.56   15.7   49.9     29.8     16.2  188.
##  9 AMB1     H12       3      2.79    1.53   15.0   52.7     31.4     15.2  193.
## 10 AMB1     H13       1      2.74    1.6    14.6   54       32.5     15.1  205.
## # ... with 104 more rows, and 3 more variables: NFIL <dbl>, MMG <chr>,
## #   NGE <dbl>
```


## Tabela bidirecional

```r
# Cria uma tabela bidirecional
tab <- make_mat(df_tidy,
                row = GEN,
                col = ENV,
                value = NGE)
# máximo valor observado
tab2 <- make_mat(df_tidy,
                row = GEN,
                col = ENV,
                value = NGE,
                fun = max)

# soma de linhas e colunas
row_col_sum(tab)
## Warning: NA values removed to compute the function. Use 'na.rm = TRUE' to
## suppress this warning.
## To remove rows with NA use `remove_rows_na()'. 
## To remove columns with NA use `remove_cols_na()'.
##               AMB2      AMB3      AMB1  row_sums
## H1        484.4000  425.1333        NA  909.5333
## H10       510.6000  488.8000  515.4000 1514.8000
## H11       478.0000  487.7333  512.7333 1478.4667
## H12       424.0000  516.8667  553.3333 1494.2000
## H13       522.8667  578.8667  611.0667 1712.8000
## H2        531.4000  466.3333  621.7333 1619.4667
## H3        474.5333  421.0000  609.8667 1505.4000
## H4        510.4667  474.2000  604.4000 1589.0667
## H5        560.4000  536.4667 2129.4000 3226.2667
## H6        621.7333  419.5333  568.5333 1609.8000
## H7        487.0667  440.6667  544.0000 1471.7333
## H8        476.7333  407.3333  541.8000 1425.8667
## H9        478.2667  419.7333  488.5333 1386.5333
## col_sums 6560.4667 6082.6667 8300.8000        NA

# média de linhas e colunas
row_col_mean(tab)
## Warning: NA values removed to compute the function. Use 'na.rm = TRUE' to
## suppress this warning.
## To remove rows with NA use `remove_rows_na()'. 
## To remove columns with NA use `remove_cols_na()'.
##               AMB2     AMB3      AMB1 row_means
## H1        484.4000 425.1333        NA  454.7667
## H10       510.6000 488.8000  515.4000  504.9333
## H11       478.0000 487.7333  512.7333  492.8222
## H12       424.0000 516.8667  553.3333  498.0667
## H13       522.8667 578.8667  611.0667  570.9333
## H2        531.4000 466.3333  621.7333  539.8222
## H3        474.5333 421.0000  609.8667  501.8000
## H4        510.4667 474.2000  604.4000  529.6889
## H5        560.4000 536.4667 2129.4000 1075.4222
## H6        621.7333 419.5333  568.5333  536.6000
## H7        487.0667 440.6667  544.0000  490.5778
## H8        476.7333 407.3333  541.8000  475.2889
## H9        478.2667 419.7333  488.5333  462.1778
## col_means 504.6513 467.8974  691.7333        NA
```

