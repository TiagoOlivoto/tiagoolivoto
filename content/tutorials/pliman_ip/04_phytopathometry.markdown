---
title: Fitopatometria
linktitle: "4. Fitopatometria"
toc: true
type: docs
date: "2021/11/25"
lastmod: "2021/11/25"
draft: false
df_print: paged
code_download: true
menu:
  plimanip:
    parent: pliman
    weight: 5
weight: 4
---



# Diretório das imagens

```r
# mudar de acordo com a pasta em seu computador
setwd("E:/Desktop/tiagoolivoto/static/tutorials/pliman_ip/imgs")
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
## v readr   2.0.2     v forcats 0.5.1
## Warning: package 'tidyr' was built under R version 4.1.1
## Warning: package 'readr' was built under R version 4.1.1
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

<img src="/tutorials/pliman_ip/04_phytopathometry_files/figure-html/doença1-1.png" width="1152" />


### Padrão da função

```r
sev <- 
  measure_disease(img = img,
                  img_healthy = h,
                  img_symptoms = d,
                  img_background = b,
                  show_image = TRUE)
```

<img src="/tutorials/pliman_ip/04_phytopathometry_files/figure-html/unnamed-chunk-3-1.png" width="672" />


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

<img src="/tutorials/pliman_ip/04_phytopathometry_files/figure-html/unnamed-chunk-4-1.png" width="672" />


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

<img src="/tutorials/pliman_ip/04_phytopathometry_files/figure-html/unnamed-chunk-5-1.png" width="672" />


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

<img src="/tutorials/pliman_ip/04_phytopathometry_files/figure-html/unnamed-chunk-6-1.png" width="672" />

```r
sev$severity
```

```
##    healthy symptomatic
## 1 76.05293    23.94707
```

```r
sev$statistics %>% 
  print_tbl()
```



|stat      |      value|
|:---------|----------:|
|n         |    416.000|
|min_area  |     35.000|
|mean_area |    439.159|
|max_area  |   6549.000|
|sd_area   |    573.486|
|sum_area  | 182690.000|

```r
sev$shape[1:10, ] %>% 
  print_tbl()
```



| id|        x|       y| area| perimeter| radius_mean| radius_min| radius_max| radius_sd| radius_ratio| major_axis| eccentricity|  theta|
|--:|--------:|-------:|----:|---------:|-----------:|----------:|----------:|---------:|------------:|----------:|------------:|------:|
|  1| 1061.504| 274.697| 6549|       366|      46.271|     22.141|     66.008|    10.333|        2.981|    114.833|        0.672| -0.120|
|  2| 1059.227| 360.102| 5267|       348|      40.639|     25.795|     54.218|     6.751|        2.102|     89.421|        0.411|  1.453|
|  3|  461.554| 535.612| 6096|       404|      44.741|     24.888|     64.375|     8.976|        2.587|    112.598|        0.755| -0.168|
|  4|  634.761| 690.760| 2855|       284|      30.784|     15.104|     44.594|     7.083|        2.952|     73.716|        0.618|  1.233|
|  5|  774.043| 402.313| 1733|       167|      23.178|     18.269|     30.872|     2.907|        1.690|     54.100|        0.629|  1.046|
|  6|  810.780| 331.954| 1443|       162|      21.750|     12.601|     31.871|     5.162|        2.529|     58.409|        0.813| -0.117|
|  7|  789.980| 304.788| 1513|       166|      21.815|     10.763|     29.729|     4.641|        2.762|     51.822|        0.557| -0.337|
|  8|  331.313| 535.291| 1204|       136|      19.349|     14.270|     24.961|     2.675|        1.749|     45.253|        0.624| -1.536|
|  9| 1123.018| 351.867| 2015|       204|      25.566|     14.980|     35.601|     4.578|        2.377|     61.071|        0.664| -0.561|
| 10| 1098.843| 481.800| 2230|       201|      27.405|     15.784|     40.041|     6.441|        2.537|     72.730|        0.818|  0.978|



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

<img src="/tutorials/pliman_ip/04_phytopathometry_files/figure-html/unnamed-chunk-8-1.png" width="672" />



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
Processing image soy_3 |=============================            | 70% 00:00:09 
Processing image soy_4 |===============================          | 75% 00:00:10 
Processing image soy_5 |=================================        | 80% 00:00:11 
Processing image soy_6 |===================================      | 85% 00:00:12 
Processing image soy_7 |=====================================    | 90% 00:00:12 
Processing image soy_8 |=======================================  | 95% 00:00:13 
Processing image soy_9 |=========================================| 100% 00:00:13 
```

```
##   usuário   sistema decorrido 
##     13.80      0.70     14.58
```

```r
sev_lote$severity %>% 
  print_tbl()
```



|img    | healthy| symptomatic|
|:------|-------:|-----------:|
|soy_1  |  92.515|       7.485|
|soy_10 |  84.684|      15.316|
|soy_11 |  16.360|      83.640|
|soy_12 |  65.150|      34.850|
|soy_13 |  77.843|      22.157|
|soy_14 |  61.145|      38.855|
|soy_15 |  63.622|      36.378|
|soy_16 |  42.235|      57.765|
|soy_17 |  77.517|      22.483|
|soy_18 |  53.733|      46.267|
|soy_19 |  86.974|      13.026|
|soy_2  |  63.549|      36.451|
|soy_20 |  50.509|      49.491|
|soy_3  |  58.863|      41.137|
|soy_4  |  44.459|      55.541|
|soy_5  |  85.009|      14.991|
|soy_6  |  77.055|      22.945|
|soy_7  |  75.825|      24.175|
|soy_8  |  70.303|      29.697|
|soy_9  |  57.413|      42.587|


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
##      0.24      0.05      7.49
```

## Imagens processadas

```r
imgs <- 
  image_import(pattern = "proc_",
               path = "processed",
               plot = TRUE,
               ncol = 5)
```

<img src="/tutorials/pliman_ip/04_phytopathometry_files/figure-html/unnamed-chunk-11-1.png" width="960" />


# Número de ovos 
O seguinte exemplo demonstra como contar o número de ovos em uma folha. A imagem foi obtida do pacote [ExpImage](https://rdrr.io/cran/ExpImage/f/vignettes/Contagem_de_objetos.Rmd). Para identificar os melhores índices para segmentação da folha/fundo e ovos/folha, a função `image_segment_iter()` é usada. 



```r
ovos <- image_import("ovos.jpg", plot = TRUE)
```

<img src="/tutorials/pliman_ip/04_phytopathometry_files/figure-html/unnamed-chunk-12-1.png" width="672" />


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

<img src="/tutorials/pliman_ip/04_phytopathometry_files/figure-html/unnamed-chunk-14-1.png" width="672" />

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

<img src="/tutorials/pliman_ip/04_phytopathometry_files/figure-html/unnamed-chunk-14-2.png" width="672" />



# Desafios


```r
img <- image_import("maize_1.png", plot = TRUE)
```

<img src="/tutorials/pliman_ip/04_phytopathometry_files/figure-html/unnamed-chunk-15-1.png" width="672" />

```r
image_segment(img, index = "all")
```

<img src="/tutorials/pliman_ip/04_phytopathometry_files/figure-html/unnamed-chunk-15-2.png" width="672" />

```r
img <- image_import("maize_2.png", plot = TRUE)
```

<img src="/tutorials/pliman_ip/04_phytopathometry_files/figure-html/unnamed-chunk-15-3.png" width="672" />

```r
image_segment(img, index = "all")
```

<img src="/tutorials/pliman_ip/04_phytopathometry_files/figure-html/unnamed-chunk-15-4.png" width="672" />

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

<img src="/tutorials/pliman_ip/04_phytopathometry_files/figure-html/unnamed-chunk-15-5.png" width="672" />
