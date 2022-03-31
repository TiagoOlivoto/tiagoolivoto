---
title: Importação de imagens
linktitle: "1. Importação de imagens"
toc: true
type: docs
date: "2022/03/31"
draft: false
df_print: paged
code_download: true
menu:
  plimanufsc:
    parent: pliman
    weight: 2
weight: 1
---



# Diretório das imagens

```r
# mudar de acordo com a pasta em seu computador
setwd("E:/Desktop/tiagoolivoto/static/tutorials/pliman_ufsc_fito/leaves")
```


# Importar imagens

```r
library(pliman)
img <- image_import("exemp_1.jpeg")
plot(img)
```

<img src="/tutorials/pliman_ufsc_fito/01_manipulation_files/figure-html/unnamed-chunk-2-1.png" width="672" />



Para importar uma lista de imagens, o argumento `pattern` da função `image_import()` é usado. Todas as imagens que correspondem ao nome do padrão são importadas para uma lista.


```r
img_list <-  image_import(pattern = "exemp_", plot = TRUE)
```

<img src="/tutorials/pliman_ufsc_fito/01_manipulation_files/figure-html/import2-1.png" width="672" />



# Exibindo imagens
Imagens individuais são exibidas com `plot()`. Para combinar imagens, a função `image_combine()` é usada. Os usuários podem informar uma lista de objetos separados por vírgulas ou uma lista de objetos da classe `Image`.


```r
# Imagens individuais
plot(img)
```

<img src="/tutorials/pliman_ufsc_fito/01_manipulation_files/figure-html/display1-1.png" width="1152" />




```r
# Combine imagens
image_combine(img_list)
```

<img src="/tutorials/pliman_ufsc_fito/01_manipulation_files/figure-html/display2-1.png" width="1152" />


# Manipulando imagens


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
## Width :  724 
## Height:  1257
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
## Width :  362 
## Height:  628
```


## Cortar uma imagem
Cortar imagens é útil para remover ruídos da borda da imagem, bem como para reduzir o tamanho das imagens antes do processamento. Para recortar uma imagem, a função `image_crop()` é usada. Os usuários precisam informar um vetor numérico indicando a faixa de pixels (`width` e `height`) que será mantida na imagem recortada.


```r
crop1 <-
  image_crop(img,
             width = 71:685,
             height = 56:1159,
             plot = TRUE)
```

<img src="/tutorials/pliman_ufsc_fito/01_manipulation_files/figure-html/unnamed-chunk-3-1.png" width="672" />

Se apenas `width` ou `height` forem informados, a imagem será recortada verticalmente ou horizontalmente.


```r
crop2 <-
  image_crop(img,
             height = 56:1159,
             plot = TRUE)
```

<img src="/tutorials/pliman_ufsc_fito/01_manipulation_files/figure-html/unnamed-chunk-4-1.png" width="672" />

Se `width` e `height` não forem declarados, um processo iterativo de corte da imagem é executado.


```r
# executa apenas em uma seção iterativa
image_crop(img)
```


Além disso, um processo de corte automatizado pode ser executado. Nesse caso, a imagem será cortada automaticamente na área de objetos com uma borda de cinco pixels por padrão.


```r
auto_crop <- image_autocrop(img, plot = TRUE)
```

<img src="/tutorials/pliman_ufsc_fito/01_manipulation_files/figure-html/unnamed-chunk-6-1.png" width="672" />



## Resolução da imagem(DPI) {#dpi}
A função `dpi()` executa uma função interativa para calcular a resolução da imagem dada uma distância conhecida informada pelo usuário. Para calcular a resolução da imagem(dpi), o usuário deve usar o botão esquerdo do mouse para criar uma linha de distância conhecida. Isso pode ser feito, por exemplo, usando um modelo com distância conhecida na imagem(por exemplo, `rule.jpg`).


```r
# executado apenas em uma seção interativa
rule <- image_import("rule.jpg", plot = TRUE)
(dpi <- dpi(rule))

rule2 <- image_crop(rule, width = 379:1638, height = 790:1769)

analyze_objects(rule2,
                marker = "area",
                watershed = FALSE) |> 
  get_measures(dpi = 518) |> 
  plot_measures(measure = "area",
                vjust = -100,
                size = 2)
```


## Exportando imagens
Para exportar imagens para o diretório atual, use a função `image_export()`. Se uma lista de imagens for exportada, as imagens serão salvas considerando o nome e a extensão presentes na lista. Se nenhuma extensão estiver presente, as imagens serão salvas como arquivos `* .jpg`.


```r
imagem_exportar(img, "img_exported.jpg")
```



