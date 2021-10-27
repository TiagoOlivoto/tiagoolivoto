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
## |=======================================================|
## | Tools for Plant Image Analysis (pliman 0.3.0)         |
## | Author: Tiago Olivoto                                 |
## | Type 'vignette('pliman_start')' for a short tutorial  |
## | Visit 'https://bit.ly/pliman' for a complete tutorial |
## |=======================================================|
library(tidyverse)
## -- Attaching packages --------------------------------------- tidyverse 1.3.1 --
## v ggplot2 3.3.5     v purrr   0.3.4
## v tibble  3.1.4     v dplyr   1.0.7
## v tidyr   1.1.3     v stringr 1.4.0
## v readr   2.0.2     v forcats 0.5.1
## Warning: package 'tibble' was built under R version 4.1.1
## Warning: package 'readr' was built under R version 4.1.1
## -- Conflicts ------------------------------------------ tidyverse_conflicts() --
## x dplyr::filter() masks stats::filter()
## x dplyr::lag()    masks stats::lag()
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

<img src="/tutorials/pliman_omegads/04_phytopathometry_files/figure-html/unnamed-chunk-3-1.png" width="672" />


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

<img src="/tutorials/pliman_omegads/04_phytopathometry_files/figure-html/unnamed-chunk-4-1.png" width="672" />


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

<img src="/tutorials/pliman_omegads/04_phytopathometry_files/figure-html/unnamed-chunk-5-1.png" width="672" />


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

<img src="/tutorials/pliman_omegads/04_phytopathometry_files/figure-html/unnamed-chunk-6-1.png" width="672" />

```r
sev$severity
```

```
##    healthy symptomatic
## 1 76.28564    23.71436
```

```r
sev$statistics %>% 
  print_tbl()
```



|stat      |      value|
|:---------|----------:|
|n         |    423.000|
|min_area  |     33.000|
|mean_area |    427.102|
|max_area  |   6564.000|
|sd_area   |    572.031|
|sum_area  | 180664.000|

```r
sev$shape[1:10, ] %>% 
  print_tbl()
```



| id|        x|       y| area| perimeter| radius_mean| radius_min| radius_max| radius_sd| radius_ratio| major_axis| eccentricity|  theta|
|--:|--------:|-------:|----:|---------:|-----------:|----------:|----------:|---------:|------------:|----------:|------------:|------:|
|  1| 1061.074| 274.786| 6564|       378|      46.626|     21.488|     68.702|    10.697|        3.197|    115.681|        0.674| -0.088|
|  2| 1058.547| 361.425| 5367|       364|      40.880|     24.946|     53.488|     6.576|        2.144|     90.647|        0.444| -1.516|
|  3|  461.813| 535.755| 6085|       410|      44.637|     24.746|     64.409|     9.118|        2.603|    112.715|        0.759| -0.161|
|  4|  634.775| 690.749| 2846|       283|      30.682|     15.054|     44.581|     7.094|        2.961|     73.659|        0.619|  1.228|
|  5|  773.966| 402.399| 1741|       167|      23.263|     18.518|     30.559|     2.927|        1.650|     54.143|        0.623|  1.054|
|  6|  800.118| 317.487| 2866|       261|      30.670|     14.980|     43.762|     7.253|        2.921|     81.697|        0.791|  0.742|
|  7| 1123.024| 351.968| 2011|       209|      25.447|     14.958|     35.336|     4.740|        2.362|     61.220|        0.669| -0.558|
|  8|  331.062| 534.910| 1193|       139|      19.180|     12.235|     24.705|     2.875|        2.019|     45.714|        0.648| -1.571|
|  9| 1089.952| 469.180| 1168|       137|      19.314|      9.025|     25.583|     3.991|        2.835|     47.726|        0.699| -1.008|
| 10| 1108.416| 494.474| 1083|       115|      18.265|     14.830|     24.330|     2.110|        1.641|     38.955|        0.314| -1.087|



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

<img src="/tutorials/pliman_omegads/04_phytopathometry_files/figure-html/unnamed-chunk-8-1.png" width="672" />



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
Processing image soy_18 |====================                    | 50% 00:00:05 
Processing image soy_19 |======================                  | 55% 00:00:07 
Processing image soy_2 |=========================                | 60% 00:00:08 
Processing image soy_20 |==========================              | 65% 00:00:08 
Processing image soy_3 |=============================            | 70% 00:00:09 
Processing image soy_4 |===============================          | 75% 00:00:10 
Processing image soy_5 |=================================        | 80% 00:00:11 
Processing image soy_6 |===================================      | 85% 00:00:11 
Processing image soy_7 |=====================================    | 90% 00:00:12 
Processing image soy_8 |=======================================  | 95% 00:00:12 
Processing image soy_9 |=========================================| 100% 00:00:13 
```

```
##   usuário   sistema decorrido 
##     13.33      0.94     14.28
```

```r
sev_lote$severity %>% 
  print_tbl()
```



|img    | healthy| symptomatic|
|:------|-------:|-----------:|
|soy_1  |  92.631|       7.369|
|soy_10 |  85.040|      14.960|
|soy_11 |  16.830|      83.170|
|soy_12 |  65.599|      34.401|
|soy_13 |  78.080|      21.920|
|soy_14 |  62.282|      37.718|
|soy_15 |  58.201|      41.799|
|soy_16 |  42.179|      57.821|
|soy_17 |  77.969|      22.031|
|soy_18 |  57.484|      42.516|
|soy_19 |  89.318|      10.682|
|soy_2  |  62.854|      37.146|
|soy_20 |  50.429|      49.571|
|soy_3  |  59.676|      40.324|
|soy_4  |  43.144|      56.856|
|soy_5  |  85.455|      14.545|
|soy_6  |  77.803|      22.197|
|soy_7  |  77.362|      22.638|
|soy_8  |  69.924|      30.076|
|soy_9  |  56.286|      43.714|


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
##      0.21      0.01      7.25
```

## Imagens processadas

```r
imgs <- 
  image_import(pattern = "proc_",
               path = "processed",
               plot = TRUE,
               ncol = 4)
```

<img src="/tutorials/pliman_omegads/04_phytopathometry_files/figure-html/unnamed-chunk-11-1.png" width="672" />


## Desafios


```r
img <- image_import("maize_1.png", plot = TRUE)
```

<img src="/tutorials/pliman_omegads/04_phytopathometry_files/figure-html/unnamed-chunk-12-1.png" width="672" />

```r
image_segment(img, index = "all")
```

<img src="/tutorials/pliman_omegads/04_phytopathometry_files/figure-html/unnamed-chunk-12-2.png" width="672" />

```r
img <- image_import("maize_2.png", plot = TRUE)
```

<img src="/tutorials/pliman_omegads/04_phytopathometry_files/figure-html/unnamed-chunk-12-3.png" width="672" />

```r
image_segment(img, index = "all")
```

<img src="/tutorials/pliman_omegads/04_phytopathometry_files/figure-html/unnamed-chunk-12-4.png" width="672" />

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

<img src="/tutorials/pliman_omegads/04_phytopathometry_files/figure-html/unnamed-chunk-12-5.png" width="672" />

