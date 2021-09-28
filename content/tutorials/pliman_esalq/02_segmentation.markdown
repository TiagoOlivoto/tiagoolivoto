---
title: Segmentação de imagens
linktitle: "2. Segmentação de imagens"
toc: true
type: docs
date: "2021/09/28"
draft: false
df_print: paged
code_download: true
menu:
  plimanesalq:
    parent: pliman
    weight: 3
weight: 2
---



# Diretório das imagens

```r
# mudar de acordo com a pasta em seu computador
setwd("E:/Desktop/tiagoolivoto/static/tutorials/pliman_esalq/leaves")
```


# Importar imagens

```r
library(pliman)  
img <- image_import("img_1.jpeg")
img <- image_resize(img, 50)
plot(img)
```

<img src="/tutorials/pliman_esalq/02_segmentation_files/figure-html/unnamed-chunk-2-1.png" width="672" />


# Segmentação de imagem

No `pliman`, as seguintes funções podem ser usadas para segmentar uma imagem.

* `image_binary()` para produzir uma imagem binária(preto e branco)
* `image_segment()` para produzir uma imagem segmentada(objetos de imagem e um fundo branco).
* `image_segment_iter()` para segmentar uma imagem iterativamente.

Ambas as funções segmentam a imagem com base no valor de algum índice de imagem, que pode ser uma das bandas RGB ou qualquer operação com essas bandas. Internamente, essas funções chamam `image_index()` para calcular esses índices.

Aqui, usamos o argumento `index" `para testar a segmentação com base no RGB e seus valores normalizados. Os usuários também podem fornecer seu índice com o argumento` my_index`.


```r
# Calcule os índices
indexes <- image_index(img, index = c("R, G, B, NR, NG, NB"))
```

<img src="/tutorials/pliman_esalq/02_segmentation_files/figure-html/segmentação2-1.png" width="960" />

```r
# Crie um gráfico raster com os valores RGB
plot(indexes)
```

<img src="/tutorials/pliman_esalq/02_segmentation_files/figure-html/segmentação2-2.png" width="960" />

```r
# Crie um histograma com os valores RGB
plot(indexes, type = "hist")
```

<img src="/tutorials/pliman_esalq/02_segmentation_files/figure-html/segmentação2-3.png" width="960" />

Neste exemplo, podemos ver a distribuição dos valores RGB (primeira linha) e os valores RGB normalizados (segunda linha). Os dois picos representam a folha (pico menor) e o fundo (pico maior). Quanto mais clara for a diferença entre esses picos, melhor será a segmentação da imagem.

A função `image_segmentation()` é usada para segmentar imagens usando índices de imagem. Em nosso exemplo, usaremos os mesmos índices calculados abaixo para ver como a imagem é segmentada. A saída desta função pode ser usada como entrada na função `analyze_objects()`.


```r
segmented <- image_segment(img, index = c("R, G, B, NR, NG, NB"))
```

<img src="/tutorials/pliman_esalq/02_segmentation_files/figure-html/segmentação3-1.png" width="960" />

Parece que o índice `"G"` proporcionou melhor segmentação. 



# Produzindo uma imagem binária

Também podemos produzir uma imagem binária com `image_binary()`. A título de curiosidade, usaremos os índices `"B"` (azul). Por padrão, `image_binary()` redimensiona a imagem para 30% do tamanho da imagem original para acelerar o tempo de computação. Use o argumento `resize = FALSE` para produzir uma imagem binária com o tamanho original.


```r
binary <- image_binary(img)
```

<img src="/tutorials/pliman_esalq/02_segmentation_files/figure-html/binary1-1.png" width="960" />

```r
# tamanho de imagem original
image_binary(img,
             index = "G",
             resize = FALSE)
```

<img src="/tutorials/pliman_esalq/02_segmentation_files/figure-html/binary1-2.png" width="960" />

Para contornar a questão de pixeis não segmentados no interior da image, o argumento `fill_hull` pode ser utilizado.



```r
image_binary(img,
             index = "G",
             resize = FALSE,
             fill_hull = TRUE)
```

<img src="/tutorials/pliman_esalq/02_segmentation_files/figure-html/binary2-1.png" width="960" />
