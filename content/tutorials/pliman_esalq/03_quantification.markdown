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
##  healthy symptomatic
##  76.8517     23.1483
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
##  healthy symptomatic
##  76.1517     23.8483
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
##  76.10242    23.89758
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
##  75.34814    24.65186
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
##  76.21992    23.78008
```

```r
print_tbl(feat$statistics)
```



|stat      |      value|
|:---------|----------:|
|n         |    421.000|
|min_area  |     38.000|
|mean_area |    428.629|
|max_area  |   6567.000|
|sd_area   |    555.531|
|sum_area  | 180453.000|

```r
print_tbl(feat$shape[1:10, ])
```



| id|        x|       y| area| perimeter| radius_mean| radius_min| radius_max| radius_sd| radius_ratio| major_axis| eccentricity|  theta|
|--:|--------:|-------:|----:|---------:|-----------:|----------:|----------:|---------:|------------:|----------:|------------:|------:|
|  1| 1061.385| 274.868| 6567|       365|      46.363|     21.773|     66.045|    10.403|        3.033|    114.965|        0.669| -0.118|
|  2| 1058.867| 361.367| 5427|       372|      40.839|     23.612|     54.001|     6.893|        2.287|     90.780|        0.427| -1.436|
|  3|  461.764| 535.753| 6137|       407|      44.913|     25.508|     63.974|     8.929|        2.508|    112.937|        0.756| -0.162|
|  4|  773.987| 402.561| 1721|       165|      23.126|     18.302|     30.460|     2.873|        1.664|     53.659|        0.617|  1.048|
|  5|  789.972| 304.759| 1511|       166|      21.808|     10.466|     30.033|     4.652|        2.870|     51.704|        0.554| -0.344|
|  6|  810.650| 331.923| 1436|       160|      21.736|     12.541|     31.576|     5.103|        2.518|     58.237|        0.814| -0.121|
|  7|  331.222| 535.192| 1206|       137|      19.319|     14.077|     24.791|     2.538|        1.761|     45.038|        0.614| -1.541|
|  8| 1123.359| 351.868| 1976|       217|      25.283|     15.455|     36.424|     4.923|        2.357|     61.018|        0.664| -0.593|
|  9| 1108.436| 494.512| 1084|       118|      18.350|     14.669|     24.597|     2.244|        1.677|     39.063|        0.320| -1.203|
| 10| 1089.525| 470.107| 1111|       126|      18.584|      9.690|     24.293|     3.605|        2.507|     45.389|        0.657| -0.966|

```r
# corrigir as medidas (dpi = 100)
feat_corrected <- get_measures(feat, dpi = 150)
```


### A little bit more!

```r
# library(pliman)
sev_img2 <- 
  measure_disease(img = "img_2",
                  img_healthy = "h_img2",
                  img_symptoms = "d_img2",
                  img_background = "b_img2",
                  show_image = FALSE,
                  show_contour = FALSE,
                  col_background  = "black")
```

```
##   healthy symptomatic
##  91.52905    8.470947
```

```r
imgs <- image_import(c("img_2.jpeg", "mask_im2.jpeg"))
image_combine(imgs)
```

<img src="/tutorials/pliman_esalq/03_quantification_files/figure-html/unnamed-chunk-7-1.png" width="672" />



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
##     13.62      1.18     14.85
```

```r
print_tbl(sev_lote)
```



<table class="kable_wrapper">
<tbody>
  <tr>
   <td> 

|img    | healthy| symptomatic|
|:------|-------:|-----------:|
|soy_1  |  93.140|       6.860|
|soy_10 |  84.781|      15.219|
|soy_11 |  16.540|      83.460|
|soy_12 |  65.323|      34.677|
|soy_13 |  78.643|      21.357|
|soy_14 |  65.178|      34.822|
|soy_15 |  59.953|      40.047|
|soy_16 |  45.870|      54.130|
|soy_17 |  79.689|      20.311|
|soy_18 |  54.754|      45.246|
|soy_19 |  89.469|      10.531|
|soy_2  |  63.073|      36.927|
|soy_20 |  51.839|      48.161|
|soy_3  |  59.296|      40.704|
|soy_4  |  43.401|      56.599|
|soy_5  |  84.160|      15.840|
|soy_6  |  75.374|      24.626|
|soy_7  |  75.166|      24.834|
|soy_8  |  70.347|      29.653|
|soy_9  |  53.218|      46.782|

 </td>
   <td> 

||
||
||
||

 </td>
   <td> 

||
||
||
||

 </td>
  </tr>
</tbody>
</table>



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
##      0.22      0.05      9.64
```



## Desafios

### Lesões com pouco contraste



```r
pepper <- image_import("pepper.png", plot = TRUE)
```

<img src="/tutorials/pliman_esalq/03_quantification_files/figure-html/unnamed-chunk-12-1.png" width="672" />

```r
image_index(pepper, index = "all")
```

<img src="/tutorials/pliman_esalq/03_quantification_files/figure-html/unnamed-chunk-12-2.png" width="672" />

### Fundos complexos

```r
img <- image_import("maize_1.png", plot = TRUE)
```

<img src="/tutorials/pliman_esalq/03_quantification_files/figure-html/unnamed-chunk-13-1.png" width="672" />

```r
image_segment(img, index = "all")
```

<img src="/tutorials/pliman_esalq/03_quantification_files/figure-html/unnamed-chunk-13-2.png" width="672" />

```r
img <- image_import("maize_2.png", plot = TRUE)
```

<img src="/tutorials/pliman_esalq/03_quantification_files/figure-html/unnamed-chunk-13-3.png" width="672" />

```r
image_segment(img, index = "all")
```

<img src="/tutorials/pliman_esalq/03_quantification_files/figure-html/unnamed-chunk-13-4.png" width="672" />

```r
img2 <- image_crop(img,
                   width = 959:32,
                   height = 163:557,
                   plot = TRUE)



image_segment_iter(img2, 
                   nseg = 2,
                   index = c("R/(G+B)", "GLI"),
                   invert = c(T, F),
                   ncol = 3)
```

```
##      image  pixels   percent
## 1 original 1466240 100.00000
## 2     seg1   72072   4.91543
## 3     seg2   17214  23.88445
```

<img src="/tutorials/pliman_esalq/03_quantification_files/figure-html/unnamed-chunk-13-5.png" width="672" />

```r
img <- image_import("maize_3.png", plot = TRUE)
```

<img src="/tutorials/pliman_esalq/03_quantification_files/figure-html/unnamed-chunk-13-6.png" width="672" />

```r
image_segment(img, index = "all")
```

<img src="/tutorials/pliman_esalq/03_quantification_files/figure-html/unnamed-chunk-13-7.png" width="672" />

