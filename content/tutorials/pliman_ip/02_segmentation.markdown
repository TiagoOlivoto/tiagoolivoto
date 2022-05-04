---
title: Segmentação de imagens
linktitle: "2. Segmentação de imagens"
toc: true
type: docs
date: "2021/10/27"
lastmod: "2022/05/06"
draft: false
df_print: paged
code_download: true
menu:
  plimanip:
    parent: pliman
    weight: 3
weight: 2
---





# Diretório das imagens

```r
# mudar de acordo com a pasta em seu computador
setwd("E:/Desktop/tiagoolivoto/static/tutorials/pliman_ip/imgs")
```


# Importar imagens

```r
library(pliman) 
img <- image_import("folhas.jpg", plot = TRUE)
```

<img src="/tutorials/pliman_ip/02_segmentation_files/figure-html/unnamed-chunk-3-1.png" width="672" />

```r
img <- image_resize(img, rel_size = 30) #processamento mais rápido
```


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

<img src="/tutorials/pliman_ip/02_segmentation_files/figure-html/segmentação2-1.png" width="960" />

```r
# Crie um gráfico raster com os valores RGB
plot(indexes)
```

<img src="/tutorials/pliman_ip/02_segmentation_files/figure-html/segmentação2-2.png" width="960" />

```r
# Crie um histograma com os valores RGB
plot(indexes, type = "density")
```

<img src="/tutorials/pliman_ip/02_segmentation_files/figure-html/segmentação2-3.png" width="960" />

Os dois picos representam a folha (pico menor) e o fundo (pico maior). Quanto mais clara for a diferença entre esses picos, melhor será a segmentação da imagem.



# Produzindo uma imagem binária

Para segmentar objetos, o `pliman` utiliza a técnica de `threshold` (Otsu, 1979)^[1], ou seja, um ponto de corte (considerando os valores dos pixels) é escolhido e a imagem é classificada em duas classes (foreground e background). Temos, então, uma imagem binária. Podemos produzir esta imagem com `image_binary()`. Este processo de binarização é a chave para todas as etapas de análise de objetos, sendo que a acurácia da análise está diretamente relacionada com um processo de binarização satisfatório.


```r
binary <- image_binary(img)
```

<img src="/tutorials/pliman_ip/02_segmentation_files/figure-html/binary1-1.png" width="960" />

A função `image_segment()` é usada para segmentar imagens usando índices de imagem. Em nosso exemplo, usaremos o índice `NB` para segmentar as folhas do fundo.


```r
segmented <- 
  image_segment(img,
                index = "NB", # padrão da função
                fill_hull = TRUE)
```

<img src="/tutorials/pliman_ip/02_segmentation_files/figure-html/segmentação3-1.png" width="960" />




^[1] Otsu, N. 1979. Threshold selection method from gray-level histograms. IEEE Trans Syst Man Cybern SMC-9(1): 62–66. doi: 10.1109/tsmc.1979.4310076.

