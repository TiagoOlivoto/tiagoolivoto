---
title: Amostragem
linktitle: "6. Amostragem"
toc: true
type: docs
date: "2022/04/22"
draft: false
df_print: paged
code_download: true
menu:
  experimentacao:
    parent: Experimentação
    weight: 7
weight: 6
---
# Dados


<!-- ```{r} -->
<!-- library(tidyverse) -->
<!-- library(rio) -->
<!-- df <- import("https://docs.google.com/spreadsheets/d/1JMrkppvv1BdGKVCekzZPsPYCKcgUWjxpuDlWqejc22s/edit#gid=1461701268") -->
<!-- df -->
<!-- ``` -->

<!-- A função `sample_random()` pode ser utilizada para amostrar `n` linhas aleatoriamente do conjunto de dados `data`. Utilizando `prop`, uma proporção dos dados é amostrada. Este último é útil ao realizar amostragens estratificadas informando o argumento `strata`, onde cada estrato possui diferentes tamanhos de amostra. -->

<!-- ```{r} -->
<!-- # Função auxiliar -->
<!-- sample_random <- function(data, n, prop, strata = NULL){ -->
<!--   if(!missing(strata)){ -->
<!--     data <- data |> group_by({{strata}}) -->
<!--   } -->
<!--   slice_sample(data, n = n, prop = prop) -->
<!-- } -->
<!-- ``` -->


<!-- # Amostragem aleatória simples -->
<!-- A amostragem aleatória simples é o método mais básico de amostragem que tanto pode ser utilizado diretamente na seleção de uma amostra, quando se conhece os indivíduos da população, como ser parte de outros planos amostrais como, por exemplo, da Amostragem Estratificada. -->

<!-- O número possíveis de amostras com `n` indivíduos de uma população com `N` elementos, é dado por: -->

<!-- $$ -->
<!-- \mathop C\nolimits_N^n = \frac{N!}{n!(N-n)!} -->
<!-- $$ -->

<!-- No próximo exemplo, veremos as possíveis amostras (120) com 3 indivíduos, tomadas de uma população com 10 indivíduos. -->

<!-- ```{r} -->
<!-- N <- 10 -->
<!-- n <- 3 -->
<!-- d <- combn(N, n) -->
<!-- t(d) -->
<!-- ``` -->



<!-- ## Aplicação -->
<!-- Vamos considerar uma variável `x`, distribuida normalmente  com média \$\bar x = 10\$ e desvio padrão \$S = 2\$, avaliada em população com N = 10. -->

<!-- ```{r} -->
<!-- N <- 10 -->
<!-- df <- data.frame(id = 1:N, -->
<!--                  x = rnorm(n = N, mean = 10, sd = 2)) -->
<!-- df -->
<!-- ``` -->

<!-- Considerando uma amostragem com `n = 3`, as 120 amostras possíveis são -->


<!-- ```{r} -->
<!-- n <- 3 -->
<!-- amostras <- combn(N, n) |> t() -->
<!-- amostras |> head() -->
<!-- amostras |> tail() -->
<!-- ``` -->

<!-- A seguinte função, computa a média das 120 amostras. Assim, obtém-se a distribuição das médias amostrais. -->
<!-- ```{r} -->
<!-- library(tidyverse) -->
<!-- medias <- NULL -->
<!-- # abordagem com for-loop -->
<!-- for (i in 1:nrow(amostras)) { -->
<!--   individ <- amostras[i,] -->
<!--   valores <- df$x[individ] -->
<!--   medias <- append(medias, mean(valores)) -->
<!-- } -->

<!-- # criar um data frame com as médias -->
<!-- df_medias <- data.frame(amostras) |> mutate(media = medias) -->
<!-- head(df_medias) -->
<!-- tail(df_medias) -->
<!-- ``` -->


<!-- Ao computar a média das medias amostrais, obtém-se a média populacional -->
<!-- ```{r} -->
<!-- med_amostral <- mean(df_medias$media) -->
<!-- med_pop <-  mean(df$x) -->

<!-- identical(med_amostral, med_pop) -->

<!-- ggplot(df_medias, aes(x = media)) + -->
<!--   geom_histogram(bins = 8, color = "black", fill = "gray") + -->
<!--   geom_vline(xintercept = med_pop, color = "red", size = 1) -->
<!-- ``` -->

<!-- # Abordagem paralela -->
<!-- Quando o número de amostras cresce bastante, a abordagem for-loop não é computacionalmente eficiente. Assim, uma abordagem utilizando `sapply()` é mais eficiente. Quando paraleliza-se a função, a eficiência aumenta mais ainda. -->
<!-- ```{r} -->
<!-- # criando uma função para obter a média de um id -->
<!-- get_mean <- function(df, var, amostras, id){ -->
<!--   individ <- amostras[id,] -->
<!--   mean(df[[var]][individ]) -->
<!-- } -->


<!-- N <- 30 -->
<!-- n <- 7 -->
<!-- df2 <- data.frame(id = 1:N, -->
<!--                   x = rnorm(n = N, mean = 10, sd = 2)) -->
<!-- amostras2 <- combn(N, n) |> t() -->


<!-- system.time( -->
<!--   medias2 <-  -->
<!--     sapply(1:nrow(amostras2), function(i){ -->
<!--       get_mean(df, "x", amostras2, id = i) -->
<!--     }) -->
<!-- ) -->


<!-- library(parallel) -->
<!-- clust <- makeCluster(5) -->
<!-- clusterExport(clust, -->
<!--               varlist = c("df", "amostras2", "get_mean")) -->
<!-- system.time( -->
<!--   medias3 <-  -->
<!--     parLapply(clust, 1:nrow(amostras2), function(i){ -->
<!--       get_mean(df, "x", amostras2, id = i) -->
<!--     }) -->
<!-- ) -->

<!-- ``` -->


<!-- # Amostragem Aleatória Estratificada -->
<!-- ## Número igual dentro de cada estrato -->
<!-- ```{r} -->
<!-- sample_random(df, n = 3, strata = cromossomo) -->
<!-- ``` -->


<!-- ## Proporção da população em cada estrato -->
<!-- ```{r} -->
<!-- sample_random(df, -->
<!--               prop = 0.3, -->
<!--               strata = cromossomo) -->
<!-- ``` -->



<!-- # Amostragem aleatória sistemática -->
<!-- ```{r} -->
<!-- sample_sist <- function(data, n, r = NULL){ -->
<!--   k <- ceiling(nrow(df) / 4) -->
<!--   if(is.null(r)){ -->
<!--     r <- sample(1:k, 1) -->
<!--   } -->
<!--   rows <- seq(r, r + k*(n-1), k) -->
<!--   slice(data, rows) -->
<!-- } -->

<!-- sample_sist(df, n = 4, r = 1) -->
<!-- ``` -->

