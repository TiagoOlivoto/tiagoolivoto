---
title: Distribuição Normal
linktitle: "4. Distribuição Normal"
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
editor_options: 
  markdown: 
    wrap: 72
---

# Introdução

A distribuição normal é um modelo bastante útil na estatística, pois sua
função densidade de probabilidade (FDP) está associada ao fato de que
aproxima de forma bastante satisfatória as curvas de frequências
observadas quando se mensura diversas variáveis biológicas (ex., altura,
massa, comprimento, etc). Como exemplo, vamos ver a distribuição da
massa de mil grãos de híbridos de milho, disponíveis no conjunto de
dados `data_ge` do pacote `metan`. Neste exemplo, a linha vermelha
representa a distribuição normal.


```r
library(tidyverse)
library(metan)

# tema personalizado
my_theme <- 
  theme_gray(base_size = 14) +
  theme(panel.grid.minor = element_blank())
# define o tema para todos os gráficos
theme_set(my_theme)


ggplot(data_ge2, aes(TKW)) + 
  geom_histogram(aes(y = ..density..),
                 bins = 15) +
  stat_function(fun = dnorm,
                geom = "line",
                color = "red",
                size = 1,
                args = list(
                  mean = mean(data_ge2$TKW),
                  sd = sd(data_ge2$TKW)
                ))
```

<img src="/classes/experimentacao/04_dist_cont_files/figure-html/unnamed-chunk-1-1.png" width="672" />

Vamos ver a distribuição dos valores do comprimento da folha de café, mensurado na primeira aula de bioestatística.


```r
library(rio)
# link dos dados
link <- "https://docs.google.com/spreadsheets/d/1JMrkppvv1BdGKVCekzZPsPYCKcgUWjxpuDlWqejc22s/edit#gid=463165208"

# função para importar os dados
df <-  
  import(link) |> 
  filter(Tipo == "Folha")

ggplot(df, aes(Comprimento)) + 
  geom_histogram(aes(y = ..density..),
                 bins = 10) +
  stat_function(fun = dnorm,
                geom = "line",
                color = "red",
                size = 1,
                args = list(
                  mean = mean(df$Comprimento),
                  sd = sd(df$Comprimento)
                ))
```

<img src="/classes/experimentacao/04_dist_cont_files/figure-html/unnamed-chunk-2-1.png" width="672" />


## Parâmetros da distribuição

A distribuição normal possui dois parâmetros:

-   \$\mu\$, sendo a média;
-   \$\sigma\$, sendo o desvio padrão.

Estes parâmetros definem a posição e a dispersão do conjunto de dados.
Assim, se *X* se distribui de forma normal e contínua (variável
contínua) de \$-\infty<x<+\infty\$, a área total sob a curva do modelo é 1.


O modelo da função normal possui a seguinte Função Densidade de
Probabilidade:

$$
{f}(x) = \frac{1}{{\sqrt {2\pi {\sigma ^2}} }}{e^{ - \frac{{{{(x - \mu )}^2}}}{{2{\sigma ^2}}}}}-\infty< x < \infty
$$

No exemplo abaixo, é apresentado a distribuição de uma variável aleatória contínua (*X*) com \$\mu = 20\$, e \$\sigma = 2\$. Assim, dizemos que \$X \sim N(\mu,\sigma)\$, ou seja, segue uma distribuição normal com média \$\mu = 20\$ e desvio padrão \$\sigma = 2\$.


```r
ggplot() +
  stat_function(fun = dnorm,
                geom = "line",
                color = "red",
                size = 1,
                xlim = c(10, 30),
                args = list(
                  mean = 20,
                  sd = 2
                )) +
  labs(y = bquote(f(x)~~"densidades"),
       x = "x")
```

<img src="/classes/experimentacao/04_dist_cont_files/figure-html/unnamed-chunk-3-1.png" width="672" />

Abaixo, pode-se observar a distribuição de variáveis aleatórias contínuas com diferentes valores de parâmetros. No gráfico à esquerda, fixa-se a média e varia-se o desvio padrão. No exemplo central, fixa-se o desvio padrão e varia-se a média. No exemplo à direita, varia-se os dois parâmetros.


```r
get_norm <- function(mu, sd, col = "blue"){
  stat_function(fun=dnorm,
                geom = "line",
                size = 1,
                col=col,
                args = c(mean=mu,sd=sd))
}

p1 <- 
  ggplot(data.frame(x=c(0,30)),aes(x=x)) +
  get_norm(10, 1) +
  get_norm(10, 2, "green") +
  get_norm(10, 4, "red")

p2 <- 
  ggplot(data.frame(x=c(0,30)),aes(x=x)) +
  get_norm(6, 2) +
  get_norm(10, 2, "green") +
  get_norm(14, 2, "red")

p3 <- 
  ggplot(data.frame(x=c(0,30)),aes(x=x)) +
  get_norm(6, 1) +
  get_norm(10, 2, "green") +
  get_norm(14, 4, "red")

arrange_ggplot(p1, p2, p3)
```

<img src="/classes/experimentacao/04_dist_cont_files/figure-html/unnamed-chunk-4-1.png" width="1152" />

## Calculando as probabilidades

A probabilidade estatística de um valor estar no intervalo
\$\[x_0,x_1\]\$ é dada pela soma da área abaixo da curva contida no
intervalo entre estes dois pontos. Tal área pode ser obtida conforme
segue:

$$
P\left(x_{1}\le X \le  x_{2}\right)=\int_{x_{1}}^{x_{2}} \frac{1}{\sigma \sqrt{2 \pi}} e^{-\frac{(x-\mu)^{2}}{2 \sigma^{2}}} d x
$$

Considere como exemplo, a altura de planta em uma lavoura de milho que segue uma distribuição normal com média 2 e desvio padrão de 0,2. Pergunda-se: qual é a probabilidade de, ao entrar aleatoriamente nesta lavoura ser encontrada uma planta que mede de 1,75 m a 2 m?

> SOLUÇÃO: Para resolver este problema, precisamos encontrar a área sombreada na figura abaixo.


```r
me <- 2
sdd <- 0.2

args <- 
  list(mean = me,
       sd = sdd)

ggplot() +
  scale_x_continuous(limits = c(1, 3),
                     breaks = seq(1, 3, by = 0.25)) +
  stat_function(fun = dnorm,
                geom = "area",
                fill = "steelblue",
                xlim = c(1.75, 2),
                args = args)+
  stat_function(fun = dnorm,
                geom = "line",
                size = 1,
                args = args)+
  scale_y_continuous(expand = expansion(mult = c(0, .1)))+
  labs(x = "Altura da planta (m)",
       y = "Probabilidade")
```

<img src="/classes/experimentacao/04_dist_cont_files/figure-html/unnamed-chunk-5-1.png" width="672" />

Para calcular esta probabilidade, precisamos encontrar a probabilidade associada a cada quantil, utilizando a função `pnorm()`. Esta função retorna por padrão a probabilidade \$P\[X \le x\]\$. Assim, ao se diminuir a probabilidade de encontrar uma planta com 2 m da probabilidade de encontrar uma planta com até 1,75 m, resolvemos o problema.


```r
# P[X<= 2.0]
(p2 <- pnorm(q = 2, mean = 2, sd = 0.2))
```

```
## [1] 0.5
```

```r
# P[X<= 1.75]
(p175 <- pnorm(q = 1.75, mean = 2, sd = 0.2))
```

```
## [1] 0.1056498
```

```r
p2 - p175
```

```
## [1] 0.3943502
```

## Aproximação da integral da distribuição Normal

O cálculo da integral da distribuição Normal pode ser aproximado pelo método geométrico por soma de retângulos. Este método possibilita calcular a integral definida em dois pontos (ex., \$\[x_0\]\$ e \$\[x_1\]\$), considerando uma variável com distribuição normal. Assim, a soma das áreas dos retângulos sob a curva da distribuição normal resultarão na probabilidade estatística de um valor estar no intervalo \$\[x_0,x_1\]\$.


```r
##### N = 20
n <- 20
p <- 0.5
x <- seq(0, n, 1)
px <- dbinom(x, n, p)

x <- seq(0, n, 1)
px <- dbinom(x, n, p)
df2 <- data.frame(x, px)


# Aproximação
media <- n*p # media
desvp <- sqrt(n*p*(1-p)) # desvio padrao

ggplot(df2, aes(x = x, y = px)) + 
  geom_bar(stat = "identity",
           width = 1, 
           color = "black",
           size = 0.01,
           fill = "salmon") + 
  scale_y_continuous(expand = c(0.01, 0)) + 
  xlab("x") + 
  ylab("px e fx") +
  stat_function(aes(x=x),
                fun=dnorm,
                geom = "line",
                size=1,
                col="green",
                args = c(mean = media, sd = desvp))
```

<img src="/classes/experimentacao/04_dist_cont_files/figure-html/unnamed-chunk-7-1.png" width="672" />

No método geométrico, a função *f(x)* corresponderá a altura de cada
retângulo. A base do retângulo (\$\Delta\$), será dada por:

$$
\Delta=\frac{x_1-x_0}{n}
$$ onde *n* representa o número de retângulos no intervalo. Ao
multiplicar a altura do retângulo pela sua base, temos a área de cada
retângulo. Ao somarmos todas as *n* áreas, teremos a aproximação da
probabilidade. Logo, é fácil notar que quanto maior o valor de *n*
melhor será a aproximação do valor calculado pela integral.

A função abaixo pode ser utilizada para aproximar a integral da função
da distribuição Normal. A função `mnorm` é a Função Densidade de
Probabilidade e é aplicada dentro da função `int_norm` para encontrar a
altura de cada retângulo. Por padrão, 50000 retângulos são utilizados.


```r
# função normal, f(x)
mnorm <- function(x, m, dp){
  (1/(dp * sqrt(2 * pi) )) * exp(-((x - m)^2)/(2 * dp ^ 2))
}
# integral definida em dois pontos
# (método geométrico por soma de retângulos)
int_norm <- function(x0, x1, me, dp, n = 50000){
  # cria uma sequência com n retangulos de x0 a x1
  x <- seq(x0, x1, length.out = n)
  # acha a base da área
  barea <- (x1 - x0)/n
  # encontra a altura
  altrect <- mnorm(x, me, dp)
  # multiplica a altura pela base e soma
  sum(altrect * barea)
}
```

Abaixo, a função `int_norm()` é usada para aproximar a probabilidade
obtida anteriormente com a função `pnorm()`.


```r
x0 <- 1.75 # x_0
x1 <- 2    # x_1
m <- 2     # média
dp <- 0.2  # desvio padrão

# método geométrico
(aprox <- int_norm(x0, x1, m, dp))
```

```
## [1] 0.3943496
```

```r
(fun_pnorm <- p2 - p175)
```

```
## [1] 0.3943502
```

```r
fun_pnorm - aprox
```

```
## [1] 6.171243e-07
```

Nota-se que com 50000 retângulos, a aproximação da probabilidade pelo
método geométrico apresentou diferença somente na quinta casa após a
vírgula, demonstrando uma aproximação satisfatória. Vejamos o impacto do
número de retângulos nesta aproximação. Para isso, vamos criar um
gráfico para mostrar como esta aproximação vai melhorando com o aumento
no número de retângulos. No exemplo, é simulado de 1 até 200 (apenas
para fins didáticos). A linha vermelha horizontal representa a
probabilidade compudata com a função `pnorm()`.


```r
x <- NULL
for (i in 1:200) {
  x[i] <- int_norm(x0, x1, m, dp, i)
}
df <- 
  data.frame(x = 1:200,
             prob = x)

ggplot(df, aes(x, prob)) +
  geom_line() +
  geom_hline(yintercept = p2 - p175,
             color = "red") +
  labs(x = "Números de retângulos",
       y = "Probabilidade aproximada")
```

<img src="/classes/experimentacao/04_dist_cont_files/figure-html/unnamed-chunk-10-1.png" width="672" />

## Distribuição Normal Padrão

A distribuição Normal Padrão é nada mais que uma distribuição normal com
média e desvio padrão fixos (\$\mu = 0; \sigma = 1\$). Uma vez que estes
parâmetros são fixos, sempre que desejamos calcular uma probabilidade
pode-se recorrer a uma tabela, onde valores de probabilidade já foram
previamente calculados para essa única distribuição.

Para isso, precisamos definir uma nova variável aleatória *Z*, chamada
de variável aleatória normal padronizada, dada pela função linear *Z*.

$$
Z = \frac{X- \mu}{\sigma}
$$ Onde *X* é uma variável aleatória com distribuição normal com média
`\(\mu\)` e `\(\sigma > 0\)`.

Como exemplo, vamos simular uma variável aleatória (X) com \$n = 300\$ tal que
`\(X \sim N(\mu = 20; \sigma = 3)\)`.


```r
set.seed(1) # assegura a reprodutibilidade
X <- round(rnorm(n = 300 , mean = 20, sd = 3), digits = 1)
hist(X)
```

<img src="/classes/experimentacao/04_dist_cont_files/figure-html/unnamed-chunk-11-1.png" width="672" />

```r
(mu <- mean(X))
```

```
## [1] 20.102
```

```r
(sdx <- sd(X))
```

```
## [1] 2.892973
```

Podemos criar uma função para criar a nova variável *Z* com base em um vetor numérico da variável original. Neste caso, a chamei de `get_z()`.


```r
get_z <- function(x){
  (x - mean(x)) / sd(x)
}
# obtém o valor Z de X
Z <- get_z(X)
hist(Z)
```

<img src="/classes/experimentacao/04_dist_cont_files/figure-html/unnamed-chunk-12-1.png" width="672" />

Os valores de *Z* podem ser interpretados como o número de desvios padrão afastados da média, em uma distribuição normal padrão.


```r
ggplot() +
  stat_function(fun = dnorm,
                geom = "area",
                fill = "cyan",
                xlim = c(-3, 3),
                alpha = 1) +
  stat_function(fun = dnorm,
                geom = "area",
                fill = "green",
                xlim = c(-2, 2),
                alpha = 1) +
  stat_function(fun = dnorm,
                geom = "area",
                fill = "salmon",
                xlim = c(-1, 1),
                alpha = 1) +
  
  stat_function(fun = dnorm,
                geom = "line")+
  scale_x_continuous(limits = c(-4, 4), breaks = c(seq(-5, 5, 1))) +
  scale_y_continuous(expand = expansion(mult = c(0, .5)),
                     breaks = NULL) +
  labs(x = "Z",
       y = "")+
  theme_gray(base_size = 16) +
  theme(panel.grid = element_blank(),
        panel.background = element_rect(fill = NA))
```

<img src="/classes/experimentacao/04_dist_cont_files/figure-html/unnamed-chunk-13-1.png" width="672" />

Desta forma, uma tabela contendo a área sobre a curva desta distribuição
de *Z* pode ser utilizada.

[![](/classes/experimentacao/04_dist_cont_files/normalp.png)](https://github.com/TiagoOlivoto/tiagoolivoto/blob/master/static/classes/experimentacao/tabela_normal_padr%C3%A3o.pdf){target="\_blank"}

A primeira decimal da variável Z encontra-se na linha e a segunda decimal na coluna. Como exemplo, a probabilidade de Z ser menor ou igual a -1 é de 0,15866.


```r
# valor exato
pnorm(-1)
```

```
## [1] 0.1586553
```



> Retomando o exemplo:
Considere como exemplo, a altura de planta em uma lavoura de milho. Esta
variável segue uma distribuição normal com média 2 e desvio padrão de
0,2. Pergunda-se: qual é a probabilidade de, ao entrar aleatoriamente
nesta lavoura ser encontrada uma planta que mede de 1,75 m a 2 m?

Neste caso, utilizando a normal padrão, a resolução é dada por:


```r
me <- 2 # média 
sdd <- 0.2 # desvio padrão
val1 <- 1.75 # primeiro quantil do intervalo
val2 <- 2 # segundo quantil do intervalo
(Z1 <- (val1 - me) / sdd) # Z associado ao primeiro quantil
```

```
## [1] -1.25
```

```r
(Z2 <- (val2 - me) / sdd) # Z associado ao segundo quantil
```

```
## [1] 0
```

```r
(prob1 <- pnorm(Z1)) # P(Z <= -1,25)
```

```
## [1] 0.1056498
```

```r
(prob2 <- pnorm(Z2)) # P(z <= 0)
```

```
## [1] 0.5
```

```r
prob2 - prob1 # P(-1,25 <= Z <= 0)
```

```
## [1] 0.3943502
```


No exemplo, a área da parte sombreada (probabilidade) é de 0,39455.

```r
normal <-
  ggplot() +
  scale_x_continuous(limits = c(1.2, 2.8)) +
  stat_function(fun = dnorm,
                geom = "area",
                fill = "steelblue",
                xlim = c(1.75, 2),
                args = list(
                  mean = me,
                  sd = sdd
                ))+
  stat_function(fun = dnorm,
                geom = "line",
                args = list(
                  mean = me,
                  sd = sdd
                )) +
  scale_y_continuous(expand = expansion(mult = c(0, .1)))+
  labs(x = "Valor original (altura em m)", y = "Probabilidade")

padrao <-
  ggplot() +
  scale_x_continuous(limits = c(-4, 4)) +
  stat_function(fun = dnorm,
                geom = "area",
                fill = "steelblue",
                xlim = c(Z1, Z2))+
  stat_function(fun = dnorm,
                geom = "line")+
  scale_y_continuous(expand = expansion(mult = c(0, .1)))+
  labs(x = "Valor de Z", y = "Probabilidade")

arrange_ggplot(normal, padrao, ncol = 1)
```

<img src="/classes/experimentacao/04_dist_cont_files/figure-html/unnamed-chunk-16-1.png" width="672" />



<!-- ## Questões -->

<!-- ### Questão 1 -->

<!-- 1.  A série histórica das vendas de uma determinada fórmula de adubo seguem uma distribuição normal com média 25.000 t e desvio padrão de 2.600 t. Se a empresa fabricante decidir fabricar 30000 toneladas deste adubo para suprir a demanda da safra atual, qual é a probabilidade de que ela não possa atender todas as vendas por estar   com a produção esgotada? -->

<!-- (R = 0,0272) SOLUÇÃO: encontrar a -->
<!--     probabilidade de vender mais que 30000 t -->

<!-- ```{r fig.width=10, fig.height=8} -->

<!-- me <- 25000 -->
<!-- sdd <- 2600 -->
<!-- val <- 30000 -->
<!-- Z <- (val - me) / sdd -->
<!-- prob <- 1 - pnorm(Z) -->
<!-- qnorm(1-pnorm(3.5), me, sdd) -->
<!-- qnorm(1-pnorm(3.5), me, sdd, lower.tail = F) -->

<!-- normal <- -->
<!--   ggplot() + -->
<!--   xlim(c(15900, 34100)) + -->
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

<!-- ### Questão 2 -->

<!-- 2. O gerente da empresa que João trabalha resolveu premiar seus     vendedores mais eficientes (5%) na venda de insumos. Um levantamento     das vendas individuais anuais mostrou que a venda de adubo segue uma     distribuição normal com média 240.000 t. e desvio padrão 30.000 t.     Qual o volume de vendas mínimo que João deve realizar para ser premiado? -->

<!-- > (R = 289.346)  -->
<!-- RESOLUÇÃO: encontrar o valor de Z associado aos 5% que mais vendem Z = 1.6448 Valor da variável original associado ao Z = 289.346 -->

<!-- ```{r fig.width=10, fig.height=8} -->
<!-- # quantil associado aos 5% que mais vendem  -->
<!-- Z <- qnorm(0.95) -->

<!-- me <- 240000 -->
<!-- sdd <- 30000 -->
<!-- # volume mínimo de vendas -->
<!-- vendas <- round(Z * sdd + me) -->


<!-- original <- -->
<!--   ggplot() + -->
<!--   xlim(c(135000, 345000)) + -->
<!--   stat_function(fun = dnorm, -->
<!--                 geom = "area", -->
<!--                 fill = "steelblue", -->
<!--                 xlim = c(vendas, 360000), -->
<!--                 args = list( -->
<!--                   mean = me, -->
<!--                   sd = sdd -->
<!--                 ))+ -->
<!--   stat_function(fun = dnorm, -->
<!--                 geom = "line", -->
<!--                 args = list( -->
<!--                   mean = me, -->
<!--                   sd = sdd -->
<!--                 ))+ -->
<!--   scale_y_continuous(expand = expansion(mult = c(0, .1)))+ -->
<!--   labs(x = "Valor original", y = "Probabilidade")+ -->
<!--   ggtitle("Distribuição da variável original") -->

<!-- padrao <- -->
<!--   ggplot() + -->
<!--   xlim(c(-3.5, 3.5)) + -->
<!--   stat_function(fun = dnorm, -->
<!--                 geom = "area", -->
<!--                 fill = "steelblue", -->
<!--                 xlim = c(Z, 3.5))+ -->
<!--   stat_function(fun = dnorm, -->
<!--                 geom = "line")+ -->
<!--   scale_x_continuous(limits = c(-3.5, 3.5), breaks = c(seq(-3, 3, 1)))+ -->
<!--   scale_y_continuous(expand = expansion(mult = c(0, .1)))+ -->
<!--   labs(x = "Valor de Z", y = "Probabilidade")+ -->
<!--   ggtitle("Distribuição de Z", -->
<!--           subtitle = paste("Valor de Z:", round(Z, 4), "; Prob área sombreada:", round(prob, 4))) -->

<!-- arrange_ggplot(original, padrao, ncol = 1) -->
<!-- ``` -->


<!-- ### Questão 3 -->
<!-- Uma variável aleatória X segue uma distribuição normal com média 100 e desvio padrão 10. Calcule a probabilidade de x estar entre 90 e 110. -->


<!-- ```{r fig.width=10, fig.height=8} -->
<!-- me <- 100 -->
<!-- sdd <- 10 -->
<!-- val1 <- 90 -->
<!-- val2 <- 110 -->
<!-- Z1 <- (val1 - me) / sdd -->
<!-- Z2 <- (val2 - me) / sdd -->

<!-- # probabilidade dos valores estarem a 1 desvio padrão para mais ou menos -->
<!-- pnorm(Z2) - pnorm(Z1) -->

<!-- args <- list( -->
<!--   mean = 100, -->
<!--   sd = 10 -->
<!-- ) -->

<!-- normal <- -->
<!--   ggplot() + -->
<!--   scale_x_continuous(limits = c(60, 140), -->
<!--                      breaks = seq(60, 140, 10)) + -->
<!--   stat_function(fun = dnorm, -->
<!--                 geom = "area", -->
<!--                 fill = "steelblue", -->
<!--                 xlim = c(90, 110), -->
<!--                 args = args) + -->
<!--   stat_function(fun = dnorm, -->
<!--                 geom = "line", -->
<!--                 args = args) + -->
<!--   scale_y_continuous(expand = expansion(mult = c(0, .1)))+ -->
<!--   labs(x = "Valor original", y = "Probabilidade")+ -->
<!--   ggtitle("Distribuição da variável original") -->


<!-- padrao <- -->
<!--   ggplot() + -->
<!--   stat_function(fun = dnorm, -->
<!--                 geom = "area", -->
<!--                 fill = "steelblue", -->
<!--                 xlim = c(Z1, Z2)) + -->
<!--   stat_function(fun = dnorm, -->
<!--                 geom = "line")+ -->
<!--   scale_x_continuous(limits = c(-4, 4), breaks = c(seq(-4, 4, 1)))+ -->
<!--   scale_y_continuous(expand = expansion(mult = c(0, .1)))+ -->
<!--   labs(x = "Valor de Z", -->
<!--        y = "Probabilidade")+ -->
<!--   ggtitle("Distribuição da variável padronizada") -->

<!-- arrange_ggplot(normal, padrao, ncol = 1) -->
<!-- ``` -->



<!-- ### Questão 4 -->

<!-- Se X\~N(10, 2), calcule (9 \< X \< 12) -->

<!-- > R: 0,53 RESOLUÇÃO: calcular a probabilidade x ser maior que 9 e menor que 12 -->

<!-- ```{r fig.width=10, fig.height=8} -->
<!-- me <- 10 -->
<!-- sdd <- 2 -->
<!-- val1 <- 9 -->
<!-- val2 <- 12 -->
<!-- Z1 <- (val1 - me) / sdd -->
<!-- Z2 <- (val2 - me) / sdd -->

<!-- (prob <- pnorm(Z2) - pnorm(Z1)) -->

<!-- normal <- -->
<!--   ggplot() + -->
<!--   scale_x_continuous(limits =  c(3, 17), -->
<!--                      breaks = 3:17) + -->
<!--   stat_function(fun = dnorm, -->
<!--                 geom = "area", -->
<!--                 fill = "steelblue", -->
<!--                 xlim = c(val1, val2), -->
<!--                 args = list( -->
<!--                   mean = me, -->
<!--                   sd = sdd -->
<!--                 ))+ -->
<!--   stat_function(fun = dnorm, -->
<!--                 geom = "line", -->
<!--                 args = list( -->
<!--                   mean = me, -->
<!--                   sd = sdd -->
<!--                 ))+ -->
<!--   scale_y_continuous(expand = expansion(mult = c(0, .1)))+ -->
<!--   labs(x = "Valor original", y = "Probabilidade")+ -->
<!--   ggtitle("Distribuição da variável original") -->

<!-- padrao <- -->
<!--   ggplot() + -->
<!--   stat_function(fun = dnorm, -->
<!--                 geom = "area", -->
<!--                 fill = "steelblue", -->
<!--                 xlim = c(Z1, Z2))+ -->
<!--   stat_function(fun = dnorm, -->
<!--                 geom = "line")+ -->
<!--   scale_x_continuous(limits = c(-3.5, 3.5), breaks = c(seq(-3, 3, 1)))+ -->
<!--   scale_y_continuous(expand = expansion(mult = c(0, .1)))+ -->
<!--   labs(x = "Valor de Z", y = "Probabilidade")+ -->
<!--   ggtitle("Distribuição da variável padronizada", -->
<!--           subtitle = paste("Z1:", round(Z1, 4), "  Z2:", round(Z2, 4), "; Prob área sombreada:", round(prob, 4))) -->

<!-- arrange_ggplot(normal, padrao, ncol = 1) -->
<!-- ``` -->

<!-- ### Questão 5 -->

<!-- Se X tem uma distribuição normal com média 100 e desvio padrão 10, determine: -->

<!-- * P(X \< 115) -->

<!-- ```{r fig.width=10, fig.height=8} -->

<!-- me <- 100 -->
<!-- sdd <- 10 -->
<!-- val <- 115 -->
<!-- Z <- (val - me) / sdd -->

<!-- (prob <- pnorm(Z)) -->

<!-- normal <- -->
<!--   ggplot() + -->
<!--   scale_x_continuous(limits = c(65,  135)) + -->
<!--   stat_function(fun = dnorm, -->
<!--                 geom = "area", -->
<!--                 fill = "steelblue", -->
<!--                 xlim = c(65, val), -->
<!--                 args = list( -->
<!--                   mean = me, -->
<!--                   sd = sdd -->
<!--                 ))+ -->
<!--   stat_function(fun = dnorm, -->
<!--                 geom = "line", -->
<!--                 args = list( -->
<!--                   mean = me, -->
<!--                   sd = sdd -->
<!--                 ))+ -->
<!--   scale_y_continuous(expand = expansion(mult = c(0, .1)))+ -->
<!--   labs(x = "Valor original", y = "Probabilidade")+ -->
<!--   ggtitle("Distribuição da variável original") -->

<!-- padrao <- -->
<!--   ggplot() + -->
<!--   stat_function(fun = dnorm, -->
<!--                 geom = "area", -->
<!--                 fill = "steelblue", -->
<!--                 xlim = c(-3.5, Z))+ -->
<!--   stat_function(fun = dnorm, -->
<!--                 geom = "line")+ -->
<!--   scale_x_continuous(limits = c(-3.5, 3.5), breaks = c(seq(-3, 3, 1)))+ -->
<!--   scale_y_continuous(expand = expansion(mult = c(0, .1)))+ -->
<!--   labs(x = "Valor de Z", y = "Probabilidade")+ -->
<!--   ggtitle("Distribuição da variável padronizada", -->
<!--           subtitle = paste("Valor de Z:", round(Z, 4), "\nProb área sombreada:", round(prob, 4))) -->

<!-- arrange_ggplot(normal, padrao, ncol = 1) -->
<!-- ``` -->

<!-- * P(X \> 80) -->

<!-- > R: 0,9772 -->
<!-- RESOLUÇÃO: calcular a probabilidade x ser maior que 80, ou seja `\(1 - P(X \le 80\)`). -->

<!-- ```{r} -->
<!-- me <- 100 -->
<!-- sdd <- 10 -->
<!-- val <- 80 -->
<!-- Z <- (val - me) / sdd -->

<!-- (prob <- 1 - pnorm(Z)) -->

<!-- normal <- -->
<!--   ggplot() + -->
<!--   scale_x_continuous(limits = c(65,  135)) + -->
<!--   stat_function(fun = dnorm, -->
<!--                 geom = "area", -->
<!--                 fill = "steelblue", -->
<!--                 xlim = c(80, 140), -->
<!--                 args = list( -->
<!--                   mean = me, -->
<!--                   sd = sdd -->
<!--                 ))+ -->
<!--   stat_function(fun = dnorm, -->
<!--                 geom = "line", -->
<!--                 args = list( -->
<!--                   mean = me, -->
<!--                   sd = sdd -->
<!--                 ))+ -->
<!--   scale_y_continuous(expand = expansion(mult = c(0, .1)))+ -->
<!--   labs(x = "Valor original", -->
<!--        y = "Probabilidade") -->

<!-- padrao <- -->
<!--   ggplot() + -->
<!--   stat_function(fun = dnorm, -->
<!--                 geom = "area", -->
<!--                 fill = "steelblue", -->
<!--                 xlim = c(Z, 4))+ -->
<!--   stat_function(fun = dnorm, -->
<!--                 geom = "line")+ -->
<!--   scale_x_continuous(limits = c(-3.5, 3.5), breaks = c(seq(-3, 3, 1)))+ -->
<!--   scale_y_continuous(expand = expansion(mult = c(0, .1)))+ -->
<!--   labs(x = "Valor de Z", y = "Probabilidade") -->

<!-- arrange_ggplot(normal, padrao, ncol = 1) -->
<!-- ``` -->


<!-- * P(X \> 100) -->
<!-- > R: 0,5 -->
<!-- RESOLUÇÃO: calcular a probabilidade x ser maior que 50, ou seja `\(1 - P(X \le 50\)`). -->

<!-- ```{r} -->

<!-- me <- 100 -->
<!-- sdd <- 10 -->
<!-- val <- 100 -->
<!-- Z <- (val - me) / sdd -->

<!-- (prob <- 1 - pnorm(Z)) -->

<!-- normal <- -->
<!--   ggplot() + -->
<!--   scale_x_continuous(limits = c(65,  135)) + -->
<!--   stat_function(fun = dnorm, -->
<!--                 geom = "area", -->
<!--                 fill = "steelblue", -->
<!--                 xlim = c(100, 140), -->
<!--                 args = list( -->
<!--                   mean = me, -->
<!--                   sd = sdd -->
<!--                 ))+ -->
<!--   stat_function(fun = dnorm, -->
<!--                 geom = "line", -->
<!--                 args = list( -->
<!--                   mean = me, -->
<!--                   sd = sdd -->
<!--                 ))+ -->
<!--   scale_y_continuous(expand = expansion(mult = c(0, .1)))+ -->
<!--   labs(x = "Valor original", -->
<!--        y = "Probabilidade") -->

<!-- padrao <- -->
<!--   ggplot() + -->
<!--   stat_function(fun = dnorm, -->
<!--                 geom = "area", -->
<!--                 fill = "steelblue", -->
<!--                 xlim = c(Z, 4))+ -->
<!--   stat_function(fun = dnorm, -->
<!--                 geom = "line")+ -->
<!--   scale_x_continuous(limits = c(-3.5, 3.5), breaks = c(seq(-3, 3, 1)))+ -->
<!--   scale_y_continuous(expand = expansion(mult = c(0, .1)))+ -->
<!--   labs(x = "Valor de Z", y = "Probabilidade") -->

<!-- arrange_ggplot(normal, padrao, ncol = 1) -->

<!-- ``` -->


<!-- ### Questão 6 -->

<!-- A alturas de 10000 alunos de um colégio têm distribuição aproximadamente normal com média de 170 cm e desvio padrão de 5 cm. Qual o número esperado de alunos com altura superior a 1,65 m? -->

<!-- > R = 8413 alunos (0,8413 \* 10000) -->
<!-- RESOLUÇÃO: calcular a probabilidade de alunos com mais de 165 cm, logo achando o número de alunos. -->

<!-- ```{r fig.width=10, fig.height=8} -->

<!-- n <- 10000 -->
<!-- me <- 170 -->
<!-- sdd <- 5 -->
<!-- val <- 165 -->
<!-- Z <- (val - me) / sdd -->
<!-- (prob <- 1 - pnorm(Z)) -->

<!-- normal <- -->
<!--   ggplot() + -->
<!--   scale_x_continuous(limits = c(152.5,  187.5), -->
<!--                      breaks = seq(150, 190, by = 5)) + -->
<!--   stat_function(fun = dnorm, -->
<!--                 geom = "area", -->
<!--                 fill = "steelblue", -->
<!--                 xlim = c(val, 187.5), -->
<!--                 args = list( -->
<!--                   mean = me, -->
<!--                   sd = sdd -->
<!--                 ))+ -->
<!--   stat_function(fun = dnorm, -->
<!--                 geom = "line", -->
<!--                 args = list( -->
<!--                   mean = me, -->
<!--                   sd = sdd -->
<!--                 ))+ -->
<!--   scale_y_continuous(expand = expansion(mult = c(0, .1)))+ -->
<!--   labs(x = "Altura do aluno",  -->
<!--        y = "Probabilidade") -->


<!-- padrao <- -->
<!--   ggplot() + -->
<!--   stat_function(fun = dnorm, -->
<!--                 geom = "area", -->
<!--                 fill = "steelblue", -->
<!--                 xlim = c(Z, 3.5))+ -->
<!--   stat_function(fun = dnorm, -->
<!--                 geom = "line")+ -->
<!--   scale_x_continuous(limits = c(-3.5, 3.5), -->
<!--                      breaks = c(seq(-3, 3, 1)))+ -->
<!--   scale_y_continuous(expand = expansion(mult = c(0, .1)))+ -->
<!--   labs(x = "Valor de Z", -->
<!--        y = "Probabilidade")+ -->
<!--   ggtitle("Distribuição da variável padronizada", -->
<!--           subtitle = paste("Valor de Z:", round(Z, 4), "\nProb área sombreada:", round(prob, 4))) -->

<!-- arrange_ggplot(normal, padrao, ncol = 1) -->
<!-- ``` -->


<!-- ### Questão 7 -->

<!-- Uma ensacadora de adubos está regulada para que o peso em cada saco seja de 50 Kg com desvio padrão de 5 Kg. Admitindo-se que a distribuição é aproximadamente normal, qual a percentagem de sacos em que o peso de adubo é inferior a 45 Kg? -->

<!-- > R (0,1587) -->
<!-- RESOLUÇÃO: encontrar a probabilidade de achar sacos com menos que 45 Kg. -->

<!-- ```{r fig.width=10, fig.height=8} -->

<!-- me <- 50 -->
<!-- sdd <- 5 -->
<!-- val <- 45 -->
<!-- Z <- (val - me) / sdd -->
<!-- (prob <- pnorm(Z)) -->

<!-- normal <- -->
<!--   ggplot() + -->
<!--   scale_x_continuous(limits = c(32.5,  67.5), -->
<!--                      breaks = seq(30, 70, by = 5)) + -->
<!--   stat_function(fun = dnorm, -->
<!--                 geom = "area", -->
<!--                 fill = "steelblue", -->
<!--                 xlim = c(32.5, val), -->
<!--                 args = list( -->
<!--                   mean = me, -->
<!--                   sd = sdd -->
<!--                 ))+ -->
<!--   stat_function(fun = dnorm, -->
<!--                 geom = "line", -->
<!--                 size = 1, -->
<!--                 args = list( -->
<!--                   mean = me, -->
<!--                   sd = sdd -->
<!--                 ))+ -->
<!--   scale_y_continuous(expand = expansion(mult = c(0, .1)))+ -->
<!--   labs(x = "Peso do saco de adubo", -->
<!--        y = "Probabilidade") -->

<!-- padrao <- -->
<!--   ggplot() + -->
<!--   stat_function(fun = dnorm, -->
<!--                 geom = "area", -->
<!--                 fill = "steelblue", -->
<!--                 xlim = c(-3.5, Z))+ -->
<!--   stat_function(fun = dnorm, -->
<!--                 geom = "line")+ -->
<!--   scale_x_continuous(limits = c(-3.5, 3.5), breaks = c(seq(-3, 3, 1)))+ -->
<!--   scale_y_continuous(expand = expansion(mult = c(0, .1)))+ -->
<!--   labs(x = "Valor de Z", y = "Probabilidade")+ -->
<!--   ggtitle("Distribuição da variável padronizada", -->
<!--           subtitle = paste("Valor de Z:", round(Z, 4), "\nProb área sombreada:", round(prob, 4))) -->

<!-- arrange_ggplot(normal, padrao, ncol = 1) -->
<!-- ``` -->


<!-- ### Questão 8 -->

<!-- Um lote de frangos com 14.000 frangos apresenta média de peso de 3,0 Kg e desvio padrão de 0,2 Kg. Assumindo que o peso deste lote segue uma distribuição aproximadamente normal, quantos são os frangos que pesam mais que 3300 g? -->

<!-- > R = \~ 935 (0,0668072 \* 14000) -->
<!-- RESOLUÇÃO: encontrar Z e achar a probabilidade de o peso ser maior que Z. -->

<!-- ```{r fig.width=10, fig.height=8} -->
<!-- me <- 3 -->
<!-- sdd <- 0.2 -->
<!-- val <- 3.3 -->
<!-- Z <- (val - me) / sdd -->
<!-- (prob <- 1 - pnorm(Z)) -->
<!-- round(prob * 14000) -->

<!-- normal <- -->
<!--   ggplot() + -->
<!--   scale_x_continuous(limits = c(2.3, 3.7), -->
<!--                      breaks = seq(2, 4, by = 0.5)) + -->
<!--   stat_function(fun = dnorm, -->
<!--                 geom = "area", -->
<!--                 fill = "steelblue", -->
<!--                 xlim = c(val, 4), -->
<!--                 args = list( -->
<!--                   mean = me, -->
<!--                   sd = sdd -->
<!--                 ))+ -->
<!--   stat_function(fun = dnorm, -->
<!--                 geom = "line", -->
<!--                 args = list( -->
<!--                   mean = me, -->
<!--                   sd = sdd -->
<!--                 ))+  -->
<!--   scale_y_continuous(expand = expansion(mult = c(0, .1)))+ -->
<!--   labs(x = "Peso do frango (kg)", y = "probabilidade")  -->


<!-- padrao <- -->
<!--   ggplot() + -->
<!--   stat_function(fun = dnorm, -->
<!--                 geom = "area", -->
<!--                 fill = "steelblue", -->
<!--                 xlim = c(Z, 3.5))+ -->
<!--   stat_function(fun = dnorm, -->
<!--                 geom = "line")+ -->
<!--   scale_x_continuous(limits = c(-3.5, 3.5), -->
<!--                      breaks = c(seq(-3, 3, 1)))+ -->
<!--   scale_y_continuous(expand = expansion(mult = c(0, .1)))+ -->
<!--   labs(x = "Valor de Z", y = "Probabilidade")+ -->
<!--   ggtitle("Distribuição da variável padronizada", -->
<!--           subtitle = paste("Valor de Z:", round(Z, 4), "\nProb área sombreada:", round(prob, 4))) -->

<!-- arrange_ggplot(normal, padrao, ncol = 1) -->
<!-- ``` -->


<!-- ### Questão 9 -->

<!-- Em uma fazenda de criação de coelhos, um lote com 300 coelhos tem média que segue uma distribuição normal com média de 3,5 Kg com desvio padrão de 250 g. Coelhos com peso de até 3.7 Kg são vendidos a R\$ 15,00 o Kg. Coelhos com peso acima de 3,7 Kg são vendidos a R\$ 20,00 o Kg. Quantos coelhos serão vendidos ao maior valor de venda? -->

<!-- > R (\~ 63 coelhos; 0.2119 \* 300) -->
<!-- RESOLUÇÃO encontrar o número de coelhos que pesem mais que 3.7 Kg. No -->
<!-- gráfico abaixo, a cor vermelha representa a probabilidade de coelhos com -->
<!-- menos de 3.7 Kg e a cor azul a probabilidade de encontrar coelhos com -->
<!-- mais de 3.7 Kg. -->

<!-- ```{r fig.width=10, fig.height=8} -->

<!-- me <- 3.5 -->
<!-- sdd <- 0.25 -->
<!-- val <- 3.7 -->
<!-- (Z <- (val - me) / sdd) -->
<!-- (prob <- 1 - pnorm(Z)) -->

<!-- # número de coelhos -->
<!-- round(prob * 300) -->
<!-- normal <- -->
<!--   ggplot() +  -->
<!--   scale_x_continuous(limits = c(2.625,  4.375)) + -->
<!--   stat_function(fun = dnorm, -->
<!--                 geom = "area", -->
<!--                 fill = "blue", -->
<!--                 xlim = c(val, 4.375), -->
<!--                 args = list( -->
<!--                   mean = me, -->
<!--                   sd = sdd -->
<!--                 ))+ -->
<!--   stat_function(fun = dnorm, -->
<!--                 geom = "area", -->
<!--                 fill = "red", -->
<!--                 xlim = c(2.625, val), -->
<!--                 args = list( -->
<!--                   mean = me, -->
<!--                   sd = sdd -->
<!--                 ))+ -->
<!--   stat_function(fun = dnorm, -->
<!--                 geom = "line", -->
<!--                 args = list( -->
<!--                   mean = me, -->
<!--                   sd = sdd -->
<!--                 ))+ -->
<!--   scale_y_continuous(expand = expansion(mult = c(0, .1)))+ -->
<!--   labs(x = "Valor original", y = "Probabilidade")+ -->
<!--   ggtitle("Peso do coelho") -->

<!-- padrao <-  -->
<!-- ggplot() + -->
<!--   stat_function(fun = dnorm, -->
<!--                 geom = "area", -->
<!--                 fill = "blue", -->
<!--                 xlim = c(Z, 3.5))+ -->
<!--   stat_function(fun = dnorm, -->
<!--                 geom = "area", -->
<!--                 fill = "red", -->
<!--                 xlim = c(-3.5, Z))+ -->
<!--   stat_function(fun = dnorm, -->
<!--                 geom = "line")+ -->
<!--   scale_x_continuous(limits = c(-3.5, 3.5), breaks = c(seq(-3, 3, 1)))+ -->
<!--   scale_y_continuous(expand = expansion(mult = c(0, .1)))+ -->
<!--   labs(x = "Valor de Z", y = "Probabilidade")+ -->
<!--   ggtitle("Distribuição da variável padronizada", -->
<!--           subtitle = paste("Valor de Z:", round(Z, 4), "\nProb área azul:", round(prob, 4))) -->

<!-- arrange_ggplot(normal, padrao, ncol = 1) -->

<!-- ``` -->


<!-- ### Questão 10 -->

<!-- 1.  Um lote gado de corte com 3000 cabeças apresenta 430 Kg de peso vivo por cabeça em média com desvio padrão de 65 Kg e se sabe que segue uma distribuição normal. Na venda deste lote, animais com até 320 Kg são abatidos em um abatedouro A. Por outro lado, animais com peso maior que 320 e menor que 520 Kg são abatidos no abatedouro B. Animais com peso superior a 520 Kg são abatidos no abatedouro C. Considerando estes dados, responda: -->

<!-- a\. O número de animais abatidos nos 3 batedouros -->

<!-- b\. O número de animais abatidos no abatedouro A -->

<!-- c\. O número de animais abatidos no abatedouro B -->

<!-- d\. O número de animais abatidos no abatedouro C -->

<!-- > RESOLUÇÃO: encontrar a probabilidade do peso (X) assumir P(X\<320), P(320 \< X \< 520) e P(X \> 520). -->

<!-- ```{r fig.width=10, fig.height=5} -->

<!-- me <- 430 -->
<!-- sdd <- 65 -->
<!-- val1 <- 320 -->
<!-- val2 <- 520 -->
<!-- Z1 <- (val1 - me) / sdd -->
<!-- Z2 <- (val2 - me) / sdd -->

<!-- (prob1 <- pnorm(Z1)) -->
<!-- (prob2 <- pnorm(Z2) - prob1) -->
<!-- (prob3 <- 1 - sum(prob1, prob2)) -->

<!-- # checar se a soma das probabilidades deu 1 -->
<!-- sum(prob1, prob2, prob3) -->

<!-- normal <- -->
<!--   ggplot() + -->
<!--   xlim(c(202.5,  657.5)) + -->
<!--   stat_function(fun = dnorm, -->
<!--                 geom = "area", -->
<!--                 fill = "steelblue", -->
<!--                 xlim = c(202.5, val1), -->
<!--                 args = list( -->
<!--                   mean = me, -->
<!--                   sd = sdd -->
<!--                 ))+ -->
<!--   stat_function(fun = dnorm, -->
<!--                 geom = "area", -->
<!--                 fill = "green", -->
<!--                 xlim = c(val1, val2), -->
<!--                 args = list( -->
<!--                   mean = me, -->
<!--                   sd = sdd -->
<!--                 ))+ -->
<!--   stat_function(fun = dnorm, -->
<!--                 geom = "area", -->
<!--                 fill = "red", -->
<!--                 xlim = c(val2, 657.5), -->
<!--                 args = list( -->
<!--                   mean = me, -->
<!--                   sd = sdd -->
<!--                 ))+ -->
<!--   stat_function(fun = dnorm, -->
<!--                 geom = "line", -->
<!--                 args = list( -->
<!--                   mean = me, -->
<!--                   sd = sdd -->
<!--                 ))+ -->
<!--   scale_y_continuous(expand = expansion(mult = c(0, .1)))+ -->
<!--   labs(x = "Valor original", y = "Probabilidade")+ -->
<!--   ggtitle("Distribuição da variável ") -->

<!-- padrao <- -->
<!--   ggplot() + -->
<!--   xlim(c(-3.5, 3.5)) + -->
<!--   stat_function(fun = dnorm, -->
<!--                 geom = "area", -->
<!--                 fill = "steelblue", -->
<!--                 xlim = c(-3.5, Z1))+ -->
<!--   stat_function(fun = dnorm, -->
<!--                 geom = "area", -->
<!--                 fill = "green", -->
<!--                 xlim = c(Z1, Z2))+ -->
<!--   stat_function(fun = dnorm, -->
<!--                 geom = "area", -->
<!--                 fill = "red", -->
<!--                 xlim = c(Z2, 3.5))+ -->
<!--   stat_function(fun = dnorm, -->
<!--                 geom = "line")+ -->
<!--   scale_x_continuous(limits = c(-3.5, 3.5), breaks = c(seq(-3, 3, 1)))+ -->
<!--   scale_y_continuous(expand = expansion(mult = c(0, .1)))+ -->
<!--   labs(x = "Valor de Z", y = "Probabilidade")+ -->
<!--   annotate("text", x = -3, y = 0.11, label = "Abatedouro A") + -->
<!--   annotate("segment", -->
<!--            x = -3, -->
<!--            y = 0.1, -->
<!--            xend = -2.2, -->
<!--            yend = 0.01, -->
<!--            arrow=arrow()) + -->
<!--   annotate("text", x = -3, y = 0.31, label = "Abatedouro B") + -->
<!--   annotate("segment", -->
<!--            x = -3, -->
<!--            y = 0.3, -->
<!--            xend = 0, -->
<!--            yend = 0.15, -->
<!--            arrow=arrow()) + -->
<!--   annotate("text", x = 3, y = 0.11, label = "Abatedouro C") + -->
<!--   annotate("segment", -->
<!--            x = 3, -->
<!--            y = 0.1, -->
<!--            xend = 2, -->
<!--            yend = 0.01, -->
<!--            arrow=arrow()) -->

<!-- arrange_ggplot(normal, padrao) -->
<!-- ``` -->



<!-- ### Questão 11 -->

<!-- Um agricultor possui uma área de plantio de eucalipto com 2,5 ha e uma densidade de 1500 plantas por ha. O diâmetro a altura do peito (DAP) segue uma distribuição normal, com média de 22 cm e variância de 16 cm\$^2\$. -->

<!-- O produtor recebeu uma proposta de compra das toras que segue a seguinte -->
<!-- condição. -->

<!-- -   Se as toras apresentarem até 17 cm de DAP, a madeira é destinada para produção de maravalha, com preço por tora de R\\\$ 28,00. -->

<!-- - Se as toras apresentarem DAP maior do que 17 cm, a madeira é destinada para produção de tábuas, com preço por tora de R\\\$ 46,00. -->

<!-- Considerando o exposto, calcule: -->

<!-- a\) O valor estimado de venda de toras para maravalha -->

<!-- Para encontrar este número, precisamos saber quantas árvores com esta -->
<!-- medida são esperadas. Para isso, precisamos encontrar a probabilidade de -->
<!-- ocorrência de árvores com até 18 cm de DAP e multiplicar essa -->
<!-- probabilidade pelo total de árvores. -->

<!-- $$ -->
<!-- Z = \frac{17 - 22}{4} = -1,25 -->
<!-- $$ -->

<!-- ```{r fig.width=10, fig.height=8} -->

<!-- ggplot() + -->
<!--   stat_function(fun = dnorm, -->
<!--                 geom = "area", -->
<!--                 fill = "cyan", -->
<!--                 xlim = c(-3, -1.25)) + -->
<!--   stat_function(fun = dnorm, -->
<!--                 geom = "line", -->
<!--                 xlim = c(-3, 3)) + -->
<!--   scale_y_continuous(expand = expansion(mult = c(0, 0.1))) + -->
<!--   labs(y = "", x = "Z") -->



<!-- # probabilidade -->
<!-- (p17 <- pnorm(17, mean = 22, sd = 4)) -->

<!-- # número de toras -->
<!-- (n <- round(p17 * (1500 * 2.5))) -->

<!-- # valor das toras -->
<!-- n * 28 -->
<!-- ``` -->

<!-- b\) o valor estimado de venda de toras para fabricação de tábua -->

<!-- Para encontrar este número, precisamos saber quantas árvores com com mais de 18 cm se espera. A probabilidade de árvores com mais de 18 cm (P) é dada por -->

<!-- $$ -->
<!-- Z = P(X > 1,25) = 1 - P(\le 1,25) -->
<!-- $$ -->

<!-- $$ -->
<!-- P(X > 1,25) = 1 - 0,1056 -->
<!-- $$ -->

<!-- $$ -->
<!-- P(X > 1,25) = 0,8943 -->
<!-- $$ -->


<!-- ```{r} -->

<!-- ggplot() + -->
<!--   stat_function(fun = dnorm, -->
<!--                 geom = "area", -->
<!--                 fill = "cyan", -->
<!--                 xlim = c(-1.25, 3)) + -->
<!--   stat_function(fun = dnorm, -->
<!--                 geom = "line", -->
<!--                 xlim = c(-3, 3)) + -->
<!--   scale_y_continuous(expand = expansion(mult = c(0, 0.1))) + -->
<!--   labs(y = "", x = "Z") -->


<!-- # probabilidade -->
<!-- (p_mais18 <- 1 - pnorm(17, mean = 22, sd = 4)) -->

<!-- # número de toras -->
<!-- (n2 <- round(p_mais18 * (1500 * 2.5))) -->

<!-- # valor das toras -->
<!-- n2 * 46 -->
<!-- ``` -->

<!-- c\) O DAP que somente 5 % das toras ultrapassará -->

<!-- Este valor é o quantil da distribuição no valor acumulado de 0.95. -->
<!-- Precisamos, primeiramente, encontrar a probabilidade de \$P(Z \> z)\$: -->


<!-- $$ -->
<!-- P(Z\>z) = 1 - P(Z≤z) -->
<!-- $$ -->


<!-- $$ -->
<!-- P(Z\>z) = 1 - 0,95 -->
<!-- $$ -->


<!-- $$ -->
<!-- P(Z\>z) = 0,05 -->
<!-- $$ -->
<!-- O valor de 0,95 é encontrado no quantil \~1,65 (Z) da distribuição -->
<!-- normal padrão (tabela). Para saber o valor exato, podemos utilizar a -->
<!-- função `qnorm()`. -->

<!-- ```{r} -->
<!-- qnorm(0.95) -->
<!-- ``` -->

<!-- ```{r} -->

<!-- ggplot() + -->
<!--   scale_x_continuous(limits = c(-3, 3), -->
<!--                      breaks = 1.644) + -->
<!--   stat_function(fun = dnorm, -->
<!--                 geom = "area", -->
<!--                 fill = "cyan", -->
<!--                 xlim = c(1.644, 3)) + -->
<!--   stat_function(fun = dnorm, -->
<!--                 geom = "line") + -->
<!--   scale_y_continuous(expand = expansion(mult = c(0, 0.1))) + -->
<!--   labs(y = "", x = "Z") + -->
<!--     annotate("segment", -->
<!--            x = 2.1, -->
<!--            y = 0.1, -->
<!--            xend = 2, -->
<!--            yend = 0.02, -->
<!--            arrow=arrow()) + -->
<!--   annotate("text", -->
<!--            x = 2.1, y = 0.11, -->
<!--            label = "Área = 0,05") -->
<!-- ``` -->

<!-- De posse do valor de *Z*, basta realizar uma inversão da fórmula de -->
<!-- padronização para encontrar o valor de *x*. -->

<!-- $$ -->
<!-- Z = (x – \mu)/\sigma\\ -->
<!-- $$ -->


<!-- $$ -->
<!-- 1,644 = (x – 22)/4\\ -->
<!-- $$ -->


<!-- $$ -->
<!-- 1,644\times4 = x – 22\\ -->
<!-- $$ -->


<!-- $$ -->
<!-- 6,576 = x – 22\\ -->
<!-- $$ -->

<!-- $$ -->
<!-- x = 22 + 6,576 -->
<!-- $$ -->

<!-- $$ -->
<!-- x = 28,576 -->
<!-- $$ -->
<!-- Então, o peso DAP que somente 5% das toras ultrapassará é de \~28,6 cm. -->




<!-- # Distribuição t -->

<!-- ```{r} -->
<!-- ggplot() + -->
<!--   scale_x_continuous(limits = c(-4, 4)) + -->
<!--   stat_function(fun = dnorm, -->
<!--                 size = 1.5, -->
<!--                 aes(color = "black")) + -->
<!--   stat_function(fun = dt, -->
<!--                 aes(color = "blue"), -->
<!--                 size = 1.5, -->
<!--                 args = list(df = 1)) + -->
<!--   stat_function(fun = dt, -->
<!--                 size = 1.5, -->
<!--                 aes(color = "red"), -->
<!--                 args = list(df = 3)) + -->
<!--   stat_function(fun = dt, -->
<!--                 size = 1.5, -->
<!--                 aes(color = "green"), -->
<!--                 args = list(df = 20))  + -->
<!--   scale_color_manual(labels = c("normal", "t - 1 GL", "t - 3 GL", "t - 20 GL"), -->
<!--                      values = c("black", "blue", "red", "green")) + -->
<!--   theme(legend.position = "bottom", -->
<!--         legend.title = element_blank()) -->
<!-- ``` -->
