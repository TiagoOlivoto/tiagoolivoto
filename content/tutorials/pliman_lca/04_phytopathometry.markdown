---
title: Fitopatometria
linktitle: "4. Fitopatometria"
toc: true
type: docs
date: "2021/11/25"
lastmod: "2021/12/11"
draft: false
df_print: paged
code_download: true
menu:
  plimanlca:
    parent: pliman
    weight: 5
weight: 4
---



# Diretório das imagens

```r
# mudar de acordo com a pasta em seu computador
setwd("E:/Desktop/tiagoolivoto/static/tutorials/pliman_lca/imgs")
```


# Severidade de doenças
## Utilizando paletas


```r
# gerar tabelas html
print_tbl <- function(table,  digits = 3, ...){
  knitr::kable(table, booktabs = TRUE, digits = digits, ...)
}
library(pliman)
## |==========================================================|
## | Tools for Plant Image Analysis (pliman 1.0.0)            |
## | Author: Tiago Olivoto                                    |
## | Type 'vignette('pliman_start')' for a short tutorial     |
## | Visit 'http://bit.ly/pkg_pliman' for a complete tutorial |
## |==========================================================|
library(tidyverse)
## -- Attaching packages --------------------------------------- tidyverse 1.3.1 --
## v ggplot2 3.3.5     v purrr   0.3.4
## v tibble  3.1.6     v dplyr   1.0.7
## v tidyr   1.1.4     v stringr 1.4.0
## v readr   2.1.1     v forcats 0.5.1
## Warning: package 'tidyr' was built under R version 4.1.1
## Warning: package 'readr' was built under R version 4.1.2
## -- Conflicts ------------------------------------------ tidyverse_conflicts() --
## x forcats::%>%()  masks stringr::%>%(), dplyr::%>%(), purrr::%>%(), tidyr::%>%(), tibble::%>%(), pliman::%>%()
## x dplyr::filter() masks stats::filter()
## x dplyr::lag()    masks stats::lag()

img <- image_import("img_1.jpeg")
h <- image_import("h_img1.png")
d <- image_import("d_img1.png")
b <- image_import("b_img1.png")
image_combine(img, h, d, b, ncol = 4)
```

<img src="/tutorials/pliman_lca/04_phytopathometry_files/figure-html/doença1-1.png" width="1152" />

## Gerando paletas

```r
h2 <- pick_palette(img)
d2 <- pick_palette(img)
b2 <- pick_palette(img)
image_combine(h2, d2, b2, ncol = 3)
```


### Padrão da função

```r
sev <- 
  measure_disease(img = img,
                  img_healthy = h,
                  img_symptoms = d,
                  img_background = b)
```

<img src="/tutorials/pliman_lca/04_phytopathometry_files/figure-html/unnamed-chunk-4-1.png" width="672" />


### Mostrando preenchimento das lesões

```r
sev <- 
  measure_disease(img = img,
                  img_healthy = h,
                  img_symptoms = d,
                  img_background = b,
                  show_contour = FALSE)
```

<img src="/tutorials/pliman_lca/04_phytopathometry_files/figure-html/unnamed-chunk-5-1.png" width="672" />


### Mostrando uma máscara

```r
sev <- 
  measure_disease(img = img,
                  img_healthy = h,
                  img_symptoms = d,
                  img_background = b,
                  show_contour = FALSE,
                  show_original = FALSE)
```

<img src="/tutorials/pliman_lca/04_phytopathometry_files/figure-html/unnamed-chunk-6-1.png" width="672" />


### Segmentando e analizando lesões

```r
sev <- 
  measure_disease(img = img,
                  img_healthy = h,
                  img_symptoms = d,
                  img_background = b,
                  watershed = TRUE,
                  show_contour = FALSE, # não mostra os contornos
                  show_features = TRUE, # computa características das lesões
                  show_segmentation = TRUE) # mostra as segmentações
```

<img src="/tutorials/pliman_lca/04_phytopathometry_files/figure-html/unnamed-chunk-7-1.png" width="672" />

```r
sev$severity
```

```
##    healthy symptomatic
## 1 76.94278    23.05722
```

```r
sev$statistics %>% 
  print_tbl()
```



|stat      |      value|
|:---------|----------:|
|n         |    431.000|
|min_area  |     31.000|
|mean_area |    406.283|
|max_area  |   6586.000|
|sd_area   |    552.724|
|sum_area  | 175108.000|

```r
sev$shape[1:10, ] %>% 
  print_tbl()
```



| id|        x|       y| area| perimeter| radius_mean| radius_min| radius_max| radius_sd| radius_ratio| major_axis| eccentricity|  theta|
|--:|--------:|-------:|----:|---------:|-----------:|----------:|----------:|---------:|------------:|----------:|------------:|------:|
|  1| 1060.232| 274.701| 6586|       402|      46.434|     19.017|     71.723|    11.831|        3.771|    117.813|        0.684| -0.033|
|  2| 1058.402| 361.558| 5244|       365|      40.401|     24.196|     53.301|     6.564|        2.203|     89.711|        0.443|  1.553|
|  3|  463.460| 536.435| 6231|       429|      45.403|     26.881|     62.254|     9.001|        2.316|    115.024|        0.765| -0.086|
|  4|  773.863| 402.433| 1732|       169|      23.187|     17.602|     30.820|     3.022|        1.751|     53.737|        0.611|  1.063|
|  5|  800.065| 317.236| 2773|       258|      30.123|     14.828|     43.296|     7.232|        2.920|     81.593|        0.805|  0.727|
|  6| 1122.574| 352.019| 1982|       209|      25.308|     15.513|     34.565|     4.717|        2.228|     61.117|        0.678| -0.538|
|  7| 1090.445| 469.572| 1228|       139|      19.715|      9.936|     25.412|     3.898|        2.558|     48.558|        0.684| -1.114|
|  8| 1108.853| 495.104| 1012|       112|      17.674|     14.540|     23.684|     2.117|        1.629|     38.382|        0.392| -0.923|
|  9|  331.419| 535.005| 1199|       139|      19.248|     12.415|     24.727|     2.738|        1.992|     45.022|        0.612| -1.554|
| 10|  788.480| 363.056| 1214|       163|      20.271|     12.088|     28.149|     4.072|        2.329|     50.513|        0.753| -1.145|



## Utilizando índices RGB
Para identificar o melhor índice para segmentar a imagem do fundo e após as lesões da folha sadia, pode-se utilizar a função `image_segment_iter`. (OBS. somente funcionará em uma seção iterativa).



```r
img %>% 
  image_resize(50) %>% 
  image_segment_iter(nseg = 2)
```

Após escolhidos os índices, podemos utilizar os argumentos `index_lb` e `index_dh` para segmentação da folha e fundo | lesão e sadio, respectivamente.


```r
# após escolhidos os índices, utiliza
sev_index <- 
  measure_disease(img, 
                  index_lb = "G",
                  index_dh = "NGRDI",
                  threshold = c("Otsu", -0.05),
                  show_image = TRUE)
```

<img src="/tutorials/pliman_lca/04_phytopathometry_files/figure-html/unnamed-chunk-9-1.png" width="672" />



## Processamento em lote
Para analisar diversas imagens de um diretório, utiliza-se o argumento `pattern`, para declarar um padrão de nomes de arquivos. Serão utilizadas 20 folhas de soja disponíveis no repositório  https://osf.io/4hbr6, um banco de dados de imagens de anotação de severidade de doenças de plantas. Obrigado a [Emerson M. Del Ponte](https://osf.io/jb6yd/) e seus colaboradores por manter este projeto disponível publicamente.


```r
system.time(
  sev_lote <- 
    measure_disease(pattern = "soy",
                    img_healthy = "healthy",
                    img_symptoms = "disease",
                    img_background = "back",
                    show_image = FALSE)
)
```

```
## Processing image soy_1 |==                                       | 5% 00:00:00 
Processing image soy_10 |====                                    | 10% 00:00:01 
Processing image soy_11 |======                                  | 15% 00:00:01 
Processing image soy_12 |========                                | 20% 00:00:02 
Processing image soy_13 |==========                              | 25% 00:00:02 
Processing image soy_14 |============                            | 30% 00:00:03 
Processing image soy_15 |==============                          | 35% 00:00:04 
Processing image soy_16 |================                        | 40% 00:00:04 
Processing image soy_17 |==================                      | 45% 00:00:04 
Processing image soy_18 |====================                    | 50% 00:00:06 
Processing image soy_19 |======================                  | 55% 00:00:07 
Processing image soy_2 |=========================                | 60% 00:00:08 
Processing image soy_20 |==========================              | 65% 00:00:09 
Processing image soy_3 |=============================            | 70% 00:00:10 
Processing image soy_4 |===============================          | 75% 00:00:10 
Processing image soy_5 |=================================        | 80% 00:00:11 
Processing image soy_6 |===================================      | 85% 00:00:12 
Processing image soy_7 |=====================================    | 90% 00:00:12 
Processing image soy_8 |=======================================  | 95% 00:00:13 
Processing image soy_9 |=========================================| 100% 00:00:14 
```

```
##   usuário   sistema decorrido 
##     14.17      0.84     15.03
```

```r
sev_lote$severity %>% 
  print_tbl()
```



|img    | healthy| symptomatic|
|:------|-------:|-----------:|
|soy_1  |  92.980|       7.020|
|soy_10 |  85.086|      14.914|
|soy_11 |  15.287|      84.713|
|soy_12 |  65.675|      34.325|
|soy_13 |  79.436|      20.564|
|soy_14 |  68.765|      31.235|
|soy_15 |  60.066|      39.934|
|soy_16 |  44.879|      55.121|
|soy_17 |  77.000|      23.000|
|soy_18 |  56.286|      43.714|
|soy_19 |  87.647|      12.353|
|soy_2  |  64.140|      35.860|
|soy_20 |  52.792|      47.208|
|soy_3  |  57.640|      42.360|
|soy_4  |  48.146|      51.854|
|soy_5  |  82.677|      17.323|
|soy_6  |  77.367|      22.633|
|soy_7  |  76.293|      23.707|
|soy_8  |  70.127|      29.873|
|soy_9  |  50.596|      49.404|


Para acelerar o tempo de processamento quando várias imagens estão disponíveis, pode-se utilizar o argumento `paralell`. Isto criará múltiplas seções R em segundo plano, sendo cada uma responsável pelo processamento de uma parte das imagens.


```r
system.time(
  sev_lote <- 
    measure_disease(pattern = "soy",
                    img_healthy = "healthy",
                    img_symptoms = "disease",
                    img_background = "back",
                    show_image = FALSE,
                    parallel = TRUE)
)
```

```
## Image processing using multiple sessions (6). Please wait.
```

```
##   usuário   sistema decorrido 
##      0.23      0.02      7.95
```


## Imagens processadas

```r
imgs <- 
  image_import(pattern = "proc_",
               path = "processed",
               plot = TRUE,
               ncol = 5)
```

<img src="/tutorials/pliman_lca/04_phytopathometry_files/figure-html/unnamed-chunk-12-1.png" width="960" />


# Número de ovos 
O seguinte exemplo demonstra como contar o número de ovos em uma folha. A imagem foi obtida do pacote [ExpImage](https://rdrr.io/cran/ExpImage/f/vignettes/Contagem_de_objetos.Rmd). Para identificar os melhores índices para segmentação da folha/fundo e ovos/folha, a função `image_segment_iter()` é usada. 



```r
ovos <- image_import("ovos.jpg", plot = TRUE)
```

<img src="/tutorials/pliman_lca/04_phytopathometry_files/figure-html/unnamed-chunk-13-1.png" width="672" />


```r
# funciona apenas em uma seção iterativa
image_segment_iter(img, nseg = 2)
```


Após conhecer os índices, o número de ovos é computado com a função `measure_disease()`, indicando os índices para segmentação.


```r
ovos_cont <- 
  measure_disease(ovos,
                  index_lb = "HUE2",
                  index_dh = "GRAY",
                  invert = c(FALSE, TRUE),
                  threshold = c("Otsu", 0.7),
                  show_features = TRUE,
                  show_segmentation = TRUE,
                  show_contour = FALSE)
```

<img src="/tutorials/pliman_lca/04_phytopathometry_files/figure-html/unnamed-chunk-15-1.png" width="672" />

```r
ovos_cont$statistics
```

```
##        stat       value
## 1         n  170.000000
## 2  min_area    7.000000
## 3 mean_area   12.147059
## 4  max_area   21.000000
## 5   sd_area    2.085912
## 6  sum_area 2065.000000
```

```r
ovos_cont <- 
  measure_disease(ovos,
                  index_lb = "HUE2",
                  index_dh = "GRAY",
                  invert = c(FALSE, TRUE),
                  threshold = c("Otsu", 0.7),
                  show_features = TRUE,
                  show_contour = FALSE,
                  col_lesions = "blue",
                  col_background = "black")
```

<img src="/tutorials/pliman_lca/04_phytopathometry_files/figure-html/unnamed-chunk-15-2.png" width="672" />



```r
# apenas na versão de desenvolvimento
pick_count(ovos)
```



# Mensuração iterativa

A função `measure_disease_iter()` fornece uma seção iterativa para `measure_disease()`, onde o usuário extrai amostras na imagem para criar as paletas de cores necessárias. `measure_disease_iter()` executa apenas em uma seção interativa. Nesta função, os usuários serão capazes extrair amostras de imagens para criar, iterativamente, as paletas de cores necessárias. Este processo chama `pick_palette()` internamente. Se `has_background` for `TRUE` (padrão), a paleta de cores do fundo é criada primeiro. A amostra de cores é realizada a cada clique com o botão esquerdo do mouse e continua até que o usuário pressione Esc. Em seguida, um novo processo de amostragem é realizado para amostrar a cor dos tecidos saudáveis e, em seguida, dos tecidos doentes. As paletas geradas são então passadas para `measure_disease()`. Todos os argumentos de tal função podem ser passados para `measure_disease()` usando `...` (três pontos).


```r
# somente roda em uma seção interativa
img <- image_pliman("sev_leaf.jpg", plot = TRUE)
measure_disease_iter(img)
```



# Desafios


```r
img <- image_import("maize_1.png", plot = TRUE)
```

<img src="/tutorials/pliman_lca/04_phytopathometry_files/figure-html/unnamed-chunk-18-1.png" width="672" />

```r
image_segment(img, index = "all")
```

<img src="/tutorials/pliman_lca/04_phytopathometry_files/figure-html/unnamed-chunk-18-2.png" width="672" />

```r
img <- image_import("maize_2.png", plot = TRUE)
```

<img src="/tutorials/pliman_lca/04_phytopathometry_files/figure-html/unnamed-chunk-18-3.png" width="672" />

```r
image_segment(img, index = "all")
```

<img src="/tutorials/pliman_lca/04_phytopathometry_files/figure-html/unnamed-chunk-18-4.png" width="672" />

```r
img2 <- image_crop(img,
                   width = 959:32,
                   height = 163:557,
                   plot = TRUE)


image_segment_iter(img2, 
                   nseg = 2, # define o número de segmentações
                   index = c("NR", "GLI"), # índices para primeira e segunda
                   invert = c(T, F), # inverter a segmentação? (passa um vetor)
                   ncol = 3) # número de colunas no plot
```

```
##      image  pixels   percent
## 1 original 1466240 100.00000
## 2     seg1   75147   5.12515
## 3     seg2   17325  23.05481
```

<img src="/tutorials/pliman_lca/04_phytopathometry_files/figure-html/unnamed-chunk-18-5.png" width="672" />
