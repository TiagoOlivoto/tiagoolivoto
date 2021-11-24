---
title: Importação e manipulação
linktitle: "1. Importação e manipulação"
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
    weight: 2
weight: 1
---




# Diretório das imagens

```r
# mudar de acordo com a pasta em seu computador
setwd("E:/Desktop/tiagoolivoto/static/tutorials/pliman_ip/imgs")
```


# Importar imagens

```r
library(pliman)  
img <- image_import("grains.jpg")
```



Para importar uma lista de imagens, use um vetor de nomes de imagens, ou o argumento `pattern`. Neste último, todas as imagens que correspondem ao nome do padrão são importadas para uma lista.


```r
img_list1 <- image_import(c("grains.jpg", "green.jpg"))
img_list2 <- image_import(pattern = "maize_")
str(img_list1)
```

```
## List of 2
##  $ grains.jpg:Formal class 'Image' [package "EBImage"] with 2 slots
##   .. ..@ .Data    : num [1:1281, 1:910, 1:3] 0.412 0.388 0.388 0.38 0.38 ...
##   .. ..@ colormode: int 2
##   .. ..$ dim: int [1:3] 1281 910 3
##  $ green.jpg :Formal class 'Image' [package "EBImage"] with 2 slots
##   .. ..@ .Data    : num [1:1238, 1:929, 1:3] 0.831 0.812 0.824 0.831 0.808 ...
##   .. ..@ colormode: int 2
##   .. ..$ dim: int [1:3] 1238 929 3
```


# Exibindo imagens
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

# Redimensionar uma imagem
Às vezes, o redimensionamento de imagens de alta resolução é necessário para reduzir o esforço computacional e tempo de processamento. A função `image_resize()` é usada para redimensionar uma imagem. O argumento `rel_size` pode ser usado para redimensionar a imagem por tamanho relativo. Por exemplo, definindo `rel_size = 50` para uma imagem de largura 1280 x 720, a nova imagem terá um tamanho de 640 x 360.


```r
image_dimension(img)
```

```
## 
## ----------------------
## Image dimension
## ----------------------
## Width :  1281 
## Height:  910
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
## Width :  640 
## Height:  455
```


# Cortar uma imagem
Cortar imagens é útil para remover ruídos da borda da imagem, bem como para reduzir o tamanho das imagens antes do processamento. Para recortar uma imagem, a função `image_crop()` é usada. Os usuários precisam informar um vetor numérico indicando a faixa de pixels (`width` e `height`) que será mantida na imagem recortada.


```r
crop1 <-
  image_crop(img,
             width = 171:1088,
             height = 115:855,
             plot = TRUE)
```

<img src="/tutorials/pliman_ip/01_manipulation_files/figure-html/unnamed-chunk-4-1.png" width="672" />

Se apenas `width` ou `height` forem informados, a imagem será recortada verticalmente ou horizontalmente.


```r
crop2 <-
  image_crop(img,
             height = 115:855,
             plot = TRUE)
```

<img src="/tutorials/pliman_ip/01_manipulation_files/figure-html/unnamed-chunk-5-1.png" width="672" />

Se `width` e `height` não forem declarados, um processo iterativo de corte da imagem é executado.


```r
# executa apenas em uma seção iterativa
image_crop(img)
```


Além disso, um processo de corte automatizado pode ser executado. Nesse caso, a imagem será cortada automaticamente na área de objetos com uma borda de cinco pixels por padrão.


```r
auto_crop <- image_autocrop(img, plot = TRUE)
```

<img src="/tutorials/pliman_ip/01_manipulation_files/figure-html/unnamed-chunk-7-1.png" width="672" />

```r
# um exemplo de corte em lote
imgs_crop <- image_import(pattern = "crop_", plot = TRUE)
```

<img src="/tutorials/pliman_ip/01_manipulation_files/figure-html/unnamed-chunk-7-2.png" width="672" />

```r
cropped <- image_autocrop(imgs_crop)
image_combine(cropped)
```

<img src="/tutorials/pliman_ip/01_manipulation_files/figure-html/unnamed-chunk-7-3.png" width="672" />

```r
# somente na versão de desenvolvimento
image_export(cropped, prefix = "c_", subfolder = "cropped")
```


A função `image_trim()` é usada para cortar pixels das bordas da imagem.



```r
# apara 100 pixels de todas as bordas
img_trim <- image_trim(img, edge = 50, plot = TRUE)

# O mesmo é alcançado com
img_trim2 <-
  image_trim(img,
             top = 50,
             bottom = 50,
             left = 50,
             right = 50,
             plot = TRUE)
```

<img src="/tutorials/pliman_ip/01_manipulation_files/figure-html/manipulate2-1.png" width="960" />

```r
# apara 100 pixels da parte superior e 50 da inferior
img_trim3 <-
  image_trim(img,
             top = 100,
             bottom = 50,
             plot = TRUE)
```

<img src="/tutorials/pliman_ip/01_manipulation_files/figure-html/manipulate2-2.png" width="960" />




# Resolução da imagem (DPI) {#dpi}
A função `dpi()` executa uma função interativa para calcular a resolução da imagem dada uma distância conhecida informada pelo usuário. Para calcular a resolução da imagem(dpi), o usuário deve usar o botão esquerdo do mouse para criar uma linha de distância conhecida. Isso pode ser feito, por exemplo, usando um modelo com distância conhecida na imagem(por exemplo, `leaves.JPG`).


```r
# executado apenas em uma seção interativa
rule <- image_import("rule.jpg", plot = TRUE)
dpi(rule)
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



