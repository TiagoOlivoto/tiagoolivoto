---
title: Fitopatometria
linktitle: "4. Fitopatometria"
toc: true
type: docs
date: "2021/10/27"
lastmod: "2021/10/27"
draft: false
df_print: paged
code_download: true
menu:
  plimanomegads:
    parent: pliman
    weight: 5
weight: 4
---



# Diretório das imagens

```r
# mudar de acordo com a pasta em seu computador
setwd("E:/Desktop/tiagoolivoto/static/tutorials/pliman_omegads/imgs")
```


# Severidade de doenças
## Utilizando paletas


```r
# gerar tabelas html
print_tbl <- function(table,  digits = 3, ...){
  knitr::kable(table, booktabs = TRUE, digits = digits, ...)
}
library(pliman)
```

```
## |=======================================================|
```

```
## | Tools for Plant Image Analysis (pliman 0.3.0)         |
```

```
## | Author: Tiago Olivoto                                 |
```

```
## | Type 'vignette('pliman_start')' for a short tutorial  |
```

```
## | Visit 'https://bit.ly/pliman' for a complete tutorial |
```

```
## |=======================================================|
```

```r
library(tidyverse)
```

```
## -- Attaching packages --------------------------------------- tidyverse 1.3.1 --
```

```
## v ggplot2 3.3.5     v purrr   0.3.4
## v tibble  3.1.4     v dplyr   1.0.7
## v tidyr   1.1.3     v stringr 1.4.0
## v readr   2.0.2     v forcats 0.5.1
```

```
## Warning: package 'tibble' was built under R version 4.1.1
```

```
## Warning: package 'readr' was built under R version 4.1.1
```

```
## -- Conflicts ------------------------------------------ tidyverse_conflicts() --
## x dplyr::filter() masks stats::filter()
## x dplyr::lag()    masks stats::lag()
```

```r
img <- image_import("img_1.jpeg")
h <- image_import("h_img1.png")
d <- image_import("d_img1.png")
b <- image_import("b_img1.png")
image_combine(img, h, d, b, ncol = 4)
```

<img src="/tutorials/pliman_omegads/04_phytopathometry_files/figure-html/doença1-1.png" width="1152" />


### Padrão da função

```r
sev <- 
  measure_disease(img = img,
                  img_healthy = h,
                  img_symptoms = d,
                  img_background = b,
                  show_image = TRUE)
```

<img src="/tutorials/pliman_omegads/04_phytopathometry_files/figure-html/unnamed-chunk-2-1.png" width="672" />


### Mostrando preenchimento das lesões

```r
sev <- 
  measure_disease(img = img,
                  img_healthy = h,
                  img_symptoms = d,
                  img_background = b,
                  show_image = TRUE,
                  show_contour = FALSE)
```

<img src="/tutorials/pliman_omegads/04_phytopathometry_files/figure-html/unnamed-chunk-3-1.png" width="672" />


### Mostrando uma máscara

```r
sev <- 
  measure_disease(img = img,
                  img_healthy = h,
                  img_symptoms = d,
                  img_background = b,
                  show_image = TRUE,
                  show_contour = FALSE,
                  show_original = FALSE)
```

<img src="/tutorials/pliman_omegads/04_phytopathometry_files/figure-html/unnamed-chunk-4-1.png" width="672" />


### Segmentando e analizando lesões

```r
sev <- 
  measure_disease(img = img,
                  img_healthy = h,
                  img_symptoms = d,
                  img_background = b,
                  show_image = TRUE,
                  watershed = TRUE,
                  show_contour = FALSE, # não mostra os contornos
                  show_features = TRUE, # computa características das lesões
                  show_segmentation = TRUE) # mostra as segmentações
```

<img src="/tutorials/pliman_omegads/04_phytopathometry_files/figure-html/unnamed-chunk-5-1.png" width="672" />

```r
sev$severity
```

```
##    healthy symptomatic
## 1 76.15187    23.84813
```

```r
sev$statistics %>% 
  print_tbl()
```



|stat      |      value|
|:---------|----------:|
|n         |    423.000|
|min_area  |     34.000|
|mean_area |    430.312|
|max_area  |   6620.000|
|sd_area   |    566.473|
|sum_area  | 182022.000|

```r
sev$shape[1:10, ] %>% 
  print_tbl()
```



| id|        x|       y| area| perimeter| radius_mean| radius_min| radius_max| radius_sd| radius_ratio| major_axis| eccentricity|  theta|
|--:|--------:|-------:|----:|---------:|-----------:|----------:|----------:|---------:|------------:|----------:|------------:|------:|
|  1| 1061.016| 275.110| 6620|       386|      46.453|     21.242|     69.169|    10.843|        3.256|    115.788|        0.665| -0.088|
|  2| 1058.488| 361.844| 5325|       360|      40.750|     24.608|     53.115|     6.427|        2.158|     89.439|        0.408| -1.560|
|  3|  461.631| 535.682| 6089|       402|      44.615|     24.816|     64.111|     9.047|        2.583|    112.804|        0.759| -0.166|
|  4|  634.904| 690.593| 2870|       281|      30.782|     15.166|     44.663|     7.010|        2.945|     73.493|        0.610|  1.250|
|  5|  774.053| 402.258| 1751|       164|      23.293|     18.515|     30.536|     2.923|        1.649|     54.446|        0.631|  1.064|
|  6|  789.763| 304.646| 1525|       170|      21.764|     10.564|     29.916|     4.576|        2.832|     51.675|        0.540| -0.378|
|  7|  810.716| 331.923| 1424|       159|      21.615|     12.469|     31.524|     5.125|        2.528|     58.122|        0.814| -0.104|
|  8| 1123.056| 351.849| 2024|       209|      25.549|     15.255|     35.213|     4.750|        2.308|     61.336|        0.662| -0.567|
|  9|  331.225| 534.992| 1200|       141|      19.242|     12.569|     24.747|     2.823|        1.969|     45.329|        0.622| -1.558|
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

<img src="/tutorials/pliman_omegads/04_phytopathometry_files/figure-html/unnamed-chunk-7-1.png" width="672" />



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
Processing image soy_11 |======                                  | 15% 00:00:02 
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
Processing image soy_4 |===============================          | 75% 00:00:12 
Processing image soy_5 |=================================        | 80% 00:00:13 
Processing image soy_6 |===================================      | 85% 00:00:14 
Processing image soy_7 |=====================================    | 90% 00:00:14 
Processing image soy_8 |=======================================  | 95% 00:00:15 
Processing image soy_9 |=========================================| 100% 00:00:15 
```

```
##   usuário   sistema decorrido 
##     15.23      1.25     16.54
```

```r
sev_lote$severity %>% 
  print_tbl()
```



|img    | healthy| symptomatic|
|:------|-------:|-----------:|
|soy_1  |  92.375|       7.625|
|soy_10 |  84.867|      15.133|
|soy_11 |  18.966|      81.034|
|soy_12 |  67.682|      32.318|
|soy_13 |  80.106|      19.894|
|soy_14 |  60.373|      39.627|
|soy_15 |  60.876|      39.124|
|soy_16 |  41.801|      58.199|
|soy_17 |  77.530|      22.470|
|soy_18 |  53.139|      46.861|
|soy_19 |  87.264|      12.736|
|soy_2  |  64.470|      35.530|
|soy_20 |  50.958|      49.042|
|soy_3  |  59.078|      40.922|
|soy_4  |  44.592|      55.408|
|soy_5  |  83.481|      16.519|
|soy_6  |  76.353|      23.647|
|soy_7  |  75.907|      24.093|
|soy_8  |  71.335|      28.665|
|soy_9  |  55.915|      44.085|


Para acelerar o tempo de processamento quando várias imagens estão disponíveis, pode-se utilizar o argumento `paralell`. Isto criará múltiplas seções R em segundo plano, sendo cada uma responsável pelo processamento de uma parte das imagens.


```r
system.time(
  sev_lote <- 
    measure_disease(pattern = "soy",
                    img_healthy = "healthy",
                    img_symptoms = "disease",
                    img_background = "back",
                    show_image = FALSE,
                    # save_image = TRUE,
                    # dir_processed = "processed",
                    # verbose = FALSE,
                    parallel = TRUE)
)
```

```
## Image processing using multiple sessions (6). Please wait.
```

```
##   usuário   sistema decorrido 
##      0.25      0.03      8.63
```

## Imagens processadas

```r
imgs <- 
  image_import(pattern = "proc_",
               path = "processed",
               plot = TRUE,
               ncol = 4)
```

<img src="/tutorials/pliman_omegads/04_phytopathometry_files/figure-html/unnamed-chunk-10-1.png" width="672" />


## Desafios


```r
img <- image_import("maize_1.png", plot = TRUE)
```

<img src="/tutorials/pliman_omegads/04_phytopathometry_files/figure-html/unnamed-chunk-11-1.png" width="672" />

```r
image_segment(img, index = "all")
```

<img src="/tutorials/pliman_omegads/04_phytopathometry_files/figure-html/unnamed-chunk-11-2.png" width="672" />

```r
img <- image_import("maize_2.png", plot = TRUE)
```

<img src="/tutorials/pliman_omegads/04_phytopathometry_files/figure-html/unnamed-chunk-11-3.png" width="672" />

```r
image_segment(img, index = "all")
```

<img src="/tutorials/pliman_omegads/04_phytopathometry_files/figure-html/unnamed-chunk-11-4.png" width="672" />

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

<img src="/tutorials/pliman_omegads/04_phytopathometry_files/figure-html/unnamed-chunk-11-5.png" width="672" />

