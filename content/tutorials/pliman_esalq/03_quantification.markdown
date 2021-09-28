---
title: Fitopatometria
linktitle: "3. Fitopatometria"
toc: true
type: docs
date: "2021/09/28"
draft: false
df_print: paged
code_download: true
menu:
  plimanesalq:
    parent: pliman
    weight: 4
weight: 3
---



# Diretório das imagens

```r
# mudar de acordo com a pasta em seu computador
setwd("E:/Desktop/tiagoolivoto/static/tutorials/pliman_esalq/leaves")
```


# Severidade da doença
## Utilizando paletas


```r
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
img <- image_import("img_1.jpeg")
h <- image_import("h_img1.png")
d <- image_import("d_img1.png")
b <- image_import("b_img1.png")
image_combine(img, h, d, b, ncol = 4)
```

<img src="/tutorials/pliman_esalq/03_quantification_files/figure-html/doença1-1.png" width="1152" />


### Padrão da função

```r
sev <- 
  measure_disease(img = img,
                  img_healthy = h,
                  img_symptoms = d,
                  img_background = b,
                  show_image = TRUE)
```

<img src="/tutorials/pliman_esalq/03_quantification_files/figure-html/unnamed-chunk-2-1.png" width="672" />

```
##   healthy symptomatic
##  76.56085    23.43915
```


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

<img src="/tutorials/pliman_esalq/03_quantification_files/figure-html/unnamed-chunk-3-1.png" width="672" />

```
##   healthy symptomatic
##  75.59873    24.40127
```


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

<img src="/tutorials/pliman_esalq/03_quantification_files/figure-html/unnamed-chunk-4-1.png" width="672" />

```
##   healthy symptomatic
##  75.28925    24.71075
```


### Segmentando as lesões

```r
sev <- 
  measure_disease(img = img,
                  img_healthy = h,
                  img_symptoms = d,
                  img_background = b,
                  show_image = TRUE,
                  show_contour = FALSE,
                  segment = TRUE,
                  show_segmentation = TRUE)
```

<img src="/tutorials/pliman_esalq/03_quantification_files/figure-html/unnamed-chunk-5-1.png" width="672" />

```
##   healthy symptomatic
##  75.55387    24.44613
```


### Analisar as lesões

```r
feat <- 
  measure_disease(img = img,
                  img_healthy = h,
                  img_symptoms = d,
                  img_background = b,
                  show_image = TRUE,
                  show_contour = FALSE,
                  segment = TRUE,
                  show_segmentation = TRUE,
                  show_features = TRUE)
```

<img src="/tutorials/pliman_esalq/03_quantification_files/figure-html/unnamed-chunk-6-1.png" width="672" />

```
##   healthy symptomatic
##  75.89289    24.10711
```


### A little bit more!

```r
sev_img2 <- 
  measure_disease(img = "img_2",
                  img_healthy = "h_img2",
                  img_symptoms = "d_img2",
                  img_background = "b_img2",
                  show_image = TRUE,
                  show_contour = FALSE,
                  col_background  = "black")
```

<img src="/tutorials/pliman_esalq/03_quantification_files/figure-html/unnamed-chunk-7-1.png" width="672" />

```
##   healthy symptomatic
##  91.71006    8.289937
```



## Utilizando índices RGB
Para identificar o melhor índice para segmentar a imagem do fundo e após as lesões da folha sadia, pode-se utilizar a função `image_segment_iter`. (OBS. somente funcionará em uma seção iterativa).



```r
image_segment_iter(img)
```

Após escolhidos os índices, podemos utilizar os argumentos `index_lb` e `index_dh` para segmentação da folha e fundo | lesão e sadio, respectivamente.


```r
# após escolhidos os índices, utiliza
sev_index <- 
  measure_disease(img, 
                  index_lb = "G",
                  index_dh = "NGRDI",
                  show_image = TRUE)
```

<img src="/tutorials/pliman_esalq/03_quantification_files/figure-html/unnamed-chunk-9-1.png" width="672" />

```
##   healthy symptomatic
##  74.34505    25.65495
```


## Processamento em lote
Para analisar diversas imagens de um diretório, utiliza-se o argumento `pattern`, para declarar um padrão de nomes de arquivos. Serão utilizadas 15 folhas de soja disponíveis no repositório  https://osf.io/4hbr6, um banco de dados de imagens de anotação de severidade de doenças de plantas. Obrigado a [Emerson M. Del Ponte](https://osf.io/jb6yd/) e seus colaboradores por manter este projeto disponível publicamente.


```r
system.time(
sev_lote <- 
  measure_disease(pattern = "soy",
                  img_healthy = "h_s",
                  img_symptoms = "d_s",
                  img_background = "b_s",
                  verbose = FALSE)
)
```

```
##   usuário   sistema decorrido 
##     13.72      0.66     14.42
```

```r
sev_lote
```

```
## $severity
##       img  healthy symptomatic
## 1   soy_1 92.44382    7.556183
## 2  soy_10 84.89943   15.100569
## 3  soy_11 16.26823   83.731769
## 4  soy_12 65.95639   34.043610
## 5  soy_13 76.02780   23.972199
## 6  soy_14 62.62902   37.370982
## 7  soy_15 60.37721   39.622786
## 8  soy_16 43.91801   56.081993
## 9  soy_17 79.72006   20.279940
## 10 soy_18 54.59130   45.408695
## 11 soy_19 89.02782   10.972181
## 12  soy_2 67.69513   32.304874
## 13 soy_20 52.00233   47.997673
## 14  soy_3 59.90982   40.090181
## 15  soy_4 41.66647   58.333535
## 16  soy_5 82.67392   17.326077
## 17  soy_6 76.41246   23.587537
## 18  soy_7 75.72521   24.274789
## 19  soy_8 70.02609   29.973914
## 20  soy_9 51.89651   48.103488
## 
## $shape
## NULL
## 
## $stats
## NULL
```



Para acelerar o tempo de processamento quando várias imagens estão disponíveis, pode-se utilizar o argumento `paralell`. Isto criará múltiplas seções R em segundo plano, sendo cada uma responsável pelo processamento de uma parte das imagens.


```r
system.time(
sev_lote <- 
  measure_disease(pattern = "soy",
                  img_healthy = "h_s",
                  img_symptoms = "d_s",
                  img_background = "b_s",
                  verbose = FALSE,
                  parallel = TRUE)
)
```

```
##   usuário   sistema decorrido 
##      0.23      0.03      8.54
```

```r
sev_lote
```

```
## $severity
##       img  healthy symptomatic
## 1   soy_1 92.29352     7.70648
## 2  soy_10 84.73562    15.26438
## 3  soy_11 15.74749    84.25251
## 4  soy_12 65.92660    34.07340
## 5  soy_13 80.29746    19.70254
## 6  soy_14 61.90905    38.09095
## 7  soy_15 58.18944    41.81056
## 8  soy_16 42.51483    57.48517
## 9  soy_17 77.48612    22.51388
## 10 soy_18 57.38100    42.61900
## 11 soy_19 87.79691    12.20309
## 12  soy_2 68.76875    31.23125
## 13 soy_20 51.17884    48.82116
## 14  soy_3 58.49024    41.50976
## 15  soy_4 45.60417    54.39583
## 16  soy_5 84.50501    15.49499
## 17  soy_6 77.37214    22.62786
## 18  soy_7 74.92604    25.07396
## 19  soy_8 70.29779    29.70221
## 20  soy_9 53.61876    46.38124
## 
## $shape
## NULL
## 
## $stats
## NULL
```

