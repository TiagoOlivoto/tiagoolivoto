---
title: Visualização
linktitle: "5. Visualização de dados"
toc: true
type: docs
date: "2022/03/15"
draft: false
df_print: paged
code_download: true
menu:
  experimentacao:
    parent: Experimentação
    weight: 6
weight: 5
---

# Pacotes
Para reprodução destes exemplos, os seguintes pacotes são necessários:


```r
# pacotes para criação de mapas (github)
remotes::install_github("ropensci/rnaturalearthhires")
remotes::install_github("ricardo-bion/ggradar")
```

Antes de carregar, verifique se o pacote está instalado.


```r
library(tidyverse)
## ── Attaching packages ─────────────────────────────────────── tidyverse 1.3.1 ──
## ✔ ggplot2 3.3.6     ✔ purrr   0.3.4
## ✔ tibble  3.1.7     ✔ dplyr   1.0.9
## ✔ tidyr   1.2.0     ✔ stringr 1.4.0
## ✔ readr   2.1.2     ✔ forcats 0.5.1
## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
## ✖ dplyr::filter() masks stats::filter()
## ✖ dplyr::lag()    masks stats::lag()
library(metan)   
## Registered S3 method overwritten by 'GGally':
##   method from   
##   +.gg   ggplot2
## |=========================================================|
## | Multi-Environment Trial Analysis (metan) v1.16.0        |
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
library(rio)
library(ggridges)
library(rnaturalearth)
library(ggradar)
library(lubridate)
## 
## Attaching package: 'lubridate'
## The following objects are masked from 'package:base':
## 
##     date, intersect, setdiff, union
```

# Dados
## Grãos de café
Os dados contidos na aba `graos` do arquivo [`Atividade caracteres qualitativos e quantitativos`](https://docs.google.com/spreadsheets/d/1JMrkppvv1BdGKVCekzZPsPYCKcgUWjxpuDlWqejc22s/edit#gid=2073179916) serão utilizados. Este arquivo contém dados do comprimento e largura de grãos e folhas de café, amostrados na primeira aula de Bioestatística da turma 2022/01. Para carregar estes dados, utilizamos o seguinte comando.




```r
url <- "https://docs.google.com/spreadsheets/d/1JMrkppvv1BdGKVCekzZPsPYCKcgUWjxpuDlWqejc22s/edit#gid=2073179916"
df <- 
  import(url, dec = ",") |> 
  as_factor(1:3)
head(df)
```

```
##     grupo individuo      cor comprimento largura
## 1 Grupo 1         1 vermelho       13.49   16.61
## 2 Grupo 1         2 vermelho       11.08   14.23
## 3 Grupo 1         3 vermelho       13.35   15.93
## 4 Grupo 1         4 vermelho        9.87   14.10
## 5 Grupo 1         5    verde       11.61   16.11
## 6 Grupo 1         6    verde        9.86   13.87
```

## Dados da estação meteorológica


```r
url2 <- "https://docs.google.com/spreadsheets/d/1JMrkppvv1BdGKVCekzZPsPYCKcgUWjxpuDlWqejc22s/edit#gid=764890920"
df_estacao <-  
  import(url2, setclass = "tbl", dec = ",") |> 
  as_character(1:4) |> 
  mutate(dia = dmy(dia))
head(df_estacao)
```

```
## # A tibble: 6 × 14
##   dia        d     m     hora   prec  tmax  tmed  tmin urmax urmed urmin dirvent
##   <date>     <chr> <chr> <chr> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>   <dbl>
## 1 2022-01-01 1     1     00:00     0  21.2  20.6  20.2   100  99.5  99.0     0  
## 2 2022-01-01 1     1     01:00     0  20.5  19.8  19.4   100  99.9  99.6     0  
## 3 2022-01-01 1     1     02:00     0  19.7  19.4  19     100 100    99.9     0  
## 4 2022-01-01 1     1     03:00     0  20.0  19.2  18.7   100 100   100       0  
## 5 2022-01-01 1     1     04:00     0  20.5  20.2  19.8   100 100   100       0  
## 6 2022-01-01 1     1     05:00     0  20.7  20.2  19.9   100 100   100      79.8
## # … with 2 more variables: velvent <dbl>, rajada <dbl>
```

# Gráficos

> "O gráfico simples trouxe mais informações à mente do analista de dados do que qualquer outro dispositivo." --- John Tukey


## O pacote `ggplot2`

O `ggplot2` é um pacote R para produção de gráficos que diferentemente da maioria dos outros pacotes, apresenta uma profunda gramática baseada no livro *The grammar of graphics* (Wilkinson 2005)[^1]. Os gráficos originados em `ggplot2` são baseados em camadas, e cada gráfico tem três componentes chave: `data`, os dados de onde o gráfico será criado; `aes()` (*aesthetic mappings*), que controla o mapeamento estético e as propriedades visuais do gráfico; e ao menos uma camada que irá descrever como cada observação será renderizada. Camadas são usualmente criadas utilizando uma função `geom_()`.

[^1]: WICKHAM, H. **Ggplot2 : elegant graphics for data analysis**: Springer, 2009.

## Meu primeiro gráfico em `ggplot2`

A seguir, vamos discutir os aspcetos básicos para a construção de gráficos utilizando o pacote `ggplot2`. A função `arrange_ggplot()` do pacote `metan` foi utilizada aqui para organizar os gráficos em forma de painéis.


## As camadas de um gráfico `ggplot2`

No `ggplot2`, os gráficos são construídos camada por camada (ou, *layers*, em inglês). Neste exemplo, vamos confeccionar um gráfico mostrando a distribuição do comprimento da folha (eixo `x`) e largura da folha (eixo `y`).


```r
p1 <- 
  ggplot(df, aes(x = comprimento, y = largura)) +
  geom_point()
```

Este comando criou um gráfico e armazenou no objeto `p1`, que será plotado posteriormente. Observe que o primeiro argumento da função é o data frame onde nossos dados foram armazenados. A função `aes()` descreve como as variáveis são mapeadas (neste caso `comprimento` no eixo `x` e `largura` no eixo `y`). A função `geom_point()` definiu que a forma geométrica a ser utilizada é baseada em pontos, gerando, assim, um gráfico de dispersão. Isto é tudo que precisa ser feito para a confecção de um gráfico simples.

## Aesthetics (estética)

> "O maior valor de uma imagem é quando ela nos obriga a perceber o que nunca esperamos ver." --- John Tukey

Alterar a estética dos gráficos `ggplot2` é uma tarefa relativamente simples. No gráfico anterior, os valores do `comprimento` e `largura` foram plotados sem nenhum tipo de mapeamento estético. Digamos que marcadores com diferentes cores para cada nível do fator `cor` poderia nos ajudar a compreender melhor o padrão presente em nossos dados. Vamos confeccionar este gráfico.


```r
p2 <- 
  ggplot(df, aes(x = comprimento, y = largura, colour = cor)) +
  geom_point()
p2
```

<div class="figure" style="text-align: center">
<img src="/classes/experimentacao/05_visualizacao_files/figure-html/unnamed-chunk-6-1.png" alt="Gráfico de dispersão padrão (p1) e com pontos mapeados por cores para cada nível do fator 'DAP' (p2)." width="768" />
<p class="caption">Figure 1: Gráfico de dispersão padrão (p1) e com pontos mapeados por cores para cada nível do fator 'DAP' (p2).</p>
</div>

Ao incluirmos `colour = cor` dentro da função `aes`, dizemos ao `ggplot` que os pontos devem ser mapeados esteticamente (neste caso utilizando cores) para cada nível do fator `cor` presente em nossos dados. Digamos que em vez de utilizar diferentes cores, a cor do grão do café deveria ser representada por diferentes tipos de marcadores (quadrados, triângulo, etc.) Neste caso, o argumento `colour = cor` é substituído por `shape = cor`.


```r
p3 <- 
  ggplot(df, aes(x = comprimento, y = largura, shape = cor)) +
  geom_point()

# organizar os gráficos
arrange_ggplot(p1, p2, p3,
               ncol = 3,
               tag_levels = list(c("p1", "p2", "p3")))
```

<div class="figure" style="text-align: center">
<img src="/classes/experimentacao/05_visualizacao_files/figure-html/unnamed-chunk-7-1.png" alt="Gráfico de dispersão padrão (p1) e com pontos mapeados por cores (p2) e marcadores (p3) para cada nível do fator 'cor'." width="960" />
<p class="caption">Figure 2: Gráfico de dispersão padrão (p1) e com pontos mapeados por cores (p2) e marcadores (p3) para cada nível do fator 'cor'.</p>
</div>

## Facet (facetas)

Mapeando os diferentes níveis de `cor` para diferentes cores, incluímos em um único gráfico os dados de todos osgrupos. Mas, e se nosso objetivo fosse realizar um gráfico para cada grupo? O `ggplot2` tem uma poderosa ferramenta para isto: as funções `facet_`. Ao utilizar estas funções, o conjunto de dados é subdividido e um gráfico é construído para cada um destes subconjuntos. Vamos ver como elas podem nos ajudar em nosso problema.


```r
fac1 <- 
  ggplot(df, aes(x = comprimento, y = largura, color = cor)) +
  geom_point() +
  facet_wrap(~ grupo)
fac1
```

<div class="figure">
<img src="/classes/experimentacao/05_visualizacao_files/figure-html/unnamed-chunk-8-1.png" alt="Um painel para cada nível da variável DAP" width="960" />
<p class="caption">Figure 3: Um painel para cada nível da variável DAP</p>
</div>

Neste exemplo, um gráfico completamente diferente do anterior é gerado com apenas uma simples adição: incluímos uma nova função, `facet_wrap(~ grupo)`. Neste caso, informamos que um gráfico deveria ser realizado para cada grupo.

## Theme (temas)

Cada gráfico criado com a função `ggplot()` tem um tema padrão. *Tema*, aqui, é toda propriedade relacionada ao aspecto visual do gráfico, que não foi definida na função `aes()` e que pode ser modificada utilizando a função `theme()` (veja `?theme`). O `ggplot2` já conta com alguns temas personalizados para facilitar nosso trabalho. Considerando o exemplo anterior, vamos utilizar a função `theme_bw()` (preto e branco) e a função `theme()` para modificar as propriedades visuais do gráfico.


```r
fac2 <- 
  ggplot(df, aes(x = comprimento, y = largura, color = cor)) +
  geom_point() +
  facet_wrap(~ grupo) +
  theme_light() +
  theme(panel.grid.minor = element_blank(), # remove as linhas do corpo do gráfico
        # sem bordas entre os painéis
        panel.spacing = unit(0, "cm"),
        # modifica o texto dos eixos
        axis.text = element_text(size = 12, colour = "black"),
        # cor dos marcadores
        axis.ticks = element_line(colour = "black"),
        # tamanho dos marcadores
        axis.ticks.length = unit(.2, "cm"), 
        #cor da borda
        panel.border = element_rect(colour = "black", fill = NA, size = 0.5))+
  # título dos eixos
  labs(x = "Comprimento do grão (mm)", # título do eixo x
       y = "Largura do grão (mm)", # título do eixo y
       color = "Cor do grão") # título da legenda

arrange_ggplot(fac1, fac2, tag_levels = list(c("f1", "f2")))
```

<div class="figure" style="text-align: center">
<img src="/classes/experimentacao/05_visualizacao_files/figure-html/unnamed-chunk-9-1.png" alt="Gráfico de dispersão considerando a confecção de um gráfico para cada nível de um fator(f1) e modificações na propriedades do tema de um gráfico ggplot2 (f2) " width="768" />
<p class="caption">Figure 4: Gráfico de dispersão considerando a confecção de um gráfico para cada nível de um fator(f1) e modificações na propriedades do tema de um gráfico ggplot2 (f2) </p>
</div>

Os argumentos inseridos dentro das função `theme()` modificaram a aparência do nosso gráfico. Inúmeros outros argumentos são disponíveis, fazendo com que os gráficos originados sejam completamente personalizáveis. Digamos que precisamos confeccionar diversos gráficos e gostaríamos de manter o mesmo tema do gráfico acima. Seria exaustivo e desinteressante informar cada vez estes argumentos para cada gráfico, não? Felizmente, outra poderosa ferramenta proporcionada pelo `ggplot2` é a possibilidade de confeccionarmos nossos próprios temas. Para isto, vamos executar o seguinte comando para criar um tema personalizado (`my_theme()`). Este tema pode então ser aplicado como uma camada adicional a cada gráfico que confecionarmos. Para evitar a necessidade da inclusão deste tema em cada gráfico gerado, iremos definir este tema como padrão utilizando a função `theme_set()`.


```r
my_theme <- function () {
  theme_light() %+replace% # permite que os valores informados possam ser sobescritos
    theme(axis.ticks.length = unit(.2, "cm"),
          axis.text = element_text(size = 12, colour = "black"),
          axis.title = element_text(size = 12, colour = "black"),
          axis.ticks = element_line(colour = "black"),
          panel.border = element_rect(colour = "black", fill = NA, size = 0.5),
          panel.grid.minor =  element_blank())
}
theme_set(my_theme())
```

## Geoms (geometria)

As funções `geom_` definem qual forma geométrica será utilizada para a visualização dos dados no gráfico. Até agora, utilizamos a função `geom_point()`para construir gráficos de dispersão. Basicamente, qualquer outro tipo de gráfico pode ser criado dependendo da função `geom_` utilizada. Dentre as diversas disponíveis no pacote `ggplot2` as funções `geom_` mais utilizadas são:

-   `geom_abline()`: para retas definidas por um intercepto e uma inclinação;
-   `geom_hline()`: para retas horizontais definidas por um intercept `y`;
-   `geom_vline()`: para retas verticais definidas por um intercept `x`;
-   `geom_boxplot()`: para boxplots;
-   `geom_histogram()`: para histogramas de frequência;
-   `geom_smooth()`: ajusta uma função para o conjunto de dados e mostra uma banda de confiança;
-   `geom_density()`: para densidades;
-   `geom_area()`: para áreas;
-   `geom_bar()`: para barras;
-   `geom_errorbar()` para barras de erro;

Deste ponto em diante, vamos confeccionar alguns exemplos utilizando algumas destas funções (ou combinações destas funções) incluindo argumentos de mapeamento de estética e temas vistos até agora.

### Linhas horizontais, verticais e diagonais

Três importantes geometrias são apresentadas a seguir:

1.   `geom_hline()` adiciona uma linha horizontal definida por um intercepto em `y`

2.  `geom_vline()` adiciona uma linha vertical definida por um intercepto em `x`.

3.  `geom_abline()` adiciona uma linha diagonal definida por um intercepto e uma inclinação.



```r
g1 <- 
  ggplot(df, aes(comprimento, largura)) +
  geom_point()

# adiciona linhas horizontais e verticais
g2 <- 
  g1 +
  geom_hline(yintercept = mean(df$largura), color = "blue") +
  geom_vline(xintercept = mean(df$comprimento), color = "red")




arrange_ggplot(g1, g2,
               tag_levels = list(c("g1", "g2")))
```

<img src="/classes/experimentacao/05_visualizacao_files/figure-html/unnamed-chunk-11-1.png" width="960" />

### Gráficos do tipo boxplot


```r
box1 <- 
  ggplot(df, aes(grupo, comprimento)) +
  geom_boxplot()

box2 <- 
  ggplot(df, aes(grupo, comprimento)) +
  geom_boxplot() +
  geom_jitter(width = 0.1, color = "salmon")

box3 <- 
  ggplot(df, aes(grupo, comprimento, fill = cor)) +
  geom_boxplot(width = 0.3) + 
  labs(x = "Grupo",
       y = "Comprimento do grão (mm)") +
  scale_fill_manual(values = c("green", "red"))

arrange_ggplot((box1 + box2) / box3,
               tag_levels = list(c("b1", "b2", "b3")))
```

<div class="figure" style="text-align: center">
<img src="/classes/experimentacao/05_visualizacao_files/figure-html/unnamed-chunk-12-1.png" alt="Gráfico do tipo boxplot combinando mapeamentos estéticos." width="864" />
<p class="caption">Figure 5: Gráfico do tipo boxplot combinando mapeamentos estéticos.</p>
</div>

Cinco estatísticas são mostradas neste boxplot. A mediana (linha horizontal), as caixas inferior e superior (primeiro e terceiro quartil (percentis 25 e 75, respectivamente)). A linha vertical superior se estende da caixa até o maior valor, não maior que \$1,5 \times {IQR}\$ (onde IQR é a amplitude interquartílica). A linha vertical inferior se estende da caixa até o menor valor, de no máximo, \$1,5 \times {IQR}\$. Dados além das linhas horizontais podem ser considerados *outliers*.

### Gráficos do tipo histograma
Neste exemplo, utilizaremos os dados de temperatura mínima da estação meteorológica, disponível no data frame `df_estacao`. O primeiro histograma (p1) mostra os dados gerais desde 01/01/2022. No segundo,  um histograma é gerado para cada mês.


```r
h1 <- 
  ggplot(df_estacao, aes(x = tmed)) +
  geom_histogram()


h2 <- 
  ggplot(df_estacao, aes(x = tmed)) +
  geom_histogram(color = "black",
                 fill = "skyblue") +
  facet_wrap(~m) +
  labs(x = "Temperatura mínima",
       y = "Horas")

arrange_ggplot(h1, h2,
               widths = c(1, 1.4),
               tag_levels = list(c("h1", "h2")))
```

<div class="figure" style="text-align: center">
<img src="/classes/experimentacao/05_visualizacao_files/figure-html/unnamed-chunk-13-1.png" alt="Gráfico do tipo histograma " width="672" />
<p class="caption">Figure 6: Gráfico do tipo histograma </p>
</div>

No histograma (h2), a linha vermelha representa a estimativa da função de probabilidade normal. Para isto, a escala do eixo `y` foi mudada de contagem para densidade.


### Gráficos de Densidade
Os gráficos de densidade, têm a mesma interpretação que histogramas, no então são esteticamente mais atraente. Os primeiros dois exemplos nada mais são que a versão densidade dos histogramas apresentados anteriormente.

No terceiro exemplo (d3), eu mostro como é possível construir um gráfico de densidade `ridges`. Gráficos `ridges` são gráficos de linha parcialmente sobrepostos que criam a impressão de uma cordilheira. Eles podem ser bastante úteis para visualizar mudanças nas distribuições ao longo do tempo ou espaço[^2].

[^2]: https://cran.r-project.org/web/packages/ggridges/vignettes/introduction.html


```r
d1 <- 
  ggplot(df_estacao, aes(x = tmed)) +
  geom_density()

d2 <- 
  ggplot(df_estacao, aes(x = tmed)) +
  geom_density(color = "black",
               fill = "skyblue") +
  facet_wrap(~m) +
  labs(x = "Temperatura média (ºC)",
       y = "Horas")

d3 <- 
  ggplot(df_estacao, aes(x = tmed, y = m, fill = stat(x))) +
  geom_density_ridges_gradient() +
  scale_fill_viridis_c() +
  labs(x = "Temperatura média (ºC)",
       y = "Meses do ano",
       fill = "Temperatura\nmédia (ºC)")

arrange_ggplot(d1, d2, d3,
               widths = c(1, 2, 2),
               tag_levels = list(c("d1", "d2", "d3")))
```

<div class="figure" style="text-align: center">
<img src="/classes/experimentacao/05_visualizacao_files/figure-html/unnamed-chunk-14-1.png" alt="Gráfico do tipo densidade " width="960" />
<p class="caption">Figure 7: Gráfico do tipo densidade </p>
</div>

### Gráficos de linhas

O seguinte exemplo mostra a temperatura mínima, média e máxima ao longo dos dias desde 01/01/2022.

Primeiro, é preciso obter as temperaturas mínimas, máximas e médias de cada dia. Fazemos isso com a função `summarise()`.


```r
clima_max_min <-
  df_estacao %>%
  group_by(dia) %>% 
  summarise(max = max(tmax),
            min = min(tmin),
            mean = mean(tmed),
            precip = sum(prec)) %>% 
  pivot_longer(-dia)
clima_max_min
```

```
## # A tibble: 628 × 3
##    dia        name   value
##    <date>     <chr>  <dbl>
##  1 2022-01-01 max     28.7
##  2 2022-01-01 min     18  
##  3 2022-01-01 mean    24.0
##  4 2022-01-01 precip   0  
##  5 2022-01-02 max     31.8
##  6 2022-01-02 min     23.4
##  7 2022-01-02 mean    27.1
##  8 2022-01-02 precip   0  
##  9 2022-01-03 max     32.4
## 10 2022-01-03 min     24.3
## # … with 618 more rows
```




```r
clima_max_min |> 
  subset(name != "precip") |> 
  ggplot(aes(dia, value, color = name)) +
  geom_point() + 
  geom_line() + 
  scale_color_manual(values = c("red", "green", "blue"),
                     labels = c("Temperatura máxima (ºC)",
                                "Temperatura média (ºC)",
                                "Temperatura mínima (ºC)"),
                     guide = "legend") + 
  scale_x_date(date_breaks = "2 week", # marcação a cada duas semanas
               date_labels = "%d/%m/%y") + # formato dd/mm/aa
  theme(legend.position = "bottom") + 
  labs(title = "Temperaturas máximas, médias e mínimas em 2022",
       subtitle = "Estação - Fazenda Ressacada",
       caption = "Elaboração: Prof. Olivoto",
       x = "Dia do ano",
       y = "Temperatura (ºC)",
       color = NULL) # remove o título da legenda
```

<img src="/classes/experimentacao/05_visualizacao_files/figure-html/unnamed-chunk-16-1.png" width="672" />


### Gráficos do tipo barra
No seguinte exemplo, os dados do comprimento do grão de café disponíveis em `df` são utilizados.

```r
bar1 <- 
  ggplot(df, aes(x = grupo, y = comprimento)) +
  geom_bar(stat = "summary")

bar2 <- 
  ggplot(df, aes(x = grupo, y = comprimento, fill = cor)) +
  stat_summary(fun = mean,
               geom = "bar",
               col = "black",
               width = 0.8,
               position = position_dodge(0.8)) + 
  stat_summary(fun.data = mean_se,
               geom = "errorbar",
               width = 0.2,
               position = position_dodge(0.8))

arrange_ggplot(bar1, bar2,
               widths = c(0.6, 1.2),
               tag_levels = list(c("bar1", "bar2")))
```

<div class="figure" style="text-align: center">
<img src="/classes/experimentacao/05_visualizacao_files/figure-html/unnamed-chunk-17-1.png" alt="Gráfico do tipo barras, com mapeamento estético e barras de erro." width="960" />
<p class="caption">Figure 8: Gráfico do tipo barras, com mapeamento estético e barras de erro.</p>
</div>

A afirmação de que um gráfico `ggplot2` é feito em camadas fica mais evidente aqui. No gráfico `bar1`, as barras representam as médias geral do `comprimento` para cada grupo. No segundo gráfico, ao usar `fill = cor` informamos que as barras devem ser coloridas para cada nível do fator `cor`. A função `stat_summary()`, é vista pela primeira vez aqui, foi utilizada no segundo gráfico para substituir a função `geom_bar()`. Com isto, foi possível incluir as médias (`fun = mean` e `geom = "bar`), bem como as barras de erro (`fun.data = mean_se` e `geom = "errorbar"`).

Utilizando a função `plot_factbars()` do pacote metan, um gráfico semelhante pode ser criado com as funções `plot_bars()` e `plot_factbars()`


```r
metan1 <- 
  plot_bars(df,
            x = grupo,
            y = comprimento)
metan2 <- 
  plot_factbars(df, # dados
                grupo, cor, # dois fatores
                resp = comprimento) # eixo y

arrange_ggplot(metan1, metan2,
               widths = c(0.6, 1.2),
               tag_levels = list(c("metan1", "metan2")))
```

<img src="/classes/experimentacao/05_visualizacao_files/figure-html/unnamed-chunk-18-1.png" width="960" />



<!-- ### Regressão linear de primeiro grau -->

<!-- ```{r message = FALSE, warning = FALSE, fig.width = 10, fig.height = 4, fig.align = "center", fig.cap = "Gráfico de dispersão, combinando pontos e linhas de regressão."} -->

<!-- l1 <-  -->
<!--   ggplot(df, aes(x = MST, y = AF)) + -->
<!--   geom_point() + -->
<!--   geom_smooth(method = "lm", se = FALSE) + # estima uma regressão linear -->
<!--   labs(x = "Matéria seca total (g)", -->
<!--        y = "Área foliar (cm2)") -->

<!-- l2 <-  -->
<!--   ggplot(df, aes(x = MST, y = AF, colour = DAP)) + -->
<!--   geom_point() + -->
<!--   geom_smooth(method = "lm", se = F)+ -->
<!--   labs(x = "Matéria seca total (g)", -->
<!--        y = "Área foliar (cm2)") -->

<!-- arrange_ggplot(l1, l2, -->
<!--                tag_levels = list(c("s1", "s2")), -->
<!--                widths = c(1, 1.2)) -->

<!-- ``` -->

<!-- ### Regressão linear polinomial -->

<!-- Para confeccionar um gráfico de regressão polinomial, além do argumento `method = "lm"` (linear model), precisa-se incluir no argumento `formula` a formula utilizada, neste caso, definida utilizando `poly()` (polinomial). -->
<!-- ```{r message = FALSE, warning = FALSE, fig.width = 7, fig.height = 3, fig.align = "center", fig.cap = "Gráfico de dispersão combinado com inclusão de curvas ajustadas."} -->
<!-- #### Polinômio de segundo grau -->
<!-- dado_reg = tibble(dose = c(15,20,25,30,35,40), -->
<!--                   prod = c(65,70,73,75,69,62)) -->
<!-- q1 <-  -->
<!--   ggplot(dado_reg, aes(dose, prod))+ -->
<!--   geom_point()+ -->
<!--   stat_smooth(method = "lm", -->
<!--               formula = "y ~ poly(x, 1)", -->
<!--               se = FALSE) -->
<!-- q2 <-   -->
<!--   q1 +  -->
<!--   stat_smooth(method = "lm", -->
<!--               formula = "y ~ poly(x, 2)", -->
<!--               linetype = "dashed", -->
<!--               color = "red", -->
<!--               se = FALSE) -->

<!-- arrange_ggplot(q1, q2, tag_levels = list(c("l1", "l2"))) -->
<!-- ``` -->

<!-- Utilizando a função `plot_lines()` do pacote metan, um gráfico semelhante pode ser criado com -->

<!-- ```{r} -->
<!-- plot_lines(dado_reg,  -->
<!--            x = dose, -->
<!--            y = prod, -->
<!--            fit = 2) -->
<!-- ``` -->

## Dados da estação
### Gráfico da precipitação e temperatura



```r
df_prec <- 
  clima_max_min |> 
  pivot_wider(names_from = "name",
              values_from = "value")

ggplot() +
  geom_bar(df_prec,
           mapping = aes(x = dia, y = precip * 30 / 100),
           stat = "identity",
           fill = "skyblue") +
  geom_line(df_prec,
            mapping = aes(x = dia, y = max, colour = "red"),
            size = 1) +
  geom_line(df_prec, 
            mapping = aes(x = dia, y = min, colour = "blue"),
            size = 1) +
  scale_x_date(date_breaks = "7 days", date_labels =  "%d/%m")+
  scale_y_continuous(name = expression("Temperatura ("~degree~"C)"),
                     sec.axis = sec_axis(~ . * 100 / 30 , name = "Precipitação (mm)")) +
  theme(legend.position = "bottom",
        legend.title = element_blank()) +
  scale_color_identity(breaks = c("red", "blue"),
                       labels = c("Temperatura máxima (ºC)",
                                  "Temperatura mínima (ºC)"),
                       guide = "legend")
```

<img src="/classes/experimentacao/05_visualizacao_files/figure-html/unnamed-chunk-19-1.png" width="672" />

### Vento


# Velocidade média do vento 


```r

vento_long <-
  df_estacao %>%
  select(m, hora, velvent) %>% 
  pivot_longer(-c(m, hora))




# confeccionar gráfico
ggplot(vento_long, aes(m, value, color = name, group = name )) +
  stat_summary(geom = "point", 
               fun = mean) +
  stat_summary(geom = "line") + 
  stat_summary(geom = "errorbar", width = 0.1) +
  scale_color_manual(values = c("red", "blue"),
                     labels = c("Rajada (m/s)",
                                "Velocidade do vento (m/s)"),
                     guide = "legend") +
  theme(panel.grid.minor = element_blank(),
        legend.position = "bottom",
        legend.title = element_blank(),
        axis.title = element_text(size = 12),
        axis.text = element_text(size = 12)) + 
  labs(title = "Velocidade média mensal do vento em 2020",
       subtitle = "Estação INMET - UFSM-FW",
       caption = "Elaboração: Prof. Tiago Olivoto",
       x = "Mês do ano",
       y = "Velocidade (m/s)")
```

<img src="/classes/experimentacao/05_visualizacao_files/figure-html/unnamed-chunk-20-1.png" width="672" />




# Direção do vento

```r
freq <- 
  cut(df_estacao$dirvent, breaks = seq(0, 360, by = 45)) |> 
  table() |> 
  as.data.frame() %>% 
  set_names("Direção", "Dias") %>% 
  mutate(Direção = paste0(seq(0, 315, by = 45)),
         Percent = Dias / 3428 * 100) %>% 
  remove_cols(Dias)
freq
##   Direção   Percent
## 1       0 13.273046
## 2      45  8.401400
## 3      90 10.239207
## 4     135 17.648775
## 5     180 13.593932
## 6     225  6.446908
## 7     270  5.513419
## 8     315 24.883314


# criar um radar plot para mostrar a direção predominante
# do vento
ggradar(freq %>% transpose_df(),
        values.radar = c("0%", "0%", "25.8%"),
        grid.max = max(freq$Percent))
```

<img src="/classes/experimentacao/05_visualizacao_files/figure-html/unnamed-chunk-21-1.png" width="672" />




## Mapas
O pacote `rnaturalearth` é uma excelente ferramenta para manter e facilitar a interação com os dados do mapa [Natural Earth](https://www.naturalearthdata.com/). Para produção de mapas com o `ggplot2`, os seguintes pacotes são necessários.




```r
# américa do sul
library(rnaturalearth)
library(tidyverse)
sam <-
  ne_countries(continent = "south america",
               returnclass = "sf",
               scale = 50)

p1 <- 
  ggplot() +
  geom_sf(data = sam, fill = "white") +
  theme_light() +
  xlim(c(-90, -35))

# plotar o brasil e destacar santa catarina
brazil <- 
  ne_states(country = "brazil", returnclass = "sf") |> 
  mutate(scat = ifelse(postal == "SC", "SC", "Outros"))

p1 + 
  geom_sf(data = brazil, aes(fill = scat))
```

<img src="/classes/experimentacao/05_visualizacao_files/figure-html/unnamed-chunk-22-1.png" width="672" />


# Referências
