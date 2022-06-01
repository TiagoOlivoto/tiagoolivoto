---
title: Visualização
linktitle: "1. Estatística Descritiva"
toc: true
type: docs
date: "2022/04/22"
draft: false
df_print: paged
code_download: true
menu:
  experimentacao:
    parent: Experimentação
    weight: 2
weight: 1
---

# Pacotes


```r
library(tidyverse)
library(metan)   
```

# Introdução

Nesse material trataremos das medidas de posição e medidas de dispersão mais utilizadas para descrever um conjunto de dados (ou grupos de dados).

# Medidas de posição
Seja uma amostra \$X_1\$, \$X_2\$, \$X_n\$, de uma população \$X_1\$, \$X_2\$, \$X_N\$ de tamanho \$n\$ e \$N\$, definimos a média aritmética por


$$
\mu  = \frac{\displaystyle\sum_{i=1}^{N}X_i}{N}, \quad \textrm{(População)}
$$


$$
\bar{X} = \frac{\displaystyle\sum_{i=1}^{n}X_i}{n}. \quad \textrm{(Amostra)}
$$

Considere a altura (em cm) de cinco plantas de milho, armazenada no objeto `altura`. Para calcular a média destas alturas, utilziamos a função `mean()`. A mediana é calculada com a função `median()`.


```r
altura <- c(245, 250, 269, 280, 262)
# Média
(media <- mean(altura))
```

```
## [1] 261.2
```

```r
# Mediana
# Ordenar os dados
sort(altura)
```

```
## [1] 245 250 262 269 280
```

```r
# Calcular a mediana
(mediana <- median(altura))
```

```
## [1] 262
```


# Medidas de dispersão
## Amplitude
A primeira medida de dispersão que definiremos é a amplitude ou amplitude total, denotada por \$A_p = X_{(max)} - X_{(min)}\$, onde \$X_{(max)}\$ e \$X_{(min)}\$ são os valores máximos e mínimos do conjunto de dados, respectivamente. Os valores extremos podem ser encontrados com a função `range()`.


```r
(extremos <- range(altura))
```

```
## [1] 245 280
```

```r
(amplitude <- extremos[2] - extremos[1])
```

```
## [1] 35
```


## Desvios médios

Considerando uma amostra \$X_1\$, \$X_2\$, \$X_n\$, de uma população \$X_1\$, \$X_2\$, \$X_N\$ de tamanho \$n\$ e \$N\$, a soma dos desvios é dada por

$$
DM  = \sum_{i = 1}^{n} \left(X_i - \bar{X} \right)
$$

Para calcularmos os desvios, basta utilizar o operador `-` no R.

```r
(desvios <- altura - media)
```

```
## [1] -16.2 -11.2   7.8  18.8   0.8
```

Para expressar estes desvios, vamos construir um gráfico utilizando o pacote `ggplot2`.


```r
df <- data.frame(pessoa = paste("Planta", 1:5),
                 altura = altura,
                 altura_media = media,
                 desvio = desvios)

ggplot(df, aes(x = altura, y = pessoa)) +
  geom_point(color = "blue",
             size = 3) +
  geom_segment(aes(x = media,
                   xend = altura,
                   y = pessoa,
                   yend = pessoa)) +
  geom_vline(xintercept = media, linetype = 2, color = "red") +
  geom_text(aes(x = altura, y = pessoa, label = round(desvio, digits = 3),
                hjust = ifelse(desvio < 0, 1.5, -0.5))) +
  scale_x_continuous(limits = c(230, 300)) + 
  theme(panel.grid.minor = element_blank()) +
  labs(x = "Altura da planta (m)",
       y = "Planta")
```

<img src="/classes/experimentacao/01_descritiva_files/figure-html/unnamed-chunk-5-1.png" width="960" />


A expressão anterior resulta em
$$
DM  = \sum_{i = 1}^{n} \left(X_i - \bar{X} \right) = 0
$$

```r
sum(desvios) |> round()
```

```
## [1] 0
```

Isso significa que essa medida não traz ganho algum a descrição dos dados, porque os desvios positivos anulam-se com os desvios negativos no somatório. Para isso, podemos contornar essa situação inserindo uma função modular nessa medida anterior, e criar o módulo do desvio. Assim, o desvio médio é dado por:

$$
S_{|\bar{X}|} = \frac{\sum_{i = 1}^{n} \left|X_i - \bar{X} \right|}{n}
$$


```r
# soma dos desvios em módulo
(somadesv <- desvios |> abs() |> sum())
```

```
## [1] 54.8
```

```r
# desvio médio
somadesv / 5
```

```
## [1] 10.96
```

## Variância

Utilizando uma função quadrática na medida surge uma outra medida de variabilidade que é a soma de quadrados.  A soma de quadrados apresenta uma outra informação interessante que é penalizar as observações quanto mais estiver distante do valor central. Assim, quando elevamos ao quadrado um alto desvio, esse valor se torna maior ainda, mas quando elevamos ao quadrado um desvio pequeno, esse valor não cresce tanto. Com isso, conseguimos compreender quais os dados que estão mais dispersos em torno da média. Ao dividir a soma de quadrados por \$n-1\$ temos o estimador da variância amostral (\$S^2\$), dado por:

$$
S^2 = \frac{\sum_{i = 1}^{n} \left(X_i - \bar X_i \right)^2}{n-1}
$$


```r
# Desvios ao quadrado
(desvq <- desvios ^ 2)
```

```
## [1] 262.44 125.44  60.84 353.44   0.64
```

```r
# soma dos desvios ao quadrado
(somadesvq <- sum(desvq))
```

```
## [1] 802.8
```

```r
# divisão por n - 1
(var_altura <- somadesvq / 4)
```

```
## [1] 200.7
```

Anteriormente, vimos o passo a passo para o cálculo da variância amostral. No R, a função `var()` pode ser utilizada para este fim.


```r
var(altura)
```

```
## [1] 200.7
```


## Desvio padrão

A variância, como medida de dispersão, apresenta sua unidade ao quadrado da unidade da variável em estudo. Em outras palavras, que se tivermos usando uma variável na escala de centímetros (ex., algura), a dispersão dada pela variância estará na escala de área (cm\$^2\$). Isso se torna difícil a percepção de dispersão quando observamos os dados. Para contornar isso, utilizamos o desvio padrão, que é a raíz quadrada da variância, dado por

$$
S = \sqrt{S^2}
$$

Para o exemplo acima, computamos o desvio padrão extraíndo a raíz de `var_altura`, ou, como para a variância, utilizando uma função específica do R para isso: `sd()` (de `s`tandard `d`eviation).


```r
(desv_altura <- sqrt(var_altura))
```

```
## [1] 14.16686
```

```r
# utilizando a função sd()
sd(altura)
```

```
## [1] 14.16686
```


## Coeficiente de variação

As medidas de variabilidade tais como a variância e desvio padrão, são conhecidas como medidas de dispersão absoluta. Isto significa que elas serão diretamente influenciadas pela magnitude da variável. Vamos tomar como motivação, os valores em `altura`, tomados em cm. Consideremos que estes dados são transformados para metros, por tanto, cada observação será dividida por 100. Observe abaixo o resultado do desvio padrão da mesma variável, mas com escala diferente.


```r
(altura_m <- altura / 100)
```

```
## [1] 2.45 2.50 2.69 2.80 2.62
```

```r
(desv_altura_m <- sd(altura_m))
```

```
## [1] 0.1416686
```

Para contornar este problema, podemos utilizar uma medida relativa de variabilidade chamada de Coeficiente de Variação (CV). Este pode ser usada para comparar a variabilidade entre quaisquer grupo de dados, independentemente da sua escala.  O coeficiente de variação é definido por:

$$
CV = \frac{S}{\bar{X}} \times 100
$$


```r
# coeficiente de variação da variável em centímetros
(cv_altura <- desv_altura / media * 100)
```

```
## [1] 5.423761
```

```r
# coeficiente de variação da variável em metros
(cv_altura2 <- desv_altura_m / mean(altura_m) * 100)
```

```
## [1] 5.423761
```

Não existe no R base uma função para computar o coeficiente de variação, então vamos criá-la utilizando a abordagem `function()`.


```r
CV <- function(dados){
  if(!class(dados) == "numeric"){
    stop("Os dados precisam ser numéricos")
  } #Indica que os dados devem ser numéricos
  media <- mean(dados)
  sd <- sd(dados)
  CV <- (sd/media) * 100
  return(CV) # Valor que será retornado pela função
}

CV(altura)
```

```
## [1] 5.423761
```


## Erro padrão da média

O erro padrão da média é a estimativa do desvio padrão de sua distribuição amostral. O desvio padrão visto anteriormente reflete a variabilidade de cada observação em torno da média amostral. Já o erro padrão da média, representa a variabilidade de cada média amostral de todas amostra possíveis, em relação a média populacional. Sua estimativa é dada por:

$$
S_{\bar{X}}  = \frac{S}{\sqrt{n}}
$$

É fácil observar que à medida que \$n \to N\$, isto é, à medida que  
\$n\$ aumenta, a média amostral ($\bar X$) tende a média populacional ($\mu$). Isso significa que a média amostral é mais precisa porque se aproxima cada vez mais da média populacional. Para os dados em `altura`, o erro padrão da média é calculado com:


```r
(epm <- desv_altura / sqrt(5))
```

```
## [1] 6.335614
```

# Aplicação utilizando o pacote metan
## Exemplo da altura de planta
Para calcular todas as estatísticas de uma só vez, podemos usar `desc_stat()` do pacote metan. Esta função pode ser usada para calcular medidas de tendência central, posição e dispersão. Por padrão (`stats = "main"`), sete estatísticas (coeficiente de variação, máximo, média, mediana, mínimo, desvio padrão da amostra, erro padrão e intervalo de confiança da média) são calculadas. Outros valores permitidos são `"all"` para mostrar todas as estatísticas, `"robust"` para mostrar estatísticas robustas, `"quantile"` para mostrar estatísticas quantílicas ou escolher uma (ou mais) estatísticas usando um vetor separado por vírgula com os nomes das estatísticas, por exemplo, `stats = c("mean, cv")`. Também podemos usar `hist = TRUE` para criar um histograma para cada variável. Para mais detalhes consulte [este material](https://tiagoolivoto.github.io/e-bookr/analdata.html#ebasic).



```r
library(metan)
desc_stat(altura, stats = "all") |> as.data.frame()
```

```
##   variable av.dev    ci.t    ci.z     cv    gmean    hmean iqr    kurt     mad
## 1      val  10.96 17.5905 12.4176 5.4238 260.8937 260.5887  19 -1.3829 17.7912
##   max  mean median min n n.valid n.missing n.unique      ps  q2.5 q25 q75 q97.5
## 1 280 261.2    262 245 5       5         0        5 14.0741 245.5 250 269 278.9
##   range  sd.amo  sd.pop     se   skew  sum sum.dev ave.dev sum.sq.dev var.amo
## 1    35 14.1669 12.6712 6.3356 0.2144 1306    54.8   10.96      802.8   200.7
##   var.pop
## 1  160.56
```

```r
# estatísticas vistas neste material
desc_stat(altura,
          stats = c("mean, median, range, ave.dev, var.amo, sd.amo, cv, se")) |> 
  as.data.frame()
```

```
##   variable  mean median range ave.dev var.amo  sd.amo     cv     se
## 1      val 261.2    262    35   10.96   200.7 14.1669 5.4238 6.3356
```


## Exemplo com os dados coletados em aula
Neste exemplo, mostro como as estatísticas descritivas para os dados coletados em aula podem ser calculadas utilizando o pacote `metan`. Os dados são importados diretamente da planilha armazenada no drive, utilizando a função `import()` do pacote `rio`.


```r
library(rio)

# link dos dados
link <- "https://docs.google.com/spreadsheets/d/1JMrkppvv1BdGKVCekzZPsPYCKcgUWjxpuDlWqejc22s/edit#gid=463165208"

# função para importar os dados
df <- 
  import(link) |> 
  as_character(1:3) # primeiras 3 colunas como caracteres

# estrutura dos dados 
str(df)
```

```
## 'data.frame':	160 obs. of  5 variables:
##  $ Grupo           : chr  "Grupo 1" "Grupo 1" "Grupo 1" "Grupo 1" ...
##  $ Tipo            : chr  "Folha" "Folha" "Folha" "Folha" ...
##  $ Amostra         : chr  "1" "2" "3" "4" ...
##  $ Comprimento     : num  14 9.4 12.1 12.2 12 12.5 11.4 7.5 9.8 14.5 ...
##  $ Largura_Diametro: num  6.4 6.41 6.42 6.43 6.44 6.45 6.46 6.47 6.48 6.49 ...
```

```r
# primeiras linhas
head(df)
```

```
##     Grupo  Tipo Amostra Comprimento Largura_Diametro
## 1 Grupo 1 Folha       1        14.0             6.40
## 2 Grupo 1 Folha       2         9.4             6.41
## 3 Grupo 1 Folha       3        12.1             6.42
## 4 Grupo 1 Folha       4        12.2             6.43
## 5 Grupo 1 Folha       5        12.0             6.44
## 6 Grupo 1 Folha       6        12.5             6.45
```

Os dados foram organziados de maneira que cada fator (grupo e tipo de amostra) estivessem em uma coluna. Isto possibilita o cálculo das estatísticas para cada nível destes fatores. As duas variáveis quantitativas contínuas são: `Comprimento` (o comprimento da folha em cm e o comprimento do grão em mm); e `Largura_diametro` (a largura da folha em cm e o diâmetro do grão em mm). 


### Estatísticas gerais
Para saber as estatísticas descritivas gerais (sem estratificação por grupo), vamos utilizar a função `group_by()` para agrupar por `Tipo`. Com isso, as estatísticas serão calculadas separadamente para `Folha` e `Grao`. Por padrão, a função calcula as estatísticas descritivas para todas as variáveis numéricas do conjunto de dados. Sendo assim, não há necessidade de informar qual variável analisar.



```r
stats = c("mean, median, range, ave.dev, var.amo, sd.amo, cv, se, n")
df |> 
  group_by(Tipo) |> 
  desc_stat(stats = stats)
```

```
## # A tibble: 4 × 11
##   Tipo  variable      mean median range ave.dev var.amo sd.amo    cv    se     n
##   <chr> <chr>        <dbl>  <dbl> <dbl>   <dbl>   <dbl>  <dbl> <dbl> <dbl> <dbl>
## 1 Folha Comprimento  12.2   12.1  13      2.23    8.33   2.89   23.7 0.382    57
## 2 Folha Largura_Dia…  6.16   6.5   1.81   0.605   0.462  0.680  11.0 0.09     57
## 3 Grao  Comprimento  13.5   12.4  24      3.34   23.9    4.89   36.3 0.482   103
## 4 Grao  Largura_Dia…  9.53   9.59 18      2.37   11.4    3.38   35.4 0.333   103
```

### Estatísticas por grupo

Para obter as estatística para cada grupo, basta adicionar o fator `Grupo` na função `group_by()` e realizar o mesmo comando mostrado acima.


```r
df |> 
  group_by(Grupo, Tipo) |> 
  desc_stat(stats = stats)
```

```
## # A tibble: 20 × 12
##    Grupo  Tipo  variable  mean median range ave.dev var.amo sd.amo     cv     se
##    <chr>  <chr> <chr>    <dbl>  <dbl> <dbl>   <dbl>   <dbl>  <dbl>  <dbl>  <dbl>
##  1 Grupo… Folha Comprim… 11.7   12.2   7     1.43    3.79   1.95   16.7   0.562 
##  2 Grupo… Folha Largura…  6.46   6.46  0.11  0.03    0.0013 0.0361  0.559 0.0104
##  3 Grupo… Grao  Comprim… 14.3   14.2   4.21  1.05    1.77   1.33    9.28  0.384 
##  4 Grupo… Grao  Largura… 10.8   10.2   3.9   1.04    1.81   1.35   12.4   0.388 
##  5 Grupo… Folha Comprim… 11.7   12.2   5.5   2       5.97   2.44   20.9   0.997 
##  6 Grupo… Folha Largura…  5.32   5.32  0.05  0.015   0.0003 0.0187  0.351 0.0076
##  7 Grupo… Grao  Comprim… 12.9   12.7   6.89  1.57    3.60   1.90   14.7   0.359 
##  8 Grupo… Grao  Largura…  9.75   9.37  5.36  1.23    2.06   1.44   14.7   0.271 
##  9 Grupo… Folha Comprim…  9.77  10     7.5   2.07    6.57   2.56   26.2   0.773 
## 10 Grupo… Folha Largura…  5.05   5.05  0.1   0.0273  0.0011 0.0332  0.657 0.01  
## 11 Grupo… Grao  Comprim… 10.5   10     8     1.75    4.37   2.09   19.9   0.348 
## 12 Grupo… Grao  Largura…  6.56   6.5   7     1.17    2.14   1.46   22.3   0.244 
## 13 Grupo… Folha Comprim… 13.1   12.8   8.6   2.02    6.40   2.53   19.3   0.632 
## 14 Grupo… Folha Largura…  6.58   6.58  0.15  0.04    0.0023 0.0476  0.724 0.0119
## 15 Grupo… Grao  Comprim… 18.2   15.4  21     7.65   70.0    8.37   45.9   1.87  
## 16 Grupo… Grao  Largura… 13.5   10.5  11     3.88   18.2    4.27   31.6   0.954 
## 17 Grupo… Folha Comprim… 13.9   15.3  10.4   2.42   10.3    3.21   23.0   0.927 
## 18 Grupo… Folha Largura…  6.76   6.76  0.11  0.03    0.0013 0.0361  0.534 0.0104
## 19 Grupo… Grao  Comprim… 16     16     4     0.857   1.67   1.29    8.07  0.488 
## 20 Grupo… Grao  Largura… 10.3   10     2     0.612   0.571  0.756   7.35  0.286 
## # … with 1 more variable: n <dbl>
```



# Simulação de dados com diferentes variâncias

O código a seguir apresenta uma simulação de três grupos com 10 observações cada um. Os grupos formados são A, B e C, todos com média `9,018686`.


```r
# Dados dos grupos gerados
set.seed(10) # assegura a reprodutibilidade
A <- rnorm(10, mean = 10, sd = 2)
set.seed(10)
B <- rnorm(9, mean = 10, sd = 4)
set.seed(10)
C <- rnorm(9, mean = 10, sd = 6)

# gerando B[10]
B[10] <-  length(A) * mean(A) - sum(B)
# gerando C[10]
C[10] <- length(A) * mean(A) - sum(C)

dados <- 
  data.frame(grupo = c(rep("A", 10),
                       rep("B", 10),
                       rep("C", 10)),
             valor = c(A, B, C))

dados
```

```
##    grupo      valor
## 1      A 10.0374923
## 2      A  9.6314949
## 3      A  7.2573389
## 4      A  8.8016646
## 5      A 10.5890903
## 6      A 10.7795886
## 7      A  7.5838476
## 8      A  9.2726480
## 9      A  6.7466546
## 10     A  9.4870432
## 11     B 10.0749847
## 12     B  9.2629898
## 13     B  4.5146778
## 14     B  7.6033291
## 15     B 11.1781805
## 16     B 11.5591772
## 17     B  5.1676953
## 18     B  8.5452959
## 19     B  3.4933093
## 20     B 18.7872234
## 21     C 10.1124770
## 22     C  8.8944847
## 23     C  1.7720167
## 24     C  6.4049937
## 25     C 11.7672708
## 26     C 12.3387658
## 27     C  2.7515429
## 28     C  7.8179439
## 29     C  0.2399639
## 30     C 28.0874035
```

Utilizando a função `means_by()` do pacote metan é possível computar médias por grupos.

```r
# calcular a média por grupo
means_by(dados, grupo) |> as.data.frame()
```

```
##   grupo    valor
## 1     A 9.018686
## 2     B 9.018686
## 3     C 9.018686
```

Dessa forma, poderíamos concluir que os grupos de dados são iguais? A resposta é não. Isso significa, que essa medida de posição apenas não consegue caracterizar completamente os grupos de dados. Para isto, medidas de dispersão são necessárias. Note no exemplo abaixo, como as medidas de dispersão diferem consideravelmente entre os grupos!



```r
desc_stat(dados,
          by = grupo,
          stats = c("mean, median, range, ave.dev, var.amo, sd.amo, cv, se"))
```

```
## # A tibble: 3 × 10
##   grupo variable  mean median range ave.dev var.amo sd.amo    cv    se
##   <chr> <chr>    <dbl>  <dbl> <dbl>   <dbl>   <dbl>  <dbl> <dbl> <dbl>
## 1 A     valor     9.02   9.38  4.03    1.14    1.96   1.40  15.5 0.443
## 2 B     valor     9.02   8.90 15.3     3.15   19.5    4.42  49.0 1.40 
## 3 C     valor     9.02   8.36 27.8     5.25   62.3    7.89  87.5 2.50
```

Isto fica mais facilmente notado ao criarmos um gráfico do tipo boxplot, contendo a dispersão dos dados.


```r
library(ggstatsplot)
```

```
## You can cite this package as:
##      Patil, I. (2021). Visualizations with statistical details: The 'ggstatsplot' approach.
##      Journal of Open Source Software, 6(61), 3167, doi:10.21105/joss.03167
```

```r
ggbetweenstats(dados,
               x = grupo,
               y = valor,
               plot.type = "box",
               pairwise.comparisons = FALSE,
               results.subtitle = FALSE,
               k = 4)
```

<img src="/classes/experimentacao/01_descritiva_files/figure-html/unnamed-chunk-22-1.png" width="768" />


