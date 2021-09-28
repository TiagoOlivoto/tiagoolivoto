---
title: Importação de imagens
linktitle: "1. Importação de imagens"
toc: true
type: docs
date: "2021/09/28"
draft: false
df_print: paged
code_download: true
menu:
  plimanesalq:
    parent: pliman
    weight: 2
weight: 1
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
plot(img)
```

<img src="/tutorials/pliman_esalq/01_manipulation_files/figure-html/unnamed-chunk-2-1.png" width="672" />



Para importar uma lista de imagens, o argumento `pattern` da função` image_import() `é usado. Todas as imagens que correspondem ao nome do padrão são importadas para uma lista.


```r
soy_list <-
  image_import(pattern = "soy_") # escolha o diretório do caminho
names(soy_list)
```

```
##  [1] "soy_1.jpg"  "soy_10.jpg" "soy_11.jpg" "soy_12.jpg" "soy_13.jpg"
##  [6] "soy_14.jpg" "soy_15.jpg" "soy_16.jpg" "soy_17.jpg" "soy_18.jpg"
## [11] "soy_19.jpg" "soy_2.jpg"  "soy_20.jpg" "soy_3.jpg"  "soy_4.jpg" 
## [16] "soy_5.jpg"  "soy_6.jpg"  "soy_7.jpg"  "soy_8.jpg"  "soy_9.jpg"
```




<!-- ## Exibindo imagens -->
<!-- Imagens individuais são exibidas com `plot()`. Para combinar imagens, a função `image_combine()` é usada. Os usuários podem informar uma lista de objetos separados por vírgulas ou uma lista de objetos da classe `Image`. -->

<!-- ```{r display1, fig.width = 12} -->
<!-- # Imagens individuais -->
<!-- plot(soy) -->

<!-- ``` -->



<!-- ```{r display2, fig.width = 12} -->
<!-- # Combine imagens -->
<!-- image_combine(soy, soja2) -->

<!-- # Combine imagens -->
<!-- image_combine(soy_list) -->


<!-- ``` -->


<!-- ## Manipulando imagens -->


<!-- `pliman` fornece um conjunto de funções` image _ *() `para realizar a manipulação de imagens e transformação de imagens exclusivas ou uma lista de imagens baseada no [pacote EBImage](https://www.bioconductor.org/packages/release/ bioc/vignettes/EBImage/inst/doc/EBImage-Introduction.html). -->

<!-- ### Redimensionar uma imagem -->
<!-- Às vezes, o redimensionamento de imagens de alta resolução é necessário para reduzir o tempo de processamento. A função `image_resize()` é usada para redimensionar uma imagem. O argumento `rel_size` pode ser usado para redimensionar a imagem por tamanho relativo. Por exemplo, definindo `rel_size = 50` para uma imagem de largura 1280 x 720, a nova imagem terá um tamanho de 640 x 360. Isso é útil para acelerar o tempo de análise, como aqueles calculados com` analyze_objects` e `measure_disease()`. -->

<!-- ```{r manipulate1} -->
<!-- dimensão_da_imagem(soja) -->
<!-- soy_resized <- image_resize(soy, rel_size = 50) -->
<!-- image_dimension(soy_resized) -->
<!-- ``` -->


<!-- ### Corta uma imagem -->
<!-- Cortar imagens é útil para remover ruídos da borda da imagem, bem como para reduzir o tamanho das imagens antes do processamento. Para recortar uma imagem, a função `image_crop()` é usada. Os usuários precisam informar um vetor numérico indicando a faixa de pixels(`largura` e` altura`) que será mantida na imagem recortada. -->

<!-- ```{r} -->
<!-- crop1 <- -->
<!--   image_crop(soja, -->
<!--              largura = 170: 720, -->
<!--              altura = 300: 650, -->
<!--              plot = TRUE) -->
<!-- ``` -->

<!-- Se apenas `width` ou` height` forem informados, a imagem será recortada verticalmente ou horizontalmente. -->

<!-- ```{r} -->
<!-- colheita2 <- -->
<!--   image_crop(soja, -->
<!--              largura = 170: 720, -->
<!--              plot = TRUE) -->
<!-- ``` -->

<!-- Se `width` e` height` estiverem faltando, um processo iterativo de corte da imagem é executado. -->

<!-- ```{r eval = FALSE} -->
<!-- # executa apenas em uma seção iterativa -->
<!-- image_crop(soja) -->
<!-- ``` -->


<!-- Além disso, um processo de corte automatizado pode ser executado. Nesse caso, a imagem será cortada automaticamente na área de objetos com uma borda de cinco pixels por padrão. -->

<!-- ```{r} -->
<!-- auto_crop <- image_autocrop(soja, plot = TRUE) -->
<!-- ``` -->


<!-- A função `image_trim()` é usada para cortar pixels das bordas da imagem. -->


<!-- ```{r manipulate2, fig.width = 10} -->
<!-- # apara 100 pixels de todas as bordas -->
<!-- soy_trim <- image_trim(soja, borda = 100, plot = TRUE) -->

<!-- # O mesmo é alcançado com -->
<!-- soy_trim2 <- -->
<!--   image_trim(soja, -->
<!--              top = 100, -->
<!--              inferior = 100, -->
<!--              esquerda = 100, -->
<!--              direita = 100, -->
<!--              plot = TRUE) -->

<!-- # apara 200 pixels da parte superior e inferior -->
<!-- soy_trim3 <- -->
<!--   image_trim(soja, -->
<!--              top = 200, -->
<!--              inferior = 200, -->
<!--              plot = TRUE) -->
<!-- # apara para 5 pixels ao redor da área dos objetos -->

<!-- ``` -->




<!-- ### Resolução da imagem(DPI) {#dpi} -->
<!-- A função `dpi()` executa uma função interativa para calcular a resolução da imagem dada uma distância conhecida informada pelo usuário. Para calcular a resolução da imagem(dpi), o usuário deve usar o botão esquerdo do mouse para criar uma linha de distância conhecida. Isso pode ser feito, por exemplo, usando um modelo com distância conhecida na imagem(por exemplo, `leaves.JPG`). -->

<!-- ```{r eval = FALSE} -->
<!-- # executado apenas em uma seção interativa -->
<!-- folhas <- imagem_import("./ leaf_area/leaves.JPG") -->
<!-- dpi(folhas) -->
<!-- ``` -->


<!-- <iframe width = "760" height = "430" src = "https://www.youtube.com/embed/Rh10_pLgeng" title = "Player de vídeo do YouTube" frameborder = "0" allow = "acelerômetro; autoplay; área de transferência- gravação; mídia criptografada; giroscópio; imagem em imagem "allowfullscreen> </iframe> -->



<!-- ### Girar uma imagem -->
<!-- `image_rotate()` é usado para girar a imagem no sentido horário pelo ângulo dado. -->

<!-- ```{r manipulate3} -->
<!-- soy_rotated <- image_rotate(soja, ângulo = 45, plot = TRUE) -->
<!-- ``` -->


<!-- ### Reflexão horizontal e vertical -->
<!-- `image_hreflect()` e `image_vreflect()` executa reflexão vertical e horizontal de imagens, respectivamente. -->

<!-- ```{r manipulate4, fig.width = 20} -->
<!-- soy_hrefl <- image_hreflect(soja) -->
<!-- soy_vrefl <- image_vreflect(soja) -->
<!-- image_combine(soy, soy_hrefl, soy_vrefl, ncol = 3) -->
<!-- ``` -->



<!-- ### Conversão horizontal e vertical -->
<!-- `image_horizontal()` e `image_vertical()` converte(se necessário) uma imagem em uma imagem horizontal ou vertical, respectivamente. -->

<!-- ```{r manipulate5, fig.width = 20} -->
<!-- soy_h <- imagem_horizontal(soja) -->
<!-- soy_v <- imagem_vertical(soja) -->
<!-- image_combine(soy, soy_h, soy_v, ncol = 3) -->

<!-- ``` -->


<!-- ### Filtro, desfoque, contraste, dilatação e erosão -->

<!-- ```{r manipulate6, fig.width = 10, -->



