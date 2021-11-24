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
                  img_background = b)
```

<img src="/tutorials/pliman_ip/04_phytopathometry_files/figure-html/unnamed-chunk-3-1.png" width="672" />


### Mostrando preenchimento das lesões

```r
sev <- 
  measure_disease(img = img,
                  img_healthy = h,
                  img_symptoms = d,
                  img_background = b,
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
##   healthy symptomatic
## 1 76.2869     23.7131
```

```r
sev$statistics %>% 
  print_tbl()
```



|stat      |      value|
|:---------|----------:|
|n         |    420.000|
|min_area  |     37.000|
|mean_area |    428.460|
|max_area  |   6565.000|
|sd_area   |    551.698|
|sum_area  | 179953.000|

```r
sev$shape[1:10, ] %>% 
  print_tbl()
```



| id|        x|       y| area| perimeter| radius_mean| radius_min| radius_max| radius_sd| radius_ratio| major_axis| eccentricity|  theta|
|--:|--------:|-------:|----:|---------:|-----------:|----------:|----------:|---------:|------------:|----------:|------------:|------:|
|  1| 1061.169| 274.567| 6565|       367|      46.525|     21.713|     68.122|    10.738|        3.137|    115.727|        0.678| -0.098|
|  2| 1059.178| 360.097| 5250|       349|      40.533|     25.416|     53.796|     6.747|        2.117|     89.678|        0.430|  1.477|
|  3|  461.586| 535.537| 6058|       407|      44.799|     25.075|     63.558|     8.977|        2.535|    112.428|        0.757| -0.166|
|  4|  773.967| 402.376| 1727|       168|      23.191|     18.369|     30.911|     2.885|        1.683|     53.675|        0.614|  1.066|
|  5|  789.965| 304.855| 1500|       165|      21.676|     10.676|     29.794|     4.621|        2.791|     51.583|        0.560| -0.318|
|  6|  810.611| 331.958| 1430|       159|      21.601|     12.266|     31.313|     5.055|        2.553|     57.899|        0.810| -0.117|
|  7|  331.290| 535.235| 1211|       135|      19.341|     14.034|     24.770|     2.570|        1.765|     44.999|        0.608| -1.539|
|  8| 1122.687| 351.997| 2012|       207|      25.631|     15.301|     36.546|     4.711|        2.388|     61.728|        0.679| -0.557|
|  9| 1108.669| 495.250| 1026|       116|      17.785|     14.686|     22.872|     2.056|        1.557|     38.184|        0.346| -0.726|
| 10| 1090.230| 470.357| 1176|       132|      19.163|     10.596|     24.573|     3.420|        2.319|     45.493|        0.611| -0.959|



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
Processing image soy_13 |==========                              | 25% 00:00:03 
Processing image soy_14 |============                            | 30% 00:00:03 
Processing image soy_15 |==============                          | 35% 00:00:04 
Processing image soy_16 |================                        | 40% 00:00:04 
Processing image soy_17 |==================                      | 45% 00:00:05 
Processing image soy_18 |====================                    | 50% 00:00:06 
Processing image soy_19 |======================                  | 55% 00:00:08 
Processing image soy_2 |=========================                | 60% 00:00:09 
Processing image soy_20 |==========================              | 65% 00:00:10 
Processing image soy_3 |=============================            | 70% 00:00:10 
Processing image soy_4 |===============================          | 75% 00:00:11 
Processing image soy_5 |=================================        | 80% 00:00:12 
Processing image soy_6 |===================================      | 85% 00:00:13 
Processing image soy_7 |=====================================    | 90% 00:00:13 
Processing image soy_8 |=======================================  | 95% 00:00:14 
Processing image soy_9 |=========================================| 100% 00:00:15 
```

```
##   usuário   sistema decorrido 
##     15.01      1.01     16.07
```

```r
sev_lote$severity %>% 
  print_tbl()
```



|img    | healthy| symptomatic|
|:------|-------:|-----------:|
|soy_1  |  92.690|       7.310|
|soy_10 |  85.439|      14.561|
|soy_11 |  17.819|      82.181|
|soy_12 |  64.162|      35.838|
|soy_13 |  76.954|      23.046|
|soy_14 |  65.271|      34.729|
|soy_15 |  59.305|      40.695|
|soy_16 |  41.418|      58.582|
|soy_17 |  80.022|      19.978|
|soy_18 |  52.931|      47.069|
|soy_19 |  86.872|      13.128|
|soy_2  |  63.106|      36.894|
|soy_20 |  51.298|      48.702|
|soy_3  |  58.866|      41.134|
|soy_4  |  50.955|      49.045|
|soy_5  |  83.429|      16.571|
|soy_6  |  75.551|      24.449|
|soy_7  |  75.627|      24.373|
|soy_8  |  69.824|      30.176|
|soy_9  |  53.332|      46.668|


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
##      0.25      0.02      9.31
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



```r
# apenas na versão de desenvolvimento
pick_count(ovos)
```



# Desafios


```r
img <- image_import("maize_1.png", plot = TRUE)
```

<img src="/tutorials/pliman_ip/04_phytopathometry_files/figure-html/unnamed-chunk-16-1.png" width="672" />

```r
image_segment(img, index = "all")
```

<img src="/tutorials/pliman_ip/04_phytopathometry_files/figure-html/unnamed-chunk-16-2.png" width="672" />

```r
img <- image_import("maize_2.png", plot = TRUE)
```

<img src="/tutorials/pliman_ip/04_phytopathometry_files/figure-html/unnamed-chunk-16-3.png" width="672" />

```r
image_segment(img, index = "all")
```

<img src="/tutorials/pliman_ip/04_phytopathometry_files/figure-html/unnamed-chunk-16-4.png" width="672" />

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

<img src="/tutorials/pliman_ip/04_phytopathometry_files/figure-html/unnamed-chunk-16-5.png" width="672" />
