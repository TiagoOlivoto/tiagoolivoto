---
toc: true
title: O pacote R pliman
author: Tiago Olivoto
date: '2021-05-12'
slug: []
categories:
  - pliman
tags:
  - Pliman
  - Plant image analysis
  - Count objects
  - Disease severity
  - Image segmentation
  - Image manipulation
  - Image index
subtitle: ''
summary: 'Você fornece paletas de cores, diz ao pliman o que cada uma representa e ele cuida dos detalhes'
authors: [Tiago Olivoto]
lastmod: '2021-05-12'
featured: no
image:
  placement: 2
  caption: 'Image by Tiago Olivoto'
  preview_only: no
projects: []
---



<a href="https://olivoto.netlify.app/post/pliman_pt_br/"  class="btn btn-primary" role="button">This post is also available in English</a>


# Introdução

Tenho o prazer de anunciar o lançamento do `pliman` (**p**ant **im**age **an**alysis) 0.2.0 no [CRAN](https://cran.r-project.org/web/packages/pliman/index.html). `pliman` é um pacote para análise de imagens, com foco especial em imagens de plantas. A análise de imagens é uma ferramenta útil para obter informações quantitativas para objetos alvo. No contexto de imagens de plantas, quantificar a área foliar, a severidade das doenças, o número de lesões, contar o número de grãos, obter estatísticas de grãos (por exemplo, comprimento e largura) são algumas das tarefas que agrônomos, criadores, fitopatologistas, geneticistas e biólogos fazem rotineiramente.

O pacote irá ajudá-lo a:

* Medir a área foliar com `leaf_area()`
* Contar a gravidade da doença com `symptomatic_area()`
* Contar o número de lesões com `count_lesions()`
* Contar objetos em uma imagem com `count_objects()`
* Obter os valores RGB para cada objeto em uma imagem com `objects_rgb()`
* Obter estatisticas de objetos com `get_measures()`
* Plotar as estatisticas do objetos com `plot_measures()`

# Instalação

Instale a última versão estável do `pliman` do [CRAN](https://CRAN.R-project.org/package=pliman) com:


```r
install.packages("pliman")

```


A versão de desenvolvimento do `pliman` pode ser instalada do [GitHub](https://github.com/TiagoOlivoto/pliman) com:


```r
devtools::install_github("TiagoOlivoto/pliman")

# To build the HTML vignette use
devtools::install_github("TiagoOlivoto/pliman", build_vignettes = TRUE)

```

*Nota*: Se você for um usuário do Windows, é sugerido instalar a versão mais recente do [Rtools](https://cran.r-project.org/bin/windows/Rtools/) antes.


# Breves exemplos
## Área foliar

Medir a área foliar é uma tarefa muito comum para criadores e agrônomos. A área foliar é usada como um recurso chave para o cálculo de vários índices, como o Índice de Área da Folha (IAF), que quantifica a quantidade de material foliar em um dossel. No pliman, os pesquisadores podem medir a área foliar usando imagens de folhas de duas maneiras principais. O primeiro, usando `leaf_area()` usa uma amostra de folhas junto com um modelo com uma área conhecida. As paletas de cores de fundo, folha e modelo devem ser declaradas. Uma forma alternativa de calcular a área foliar em `pliman` é usando` count_objects()`. Esta função tem a vantagem de usar segmentação de imagem com base em vários índices (por exemplo, valores de vermelho, verde e azul, RGB). Portanto, as paletas de amostra não precisam ser inseridas. No exemplo a seguir, calcularemos a área da folha da imagem `leaves` com esta última abordagem. Para mais detalhes e outros exemplos, veja esta [vinheta](https://tiagoolivoto.github.io/pliman/articles/leaf_area.html).



```r
library(pliman)
# |========================================================|
# | Tools for Plant Image Analysis (pliman 0.2.0)          |
# | Author: Tiago Olivoto                                  |
# | Type 'vignette('pliman_start')' for a short tutorial   |
# | Visit 'https://bit.ly/3eL0dF3' for a complete tutorial |
# |========================================================|
leaves <- image_import(image_pliman("la_leaves.JPG"))
image_show(leaves)
```

<img src="/post/pliman_pt_br/index.pt-br_files/figure-html/unnamed-chunk-3-1.png" width="672" />


```r
count <- count_objects(leaves)
# 
# --------------------------------------------
# Number of objects: 6 
# --------------------------------------------
#  statistics      area perimeter
#         min   4332.00  253.0000
#        mean  26704.17  533.5000
#         max  44763.00  727.0000
#          sd  16286.76  197.2265
#         sum 160225.00 3201.0000
plot_measures(count)
```

<img src="/post/pliman_pt_br/index.pt-br_files/figure-html/unnamed-chunk-4-1.png" width="672" />

A função `get_measures()` é utilizada para ajustar a área foliar utilizando o objeto 6. Sabe-se que este objeto tem um lado de 2 cm, portanto apresenta 4 cm `\(^2\)`.


```r
area <-
get_measures(count,
             id = 6,
             area ~ 4)
# -----------------------------------------
# measures corrected with:
# object id: 6
# area: 4
# -----------------------------------------
area
#   id        x        y      area perimeter radius_mean radius_min radius_max
# 1  1 537.3833 498.9915 41.332410 22.091245    3.678437   2.756046   5.259454
# 2  2 438.6512 165.2385 35.362881 19.477975    3.370650   2.875019   4.546890
# 3  3 110.8785 477.0276 31.268698 20.116099    3.268759   2.374700   4.856987
# 4  4 178.4196 174.2348 27.445983 18.201727    3.027071   2.307497   4.394600
# 5  5 315.2358 434.6106  8.535549  9.693407    1.655947   1.311698   2.253471
# 6  6 313.4910 655.2052  4.000000  7.687875    1.125488   0.926436   1.378890
```
             

## Contagem de grãos em uma imagem

Aqui, contaremos os grãos na imagem `soybean_touch.png`. Esta imagem tem um fundo ciano e contém 30 grãos de soja se tocando. Visite [este post](https://tiagoolivoto.github.io/pliman/articles/count_objects.html) para mais detalhes e exemplos.


```r
soy <- image_import (image_pliman ("soybean_touch.jpg"))
image_show(soy)
```

<img src="/post/pliman_pt_br/index.pt-br_files/figure-html/unnamed-chunk-6-1.png" width="672" />

A função `count_objects()` segmenta a imagem usando o índice azul padrão como padrão, como segue $ NB = (B / (R + G + B)) $, onde `\(R\)`, `\(G\)` e `\(B\)` são os faixas vermelhas, verdes e azuis. Os objetos são contados e os objetos segmentados são coloridos aleatoriamente


```r
count <- count_objects(soy)
```

<img src="/post/pliman_pt_br/index.pt-br_files/figure-html/unnamed-chunk-7-1.png" width="672" />

```
# 
# --------------------------------------------
# Number of objects: 30 
# --------------------------------------------
#  statistics       area   perimeter
#         min  1366.0000  117.000000
#        mean  2057.3667  146.600000
#         max  2445.0000  158.000000
#          sd   230.5574    8.406073
#         sum 61721.0000 4398.000000
```

Os usuários podem remover cores aleatórias e identificar objetos (neste exemplo, grãos) usando os argumentos `marker = "text"` e `show_segmentation = FALSE`. A cor de fundo também pode ser alterada com o argumento `col_background`. Neste exemplo, apenas os cinco maiores grãos na área serão identificados usando `topn_upper = 5`.


```r
count2 <-
  count_objects(soy,
                marker = "text",
                show_segmentation = FALSE,
                col_background = "white",
                topn_upper = 5)
```

<img src="/post/pliman_pt_br/index.pt-br_files/figure-html/unnamed-chunk-8-1.png" width="672" />

```
# 
# --------------------------------------------
# Number of objects: 5 
# --------------------------------------------
#  statistics        area  perimeter
#         min  2299.00000 152.000000
#        mean  2334.60000 154.200000
#         max  2445.00000 158.000000
#          sd    62.07495   2.387467
#         sum 11673.00000 771.000000
# Obtém as medidas do objeto
(medidas <- get_measures(count2))
#    id        x         y area perimeter radius_mean radius_min radius_max
# 4   1 345.3566 105.78323 2445       158    27.51343   24.68250   30.47116
# 11  2 468.9970  56.42549 2315       155    26.76542   23.03064   30.78003
# 3   3 237.5917 339.82483 2312       152    26.69878   23.96521   29.04402
# 5   4 406.9314  77.54909 2302       153    26.64891   23.96546   29.63586
# 2   5 538.0561 401.89604 2299       153    26.60716   24.95688   28.40020
```


## Severidade de doenças

A severidade da doença em plantas é um parâmetro importante para medir o nível da doença e, portanto, pode ser usada para prever a produção e recomendar tratamentos. No `pliman`, a função` symptomatic_area()` é usada para quantificar a severidade das doenças. O usuário fornece paletas de cores, diz ao `pliman` o que cada uma representa e ele cuida dos detalhes.


```r
img <- image_import(image_pliman("sev_leaf.jpg"))
healthy <- image_import(image_pliman("sev_healthy.jpg"))
symptoms <- image_import(image_pliman("sev_sympt.jpg"))
background <- image_import(image_pliman("sev_back.jpg"))
image_combine(img, healthy, symptoms,background)
```

<img src="/post/pliman_pt_br/index.pt-br_files/figure-html/unnamed-chunk-9-1.png" width="672" />

```r

# Computar a severidade de doenças
symptomatic_area(img = img,
                 img_healthy = healthy,
                 img_symptoms = symptoms,
                 img_background = background,
                 show_image = TRUE)
```

<img src="/post/pliman_pt_br/index.pt-br_files/figure-html/unnamed-chunk-9-2.png" width="672" />

```
#    healthy symptomatic
# 1 89.17328    10.82672
```


# Processamento em lote
Na análise de imagens de plantas, frequentemente é necessário processar mais de uma imagem. Por exemplo, no melhoramento de plantas, o número de grãos por planta (por exemplo, trigo) é frequentemente usado na seleção indireta de plantas de alto rendimento. No `pliman`, o processamento em lote pode ser feito quando o usuário declara o argumento` img_pattern`.

O exemplo a seguir seria usado para contar os objetos nas imagens com um nome de padrão `"trat"` (por exemplo, `"trat1"`, `"trat2"`, `"tratn"`) salvos na subpasta "`originals"` no diretório de trabalho atual. As imagens processadas serão salvas na subpasta `"processed"`. O objeto `list_res` será uma lista com dois objetos (`results` e `statistics`) para cada imagem.

Para acelerar o tempo de processamento, especialmente para um grande número de imagens, o argumento `parallel = TRUE` pode ser usado. Nesse caso, as imagens são processadas de forma assíncrona (em paralelo) em sessões `R` separadas rodando em segundo plano na mesma máquina. O número de seções é configurado para 90% dos núcleos (virtuais) disponíveis. Este número pode ser controlado explicitamente com o argumento `workers`.



```r
list_res <- 
count_objects(img_pattern = "trat", # matches the name pattern in 'originals' subfolder
              dir_original = "originals",
              dir_processed = "processed",
              parallel = TRUE, # parallel processing
              workers = 8, # 8 multiple sections
              save_image = TRUE)
```


<i class = "fas fa-check"> </i> Siga o [projeto pliman](https://www.researchgate.net/project/R-package-pliman) no Research Gate.<br>
<i class = "fas fa-check"> </i> Compartilhe este post nas suas redes sociais.<br>
<i class = "fas fa-check"> </i> Aproveite as funcionalidades do pacote! <br>

