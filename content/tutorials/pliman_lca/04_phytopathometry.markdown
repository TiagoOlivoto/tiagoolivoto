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
## 1 76.14718    23.85282
```

```r
sev$statistics %>% 
  print_tbl()
```



|stat      |      value|
|:---------|----------:|
|n         |    427.000|
|min_area  |     35.000|
|mean_area |    426.532|
|max_area  |   6576.000|
|sd_area   |    575.832|
|sum_area  | 182129.000|

```r
sev$shape[1:10, ] %>% 
  print_tbl()
```



| id|        x|       y| area| perimeter| radius_mean| radius_min| radius_max| radius_sd| radius_ratio| major_axis| eccentricity|  theta|
|--:|--------:|-------:|----:|---------:|-----------:|----------:|----------:|---------:|------------:|----------:|------------:|------:|
|  1| 1060.964| 275.024| 6576|       387|      46.189|     20.326|     68.615|    11.100|        3.376|    116.106|        0.674| -0.096|
|  2| 1058.586| 361.940| 5374|       357|      40.750|     24.956|     53.453|     6.411|        2.142|     89.893|        0.413| -1.523|
|  3|  463.466| 536.387| 6314|       429|      45.614|     28.180|     61.907|     8.926|        2.197|    115.672|        0.765| -0.080|
|  4|  635.018| 690.608| 2874|       285|      30.849|     15.679|     45.101|     7.036|        2.877|     73.281|        0.598|  1.253|
|  5|  773.888| 402.078| 1788|       164|      23.545|     18.760|     30.372|     2.897|        1.619|     54.789|        0.624|  1.105|
|  6|  799.965| 317.062| 2863|       265|      30.528|     14.858|     43.866|     7.321|        2.952|     82.434|        0.800|  0.740|
|  7| 1123.433| 351.884| 1999|       204|      25.320|     15.583|     34.270|     4.471|        2.199|     60.677|        0.662| -0.602|
|  8|  331.428| 534.973| 1197|       140|      19.188|     11.930|     24.835|     2.881|        2.082|     45.402|        0.625| -1.536|
|  9| 1089.920| 469.081| 1172|       135|      19.301|      9.230|     25.365|     3.989|        2.748|     48.006|        0.701| -1.027|
| 10| 1108.468| 494.505| 1088|       117|      18.332|     14.700|     24.660|     2.192|        1.678|     39.004|        0.307| -1.123|



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
Processing image soy_13 |==========                              | 25% 00:00:03 
Processing image soy_14 |============                            | 30% 00:00:04 
Processing image soy_15 |==============                          | 35% 00:00:04 
Processing image soy_16 |================                        | 40% 00:00:05 
Processing image soy_17 |==================                      | 45% 00:00:05 
Processing image soy_18 |====================                    | 50% 00:00:06 
Processing image soy_19 |======================                  | 55% 00:00:08 
Processing image soy_2 |=========================                | 60% 00:00:09 
Processing image soy_20 |==========================              | 65% 00:00:10 
Processing image soy_3 |=============================            | 70% 00:00:11 
Processing image soy_4 |===============================          | 75% 00:00:11 
Processing image soy_5 |=================================        | 80% 00:00:12 
Processing image soy_6 |===================================      | 85% 00:00:13 
Processing image soy_7 |=====================================    | 90% 00:00:14 
Processing image soy_8 |=======================================  | 95% 00:00:14 
Processing image soy_9 |=========================================| 100% 00:00:15 
```

```
##   usuário   sistema decorrido 
##     15.35      0.97     16.31
```

```r
sev_lote$severity %>% 
  print_tbl()
```



|img    | healthy| symptomatic|
|:------|-------:|-----------:|
|soy_1  |  92.511|       7.489|
|soy_10 |  85.063|      14.937|
|soy_11 |  15.940|      84.060|
|soy_12 |  65.898|      34.102|
|soy_13 |  81.815|      18.185|
|soy_14 |  65.210|      34.790|
|soy_15 |  58.286|      41.714|
|soy_16 |  51.201|      48.799|
|soy_17 |  76.457|      23.543|
|soy_18 |  56.327|      43.673|
|soy_19 |  87.746|      12.254|
|soy_2  |  63.783|      36.217|
|soy_20 |  52.773|      47.227|
|soy_3  |  60.121|      39.879|
|soy_4  |  45.607|      54.393|
|soy_5  |  83.137|      16.863|
|soy_6  |  77.256|      22.744|
|soy_7  |  75.937|      24.063|
|soy_8  |  69.901|      30.099|
|soy_9  |  51.906|      48.094|


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
##      0.19      0.04      9.03
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
