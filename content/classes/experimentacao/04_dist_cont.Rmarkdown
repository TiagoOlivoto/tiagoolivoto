---
title: Visualização
linktitle: "4. Distribuições contínuas"
toc: true
type: docs
date: "2022/04/22"
draft: false
df_print: paged
code_download: true
menu:
  experimentacao:
    parent: Experimentação
    weight: 5
# weight: 1
---


<!-- df1 <- 9 -->
<!-- df2 <- 30 -->
<!-- Alpha.des <- 0.05 -->
<!-- Alpha.obs = 0.066545 -->

<!-- df <- tibble(x = seq(from = -4, to = 4, length = 1000), -->
<!-- y = dnorm(x)) -->

<!-- ggplot(data=df, aes(x, y))+ -->
<!-- geom_line() + -->
<!-- geom_area(mapping = aes(x = ifelse(between(x, -4, -1) , x, 0)), fill = "red")+ -->
<!-- ylim(0, 0.4) -->


<!-- df <- data.frame( -->
<!-- sex=factor(rep(c("F", "M"), each=200)), -->
<!-- weight=round(c(rnorm(200, mean=55, sd=5), -->
<!-- rnorm(200, mean=65, sd=5))) -->
<!-- ) -->
<!-- head(df) -->
<!-- dat <- with(density(df$weight), data.frame(x, y)) -->

<!-- ggplot(data = dat, mapping = aes(x = x, y = y)) + -->
<!-- geom_line()+ -->
<!-- geom_area(mapping = aes(x = ifelse(x>65 & x< 70 , x, 0)), fill = "red") + -->
<!-- xlim(30, 80) -->


<!-- ## Questão 1 -->
<!-- 1.	A série histórica das vendas de uma determinada fórmula de adubo seguem uma distribuição normal com média 25.000 t e desvio padrão de 2.600 t. Se a empresa fabricante decidir fabricar 30000 toneladas deste adubo para suprir a demanda da safra atual, qual é a probabilidade de que ela não possa atender todas as vendas por estar com a produção esgotada? (R = 0,0272) -->
<!-- SOLUÇÃO: encontrar a probabilidade de vender mais que 30000 t -->



<!-- ```{r} -->
<!-- library(tidyverse) -->
<!-- library(metan) -->
<!-- me <- 25000 -->
<!-- sdd <- 2600 -->
<!-- val <- 30000 -->
<!-- Z <- (val - me) / sdd -->
<!-- prob <- 1 - pnorm(Z) -->
<!-- qnorm(1-pnorm(3.5), me, sdd) -->
<!-- qnorm(1-pnorm(3.5), me, sdd, lower.tail = F) -->

<!-- normal <- -->
<!--   ggplot() + -->
<!--   scale_x_continuous(limits = c(15900, 34100)) + -->
<!--   stat_function(fun = dnorm, -->
<!--                 geom = "area", -->
<!--                 fill = "steelblue", -->
<!--                 xlim = c(30000, 34100), -->
<!--                 args = list( -->
<!--                   mean = me, -->
<!--                   sd = sdd -->
<!--                 )) + -->
<!--   stat_function(fun = dnorm, -->
<!--                 geom = "line", -->
<!--                 args = list( -->
<!--                   mean = me, -->
<!--                   sd = sdd -->
<!--                 )) + -->
<!--   scale_y_continuous(expand = expansion(mult = c(0, .1)))+ -->
<!--   labs(x = "Valor original", y = "Probabilidade")+ -->
<!--   ggtitle("Distribuição da variável original") -->

<!-- padrao <- -->
<!--   ggplot() + -->
<!--   stat_function(fun = dnorm, -->
<!--                 geom = "area", -->
<!--                 fill = "steelblue", -->
<!--                 xlim = c(Z, 3.5)) + -->
<!--   stat_function(fun = dnorm, -->
<!--                 geom = "line")+ -->
<!--   scale_x_continuous(limits = c(-3.5, 3.5), breaks = c(seq(-3, 3, 1)))+ -->
<!--   scale_y_continuous(expand = expansion(mult = c(0, .1)))+ -->
<!--   labs(x = "Valor de Z", y = "Probabilidade")+ -->
<!--   # theme_metan(color.background = "transparent")+ -->
<!--   ggtitle("Distribuição da variável padronizada", -->
<!--           subtitle = paste("Valor de Z:", round(Z, 4), "; Prob área sombreada:", round(prob, 4))) -->

<!-- arrange_ggplot(normal, padrao, ncol = 1) -->
<!-- ``` -->








<!-- ## QUEST?O 2 -->
<!-- me <- 240000 -->
<!-- sdd <- 30000 -->
<!-- val <- me + 49362 -->
<!-- Z <- abs(qnorm(0.05)) -->
<!-- prob <- 0.05 -->
<!-- qnorm(1-pnorm(3.5), me, sdd) -->
<!-- qnorm(1-pnorm(3.5), me, sdd, lower.tail = F) -->

<!-- normal <- -->
<!-- ggplot(NULL, aes(x = c(135000, 345000))) + -->
<!-- stat_function(fun = dnorm, -->
<!-- geom = "area", -->
<!-- fill = "steelblue", -->
<!-- xlim = c(val, 345000), -->
<!-- args = list( -->
<!-- mean = me, -->
<!-- sd = sdd -->
<!-- ))+ -->
<!-- stat_function(fun = dnorm, -->
<!-- geom = "line", -->
<!-- args = list( -->
<!-- mean = me, -->
<!-- sd = sdd -->
<!-- ))+ -->
<!-- scale_y_continuous(expand = expand_scale(mult = c(0, .1)))+ -->
<!-- scale_x_continuous(labels = scales::comma)+ -->
<!-- labs(x = "Valor original", y = "Probabilidade")+ -->
<!-- theme_metan(color.background = "transparent") + -->
<!-- ggtitle("Distribui??o da vari?vel original") -->

<!-- padrao <- -->
<!-- ggplot(NULL, aes(x = c(-3.5, 3.5))) + -->
<!-- stat_function(fun = dnorm, -->
<!-- geom = "area", -->
<!-- fill = "steelblue", -->
<!-- xlim = c(Z, 3.5))+ -->
<!-- stat_function(fun = dnorm, -->
<!-- geom = "line")+ -->
<!-- scale_x_continuous(limits = c(-3.5, 3.5), breaks = c(seq(-3, 3, 1)))+ -->
<!-- scale_y_continuous(expand = expand_scale(mult = c(0, .1)))+ -->
<!-- labs(x = "Valor de Z", y = "Probabilidade")+ -->
<!-- theme_metan(color.background = "transparent")+ -->
<!-- ggtitle("Distribui??o da vari?vel padronizada", -->
<!-- subtitle = paste("Valor de Z:", round(Z, 4), "; Prob ?rea sombreada:", round(prob, 4))) -->

<!-- plot_grid(normal, padrao, ncol = 1, align = "hv") -->


<!-- ## QUEST?O 4 -->
<!-- me <- 1.9 -->
<!-- sdd <- sqrt(0.01) -->
<!-- val <- 2.1 -->
<!-- Z <- (val - me) / sdd -->
<!-- prob <- 1 - pnorm(Z) -->
<!-- qnorm(1-pnorm(3.5), me, sdd) -->
<!-- qnorm(1-pnorm(3.5), me, sdd, lower.tail = F) -->

<!-- normal <- -->
<!-- ggplot(NULL, aes(x = c(1.55, 2.25))) + -->
<!-- stat_function(fun = dnorm, -->
<!-- geom = "area", -->
<!-- fill = "steelblue", -->
<!-- xlim = c(val, 2.25), -->
<!-- args = list( -->
<!-- mean = me, -->
<!-- sd = sdd -->
<!-- ))+ -->
<!-- stat_function(fun = dnorm, -->
<!-- geom = "line", -->
<!-- args = list( -->
<!-- mean = me, -->
<!-- sd = sdd -->
<!-- ))+ -->
<!-- scale_y_continuous(expand = expand_scale(mult = c(0, .1)))+ -->
<!-- labs(x = "Valor original", y = "Probabilidade")+ -->
<!-- theme_metan(color.background = "transparent") + -->
<!-- ggtitle("Distribui??o da vari?vel original") -->

<!-- padrao <- -->
<!-- ggplot(NULL, aes(x = c(-3.5, 3.5))) + -->
<!-- stat_function(fun = dnorm, -->
<!-- geom = "area", -->
<!-- fill = "steelblue", -->
<!-- xlim = c(Z, 3.5))+ -->
<!-- stat_function(fun = dnorm, -->
<!-- geom = "line")+ -->
<!-- scale_x_continuous(limits = c(-3.5, 3.5), breaks = c(seq(-3, 3, 1)))+ -->
<!-- scale_y_continuous(expand = expand_scale(mult = c(0, .1)))+ -->
<!-- labs(x = "Valor de Z", y = "Probabilidade")+ -->
<!-- theme_metan(color.background = "transparent")+ -->
<!-- ggtitle("Distribui??o da vari?vel padronizada", -->
<!-- subtitle = paste("Valor de Z:", round(Z, 4), "   Prob ?rea sombreada:", round(prob, 4))) -->

<!-- plot_grid(normal, padrao, ncol = 1, align = "hv") -->


<!-- ## QUEST?O 4 -->
<!-- # A -->
<!-- me <- 10 -->
<!-- sdd <- 2 -->
<!-- val1 <- 9 -->
<!-- val2 <- 12 -->
<!-- Z1 <- (val1 - me) / sdd -->
<!-- Z2 <- (val2 - me) / sdd -->

<!-- prob <- pnorm(Z2) - pnorm(Z1) -->

<!-- qnorm(1-pnorm(3.5), me, sdd, lower.tail = F) -->

<!-- normal <- -->
<!-- ggplot(NULL, aes(x = c(3, 17))) + -->
<!-- stat_function(fun = dnorm, -->
<!-- geom = "area", -->
<!-- fill = "steelblue", -->
<!-- xlim = c(val1, val2), -->
<!-- args = list( -->
<!-- mean = me, -->
<!-- sd = sdd -->
<!-- ))+ -->
<!-- stat_function(fun = dnorm, -->
<!-- geom = "line", -->
<!-- args = list( -->
<!-- mean = me, -->
<!-- sd = sdd -->
<!-- ))+ -->
<!-- scale_y_continuous(expand = expand_scale(mult = c(0, .1)))+ -->
<!-- scale_x_continuous(labels = scales::comma)+ -->
<!-- labs(x = "Valor original", y = "Probabilidade")+ -->
<!-- theme_metan(color.background = "transparent") + -->
<!-- ggtitle("Distribui??o da vari?vel original") -->

<!-- padrao <- -->
<!-- ggplot(NULL, aes(x = c(-3.5, 3.5))) + -->
<!-- stat_function(fun = dnorm, -->
<!-- geom = "area", -->
<!-- fill = "steelblue", -->
<!-- xlim = c(Z1, Z2))+ -->
<!-- stat_function(fun = dnorm, -->
<!-- geom = "line")+ -->
<!-- scale_x_continuous(limits = c(-3.5, 3.5), breaks = c(seq(-3, 3, 1)))+ -->
<!-- scale_y_continuous(expand = expand_scale(mult = c(0, .1)))+ -->
<!-- labs(x = "Valor de Z", y = "Probabilidade")+ -->
<!-- theme_metan(color.background = "transparent")+ -->
<!-- ggtitle("Distribui??o da vari?vel padronizada", -->
<!-- subtitle = paste("Z1:", round(Z1, 4), "Z2:", round(Z2, 4), "; Prob ?rea sombreada:", round(prob, 4))) -->

<!-- plot_grid(normal, padrao, ncol = 1, align = "hv") -->






<!-- # B -->
<!-- me <- 10 -->
<!-- sdd <- 2 -->
<!-- val <- 10 -->
<!-- Z <- (val - me) / sdd -->
<!-- qnorm(1-pnorm(3.5), me, sdd, lower.tail = F) -->

<!-- prob <- 1-pnorm(Z) -->

<!-- normal <- -->
<!-- ggplot(NULL, aes(x = c(3, 17))) + -->
<!-- stat_function(fun = dnorm, -->
<!-- geom = "area", -->
<!-- fill = "steelblue", -->
<!-- xlim = c(val, 17), -->
<!-- args = list( -->
<!-- mean = me, -->
<!-- sd = sdd -->
<!-- ))+ -->
<!-- stat_function(fun = dnorm, -->
<!-- geom = "line", -->
<!-- args = list( -->
<!-- mean = me, -->
<!-- sd = sdd -->
<!-- ))+ -->
<!-- scale_y_continuous(expand = expand_scale(mult = c(0, .1)))+ -->
<!-- scale_x_continuous(labels = scales::comma)+ -->
<!-- labs(x = "Valor original", y = "Probabilidade")+ -->
<!-- theme_metan(color.background = "transparent") + -->
<!-- ggtitle("Distribui??o da vari?vel original") -->

<!-- padrao <- -->
<!-- ggplot(NULL, aes(x = c(-3.5, 3.5))) + -->
<!-- stat_function(fun = dnorm, -->
<!-- geom = "area", -->
<!-- fill = "steelblue", -->
<!-- xlim = c(Z, 3,5))+ -->
<!-- stat_function(fun = dnorm, -->
<!-- geom = "line")+ -->
<!-- scale_x_continuous(limits = c(-3.5, 3.5), breaks = c(seq(-3, 3, 1)))+ -->
<!-- scale_y_continuous(expand = expand_scale(mult = c(0, .1)))+ -->
<!-- labs(x = "Valor de Z", y = "Probabilidade")+ -->
<!-- theme_metan(color.background = "transparent")+ -->
<!-- ggtitle("Distribui??o da vari?vel padronizada", -->
<!-- subtitle = paste("Valor de Z:", round(Z, 4), "Prob ?rea sombreada:", round(prob, 4))) -->

<!-- plot_grid(normal, padrao, ncol = 1, align = "hv") -->





<!-- # QUEST?O 5 -->
<!-- # A -->
<!-- me <- 100 -->
<!-- sdd <- 10 -->
<!-- val <- 115 -->
<!-- Z <- (val - me) / sdd -->
<!-- qnorm(1-pnorm(3.5), me, sdd) -->

<!-- prob <- pnorm(Z) -->

<!-- normal <- -->
<!-- ggplot(NULL, aes(x = c(65,  135))) + -->
<!-- stat_function(fun = dnorm, -->
<!-- geom = "area", -->
<!-- fill = "steelblue", -->
<!-- xlim = c(65, val), -->
<!-- args = list( -->
<!-- mean = me, -->
<!-- sd = sdd -->
<!-- ))+ -->
<!-- stat_function(fun = dnorm, -->
<!-- geom = "line", -->
<!-- args = list( -->
<!-- mean = me, -->
<!-- sd = sdd -->
<!-- ))+ -->
<!-- scale_y_continuous(expand = expand_scale(mult = c(0, .1)))+ -->
<!-- scale_x_continuous(labels = scales::comma)+ -->
<!-- labs(x = "Valor original", y = "Probabilidade")+ -->
<!-- theme_metan(color.background = "transparent") + -->
<!-- ggtitle("Distribui??o da vari?vel original") -->

<!-- padrao <- -->
<!-- ggplot(NULL, aes(x = c(-3.5, 3.5))) + -->
<!-- stat_function(fun = dnorm, -->
<!-- geom = "area", -->
<!-- fill = "steelblue", -->
<!-- xlim = c(-3.5, Z))+ -->
<!-- stat_function(fun = dnorm, -->
<!-- geom = "line")+ -->
<!-- scale_x_continuous(limits = c(-3.5, 3.5), breaks = c(seq(-3, 3, 1)))+ -->
<!-- scale_y_continuous(expand = expand_scale(mult = c(0, .1)))+ -->
<!-- labs(x = "Valor de Z", y = "Probabilidade")+ -->
<!-- theme_metan(color.background = "transparent")+ -->
<!-- ggtitle("Distribui??o da vari?vel padronizada", -->
<!-- subtitle = paste("Valor de Z:", round(Z, 4), "Prob ?rea sombreada:", round(prob, 4))) -->

<!-- plot_grid(normal, padrao, ncol = 1, align = "hv") -->








<!-- # b -->
<!-- me <- 100 -->
<!-- sdd <- 10 -->
<!-- val <- 80 -->
<!-- Z <- (val - me) / sdd -->

<!-- prob <- 1 - pnorm(Z) -->

<!-- normal <- -->
<!-- ggplot(NULL, aes(x = c(65,  135))) + -->
<!-- stat_function(fun = dnorm, -->
<!-- geom = "area", -->
<!-- fill = "steelblue", -->
<!-- xlim = c(val, 135), -->
<!-- args = list( -->
<!-- mean = me, -->
<!-- sd = sdd -->
<!-- ))+ -->
<!-- stat_function(fun = dnorm, -->
<!-- geom = "line", -->
<!-- args = list( -->
<!-- mean = me, -->
<!-- sd = sdd -->
<!-- ))+ -->
<!-- scale_y_continuous(expand = expand_scale(mult = c(0, .1)))+ -->
<!-- scale_x_continuous(labels = scales::comma)+ -->
<!-- labs(x = "Valor original", y = "Probabilidade")+ -->
<!-- theme_metan(color.background = "transparent") + -->
<!-- ggtitle("Distribui??o da vari?vel original") -->

<!-- padrao <- -->
<!-- ggplot(NULL, aes(x = c(-3.5, 3.5))) + -->
<!-- stat_function(fun = dnorm, -->
<!-- geom = "area", -->
<!-- fill = "steelblue", -->
<!-- xlim = c(Z, 3.5))+ -->
<!-- stat_function(fun = dnorm, -->
<!-- geom = "line")+ -->
<!-- scale_x_continuous(limits = c(-3.5, 3.5), breaks = c(seq(-3, 3, 1)))+ -->
<!-- scale_y_continuous(expand = expand_scale(mult = c(0, .1)))+ -->
<!-- labs(x = "Valor de Z", y = "Probabilidade")+ -->
<!-- theme_metan(color.background = "transparent")+ -->
<!-- ggtitle("Distribui??o da vari?vel padronizada", -->
<!-- subtitle = paste("Valor de Z:", round(Z, 4), "Prob ?rea sombreada:", round(prob, 4))) -->

<!-- plot_grid(normal, padrao, ncol = 1, align = "hv") -->





<!-- # b -->
<!-- me <- 100 -->
<!-- sdd <- 10 -->
<!-- val <- 100 -->
<!-- Z <- (val - me) / sdd -->

<!-- prob <- 1 - pnorm(Z) -->

<!-- normal <- -->
<!-- ggplot(NULL, aes(x = c(65,  135))) + -->
<!-- stat_function(fun = dnorm, -->
<!-- geom = "area", -->
<!-- fill = "steelblue", -->
<!-- xlim = c(val, 135), -->
<!-- args = list( -->
<!-- mean = me, -->
<!-- sd = sdd -->
<!-- ))+ -->
<!-- stat_function(fun = dnorm, -->
<!-- geom = "line", -->
<!-- args = list( -->
<!-- mean = me, -->
<!-- sd = sdd -->
<!-- ))+ -->
<!-- scale_y_continuous(expand = expand_scale(mult = c(0, .1)))+ -->
<!-- scale_x_continuous(labels = scales::comma)+ -->
<!-- labs(x = "Valor original", y = "Probabilidade")+ -->
<!-- theme_metan(color.background = "transparent") + -->
<!-- ggtitle("Distribui??o da vari?vel original") -->

<!-- padrao <- -->
<!-- ggplot(NULL, aes(x = c(-3.5, 3.5))) + -->
<!-- stat_function(fun = dnorm, -->
<!-- geom = "area", -->
<!-- fill = "steelblue", -->
<!-- xlim = c(Z, 3.5))+ -->
<!-- stat_function(fun = dnorm, -->
<!-- geom = "line")+ -->
<!-- scale_x_continuous(limits = c(-3.5, 3.5), breaks = c(seq(-3, 3, 1)))+ -->
<!-- scale_y_continuous(expand = expand_scale(mult = c(0, .1)))+ -->
<!-- labs(x = "Valor de Z", y = "Probabilidade")+ -->
<!-- theme_metan(color.background = "transparent")+ -->
<!-- ggtitle("Distribui??o da vari?vel padronizada", -->
<!-- subtitle = paste("Valor de Z:", round(Z, 4), "   Prob ?rea sombreada:", round(prob, 4))) -->

<!-- plot_grid(normal, padrao, ncol = 1, align = "hv") -->








<!-- # Q6 -->
<!-- n <- 10000 -->
<!-- me <- 170 -->
<!-- sdd <- 5 -->
<!-- val <- 165 -->
<!-- Z <- (val - me) / sdd -->
<!-- qnorm(1-pnorm(3.5), me, sdd) -->
<!-- qnorm(1-pnorm(3.5), me, sdd, lower.tail = F) -->
<!-- prob <- 1 - pnorm(Z) -->

<!-- normal <- -->
<!-- ggplot(NULL, aes(x = c(152.5,  187.5))) + -->
<!-- stat_function(fun = dnorm, -->
<!-- geom = "area", -->
<!-- fill = "steelblue", -->
<!-- xlim = c(val, 187.5), -->
<!-- args = list( -->
<!-- mean = me, -->
<!-- sd = sdd -->
<!-- ))+ -->
<!-- stat_function(fun = dnorm, -->
<!-- geom = "line", -->
<!-- args = list( -->
<!-- mean = me, -->
<!-- sd = sdd -->
<!-- ))+ -->
<!-- scale_y_continuous(expand = expand_scale(mult = c(0, .1)))+ -->
<!-- scale_x_continuous(labels = scales::comma)+ -->
<!-- labs(x = "Valor original", y = "Probabilidade")+ -->
<!-- theme_metan(color.background = "transparent") + -->
<!-- ggtitle("Distribui??o da vari?vel original") -->

<!-- padrao <- -->
<!-- ggplot(NULL, aes(x = c(-3.5, 3.5))) + -->
<!-- stat_function(fun = dnorm, -->
<!-- geom = "area", -->
<!-- fill = "steelblue", -->
<!-- xlim = c(Z, 3.5))+ -->
<!-- stat_function(fun = dnorm, -->
<!-- geom = "line")+ -->
<!-- scale_x_continuous(limits = c(-3.5, 3.5), breaks = c(seq(-3, 3, 1)))+ -->
<!-- scale_y_continuous(expand = expand_scale(mult = c(0, .1)))+ -->
<!-- labs(x = "Valor de Z", y = "Probabilidade")+ -->
<!-- theme_metan(color.background = "transparent")+ -->
<!-- ggtitle("Distribui??o da vari?vel padronizada", -->
<!-- subtitle = paste("Valor de Z:", round(Z, 4), "   Prob ?rea sombreada:", round(prob, 4))) -->

<!-- plot_grid(normal, padrao, ncol = 1, align = "hv") -->












<!-- # Q7 -->
<!-- me <- 50 -->
<!-- sdd <- 5 -->
<!-- val <- 45 -->
<!-- Z <- (val - me) / sdd -->
<!-- qnorm(1-pnorm(3.5), me, sdd) -->
<!-- qnorm(1-pnorm(3.5), me, sdd, lower.tail = F) -->
<!-- prob <- pnorm(Z) -->

<!-- normal <- -->
<!-- ggplot(NULL, aes(x = c(32.5,  67.5))) + -->
<!-- stat_function(fun = dnorm, -->
<!-- geom = "area", -->
<!-- fill = "steelblue", -->
<!-- xlim = c(32.5, val), -->
<!-- args = list( -->
<!-- mean = me, -->
<!-- sd = sdd -->
<!-- ))+ -->
<!-- stat_function(fun = dnorm, -->
<!-- geom = "line", -->
<!-- args = list( -->
<!-- mean = me, -->
<!-- sd = sdd -->
<!-- ))+ -->
<!-- scale_y_continuous(expand = expand_scale(mult = c(0, .1)))+ -->
<!-- scale_x_continuous(labels = scales::comma)+ -->
<!-- labs(x = "Valor original", y = "Probabilidade")+ -->
<!-- theme_metan(color.background = "transparent") + -->
<!-- ggtitle("Distribui??o da vari?vel original") -->

<!-- padrao <- -->
<!-- ggplot(NULL, aes(x = c(-3.5, 3.5))) + -->
<!-- stat_function(fun = dnorm, -->
<!-- geom = "area", -->
<!-- fill = "steelblue", -->
<!-- xlim = c(-3.5, Z))+ -->
<!-- stat_function(fun = dnorm, -->
<!-- geom = "line")+ -->
<!-- scale_x_continuous(limits = c(-3.5, 3.5), breaks = c(seq(-3, 3, 1)))+ -->
<!-- scale_y_continuous(expand = expand_scale(mult = c(0, .1)))+ -->
<!-- labs(x = "Valor de Z", y = "Probabilidade")+ -->
<!-- theme_metan(color.background = "transparent")+ -->
<!-- ggtitle("Distribui??o da vari?vel padronizada", -->
<!-- subtitle = paste("Valor de Z:", round(Z, 4), "   Prob ?rea sombreada:", round(prob, 4))) -->

<!-- plot_grid(normal, padrao, ncol = 1, align = "hv") -->










<!-- # Q8 -->
<!-- me <- 2.95 -->
<!-- sdd <- 0.2 -->
<!-- val <- 3.2 -->
<!-- Z <- (val - me) / sdd -->
<!-- qnorm(1-pnorm(3.5), me, sdd) -->
<!-- qnorm(1-pnorm(3.5), me, sdd, lower.tail = F) -->
<!-- prob <- 1 - pnorm(Z) -->

<!-- normal <- -->
<!-- ggplot(NULL, aes(x = c(2.25,  3.65))) + -->
<!-- stat_function(fun = dnorm, -->
<!-- geom = "area", -->
<!-- fill = "steelblue", -->
<!-- xlim = c(val, 3.65), -->
<!-- args = list( -->
<!-- mean = me, -->
<!-- sd = sdd -->
<!-- ))+ -->
<!-- stat_function(fun = dnorm, -->
<!-- geom = "line", -->
<!-- args = list( -->
<!-- mean = me, -->
<!-- sd = sdd -->
<!-- ))+ -->
<!-- scale_y_continuous(expand = expand_scale(mult = c(0, .1)))+ -->
<!-- scale_x_continuous(labels = scales::comma)+ -->
<!-- labs(x = "Valor original", y = "Probabilidade")+ -->
<!-- theme_metan(color.background = "transparent") + -->
<!-- ggtitle("Distribui??o da vari?vel original") -->

<!-- padrao <- -->
<!-- ggplot(NULL, aes(x = c(-3.5, 3.5))) + -->
<!-- stat_function(fun = dnorm, -->
<!-- geom = "area", -->
<!-- fill = "steelblue", -->
<!-- xlim = c(Z, 3.5))+ -->
<!-- stat_function(fun = dnorm, -->
<!-- geom = "line")+ -->
<!-- scale_x_continuous(limits = c(-3.5, 3.5), breaks = c(seq(-3, 3, 1)))+ -->
<!-- scale_y_continuous(expand = expand_scale(mult = c(0, .1)))+ -->
<!-- labs(x = "Valor de Z", y = "Probabilidade")+ -->
<!-- theme_metan(color.background = "transparent")+ -->
<!-- ggtitle("Distribui??o da vari?vel padronizada", -->
<!-- subtitle = paste("Valor de Z:", round(Z, 4), "   Prob ?rea sombreada:", round(prob, 4))) -->

<!-- plot_grid(normal, padrao, ncol = 1, align = "hv") -->










<!-- # Q9 -->
<!-- me <- 3.5 -->
<!-- sdd <- 0.25 -->
<!-- val <- 3.7 -->
<!-- Z <- (val - me) / sdd -->
<!-- qnorm(1-pnorm(3.5), me, sdd) -->
<!-- qnorm(1-pnorm(3.5), me, sdd, lower.tail = F) -->
<!-- prob <- 1 - pnorm(Z) -->

<!-- normal <- -->
<!-- ggplot(NULL, aes(x = c(2.625,  4.375))) + -->
<!-- stat_function(fun = dnorm, -->
<!-- geom = "area", -->
<!-- fill = "steelblue", -->
<!-- xlim = c(val, 4.375), -->
<!-- args = list( -->
<!-- mean = me, -->
<!-- sd = sdd -->
<!-- ))+ -->
<!-- stat_function(fun = dnorm, -->
<!-- geom = "area", -->
<!-- fill = "red", -->
<!-- xlim = c(2.625, val), -->
<!-- args = list( -->
<!-- mean = me, -->
<!-- sd = sdd -->
<!-- ))+ -->
<!-- stat_function(fun = dnorm, -->
<!-- geom = "line", -->
<!-- args = list( -->
<!-- mean = me, -->
<!-- sd = sdd -->
<!-- ))+ -->
<!-- scale_y_continuous(expand = expand_scale(mult = c(0, .1)))+ -->
<!-- scale_x_continuous(labels = scales::comma)+ -->
<!-- labs(x = "Valor original", y = "Probabilidade")+ -->
<!-- theme_metan(color.background = "transparent") + -->
<!-- ggtitle("Distribui??o da vari?vel original") -->

<!-- padrao <- -->
<!-- ggplot(NULL, aes(x = c(-3.5, 3.5))) + -->
<!-- stat_function(fun = dnorm, -->
<!-- geom = "area", -->
<!-- fill = "steelblue", -->
<!-- xlim = c(Z, 3.5))+ -->
<!-- stat_function(fun = dnorm, -->
<!-- geom = "area", -->
<!-- fill = "red", -->
<!-- xlim = c(-3.5, Z))+ -->
<!-- stat_function(fun = dnorm, -->
<!-- geom = "line")+ -->
<!-- scale_x_continuous(limits = c(-3.5, 3.5), breaks = c(seq(-3, 3, 1)))+ -->
<!-- scale_y_continuous(expand = expand_scale(mult = c(0, .1)))+ -->
<!-- labs(x = "Valor de Z", y = "Probabilidade")+ -->
<!-- theme_metan(color.background = "transparent")+ -->
<!-- ggtitle("Distribui??o da vari?vel padronizada", -->
<!-- subtitle = paste("Valor de Z:", round(Z, 4), "   Prob ?rea sombreada:", round(prob, 4))) -->

<!-- plot_grid(normal, padrao, ncol = 1, align = "hv") -->











<!-- # Q10 -->
<!-- me <- 430 -->
<!-- sdd <- 65 -->
<!-- val1 <- 320 -->
<!-- val2 <- 520 -->
<!-- Z1 <- (val1 - me) / sdd -->
<!-- Z2 <- (val2 - me) / sdd -->
<!-- qnorm(1-pnorm(3.5), me, sdd) -->
<!-- qnorm(1-pnorm(3.5), me, sdd, lower.tail = F) -->
<!-- prob1 <- pnorm(Z1) -->
<!-- prob2 <- pnorm(Z2) - prob1 -->
<!-- prob3 <- 1 - sum(prob1, prob2) -->
<!-- sum(prob1, prob2, prob3) -->

<!-- normal <- -->
<!-- ggplot(NULL, aes(x = c(202.5,  657.5))) + -->
<!-- stat_function(fun = dnorm, -->
<!-- geom = "area", -->
<!-- fill = "steelblue", -->
<!-- xlim = c(202.5, val1), -->
<!-- args = list( -->
<!-- mean = me, -->
<!-- sd = sdd -->
<!-- ))+ -->
<!-- stat_function(fun = dnorm, -->
<!-- geom = "area", -->
<!-- fill = "green", -->
<!-- xlim = c(val1, val2), -->
<!-- args = list( -->
<!-- mean = me, -->
<!-- sd = sdd -->
<!-- ))+ -->
<!-- stat_function(fun = dnorm, -->
<!-- geom = "area", -->
<!-- fill = "red", -->
<!-- xlim = c(val2, 657.5), -->
<!-- args = list( -->
<!-- mean = me, -->
<!-- sd = sdd -->
<!-- ))+ -->
<!-- stat_function(fun = dnorm, -->
<!-- geom = "line", -->
<!-- args = list( -->
<!-- mean = me, -->
<!-- sd = sdd -->
<!-- ))+ -->
<!-- scale_y_continuous(expand = expand_scale(mult = c(0, .1)))+ -->
<!-- scale_x_continuous(labels = scales::comma)+ -->
<!-- labs(x = "Valor original", y = "Probabilidade")+ -->
<!-- theme_metan(color.background = "transparent") + -->
<!-- ggtitle("Distribuição da variável ") -->

<!-- # padrao <- -->
<!-- ggplot(NULL, aes(x = c(-3.5, 3.5))) + -->
<!-- stat_function(fun = dnorm, -->
<!-- geom = "area", -->
<!-- fill = "steelblue", -->
<!-- xlim = c(-3.5, Z1))+ -->
<!-- stat_function(fun = dnorm, -->
<!-- geom = "area", -->
<!-- fill = "green", -->
<!-- xlim = c(Z1, Z2))+ -->
<!-- stat_function(fun = dnorm, -->
<!-- geom = "area", -->
<!-- fill = "red", -->
<!-- xlim = c(Z2, 3.5))+ -->
<!-- stat_function(fun = dnorm, -->
<!-- geom = "line")+ -->
<!-- scale_x_continuous(limits = c(-3.5, 3.5), breaks = c(seq(-3, 3, 1)))+ -->
<!-- scale_y_continuous(expand = expand_scale(mult = c(0, .1)))+ -->
<!-- labs(x = "Valor de Z", y = "Probabilidade")+ -->
<!-- theme_metan(color.background = "transparent")+ -->
<!-- annotate("text", x = -3, y = 0.11, label = "Abatedouro A") + -->
<!-- annotate("segment", -->
<!-- x = -3, -->
<!-- y = 0.1, -->
<!-- xend = -2.2, -->
<!-- yend = 0.04, -->
<!-- arrow=arrow()) + -->
<!-- annotate("text", x = -3, y = 0.31, label = "Abatedouro B") + -->
<!-- annotate("segment", -->
<!-- x = -3, -->
<!-- y = 0.3, -->
<!-- xend = -1.2, -->
<!-- yend = 0.2, -->
<!-- arrow=arrow()) + -->
<!-- annotate("text", x = 3, y = 0.11, label = "Abatedouro C") + -->
<!-- annotate("segment", -->
<!-- x = 3, -->
<!-- y = 0.1, -->
<!-- xend = 2.2, -->
<!-- yend = 0.04, -->
<!-- arrow=arrow()) -->



<!-- ggplot(data_error, aes(x, y)) + -->
<!-- geom_segment(aes(x = x, y = y, xend = x, yend = fitted(mod))) + -->
<!-- geom_point(color = "red") + -->
<!-- geom_smooth(se = FALSE, method = "lm")+ -->
<!-- annotate("text", x = 4, y = 16, label = "y = 5.04 + 0.63 x")+ -->
<!-- theme_metan() -->


<!-- values = c(2167, 1695, 1981, 2250, 2049) -->
<!-- me <- 50 -->
<!-- sdd <- 3.5 -->
<!-- val <- 45 -->
<!-- Z <- (val - me) / sdd -->
<!-- 1- pnorm(Z) -->
