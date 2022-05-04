---
title: Analizando objetos
linktitle: "3. Analizando objetos"
toc: true
type: docs
date: "2021/11/25"
lastmod: "2022/05/06"
draft: false
df_print: paged
code_download: true
menu:
  plimanip:
    parent: pliman
    weight: 4
weight: 3
---



# Diretório das imagens

```r
# mudar de acordo com a pasta em seu computador
setwd("E:/Desktop/tiagoolivoto/static/tutorials/pliman_ip/imgs")
```

# Trabalhando com polígonos
> Um 'polígono' é uma figura plana que é descrita por um número finito de segmentos de linha reta conectados para formar uma cadeia poligonal fechada (Singer, 1993)^[1].

Dado o exposto, podemos concluir que objetos de imagem podem ser expressos como polígonos com `n` vértices. O `pliman` tem um conjunto de funções (`draw_*()`) úteis  para desenhar formas comuns como círculos, quadrados, triângulos, retângulos e `n`-tagons. Outro grupo de funções `poly_*()` pode ser usado para analisar polígonos. Vamos começar com um exemplo simples, relacionado à área e perímetro de um quadrado.


```r
library(pliman)
```

```
## |==========================================================|
```

```
## | Tools for Plant Image Analysis (pliman 1.2.0)            |
```

```
## | Author: Tiago Olivoto                                    |
```

```
## | Type 'citation('pliman')' to know how to cite pliman     |
```

```
## | Type 'vignette('pliman_start')' for a short tutorial     |
```

```
## | Visit 'http://bit.ly/pkg_pliman' for a complete tutorial |
```

```
## |==========================================================|
```

```r
quadrado <- draw_square(side = 1)
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/unnamed-chunk-3-1.png" width="672" />

```r
poly_area(quadrado)
```

```
## [1] 1
```

```r
poly_perimeter(quadrado)
```

```
## [1] 4
```

Agora, vamos ver o que acontece quando começamos com um hexágono e aumentamos o número de lados até 1000.


```r
formas <- list(side6 = draw_n_tagon(6, plot = FALSE),
               side12 = draw_n_tagon(12, plot = FALSE),
               side24 = draw_n_tagon(24, plot = FALSE),
               side100 = draw_n_tagon(100, plot = FALSE),
               side500 = draw_n_tagon(500, plot = FALSE),
               side100 = draw_n_tagon(1000, plot = FALSE))
plot_polygon(formas, merge = FALSE)
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/unnamed-chunk-4-1.png" width="672" />

```r
poly_area(formas)
```

```
##    side6   side12   side24  side100  side500  side100 
## 2.598076 3.000000 3.105829 3.139526 3.141510 3.141572
```

```r
poly_perimeter(formas)
```

```
##    side6   side12   side24  side100  side500  side100 
## 6.000000 6.211657 6.265257 6.282152 6.283144 6.283175
```


Observe que quando `\(n \to \infty\)`, a soma dos lados se torna a circunferência do círculo, dada por `\(2\pi r\)`, e a área se torna `\(\pi r^2\)`. Isso é divertido, mas o `pliman` é projetado principalmente para analisar a análise de imagens de plantas. Então, por que usar polígonos? Vamos ver como podemos usar essas funções para obter informações realmente úteis.



```r
leaves <- image_import("ref_leaves.jpg", plot = TRUE)

# obtendo o contorno dos objetos
cont <- object_contour(leaves, watershed = FALSE, index = "HI")
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/unnamed-chunk-5-1.png" width="768" />

```r
# plotando o polígono
plot_polygon(cont)
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/unnamed-chunk-5-2.png" width="768" />


Legal! Podemos usar o contorno de qualquer objeto para obter informações úteis relacionadas à sua forma. Para reduzir a quantidade de saída, usarei apenas cinco amostras: 2, 4, 13, 24 e 35.


```r
cont <- cont[c("2", "4", "13", "24", "35")]
plot_polygon(cont)
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/unnamed-chunk-6-1.png" width="672" />

Na versão atual do `pliman`, você poderá calcular as seguintes medidas. Para mais detalhes, ver Chen & Wang (2005)^[2], Claude (2008)^[3], e Montero et al. 2009^[4].

## Área

A área de uma forma é calculada usando a formula de Shoelace (Lee e Lim, 2017)^[5], como segue

$$
A=\frac{1}{2}\left|\sum_{i=1}^{n}\left(x_{i} y_{i+1}-x_{i+1}y_{i}\right)\right|
$$


```r
poly_area(cont)
```

```
##       2       4      13      24      35 
## 44952.0 46622.0 15124.5 12060.0  1654.5
```


## Perímetro
O perímetro é calculado como a soma da distância euclidiana entre todos os pontos de uma forma. As distâncias podem ser obtidas com `poly_distpts()`.


```r
poly_perimeter(cont)
```

```
##         2         4        13        24        35 
## 1275.4550  891.4062  559.3991  460.3869  591.8112
```

```r
# perímetro de um círculo com raio igual a 2
circle <- draw_circle(radius = 2, plot = FALSE)
poly_perimeter(circle)
```

```
## [1] 12.56635
```

```r
#verifica o resultado
2*pi*2
```

```
## [1] 12.56637
```


## Raio

O raio de um pixel no contorno do objeto é calculado como sua distância ao centroide do objeto (também chamado de 'centro de massa'). Estas distâncias podem ser obtidas com `poly_centdist()`.


```r
dist <- poly_centdist(cont)

# estatísticas para o raio
mean_list(dist)
```

```
##         2         4        13        24        35 
## 119.33467 124.86878  71.91624  64.04449  72.09876
```

```r
min_list(dist)
```

```
##         2         4        13        24        35 
## 68.868885 89.614639 48.363509 47.880800  3.341768
```

```r
max_list(dist)
```

```
##         2         4        13        24        35 
## 170.41035 185.66189 108.03828  95.25586 143.80833
```

```r
sd_list(dist)
```

```
##        2        4       13       24       35 
## 20.80831 27.19785 14.60321 13.56119 41.34589
```

```r
# raio médio do círculo acima
poly_centdist(circle) |> mean_list()
```

```
## [1] 1.999998
```



## Comprimento e largura

O comprimento e a largura de um objeto são calculados com `poly_lw()`, como a diferença entre o máximo e o mínimo das coordenadas `x` e `y` após o objeto ter sido alinhado com `poly_align()`.


```r
alinhado <- poly_align(cont)
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/unnamed-chunk-10-1.png" width="672" />

```r
# calcula comprimento e largura
poly_lw(cont)
```

```
##      length      width
## 2  312.9211 265.501918
## 4  351.6712 186.401587
## 13 186.3352 140.427787
## 24 184.0703 100.133973
## 35 286.2853   9.956061
```

## Circularidade, excentricidade, diâmetro e alongamento

A circularidade (Montero et al. 2009)^[6] também é chamada de compacidade de forma, ou medida de redondeza de um objeto. É dada por `\(C = P^2 / A\)`, onde `\(P\)` é o perímetro e `\(A\)` é a área do objeto.


```r
poly_circularity(cont)
```

```
##         2         4        13        24        35 
##  36.18939  17.04356  20.69009  17.57513 211.68962
```

Como a medida acima depende da escala, a circularidade normalizada pode ser usada. Neste caso, assume-se que um círculo perfeito possui circularidade igual a 1. Essa medida é invariável sob translação, rotação e transformações de escala, sendo dada `\(Cn = P^2 / 4 \pi A\)`


```r
poly_circularity_norm(cont)
```

```
##         2         4        13        24        35 
##  2.879860  1.356284  1.646465  1.398584 16.845725
```

```r
# circularidade normalizada para diferentes formas
draw_square(plot = FALSE) |> poly_circularity_norm()
```

```
## [1] 1.27324
```

```r
draw_circle(plot = FALSE) |> poly_circularity_norm()
```

```
## [1] 1.000003
```


`poly_circularity_haralick()` calcula a circularidade de Haralick, CH (Haralick, 1974)[^7]. O método é baseado no cálculo de todas as distâncias euclidianas do centroide do objeto até cada pixel de contorno. Com este conjunto de distâncias, calcula-se a média ($m$) e o desvio padrão ($s$). Esses parâmetros estatísticos são usados em uma razão que calcula a CH como `\(CH = m/sd\)`.


```r
poly_circularity_haralick(cont)
```

```
##        2        4       13       24       35 
## 5.734954 4.591127 4.924687 4.722631 1.743795
```

`poly_convexity()` Calcula a convexidade de uma forma usando uma razão entre o perímetro do casco convexo e o perímetro do polígono.


```r
poly_convexity(cont)
```

```
##         2         4        13        24        35 
## 0.6456159 0.9093251 0.7675646 0.9267030 0.7180971
```


`poly_eccentricity()` Calcula a excentricidade de uma forma usando a razão dos autovalores (eixos de inércia das coordenadas).


```r
poly_eccentricity(cont)
```

```
##           2           4          13          24          35 
## 0.841114622 0.402214559 0.599908673 0.412005655 0.001474145
```


`poly_elongation()` Calcula a elongação de um objeto como `1 - largura / comprimento`


```r
poly_elongation(cont)
```

```
##         2         4        13        24        35 
## 0.1515373 0.4699549 0.2463701 0.4560015 0.9652233
```


`poly_caliper()` Calcula o calibre (também chamado de diâmetro do Feret).


```r
poly_caliper(cont)
```

```
##        2        4       13       24       35 
## 317.6303 351.7528 187.4807 184.1738 286.2953
```


Os usuários podem usar a função `poly_measures()` para calcular a maioria das medidas do objeto em uma única chamada.


```r
(medidas <- poly_measures(cont) |> round_cols())
```

```
##    id      x      y    area area_ch perimeter radius_mean radius_min radius_max
## 2   1 910.85 190.05 44952.0 57389.5   1275.45      119.33      68.87     170.41
## 4   2 275.06 220.21 46622.0 47114.0    891.41      124.87      89.61     185.66
## 13  3 866.76 482.69 15124.5 16451.0    559.40       71.92      48.36     108.04
## 24  4 959.61 622.00 12060.0 12404.0    460.39       64.04      47.88      95.26
## 35  5 455.04 733.98  1654.5  2129.0    591.81       72.10       3.34     143.81
##    radius_sd radius_ratio diam_mean diam_min diam_max caliper length  width
## 2      20.81         2.47    238.67   137.74   340.82  317.63 312.92 265.50
## 4      27.20         2.07    249.74   179.23   371.32  351.75 351.67 186.40
## 13     14.60         2.23    143.83    96.73   216.08  187.48 186.34 140.43
## 24     13.56         1.99    128.09    95.76   190.51  184.17 184.07 100.13
## 35     41.35        43.03    144.20     6.68   287.62  286.30 286.29   9.96
##    solidity convexity elongation circularity circularity_haralick
## 2      0.78      0.65       0.15       36.19                 3.31
## 4      0.99      0.91       0.47       17.04                 3.29
## 13     0.92      0.77       0.25       20.69                 3.31
## 24     0.97      0.93       0.46       17.58                 3.53
## 35     0.78      0.72       0.97      211.69                 0.08
##    circularity_norm eccentricity
## 2              2.88         0.84
## 4              1.36         0.40
## 13             1.65         0.60
## 24             1.40         0.41
## 35            16.85         0.00
```

Se a resolução da imagem for conhecida, as medidas podem ser corrigidas com `get_measures()`. A resolução da imagem pode ser obtida usando uma distância conhecida na imagem. No exemplo, o quadrado branco tem um lado de 5 cm. Assim, usando `dpi()` a resolução pode ser obtida. Nesse caso, o dpi é ~50.


```r
(medidas_cor <- get_measures(medidas, dpi = 50))
```

```
##    id      x      y    area area_ch perimeter radius_mean radius_min radius_max
## 2   1 910.85 190.05 116.005 148.102    64.793       6.062      3.499      8.657
## 4   2 275.06 220.21 120.315 121.584    45.284       6.343      4.552      9.432
## 13  3 866.76 482.69  39.031  42.454    28.418       3.654      2.457      5.488
## 24  4 959.61 622.00  31.123  32.010    23.388       3.253      2.432      4.839
## 35  5 455.04 733.98   4.270   5.494    30.064       3.663      0.170      7.306
##    radius_sd radius_ratio diam_mean diam_min diam_max caliper length  width
## 2      1.057        0.125    12.124    6.997   17.314  16.136 15.896 13.487
## 4      1.382        0.105    12.687    9.105   18.863  17.869 17.865  9.469
## 13     0.742        0.113     7.307    4.914   10.977   9.524  9.466  7.134
## 24     0.689        0.101     6.507    4.865    9.678   9.356  9.351  5.087
## 35     2.101        2.186     7.325    0.339   14.611  14.544 14.544  0.506
##    solidity convexity elongation circularity circularity_haralick
## 2      0.78      0.65       0.15       36.19                 3.31
## 4      0.99      0.91       0.47       17.04                 3.29
## 13     0.92      0.77       0.25       20.69                 3.31
## 24     0.97      0.93       0.46       17.58                 3.53
## 35     0.78      0.72       0.97      211.69                 0.08
##    circularity_norm eccentricity
## 2              2.88         0.84
## 4              1.36         0.40
## 13             1.65         0.60
## 24             1.40         0.41
## 35            16.85         0.00
```




Algumas funções úteis podem ser usadas para manipular coordenadas. No exemplo a seguir, mostrarei alguns recursos implementados no `pliman`. Apenas para simplificar, usarei apenas o objeto 2.



```r
o2 <- cont[["2"]]
plot_polygon(o2)
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/unnamed-chunk-20-1.png" width="672" />

## Rotacionar polígonos

`poly_rotate()` pode ser usado para girar as coordenadas do polígono por um `ângulo` (0-360 graus) na direção trigonométrica (anti-horário).



```r
rot <- poly_rotate(o2, angle = 45)
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/unnamed-chunk-21-1.png" width="384" />


## Inverter polígonos
`poly_flip_x()` e `poly_flip_y()` podem ser usados para inverter formas ao longo do eixo x e y, respectivamente.


```r
flipped <- list(
  fx = poly_flip_x(o2),
  fy = poly_flip_y(o2)
)
plot_polygon(flipped, merge = FALSE, aspect_ratio = 1)
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/unnamed-chunk-22-1.png" width="768" />


## Amostragem do perímetro

`poly_sample()` amostra `n` coordenadas entre pontos existentes, e `poly_sample_prop()` amostra uma proporção de coordenadas entre os existentes.


```r
# amostra 50 coordenadas
poly_sample(o2, n = 50) |> plot_polygon()
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/unnamed-chunk-23-1.png" width="384" />

```r
# amostra 10% das coordenadas
poly_sample_prop(o2, prop = 0.1) |> plot_polygon()
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/unnamed-chunk-23-2.png" width="384" />


## Suavização

`poly_smooth()` suaviza o contorno de um polígono combinando `prop` amostras de pontos de coordenadas e interpolando-as usando `vertices` vértices (padrão é 1000) .


```r
smoothed <-
  list(
    original = o2,
    s1 = poly_smooth(o2, prop = 0.2, plot = FALSE),
    s2 = poly_smooth(o2, prop = 0.1, plot = FALSE),
    s1 = poly_smooth(o2, prop = 0.04, plot = FALSE)
  )
plot_polygon(smoothed, merge = FALSE, ncol = 4)
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/unnamed-chunk-24-1.png" width="864" />


## Ruídos


`poly_jitter()` adiciona uma pequena quantidade de ruído a um conjunto de coordenadas. Veja `base::jitter()` para mais detalhes.


```r
set.seed(1)
c1 <- draw_circle(n = 200, plot = FALSE)
c2 <-
  draw_circle(n = 200, plot = FALSE) |>
  poly_jitter(noise_x = 100,
              noise_y = 100,
              plot = FALSE)

plot_polygon(list(c1, c2), merge = FALSE)
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/unnamed-chunk-25-1.png" width="768" />







# Analisando objetos

As funções vistas até agora podem ser utilizadas para obter medidas de objetos. No entanto, para a análise de uma imagem é necessário combinar diferentes funções (principalmente `object_contour()` e `poly_measures()`). Além disso, quase sempre, várias imagens precisam ser analizadas e repetir esse processo cada vez seria tedioso e pouco eficiente. Para contemplar estas necessidades, os usuários podem utilizar a função `analyze_objects()`. Vamos começar com um exemplo simples, utilizando a imagem`object_300dpi.png` disponível na [página GitHub](https://github.com/TiagoOlivoto/pliman/tree/master/inst/tmp_images). Para facilitar a importação de imagens desta pasta, uma função auxiliar `image_pliman()` é usada.



```r
# gerar tabelas html
print_tbl <- function(table,  digits = 3, ...){
  knitr::kable(table, booktabs = TRUE, digits = digits, ...)
}
library(pliman)
library(tidyverse)
## Warning: package 'tidyverse' was built under R version 4.1.3
## -- Attaching packages --------------------------------------- tidyverse 1.3.1 --
## v ggplot2 3.3.5     v purrr   0.3.4
## v tibble  3.1.6     v dplyr   1.0.8
## v tidyr   1.2.0     v stringr 1.4.0
## v readr   2.1.2     v forcats 0.5.1
## -- Conflicts ------------------------------------------ tidyverse_conflicts() --
## x forcats::%>%()               masks stringr::%>%(), dplyr::%>%(), purrr::%>%(), tidyr::%>%(), tibble::%>%(), pliman::%>%()
## x tibble::column_to_rownames() masks pliman::column_to_rownames()
## x dplyr::filter()              masks stats::filter()
## x dplyr::lag()                 masks stats::lag()
## x tibble::remove_rownames()    masks pliman::remove_rownames()
## x tibble::rownames_to_column() masks pliman::rownames_to_column()
library(patchwork)

img <- image_pliman("objects_300dpi.jpg", plot = TRUE)
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/unnamed-chunk-26-1.png" width="672" />



A imagem acima foi produzida com o Microsoft PowerPoint. Tem uma resolução conhecida de 300 dpi(pontos por polegada) e mostra quatro objetos

- Quadrado maior: 10 x 10 cm (100 cm$^2$)  
- Quadrado menor: 5 x 5 cm(25 cm$^2$)  
- Retângulo: 4 x 2 cm(8 cm$^2$)  
- Círculo: 3 cm de diâmetro(~7,07 cm$^2$)  


Para contar os objetos na imagem usamos `analyze_objects()` e informamos a imagem (o único argumento obrigatório). Por padrão, o índice `NB` é utilizado para segmentação dos objetos.



```r
img_res <- analyze_objects(img, marker = "id")
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/unnamed-chunk-27-1.png" width="960" />



## Ajustando as medidas do objeto

Os resultados foram armazenados em `img_res`. Como não há escala declarada no exemplo acima, não temos ideia sobre a área real dos objetos em cm$^2$, apenas em pixels. Neste caso, usamos `get_measures()` para ajustar as medidas de pixels para unidades métricas.

Existem duas formas principais de ajustar as medidas do objeto (de pixels a cm, por exemplo). O primeiro é declarar a área, perímetro ou raio conhecido de um determinado objeto. A medida para os outros objetos será então calculada por uma regra de três simples. A segunda é declarando uma resolução de imagem conhecida em dpi (pontos por polegada). Neste caso, perímetro, área e raio serão ajustados pelo dpi informado.

### Declarando um valor conhecido

Como conhecemos a área do quadrado maior (objeto 1), vamos ajustar a área dos outros objetos na imagem usando isso.



```r
get_measures(img_res,
             id = 1,
             area ~ 100)
```

```
## -----------------------------------------
## measures corrected with:
## object id: 1
## area     : 100
## -----------------------------------------
## Total    : 39.985 
## Average  : 13.328 
## -----------------------------------------
```

```
##   id        x        y   area area_ch perimeter radius_mean radius_min
## 2  2 1737.513  453.246 25.041  24.978    21.980       2.865      2.495
## 3  3 1737.575 1296.331  7.023   7.015     9.903       1.491      1.483
## 4  4 1737.972  939.503  7.922   7.880    11.906       1.666      0.986
##   radius_max radius_sd diam_mean diam_min diam_max major_axis minor_axis length
## 2      3.524     0.313     5.730    4.989    7.049      5.781      5.776  5.058
## 3      1.502     0.003     2.983    2.967    3.003      2.991      2.990  2.987
## 4      2.222     0.424     3.332    1.973    4.444      4.611      2.291  3.993
##   width radius_ratio eccentricity  theta solidity convexity elongation
## 2 5.050        1.413        0.999  1.539    1.003     0.681      0.002
## 3 2.992        1.012        0.998 -1.490    1.001     0.921     -0.001
## 4 1.976        2.253        0.346  0.000    1.005     0.837      0.505
##   circularity circularity_haralick circularity_norm
## 2      19.294                9.144            1.541
## 3      13.965              441.819            1.117
## 4      17.894                3.929            1.433
```



O mesmo pode ser usado para ajustar as medidas com base no perímetro ou raio. Vamos ajustar o perímetro dos objetos pelo perímetro do objeto 2 (20 cm).


### Declarando a resolução da imagem

Se a resolução da imagem for conhecida, todas as medidas serão ajustadas de acordo com esta resolução. Vamos ver um exemplo numérico com `pixels_to_cm()`. Esta função converte o número de pixels (*px*) em cm, considerando a resolução da imagem em `dpi`, da seguinte forma: `\(cm = px \times(2,54 / dpi)\)`. Como sabemos o número de pixels do quadrado maior, seu perímetro em cm é dado por




```r
# número de pixels para o perímetro do quadrado maior

ls_px <- img_res$results$perimeter[1]
pixels_to_cm(px = ls_px, dpi = 300)
```

```
## [1] 39.9046
```

O perímetro do objeto 1 ajustado pela resolução da imagem é muito próximo do verdadeiro (40 cm). Abaixo, os valores de todas as medidas são ajustados declarando o argumento `dpi` em` get_measures()`.


```r
img_res_cor <- get_measures(img_res, dpi = 300)
print_tbl(t(img_res_cor))
```



|                     |       1|        2|        3|        4|
|:--------------------|-------:|--------:|--------:|--------:|
|id                   |   1.000|    2.000|    3.000|    4.000|
|x                    | 668.506| 1737.513| 1737.575| 1737.972|
|y                    | 798.002|  453.246| 1296.331|  939.503|
|area                 |  99.729|   24.973|    7.004|    7.900|
|area_ch              |  99.644|   24.910|    6.996|    7.858|
|perimeter            |  39.905|   21.950|    9.890|   11.890|
|radius_mean          |   5.725|    2.861|    1.489|    1.664|
|radius_min           |   4.985|    2.491|    1.481|    0.985|
|radius_max           |   7.052|    3.520|    1.500|    2.219|
|radius_sd            |   0.628|    0.313|    0.003|    0.423|
|diam_mean            |  11.450|    5.722|    2.979|    3.327|
|diam_min             |   9.970|    4.983|    2.963|    1.970|
|diam_max             |  14.105|    7.039|    2.999|    4.438|
|major_axis           |  11.536|    5.773|    2.987|    4.604|
|minor_axis           |  11.526|    5.768|    2.986|    2.288|
|length               |  10.034|    5.051|    2.983|    3.988|
|width                |  10.017|    5.043|    2.988|    1.973|
|radius_ratio         |   1.415|    1.413|    1.012|    2.253|
|eccentricity         |   0.999|    0.999|    0.998|    0.346|
|theta                |   0.014|    1.539|   -1.490|    0.000|
|solidity             |   1.001|    1.003|    1.001|    1.005|
|convexity            |   0.752|    0.681|    0.921|    0.837|
|elongation           |   0.002|    0.002|   -0.001|    0.505|
|circularity          |  15.967|   19.294|   13.965|   17.894|
|circularity_haralick |   9.113|    9.144|  441.819|    3.929|
|circularity_norm     |   1.273|    1.541|    1.117|    1.433|



### Entendendo as medidas


```r
object_contour(img) %>% # obtém o contorno dos objetos
  poly_mass() %>% # computa o centro de massa e raios mínimo e máximo
  plot_mass() # plota as medidas
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/unnamed-chunk-31-1.png" width="672" />

* Quadrado maior:
- O diâmetro mínimo (a = 9,97) pode ser considerado como o lado do quadrado

- O diâmetro máximo, dado por `\(a \sqrt{2}\)` pode ser considerado a diagonal do quadrado ($9,97 \sqrt{2} = 14.099 \approx 14.105$ 

```r
t(img_res_cor)
```

```
##                            1        2        3        4
## id                     1.000    2.000    3.000    4.000
## x                    668.506 1737.513 1737.575 1737.972
## y                    798.002  453.246 1296.331  939.503
## area                  99.729   24.973    7.004    7.900
## area_ch               99.644   24.910    6.996    7.858
## perimeter             39.905   21.950    9.890   11.890
## radius_mean            5.725    2.861    1.489    1.664
## radius_min             4.985    2.491    1.481    0.985
## radius_max             7.052    3.520    1.500    2.219
## radius_sd              0.628    0.313    0.003    0.423
## diam_mean             11.450    5.722    2.979    3.327
## diam_min               9.970    4.983    2.963    1.970
## diam_max              14.105    7.039    2.999    4.438
## major_axis            11.536    5.773    2.987    4.604
## minor_axis            11.526    5.768    2.986    2.288
## length                10.034    5.051    2.983    3.988
## width                 10.017    5.043    2.988    1.973
## radius_ratio           1.415    1.413    1.012    2.253
## eccentricity           0.999    0.999    0.998    0.346
## theta                  0.014    1.539   -1.490    0.000
## solidity               1.001    1.003    1.001    1.005
## convexity              0.752    0.681    0.921    0.837
## elongation             0.002    0.002   -0.001    0.505
## circularity           15.967   19.294   13.965   17.894
## circularity_haralick   9.113    9.144  441.819    3.929
## circularity_norm       1.273    1.541    1.117    1.433
```



A função `analyze_objects()` calcula uma gama de medidas que podem ser utilizadas para estudar a forma dos objetos, como por exemplo, folhas. Como exemplo, usarei a imagem `potato_leaves.png`, que foi coletada de [Gupta et al.(2020)](https://doi.org/10.1111/nph.16286)



```r
batata <- image_pliman("potato_leaves.jpg", plot = TRUE)

pot_meas <-
  analyze_objects(batata,
                  watershed = FALSE,
                  marker = "id",
                  show_chull = TRUE) # mostra o casco convex
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/batata-1.png" width="960" />

```r
pot_meas$results %>% 
  print_tbl()
```



| id|       x|       y|  area| area_ch| perimeter| radius_mean| radius_min| radius_max| radius_sd| diam_mean| diam_min| diam_max| major_axis| minor_axis|  length|   width| radius_ratio| eccentricity|  theta| solidity| convexity| elongation| circularity| circularity_haralick| circularity_norm|
|--:|-------:|-------:|-----:|-------:|---------:|-----------:|----------:|----------:|---------:|---------:|--------:|--------:|----------:|----------:|-------:|-------:|------------:|------------:|------:|--------:|---------:|----------:|-----------:|--------------------:|----------------:|
|  1| 854.542| 224.043| 51380|   54536|  1005.916|     131.565|     92.111|    198.025|    26.061|   263.131|  184.222|  396.050|    305.737|    242.212| 345.519| 254.702|        2.150|        0.623|  1.394|    0.942|     0.914|      0.263|      19.694|                5.048|            1.580|
|  2| 197.844| 217.851| 58923|   76706|  1243.597|     140.296|     70.106|    192.361|    28.585|   280.592|  140.212|  384.723|    318.244|    274.128| 330.014| 330.998|        2.744|        0.789| -0.099|    0.768|     0.739|     -0.003|      26.247|                4.908|            2.108|
|  3| 536.210| 240.238| 35117|   62792|  1518.592|     109.900|     38.137|    188.511|    35.510|   219.800|   76.273|  377.021|    253.498|    243.279| 293.957| 306.794|        4.943|        0.924|  1.097|    0.559|     0.565|     -0.044|      65.670|                3.095|            5.325|



As três medidas principais (em unidades de pixel) são:

1. `area` a área do objeto.
2. `area_ch` a área do casco convexo.
3. `perímetro` o perímetro do objeto.


## Processamento de imagens únicas

No exemplo a seguir, mostro como analisar três folhas de batata-doce, plotando o comprimento e a largura de cada uma.



```r
folhas <-  image_import("folhas.jpg", plot = TRUE) 
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/unnamed-chunk-33-1.png" width="672" />

```r
folhas_meas <- 
  analyze_objects(folhas,
                  watershed = FALSE,
                  col_background = "black")

folhas_cor <- get_measures(folhas_meas, dpi = 300)
print_tbl(t(folhas_cor))
```



|                     |       1|       2|
|:--------------------|-------:|-------:|
|id                   |   1.000|   2.000|
|x                    | 528.653| 233.994|
|y                    | 299.984| 825.804|
|area                 |   5.871|   3.874|
|area_ch              |   5.947|   4.207|
|perimeter            |  12.020|   9.747|
|radius_mean          |   1.592|   1.145|
|radius_min           |   0.736|   0.836|
|radius_max           |   2.672|   1.665|
|radius_sd            |   0.583|   0.219|
|diam_mean            |   3.185|   2.290|
|diam_min             |   1.473|   1.672|
|diam_max             |   5.343|   3.330|
|major_axis           |   4.844|   2.861|
|minor_axis           |   1.565|   1.743|
|length               |   5.240|   3.193|
|width                |   1.603|   1.883|
|radius_ratio         |   3.629|   1.991|
|eccentricity         |   0.135|   0.421|
|theta                |  -1.056|  -0.087|
|solidity             |   0.987|   0.921|
|convexity            |   0.918|   0.773|
|elongation           |   0.694|   0.410|
|circularity          |  24.608|  24.521|
|circularity_haralick |   2.732|   5.239|
|circularity_norm     |   1.973|   1.969|

```r
# plota a largura e comprimento
plot_measures(folhas_cor, measure = "width")
plot_measures(folhas_cor, measure = "length", vjust = 50)
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/unnamed-chunk-33-2.png" width="672" />




Aqui, contaremos os grãos na imagem `grains.jpg`. Esta imagem tem um fundo ciano e contém 90 grãos de soja que se tocam. A função `analyze_objects()` segmenta a imagem usando como padrão o índice azul normalizado, como segue \$NB = (B /(R + G + B))\$, onde *R*, *G* e *B* são as faixas vermelha, verde e azul. Note que se a imagem estiver contida no diretório padrão, não é necessário realizar a importação da mesma. Basta informar o nome da imagem entre aspas no argumento `img` (ex., `img = "grains"`).

Neste exemplo, os objetos são contados e os objetos segmentados são coloridos com cores aleatórias utilizando o argumento `show_segmentation = TRUE`. Os usuários podem definir `show_contour = FALSE` para remover a linha de contorno e identificar os objetos (neste exemplo, os grãos) usando os argumentos `marker = "id"`. A cor do fundo também pode ser alterada com `col_background`.




```r
count <- 
  analyze_objects("grains",
                  show_segmentation = TRUE,
                  show_contour = FALSE,
                  marker = "id")
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/unnamed-chunk-34-1.png" width="1152" />

```r
count$statistics
```

```
##        stat       value
## 1         n    90.00000
## 2  min_area   439.00000
## 3 mean_area   670.71111
## 4  max_area   834.00000
## 5   sd_area    71.51636
## 6  sum_area 60364.00000
```






```r
# Obtenha as medidas do objeto
medidas <- get_measures(count)
head(medidas)
```

```
##   id       x       y area area_ch perimeter radius_mean radius_min radius_max
## 1  1 351.824 411.147  834     800   103.669      15.827     14.814     16.877
## 2  2 824.939 264.776  818     796   106.497      15.707     13.713     17.676
## 3  3 710.004 262.800  761     733   100.255      15.112     12.886     17.048
## 4  4 811.438 198.836  730     700    97.083      14.792     13.908     15.505
## 5  5 818.924 714.852  735     707    98.255      14.834     13.673     16.038
## 6  6 807.158 341.957  752     721    98.841      15.021     13.581     16.724
##   radius_sd diam_mean diam_min diam_max major_axis minor_axis length  width
## 1     0.467    31.654   29.628   33.753     33.480     31.734 33.241 31.850
## 2     1.186    31.414   27.425   35.353     35.620     29.272 34.851 29.316
## 3     1.175    30.224   25.773   34.097     34.365     28.228 33.818 27.708
## 4     0.316    29.585   27.817   31.009     30.713     30.268 30.013 29.035
## 5     0.578    29.668   27.347   32.076     31.955     29.302 31.378 29.151
## 6     0.812    30.042   27.163   33.447     33.092     28.966 33.014 28.896
##   radius_ratio eccentricity  theta solidity convexity elongation circularity
## 1        1.139        0.927  1.331    1.042     0.879      0.042      12.886
## 2        1.289        0.739 -0.311    1.028     0.914      0.159      13.865
## 3        1.323        0.749 -0.261    1.038     0.882      0.181      13.208
## 4        1.115        0.981 -1.567    1.043     0.900      0.033      12.911
## 5        1.173        0.881 -1.227    1.040     0.886      0.071      13.135
## 6        1.231        0.806  0.574    1.043     0.875      0.125      12.991
##   circularity_haralick circularity_norm
## 1               33.906            1.086
## 2               13.241            1.171
## 3               12.857            1.117
## 4               46.798            1.092
## 5               25.666            1.112
## 6               18.506            1.099
```


No exemplo a seguir, selecionaremos objetos com uma área acima da média de todos os objetos usando `lower_size = 719.1`.




```r
analyze_objects("grains", 
                marker = "id",
                lower_size = 719.1)
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/unnamed-chunk-36-1.png" width="1152" />



Os usuários também podem usar os argumentos `topn_*` para selecionar os  `n` objetos com base nas menores ou maiores áreas. Vamos ver como selecionar os 5 grãos com a menor área, mostrando os grãos originais em um fundo azul. Também usaremos o argumento `my_index` para escolher um índice personalizado para segmentar a imagem. Apenas para comparação, iremos configurar explicitamente o índice azul normalizado chamando `my_index = "B/(R + G + B)"`.




```r
analyze_objects("grains",
                marker = "id",
                topn_lower = 5,
                col_background = "salmon",
                my_index = "B /(R + G + B)") # azul normalizado (NB)
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/unnamed-chunk-37-1.png" width="1152" />



## Processamento em lote

Na análise de imagens, frequentemente é necessário processar mais de uma imagem. Por exemplo, no melhoramento de plantas, o número de grãos por planta (por exemplo, trigo) é frequentemente usado na seleção indireta de plantas de alto rendimento. No `pliman`, o processamento em lote pode ser feito quando o usuário declara o argumento `pattern`.


Para acelerar o tempo de processamento, especialmente para um grande número de imagens, o argumento `parallel = TRUE` pode ser usado. Nesse caso, as imagens são processadas de forma assíncrona (em paralelo) em sessões `R` separadas rodando em segundo plano na mesma máquina. O número de seções é configurado para 50% dos núcleos disponíveis. Este número pode ser controlado explicitamente com o argumento `workers`.



```r
system.time(
  list_res <- analyze_objects(pattern = "img_sb", show_image = FALSE)
)
```

```
## Processing image img_sb_50_1 |===                                | 8% 00:00:00 
Processing image img_sb_50_10 |=====                             | 15% 00:00:01 
Processing image img_sb_50_11 |========                          | 23% 00:00:01 
Processing image img_sb_50_12 |==========                        | 31% 00:00:02 
Processing image img_sb_50_13 |=============                     | 38% 00:00:02 
Processing image img_sb_50_2 |================                   | 46% 00:00:02 
Processing image img_sb_50_3 |===================                | 54% 00:00:03 
Processing image img_sb_50_4 |======================             | 62% 00:00:04 
Processing image img_sb_50_5 |========================           | 69% 00:00:05 
Processing image img_sb_50_6 |===========================        | 77% 00:00:06 
Processing image img_sb_50_7 |==============================     | 85% 00:00:07 
Processing image img_sb_50_8 |================================   | 92% 00:00:07 
Processing image img_sb_50_9 |===================================| 100% 00:00:08 
## --------------------------------------------
##         Image Objects
##   img_sb_50_1     100
##  img_sb_50_10      29
##  img_sb_50_11      23
##  img_sb_50_12      15
##  img_sb_50_13       7
##   img_sb_50_2      90
##   img_sb_50_3      83
##   img_sb_50_4      75
##   img_sb_50_5      70
##   img_sb_50_6      60
##   img_sb_50_7      57
##   img_sb_50_8      48
##   img_sb_50_9      36
## --------------------------------------------
```

```
## Done!
```

```
##   usuário   sistema decorrido 
##      8.70      0.39      9.17
```

```r
# procesamento paralelo
# 6 múltiplas seções (observe o tempo!)
system.time(
  list_res <- 
    analyze_objects(pattern = "img_sb",
                    show_image = FALSE,
                    parallel = TRUE)
)
```

```
## Image processing using multiple sessions (6). Please wait.
```

```
## --------------------------------------------
##         Image Objects
##   img_sb_50_1     100
##  img_sb_50_10      29
##  img_sb_50_11      23
##  img_sb_50_12      15
##  img_sb_50_13       7
##   img_sb_50_2      90
##   img_sb_50_3      83
##   img_sb_50_4      75
##   img_sb_50_5      70
##   img_sb_50_6      60
##   img_sb_50_7      57
##   img_sb_50_8      48
##   img_sb_50_9      36
## --------------------------------------------
```

```
## Done!
```

```
##   usuário   sistema decorrido 
##      0.08      0.05      4.93
```




# Coordenadas de objetos
Os usuários podem obter as coordenadas para todos os objetos desejados com `object_coord()`. Quando o argumento `id` é definido como `NULL` (padrão), um retângulo delimitador é desenhado incluindo todos os objetos. Use `id = "all"` para obter as coordenadas de todos os objetos na imagem ou use um vetor numérico para indicar os objetos para calcular as coordenadas. Note que o argumento `watershed = FALSE` é usado para 



```r
folhas <- image_import("folhas.jpg", plot = TRUE)

# obter o id de cada objeto
object_id(folhas,
          watershed = FALSE)
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/objec2-1.png" width="672" />

```r
# Obtenha as coordenadas de um retângulo delimitador em torno de todos os objetos
object_coord(folhas,
             watershed = FALSE)
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/objec2-2.png" width="672" />

```
## $col_min
## [1] 49
## 
## $col_max
## [1] 937
## 
## $row_min
## [1] 41
## 
## $row_max
## [1] 702
```

```r
# Obtenha as coordenadas para todos os objetos
object_coord(folhas,
             id = "all",
             watershed = FALSE)
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/objec2-3.png" width="672" />

```
## $col_min
## [1]  49 710
## 
## $col_max
## [1] 603 937
## 
## $row_min
## [1] 379  41
## 
## $row_max
## [1] 702 424
```

```r
# Obtenha as coordenadas dos objetos 1 e 2
# 20 pixeis de borda
object_coord(folhas,
             id = 1,
             edge = 20,
             watershed = FALSE)
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/objec2-4.png" width="672" />

```
## $col_min
## [1] 31
## 
## $col_max
## [1] 621
## 
## $row_min
## [1] 361
## 
## $row_max
## [1] 720
```



# Isolando objetos

Conhecendo as coordenadas de cada objeto, é possível isolá-lo. A função `object_isolate()` é usada para isso. No exemplo a seguir, irei isolar o objeto 1 e definir uma borda de 5 pixels ao redor do objeto.


```r
id1 <- 
  object_isolate(folhas,
                 watershed = FALSE,
                 id = 1,
                 edge = 10)
plot(id1)
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/objec3-1.png" width="672" />

# Incluindo objetos em uma lista

Considerando esta mesma lógica, é possível dividir uma série de objetos contidos em uma única imagem e incluí-los em uma lista, utilizando `object_split()`. Por padrão, o fundo é removido, sendo mostrado na cor branca.


```r
list <- 
  object_split(folhas, 
               watershed = FALSE)
```

```
## ==============================
## Summary of the procedure
## ==============================
## Number of objects: 2 
## Average area     : 67972 
## Minimum area     : 54043 
## Maximum area     : 81901 
## Objects created  : 2 
## ==============================
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/unnamed-chunk-39-1.png" width="960" />




# Valores RGB para cada objeto

Para obter a intensidade RGB de cada objeto da imagem, usamos o argumento `object_rgb = TRUE` na função `analyze_objects() `. No seguinte exemplo,  utilizaremos as bandas R, G e B e seus valores normalizados. A função `pliman_indexes()` retorna os índices disponíveis no pacote. Para computar um índice específico, basta entrar com uma fórmula contendo os valores de R, G, ou B (ex. `object_index = "B/G+R"`). 




```r
img <- image_import("green.jpg", plot = TRUE)
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/rgb2-1.png" width="960" />

```r
(indx <- pliman_indexes())
```

```
##  [1] "R"     "G"     "B"     "NR"    "NG"    "NB"    "GB"    "RB"    "GR"   
## [10] "BI"    "BIM"   "SCI"   "GLI"   "HI"    "NGRDI" "NDGBI" "NDRBI" "I"    
## [19] "S"     "VARI"  "HUE"   "HUE2"  "BGI"   "L"     "GRAY"  "GLAI"  "SAT"  
## [28] "CI"    "SHP"   "RI"
```

```r
soy_green <-
  analyze_objects(img,
                  object_index = indx[1:6], # R:NB
                  marker = "id",
                  marker_col = "black",
                  col_background = "white",
                  show_contour = FALSE)
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/rgb2-2.png" width="960" />

```r
# PCA com os índices
ind <- summary_index(soy_green, type = "var")
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/rgb2-3.png" width="960" />

O índice `R` proporcionou a maior contribuição para a variação do PC1. O biplot contendo os índices (variáveis) e os grãos (indivíduos) pode ser visto abaixo.


```r
get_biplot(ind$pca_res, show = "var")
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/unnamed-chunk-40-1.png" width="768" /><img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/unnamed-chunk-40-2.png" width="768" />

```r
get_biplot(ind$pca_res, show = "ind")
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/unnamed-chunk-40-3.png" width="768" />


Agora, vamos plotar o índice `R` em cada objeto


```r
plot(img)
plot_measures(soy_green,
              measure = "R",
              col = "black")
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/unnamed-chunk-41-1.png" width="672" />

Parece que grãos com valores médios de vermelho (`R``) inferiores a 0.6 podem ser consideradas sementes esverdeadas. Os usuários podem então trabalhar com esse recurso e adaptá-lo ao seu caso.


```r
report <- 
  summary_index(soy_green,
                index = "R",
                cut_point = 0.6,
                plot = FALSE)
ids <- report$ids
report$between_id
```

```
##    n nsel prop mean_index_sel mean_index_nsel
## 1 50    5  0.1      0.5448581       0.7053636
```

```r
report$within_id[ids,]
```

```
##    id        x        y n_less n_greater less_ratio greater_ratio
## 30 30 520.5038 364.3333   2717       169      0.941         0.059
## 45 45 732.0470 638.1619   1588       370      0.811         0.189
## 47 47 282.1431 502.3110   1179       834      0.586         0.414
## 48 48 207.0196 808.0633    851       934      0.477         0.523
## 50 50 511.4493 808.5008   2389        15      0.994         0.006
```

```r
# proporção de pixeis de cada objeto (acima e abaixo de 0.6)
barplot(t(report$within_id[,6:7]) |> as.matrix(),
        legend = c("R < 0.6", "R > 0.6"))
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/rgb4-1.png" width="960" />


No seguinte gráfico, ploto a distribuição dos valores de R, G e B dos esverdeados e não esverdeados.


```r
# distribuição dos valores RGB
rgbs <-
  soy_green$object_rgb |>
  mutate(type = ifelse(id %in% ids, "Esverdeado", "Não esverdeado")) |>
  select(-id) |>
  pivot_longer(-type)

ggplot(rgbs, aes(x = value)) +
  geom_density(aes(fill = name), alpha = 0.5) +
  facet_wrap(~type)
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/unnamed-chunk-42-1.png" width="672" />

Agora, usando os ids de cada grão, ploto os valores somente nos esverdeados.


```r
# plotar 
plot(img)
plot_measures(soy_green,
              id = ids,
              measure = "R",
              col = "black")
cont <- object_contour(img, show_image = FALSE)
plot_contour(cont,
             id = ids,
             col = "red")
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/unnamed-chunk-43-1.png" width="672" />

Quando existem muitos objetos, o argumento `parallel = TRUE` irá acelerar a extração dos valores RGB. No exemplo a seguir, uma imagem com 1343 grãos de *Vicia cracca* é analisada. Os índices `"R"` e `"R/G"` são computados. Os grãos com um valor médio de vermelho superior a 0,25 são destacados.


```r
img2 <- image_import("vicia.jpg", plot = TRUE)

vicia <-
  analyze_objects(img2,
                  index = "B",
                  object_index = "R",
                  show_image = FALSE,
                  parallel = TRUE)

resumo_indice <- 
  summary_index(vicia,
                index = "R",
                cut_point = 0.25,
                select_higher = TRUE)

cont2 <-
  object_contour(img2,
                 index = "B",
                 show_image = FALSE)
ids2 <- resumo_indice$ids
plot_contour(cont2, id = ids2, col = "red")
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/rgb5-1.png" width="1152" />






# Área foliar
## Resolução conhecida

```r
folhas <- image_import(image = "ref_leaves.jpg", plot = TRUE)
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/unnamed-chunk-44-1.png" width="672" />

```r
af <-
  analyze_objects(folhas,
                  watershed = FALSE,
                  show_contour = FALSE,
                  col_background = "black",
                  marker = "id")
af_cor <- get_measures(af, dpi = 50.5)

plot_measures(af_cor,
              measure = "area",
              vjust = -30,
              col = "red")
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/unnamed-chunk-44-2.png" width="672" />



## Objeto de referência (dev version)

Na versão de desenvolvimento, foi incluído o argumento `reference`. Isto possibilita corrigir as medidas de objetos utilizando um objeto de referência. Neste exemplo, a área foliar da imagem `ref_leaves` é quantificada e corrigida considerando como objeto de referência, um quadrado branco de 5 x 5 (25 cm$^2$). Para isso, é necessário fornecer paletas de cores referentes ao fundo (`background`), folhas (`foreground`) e o objeto de referência (`reference`). Além disso, a área do objeto de referência precisa ser informada em `reference_area`.


```r
img <- image_import(pattern = "ref_", plot = TRUE)
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/unnamed-chunk-45-1.png" width="672" />

```r
area <- 
  analyze_objects(img = "ref_leaves",
                  foreground = "ref_folha",
                  background = "ref_back",
                  reference = "ref_ref",
                  reference_area = 25,
                  marker = "area",
                  watershed = FALSE)
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/unnamed-chunk-45-2.png" width="672" />




## Preenchendo 'buracos'
Um aspecto importante a se considerar é quando há a presença de 'buracos' nas folhas. Isto pode ocorrer, por exemplo, pelo ataque de pragas. Neste caso, a área teria que ser considerada, pois ela estava lá!


```r
holes <- image_import("holes.jpg", plot = TRUE)
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/unnamed-chunk-46-1.png" width="960" />

```r
af <-
  analyze_objects(holes,
                  watershed = FALSE,
                  col_background = "white",
                  marker = "area",
                  marker_col = "red",
                  marker_size = 3,
                  show_image = FALSE,
                  save_image = TRUE,
                  dir_processed = tempdir(),
                  contour_size = 5)

af2 <-
  analyze_objects(holes,
                  fill_hull = TRUE, # preenche 'buracos'
                  watershed = FALSE,
                  col_background = "white",
                  marker = "area",
                  marker_col = "red",
                  marker_size = 3,
                  show_image = FALSE,
                  save_image = TRUE,
                  prefix = "proc2_",
                  dir_processed = tempdir(),
                  contour_size = 5)

imgs <- image_import(pattern = "proc", path = tempdir())
image_combine(imgs)
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/unnamed-chunk-46-2.png" width="960" />



## Várias imagens da mesma amostra

Se os usuários precisarem analisar várias imagens da mesma amostra, as imagens da mesma amostra devem compartilhar o mesmo prefixo de nome de arquivo, que é definido como a parte do nome do arquivo que precede o primeiro hífen (`-`) ou underscore (`_`). Então, ao usar `get_measures()`, as medidas das imagens de folhas chamadas, por exemplo, `F1-1.jpeg`,` F1_2.jpeg` e `F1-3.jpeg` serão combinadas em uma única imagem (`F1`), mostrado no objeto `merge`. Isso é útil, por exemplo, para analisar folhas grandes que precisam ser divididas em várias imagens ou várias folhas pertencentes à mesma amostra que não podem ser digitalizadas em uma imagem única.

No exemplo a seguir, cinco imagens serão usadas como exemplos. Cada imagem possui folhas de diferentes espécies. As imagens foram divididas em imagens diferentes que compartilham o mesmo prefixo (por exemplo, L1_\*, L2_\* e assim por diante). Observe que para garantir que todas as imagens sejam processadas, todas as imagens devem compartilhar um padrão comum, neste caso ("L"). Os três pontos no canto inferior direito têm uma distância conhecida de 5 cm entre eles, que pode ser usada para extrair o dpi da imagem com `dpi()`. Apenas para fins didáticos, considerarei que todas as imagens têm resolução de 100 dpi.



```r
# imagens inteiras
imgs <-
  image_import(pattern = "leaf",
               plot = TRUE,
               ncol = 2)
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/merge0-1.png" width="960" />

```r
# imagens da mesma amostra
sample_imgs <-
  image_import(pattern = "L",
               plot = TRUE,
               ncol = 5)
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/merge0-2.png" width="960" />

Aqui, usarei o `pattern =" L "` para indicar que todas as imagens com este nome de padrão devem ser analisadas. O índice verde (`" G "`) é usado para segmentar as folhas e `divisor de águas = FALSO` é usado para omitir o algoritmo de segmentação de divisor de águas.



```r
merged <-
  analyze_objects(pattern = "L",
                  index = "B",
                  watershed = FALSE)
```

```
## Processing image L1_1 |====                                      | 8% 00:00:00 
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/merge1-1.png" width="672" />

```
## Processing image L1_2 |=======                                   | 17% 00:00:00 
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/merge1-2.png" width="672" />

```
## Processing image L2_1 |==========                                | 25% 00:00:00 
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/merge1-3.png" width="672" />

```
## Processing image L2_2 |==============                            | 33% 00:00:01 
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/merge1-4.png" width="672" />

```
## Processing image L3_1 |==================                        | 42% 00:00:01 
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/merge1-5.png" width="672" />

```
## Processing image L3_2 |=====================                     | 50% 00:00:01 
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/merge1-6.png" width="672" />

```
## Processing image L3_3 |========================                  | 58% 00:00:02 
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/merge1-7.png" width="672" />

```
## Processing image L4_1 |============================              | 67% 00:00:02 
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/merge1-8.png" width="672" />

```
## Processing image L4_2 |================================          | 75% 00:00:02 
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/merge1-9.png" width="672" />

```
## Processing image L4_3 |===================================       | 83% 00:00:03 
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/merge1-10.png" width="672" />

```
## Processing image L5_1 |======================================    | 92% 00:00:03 
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/merge1-11.png" width="672" />

```
## Processing image L5_2 |==========================================| 100% 00:00:03 
```

```
## --------------------------------------------
##  Image Objects
##   L1_1       1
##   L1_2       1
##   L2_1       2
##   L2_2       3
##   L3_1       1
##   L3_2       1
##   L3_3       1
##   L4_1       2
##   L4_2       2
##   L4_3       3
##   L5_1       3
##   L5_2       3
## --------------------------------------------
```

```
## Done!
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/merge1-12.png" width="672" />

Usando a função `get_measures()` é possível converter as medidas de unidades de pixel em unidades métricas (cm$^ 2$).


```r
merged_cor <- get_measures(merged, dpi = 100)
```

Observe que o `merged_cor` é uma lista com três objetos:

* `results`: um data frame que contém as medidas de cada objeto individual (neste caso, folha) de cada imagem analisada.


```r
merged_cor$results %>% 
  print_tbl()
```



|img  | id|       x|       y|    area| area_ch| perimeter| radius_mean| radius_min| radius_max| radius_sd| diam_mean| diam_min| diam_max| major_axis| minor_axis| length|   width| radius_ratio| eccentricity|  theta| solidity| convexity| elongation| circularity| circularity_haralick| circularity_norm|
|:----|--:|-------:|-------:|-------:|-------:|---------:|-----------:|----------:|----------:|---------:|---------:|--------:|--------:|----------:|----------:|------:|-------:|------------:|------------:|------:|--------:|---------:|----------:|-----------:|--------------------:|----------------:|
|L1_1 |  1| 427.723| 516.719| 102.170|   7.423|   133.418|       6.217|      0.561|     11.913|     2.899|    12.435|    1.122|   23.826|     19.863|     15.144| 21.566| 723.144|       21.226|        0.639|  0.158|    0.350|     0.403|      0.148|     174.222|                2.145|           14.066|
|L1_2 |  1| 372.556| 526.031|  92.840|   5.258|   123.954|       5.341|      1.042|     10.168|     2.186|    10.682|    2.085|   20.336|     15.123|     13.215| 16.922| 579.543|        9.754|        0.804|  0.600|    0.448|     0.388|      0.130|     165.496|                2.443|           13.363|
|L2_1 |  1| 251.404| 282.798|  46.319|   1.188|    28.449|       3.936|      2.527|      5.920|     0.911|     7.872|    5.054|   11.840|     10.479|      5.708| 11.347| 234.501|        2.342|        0.391|  1.502|    0.990|     0.920|      0.475|      17.473|                4.320|            1.400|
|L2_1 |  2| 146.366| 701.900|  35.305|   0.918|    25.682|       3.441|      2.311|      5.209|     0.820|     6.881|    4.621|   10.417|      9.308|      4.873| 10.314| 198.859|        2.254|        0.372| -1.533|    0.977|     0.909|      0.510|      18.682|                4.197|            1.498|
|L2_2 |  1| 326.113| 391.141|  19.026|   0.488|    19.480|       2.613|      1.659|      4.129|     0.737|     5.225|    3.319|    8.259|      7.301|      3.375|  8.154| 140.051|        2.488|        0.272|  1.560|    0.990|     0.912|      0.564|      19.945|                3.546|            1.605|
|L2_2 |  2| 113.850| 755.321|  38.153|   0.982|    25.140|       3.534|      2.518|      5.097|     0.664|     7.069|    5.036|   10.195|      8.955|      5.462|  9.755| 222.389|        2.024|        0.476|  1.556|    0.987|     0.915|      0.421|      16.565|                5.319|            1.327|
|L2_2 |  3| 376.213| 784.804|  16.320|   0.418|    17.290|       2.365|      1.532|      3.616|     0.604|     4.730|    3.063|    7.231|      6.509|      3.238|  7.151| 137.701|        2.361|        0.327|  1.395|    0.993|     0.923|      0.511|      18.317|                3.918|            1.474|
|L3_1 |  1| 253.962| 480.290|  64.082|   2.993|    92.040|       4.199|      0.408|      9.476|     2.050|     8.397|    0.817|   18.952|     15.225|      8.681| 15.718| 391.803|       23.207|        0.371| -1.550|    0.544|     0.385|      0.367|     132.194|                2.048|           10.566|
|L3_2 |  1| 200.077| 436.484|  30.205|   1.462|    63.289|       2.830|      0.065|      6.576|     1.425|     5.661|    0.131|   13.152|      9.857|      7.103| 10.814| 323.238|      100.588|        0.511|  1.564|    0.525|     0.395|      0.241|     132.609|                1.986|           10.802|
|L3_3 |  1| 204.984| 363.476|  52.026|   2.219|    93.326|       3.494|      0.077|      7.821|     1.656|     6.989|    0.155|   15.641|     12.404|      8.414| 13.411| 365.188|      101.216|        0.467|  1.538|    0.595|     0.385|      0.308|     167.412|                2.110|           13.578|
|L4_1 |  1| 270.258| 326.544|  54.355|   1.391|    29.242|       4.177|      3.390|      5.717|     0.557|     8.354|    6.780|   11.434|      9.918|      7.035| 10.438| 285.642|        1.686|        0.616|  1.484|    0.992|     0.899|      0.305|      15.731|                7.495|            1.259|
|L4_1 |  3| 252.952| 845.157|  61.679|   1.625|    34.029|       4.540|      3.654|      6.488|     0.704|     9.080|    7.307|   12.975|     10.549|      7.549| 11.940| 313.620|        1.776|        0.544|  1.428|    0.964|     0.877|      0.333|      18.774|                6.447|            1.503|
|L4_2 |  1| 291.942| 235.565|  61.503|   1.597|    32.955|       4.544|      3.148|      6.592|     0.823|     9.087|    6.297|   13.183|     10.970|      7.278| 12.132| 297.169|        2.094|        0.475| -1.332|    0.978|     0.913|      0.378|      17.658|                5.520|            1.413|
|L4_2 |  2| 260.787| 799.754|  73.268|   1.915|    35.872|       4.938|      3.787|      7.013|     0.779|     9.876|    7.574|   14.026|     11.609|      8.152| 12.735| 325.870|        1.852|        0.525|  1.527|    0.972|     0.858|      0.350|      17.563|                6.342|            1.405|
|L4_3 |  1| 206.166| 213.417|  29.186|   0.751|    22.252|       3.097|      2.054|      4.374|     0.668|     6.193|    4.107|    8.748|      8.256|      4.535|  8.532| 181.531|        2.130|        0.412| -1.536|    0.987|     0.901|      0.460|      16.965|                4.633|            1.361|
|L4_3 |  2| 219.514| 552.896|  19.503|   0.519|    19.444|       2.595|      1.608|      3.940|     0.648|     5.191|    3.215|    7.881|      7.069|      3.548|  7.552| 145.554|        2.451|        0.324|  1.538|    0.954|     0.870|      0.510|      19.386|                4.008|            1.560|
|L4_3 |  3| 229.163| 937.157|  34.149|   0.900|    27.156|       3.470|      2.211|      5.138|     0.799|     6.940|    4.421|   10.277|      8.809|      5.090|  9.483| 210.667|        2.324|        0.344|  1.471|    0.964|     0.856|      0.436|      21.596|                4.342|            1.734|
|L5_1 |  1| 225.338| 275.720|  52.797|   1.383|    35.431|       4.590|      2.259|      7.735|     1.623|     9.179|    4.517|   15.470|     13.610|      5.029| 15.329| 204.313|        3.425|        0.175| -1.479|    0.970|     0.890|      0.661|      23.777|                2.828|            1.906|
|L5_1 |  2| 335.525| 884.869|  31.675|   0.828|    28.086|       3.619|      1.727|      6.199|     1.321|     7.237|    3.454|   12.398|     10.718|      3.823| 12.264| 159.670|        3.590|        0.156|  1.382|    0.971|     0.894|      0.669|      24.903|                2.739|            2.001|
|L5_1 |  3| 120.360| 887.853|  30.192|   0.821|    30.496|       3.827|      1.649|      6.774|     1.523|     7.654|    3.297|   13.549|     11.055|      3.579| 13.464| 149.277|        4.109|        0.109| -1.564|    0.934|     0.918|      0.718|      30.803|                2.512|            2.480|
|L5_2 |  1| 339.022| 300.133|  45.622|   1.189|    33.995|       4.331|      2.188|      7.465|     1.609|     8.662|    4.376|   14.930|     13.160|      4.466| 14.760| 183.139|        3.412|        0.152| -1.547|    0.974|     0.897|      0.685|      25.332|                2.691|            2.033|
|L5_2 |  2| 205.390| 802.624|  42.866|   1.115|    33.289|       4.267|      2.060|      7.335|     1.583|     8.534|    4.120|   14.670|     12.766|      4.355| 14.614| 179.397|        3.561|        0.144|  1.508|    0.976|     0.912|      0.688|      25.852|                2.695|            2.075|
|L5_2 |  3| 535.301| 819.600|  44.996|   1.176|    33.320|       4.300|      1.992|      7.465|     1.584|     8.600|    3.984|   14.930|     13.069|      4.450| 14.488| 185.768|        3.748|        0.155| -1.450|    0.972|     0.915|      0.674|      24.674|                2.714|            1.980|

* `summary`: um data frame que contém o resumo dos resultados, contendo o número de objetos em cada imagem (`n`) a soma, média e desvio padrão da área de cada imagem, bem como o valor médio para todas as outras medidas (perímetro, raio, etc.)



```r
merged_cor$summary %>% 
  print_tbl()
```



|img  |  n| area_sum| area_mean| area_sd| area_ch| perimeter| radius_mean| radius_min| radius_max| radius_sd| diam_mean| diam_min| diam_max| major_axis| minor_axis| length|   width| radius_ratio| eccentricity|  theta| solidity| convexity| elongation| circularity| circularity_haralick| circularity_norm|
|:----|--:|--------:|---------:|-------:|-------:|---------:|-----------:|----------:|----------:|---------:|---------:|--------:|--------:|----------:|----------:|------:|-------:|------------:|------------:|------:|--------:|---------:|----------:|-----------:|--------------------:|----------------:|
|L1_1 |  1|  102.170|   102.170|   0.000|   7.423|   133.418|       6.217|      0.561|     11.913|     2.899|    12.435|    1.122|   23.826|     19.863|     15.144| 21.566| 723.144|       21.226|        0.639|  0.158|    0.350|     0.403|      0.148|     174.222|                2.145|           14.066|
|L1_2 |  1|   92.840|    92.840|   0.000|   5.258|   123.954|       5.341|      1.042|     10.168|     2.186|    10.682|    2.085|   20.336|     15.123|     13.215| 16.922| 579.543|        9.754|        0.804|  0.600|    0.448|     0.388|      0.130|     165.496|                2.443|           13.363|
|L2_1 |  2|   81.624|    40.812|   7.788|   1.053|    27.065|       3.688|      2.419|      5.564|     0.865|     7.377|    4.838|   11.128|      9.893|      5.290| 10.830| 216.680|        2.298|        0.381| -0.016|    0.983|     0.914|      0.493|      18.078|                4.258|            1.449|
|L2_2 |  3|   73.500|    24.500|  11.901|   0.629|    20.637|       2.837|      1.903|      4.281|     0.668|     5.675|    3.806|    8.562|      7.588|      4.025|  8.353| 166.714|        2.291|        0.358|  1.504|    0.990|     0.917|      0.499|      18.276|                4.261|            1.469|
|L3_1 |  1|   64.082|    64.082|   0.000|   2.993|    92.040|       4.199|      0.408|      9.476|     2.050|     8.397|    0.817|   18.952|     15.225|      8.681| 15.718| 391.803|       23.207|        0.371| -1.550|    0.544|     0.385|      0.367|     132.194|                2.048|           10.566|
|L3_2 |  1|   30.205|    30.205|   0.000|   1.462|    63.289|       2.830|      0.065|      6.576|     1.425|     5.661|    0.131|   13.152|      9.857|      7.103| 10.814| 323.238|      100.588|        0.511|  1.564|    0.525|     0.395|      0.241|     132.609|                1.986|           10.802|
|L3_3 |  1|   52.026|    52.026|   0.000|   2.219|    93.326|       3.494|      0.077|      7.821|     1.656|     6.989|    0.155|   15.641|     12.404|      8.414| 13.411| 365.188|      101.216|        0.467|  1.538|    0.595|     0.385|      0.308|     167.412|                2.110|           13.578|
|L4_1 |  2|  116.034|    58.017|   5.178|   1.508|    31.635|       4.358|      3.522|      6.102|     0.631|     8.717|    7.044|   12.205|     10.233|      7.292| 11.189| 299.631|        1.731|        0.580|  1.456|    0.978|     0.888|      0.319|      17.253|                6.971|            1.381|
|L4_2 |  2|  134.771|    67.385|   8.319|   1.756|    34.413|       4.741|      3.468|      6.802|     0.801|     9.482|    6.936|   13.605|     11.289|      7.715| 12.433| 311.519|        1.973|        0.500|  0.097|    0.975|     0.886|      0.364|      17.610|                5.931|            1.409|
|L4_3 |  3|   82.838|    27.613|   7.449|   0.723|    22.951|       3.054|      1.957|      4.484|     0.705|     6.108|    3.915|    8.968|      8.045|      4.391|  8.522| 179.251|        2.302|        0.360|  0.491|    0.968|     0.876|      0.469|      19.315|                4.328|            1.552|
|L5_1 |  3|  114.664|    38.221|  12.645|   1.011|    31.338|       4.012|      1.878|      6.903|     1.489|     8.023|    3.756|   13.806|     11.795|      4.144| 13.686| 171.087|        3.708|        0.147| -0.554|    0.958|     0.901|      0.683|      26.494|                2.693|            2.129|
|L5_2 |  3|  133.484|    44.495|   1.445|   1.160|    33.535|       4.299|      2.080|      7.422|     1.592|     8.599|    4.160|   14.843|     12.998|      4.424| 14.620| 182.768|        3.573|        0.150| -0.496|    0.974|     0.908|      0.682|      25.286|                2.700|            2.029|

* `merge`: um data frame que contém os resultados mesclados pelo prefixo da imagem. Observe que, neste caso, os resultados são apresentados por L1, L2, L3, L4 e L5.


```r
merged_cor$merge %>% 
  print_tbl()
```



|img |  n| area_sum| area_mean| area_sd| area_ch| perimeter| radius_mean| radius_min| radius_max| radius_sd| diam_mean| diam_min| diam_max| major_axis| minor_axis| length|   width| radius_ratio| eccentricity|  theta| solidity| convexity| elongation| circularity| circularity_haralick| circularity_norm|
|:---|--:|--------:|---------:|-------:|-------:|---------:|-----------:|----------:|----------:|---------:|---------:|--------:|--------:|----------:|----------:|------:|-------:|------------:|------------:|------:|--------:|---------:|----------:|-----------:|--------------------:|----------------:|
|L1  |  2|  195.010|    97.505|   0.000|   6.341|   128.686|       5.779|      0.802|     11.040|     2.542|    11.558|    1.604|   22.081|     17.493|     14.179| 19.244| 651.343|       15.490|        0.722|  0.379|    0.399|     0.396|      0.139|     169.859|                2.294|           13.714|
|L2  |  5|  155.124|    32.656|   9.845|   0.841|    23.851|       3.263|      2.161|      4.922|     0.767|     6.526|    4.322|    9.845|      8.741|      4.658|  9.592| 191.697|        2.295|        0.370|  0.744|    0.987|     0.916|      0.496|      18.177|                4.260|            1.459|
|L3  |  3|  146.313|    48.771|   0.000|   2.225|    82.885|       3.508|      0.184|      7.958|     1.711|     7.016|    0.367|   15.915|     12.495|      8.066| 13.314| 360.076|       75.004|        0.450|  0.517|    0.555|     0.389|      0.305|     144.072|                2.048|           11.649|
|L4  |  7|  333.643|    51.005|   6.982|   1.329|    29.666|       4.051|      2.982|      5.796|     0.712|     8.102|    5.965|   11.592|      9.856|      6.466| 10.715| 263.467|        2.002|        0.480|  0.681|    0.974|     0.883|      0.384|      18.059|                5.743|            1.447|
|L5  |  6|  248.149|    41.358|   7.045|   1.085|    32.436|       4.156|      1.979|      7.162|     1.541|     8.311|    3.958|   14.325|     12.396|      4.284| 14.153| 176.927|        3.641|        0.148| -0.525|    0.966|     0.904|      0.683|      25.890|                2.697|            2.079|

O `area_sum` de img` L1` é a soma das duas folhas (uma em cada imagem)


```r
sum(merged_cor$results$area[1:2])
```

```
## [1] 195.01
```





```r
df_leaf <-
  merged_cor$results %>% 
  separate(img, into = c("img", "code"))

# leaf area of the different species
p1 <- 
  ggplot(df_leaf, aes(x = img, y = area)) +
  geom_boxplot() +
  geom_jitter(color = "red") +
  labs(x = "Imagem", y = expression(Área~(cm^2)))

p2 <- 
  ggplot(df_leaf, aes(x = img, y = area)) +
  stat_summary(fun = sum,
               geom = "bar",
               # fill = "white",
               col = "black") +
  labs(x = "Imagem", y = expression(Área~total~(cm^2)))


# solidity of the different species
p3 <- 
  ggplot(df_leaf, aes(x = img, y = solidity)) +
  geom_boxplot() +
  geom_jitter(color = "red") +
  labs(x = "Imagem", y = "Solidez")

p1 + p2 + p3 +
  plot_layout(ncol = 3)
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/merge9-1.png" width="960" />












[^1] Singer, M.H. 1993. A general approach to moment calculation for polygons and line segments. Pattern Recognition 26(7): 1019–1028. doi: 10.1016/0031-3203(93)90003-F.


[^2] Chen, C.H., and P.S.P. Wang. 2005. Handbook of Pattern Recognition and Computer Vision. 3rd ed. World Scientific.

[^3] Claude, J. 2008. Morphometrics with R. Springer.

[^4] Montero, R.S., E. Bribiesca, R. Santiago, and E. Bribiesca. 2009. State of the Art of Compactness and Circularity Measures. International Mathematical Forum 4(27): 1305–1335.

[^5] Lee, Y., and W. Lim. 2017. Fórmula de cadarço: conectando a área de um polígono e o produto vetorial vetorial. The Mathematics Teacher 110(8): 631–636. doi: 10.5951/MATHTEACHER.110.8.0631.

[^6] Montero, R.S., E. Bribiesca, R. Santiago, and E. Bribiesca. 2009. State of the Art of Compactness and Circularity Measures. International Mathematical Forum 4(27): 1305–1335

[^7] Haralick, R.M. 1974. A Measure for Circularity of Digital Figures. IEEE Transactions on Systems, Man, and Cybernetics SMC-4(4): 394–396. doi: 10.1109/TSMC.1974.5408463.

