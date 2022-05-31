---
title: Distribuições Contínuas
linktitle: "4. Distribuições Contínuas"
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
---

# Distribuição Normal

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

No método geométrico, a função *f(x)* corresponderá a altura de cada retângulo. A base do retângulo (\$\Delta\$), será dada por:

$$
\Delta=\frac{x_1-x_0}{n}
$$

onde *n* representa o número de retângulos no intervalo. Ao multiplicar a altura do retângulo pela sua base, temos a área de cada retângulo. Ao somarmos todas as *n* áreas, teremos a aproximação da probabilidade. Logo, é fácil notar que quanto maior o valor de *n* melhor será a aproximação do valor calculado pela integral.

A função abaixo pode ser utilizada para aproximar a integral da função da distribuição Normal. A função `mnorm` é a Função Densidade de Probabilidade e é aplicada dentro da função `int_norm` para encontrar a altura de cada retângulo. Por padrão, 50000 retângulos são utilizados.


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

Abaixo, a função `int_norm()` é usada para aproximar a probabilidade obtida anteriormente com a função `pnorm()`.


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

Nota-se que com 50000 retângulos, a aproximação da probabilidade pelo método geométrico apresentou diferença somente na quinta casa após a vírgula, demonstrando uma aproximação satisfatória. Vejamos o impacto do
número de retângulos nesta aproximação. Para isso, vamos criar um gráfico para mostrar como esta aproximação vai melhorando com o aumento no número de retângulos. No exemplo, é simulado de 1 até 200 (apenas
para fins didáticos). A linha vermelha horizontal representa a probabilidade compudata com a função `pnorm()`.


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

A distribuição Normal Padrão é nada mais que uma distribuição normal com média e desvio padrão fixos (\$\mu = 0; \sigma = 1\$). Uma vez que estes parâmetros são fixos, sempre que desejamos calcular uma probabilidade
pode-se recorrer a uma tabela, onde valores de probabilidade já foram previamente calculados para essa única distribuição.

Para isso, precisamos definir uma nova variável aleatória *Z*, chamada de variável aleatória normal padronizada, dada pela função linear *Z*.

$$
Z = \frac{X- \mu}{\sigma}
$$ Onde *X* é uma variável aleatória com distribuição normal com média
\$\mu\$ e \$\sigma > 0\$.

Como exemplo, vamos simular uma variável aleatória (X) com \$n = 300\$ tal que
\$X \sim N(\mu = 20; \sigma = 3)\$.


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




# Distribuição t

A distribuição *t* de Student é uma distribuição de probabilidade contínua, publicada por William Sealy Gosset sob o pseudônimo *Student* [^1].

[^1]: http://www.swlearning.com/quant/kohler/stat/biographical_sketches/bio12.1.html

A distribuição *t* possui como único parâmetro o Grau Liberdade (GL). Esta distribuição detém caudas mais pesadas que a distribuição normal quando o tamanho da amostra é pequeno e a medida que \$n \to N\$, a distribuição *t* de Student se aproxima da normal. Note abaixo as diferenças nas curvas quando se compara a distribuição Normal com a distribuição *t* com diferentes GLs.



```r
ggplot() +
  scale_x_continuous(limits = c(-6, 6)) +
  stat_function(fun = dnorm,
                size = 1.5,
                aes(color = "black")) +
  stat_function(fun = dt,
                aes(color = "blue"),
                size = 1.5,
                args = list(df = 1)) +
  stat_function(fun = dt,
                size = 1.5,
                aes(color = "red"),
                args = list(df = 3)) +
  stat_function(fun = dt,
                size = 1.5,
                aes(color = "green"),
                args = list(df = 20))  +
  scale_color_manual(labels = c("normal", "t - 1 GL", "t - 20 GL", "t - 3 GL"),
                     values = c("black", "blue", "red", "green")) +
  ylab("") +
  theme(legend.position = "bottom",
        legend.title = element_blank())
```

<img src="/classes/experimentacao/04_dist_cont_files/figure-html/unnamed-chunk-17-1.png" width="672" />


Abaixo, é mostrada a Função Densidade de Probabilidade de uma distribuição *t* com 20 graus liberdade. As áreas sombreadas em azul escuro representam os quantis que acumulam uma área de \$\alpha / 2\$ em cada lado da distribuição, de tal forma que a área destacada em verde representa 1 - \$\alpha\$, sendo \$\alpha\$ a probabilidade de erro.


```r
ggplot() +
  stat_function(fun = dt, 
                args = list(df = 20),
                geom = "area", 
                fill = "steelblue", 
                xlim = c(-4, -2.08)) +
  stat_function(fun = dt, 
                args = list(df = 20),
                geom = "area", 
                fill = "steelblue", 
                xlim = c(4, 2.08)) +
    stat_function(fun = dt, 
                args = list(df = 20),
                geom = "area", 
                fill = "green", 
                xlim = c(-2.08, 2.08)) +
  stat_function(fun = dt,
                args = list(df = 20),
                size = 1) +
  scale_x_continuous(limits = c(-4, 4),
                     breaks = c(-2.08, 2.08)) +
  scale_y_continuous(expand = expansion(mult = c(0, .1)),
                     breaks = NULL) +
  ylab("")
```

<img src="/classes/experimentacao/04_dist_cont_files/figure-html/unnamed-chunk-18-1.png" width="672" />


## Intervalo de confiança


A estimação por pontos (ex., média) não nos fornece a ideia da margem de erro cometida ao estimar um determinado parâmetro. Por isso, para verificar se uma dada hipótese `\(H_0\)` (de igualdade) é ou não verdadeira, deve-se utilizar intervalos de confiança ou testes de hipóteses. A construção destes intervalos, e as particularidades dos testes de hipóteses para amostras independentes e dependentes, serão discutidos a seguir. Recomendo como literatura o livro [Estatística Básica](http://www.editoraufv.com.br/produto/1595058/estatistica-basica)[^analdata-2] escrito pelo Prof. Daniel Furtado Ferreira.

O intervalo de confiança de uma média amostral assumindo uma taxa de erro `\(\alpha\\)` é dado por:

$$
P\left[ {\bar X - {t_{\alpha /2}}\frac{S}{{\sqrt n }} \le \mu  \le \bar X + {t_{\alpha /2}}\frac{S}{{\sqrt n }}} \right] = 1 - \alpha 
$$

Na expressão acima, \$\bar X\$ é a média, \$S\$ é o desvio padrão e \$-t_{\alpha /2}\$ e \$+t_{\alpha /2}\$ são os quantis inferior e superior, respectivamente, da distribuição *t* de Student. O intervalo acima indica que o valor do parâmetro (\$\mu\$) tem \$1 - \alpha\$ de chance de estar contido no intervalo.

### Exemplo 1 (altura da turma)
Como exemplo de motivação, vamos utilizar os dados referentes a altura (em cm) dos alunos da disciplina de Bioestatística e Experimentação Agrícola, mensurada em sala de aula. A amostra é composta por 20 observações.


```r
library(rio)
df_altura <- 
  import("https://docs.google.com/spreadsheets/d/1JMrkppvv1BdGKVCekzZPsPYCKcgUWjxpuDlWqejc22s/edit#gid=1992833755") |> 
  as_character(Pessoa)

df_altura
```

```
##    Pessoa Altura
## 1       1    176
## 2       2    164
## 3       3    159
## 4       4    163
## 5       5    173
## 6       6    161
## 7       7    177
## 8       8    179
## 9       9    168
## 10     10    172
## 11     11    178
## 12     12    170
## 13     13    174
## 14     14    169
## 15     15    175
## 16     16    169
## 17     17    187
## 18     18    181
## 19     19    186
## 20     20    171
```


Como n = 20, o grau liberdade para encontrar o quantil da distribuição *t* é 19. O quantil associado a este Grau Liberdade, considerando \$\alpha = 0,05\$ é encontrado na tabela da distribuição *t*. Nesta tabela, o valor de 



[![](/classes/experimentacao/04_dist_cont_files/dist_t.png)](https://github.com/TiagoOlivoto/tiagoolivoto/blob/master/static/classes/experimentacao/tabela_t.pdf){target="\_blank"}


Tamém podemos encontrar este quantil utilizando a função `qt()`. No próximo código, o quantil (2.5% e 97.5%), a média e o desvio padrão são calculados. Note que 


```r
(quantil_t <- qt(c(0.025, 0.975), df = 19))
```

```
## [1] -2.093024  2.093024
```

```r
(media <- mean(df_altura$Altura))
```

```
## [1] 172.6
```

```r
(desvpad <- sd(df_altura$Altura))
```

```
## [1] 7.639234
```

De posse destas informações, podemos calcular o intervalo de confiança (limite inferior, LI e limite superior, LS)

$$
LI = 172,6 - 2,093 \times \frac{{7,64}}{{\sqrt {20} }} = 169,02
$$

$$
Ls = 172,6 + 2,093 \times \frac{{7,64}}{{\sqrt {20} }} = 176,17
$$

Para facilitar nossos próximos exemplos, vamos criar uma função para computar o intervalo de confiança 95%.

```r
get_ci_t <- function(media, dp, n){
  quantil_t <- qt(0.975, n - 1)
  quantil_t * dp / sqrt(n)
}
```




```r
df <- tibble(
  media = media,
  desvpad = desvpad,
  LI = media - get_ci_t(media, desvpad, 20),
  LS = media + get_ci_t(media, desvpad, 20)
)
df
```

```
## # A tibble: 1 × 4
##   media desvpad    LI    LS
##   <dbl>   <dbl> <dbl> <dbl>
## 1  173.    7.64  169.  176.
```

```r
# criar o gráfico com os intervalos
ggplot(df, aes(x = media, y = "")) +
  geom_errorbar(aes(xmin = LI,
                    xmax = LS),
                width = 0.1) +
  geom_point(color = "blue",
             size = 3) +
  scale_x_continuous(breaks = seq(169, 177, by = 1)) +
  labs(x = "Altura do aluno (cm)",
       y = "")
```

<img src="/classes/experimentacao/04_dist_cont_files/figure-html/unnamed-chunk-22-1.png" width="672" />

A função `t.test()` pode também ser utilizada para calcular o intervalo de confiança de 95% quando se tem apenas uma amostra.


```r
ic <- t.test(df_altura$Altura)
ic$conf.int
```

```
## [1] 169.0247 176.1753
## attr(,"conf.level")
## [1] 0.95
```


### Exemplo 2 (peso de frango)

Considere um aviário com 15000 frangos. O criador realizou a amostragem de 25 frangos aleatoriamente para realizar uma estimativa da média do peso do lote visando a programação para abate. Após analisar as pesagens coletadas, o produtor encontrou uma média de 2,83 Kg e um desvio padrão de 0,27 Kg. Pergunta-se: Qual o intervalo de 95% para a média estimada?


```r
df3 <- tibble(
  media = 2.83,
  desvpad = 0.27,
  LI = media - get_ci_t(media, desvpad, n = 25),
  LS = media + get_ci_t(media, desvpad, n = 25)
)

ggplot(df3, aes(x = media, y = "")) +
  geom_errorbar(aes(xmin = LI,
                    xmax = LS),
                width = 0.1) +
  geom_point(color = "blue",
             size = 3) +
  labs(x = "Peso médio do frango",
       y = "")
```

<img src="/classes/experimentacao/04_dist_cont_files/figure-html/unnamed-chunk-24-1.png" width="672" />




### Variação no desvio padrão
Abaixo, são simuladas 4 amostras de n = 20 com médias igual a 10 e desvios padrões variantes. Note como o intervalo de confiança é menor a medida em que o desvio padrão é mais baixo.


```r
df4 <- tibble(
  amostra = paste0(1:4),
  media = c(10, 10, 10, 10),
  desvpad = c(1, 4, 6, 8),
  LI = media - get_ci_t(media, desvpad, n = 20),
  LS = media + get_ci_t(media, desvpad, n = 20),
  lab = paste0("dp: ", desvpad)
)
df4
```

```
## # A tibble: 4 × 6
##   amostra media desvpad    LI    LS lab  
##   <chr>   <dbl>   <dbl> <dbl> <dbl> <chr>
## 1 1          10       1  9.53  10.5 dp: 1
## 2 2          10       4  8.13  11.9 dp: 4
## 3 3          10       6  7.19  12.8 dp: 6
## 4 4          10       8  6.26  13.7 dp: 8
```

```r
# criar o gráfico com os intervalos
ggplot(df4, aes(x = media, y = amostra)) +
  geom_vline(xintercept = 10, linetype = 2) + 
  geom_errorbar(aes(xmin = LI,
                    xmax = LS),
                width = 0.1) +
  geom_point(color = "blue",
             size = 3) +
  scale_x_continuous(breaks = seq(169, 177, by = 1)) +
  geom_text(aes(label = lab),
            vjust = -1,
            hjust = 2) +
  labs(x = "Variável hipotética",
       y = "Amostra")
```

<img src="/classes/experimentacao/04_dist_cont_files/figure-html/unnamed-chunk-25-1.png" width="672" />


### Variação no tamanho da amostra



```r
df_t <- tibble(
  dist = "t",
  n = seq(2, 30, length.out = 200),
  media = 10,
  desvpad = 2,
  UL = media + get_ci_t(media, desvpad, n = n),
  LL = media - get_ci_t(media, desvpad, n = n)
)
df_n <- tibble(
  dist = "normal",
  n = seq(2, 30, length.out = 200),
  media = 10,
  desvpad = 2,
  UL = media + qnorm(0.975) * desvpad / sqrt(n),
  LL = media - qnorm(0.975) * desvpad / sqrt(n)
)
df_dists <- rbind(df_t, df_n)

# criar o gráfico com os intervalos
ggplot(df_dists, aes(color = dist)) +
  geom_line(aes(x = n, y = LL), size = 1) +
  geom_line(aes(x = n, y = UL), size = 1) +
  scale_x_continuous(breaks = seq(2, 30, by = 2)) +
  labs(x = "Tamanho da amostra",
       y = "Intervalo de confiança (95%)") +
  theme(legend.position = "bottom",
        legend.title = element_blank())
```

<img src="/classes/experimentacao/04_dist_cont_files/figure-html/unnamed-chunk-26-1.png" width="672" />



## Testes de hipóteses

Os testes de hipóteses são utilizados para determinar quais resultados de um estudo científico podem levar à rejeição da hipótese nula (\$H_0\$) a um nível de significância pré–estabelecido. Os testes de hipóteses aqui demonstrados tem como objetivo:

1) verificar se determinada amostra difrere ou não de zero (${H_0}:\mu = 0$)
2) Verificar se duas amostras independentes são ou não iguais (${H_0}:{\mu _1} = {\mu _2}$).
2) Verificar se duas amostras dependentes possuem desvios iguais a zero (${H_0}:d_i = 0$).



### Teste de hipótese para uma amostra

No caso de uma amostra, a estatística teste (t calculado) é dada por

$$
{t_{c(\alpha; \nu)}} = \frac{{\bar Y - \mu }}{{\frac{{{S_Y}}}{{\sqrt n }}}}
$$

Onde \$\alpha\$ é a probabilidade de erro, \$\nu\$ é o grau de liberdade (nº de amostras menos 1), \$\bar Y\$ é a média da amostra, \$S_y\$ é o desvio padrão da amostra e \$n\$ é o número de amostras.

Vamos retornar ao exemplo da altura da turma. A média da amostragem é de 172,6 cm. Digamos que a altura média dos alunos da UFSC é de 165 cm. Pode-se dizer que a estimativa da altura da turma de Bioestatística a 165 cm, considerando uma taxa de erro de 5%?

Primeiramente, define-se as hipóteses;

$$
{H_0}:172,6 = 165
$$

$$
H_1:172,6 \ne 165
$$



```r
altura <- df_altura$Altura
(dp <- sd(altura))
```

```
## [1] 7.639234
```

```r
(media <- mean(altura))
```

```
## [1] 172.6
```

```r
(n <- length(altura))
```

```
## [1] 20
```

```r
(t_tab <- qt(0.975, df = n - 1))
```

```
## [1] 2.093024
```


$$
{t_c} = \frac{{172,6 - 165}}{{\frac{{7,63}}{{\sqrt {20} }}}}
$$
$$
{t_c} = 4,455
$$


Como o t calculado (4,455) é maior que o t tabelado (2,09), rejeita-se a hipótese nula e afirma-se que a estimativa da média da altura da turma difere de 165 cm. Este mesmo teste pode ser realizado com a função `t.test()`.


```r
# t tabelado
t.test(altura, mu = 165)
```

```
## 
## 	One Sample t-test
## 
## data:  altura
## t = 4.4492, df = 19, p-value = 0.0002752
## alternative hypothesis: true mean is not equal to 165
## 95 percent confidence interval:
##  169.0247 176.1753
## sample estimates:
## mean of x 
##     172.6
```



### Teste de hipóteses para amostras independentes

Neste tipo de teste de hipótese, o objetivo é comparar se a estimativa da média de um grupo "A" difere estatisticamente da estimativa da média de um grupo "B". Utilizaremos como amostras os dados do diâmetro dos grãos obtidas na primeira aula, onde deseja-se comparar se o diâmetro entre os grupos "vermelho" e "verde" difere estatisticamente.


```r
df_grao <- 
  import("https://docs.google.com/spreadsheets/d/1JMrkppvv1BdGKVCekzZPsPYCKcgUWjxpuDlWqejc22s/edit#gid=1716920199",
         dec = ",")

#gráfico
ggplot(df_grao, aes(DIAM_GRAO, fill = COR_GRAO)) +
  geom_density(alpha = 0.6) +
  scale_fill_manual(values = c("green", "red")) +
  theme(legend.position = "bottom",
        legend.title = element_blank())
```

<img src="/classes/experimentacao/04_dist_cont_files/figure-html/unnamed-chunk-29-1.png" width="672" />

```r
vermelho <- 
  df_grao |> 
  subset(COR_GRAO == "vermelho") |>
  pull(DIAM_GRAO)

verde <- 
  df_grao |> 
  subset(COR_GRAO == "verde") |>
  pull(DIAM_GRAO)
```

Neste caso, a estatística do teste é dada por

$$
{t_c} = \frac{{\left( {{{\bar x}_1} - {{\bar x}_2}} \right)}}{{\sqrt {S_p^2\left( {\frac{1}{{{n_1}}} + \frac{1}{{{n_2}}}} \right)} }}
$$

Onde

$$
S_p^2 = \frac{{\left( {{n_1} - 1} \right)S_{{x_1}}^2 + \left( {{n_2} - 1} \right)S_{{x_2}}^2}}{{{n_1} + {n_2} - 2}}
$$

Onde \$\bar x_1\$, \$n_1\$ e \$S^2_{x_1}\$ são a média, o tamanho da amostra e a variância para a amostra 1; \$\bar x_2\$, \$n_2\$ e \$S^2_{x_2}\$ são a média, o tamanho da amostra e a variância para a amostra 2. Vamos calcular estas estatísticas para os dados em questão. A estatística de teste é então comparada com o *t* tabelado com 26 (13 + 15 - 2) Graus Liberdade.


```r
df_grao |> 
  desc_stat(DIAM_GRAO,
            by = COR_GRAO,
            stats = c("n, mean, sd.amo")) |> 
  as.data.frame()
```

```
##   COR_GRAO  variable  n    mean sd.amo
## 1    verde DIAM_GRAO 15  8.8200 1.0105
## 2 vermelho DIAM_GRAO 13 10.8177 1.0617
```

```r
(t_tab <- qt(0.975, df = 26))
```

```
## [1] 2.055529
```


Com base nos valores obtidos, a estatística t é obtida com:

$$
S_p^2 = \frac{{\left( {13 - 1} \right)1,{{06}^2} + \left( {15 - 1} \right)1,{{01}^2}}}{{13 + 15 - 2}}
$$

$$
S_p^2 = 1,067
$$


$$
{t_c} = \frac{{\left( {10,81 - 8,82} \right)}}{{\sqrt {1,067\left( {\frac{1}{{13}} + \frac{1}{{15}}} \right)} }}
$$

$$
{t_c} = 5,084
$$

Como `\(5,084 > 2,055\)`, rejeita-se a hipótese \$H_0\$ e conclui-se que as médias dos dois grupos são estatisticamente distintas. Usando a função `t.test()`, este teste de hipótese é realizado com:


```r
# testa se as amostras difrem entre si
t.test(vermelho, verde, var.equal = TRUE) 
```

```
## 
## 	Two Sample t-test
## 
## data:  vermelho and verde
## t = 5.0962, df = 26, p-value = 2.608e-05
## alternative hypothesis: true difference in means is not equal to 0
## 95 percent confidence interval:
##  1.191932 2.803452
## sample estimates:
## mean of x mean of y 
##  10.81769   8.82000
```


O pacote [ggstatplot](https://indrajeetpatil.github.io/ggstatsplot/index.html)[^analdata-3] pode ser utilizado para confecionar gráficos que incluem teste de hipóteses.


```r
library(ggstatsplot)

ggbetweenstats(df_grao, 
               x = COR_GRAO,
               y = DIAM_GRAO,
               plot.type = "box",
               bf.message = FALSE,
               var.equal = TRUE)
```

<img src="/classes/experimentacao/04_dist_cont_files/figure-html/unnamed-chunk-32-1.png" width="672" />


### Teste de hipóteses para amostras dependentes

As formas de comparação discutidas acima consideram as amostras como sendo independentes entre si. Em certas ocasiões, um mesmo indivíduo de uma amostra é medido ao longo do tempo ou avaliado antes ou depois da aplicação de um determinado tratamento.

Assim, nessas ocasiões, é possível avaliar se a diferença média das observações é estatisticamente igual a zero ou não. Se esta diferença for estatisticamente diferente de zero, pode-se afirmar que tal tratamento possui efeito significativo.

A estatística do teste *t* para amostras pareadas é dada por 

$$
{t_c} = \frac{{\bar D}}{{\frac{{{S_D}}}{{\sqrt n }}}} \sim {t_{\left( {\alpha ,\nu } \right)}}
$$

Onde \$\bar D\$ é a média das diferenças e \$S_D\$ é o desvio padrão das diferenças.

> A fim de determinar a eficiência de um medicamento antitérmico, a temperatura corporal (em graus Celsius) de 7 indivíduos foi medida. Em seguida, foi administrado o medicamento e após uma hora a temperatura foi medida novamente.



```r
paired <- 
  import("https://docs.google.com/spreadsheets/d/1JMrkppvv1BdGKVCekzZPsPYCKcgUWjxpuDlWqejc22s/edit#gid=1507821405",
         dec = ",")
paired
```

```
##   INDIVIDUO ANTES DEPOIS DIFERENCA
## 1         1  37.5   36.8      -0.7
## 2         2  36.0   35.4      -0.6
## 3         3  39.0   37.6      -1.4
## 4         4  38.0   37.2      -0.8
## 5         5  37.8   36.9      -0.9
## 6         6  38.5   37.7      -0.8
## 7         7  39.3   38.0      -1.3
```

```r
(mean_dif <- mean(paired$DIFERENCA))
```

```
## [1] -0.9285714
```

```r
(dp_dif <- sd(paired$DIFERENCA))
```

```
## [1] 0.3039424
```

```r
(n <- length(paired$DIFERENCA))
```

```
## [1] 7
```

A estatística de teste é dada por:

$$
{t_c} = \frac{{-0.928 - 0}}{{\frac{{0,3039}}{{\sqrt {7} }}}}
$$
$$
t_c = -8,079
$$



```r
antes <- paired$ANTES
depois <- paired$DEPOIS
t.test(depois, antes, paired = TRUE, var.equal = TRUE)
```

```
## 
## 	Paired t-test
## 
## data:  depois and antes
## t = -8.083, df = 6, p-value = 0.0001921
## alternative hypothesis: true mean difference is not equal to 0
## 95 percent confidence interval:
##  -1.2096712 -0.6474716
## sample estimates:
## mean difference 
##      -0.9285714
```

Note que o mesmo resultado é obtido ao se realizar um teste para uma amostra utilizando a diferença calculada.


```r
t.test(paired$DIFERENCA, var.equal = TRUE)
```

```
## 
## 	One Sample t-test
## 
## data:  paired$DIFERENCA
## t = -8.083, df = 6, p-value = 0.0001921
## alternative hypothesis: true mean is not equal to 0
## 95 percent confidence interval:
##  -1.2096712 -0.6474716
## sample estimates:
##  mean of x 
## -0.9285714
```

