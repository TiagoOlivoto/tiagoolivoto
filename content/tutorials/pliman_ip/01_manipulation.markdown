---
title: Importação e manipulação
linktitle: "1. Importação e manipulação"
toc: true
type: docs
date: "2021/11/25"
lastmod: "2022/05/06"
draft: false
df_print: paged
code_download: true
menu:
  plimanip:
    parent: pliman
    weight: 2
weight: 1
---




# Diretório das imagens

```r
# mudar de acordo com a pasta em seu computador
setwd("E:/Desktop/tiagoolivoto/static/tutorials/pliman_ip/imgs")
```


## Importar imagens

```r
library(pliman)
library(tidyverse)
library(patchwork)
img <- image_import("folhas.jpg")
```



Para importar uma lista de imagens, use um vetor de nomes de imagens, ou o argumento `pattern`. Neste último, todas as imagens que correspondem ao nome do padrão são importadas para uma lista.


```r
img_list1 <- image_import(c("img_sb_50_1.jpg", "img_sb_50_2.jpg"))
img_list2 <- image_import(pattern = "img_sb_")
str(img_list2)
```

```
## List of 13
##  $ img_sb_50_1.jpg :Formal class 'Image' [package "EBImage"] with 2 slots
##   .. ..@ .Data    : num [1:816, 1:612, 1:3] 0.365 0.361 0.369 0.357 0.365 ...
##   .. ..@ colormode: int 2
##   .. ..$ dim: int [1:3] 816 612 3
##  $ img_sb_50_10.jpg:Formal class 'Image' [package "EBImage"] with 2 slots
##   .. ..@ .Data    : num [1:816, 1:612, 1:3] 0.42 0.408 0.416 0.416 0.416 ...
##   .. ..@ colormode: int 2
##   .. ..$ dim: int [1:3] 816 612 3
##  $ img_sb_50_11.jpg:Formal class 'Image' [package "EBImage"] with 2 slots
##   .. ..@ .Data    : num [1:816, 1:612, 1:3] 0.388 0.38 0.384 0.384 0.376 ...
##   .. ..@ colormode: int 2
##   .. ..$ dim: int [1:3] 816 612 3
##  $ img_sb_50_12.jpg:Formal class 'Image' [package "EBImage"] with 2 slots
##   .. ..@ .Data    : num [1:816, 1:612, 1:3] 0.38 0.38 0.392 0.384 0.4 ...
##   .. ..@ colormode: int 2
##   .. ..$ dim: int [1:3] 816 612 3
##  $ img_sb_50_13.jpg:Formal class 'Image' [package "EBImage"] with 2 slots
##   .. ..@ .Data    : num [1:816, 1:612, 1:3] 0.4 0.392 0.412 0.392 0.404 ...
##   .. ..@ colormode: int 2
##   .. ..$ dim: int [1:3] 816 612 3
##  $ img_sb_50_2.jpg :Formal class 'Image' [package "EBImage"] with 2 slots
##   .. ..@ .Data    : num [1:816, 1:612, 1:3] 0.384 0.384 0.392 0.388 0.392 ...
##   .. ..@ colormode: int 2
##   .. ..$ dim: int [1:3] 816 612 3
##  $ img_sb_50_3.jpg :Formal class 'Image' [package "EBImage"] with 2 slots
##   .. ..@ .Data    : num [1:816, 1:612, 1:3] 0.369 0.376 0.361 0.361 0.365 ...
##   .. ..@ colormode: int 2
##   .. ..$ dim: int [1:3] 816 612 3
##  $ img_sb_50_4.jpg :Formal class 'Image' [package "EBImage"] with 2 slots
##   .. ..@ .Data    : num [1:816, 1:612, 1:3] 0.4 0.408 0.396 0.392 0.392 ...
##   .. ..@ colormode: int 2
##   .. ..$ dim: int [1:3] 816 612 3
##  $ img_sb_50_5.jpg :Formal class 'Image' [package "EBImage"] with 2 slots
##   .. ..@ .Data    : num [1:816, 1:612, 1:3] 0.396 0.404 0.396 0.396 0.388 ...
##   .. ..@ colormode: int 2
##   .. ..$ dim: int [1:3] 816 612 3
##  $ img_sb_50_6.jpg :Formal class 'Image' [package "EBImage"] with 2 slots
##   .. ..@ .Data    : num [1:816, 1:612, 1:3] 0.4 0.38 0.396 0.384 0.388 ...
##   .. ..@ colormode: int 2
##   .. ..$ dim: int [1:3] 816 612 3
##  $ img_sb_50_7.jpg :Formal class 'Image' [package "EBImage"] with 2 slots
##   .. ..@ .Data    : num [1:816, 1:612, 1:3] 0.353 0.361 0.365 0.365 0.373 ...
##   .. ..@ colormode: int 2
##   .. ..$ dim: int [1:3] 816 612 3
##  $ img_sb_50_8.jpg :Formal class 'Image' [package "EBImage"] with 2 slots
##   .. ..@ .Data    : num [1:816, 1:612, 1:3] 0.365 0.373 0.38 0.388 0.384 ...
##   .. ..@ colormode: int 2
##   .. ..$ dim: int [1:3] 816 612 3
##  $ img_sb_50_9.jpg :Formal class 'Image' [package "EBImage"] with 2 slots
##   .. ..@ .Data    : num [1:816, 1:612, 1:3] 0.373 0.365 0.373 0.376 0.392 ...
##   .. ..@ colormode: int 2
##   .. ..$ dim: int [1:3] 816 612 3
```


## Exibindo imagens
Imagens individuais são exibidas com `plot()`. Para combinar imagens, a função `image_combine()` é usada. Os usuários podem informar uma lista de objetos separados por vírgulas ou uma lista de objetos da classe `Image`.


```r
# Imagens individuais
plot(img)
```

<img src="/tutorials/pliman_ip/01_manipulation_files/figure-html/display1-1.png" width="960" />




```r
# Combine imagens
image_combine(img_list1)
```

<img src="/tutorials/pliman_ip/01_manipulation_files/figure-html/display2-1.png" width="960" />




`pliman` fornece um conjunto de funções `image_*()` para realizar a manipulação de imagens e transformação de imagens exclusivas ou uma lista de imagens baseada no [pacote EBImage](https://www.bioconductor.org/packages/release/bioc/vignettes/EBImage/inst/doc/EBImage-Introduction.html).

## Redimensionar uma imagem
Às vezes, o redimensionamento de imagens de alta resolução é necessário para reduzir o esforço computacional e tempo de processamento. A função `image_resize()` é usada para redimensionar uma imagem. O argumento `rel_size` pode ser usado para redimensionar a imagem por tamanho relativo. Por exemplo, definindo `rel_size = 50` para uma imagem de largura 1280 x 720, a nova imagem terá um tamanho de 640 x 360.


```r
image_dimension(img)
```

```
## 
## ----------------------
## Image dimension
## ----------------------
## Width :  783 
## Height:  1005
```

```r
img_resized <- image_resize(img, rel_size = 50)
image_dimension(img_resized)
```

```
## 
## ----------------------
## Image dimension
## ----------------------
## Width :  392 
## Height:  502
```





## Resolução da imagem (DPI) {#dpi}
A função `dpi()` executa uma função interativa para calcular a resolução da imagem dada uma distância conhecida informada pelo usuário. Para calcular a resolução da imagem (dpi), o usuário deve usar o botão esquerdo do mouse para criar uma linha de distância conhecida. Isso pode ser feito, por exemplo, usando um modelo com distância conhecida, como à seguir.


```r
# executado apenas em uma seção interativa
rule <- image_import("rule.jpg", plot = TRUE)
(dpi <- dpi(rule))

rule2 <- image_crop(rule,
                    width = 384:1599,
                    height = 805:1721,
                    plot = TRUE)

analyze_objects(rule2,
                watershed = FALSE,
                marker = "area") |> 
  get_measures(dpi = 518)
```




# Filtro, desfoque, contraste, dilatação, erosão


```r
img_filter <- image_filter(img)
img_blur <- image_blur(img)
img_contrast <- image_contrast(img)
img_dilatation <- image_dilate(img)
img_erosion <- image_erode(img)
img_opening <- image_opening(img)
img_closing <- image_closing(img)
image_combine(img,
              img_filter,
              img_blur,
              img_contrast,
              img_dilatation,
              img_erosion,
              img_opening,
              img_closing,
              ncol = 4)
```

<img src="/tutorials/pliman_ip/01_manipulation_files/figure-html/manipulate6-1.png" width="960" />




# Exportando imagens
Para exportar imagens para o diretório atual, use a função `image_export()`. Se uma lista de imagens for exportada, as imagens serão salvas considerando o nome e a extensão presentes na lista. Se nenhuma extensão estiver presente, as imagens serão salvas como arquivos `* .jpg`.


```r
image_export(img, "img_exported.jpg")

# ou para uma subpasta
image_export(img, "test/img_exported.jpg")
```



