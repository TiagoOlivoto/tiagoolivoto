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
##   healthy symptomatic
##  75.86151    24.13849
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
##  76.78864    23.21136
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
##  76.59556    23.40444
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
##  76.07694    23.92306
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
##  healthy symptomatic
##   75.625      24.375
```

```r
print_tbl(feat$statistics)
```



|stat      |      value|
|:---------|----------:|
|n         |    412.000|
|min_area  |     36.000|
|mean_area |    450.502|
|max_area  |   6664.000|
|sd_area   |    584.490|
|sum_area  | 185607.000|

```r
print_tbl(feat$shape[1:10, ])
```



| id|        x|       y| area| perimeter| radius_mean| radius_min| radius_max| radius_sd| radius_ratio| major_axis| eccentricity|  theta|
|--:|--------:|-------:|----:|---------:|-----------:|----------:|----------:|---------:|------------:|----------:|------------:|------:|
|  1| 1061.009| 274.681| 6664|       367|      46.853|     21.509|     68.537|    10.779|        3.186|    116.512|        0.675| -0.091|
|  2| 1058.969| 361.470| 5457|       366|      41.103|     24.348|     53.966|     6.627|        2.216|     90.701|        0.420| -1.477|
|  3|  461.585| 535.516| 6113|       404|      44.649|     24.678|     64.244|     8.967|        2.603|    112.833|        0.758| -0.170|
|  4|  634.892| 690.333| 2840|       276|      30.600|     14.867|     44.739|     7.240|        3.009|     73.637|        0.623|  1.199|
|  5|  773.889| 402.566| 1760|       168|      23.287|     18.290|     30.875|     2.855|        1.688|     54.099|        0.611|  1.057|
|  6|  789.810| 304.597| 1543|       170|      21.929|     10.851|     29.622|     4.637|        2.730|     51.998|        0.541| -0.347|
|  7|  810.856| 331.917| 1452|       161|      21.785|     12.562|     31.720|     5.177|        2.525|     58.797|        0.816| -0.121|
|  8|  331.143| 534.896| 1217|       135|      19.408|     13.383|     25.057|     2.829|        1.872|     46.217|        0.653|  1.553|
|  9| 1123.506| 351.704| 1998|       210|      25.201|     15.431|     35.190|     4.796|        2.280|     60.689|        0.652| -0.610|
| 10| 1098.732| 482.138| 2208|       198|      26.837|     14.709|     39.704|     6.706|        2.699|     73.287|        0.824|  0.964|

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
##  91.59298     8.40702
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
##     13.83      0.81     14.70
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
|soy_1  |  92.775|       7.225|
|soy_10 |  84.817|      15.183|
|soy_11 |  16.272|      83.728|
|soy_12 |  66.426|      33.574|
|soy_13 |  78.987|      21.013|
|soy_14 |  67.014|      32.986|
|soy_15 |  59.034|      40.966|
|soy_16 |  41.933|      58.067|
|soy_17 |  77.087|      22.913|
|soy_18 |  53.244|      46.756|
|soy_19 |  86.296|      13.704|
|soy_2  |  62.783|      37.217|
|soy_20 |  51.108|      48.892|
|soy_3  |  57.907|      42.093|
|soy_4  |  47.077|      52.923|
|soy_5  |  82.189|      17.811|
|soy_6  |  72.604|      27.396|
|soy_7  |  75.456|      24.544|
|soy_8  |  69.705|      30.295|
|soy_9  |  53.348|      46.652|

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
##      0.25      0.02      8.97
```

