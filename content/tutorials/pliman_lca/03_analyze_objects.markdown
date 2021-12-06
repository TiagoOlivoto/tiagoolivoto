---
title: Analizando objetos
linktitle: "3. Analizando objetos"
toc: true
type: docs
date: "2021/11/25"
lastmod: "2021/11/25"
draft: false
df_print: paged
code_download: true
menu:
  plimanlca:
    parent: pliman
    weight: 4
weight: 3
---



# Diretório das imagens

```r
# mudar de acordo com a pasta em seu computador
setwd("E:/Desktop/tiagoolivoto/static/tutorials/pliman_lca/imgs")
```

A função `analyze_objects()` pode ser usada para contar objetos em uma imagem. Vamos começar com um exemplo simples com a imagem `object_300dpi.png` disponível na [página GitHub](https://github.com/TiagoOlivoto/pliman/tree/master/inst/tmp_images). Para facilitar a importação de imagens desta pasta, uma função auxiliar `image_pliman()` é usada.



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
## v readr   2.1.1     v forcats 0.5.1
## Warning: package 'tidyr' was built under R version 4.1.1
## Warning: package 'readr' was built under R version 4.1.2
## -- Conflicts ------------------------------------------ tidyverse_conflicts() --
## x forcats::%>%()  masks stringr::%>%(), dplyr::%>%(), purrr::%>%(), tidyr::%>%(), tibble::%>%(), pliman::%>%()
## x dplyr::filter() masks stats::filter()
## x dplyr::lag()    masks stats::lag()
library(patchwork)

img <- image_pliman("objects_300dpi.jpg", plot = TRUE)
```

<img src="/tutorials/pliman_lca/03_analyze_objects_files/figure-html/unnamed-chunk-3-1.png" width="672" />



A imagem acima foi produzida com o Microsoft PowerPoint. Tem uma resolução conhecida de 300 dpi(pontos por polegada) e mostra quatro objetos

- Quadrado maior: 10 x 10 cm (100 cm$^2$)  
- Quadrado menor: 5 x 5 cm(25 cm$^2$)  
- Retângulo: 4 x 2 cm(8 cm$^2$)  
- Círculo: 3 cm de diâmetro(~7,07 cm$^2$)  


Para contar os objetos na imagem usamos `analyze_objects()` e informamos a imagem (o único argumento obrigatório). Primeiro, usamos `image_binary()` para ver o índice mais adequado para segmentar os objetos do fundo. Por padrão, R, G, B e seus valores normalizados.



```r
image_binary(img)
```

<img src="/tutorials/pliman_lca/03_analyze_objects_files/figure-html/unnamed-chunk-4-1.png" width="960" />



# Analizar objetos


```r
img_res <- analyze_objects(img, marker = "id")
```

<img src="/tutorials/pliman_lca/03_analyze_objects_files/figure-html/unnamed-chunk-5-1.png" width="960" />



# Ajustando as medidas do objeto

Os resultados foram armazenados em `img_res`. Como não há escala declarada no exemplo acima, não temos ideia sobre a área real dos objetos em cm$^2$, apenas em pixels. Neste caso, usamos `get_measures()` para ajustar as medidas de pixels para unidades métricas.

Existem duas formas principais de ajustar as medidas do objeto (de pixels a cm, por exemplo). O primeiro é declarar a área, perímetro ou raio conhecido de um determinado objeto. A medida para os outros objetos será então calculada por uma regra de três simples. A segunda é declarando uma resolução de imagem conhecida em dpi (pontos por polegada). Neste caso, perímetro, área e raio serão ajustados pelo dpi informado.

## Declarando um valor conhecido

Como conhecemos a área do quadrado maior (objeto 1), vamos ajustar a área dos outros objetos na imagem usando isso.



```r
get_measures(img_res,
             id = 1,
             area ~ 100)
```

```
## -----------------------------------------
## measures corrected with:
## object id: 1
## area     : 100
## -----------------------------------------
## Total    : 139.985 
## Average  : 34.996 
## -----------------------------------------
```

```
##   id        x        y    area area_ch perimeter radius_mean radius_min
## 1  1  668.506  798.002 100.000  99.915    39.932       5.733      4.992
## 2  2 1737.513  453.246  25.041  24.978    19.924       2.865      2.495
## 3  3 1737.575 1296.331   7.023   7.015     8.504       1.491      1.483
## 4  4 1737.972  939.503   7.922   7.880    11.886       1.666      0.986
##   radius_max radius_sd radius_ratio diam_mean diam_min diam_max major_axis
## 1      7.062    74.203        1.415    11.466    9.983   14.124     11.552
## 2      3.524    36.957        1.413     5.730    4.989    7.049      5.781
## 3      1.502     0.398        1.012     2.983    2.967    3.003      2.991
## 4      2.222    50.007        2.253     3.332    1.973    4.444      4.611
##   minor_axis eccentricity  theta solidity circularity
## 1     11.542        0.041  0.014    1.001       0.788
## 2      5.776        0.041  1.539    1.003       0.793
## 3      2.990        0.026 -1.490    1.001       1.220
## 4      2.291        0.868  0.000    1.005       0.705
```



O mesmo pode ser usado para ajustar as medidas com base no perímetro ou raio. Vamos ajustar o perímetro dos objetos pelo perímetro do objeto 2(20 cm).


## Declarando a resolução da imagem

Se a resolução da imagem for conhecida, todas as medidas serão ajustadas de acordo com esta resolução. Vamos ver um exemplo numérico com `pixels_to_cm()`. Esta função converte o número de pixels (*px*) em cm, considerando a resolução da imagem em `dpi`, da seguinte forma: `\(cm = px \times(2,54 / dpi)\)`. Como sabemos o número de pixels do quadrado maior, seu perímetro em cm é dado por




```r
# número de pixels para o perímetro do quadrado maior

ls_px <- img_res$results$perimeter[1]
pixels_to_cm(px = ls_px, dpi = 300)
```

```
## [1] 39.878
```

O perímetro do objeto 1 ajustado pela resolução da imagem é muito próximo do verdadeiro (40 cm). Abaixo, os valores de todas as medidas são ajustados declarando o argumento `dpi` em` get_measures()`.


```r
img_res_cor <- get_measures(img_res, dpi = 300)
print_tbl(t(img_res_cor))
```



|             |       1|        2|        3|        4|
|:------------|-------:|--------:|--------:|--------:|
|id           |   1.000|    2.000|    3.000|    4.000|
|x            | 668.506| 1737.513| 1737.575| 1737.972|
|y            | 798.002|  453.246| 1296.331|  939.503|
|area         |  99.729|   24.973|    7.004|    7.900|
|area_ch      |  99.644|   24.910|    6.996|    7.858|
|perimeter    |  39.878|   19.897|    8.492|   11.870|
|radius_mean  |   5.725|    2.861|    1.489|    1.664|
|radius_min   |   4.985|    2.491|    1.481|    0.985|
|radius_max   |   7.052|    3.520|    1.500|    2.219|
|radius_sd    |  74.203|   36.957|    0.398|   50.007|
|radius_ratio |   1.415|    1.413|    1.012|    2.253|
|diam_mean    |  11.450|    5.722|    2.979|    3.327|
|diam_min     |   9.970|    4.983|    2.963|    1.970|
|diam_max     |  14.105|    7.039|    2.999|    4.438|
|major_axis   |  11.536|    5.773|    2.987|    4.604|
|minor_axis   |  11.526|    5.768|    2.986|    2.288|
|eccentricity |   0.041|    0.041|    0.026|    0.868|
|theta        |   0.014|    1.539|   -1.490|    0.000|
|solidity     |   1.001|    1.003|    1.001|    1.005|
|circularity  |   0.788|    0.793|    1.220|    0.705|


## Entendendo as medidas


```r
object_contour(img) %>% # obtém o contorno dos objetos
  poly_mass() %>% # computa o centro de massa e raios mínimo e máximo
  plot_mass() # plota as medidas
```

<img src="/tutorials/pliman_lca/03_analyze_objects_files/figure-html/unnamed-chunk-9-1.png" width="672" />

* Quadrado maior:
   - O diâmetro mínimo (a = 9,97) pode ser considerado como o lado do quadrado
   
   - O diâmetro máximo, dado por `\(a \sqrt{2}\)` pode ser considerado a diagonal do quadrado ($9,97 \sqrt{2} = 14.099$ 

```r
t(img_res_cor)
```

```
##                    1        2        3        4
## id             1.000    2.000    3.000    4.000
## x            668.506 1737.513 1737.575 1737.972
## y            798.002  453.246 1296.331  939.503
## area          99.729   24.973    7.004    7.900
## area_ch       99.644   24.910    6.996    7.858
## perimeter     39.878   19.897    8.492   11.870
## radius_mean    5.725    2.861    1.489    1.664
## radius_min     4.985    2.491    1.481    0.985
## radius_max     7.052    3.520    1.500    2.219
## radius_sd     74.203   36.957    0.398   50.007
## radius_ratio   1.415    1.413    1.012    2.253
## diam_mean     11.450    5.722    2.979    3.327
## diam_min       9.970    4.983    2.963    1.970
## diam_max      14.105    7.039    2.999    4.438
## major_axis    11.536    5.773    2.987    4.604
## minor_axis    11.526    5.768    2.986    2.288
## eccentricity   0.041    0.041    0.026    0.868
## theta          0.014    1.539   -1.490    0.000
## solidity       1.001    1.003    1.001    1.005
## circularity    0.788    0.793    1.220    0.705
```




# Contando objetos

Aqui, contaremos os grãos na imagem `soybean_touch.jpg`. Esta imagem tem um fundo ciano e contém 30 grãos de soja que se tocam. A função `analyze_objects()` segmenta a imagem usando como padrão o índice azul normalizado, como segue `\(NB =(B /(R + G + B))\)`, onde *R*, *G* e *B* são as faixas vermelha, verde e azul. Os objetos são contados e os objetos segmentados são coloridos com permutações aleatórias.




```r
soy <- image_pliman("soybean_touch.jpg")

count <- analyze_objects(soy)
```

<img src="/tutorials/pliman_lca/03_analyze_objects_files/figure-html/unnamed-chunk-11-1.png" width="1152" />

```r
count$statistics %>% 
  print_tbl()
```



|stat      |     value|
|:---------|---------:|
|n         |    30.000|
|min_area  |  1366.000|
|mean_area |  2057.367|
|max_area  |  2445.000|
|sd_area   |   230.557|
|sum_area  | 61721.000|



Os usuários podem definir `show_contour = FALSE` para remover a linha de contorno e identificar os objetos (neste exemplo, os grãos) usando os argumentos `marker = "id"`. A cor do fundo também pode ser alterada com `col_background`.




```r
count2 <-
  analyze_objects(soy,
                  show_contour = FALSE,
                  marker = "id",
                  show_segmentation = FALSE,
                  col_background = "white") # padrão
```

<img src="/tutorials/pliman_lca/03_analyze_objects_files/figure-html/unnamed-chunk-12-1.png" width="1152" />




```r
# Obtenha as medidas do objeto

medidas <- get_measures(count)
medidas %>% 
  print_tbl()
```



| id|       x|       y| area| area_ch| perimeter| radius_mean| radius_min| radius_max| radius_sd| radius_ratio| diam_mean| diam_min| diam_max| major_axis| minor_axis| eccentricity|  theta| solidity| circularity|
|--:|-------:|-------:|----:|-------:|---------:|-----------:|----------:|----------:|---------:|------------:|---------:|--------:|--------:|----------:|----------:|------------:|------:|--------:|-----------:|
|  1| 245.833| 509.841| 2286|    2321|       158|      26.543|     22.763|     28.941|     1.425|        1.271|    53.086|   45.526|   57.883|     56.422|     51.849|        0.394| -0.870|    0.985|       1.151|
|  2| 538.056| 401.896| 2299|    2258|       153|      26.607|     24.957|     28.400|     0.935|        1.138|    53.214|   49.914|   56.800|     56.604|     51.733|        0.406| -0.838|    1.018|       1.234|
|  3| 237.592| 339.825| 2312|    2282|       152|      26.699|     23.965|     29.044|     1.233|        1.212|    53.398|   47.930|   58.088|     57.510|     51.247|        0.454| -0.572|    1.013|       1.258|
|  4| 345.357| 105.783| 2445|    2406|       158|      27.513|     24.682|     30.471|     1.730|        1.235|    55.027|   49.365|   60.942|     60.922|     51.105|        0.544| -0.991|    1.016|       1.231|
|  5| 406.931|  77.549| 2302|    2264|       153|      26.649|     23.965|     29.636|     1.640|        1.237|    53.298|   47.931|   59.272|     58.860|     49.819|        0.533|  1.144|    1.017|       1.236|
|  6| 277.445| 260.559| 2163|    2120|       149|      25.766|     24.291|     27.887|     0.765|        1.148|    51.532|   48.581|   55.774|     53.963|     51.097|        0.322| -0.163|    1.020|       1.224|
|  7| 301.206| 370.092| 2217|    2202|       154|      26.113|     23.591|     28.687|     1.358|        1.216|    52.227|   47.182|   57.375|     56.484|     50.034|        0.464| -1.493|    1.007|       1.175|
|  8| 192.828| 379.645| 2207|    2176|       149|      26.105|     23.715|     28.858|     1.488|        1.217|    52.210|   47.431|   57.717|     57.339|     49.030|        0.518|  0.956|    1.014|       1.249|
|  9| 434.710| 553.707| 2174|    2132|       148|      25.890|     23.750|     28.506|     1.437|        1.200|    51.781|   47.499|   57.012|     56.797|     48.755|        0.513|  0.946|    1.020|       1.247|
| 10| 594.744|  47.311| 2219|    2182|       153|      26.160|     23.352|     29.659|     1.856|        1.270|    52.320|   46.704|   59.319|     58.590|     48.249|        0.567| -1.032|    1.017|       1.191|
| 11| 468.997|  56.425| 2315|    2275|       155|      26.765|     23.031|     30.780|     2.349|        1.336|    53.531|   46.061|   61.560|     61.230|     48.157|        0.618|  1.292|    1.018|       1.211|
| 12| 461.172| 156.027| 2175|    2131|       148|      25.933|     23.071|     29.512|     1.656|        1.279|    51.866|   46.142|   59.024|     57.396|     48.284|        0.541|  1.090|    1.021|       1.248|
| 13| 202.075| 203.461| 2188|    2166|       153|      26.008|     22.487|     29.808|     1.987|        1.326|    52.015|   44.974|   59.616|     58.474|     47.719|        0.578| -1.131|    1.010|       1.175|
| 14| 403.486| 169.015| 2035|    1994|       143|      25.019|     22.398|     27.010|     1.168|        1.206|    50.038|   44.796|   54.020|     54.002|     48.012|        0.458| -1.094|    1.021|       1.251|
| 15| 245.987| 221.375| 2117|    2091|       148|      25.528|     21.950|     29.113|     1.793|        1.326|    51.056|   43.900|   58.226|     56.809|     47.542|        0.547| -1.282|    1.012|       1.215|
| 16| 250.400| 436.934| 1964|    1928|       142|      24.552|     22.971|     26.258|     0.798|        1.143|    49.104|   45.943|   52.515|     51.553|     48.573|        0.335| -1.383|    1.019|       1.224|
| 17|  84.671| 206.432| 2183|    2144|       151|      25.923|     22.825|     28.743|     1.708|        1.259|    51.846|   45.650|   57.486|     57.492|     48.382|        0.540|  0.023|    1.018|       1.203|
| 18| 448.412| 296.209| 2068|    2023|       145|      25.196|     23.357|     27.032|     0.993|        1.157|    50.392|   46.714|   54.063|     53.898|     48.857|        0.422| -1.555|    1.022|       1.236|
| 19| 296.178| 186.505| 2056|    2012|       144|      25.132|     22.639|     27.213|     1.211|        1.202|    50.265|   45.279|   54.426|     54.444|     48.094|        0.469|  1.549|    1.022|       1.246|
| 20| 321.973| 321.691| 1978|    1982|       151|      24.635|     21.223|     27.370|     1.595|        1.290|    49.271|   42.445|   54.739|     52.546|     48.202|        0.398|  1.518|    0.998|       1.090|
| 21| 550.202| 200.506| 1939|    1902|       141|      24.400|     22.578|     26.353|     0.849|        1.167|    48.799|   45.156|   52.706|     51.869|     47.628|        0.396|  0.733|    1.019|       1.226|
| 22| 106.294| 432.089| 1922|    1886|       140|      24.304|     22.838|     26.264|     0.891|        1.150|    48.608|   45.675|   52.528|     51.942|     47.122|        0.421|  0.759|    1.019|       1.232|
| 23| 242.940| 388.543| 1926|    1942|       146|      24.391|     22.412|     27.420|     0.958|        1.223|    48.781|   44.825|   54.840|     50.517|     48.757|        0.262| -0.901|    0.992|       1.135|
| 24| 492.988| 344.441| 1891|    1855|       139|      24.076|     21.894|     25.988|     1.180|        1.187|    48.152|   43.789|   51.976|     52.247|     46.096|        0.471|  1.505|    1.019|       1.230|
| 25| 721.705| 586.342| 1915|    1873|       140|      24.250|     21.886|     26.818|     1.350|        1.225|    48.500|   43.772|   53.636|     53.127|     45.908|        0.503|  1.339|    1.022|       1.228|
| 26| 510.468| 158.372| 1787|    1767|       137|      23.466|     21.173|     26.180|     1.009|        1.236|    46.932|   42.345|   52.360|     48.654|     47.026|        0.257| -1.172|    1.011|       1.196|
| 27|  92.838| 569.395| 1743|    1708|       134|      23.124|     21.249|     25.332|     1.044|        1.192|    46.248|   42.499|   50.663|     50.016|     44.394|        0.461|  0.812|    1.020|       1.220|
| 28| 281.037| 474.071| 1819|    1923|       154|      23.484|     17.887|     27.203|     2.497|        1.521|    46.968|   35.773|   54.405|     49.847|     47.188|        0.322|  0.105|    0.946|       0.964|
| 29| 273.273| 547.459| 1710|    1726|       143|      22.780|     17.617|     25.910|     1.792|        1.471|    45.561|   35.234|   51.820|     49.140|     44.737|        0.414| -0.600|    0.991|       1.051|
| 30| 265.292| 143.411| 1366|    1331|       117|      20.405|     18.590|     22.030|     0.772|        1.185|    40.809|   37.181|   44.060|     43.697|     39.816|        0.412| -0.461|    1.026|       1.254|



No exemplo a seguir, selecionaremos objetos com uma área acima da média de todos os objetos usando `lower_size = 2057,36`. Além disso, usaremos o argumento `show_original = FALSE` para mostrar os resultados como uma máscara.




```r
analyze_objects(soy, 
                marker = "id",
                show_original = FALSE,
                lower_size = 2057.36)
```

<img src="/tutorials/pliman_lca/03_analyze_objects_files/figure-html/unnamed-chunk-14-1.png" width="1152" />



Os usuários também podem usar os argumentos `topn_*` para selecionar os  `n` objetos com base nas menores ou maiores áreas. Vamos ver como selecionar os 5 grãos com a menor área, mostrando os grãos originais em um fundo azul. Também usaremos o argumento `my_index` para escolher um índice personalizado para segmentar a imagem. Apenas para comparação, iremos configurar explicitamente o índice azul normalizado chamando `my_index = "B/(R + G + B)"`.




```r
analyze_objects(soy,
                marker = "id",
                topn_lower = 5,
                col_background = "black",
                my_index = "B /(R + G + B)")
```

<img src="/tutorials/pliman_lca/03_analyze_objects_files/figure-html/unnamed-chunk-15-1.png" width="1152" />


# Coordenadas de objetos
Os usuários podem obter as coordenadas para todos os objetos desejados com `object_coord()`. Quando o argumento `id` é definido como `NULL` (padrão), um retângulo delimitador é desenhado incluindo todos os objetos. Use `id = "all"` para obter as coordenadas de todos os objetos na imagem ou use um vetor numérico para indicar os objetos para calcular as coordenadas. Note que o argumento `watershed = FALSE` é usado para 



```r
folhas <- image_import(image = "leaves.jpg", plot = TRUE)

# obter o id de cada objeto
object_id(folhas,  watershed = FALSE)
```

<img src="/tutorials/pliman_lca/03_analyze_objects_files/figure-html/objec2-1.png" width="672" />

```r
# Obtenha as coordenadas de um retângulo delimitador em torno de todos os objetos
object_coord(folhas, watershed = FALSE)
```

<img src="/tutorials/pliman_lca/03_analyze_objects_files/figure-html/objec2-2.png" width="672" />

```
## $col_min
## [1] 47
## 
## $col_max
## [1] 877
## 
## $row_min
## [1] 35
## 
## $row_max
## [1] 1112
```

```r
# Obtenha as coordenadas para todos os objetos
object_coord(folhas,
             id = "all",
             watershed = FALSE)
```

<img src="/tutorials/pliman_lca/03_analyze_objects_files/figure-html/objec2-3.png" width="672" />

```
## $col_min
##  [1]  47  51  54  56  75  79  94 262 292 292 295 308 314 374 376 390 392 412 422
## [20] 463 482 499 526 529 537 540 544 597 603 610 642 661 684 703 709 710 710 714
## [39] 761 778 779
## 
## $col_max
##  [1]  52 372 294 411 308  88 261 686 296 569 308 510 483 378 380 394 529 598 426
## [20] 677 486 572 531 534 657 610 730 658 608 717 785 869 877 707 713 768 714 718
## [39] 765 796 783
## 
## $row_min
##  [1] 534 769 464 181 622 425 390  35 516 977 515 345 531 155 156 163 688 796 176
## [20] 450 556 622 360 359 325 699 916 783 782 555 720 152 802 720 403 318 722 723
## [39] 320 362 639
## 
## $row_max
##  [1]  538 1037  606  370  761  430  452  189  520 1112  520  422  662  159  160
## [16]  167  734  941  180  564  560  660  364  363  362  732 1019  896  786  658
## [31]  762  308  932  724  407  406  726  727  324  641  643
```

```r
# Obtenha as coordenadas dos objetos 1 e 3
object_coord(folhas,
             id = c(2, 4),
             watershed = FALSE)
```

<img src="/tutorials/pliman_lca/03_analyze_objects_files/figure-html/objec2-4.png" width="672" />

```
## $col_min
## [1] 51 56
## 
## $col_max
## [1] 372 411
## 
## $row_min
## [1] 769 181
## 
## $row_max
## [1] 1037  370
```



# Isolando objetos

Para isolar objetos, a função `object_isolate()` é usada. No exemplo a seguir, irei isolar o objeto 32 e definir uma borda de 5 pixels ao redor do objeto.


```r
id1 <- 
  object_isolate(folhas,
                 watershed = FALSE,
                 id = 32,
                 edge = 5)
plot(id1)
```

<img src="/tutorials/pliman_lca/03_analyze_objects_files/figure-html/objec3-1.png" width="672" />



# Processamento em lote

Na análise de imagens, frequentemente é necessário processar mais de uma imagem. Por exemplo, no melhoramento de plantas, o número de grãos por planta (por exemplo, trigo) é frequentemente usado na seleção indireta de plantas de alto rendimento. No `pliman`, o processamento em lote pode ser feito quando o usuário declara o argumento `pattern`.


Para acelerar o tempo de processamento, especialmente para um grande número de imagens, o argumento `parallel = TRUE` pode ser usado. Nesse caso, as imagens são processadas de forma assíncrona(em paralelo) em sessões `R` separadas rodando em segundo plano na mesma máquina. O número de seções é configurado para 50% dos núcleos disponíveis. Este número pode ser controlado explicitamente com o argumento `trabalhadores`.




```r
system.time(
  list_res <- analyze_objects(pattern = "img_sb")
)
```

```
## Processing image img_sb_50_1 |===                                | 8% 00:00:00 
```

<img src="/tutorials/pliman_lca/03_analyze_objects_files/figure-html/unnamed-chunk-16-1.png" width="672" />

```
## Processing image img_sb_50_10 |=====                             | 15% 00:00:00 
```

<img src="/tutorials/pliman_lca/03_analyze_objects_files/figure-html/unnamed-chunk-16-2.png" width="672" />

```
## Processing image img_sb_50_11 |========                          | 23% 00:00:01 
```

<img src="/tutorials/pliman_lca/03_analyze_objects_files/figure-html/unnamed-chunk-16-3.png" width="672" />

```
## Processing image img_sb_50_12 |==========                        | 31% 00:00:02 
```

<img src="/tutorials/pliman_lca/03_analyze_objects_files/figure-html/unnamed-chunk-16-4.png" width="672" />

```
## Processing image img_sb_50_13 |=============                     | 38% 00:00:03 
```

<img src="/tutorials/pliman_lca/03_analyze_objects_files/figure-html/unnamed-chunk-16-5.png" width="672" />

```
## Processing image img_sb_50_2 |================                   | 46% 00:00:03 
```

<img src="/tutorials/pliman_lca/03_analyze_objects_files/figure-html/unnamed-chunk-16-6.png" width="672" />

```
## Processing image img_sb_50_3 |===================                | 54% 00:00:04 
```

<img src="/tutorials/pliman_lca/03_analyze_objects_files/figure-html/unnamed-chunk-16-7.png" width="672" />

```
## Processing image img_sb_50_4 |======================             | 62% 00:00:05 
```

<img src="/tutorials/pliman_lca/03_analyze_objects_files/figure-html/unnamed-chunk-16-8.png" width="672" />

```
## Processing image img_sb_50_5 |========================           | 69% 00:00:06 
```

<img src="/tutorials/pliman_lca/03_analyze_objects_files/figure-html/unnamed-chunk-16-9.png" width="672" />

```
## Processing image img_sb_50_6 |===========================        | 77% 00:00:07 
```

<img src="/tutorials/pliman_lca/03_analyze_objects_files/figure-html/unnamed-chunk-16-10.png" width="672" />

```
## Processing image img_sb_50_7 |==============================     | 85% 00:00:08 
```

<img src="/tutorials/pliman_lca/03_analyze_objects_files/figure-html/unnamed-chunk-16-11.png" width="672" />

```
## Processing image img_sb_50_8 |================================   | 92% 00:00:09 
```

<img src="/tutorials/pliman_lca/03_analyze_objects_files/figure-html/unnamed-chunk-16-12.png" width="672" />

```
## Processing image img_sb_50_9 |===================================| 100% 00:00:10 
```

```
## --------------------------------------------
##         Image Objects
##   img_sb_50_1     100
##  img_sb_50_10      29
##  img_sb_50_11      23
##  img_sb_50_12      15
##  img_sb_50_13       7
##   img_sb_50_2      90
##   img_sb_50_3      83
##   img_sb_50_4      75
##   img_sb_50_5      70
##   img_sb_50_6      60
##   img_sb_50_7      57
##   img_sb_50_8      48
##   img_sb_50_9      36
## --------------------------------------------
```

```
## Done!
```

<img src="/tutorials/pliman_lca/03_analyze_objects_files/figure-html/unnamed-chunk-16-13.png" width="672" />

```
##   usuário   sistema decorrido 
##     11.01      0.63     11.74
```

```r
# procesamento paralelo
# três múltiplas seções
system.time(
  list_res <- 
    analyze_objects(pattern = "img_sb",
                    show_image = FALSE,
                    parallel = TRUE,
                    workers = 3)
)
```

```
## Image processing using multiple sessions (3). Please wait.
```

```
## --------------------------------------------
##         Image Objects
##   img_sb_50_1     100
##  img_sb_50_10      29
##  img_sb_50_11      23
##  img_sb_50_12      15
##  img_sb_50_13       7
##   img_sb_50_2      90
##   img_sb_50_3      83
##   img_sb_50_4      75
##   img_sb_50_5      70
##   img_sb_50_6      60
##   img_sb_50_7      57
##   img_sb_50_8      48
##   img_sb_50_9      36
## --------------------------------------------
```

```
## Done!
```

```
##   usuário   sistema decorrido 
##      0.03      0.02      3.44
```

```r
list_res$count %>% print_tbl()
```



|   |Image        | Objects|
|:--|:------------|-------:|
|1  |img_sb_50_1  |     100|
|7  |img_sb_50_10 |      29|
|13 |img_sb_50_11 |      23|
|19 |img_sb_50_12 |      15|
|25 |img_sb_50_13 |       7|
|31 |img_sb_50_2  |      90|
|37 |img_sb_50_3  |      83|
|43 |img_sb_50_4  |      75|
|49 |img_sb_50_5  |      70|
|55 |img_sb_50_6  |      60|
|61 |img_sb_50_7  |      57|
|67 |img_sb_50_8  |      48|
|73 |img_sb_50_9  |      36|

```r
list_res$results %>% print_tbl()
```



|     |img          |  id|       x|       y| area| area_ch| perimeter| radius_mean| radius_min| radius_max| radius_sd| radius_ratio| diam_mean| diam_min| diam_max| major_axis| minor_axis| eccentricity|  theta| solidity| circularity|
|:----|:------------|---:|-------:|-------:|----:|-------:|---------:|-----------:|----------:|----------:|---------:|------------:|---------:|--------:|--------:|----------:|----------:|------------:|------:|--------:|-----------:|
|1    |img_sb_50_1  |   1| 518.854| 260.189|  185|     171|        44|       7.197|      5.645|      8.276|     0.644|        1.466|    14.393|   11.289|   16.553|     16.777|     14.083|        0.543|  0.874|    1.082|       1.201|
|2    |img_sb_50_1  |   2| 468.818| 398.552|  192|     175|        43|       7.357|      6.306|      8.202|     0.415|        1.301|    14.715|   12.612|   16.404|     16.288|     15.046|        0.383|  1.105|    1.097|       1.305|
|3    |img_sb_50_1  |   3| 332.133| 442.092|  173|     160|        42|       6.969|      6.169|      7.854|     0.370|        1.273|    13.938|   12.338|   15.707|     15.059|     14.694|        0.219| -0.425|    1.081|       1.232|
|4    |img_sb_50_1  |   4| 242.217| 269.533|  184|     168|        42|       7.230|      6.163|      8.288|     0.540|        1.345|    14.460|   12.326|   16.577|     16.748|     13.979|        0.551|  1.074|    1.095|       1.311|
|5    |img_sb_50_1  |   5| 365.399| 453.936|  188|     171|        42|       7.310|      6.243|      8.210|     0.481|        1.315|    14.621|   12.485|   16.419|     16.734|     14.297|        0.520| -0.659|    1.099|       1.339|
|6    |img_sb_50_1  |   6| 540.210| 199.448|  181|     167|        44|       7.138|      6.252|      8.087|     0.463|        1.294|    14.276|   12.504|   16.175|     15.695|     14.813|        0.330|  0.806|    1.084|       1.175|
|7    |img_sb_50_1  |   7| 277.933| 445.438|  178|     165|        42|       7.073|      6.043|      8.091|     0.498|        1.339|    14.146|   12.085|   16.182|     16.134|     14.085|        0.488| -1.567|    1.079|       1.268|
|8    |img_sb_50_1  |   8| 380.578| 352.896|  173|     159|        40|       6.979|      6.464|      7.585|     0.308|        1.173|    13.957|   12.927|   15.169|     15.260|     14.439|        0.324| -0.816|    1.088|       1.359|
|9    |img_sb_50_1  |   9| 572.404| 331.739|  161|     143|        39|       6.701|      6.199|      7.209|     0.269|        1.163|    13.402|   12.399|   14.418|     14.480|     14.147|        0.213| -0.182|    1.126|       1.330|
|10   |img_sb_50_1  |  10| 267.431| 454.684|  174|     160|        42|       6.997|      6.090|      8.231|     0.533|        1.352|    13.994|   12.180|   16.463|     16.179|     13.729|        0.529|  1.196|    1.087|       1.240|
|11   |img_sb_50_1  |  11| 430.621| 144.595|  190|     170|        43|       7.312|      6.263|      8.343|     0.536|        1.332|    14.623|   12.526|   16.685|     16.837|     14.370|        0.521| -1.400|    1.118|       1.291|
|12   |img_sb_50_1  |  12| 483.341| 392.347|  173|     158|        42|       6.964|      5.422|      8.450|     0.835|        1.558|    13.929|   10.843|   16.899|     17.047|     12.974|        0.649| -0.084|    1.095|       1.232|
|13   |img_sb_50_1  |  13| 336.733| 429.159|  176|     159|        41|       7.036|      6.058|      8.037|     0.506|        1.327|    14.073|   12.115|   16.075|     16.114|     13.934|        0.502|  0.073|    1.107|       1.316|
|14   |img_sb_50_1  |  14| 556.317| 259.130|  161|     144|        38|       6.711|      5.975|      7.672|     0.392|        1.284|    13.422|   11.951|   15.345|     14.786|     13.904|        0.340| -0.209|    1.118|       1.401|
|15   |img_sb_50_1  |  15| 259.945| 387.528|  163|     146|        39|       6.756|      5.967|      7.463|     0.339|        1.251|    13.512|   11.933|   14.927|     14.564|     14.276|        0.198| -1.509|    1.116|       1.347|
|16   |img_sb_50_1  |  16| 321.862| 194.299|  174|     157|        40|       7.001|      5.953|      7.980|     0.542|        1.341|    14.003|   11.906|   15.961|     16.173|     13.706|        0.531|  1.304|    1.108|       1.367|
|17   |img_sb_50_1  |  17| 202.888| 425.828|  169|     152|        40|       6.878|      6.100|      7.610|     0.367|        1.248|    13.755|   12.200|   15.220|     15.273|     14.097|        0.385| -0.174|    1.112|       1.327|
|18   |img_sb_50_1  |  18| 319.110| 361.797|  172|     153|        40|       6.943|      6.125|      7.620|     0.383|        1.244|    13.887|   12.250|   15.240|     15.442|     14.193|        0.394| -0.205|    1.124|       1.351|
|19   |img_sb_50_1  |  19| 525.106| 392.021|  188|     170|        42|       7.293|      6.005|      8.525|     0.708|        1.420|    14.585|   12.009|   17.050|     17.335|     13.816|        0.604| -1.387|    1.106|       1.339|
|20   |img_sb_50_1  |  20| 242.536| 420.168|  179|     162|        42|       7.090|      6.431|      8.126|     0.454|        1.263|    14.180|   12.863|   16.251|     16.101|     14.154|        0.477| -1.101|    1.105|       1.275|
|21   |img_sb_50_1  |  21| 603.765| 244.306|  170|     156|        41|       6.898|      5.979|      7.728|     0.462|        1.293|    13.796|   11.957|   15.456|     15.617|     13.908|        0.455| -0.155|    1.090|       1.271|
|22   |img_sb_50_1  |  22| 594.873| 314.006|  158|     142|        38|       6.652|      5.663|      7.610|     0.438|        1.344|    13.303|   11.325|   15.219|     14.929|     13.507|        0.426|  0.091|    1.113|       1.375|
|23   |img_sb_50_1  |  23| 354.018| 195.904|  167|     149|        39|       6.865|      5.951|      7.777|     0.476|        1.307|    13.731|   11.901|   15.555|     15.665|     13.578|        0.499|  0.425|    1.121|       1.380|
|24   |img_sb_50_1  |  24| 401.551| 109.814|  167|     151|        40|       6.844|      6.123|      7.565|     0.312|        1.236|    13.688|   12.245|   15.131|     14.978|     14.201|        0.318|  1.145|    1.106|       1.312|
|25   |img_sb_50_1  |  25| 646.922| 409.550|  180|     163|        42|       7.107|      6.476|      7.993|     0.387|        1.234|    14.213|   12.952|   15.987|     15.890|     14.425|        0.419|  0.106|    1.104|       1.282|
|26   |img_sb_50_1  |  26| 159.551| 279.431|  167|     149|        39|       6.854|      5.974|      7.815|     0.453|        1.308|    13.707|   11.949|   15.631|     15.634|     13.609|        0.492| -0.858|    1.121|       1.380|
|27   |img_sb_50_1  |  27| 407.041| 191.858|  169|     152|        40|       6.874|      6.075|      7.563|     0.380|        1.245|    13.748|   12.150|   15.127|     15.378|     13.991|        0.415| -0.161|    1.112|       1.327|
|28   |img_sb_50_1  |  28| 439.434| 209.823|  175|     156|        41|       7.009|      6.197|      8.094|     0.537|        1.306|    14.019|   12.395|   16.187|     16.290|     13.678|        0.543|  0.929|    1.122|       1.308|
|29   |img_sb_50_1  |  29| 379.739| 212.596|  161|     143|        39|       6.711|      5.783|      7.688|     0.483|        1.329|    13.423|   11.566|   15.376|     15.505|     13.221|        0.522|  0.785|    1.126|       1.330|
|30   |img_sb_50_1  |  30| 598.226| 232.232|  164|     149|        40|       6.767|      5.687|      7.533|     0.467|        1.325|    13.533|   11.375|   15.066|     15.392|     13.591|        0.469| -0.310|    1.101|       1.288|
|31   |img_sb_50_1  |  31| 626.960| 298.980|  150|     136|        38|       6.444|      5.817|      7.233|     0.431|        1.243|    12.888|   11.635|   14.466|     14.712|     12.997|        0.469| -0.646|    1.103|       1.305|
|32   |img_sb_50_1  |  32| 508.500| 416.500|  174|     157|        40|       7.028|      6.042|      7.906|     0.551|        1.309|    14.057|   12.083|   15.811|     16.441|     13.450|        0.575|  1.085|    1.108|       1.367|
|33   |img_sb_50_1  |  33| 590.280| 326.509|  175|     161|        41|       7.014|      5.561|      7.860|     0.523|        1.413|    14.027|   11.122|   15.720|     15.850|     14.154|        0.450|  0.069|    1.087|       1.308|
|34   |img_sb_50_1  |  34| 438.880| 179.455|  167|     151|        40|       6.845|      5.971|      7.560|     0.408|        1.266|    13.690|   11.942|   15.120|     15.525|     13.695|        0.471| -0.524|    1.106|       1.312|
|35   |img_sb_50_1  |  35| 367.825| 246.480|  171|     152|        40|       6.932|      5.747|      7.980|     0.666|        1.389|    13.865|   11.494|   15.959|     16.504|     13.186|        0.601|  1.551|    1.125|       1.343|
|36   |img_sb_50_1  |  36| 537.835| 479.268|  164|     149|        40|       6.764|      5.981|      7.542|     0.390|        1.261|    13.527|   11.963|   15.083|     15.015|     13.933|        0.373|  1.355|    1.101|       1.288|
|37   |img_sb_50_1  |  37| 321.719| 345.671|  167|     153|        40|       6.849|      6.018|      7.695|     0.446|        1.279|    13.699|   12.035|   15.390|     15.548|     13.695|        0.473| -0.762|    1.092|       1.312|
|38   |img_sb_50_1  |  38| 405.922| 453.608|  153|     134|        37|       6.531|      5.874|      7.264|     0.347|        1.237|    13.061|   11.748|   14.529|     14.624|     13.304|        0.415|  1.243|    1.142|       1.404|
|39   |img_sb_50_1  |  39| 406.908| 276.532|  173|     154|        41|       6.972|      5.696|      8.244|     0.706|        1.447|    13.945|   11.393|   16.488|     16.704|     13.195|        0.613|  1.269|    1.123|       1.293|
|40   |img_sb_50_1  |  40| 454.776| 504.782|  165|     147|        39|       6.795|      5.799|      7.810|     0.521|        1.347|    13.590|   11.599|   15.620|     15.707|     13.381|        0.524| -0.117|    1.122|       1.363|
|41   |img_sb_50_1  |  41| 655.547| 247.604|  159|     141|        38|       6.671|      6.040|      7.334|     0.313|        1.214|    13.342|   12.079|   14.669|     14.913|     13.546|        0.418|  0.830|    1.128|       1.384|
|42   |img_sb_50_1  |  42| 445.582| 415.582|  158|     141|        38|       6.649|      5.711|      7.311|     0.348|        1.280|    13.299|   11.421|   14.622|     14.955|     13.434|        0.439|  0.849|    1.121|       1.375|
|43   |img_sb_50_1  |  43| 386.166| 463.310|  145|     130|        37|       6.335|      5.704|      6.905|     0.327|        1.210|    12.671|   11.409|   13.810|     14.091|     13.102|        0.368|  1.079|    1.115|       1.331|
|44   |img_sb_50_1  |  44| 491.178| 263.497|  169|     152|        40|       6.890|      6.071|      7.759|     0.382|        1.278|    13.780|   12.142|   15.518|     15.507|     13.867|        0.448|  0.437|    1.112|       1.327|
|45   |img_sb_50_1  |  45| 412.820| 250.713|  167|     150|        39|       6.841|      5.993|      7.546|     0.356|        1.259|    13.682|   11.986|   15.092|     15.297|     13.886|        0.419| -0.382|    1.113|       1.380|
|46   |img_sb_50_1  |  46| 652.087| 381.134|  172|     157|        41|       6.955|      5.909|      7.969|     0.543|        1.349|    13.911|   11.817|   15.937|     16.194|     13.532|        0.549| -0.996|    1.096|       1.286|
|47   |img_sb_50_1  |  47| 394.188| 265.039|  181|     162|        41|       7.183|      5.824|      8.356|     0.679|        1.435|    14.366|   11.649|   16.712|     17.155|     13.426|        0.622|  0.770|    1.117|       1.353|
|48   |img_sb_50_1  |  48| 698.038| 376.981|  156|     139|        38|       6.602|      5.854|      7.287|     0.412|        1.245|    13.205|   11.707|   14.575|     15.081|     13.147|        0.490|  1.285|    1.122|       1.358|
|49   |img_sb_50_1  |  49| 424.361| 356.213|  155|     138|        37|       6.584|      5.996|      7.107|     0.277|        1.185|    13.169|   11.991|   14.215|     14.353|     13.744|        0.288|  0.633|    1.123|       1.423|
|50   |img_sb_50_1  |  50| 616.518| 423.287|  164|     148|        39|       6.786|      5.660|      7.652|     0.473|        1.352|    13.572|   11.320|   15.303|     15.626|     13.353|        0.519| -0.936|    1.108|       1.355|
|51   |img_sb_50_1  |  51| 222.940| 310.042|  167|     151|        40|       6.862|      5.865|      8.072|     0.603|        1.376|    13.724|   11.731|   16.143|     16.172|     13.162|        0.581|  1.134|    1.106|       1.312|
|52   |img_sb_50_1  |  52| 542.125| 465.737|  152|     137|        38|       6.507|      5.810|      7.474|     0.441|        1.286|    13.014|   11.620|   14.948|     14.864|     13.024|        0.482| -1.221|    1.109|       1.323|
|53   |img_sb_50_1  |  53| 164.047| 361.537|  149|     132|        37|       6.439|      5.464|      7.236|     0.382|        1.324|    12.878|   10.927|   14.473|     14.570|     13.004|        0.451|  1.182|    1.129|       1.368|
|54   |img_sb_50_1  |  54| 249.529| 191.904|  157|     141|        37|       6.649|      5.709|      7.338|     0.416|        1.285|    13.297|   11.419|   14.675|     14.990|     13.353|        0.454| -1.146|    1.113|       1.441|
|55   |img_sb_50_1  |  55| 508.466| 377.993|  148|     133|        38|       6.399|      5.902|      6.973|     0.307|        1.181|    12.797|   11.804|   13.946|     14.062|     13.407|        0.302| -0.275|    1.113|       1.288|
|56   |img_sb_50_1  |  56| 271.894| 392.919|  160|     144|        39|       6.691|      5.620|      7.699|     0.505|        1.370|    13.383|   11.240|   15.398|     15.479|     13.180|        0.524| -1.179|    1.111|       1.322|
|57   |img_sb_50_1  |  57| 571.385| 399.609|  156|     139|        38|       6.603|      5.766|      7.404|     0.401|        1.284|    13.206|   11.531|   14.808|     15.034|     13.198|        0.479|  0.922|    1.122|       1.358|
|58   |img_sb_50_1  |  58| 623.553| 254.100|  150|     134|        37|       6.468|      5.501|      7.283|     0.393|        1.324|    12.935|   11.002|   14.566|     14.609|     13.071|        0.447|  0.432|    1.119|       1.377|
|59   |img_sb_50_1  |  59| 625.159| 163.152|  151|     136|        38|       6.480|      5.658|      7.321|     0.454|        1.294|    12.960|   11.316|   14.641|     14.831|     12.987|        0.483|  0.572|    1.110|       1.314|
|60   |img_sb_50_1  |  60| 318.145| 444.661|  165|     152|        40|       6.824|      5.638|      7.940|     0.569|        1.408|    13.647|   11.276|   15.879|     15.699|     13.501|        0.510|  1.369|    1.086|       1.296|
|61   |img_sb_50_1  |  61| 431.371| 248.285|  151|     134|        38|       6.480|      5.674|      7.390|     0.408|        1.303|    12.959|   11.347|   14.780|     14.684|     13.106|        0.451| -0.416|    1.127|       1.314|
|62   |img_sb_50_1  |  62| 556.580| 290.840|  169|     154|        40|       6.887|      5.653|      8.075|     0.579|        1.428|    13.774|   11.306|   16.150|     16.142|     13.333|        0.564|  1.151|    1.097|       1.327|
|63   |img_sb_50_1  |  63| 483.217| 379.573|  143|     130|        38|       6.301|      5.170|      7.167|     0.503|        1.386|    12.601|   10.341|   14.334|     14.082|     13.054|        0.375| -1.321|    1.100|       1.244|
|64   |img_sb_50_1  |  64| 486.514| 280.408|  179|     169|        43|       7.132|      5.522|      9.017|     0.753|        1.633|    14.265|   11.044|   18.034|     16.814|     13.698|        0.580|  0.076|    1.059|       1.217|
|65   |img_sb_50_1  |  65| 296.825| 255.867|  143|     127|        36|       6.314|      5.525|      7.128|     0.434|        1.290|    12.628|   11.051|   14.256|     14.463|     12.603|        0.490|  1.056|    1.126|       1.387|
|66   |img_sb_50_1  |  66| 636.210| 325.287|  157|     141|        39|       6.617|      5.697|      7.478|     0.474|        1.313|    13.234|   11.393|   14.955|     15.224|     13.139|        0.505|  1.565|    1.113|       1.297|
|67   |img_sb_50_1  |  67| 217.432| 342.594|  155|     139|        38|       6.572|      5.578|      7.384|     0.441|        1.324|    13.145|   11.155|   14.769|     15.049|     13.112|        0.491|  0.553|    1.115|       1.349|
|68   |img_sb_50_1  |  68| 663.909| 351.487|  154|     138|        38|       6.575|      5.835|      7.542|     0.471|        1.293|    13.151|   11.669|   15.084|     15.232|     12.869|        0.535|  0.821|    1.116|       1.340|
|69   |img_sb_50_1  |  69| 542.503| 185.212|  165|     150|        40|       6.786|      5.958|      7.526|     0.416|        1.263|    13.573|   11.916|   15.053|     15.217|     13.831|        0.417|  1.536|    1.100|       1.296|
|70   |img_sb_50_1  |  70| 266.048| 539.386|  145|     128|        36|       6.358|      5.591|      7.097|     0.363|        1.269|    12.715|   11.181|   14.194|     14.457|     12.740|        0.473| -1.098|    1.133|       1.406|
|71   |img_sb_50_1  |  71| 586.460| 390.710|  176|     159|        41|       7.055|      5.858|      8.137|     0.613|        1.389|    14.110|   11.715|   16.274|     16.557|     13.553|        0.574|  1.356|    1.107|       1.316|
|72   |img_sb_50_1  |  72| 245.448| 434.000|  154|     141|        39|       6.547|      5.790|      7.328|     0.397|        1.266|    13.093|   11.580|   14.656|     14.638|     13.429|        0.398| -1.017|    1.092|       1.272|
|73   |img_sb_50_1  |  73| 294.163| 386.135|  141|     125|        37|       6.232|      5.657|      6.784|     0.284|        1.199|    12.464|   11.314|   13.569|     13.479|     13.316|        0.155|  1.302|    1.128|       1.294|
|74   |img_sb_50_1  |  74| 472.383| 275.025|  162|     155|        43|       6.675|      4.453|      7.712|     0.769|        1.732|    13.351|    8.905|   15.424|     15.067|     13.968|        0.375| -1.247|    1.045|       1.101|
|75   |img_sb_50_1  |  75| 526.219| 200.212|  137|     124|        36|       6.173|      5.168|      7.109|     0.464|        1.376|    12.346|   10.335|   14.218|     13.904|     12.645|        0.416| -0.351|    1.105|       1.328|
|76   |img_sb_50_1  |  76| 593.594| 439.993|  138|     124|        36|       6.186|      5.566|      6.764|     0.304|        1.215|    12.372|   11.131|   13.528|     13.723|     12.804|        0.360| -0.558|    1.113|       1.338|
|77   |img_sb_50_1  |  77| 361.642| 416.534|  148|     133|        36|       6.427|      5.750|      6.897|     0.271|        1.199|    12.854|   11.500|   13.793|     13.864|     13.592|        0.197| -0.010|    1.113|       1.435|
|78   |img_sb_50_1  |  78| 373.833| 153.128|  156|     140|        39|       6.593|      5.506|      7.535|     0.592|        1.369|    13.185|   11.012|   15.070|     15.592|     12.749|        0.576|  1.536|    1.114|       1.289|
|79   |img_sb_50_1  |  79| 501.306| 332.810|  147|     133|        37|       6.398|      5.689|      7.249|     0.430|        1.274|    12.797|   11.378|   14.499|     14.687|     12.744|        0.497|  0.764|    1.105|       1.349|
|80   |img_sb_50_1  |  80| 579.772| 280.792|  149|     132|        38|       6.461|      5.626|      7.520|     0.539|        1.337|    12.922|   11.252|   15.039|     15.150|     12.535|        0.562|  0.562|    1.129|       1.297|
|81   |img_sb_50_1  |  81| 273.103| 477.314|  156|     142|        38|       6.593|      5.685|      7.349|     0.428|        1.293|    13.187|   11.370|   14.697|     14.948|     13.295|        0.457|  0.068|    1.099|       1.358|
|82   |img_sb_50_1  |  82| 226.161| 455.884|  155|     141|        38|       6.583|      5.131|      7.951|     0.581|        1.550|    13.166|   10.262|   15.903|     15.485|     12.755|        0.567| -0.233|    1.099|       1.349|
|83   |img_sb_50_1  |  83| 301.154| 359.734|  143|     128|        37|       6.291|      5.320|      7.035|     0.425|        1.322|    12.582|   10.639|   14.069|     14.423|     12.628|        0.483| -1.172|    1.117|       1.313|
|84   |img_sb_50_1  |  84| 605.594| 408.706|  143|     128|        37|       6.305|      5.412|      7.178|     0.475|        1.326|    12.611|   10.823|   14.357|     14.637|     12.450|        0.526| -0.623|    1.117|       1.313|
|85   |img_sb_50_1  |  85| 640.186| 217.559|  145|     128|        36|       6.357|      5.319|      7.088|     0.393|        1.333|    12.715|   10.638|   14.175|     14.471|     12.745|        0.474|  1.221|    1.133|       1.406|
|86   |img_sb_50_1  |  86| 486.826| 355.604|  144|     128|        36|       6.331|      5.311|      7.062|     0.392|        1.330|    12.662|   10.623|   14.125|     14.406|     12.716|        0.470| -1.168|    1.125|       1.396|
|87   |img_sb_50_1  |  87| 547.449| 269.776|  156|     141|        39|       6.593|      5.363|      7.966|     0.643|        1.485|    13.186|   10.726|   15.931|     15.678|     12.710|        0.585|  1.489|    1.106|       1.289|
|88   |img_sb_50_1  |  88| 448.167| 125.710|  138|     123|        35|       6.193|      5.314|      7.066|     0.428|        1.330|    12.386|   10.627|   14.131|     14.219|     12.360|        0.494|  1.314|    1.122|       1.416|
|89   |img_sb_50_1  |  89| 615.741| 377.636|  143|     128|        37|       6.292|      5.258|      7.096|     0.470|        1.349|    12.584|   10.516|   14.192|     14.551|     12.525|        0.509|  1.448|    1.117|       1.313|
|90   |img_sb_50_1  |  90| 662.882| 423.681|  144|     131|        37|       6.312|      5.359|      7.305|     0.501|        1.363|    12.624|   10.718|   14.611|     14.697|     12.482|        0.528|  0.208|    1.099|       1.322|
|91   |img_sb_50_1  |  91| 578.713| 500.515|  136|     120|        36|       6.123|      5.257|      6.889|     0.460|        1.311|    12.246|   10.513|   13.779|     14.220|     12.170|        0.517|  1.492|    1.133|       1.319|
|92   |img_sb_50_1  |  92| 307.914| 510.129|  140|     122|        37|       6.215|      4.869|      7.500|     0.784|        1.540|    12.430|    9.737|   14.999|     15.499|     11.498|        0.671| -1.424|    1.148|       1.285|
|93   |img_sb_50_1  |  93| 379.683| 476.462|  145|     126|        37|       6.328|      5.387|      7.197|     0.492|        1.336|    12.655|   10.773|   14.394|     14.692|     12.567|        0.518| -0.209|    1.151|       1.331|
|94   |img_sb_50_1  |  94| 604.354| 304.605|  147|     134|        38|       6.379|      5.439|      7.582|     0.519|        1.394|    12.759|   10.879|   15.163|     14.760|     12.732|        0.506|  1.403|    1.097|       1.279|
|95   |img_sb_50_1  |  95| 580.236| 254.386|  140|     123|        37|       6.211|      5.252|      7.083|     0.501|        1.349|    12.422|   10.503|   14.167|     14.508|     12.295|        0.531|  1.334|    1.138|       1.285|
|96   |img_sb_50_1  |  96| 518.315| 163.108|  130|     113|        35|       5.986|      5.152|      6.980|     0.467|        1.355|    11.972|   10.305|   13.960|     14.001|     11.824|        0.536|  0.960|    1.150|       1.334|
|97   |img_sb_50_1  |  97| 529.924| 253.689|  132|     118|        36|       6.050|      5.195|      7.019|     0.435|        1.351|    12.101|   10.389|   14.037|     13.705|     12.378|        0.429|  0.256|    1.119|       1.280|
|98   |img_sb_50_1  |  98| 339.597| 372.306|  124|     111|        34|       5.829|      5.195|      6.561|     0.351|        1.263|    11.658|   10.390|   13.122|     13.084|     12.072|        0.386| -0.070|    1.117|       1.348|
|99   |img_sb_50_1  |  99| 666.597| 409.479|  119|     103|        33|       5.698|      4.699|      6.322|     0.337|        1.345|    11.396|    9.399|   12.643|     12.799|     11.836|        0.381| -0.508|    1.155|       1.373|
|100  |img_sb_50_1  | 100| 235.317| 238.267|  101|      86|        31|       5.205|      4.298|      5.915|     0.458|        1.376|    10.410|    8.596|   11.830|     12.367|     10.396|        0.542| -1.429|    1.174|       1.321|
|110  |img_sb_50_10 |   1| 481.635| 166.295|  342|     318|        58|       9.983|      8.632|     11.329|     0.716|        1.312|    19.966|   17.265|   22.658|     22.738|     19.153|        0.539| -0.114|    1.075|       1.278|
|210  |img_sb_50_10 |   2| 368.095| 271.675|  326|     303|        55|       9.747|      8.678|     10.943|     0.587|        1.261|    19.494|   17.355|   21.887|     21.858|     18.984|        0.496|  1.402|    1.076|       1.354|
|310  |img_sb_50_10 |   3| 602.070| 234.720|  328|     311|        57|       9.786|      8.517|     11.128|     0.742|        1.307|    19.573|   17.034|   22.256|     22.491|     18.584|        0.563| -0.816|    1.055|       1.269|
|410  |img_sb_50_10 |   4| 539.772| 402.109|  311|     291|        55|       9.493|      8.482|     10.304|     0.451|        1.215|    18.987|   16.964|   20.609|     20.897|     18.951|        0.421|  0.268|    1.069|       1.292|
|510  |img_sb_50_10 |   5| 385.630| 216.891|  330|     309|        57|       9.805|      8.475|     10.992|     0.667|        1.297|    19.611|   16.951|   21.983|     22.263|     18.873|        0.530| -0.289|    1.068|       1.276|
|610  |img_sb_50_10 |   6| 320.919| 337.934|  335|     316|        56|       9.900|      8.600|     11.188|     0.719|        1.301|    19.801|   17.201|   22.377|     22.624|     18.859|        0.552| -1.100|    1.060|       1.342|
|710  |img_sb_50_10 |   7| 620.153| 365.713|  300|     278|        53|       9.328|      8.494|     10.290|     0.443|        1.211|    18.656|   16.988|   20.580|     20.417|     18.720|        0.399|  0.365|    1.079|       1.342|
|810  |img_sb_50_10 |   8| 341.706| 423.529|  323|     301|        55|       9.707|      8.423|     11.034|     0.740|        1.310|    19.413|   16.845|   22.067|     22.240|     18.505|        0.555| -0.337|    1.073|       1.342|
|910  |img_sb_50_10 |   9| 246.751| 428.617|  313|     293|        55|       9.539|      8.418|     10.766|     0.544|        1.279|    19.077|   16.836|   21.532|     21.362|     18.663|        0.487|  0.951|    1.068|       1.300|
|101  |img_sb_50_10 |  10| 336.607| 242.065|  336|     315|        57|       9.924|      8.604|     11.359|     0.722|        1.320|    19.848|   17.208|   22.718|     22.703|     18.851|        0.557|  0.851|    1.067|       1.300|
|111  |img_sb_50_10 |  11| 317.081| 450.981|  308|     288|        55|       9.478|      8.293|     10.743|     0.682|        1.295|    18.957|   16.585|   21.485|     21.711|     18.066|        0.555|  0.657|    1.069|       1.279|
|121  |img_sb_50_10 |  12| 543.349| 461.603|  315|     296|        56|       9.574|      8.379|     11.006|     0.756|        1.314|    19.148|   16.758|   22.013|     22.081|     18.181|        0.567|  0.451|    1.064|       1.262|
|131  |img_sb_50_10 |  13| 491.601| 396.805|  308|     292|        55|       9.457|      8.362|     10.439|     0.554|        1.248|    18.914|   16.724|   20.879|     21.159|     18.547|        0.481|  1.170|    1.055|       1.279|
|141  |img_sb_50_10 |  14| 313.568| 244.007|  296|     276|        53|       9.259|      8.000|      9.944|     0.432|        1.243|    18.517|   16.000|   19.888|     20.336|     18.533|        0.412| -0.435|    1.072|       1.324|
|151  |img_sb_50_10 |  15| 433.894| 159.541|  331|     310|        58|       9.804|      8.483|     11.079|     0.786|        1.306|    19.607|   16.966|   22.159|     22.618|     18.646|        0.566|  0.084|    1.068|       1.236|
|161  |img_sb_50_10 |  16| 453.532| 429.997|  333|     309|        57|       9.844|      8.404|     11.380|     0.863|        1.354|    19.688|   16.809|   22.759|     22.921|     18.498|        0.591|  1.486|    1.078|       1.288|
|171  |img_sb_50_10 |  17| 410.401| 131.124|  299|     277|        53|       9.311|      8.315|     10.478|     0.596|        1.260|    18.622|   16.630|   20.957|     21.000|     18.128|        0.505|  1.409|    1.079|       1.338|
|181  |img_sb_50_10 |  18| 538.691| 378.451|  288|     271|        53|       9.165|      7.804|     10.393|     0.644|        1.332|    18.330|   15.609|   20.787|     20.807|     17.667|        0.528| -0.830|    1.063|       1.288|
|191  |img_sb_50_10 |  19| 334.759| 485.528|  299|     278|        54|       9.310|      8.256|     10.473|     0.629|        1.268|    18.620|   16.513|   20.946|     21.164|     17.982|        0.527|  0.265|    1.076|       1.289|
|201  |img_sb_50_10 |  20| 423.583| 300.557|  271|     250|        50|       8.845|      7.925|      9.652|     0.385|        1.218|    17.689|   15.850|   19.304|     19.335|     17.854|        0.384| -0.424|    1.084|       1.362|
|211  |img_sb_50_10 |  21| 593.616| 345.737|  281|     261|        52|       9.022|      8.125|     10.209|     0.544|        1.256|    18.044|   16.251|   20.417|     20.214|     17.721|        0.481| -1.228|    1.077|       1.306|
|221  |img_sb_50_10 |  22| 638.620| 263.075|  295|     275|        53|       9.255|      8.104|     10.174|     0.490|        1.255|    18.511|   16.209|   20.348|     20.562|     18.265|        0.459| -0.506|    1.073|       1.320|
|231  |img_sb_50_10 |  23| 546.382| 322.818|  285|     266|        53|       9.067|      7.804|     10.308|     0.616|        1.321|    18.135|   15.607|   20.616|     20.539|     17.673|        0.509|  0.130|    1.071|       1.275|
|241  |img_sb_50_10 |  24| 276.003| 423.855|  290|     269|        53|       9.158|      8.096|     10.204|     0.511|        1.260|    18.316|   16.193|   20.408|     20.462|     18.051|        0.471|  0.924|    1.078|       1.297|
|251  |img_sb_50_10 |  25| 243.083| 240.428|  278|     257|        52|       8.950|      8.138|      9.757|     0.343|        1.199|    17.901|   16.277|   19.514|     19.403|     18.242|        0.341| -0.344|    1.082|       1.292|
|261  |img_sb_50_10 |  26| 500.330| 249.126|  270|     252|        52|       8.815|      7.596|     10.002|     0.577|        1.317|    17.629|   15.192|   20.005|     19.918|     17.280|        0.497| -1.302|    1.071|       1.255|
|271  |img_sb_50_10 |  27| 475.000| 221.201|  284|     262|        52|       9.109|      7.790|     10.403|     0.726|        1.335|    18.219|   15.580|   20.806|     21.139|     17.099|        0.588| -0.812|    1.084|       1.320|
|281  |img_sb_50_10 |  28| 281.949| 251.724|  254|     235|        49|       8.545|      7.494|      9.439|     0.500|        1.260|    17.090|   14.988|   18.878|     19.196|     16.838|        0.480|  0.229|    1.081|       1.329|
|291  |img_sb_50_10 |  29| 463.269| 398.043|  208|     188|        44|       7.689|      6.659|      8.776|     0.509|        1.318|    15.379|   13.318|   17.553|     17.497|     15.134|        0.502|  1.234|    1.106|       1.350|
|112  |img_sb_50_11 |   1| 341.749| 370.467|  291|     269|        53|       9.172|      8.087|     10.179|     0.512|        1.259|    18.344|   16.175|   20.358|     20.470|     18.097|        0.467| -1.455|    1.082|       1.302|
|212  |img_sb_50_11 |   2| 583.324| 376.643|  272|     252|        51|       8.848|      8.174|      9.519|     0.343|        1.165|    17.696|   16.347|   19.038|     19.164|     18.073|        0.333|  0.319|    1.079|       1.314|
|311  |img_sb_50_11 |   3| 380.127| 158.567|  275|     253|        51|       8.903|      7.851|      9.885|     0.559|        1.259|    17.806|   15.702|   19.770|     20.069|     17.443|        0.495|  1.422|    1.087|       1.329|
|411  |img_sb_50_11 |   4| 461.458| 322.515|  299|     277|        54|       9.311|      8.244|     10.573|     0.635|        1.282|    18.621|   16.488|   21.145|     21.182|     17.979|        0.529|  1.308|    1.079|       1.289|
|511  |img_sb_50_11 |   5| 403.257| 186.677|  300|     280|        53|       9.361|      8.185|     10.440|     0.652|        1.275|    18.722|   16.371|   20.881|     21.381|     17.867|        0.549| -0.715|    1.071|       1.342|
|611  |img_sb_50_11 |   6| 358.341| 240.483|  296|     274|        54|       9.244|      7.883|     10.445|     0.612|        1.325|    18.488|   15.765|   20.890|     20.940|     18.007|        0.510| -0.307|    1.080|       1.276|
|711  |img_sb_50_11 |   7| 431.780| 389.101|  277|     257|        51|       8.952|      7.957|      9.745|     0.484|        1.225|    17.905|   15.913|   19.491|     19.983|     17.651|        0.469| -0.857|    1.078|       1.338|
|811  |img_sb_50_11 |   8| 463.398| 155.838|  314|     295|        55|       9.580|      8.194|     11.034|     0.834|        1.347|    19.160|   16.389|   22.068|     22.361|     17.884|        0.600|  1.145|    1.064|       1.304|
|911  |img_sb_50_11 |   9| 496.787| 483.361|  291|     269|        53|       9.174|      8.340|     10.288|     0.489|        1.234|    18.347|   16.679|   20.577|     20.299|     18.253|        0.437|  0.128|    1.082|       1.302|
|102  |img_sb_50_11 |  10| 512.596| 469.240|  287|     266|        53|       9.109|      7.934|     10.209|     0.606|        1.287|    18.219|   15.869|   20.418|     20.696|     17.657|        0.522|  0.459|    1.079|       1.284|
|113  |img_sb_50_11 |  11| 257.846| 347.614|  298|     277|        54|       9.299|      8.022|     10.338|     0.674|        1.289|    18.598|   16.044|   20.676|     21.220|     17.883|        0.538|  0.155|    1.076|       1.284|
|122  |img_sb_50_11 |  12| 599.121| 278.951|  265|     243|        50|       8.730|      7.980|      9.786|     0.465|        1.226|    17.461|   15.960|   19.572|     19.467|     17.322|        0.456| -0.361|    1.091|       1.332|
|132  |img_sb_50_11 |  13| 563.908| 253.007|  294|     272|        54|       9.259|      8.014|     10.672|     0.686|        1.332|    18.518|   16.028|   21.344|     21.298|     17.577|        0.565| -0.844|    1.081|       1.267|
|142  |img_sb_50_11 |  14| 506.912| 312.973|  262|     241|        50|       8.683|      7.671|      9.506|     0.472|        1.239|    17.366|   15.342|   19.012|     19.441|     17.140|        0.472|  1.333|    1.087|       1.317|
|152  |img_sb_50_11 |  15| 199.992| 410.783|  254|     235|        50|       8.545|      7.577|      9.392|     0.487|        1.240|    17.090|   15.154|   18.784|     19.186|     16.850|        0.478|  1.181|    1.081|       1.277|
|162  |img_sb_50_11 |  16| 528.665| 232.921|  242|     223|        48|       8.325|      7.501|      9.060|     0.389|        1.208|    16.649|   15.001|   18.121|     18.419|     16.715|        0.420|  0.599|    1.085|       1.320|
|172  |img_sb_50_11 |  17| 227.402| 425.354|  246|     227|        50|       8.392|      7.613|      9.346|     0.472|        1.228|    16.784|   15.225|   18.693|     18.722|     16.759|        0.446| -0.640|    1.084|       1.237|
|182  |img_sb_50_11 |  18| 242.301| 442.634|  246|     228|        48|       8.408|      7.607|      9.203|     0.439|        1.210|    16.815|   15.214|   18.407|     18.691|     16.758|        0.443| -0.717|    1.079|       1.342|
|192  |img_sb_50_11 |  19| 558.028| 358.339|  254|     234|        48|       8.569|      7.432|      9.897|     0.644|        1.332|    17.139|   14.864|   19.793|     19.652|     16.467|        0.546| -1.307|    1.085|       1.385|
|202  |img_sb_50_11 |  20| 248.413| 285.825|  252|     233|        49|       8.514|      6.841|      9.848|     0.687|        1.440|    17.027|   13.682|   19.696|     19.665|     16.339|        0.557| -1.192|    1.082|       1.319|
|213  |img_sb_50_11 |  21| 406.996| 248.102|  255|     235|        50|       8.580|      7.223|     10.132|     0.736|        1.403|    17.159|   14.446|   20.263|     20.070|     16.169|        0.592| -1.093|    1.085|       1.282|
|222  |img_sb_50_11 |  22| 277.607| 453.656|  224|     204|        45|       8.021|      7.147|      9.084|     0.527|        1.271|    16.042|   14.293|   18.168|     18.273|     15.601|        0.521| -1.118|    1.098|       1.390|
|232  |img_sb_50_11 |  23| 538.688| 423.799|  189|     170|        41|       7.319|      6.620|      7.949|     0.337|        1.201|    14.638|   13.240|   15.899|     16.172|     14.869|        0.393|  0.281|    1.112|       1.413|
|114  |img_sb_50_12 |   1| 350.000| 315.000|  269|     245|        50|       8.808|      8.000|      9.849|     0.514|        1.231|    17.615|   16.000|   19.698|     19.810|     17.274|        0.490|  0.254|    1.098|       1.352|
|214  |img_sb_50_12 |   2| 298.207| 249.844|  275|     252|        51|       8.915|      7.691|     10.165|     0.677|        1.322|    17.830|   15.381|   20.329|     20.520|     17.060|        0.556| -0.320|    1.091|       1.329|
|312  |img_sb_50_12 |   3| 504.276| 492.862|  261|     241|        51|       8.656|      7.828|      9.433|     0.443|        1.205|    17.312|   15.655|   18.866|     19.219|     17.293|        0.436|  0.181|    1.083|       1.261|
|412  |img_sb_50_12 |   4| 588.787| 393.885|  244|     225|        49|       8.351|      7.559|      8.966|     0.361|        1.186|    16.701|   15.118|   17.931|     18.283|     16.994|        0.369|  0.488|    1.084|       1.277|
|512  |img_sb_50_12 |   5| 481.329| 181.746|  280|     260|        51|       9.038|      7.597|     10.396|     0.824|        1.368|    18.075|   15.195|   20.792|     21.262|     16.763|        0.615|  1.103|    1.077|       1.353|
|612  |img_sb_50_12 |   6| 606.136| 301.885|  235|     216|        48|       8.193|      7.425|      8.984|     0.383|        1.210|    16.385|   14.850|   17.968|     17.956|     16.675|        0.371| -0.570|    1.088|       1.282|
|712  |img_sb_50_12 |   7| 544.977| 268.158|  266|     245|        50|       8.768|      7.253|     10.345|     0.755|        1.426|    17.536|   14.507|   20.689|     20.438|     16.581|        0.585| -1.371|    1.086|       1.337|
|812  |img_sb_50_12 |   8| 519.352| 479.850|  253|     231|        49|       8.525|      7.564|      9.657|     0.525|        1.277|    17.049|   15.128|   19.314|     19.273|     16.713|        0.498|  0.571|    1.095|       1.324|
|912  |img_sb_50_12 |   9| 231.411| 437.163|  258|     237|        50|       8.607|      7.441|     10.004|     0.726|        1.345|    17.215|   14.881|   20.008|     20.053|     16.378|        0.577| -1.548|    1.089|       1.297|
|103  |img_sb_50_12 |  10| 419.132| 315.987|  228|     207|        48|       8.042|      6.980|      8.975|     0.579|        1.286|    16.085|   13.959|   17.950|     18.338|     15.866|        0.501|  0.056|    1.101|       1.244|
|115  |img_sb_50_12 |  11| 330.686| 352.178|  242|     221|        47|       8.334|      7.301|      9.369|     0.528|        1.283|    16.668|   14.602|   18.737|     18.794|     16.398|        0.489|  1.462|    1.095|       1.377|
|123  |img_sb_50_12 |  12| 395.478| 273.839|  224|     205|        47|       7.984|      7.127|      8.935|     0.409|        1.254|    15.968|   14.254|   17.870|     17.759|     16.060|        0.427|  1.162|    1.093|       1.274|
|133  |img_sb_50_12 |  13| 539.257| 365.358|  226|     208|        47|       8.044|      7.126|      9.131|     0.571|        1.281|    16.087|   14.252|   18.262|     18.458|     15.594|        0.535|  1.136|    1.087|       1.286|
|143  |img_sb_50_12 |  14| 390.543| 398.744|  219|     199|        46|       7.948|      6.618|      9.419|     0.730|        1.423|    15.896|   13.236|   18.838|     18.829|     14.808|        0.618|  0.867|    1.101|       1.301|
|153  |img_sb_50_12 |  15| 545.355| 437.331|  169|     153|        41|       6.871|      6.119|      7.611|     0.359|        1.244|    13.742|   12.238|   15.222|     15.154|     14.222|        0.345|  0.298|    1.105|       1.263|
|116  |img_sb_50_13 |   1| 507.516| 380.042|  308|     284|        54|       9.468|      8.327|     10.710|     0.571|        1.286|    18.936|   16.655|   21.421|     21.387|     18.320|        0.516|  0.575|    1.085|       1.327|
|215  |img_sb_50_13 |   2| 583.464| 284.363|  295|     275|        53|       9.236|      8.327|     10.012|     0.392|        1.202|    18.472|   16.653|   20.024|     20.099|     18.691|        0.368|  0.295|    1.073|       1.320|
|313  |img_sb_50_13 |   3| 396.411| 245.586|  321|     298|        56|       9.686|      8.334|     11.108|     0.847|        1.333|    19.371|   16.668|   22.215|     22.578|     18.097|        0.598| -1.358|    1.077|       1.286|
|413  |img_sb_50_13 |   4| 490.818| 394.459|  307|     288|        55|       9.428|      8.367|     10.366|     0.543|        1.239|    18.855|   16.734|   20.733|     21.060|     18.567|        0.472|  0.122|    1.066|       1.275|
|513  |img_sb_50_13 |   5| 425.061| 237.447|  293|     273|        53|       9.218|      8.242|     10.094|     0.476|        1.225|    18.436|   16.484|   20.188|     20.427|     18.264|        0.448|  0.921|    1.073|       1.311|
|613  |img_sb_50_13 |   6| 528.441| 253.081|  270|     251|        50|       8.855|      7.836|     10.264|     0.582|        1.310|    17.709|   15.671|   20.529|     20.085|     17.132|        0.522|  1.092|    1.076|       1.357|
|713  |img_sb_50_13 |   7| 535.767| 332.917|  206|     188|        45|       7.639|      6.849|      8.352|     0.425|        1.219|    15.278|   13.698|   16.703|     17.149|     15.290|        0.453|  0.281|    1.096|       1.278|
|117  |img_sb_50_2  |   1| 224.337| 276.596|  359|     335|        59|      10.230|      9.329|     11.150|     0.439|        1.195|    20.461|   18.658|   22.301|     22.278|     20.526|        0.389|  1.434|    1.072|       1.296|
|216  |img_sb_50_2  |   2| 525.667| 178.311|  354|     331|        59|      10.167|      9.059|     11.326|     0.606|        1.250|    20.334|   18.118|   22.653|     22.816|     19.757|        0.500| -0.407|    1.069|       1.278|
|314  |img_sb_50_2  |   3| 517.045| 133.837|  312|     292|        55|       9.514|      8.893|     10.242|     0.368|        1.152|    19.027|   17.786|   20.484|     20.582|     19.308|        0.346| -1.568|    1.068|       1.296|
|414  |img_sb_50_2  |   4| 452.367| 176.914|  324|     307|        57|       9.692|      7.937|     10.822|     0.653|        1.363|    19.385|   15.875|   21.643|     21.899|     18.869|        0.508| -0.297|    1.055|       1.253|
|514  |img_sb_50_2  |   5| 514.448| 230.235|  324|     299|        55|       9.714|      8.745|     10.800|     0.514|        1.235|    19.429|   17.490|   21.600|     21.582|     19.119|        0.464|  0.795|    1.084|       1.346|
|614  |img_sb_50_2  |   6| 355.801| 478.874|  301|     280|        54|       9.349|      8.206|     10.471|     0.568|        1.276|    18.699|   16.412|   20.941|     21.027|     18.233|        0.498| -0.936|    1.075|       1.297|
|714  |img_sb_50_2  |   7| 521.834| 480.946|  313|     291|        54|       9.544|      8.363|     10.437|     0.519|        1.248|    19.088|   16.726|   20.875|     21.254|     18.746|        0.471| -1.345|    1.076|       1.349|
|813  |img_sb_50_2  |   8| 182.465| 274.623|  297|     280|        54|       9.276|      8.318|     10.145|     0.441|        1.220|    18.552|   16.636|   20.291|     20.369|     18.585|        0.409|  0.997|    1.061|       1.280|
|913  |img_sb_50_2  |   9| 535.241| 325.762|  349|     328|        59|      10.154|      8.468|     11.708|     0.867|        1.383|    20.308|   16.936|   23.416|     23.601|     18.849|        0.602| -0.846|    1.064|       1.260|
|104  |img_sb_50_2  |  10| 525.870| 250.446|  307|     290|        54|       9.453|      8.549|     10.582|     0.496|        1.238|    18.905|   17.098|   21.164|     20.624|     19.020|        0.387|  0.431|    1.059|       1.323|
|118  |img_sb_50_2  |  11| 349.074| 446.552|  310|     295|        56|       9.481|      8.359|     10.564|     0.529|        1.264|    18.961|   16.718|   21.127|     21.118|     18.709|        0.464| -1.332|    1.051|       1.242|
|124  |img_sb_50_2  |  12| 557.442| 516.850|  301|     281|        54|       9.326|      8.224|      9.955|     0.364|        1.211|    18.652|   16.448|   19.911|     20.163|     19.012|        0.333| -0.007|    1.071|       1.297|
|134  |img_sb_50_2  |  13| 378.490| 185.066|  290|     269|        51|       9.179|      8.284|     10.107|     0.376|        1.220|    18.358|   16.568|   20.214|     19.805|     18.666|        0.334| -0.607|    1.078|       1.401|
|144  |img_sb_50_2  |  14| 495.595| 379.617|  316|     294|        55|       9.595|      8.408|     10.907|     0.771|        1.297|    19.190|   16.816|   21.814|     22.074|     18.257|        0.562| -0.055|    1.075|       1.313|
|154  |img_sb_50_2  |  15| 601.937| 414.381|  315|     294|        56|       9.571|      8.090|     10.900|     0.670|        1.347|    19.142|   16.180|   21.800|     21.586|     18.606|        0.507| -0.102|    1.071|       1.262|
|163  |img_sb_50_2  |  16| 299.268| 196.735|  325|     304|        57|       9.738|      8.381|     11.196|     0.828|        1.336|    19.477|   16.761|   22.393|     22.727|     18.214|        0.598| -0.732|    1.069|       1.257|
|173  |img_sb_50_2  |  17| 616.415| 267.573|  323|     302|        56|       9.704|      8.552|     11.040|     0.690|        1.291|    19.407|   17.104|   22.080|     22.095|     18.632|        0.537|  0.386|    1.070|       1.294|
|183  |img_sb_50_2  |  18| 424.868| 384.917|  288|     268|        52|       9.136|      8.296|      9.968|     0.372|        1.202|    18.272|   16.591|   19.935|     19.732|     18.602|        0.333|  0.865|    1.075|       1.338|
|193  |img_sb_50_2  |  19| 375.134| 502.581|  298|     275|        52|       9.309|      8.222|     10.314|     0.457|        1.254|    18.617|   16.444|   20.627|     20.583|     18.430|        0.445| -1.149|    1.084|       1.385|
|203  |img_sb_50_2  |  20| 588.699| 368.838|  302|     282|        53|       9.363|      8.549|     10.267|     0.436|        1.201|    18.726|   17.098|   20.534|     20.529|     18.742|        0.408|  1.311|    1.071|       1.351|
|217  |img_sb_50_2  |  21| 434.921| 144.748|  302|     282|        55|       9.355|      8.193|     10.594|     0.595|        1.293|    18.710|   16.387|   21.189|     20.907|     18.424|        0.473|  1.103|    1.071|       1.255|
|223  |img_sb_50_2  |  22| 303.561| 509.402|  328|     313|        58|       9.755|      8.331|     11.086|     0.693|        1.331|    19.510|   16.662|   22.171|     22.004|     19.018|        0.503|  0.099|    1.048|       1.225|
|233  |img_sb_50_2  |  23| 564.913| 138.106|  310|     291|        54|       9.516|      7.826|     11.095|     0.736|        1.418|    19.032|   15.653|   22.190|     21.646|     18.305|        0.534|  1.466|    1.065|       1.336|
|242  |img_sb_50_2  |  24| 409.946| 500.287|  314|     295|        56|       9.543|      7.900|     10.643|     0.698|        1.347|    19.086|   15.800|   21.286|     21.797|     18.362|        0.539| -0.199|    1.064|       1.258|
|252  |img_sb_50_2  |  25| 539.511| 264.683|  325|     310|        57|       9.699|      8.435|     11.052|     0.703|        1.310|    19.398|   16.871|   22.103|     21.860|     19.011|        0.494|  1.541|    1.048|       1.257|
|262  |img_sb_50_2  |  26| 638.451| 352.131|  297|     280|        53|       9.270|      8.346|     10.178|     0.464|        1.220|    18.541|   16.692|   20.357|     20.379|     18.572|        0.412| -1.244|    1.061|       1.329|
|272  |img_sb_50_2  |  27| 565.288| 247.703|  316|     294|        56|       9.587|      8.207|     10.890|     0.723|        1.327|    19.174|   16.413|   21.781|     21.935|     18.352|        0.548| -0.141|    1.075|       1.266|
|282  |img_sb_50_2  |  28| 487.140| 466.817|  301|     286|        55|       9.333|      7.947|     10.564|     0.677|        1.329|    18.665|   15.894|   21.129|     21.086|     18.249|        0.501| -1.242|    1.052|       1.250|
|292  |img_sb_50_2  |  29| 333.275| 417.329|  298|     275|        54|       9.284|      8.168|     10.251|     0.535|        1.255|    18.569|   16.336|   20.502|     20.682|     18.348|        0.462|  1.312|    1.084|       1.284|
|301  |img_sb_50_2  |  30| 485.682| 417.049|  305|     281|        53|       9.411|      8.303|     10.657|     0.594|        1.283|    18.823|   16.606|   21.313|     21.156|     18.360|        0.497| -1.502|    1.085|       1.364|
|315  |img_sb_50_2  |  31| 563.468| 159.488|  299|     279|        54|       9.311|      8.477|     10.567|     0.527|        1.247|    18.623|   16.953|   21.135|     20.775|     18.334|        0.470| -1.419|    1.072|       1.289|
|321  |img_sb_50_2  |  32| 544.392| 127.726|  332|     311|        58|       9.846|      8.204|     11.353|     0.856|        1.384|    19.692|   16.408|   22.706|     22.905|     18.468|        0.592|  0.288|    1.068|       1.240|
|331  |img_sb_50_2  |  33| 445.371| 306.609|  302|     282|        55|       9.348|      8.297|     10.398|     0.554|        1.253|    18.696|   16.593|   20.797|     20.956|     18.356|        0.482| -1.149|    1.071|       1.255|
|341  |img_sb_50_2  |  34| 213.791| 396.819|  287|     265|        52|       9.107|      8.116|     10.108|     0.481|        1.245|    18.214|   16.232|   20.217|     20.155|     18.139|        0.436| -1.464|    1.083|       1.334|
|351  |img_sb_50_2  |  35| 392.114| 172.692|  273|     254|        52|       8.853|      7.812|      9.725|     0.466|        1.245|    17.707|   15.625|   19.450|     19.308|     18.066|        0.353|  0.711|    1.075|       1.269|
|361  |img_sb_50_2  |  36| 590.484| 430.270|  285|     270|        54|       9.063|      7.353|     10.399|     0.680|        1.414|    18.126|   14.706|   20.798|     20.488|     17.798|        0.495|  1.531|    1.056|       1.228|
|371  |img_sb_50_2  |  37| 549.159| 495.686|  290|     276|        55|       9.227|      7.919|     11.011|     0.820|        1.390|    18.455|   15.838|   22.022|     20.988|     17.748|        0.534|  0.964|    1.051|       1.205|
|381  |img_sb_50_2  |  38| 136.330| 380.944|  285|     264|        52|       9.074|      8.386|      9.786|     0.347|        1.167|    18.148|   16.773|   19.571|     19.678|     18.437|        0.350|  0.870|    1.080|       1.324|
|391  |img_sb_50_2  |  39| 442.860| 449.674|  279|     262|        53|       8.970|      7.842|     10.134|     0.592|        1.292|    17.941|   15.685|   20.267|     20.309|     17.517|        0.506| -1.096|    1.065|       1.248|
|401  |img_sb_50_2  |  40| 204.608| 298.752|  306|     283|        54|       9.422|      8.249|     10.610|     0.621|        1.286|    18.844|   16.498|   21.219|     21.272|     18.313|        0.509|  1.501|    1.081|       1.319|
|415  |img_sb_50_2  |  41| 515.672| 454.727|  293|     271|        54|       9.210|      8.224|     10.365|     0.506|        1.260|    18.420|   16.447|   20.731|     20.467|     18.235|        0.454| -1.401|    1.081|       1.263|
|421  |img_sb_50_2  |  42| 323.641| 480.522|  312|     290|        55|       9.521|      8.354|     11.133|     0.784|        1.333|    19.042|   16.708|   22.265|     22.037|     18.034|        0.575| -1.491|    1.076|       1.296|
|431  |img_sb_50_2  |  43| 250.809| 268.365|  288|     269|        52|       9.131|      8.126|     10.192|     0.490|        1.254|    18.262|   16.253|   20.385|     20.284|     18.082|        0.453|  1.237|    1.071|       1.338|
|441  |img_sb_50_2  |  44| 380.343| 538.076|  277|     255|        51|       8.937|      8.195|      9.738|     0.360|        1.188|    17.873|   16.391|   19.476|     19.471|     18.105|        0.368| -1.421|    1.086|       1.338|
|451  |img_sb_50_2  |  45| 280.524| 305.373|  271|     250|        50|       8.845|      7.900|      9.698|     0.381|        1.228|    17.689|   15.800|   19.396|     19.405|     17.775|        0.401| -1.036|    1.084|       1.362|
|461  |img_sb_50_2  |  46| 352.272| 192.371|  294|     274|        53|       9.218|      8.095|     10.382|     0.542|        1.283|    18.437|   16.189|   20.764|     20.620|     18.164|        0.473|  1.495|    1.073|       1.315|
|471  |img_sb_50_2  |  47| 251.332| 228.977|  307|     286|        54|       9.454|      7.695|     11.020|     0.837|        1.432|    18.909|   15.390|   22.039|     22.070|     17.727|        0.596| -1.191|    1.073|       1.323|
|481  |img_sb_50_2  |  48| 337.519| 382.806|  289|     267|        53|       9.143|      8.052|     10.320|     0.577|        1.282|    18.285|   16.104|   20.639|     20.667|     17.805|        0.508| -1.057|    1.082|       1.293|
|491  |img_sb_50_2  |  49| 545.482| 433.226|  301|     279|        54|       9.351|      8.222|     10.667|     0.668|        1.297|    18.702|   16.445|   21.335|     21.358|     17.939|        0.543|  1.361|    1.079|       1.297|
|501  |img_sb_50_2  |  50| 535.396| 194.586|  273|     255|        52|       8.871|      8.062|      9.900|     0.456|        1.228|    17.742|   16.125|   19.799|     19.314|     18.050|        0.356|  0.653|    1.071|       1.269|
|515  |img_sb_50_2  |  51| 278.078| 363.537|  268|     248|        50|       8.784|      8.202|      9.402|     0.271|        1.146|    17.567|   16.404|   18.804|     18.555|     18.388|        0.134| -0.604|    1.081|       1.347|
|521  |img_sb_50_2  |  52| 649.974| 166.230|  313|     291|        55|       9.566|      8.301|     11.183|     0.734|        1.347|    19.132|   16.603|   22.366|     22.034|     18.081|        0.571| -0.492|    1.076|       1.300|
|531  |img_sb_50_2  |  53| 530.781| 349.215|  270|     253|        51|       8.815|      7.800|      9.748|     0.435|        1.250|    17.631|   15.601|   19.496|     19.464|     17.667|        0.420|  0.025|    1.067|       1.304|
|541  |img_sb_50_2  |  54| 306.810| 138.708|  284|     263|        52|       9.062|      8.048|     10.157|     0.547|        1.262|    18.124|   16.097|   20.314|     20.333|     17.791|        0.484| -1.265|    1.080|       1.320|
|551  |img_sb_50_2  |  55| 520.925| 375.341|  293|     273|        54|       9.219|      7.909|     10.627|     0.867|        1.344|    18.438|   15.818|   21.253|     21.738|     17.157|        0.614| -1.536|    1.073|       1.263|
|561  |img_sb_50_2  |  56| 203.301| 189.675|  286|     264|        52|       9.099|      8.024|     10.288|     0.565|        1.282|    18.198|   16.048|   20.576|     20.515|     17.744|        0.502| -1.223|    1.083|       1.329|
|571  |img_sb_50_2  |  57| 563.459| 548.189|  296|     280|        54|       9.269|      8.243|     10.336|     0.550|        1.254|    18.539|   16.486|   20.672|     20.792|     18.140|        0.489| -0.859|    1.057|       1.276|
|581  |img_sb_50_2  |  58| 438.284| 417.172|  285|     264|        52|       9.079|      8.088|     10.327|     0.554|        1.277|    18.158|   16.177|   20.655|     20.325|     17.873|        0.476|  0.078|    1.080|       1.324|
|591  |img_sb_50_2  |  59| 449.493| 159.338|  272|     252|        54|       8.856|      8.035|     10.144|     0.434|        1.262|    17.713|   16.070|   20.287|     18.888|     18.426|        0.220|  0.271|    1.079|       1.172|
|601  |img_sb_50_2  |  60| 477.115| 451.820|  261|     239|        49|       8.670|      7.820|      9.479|     0.420|        1.212|    17.340|   15.639|   18.959|     19.138|     17.358|        0.421| -1.427|    1.092|       1.366|
|615  |img_sb_50_2  |  61| 252.123| 315.254|  284|     264|        53|       9.056|      7.834|     10.312|     0.683|        1.316|    18.112|   15.668|   20.624|     20.804|     17.384|        0.549|  1.517|    1.076|       1.271|
|621  |img_sb_50_2  |  62| 341.368| 559.280|  261|     239|        49|       8.669|      7.890|      9.365|     0.312|        1.187|    17.337|   15.780|   18.729|     18.752|     17.714|        0.328|  0.755|    1.092|       1.366|
|631  |img_sb_50_2  |  63| 445.425| 379.545|  266|     244|        50|       8.753|      7.934|      9.626|     0.352|        1.213|    17.506|   15.867|   19.252|     19.146|     17.680|        0.384|  0.848|    1.090|       1.337|
|641  |img_sb_50_2  |  64| 339.770| 531.560|  318|     301|        56|       9.653|      8.086|     11.191|     0.909|        1.384|    19.307|   16.171|   22.382|     22.707|     17.873|        0.617|  0.876|    1.056|       1.274|
|651  |img_sb_50_2  |  65| 322.111| 519.695|  298|     295|        61|       9.414|      7.632|     11.646|     1.060|        1.526|    18.827|   15.264|   23.293|     21.967|     17.487|        0.605|  0.728|    1.010|       1.006|
|661  |img_sb_50_2  |  66| 258.182| 456.458|  275|     255|        52|       8.901|      7.824|      9.994|     0.427|        1.277|    17.802|   15.649|   19.988|     19.651|     17.820|        0.421|  0.453|    1.078|       1.278|
|671  |img_sb_50_2  |  67| 523.080| 432.909|  275|     253|        51|       8.906|      7.765|     10.230|     0.622|        1.317|    17.812|   15.530|   20.460|     20.204|     17.348|        0.513| -0.175|    1.087|       1.329|
|681  |img_sb_50_2  |  68| 422.101| 306.205|  258|     239|        49|       8.615|      7.761|      9.429|     0.470|        1.215|    17.229|   15.523|   18.859|     19.116|     17.202|        0.436|  0.243|    1.079|       1.350|
|691  |img_sb_50_2  |  69| 426.070| 458.322|  273|     257|        53|       8.860|      7.604|      9.977|     0.586|        1.312|    17.720|   15.207|   19.953|     19.542|     17.878|        0.404|  0.571|    1.062|       1.221|
|701  |img_sb_50_2  |  70| 594.507| 391.853|  272|     254|        51|       8.871|      7.633|     10.182|     0.607|        1.334|    17.741|   15.266|   20.364|     20.232|     17.118|        0.533| -1.084|    1.071|       1.314|
|715  |img_sb_50_2  |  71| 671.628| 300.390|  277|     258|        51|       8.952|      7.810|      9.877|     0.511|        1.265|    17.904|   15.620|   19.755|     20.047|     17.594|        0.479| -0.416|    1.074|       1.338|
|721  |img_sb_50_2  |  72| 578.308| 178.563|  247|     226|        48|       8.411|      7.640|      8.916|     0.330|        1.167|    16.823|   15.280|   17.832|     18.160|     17.319|        0.301| -1.558|    1.093|       1.347|
|731  |img_sb_50_2  |  73| 291.239| 269.721|  251|     231|        48|       8.500|      7.626|      9.345|     0.441|        1.225|    17.000|   15.253|   18.690|     18.848|     16.962|        0.436| -0.657|    1.087|       1.369|
|741  |img_sb_50_2  |  74| 625.989|  93.531|  271|     248|        50|       8.864|      7.817|      9.879|     0.565|        1.264|    17.728|   15.635|   19.758|     20.127|     17.139|        0.524|  0.750|    1.093|       1.362|
|751  |img_sb_50_2  |  75| 281.111| 417.210|  243|     223|        48|       8.342|      7.347|      9.236|     0.458|        1.257|    16.684|   14.693|   18.472|     18.585|     16.659|        0.443|  0.642|    1.090|       1.325|
|761  |img_sb_50_2  |  76| 324.166| 307.769|  277|     257|        51|       8.974|      7.882|     10.206|     0.683|        1.295|    17.947|   15.764|   20.412|     20.710|     17.032|        0.569|  0.826|    1.078|       1.338|
|771  |img_sb_50_2  |  77| 497.864| 361.769|  242|     223|        48|       8.329|      6.991|      9.383|     0.504|        1.342|    16.658|   13.982|   18.766|     18.590|     16.601|        0.450| -1.314|    1.085|       1.320|
|781  |img_sb_50_2  |  78| 498.771| 286.328|  253|     235|        50|       8.527|      7.670|      9.545|     0.484|        1.244|    17.054|   15.341|   19.091|     19.052|     16.916|        0.460|  1.359|    1.077|       1.272|
|791  |img_sb_50_2  |  79| 655.521| 229.678|  267|     246|        50|       8.782|      7.498|     10.148|     0.722|        1.353|    17.564|   14.995|   20.295|     20.353|     16.712|        0.571|  0.259|    1.085|       1.342|
|801  |img_sb_50_2  |  80| 553.374| 306.125|  273|     251|        51|       8.900|      7.570|     10.304|     0.753|        1.361|    17.800|   15.140|   20.608|     20.803|     16.705|        0.596| -0.929|    1.088|       1.319|
|814  |img_sb_50_2  |  81| 452.289| 333.179|  235|     218|        48|       8.194|      7.213|      9.126|     0.454|        1.265|    16.388|   14.427|   18.252|     18.230|     16.423|        0.434| -0.073|    1.078|       1.282|
|821  |img_sb_50_2  |  82| 430.834| 291.723|  235|     219|        47|       8.195|      7.559|      9.310|     0.373|        1.232|    16.391|   15.119|   18.620|     17.807|     16.830|        0.327| -0.822|    1.073|       1.337|
|831  |img_sb_50_2  |  83| 414.126| 257.861|  230|     212|        46|       8.117|      7.109|      8.993|     0.497|        1.265|    16.235|   14.217|   17.987|     18.295|     16.016|        0.483|  0.922|    1.085|       1.366|
|841  |img_sb_50_2  |  84| 484.500| 269.291|  258|     238|        50|       8.599|      7.502|      9.954|     0.667|        1.327|    17.198|   15.003|   19.907|     19.756|     16.646|        0.539| -1.555|    1.084|       1.297|
|851  |img_sb_50_2  |  85| 542.519| 475.767|  258|     235|        51|       8.611|      7.415|      9.838|     0.644|        1.327|    17.223|   14.830|   19.676|     19.720|     16.678|        0.534|  1.395|    1.098|       1.246|
|861  |img_sb_50_2  |  86| 331.815| 168.104|  260|     244|        52|       8.651|      6.846|     10.188|     1.073|        1.488|    17.303|   13.692|   20.375|     21.269|     15.584|        0.681|  1.555|    1.066|       1.208|
|871  |img_sb_50_2  |  87| 394.854| 515.205|  219|     200|        46|       7.889|      6.718|      8.920|     0.534|        1.328|    15.777|   13.437|   17.840|     17.885|     15.600|        0.489| -1.554|    1.095|       1.301|
|881  |img_sb_50_2  |  88| 474.456| 507.402|  204|     185|        43|       7.616|      6.778|      8.331|     0.289|        1.229|    15.232|   13.555|   16.661|     16.529|     15.703|        0.312| -0.564|    1.103|       1.386|
|891  |img_sb_50_2  |  89| 457.112| 407.542|  240|     223|        49|       8.369|      6.107|     10.447|     1.114|        1.711|    16.738|   12.214|   20.895|     20.689|     14.888|        0.694| -1.003|    1.076|       1.256|
|901  |img_sb_50_2  |  90| 367.324| 379.351|  185|     168|        43|       7.209|      6.304|      8.035|     0.464|        1.275|    14.419|   12.608|   16.069|     16.368|     14.398|        0.476| -1.421|    1.101|       1.257|
|119  |img_sb_50_3  |   1| 510.465| 185.897|  312|     290|        56|       9.511|      8.396|     10.713|     0.542|        1.276|    19.023|   16.791|   21.426|     21.303|     18.664|        0.482| -0.521|    1.076|       1.250|
|218  |img_sb_50_3  |   2| 500.887| 235.007|  291|     270|        52|       9.201|      8.302|     10.300|     0.503|        1.241|    18.403|   16.605|   20.599|     20.582|     18.003|        0.485|  0.763|    1.078|       1.352|
|316  |img_sb_50_3  |   3| 441.426| 186.275|  291|     274|        54|       9.165|      7.486|     10.272|     0.645|        1.372|    18.330|   14.971|   20.544|     20.730|     17.909|        0.504| -0.364|    1.062|       1.254|
|416  |img_sb_50_3  |   4| 501.353| 144.381|  278|     259|        52|       8.946|      8.340|      9.576|     0.341|        1.148|    17.891|   16.679|   19.153|     19.260|     18.387|        0.298|  1.521|    1.073|       1.292|
|516  |img_sb_50_3  |   5| 513.145| 470.355|  282|     262|        52|       9.023|      8.078|      9.866|     0.493|        1.221|    18.046|   16.157|   19.732|     20.070|     17.895|        0.453| -1.294|    1.076|       1.311|
|616  |img_sb_50_3  |   6| 308.967| 501.624|  303|     281|        54|       9.376|      8.241|     10.356|     0.601|        1.257|    18.752|   16.482|   20.712|     21.139|     18.254|        0.504|  0.180|    1.078|       1.306|
|716  |img_sb_50_3  |   7| 511.967| 253.653|  274|     253|        50|       8.913|      7.885|     10.527|     0.484|        1.335|    17.825|   15.770|   21.053|     19.594|     17.843|        0.413|  0.372|    1.083|       1.377|
|815  |img_sb_50_3  |   8| 525.268| 266.914|  291|     275|        53|       9.168|      7.921|     10.418|     0.569|        1.315|    18.336|   15.841|   20.835|     20.343|     18.295|        0.437|  1.538|    1.058|       1.302|
|914  |img_sb_50_3  |   9| 597.512| 267.723|  289|     267|        53|       9.145|      8.174|     10.179|     0.579|        1.245|    18.291|   16.349|   20.358|     20.611|     17.866|        0.499|  0.366|    1.082|       1.293|
|105  |img_sb_50_3  |  10| 478.022| 411.164|  274|     256|        52|       8.882|      7.981|     10.038|     0.560|        1.258|    17.765|   15.962|   20.077|     20.027|     17.427|        0.493| -1.545|    1.070|       1.273|
|1110 |img_sb_50_3  |  11| 522.441| 324.405|  311|     288|        54|       9.552|      8.219|     10.948|     0.771|        1.332|    19.103|   16.439|   21.896|     22.193|     17.831|        0.595| -0.816|    1.080|       1.340|
|125  |img_sb_50_3  |  12| 573.626| 363.744|  270|     249|        50|       8.831|      7.945|      9.512|     0.368|        1.197|    17.662|   15.890|   19.024|     19.276|     17.830|        0.380|  1.116|    1.084|       1.357|
|135  |img_sb_50_3  |  13| 424.231| 156.360|  264|     241|        50|       8.713|      7.672|      9.764|     0.524|        1.273|    17.426|   15.343|   19.528|     19.507|     17.249|        0.467|  1.185|    1.095|       1.327|
|145  |img_sb_50_3  |  14| 526.799| 138.055|  293|     274|        54|       9.230|      7.778|     10.787|     0.804|        1.387|    18.459|   15.556|   21.573|     21.454|     17.405|        0.585|  0.276|    1.069|       1.263|
|155  |img_sb_50_3  |  15| 408.461| 490.866|  284|     261|        53|       9.049|      7.838|     10.374|     0.695|        1.324|    18.098|   15.677|   20.749|     20.842|     17.349|        0.554| -0.137|    1.088|       1.271|
|164  |img_sb_50_3  |  16| 350.130| 441.520|  277|     255|        52|       8.936|      7.878|      9.945|     0.613|        1.262|    17.872|   15.756|   19.890|     20.348|     17.332|        0.524| -1.391|    1.086|       1.287|
|174  |img_sb_50_3  |  17| 547.464| 503.498|  267|     245|        51|       8.765|      8.159|      9.655|     0.312|        1.183|    17.529|   16.319|   19.310|     18.698|     18.189|        0.232| -0.444|    1.090|       1.290|
|184  |img_sb_50_3  |  18| 553.804| 532.860|  265|     246|        50|       8.734|      7.926|      9.467|     0.458|        1.194|    17.469|   15.852|   18.934|     19.369|     17.431|        0.436| -0.864|    1.077|       1.332|
|194  |img_sb_50_3  |  19| 357.231| 471.907|  268|     248|        51|       8.792|      7.899|      9.744|     0.504|        1.234|    17.584|   15.797|   19.487|     19.712|     17.315|        0.478| -0.925|    1.081|       1.295|
|204  |img_sb_50_3  |  20| 419.954| 382.135|  260|     245|        50|       8.651|      7.877|      9.377|     0.412|        1.190|    17.302|   15.754|   18.754|     18.982|     17.465|        0.392|  0.966|    1.061|       1.307|
|219  |img_sb_50_3  |  21| 620.152| 346.871|  263|     245|        50|       8.703|      7.685|      9.576|     0.442|        1.246|    17.407|   15.369|   19.151|     19.274|     17.376|        0.433| -1.181|    1.073|       1.322|
|224  |img_sb_50_3  |  22| 326.982| 474.069|  277|     259|        52|       8.946|      7.651|     10.206|     0.740|        1.334|    17.892|   15.302|   20.411|     20.744|     17.016|        0.572| -1.567|    1.069|       1.287|
|234  |img_sb_50_3  |  23| 257.023| 320.717|  258|     240|        50|       8.611|      7.449|      9.654|     0.588|        1.296|    17.223|   14.897|   19.308|     19.592|     16.769|        0.517|  1.543|    1.075|       1.297|
|243  |img_sb_50_3  |  24| 334.638| 414.657|  265|     249|        50|       8.735|      7.591|      9.729|     0.511|        1.282|    17.470|   15.181|   19.458|     19.527|     17.294|        0.464|  1.223|    1.064|       1.332|
|253  |img_sb_50_3  |  25| 486.350| 375.871|  280|     260|        52|       8.992|      7.765|     10.321|     0.690|        1.329|    17.984|   15.531|   20.643|     20.622|     17.302|        0.544| -0.056|    1.077|       1.301|
|263  |img_sb_50_3  |  26| 587.086| 406.191|  278|     262|        52|       8.962|      7.328|     10.210|     0.743|        1.393|    17.925|   14.656|   20.420|     20.729|     17.104|        0.565| -0.218|    1.061|       1.292|
|273  |img_sb_50_3  |  27| 626.939| 171.759|  278|     259|        52|       8.974|      7.780|     10.321|     0.681|        1.327|    17.948|   15.560|   20.642|     20.662|     17.138|        0.559| -0.505|    1.073|       1.292|
|283  |img_sb_50_3  |  28| 545.550| 167.162|  271|     251|        50|       8.859|      7.810|     10.412|     0.548|        1.333|    17.718|   15.621|   20.823|     19.764|     17.508|        0.464| -1.362|    1.080|       1.362|
|293  |img_sb_50_3  |  29| 549.004| 250.397|  282|     265|        52|       9.030|      7.621|     10.140|     0.641|        1.330|    18.061|   15.242|   20.279|     20.580|     17.458|        0.530| -0.152|    1.064|       1.311|
|302  |img_sb_50_3  |  30| 372.142| 195.589|  253|     232|        48|       8.537|      7.788|      9.317|     0.363|        1.196|    17.075|   15.575|   18.635|     18.235|     17.697|        0.241| -1.061|    1.091|       1.380|
|317  |img_sb_50_3  |  31| 437.477| 308.300|  277|     257|        51|       8.956|      7.634|      9.881|     0.559|        1.294|    17.911|   15.267|   19.763|     20.184|     17.481|        0.500| -1.142|    1.078|       1.338|
|322  |img_sb_50_3  |  32| 375.642| 493.698|  268|     247|        50|       8.794|      7.751|      9.687|     0.467|        1.250|    17.589|   15.502|   19.374|     19.509|     17.502|        0.442| -1.203|    1.085|       1.347|
|332  |img_sb_50_3  |  33| 343.196| 521.604|  280|     260|        52|       9.047|      7.455|     10.534|     0.878|        1.413|    18.094|   14.910|   21.068|     21.411|     16.700|        0.626|  0.825|    1.077|       1.301|
|342  |img_sb_50_3  |  34| 519.876| 201.050|  241|     221|        48|       8.311|      7.688|      9.207|     0.368|        1.198|    16.623|   15.375|   18.414|     18.005|     17.058|        0.320|  0.678|    1.090|       1.314|
|352  |img_sb_50_3  |  35| 298.188| 208.177|  288|     266|        53|       9.193|      7.889|     10.615|     0.727|        1.345|    18.387|   15.778|   21.229|     21.291|     17.221|        0.588| -0.790|    1.083|       1.288|
|362  |img_sb_50_3  |  36| 539.374| 483.872|  257|     236|        49|       8.612|      7.433|      9.453|     0.424|        1.272|    17.224|   14.865|   18.907|     18.999|     17.246|        0.420|  0.742|    1.089|       1.345|
|372  |img_sb_50_3  |  37| 337.965| 381.965|  257|     240|        50|       8.595|      7.600|      9.525|     0.574|        1.253|    17.189|   15.200|   19.050|     19.593|     16.703|        0.523| -1.017|    1.071|       1.292|
|382  |img_sb_50_3  |  38| 438.245| 169.702|  245|     228|        50|       8.366|      7.468|      9.563|     0.466|        1.280|    16.731|   14.937|   19.127|     18.043|     17.396|        0.265|  0.100|    1.075|       1.232|
|392  |img_sb_50_3  |  39| 281.829| 365.060|  234|     214|        47|       8.182|      7.635|      8.918|     0.280|        1.168|    16.364|   15.270|   17.836|     17.463|     17.060|        0.214| -0.859|    1.093|       1.331|
|402  |img_sb_50_3  |  40| 347.801| 202.722|  266|     249|        50|       8.753|      7.317|      9.911|     0.581|        1.354|    17.507|   14.634|   19.821|     19.745|     17.172|        0.494|  1.521|    1.068|       1.337|
|417  |img_sb_50_3  |  41| 438.221| 442.739|  249|     231|        49|       8.475|      7.261|      9.646|     0.547|        1.328|    16.951|   14.522|   19.293|     19.128|     16.593|        0.497| -1.114|    1.078|       1.303|
|422  |img_sb_50_3  |  42| 304.012| 153.678|  255|     235|        49|       8.565|      7.260|      9.565|     0.526|        1.317|    17.130|   14.521|   19.130|     19.309|     16.812|        0.492| -1.295|    1.085|       1.335|
|432  |img_sb_50_3  |  43| 345.190| 547.401|  232|     214|        46|       8.158|      7.516|      9.015|     0.360|        1.199|    16.316|   15.032|   18.030|     17.790|     16.614|        0.358|  0.796|    1.084|       1.378|
|442  |img_sb_50_3  |  44| 650.331| 297.610|  254|     238|        50|       8.532|      7.586|      9.526|     0.496|        1.256|    17.065|   15.173|   19.053|     19.062|     16.986|        0.454| -0.432|    1.067|       1.277|
|452  |img_sb_50_3  |  45| 546.120| 147.055|  275|     258|        53|       8.922|      6.939|     10.706|     0.804|        1.543|    17.843|   13.879|   21.413|     20.215|     17.503|        0.500|  1.331|    1.066|       1.230|
|462  |img_sb_50_3  |  46| 265.199| 452.809|  246|     226|        49|       8.402|      7.559|      9.249|     0.405|        1.224|    16.804|   15.118|   18.499|     18.575|     16.864|        0.419|  0.507|    1.088|       1.288|
|472  |img_sb_50_3  |  47| 381.280| 526.840|  250|     232|        49|       8.464|      7.484|      9.291|     0.431|        1.241|    16.928|   14.968|   18.581|     18.735|     16.996|        0.421| -1.417|    1.078|       1.308|
|482  |img_sb_50_3  |  48| 480.346| 457.905|  263|     246|        51|       8.689|      7.060|      9.735|     0.694|        1.379|    17.379|   14.119|   19.471|     19.653|     17.148|        0.489| -1.281|    1.069|       1.271|
|492  |img_sb_50_3  |  49| 534.438| 425.008|  258|     241|        52|       8.615|      7.523|      9.706|     0.640|        1.290|    17.230|   15.046|   19.413|     19.790|     16.613|        0.543|  1.343|    1.071|       1.199|
|502  |img_sb_50_3  |  50| 506.860| 445.957|  257|     239|        50|       8.589|      7.173|      9.500|     0.576|        1.324|    17.179|   14.346|   19.000|     19.451|     16.843|        0.500| -1.395|    1.075|       1.292|
|517  |img_sb_50_3  |  51| 282.100| 318.301|  239|     218|        48|       8.260|      7.451|      9.153|     0.429|        1.228|    16.521|   14.902|   18.305|     18.316|     16.625|        0.420| -0.788|    1.096|       1.304|
|522  |img_sb_50_3  |  52| 576.827| 421.441|  254|     236|        50|       8.526|      7.116|      9.544|     0.536|        1.341|    17.052|   14.232|   19.087|     19.145|     16.922|        0.468|  1.351|    1.076|       1.277|
|532  |img_sb_50_3  |  53| 326.504| 511.038|  260|     244|        51|       8.672|      7.454|     10.151|     0.673|        1.362|    17.344|   14.908|   20.303|     19.776|     16.813|        0.527|  0.808|    1.066|       1.256|
|542  |img_sb_50_3  |  54| 415.856| 308.195|  236|     221|        49|       8.208|      6.999|      9.045|     0.475|        1.292|    16.417|   13.999|   18.089|     18.013|     16.742|        0.369|  0.205|    1.068|       1.235|
|552  |img_sb_50_3  |  55| 422.808| 451.092|  240|     223|        49|       8.277|      7.310|      9.256|     0.448|        1.266|    16.554|   14.619|   18.512|     17.933|     17.126|        0.297|  0.486|    1.076|       1.256|
|562  |img_sb_50_3  |  56| 579.755| 385.112|  241|     223|        47|       8.331|      7.279|      9.580|     0.606|        1.316|    16.663|   14.558|   19.160|     19.092|     16.083|        0.539| -1.135|    1.081|       1.371|
|572  |img_sb_50_3  |  57| 603.017| 104.017|  239|     218|        48|       8.286|      7.217|      9.249|     0.462|        1.282|    16.572|   14.434|   18.498|     18.646|     16.312|        0.484|  0.822|    1.096|       1.304|
|582  |img_sb_50_3  |  58| 323.933| 311.829|  240|     222|        49|       8.314|      7.193|      9.640|     0.604|        1.340|    16.627|   14.386|   19.280|     19.115|     15.988|        0.548|  0.742|    1.081|       1.256|
|592  |img_sb_50_3  |  59| 559.890| 185.000|  219|     200|        44|       7.923|      7.287|      8.576|     0.298|        1.177|    15.845|   14.574|   17.153|     17.035|     16.382|        0.274|  1.571|    1.095|       1.422|
|602  |img_sb_50_3  |  60| 510.267| 371.322|  258|     239|        50|       8.617|      7.193|     10.442|     0.813|        1.452|    17.234|   14.387|   20.883|     20.308|     16.182|        0.604| -1.569|    1.079|       1.297|
|617  |img_sb_50_3  |  61| 384.626| 183.556|  243|     229|        49|       8.324|      7.414|      9.357|     0.506|        1.262|    16.648|   14.827|   18.714|     18.073|     17.245|        0.299|  0.624|    1.061|       1.272|
|622  |img_sb_50_3  |  62| 532.685| 465.419|  241|     221|        48|       8.324|      7.266|     10.021|     0.664|        1.379|    16.648|   14.532|   20.042|     19.079|     16.153|        0.532|  1.311|    1.090|       1.314|
|632  |img_sb_50_3  |  63| 633.669| 231.343|  236|     217|        49|       8.214|      6.730|      9.541|     0.686|        1.418|    16.427|   13.459|   19.081|     19.144|     15.717|        0.571|  0.336|    1.088|       1.235|
|642  |img_sb_50_3  |  64| 470.525| 443.929|  238|     219|        48|       8.255|      7.458|      9.172|     0.484|        1.230|    16.509|   14.917|   18.344|     18.465|     16.430|        0.456| -1.343|    1.087|       1.298|
|652  |img_sb_50_3  |  65| 262.590| 293.791|  249|     228|        49|       8.441|      7.350|      9.371|     0.549|        1.275|    16.881|   14.701|   18.743|     19.121|     16.578|        0.498|  1.475|    1.092|       1.303|
|662  |img_sb_50_3  |  66| 433.510| 412.305|  249|     232|        52|       8.473|      7.040|     10.432|     0.721|        1.482|    16.945|   14.079|   20.864|     19.164|     16.649|        0.495| -0.081|    1.073|       1.157|
|672  |img_sb_50_3  |  67| 513.332| 425.382|  241|     219|        48|       8.305|      7.121|      9.467|     0.543|        1.329|    16.611|   14.241|   18.934|     18.774|     16.351|        0.491| -0.239|    1.100|       1.314|
|682  |img_sb_50_3  |  68| 487.249| 288.100|  221|     201|        46|       7.937|      6.924|      8.858|     0.453|        1.279|    15.873|   13.847|   17.715|     17.761|     15.845|        0.452|  1.348|    1.100|       1.312|
|692  |img_sb_50_3  |  69| 518.671| 346.460|  237|     220|        48|       8.230|      7.491|      9.431|     0.462|        1.259|    16.461|   14.982|   18.862|     18.401|     16.403|        0.453| -0.058|    1.077|       1.293|
|702  |img_sb_50_3  |  70| 285.682| 415.527|  220|     201|        46|       7.909|      6.996|      8.702|     0.404|        1.244|    15.817|   13.992|   17.404|     17.557|     15.955|        0.417|  0.608|    1.095|       1.307|
|717  |img_sb_50_3  |  71| 423.668| 294.428|  208|     191|        45|       7.686|      7.063|      8.673|     0.343|        1.228|    15.373|   14.126|   17.346|     16.480|     16.111|        0.211| -0.711|    1.089|       1.291|
|722  |img_sb_50_3  |  72| 291.502| 276.890|  219|     202|        46|       7.901|      7.175|      8.658|     0.397|        1.207|    15.802|   14.350|   17.316|     17.477|     15.958|        0.408| -0.867|    1.084|       1.301|
|732  |img_sb_50_3  |  73| 488.042| 359.085|  213|     195|        47|       7.794|      6.854|      9.231|     0.566|        1.347|    15.587|   13.709|   18.463|     17.716|     15.360|        0.498| -1.354|    1.092|       1.212|
|742  |img_sb_50_3  |  74| 439.090| 376.721|  233|     217|        48|       8.166|      7.384|      8.980|     0.435|        1.216|    16.332|   14.767|   17.960|     18.220|     16.288|        0.448|  0.958|    1.074|       1.271|
|752  |img_sb_50_3  |  75| 539.070| 305.613|  243|     224|        49|       8.372|      6.984|      9.787|     0.762|        1.401|    16.744|   13.969|   19.573|     19.779|     15.637|        0.612| -0.977|    1.085|       1.272|
|762  |img_sb_50_3  |  76| 327.966| 180.711|  235|     217|        49|       8.210|      6.697|      9.779|     0.929|        1.460|    16.420|   13.394|   19.558|     19.954|     14.994|        0.660|  1.487|    1.083|       1.230|
|772  |img_sb_50_3  |  77| 444.800| 333.073|  205|     187|        44|       7.622|      6.709|      8.475|     0.456|        1.263|    15.245|   13.418|   16.950|     17.150|     15.220|        0.461| -0.069|    1.096|       1.331|
|782  |img_sb_50_3  |  78| 473.587| 272.343|  230|     211|        47|       8.103|      7.159|      8.996|     0.492|        1.257|    16.205|   14.318|   17.993|     18.295|     16.001|        0.485|  1.471|    1.090|       1.308|
|792  |img_sb_50_3  |  79| 407.121| 262.976|  206|     188|        45|       7.651|      6.846|      8.623|     0.534|        1.260|    15.302|   13.691|   17.246|     17.548|     14.947|        0.524|  1.078|    1.096|       1.278|
|802  |img_sb_50_3  |  80| 469.290| 496.210|  186|     171|        43|       7.231|      6.658|      7.955|     0.325|        1.195|    14.462|   13.316|   15.910|     15.697|     15.106|        0.272| -0.242|    1.088|       1.264|
|816  |img_sb_50_3  |  81| 394.554| 505.176|  193|     175|        43|       7.383|      6.352|      8.374|     0.552|        1.318|    14.766|   12.705|   16.747|     17.050|     14.399|        0.536|  1.502|    1.103|       1.312|
|822  |img_sb_50_3  |  82| 450.963| 402.790|  214|     197|        45|       7.893|      5.621|      9.615|     1.125|        1.711|    15.786|   11.241|   19.231|     19.889|     13.760|        0.722| -1.059|    1.086|       1.328|
|832  |img_sb_50_3  |  83| 365.795| 378.072|  166|     152|        40|       6.815|      5.913|      7.951|     0.458|        1.345|    13.630|   11.827|   15.902|     15.566|     13.584|        0.488| -1.414|    1.092|       1.304|
|120  |img_sb_50_4  |   1| 464.611| 313.472|  301|     282|        54|       9.362|      7.746|     10.729|     0.706|        1.385|    18.725|   15.491|   21.458|     21.466|     17.873|        0.554| -0.849|    1.067|       1.297|
|220  |img_sb_50_4  |   2| 419.467| 320.966|  261|     241|        51|       8.674|      7.877|      9.818|     0.522|        1.246|    17.347|   15.754|   19.636|     19.425|     17.144|        0.470|  0.449|    1.083|       1.261|
|318  |img_sb_50_4  |   3| 501.318| 101.770|  261|     244|        51|       8.659|      8.042|      9.395|     0.326|        1.168|    17.318|   16.085|   18.790|     18.647|     17.835|        0.292|  1.069|    1.070|       1.261|
|418  |img_sb_50_4  |   4| 569.138| 239.343|  289|     271|        53|       9.153|      7.587|     10.539|     0.805|        1.389|    18.306|   15.173|   21.078|     21.295|     17.317|        0.582| -0.177|    1.066|       1.293|
|518  |img_sb_50_4  |   5| 465.988| 227.035|  256|     236|        50|       8.572|      7.608|      9.468|     0.511|        1.244|    17.144|   15.216|   18.936|     19.353|     16.832|        0.494| -1.137|    1.085|       1.287|
|618  |img_sb_50_4  |   6| 545.489| 157.941|  272|     251|        51|       8.855|      7.638|     10.144|     0.635|        1.328|    17.710|   15.276|   20.289|     20.225|     17.117|        0.533|  0.045|    1.084|       1.314|
|718  |img_sb_50_4  |   7| 288.618| 424.258|  267|     249|        51|       8.777|      7.572|      9.941|     0.701|        1.313|    17.554|   15.145|   19.883|     19.900|     17.209|        0.502|  0.422|    1.072|       1.290|
|817  |img_sb_50_4  |   8| 453.435| 198.413|  283|     263|        53|       9.051|      7.698|     10.170|     0.648|        1.321|    18.102|   15.396|   20.340|     20.658|     17.447|        0.535| -1.174|    1.076|       1.266|
|915  |img_sb_50_4  |   9| 282.367| 331.240|  275|     252|        51|       8.910|      7.771|     10.073|     0.649|        1.296|    17.820|   15.542|   20.146|     20.409|     17.150|        0.542| -0.095|    1.091|       1.329|
|106  |img_sb_50_4  |  10| 329.975| 236.228|  241|     222|        49|       8.290|      7.275|      9.195|     0.467|        1.264|    16.581|   14.550|   18.389|     18.293|     16.829|        0.392| -0.516|    1.086|       1.261|
|1111 |img_sb_50_4  |  11| 287.759| 460.416|  274|     256|        52|       8.909|      7.528|     10.133|     0.723|        1.346|    17.819|   15.057|   20.266|     20.677|     16.872|        0.578|  1.107|    1.070|       1.273|
|126  |img_sb_50_4  |  12| 314.388| 158.756|  242|     222|        48|       8.331|      7.578|      9.083|     0.410|        1.199|    16.663|   15.155|   18.166|     18.456|     16.696|        0.426| -0.570|    1.090|       1.320|
|136  |img_sb_50_4  |  13| 506.760| 314.636|  275|     256|        51|       8.947|      7.823|      9.941|     0.532|        1.271|    17.894|   15.646|   19.882|     19.971|     17.594|        0.473|  1.052|    1.074|       1.329|
|146  |img_sb_50_4  |  14| 632.451| 350.027|  257|     237|        48|       8.620|      7.789|      9.365|     0.368|        1.202|    17.240|   15.578|   18.731|     18.817|     17.404|        0.380|  0.732|    1.084|       1.402|
|156  |img_sb_50_4  |  15| 177.457| 209.721|  258|     236|        49|       8.625|      7.642|      9.611|     0.495|        1.258|    17.250|   15.285|   19.221|     19.397|     16.928|        0.488|  0.777|    1.093|       1.350|
|165  |img_sb_50_4  |  16| 580.463| 271.896|  268|     247|        50|       8.811|      7.797|      9.746|     0.516|        1.250|    17.623|   15.594|   19.493|     19.889|     17.142|        0.507| -0.909|    1.085|       1.347|
|175  |img_sb_50_4  |  17| 541.653| 364.128|  242|     222|        48|       8.329|      7.537|      9.010|     0.329|        1.195|    16.658|   15.075|   18.021|     17.982|     17.139|        0.303| -0.095|    1.090|       1.320|
|185  |img_sb_50_4  |  18| 319.676| 251.143|  259|     242|        51|       8.632|      7.328|      9.563|     0.497|        1.305|    17.265|   14.657|   19.126|     19.172|     17.253|        0.436| -0.928|    1.070|       1.251|
|195  |img_sb_50_4  |  19| 594.205| 330.086|  268|     246|        50|       8.820|      7.700|     10.281|     0.699|        1.335|    17.640|   15.401|   20.562|     20.364|     16.770|        0.567|  1.179|    1.089|       1.347|
|205  |img_sb_50_4  |  20| 560.069| 538.190|  247|     227|        49|       8.417|      7.533|      9.419|     0.487|        1.250|    16.834|   15.067|   18.837|     18.940|     16.605|        0.481| -0.876|    1.088|       1.293|
|2110 |img_sb_50_4  |  21| 621.685| 281.911|  270|     249|        51|       8.849|      7.719|     10.041|     0.635|        1.301|    17.698|   15.439|   20.082|     20.322|     16.909|        0.555| -0.883|    1.084|       1.304|
|225  |img_sb_50_4  |  22| 588.092| 247.016|  249|     231|        49|       8.460|      7.531|      9.358|     0.462|        1.243|    16.919|   15.061|   18.716|     18.571|     17.117|        0.388|  0.016|    1.078|       1.303|
|235  |img_sb_50_4  |  23| 518.415| 288.542|  253|     232|        48|       8.559|      7.685|      9.580|     0.490|        1.247|    17.118|   15.371|   19.160|     19.321|     16.658|        0.507| -0.846|    1.091|       1.380|
|244  |img_sb_50_4  |  24| 425.751| 166.897|  233|     223|        49|       8.124|      6.400|      9.244|     0.672|        1.444|    16.248|   12.800|   18.488|     18.561|     16.069|        0.501| -1.393|    1.045|       1.219|
|254  |img_sb_50_4  |  25| 295.837| 344.515|  264|     244|        50|       8.717|      6.896|     10.247|     0.700|        1.486|    17.435|   13.793|   20.494|     20.012|     16.855|        0.539|  1.220|    1.082|       1.327|
|264  |img_sb_50_4  |  26| 550.101| 305.789|  227|     210|        46|       8.068|      7.296|      8.921|     0.334|        1.223|    16.135|   14.593|   17.842|     17.326|     16.714|        0.263| -0.835|    1.081|       1.348|
|274  |img_sb_50_4  |  27| 447.866| 450.920|  238|     220|        48|       8.254|      7.212|      9.375|     0.465|        1.300|    16.508|   14.424|   18.750|     18.315|     16.589|        0.424|  0.134|    1.082|       1.298|
|284  |img_sb_50_4  |  28| 503.067| 414.647|  255|     242|        53|       8.518|      6.662|      9.756|     0.667|        1.464|    17.037|   13.325|   19.512|     18.847|     17.428|        0.381|  1.313|    1.054|       1.141|
|294  |img_sb_50_4  |  29| 568.743| 487.937|  253|     234|        50|       8.541|      7.412|      9.842|     0.680|        1.328|    17.082|   14.825|   19.684|     19.803|     16.267|        0.570| -0.539|    1.081|       1.272|
|303  |img_sb_50_4  |  30| 570.644| 213.749|  239|     220|        47|       8.276|      7.374|      8.969|     0.358|        1.216|    16.552|   14.749|   17.938|     18.157|     16.750|        0.386| -0.196|    1.086|       1.360|
|319  |img_sb_50_4  |  31| 554.206| 509.718|  252|     237|        49|       8.497|      7.388|      9.314|     0.475|        1.261|    16.993|   14.776|   18.627|     18.873|     17.023|        0.432| -0.161|    1.063|       1.319|
|323  |img_sb_50_4  |  32| 300.602| 250.707|  259|     241|        50|       8.642|      7.269|     10.000|     0.680|        1.376|    17.284|   14.537|   19.999|     19.834|     16.640|        0.544|  0.097|    1.075|       1.302|
|333  |img_sb_50_4  |  33| 563.742| 412.238|  240|     221|        48|       8.295|      7.196|      9.607|     0.603|        1.335|    16.590|   14.392|   19.213|     18.878|     16.227|        0.511| -1.469|    1.086|       1.309|
|343  |img_sb_50_4  |  34| 323.073| 440.785|  260|     240|        50|       8.700|      6.905|     10.313|     0.904|        1.494|    17.399|   13.810|   20.626|     20.787|     15.942|        0.642| -1.175|    1.083|       1.307|
|353  |img_sb_50_4  |  35| 532.028| 319.289|  246|     224|        48|       8.420|      7.241|      9.716|     0.632|        1.342|    16.839|   14.483|   19.432|     19.428|     16.114|        0.559|  0.978|    1.098|       1.342|
|363  |img_sb_50_4  |  36| 344.225| 373.185|  249|     231|        49|       8.456|      7.276|      9.787|     0.592|        1.345|    16.912|   14.552|   19.573|     19.241|     16.494|        0.515|  1.078|    1.078|       1.303|
|373  |img_sb_50_4  |  37| 614.882| 348.387|  238|     217|        46|       8.286|      7.211|      9.226|     0.457|        1.280|    16.573|   14.422|   18.453|     18.410|     16.484|        0.445|  1.041|    1.097|       1.413|
|383  |img_sb_50_4  |  38| 252.862| 257.555|  247|     226|        49|       8.449|      7.423|      9.634|     0.585|        1.298|    16.898|   14.847|   19.269|     19.331|     16.269|        0.540|  0.885|    1.093|       1.293|
|393  |img_sb_50_4  |  39| 437.448| 413.656|  259|     240|        51|       8.629|      7.397|      9.825|     0.756|        1.328|    17.257|   14.795|   19.649|     20.216|     16.312|        0.591|  1.463|    1.079|       1.251|
|403  |img_sb_50_4  |  40| 488.996| 465.211|  246|     232|        49|       8.405|      6.918|      9.423|     0.604|        1.362|    16.810|   13.837|   18.845|     18.919|     16.643|        0.476| -1.124|    1.060|       1.288|
|419  |img_sb_50_4  |  41| 561.122| 318.275|  262|     246|        51|       8.668|      7.297|      9.889|     0.692|        1.355|    17.337|   14.594|   19.778|     19.917|     16.809|        0.536| -0.210|    1.065|       1.266|
|423  |img_sb_50_4  |  42| 513.385| 400.385|  262|     247|        52|       8.667|      7.182|     10.144|     0.822|        1.412|    17.335|   14.365|   20.287|     20.251|     16.545|        0.577|  1.431|    1.061|       1.218|
|433  |img_sb_50_4  |  43| 318.185| 327.099|  243|     223|        48|       8.345|      7.125|      9.488|     0.618|        1.332|    16.690|   14.250|   18.975|     19.139|     16.171|        0.535| -1.473|    1.090|       1.325|
|443  |img_sb_50_4  |  44| 312.619| 360.410|  239|     218|        48|       8.258|      7.452|      8.883|     0.411|        1.192|    16.517|   14.903|   17.765|     18.263|     16.660|        0.410|  1.458|    1.096|       1.304|
|453  |img_sb_50_4  |  45| 654.910| 307.573|  234|     215|        48|       8.165|      7.458|      9.122|     0.408|        1.223|    16.330|   14.917|   18.244|     18.023|     16.546|        0.397| -0.378|    1.088|       1.276|
|463  |img_sb_50_4  |  46| 392.671| 531.320|  228|     207|        45|       8.087|      7.295|      8.878|     0.401|        1.217|    16.175|   14.589|   17.755|     17.910|     16.202|        0.426| -1.409|    1.101|       1.415|
|473  |img_sb_50_4  |  47| 275.236| 434.751|  225|     206|        46|       8.006|      7.160|      8.869|     0.404|        1.239|    16.012|   14.319|   17.737|     17.303|     16.607|        0.281| -0.152|    1.092|       1.336|
|483  |img_sb_50_4  |  48| 376.282| 234.630|  227|     206|        47|       8.044|      7.322|      8.905|     0.389|        1.216|    16.087|   14.644|   17.810|     17.627|     16.423|        0.363|  0.086|    1.102|       1.291|
|493  |img_sb_50_4  |  49| 479.801| 451.656|  221|     205|        47|       7.926|      6.837|      8.787|     0.515|        1.285|    15.851|   13.674|   17.575|     17.809|     15.855|        0.455| -1.337|    1.078|       1.257|
|503  |img_sb_50_4  |  50| 322.543| 458.973|  221|     201|        46|       7.941|      7.182|      8.679|     0.359|        1.208|    15.883|   14.365|   17.358|     17.433|     16.151|        0.376| -1.200|    1.100|       1.312|
|519  |img_sb_50_4  |  51| 432.272| 310.522|  228|     210|        47|       8.070|      7.326|      8.957|     0.400|        1.223|    16.140|   14.652|   17.914|     17.433|     16.707|        0.286|  0.572|    1.086|       1.297|
|523  |img_sb_50_4  |  52| 463.418| 390.435|  237|     217|        48|       8.229|      7.438|      8.878|     0.439|        1.194|    16.458|   14.875|   17.756|     18.402|     16.384|        0.455| -1.475|    1.092|       1.293|
|533  |img_sb_50_4  |  53| 488.160| 314.008|  243|     224|        49|       8.364|      6.922|      9.678|     0.788|        1.398|    16.728|   13.844|   19.357|     19.672|     15.770|        0.598|  0.219|    1.085|       1.272|
|543  |img_sb_50_4  |  54| 323.886| 221.198|  237|     222|        51|       8.228|      6.852|      9.781|     0.715|        1.428|    16.456|   13.703|   19.562|     18.796|     16.194|        0.508|  0.126|    1.068|       1.145|
|553  |img_sb_50_4  |  55| 382.937| 265.303|  221|     205|        46|       7.944|      7.196|      8.700|     0.392|        1.209|    15.889|   14.391|   17.400|     17.623|     15.968|        0.423|  0.572|    1.078|       1.312|
|563  |img_sb_50_4  |  56| 484.893| 328.971|  206|     191|        46|       7.630|      6.078|      8.321|     0.484|        1.369|    15.260|   12.155|   16.642|     16.510|     15.990|        0.249|  0.660|    1.079|       1.223|
|573  |img_sb_50_4  |  57| 445.513| 352.623|  228|     208|        46|       8.081|      7.045|      8.885|     0.483|        1.261|    16.162|   14.091|   17.770|     18.255|     15.890|        0.492|  0.328|    1.096|       1.354|
|583  |img_sb_50_4  |  58| 539.664| 489.415|  229|     210|        47|       8.100|      7.180|      8.997|     0.500|        1.253|    16.200|   14.359|   17.995|     18.272|     15.962|        0.487|  1.102|    1.090|       1.303|
|593  |img_sb_50_4  |  59| 610.937| 121.409|  237|     216|        46|       8.280|      7.416|      9.346|     0.522|        1.260|    16.560|   14.831|   18.691|     18.842|     16.005|        0.528|  0.914|    1.097|       1.407|
|603  |img_sb_50_4  |  60| 548.478| 414.066|  226|     210|        47|       8.023|      6.363|      9.274|     0.701|        1.457|    16.045|   12.726|   18.547|     18.640|     15.485|        0.557|  1.484|    1.076|       1.286|
|619  |img_sb_50_4  |  61| 548.392| 444.037|  217|     201|        45|       7.863|      7.056|      8.637|     0.363|        1.224|    15.727|   14.112|   17.273|     17.248|     16.025|        0.370| -0.823|    1.080|       1.347|
|623  |img_sb_50_4  |  62| 569.049| 336.289|  225|     205|        46|       8.037|      6.702|      9.262|     0.627|        1.382|    16.075|   13.404|   18.524|     18.588|     15.425|        0.558| -0.507|    1.098|       1.336|
|633  |img_sb_50_4  |  63| 299.091| 129.215|  219|     201|        45|       7.914|      6.911|      9.086|     0.564|        1.315|    15.829|   13.821|   18.172|     18.132|     15.393|        0.528| -0.905|    1.090|       1.359|
|643  |img_sb_50_4  |  64| 364.619| 250.139|  202|     180|        43|       7.564|      6.845|      8.270|     0.343|        1.208|    15.128|   13.690|   16.539|     16.526|     15.568|        0.336|  0.345|    1.122|       1.373|
|653  |img_sb_50_4  |  65| 427.843| 393.375|  216|     197|        45|       7.840|      6.778|      8.969|     0.618|        1.323|    15.681|   13.557|   17.937|     18.126|     15.177|        0.547| -1.428|    1.096|       1.340|
|663  |img_sb_50_4  |  66| 381.761| 338.746|  213|     194|        44|       7.798|      6.700|      8.638|     0.432|        1.289|    15.597|   13.399|   17.276|     17.381|     15.614|        0.439|  1.042|    1.098|       1.383|
|673  |img_sb_50_4  |  67| 380.759| 393.679|  212|     194|        46|       7.773|      6.682|      9.010|     0.648|        1.348|    15.547|   13.365|   18.020|     18.186|     14.852|        0.577|  0.864|    1.093|       1.259|
|683  |img_sb_50_4  |  68| 459.018| 438.059|  220|     203|        47|       7.924|      6.395|      9.218|     0.717|        1.442|    15.847|   12.790|   18.437|     18.339|     15.378|        0.545|  0.453|    1.084|       1.252|
|693  |img_sb_50_4  |  69| 456.862| 299.195|  210|     199|        45|       7.739|      6.130|      8.701|     0.575|        1.419|    15.479|   12.259|   17.402|     17.278|     15.590|        0.431| -1.030|    1.055|       1.303|
|703  |img_sb_50_4  |  70| 392.286| 252.844|  199|     180|        44|       7.504|      6.385|      8.437|     0.452|        1.321|    15.007|   12.770|   16.873|     16.758|     15.154|        0.427|  0.006|    1.106|       1.292|
|719  |img_sb_50_4  |  71| 439.277| 172.817|  202|     191|        49|       7.479|      4.620|      8.714|     0.864|        1.886|    14.958|    9.239|   17.428|     17.507|     14.863|        0.528| -1.383|    1.058|       1.057|
|723  |img_sb_50_4  |  72| 444.195| 378.390|  200|     184|        43|       7.535|      6.467|      8.459|     0.479|        1.308|    15.071|   12.935|   16.917|     17.028|     14.968|        0.477| -0.257|    1.087|       1.359|
|733  |img_sb_50_4  |  73| 478.145| 502.174|  172|     156|        40|       6.948|      6.194|      7.587|     0.300|        1.225|    13.895|   12.388|   15.174|     15.164|     14.436|        0.306| -0.476|    1.103|       1.351|
|743  |img_sb_50_4  |  74| 387.520| 422.436|  179|     162|        42|       7.092|      6.381|      7.925|     0.455|        1.242|    14.183|   12.762|   15.851|     16.057|     14.220|        0.465|  1.095|    1.105|       1.275|
|753  |img_sb_50_4  |  75| 384.355| 379.192|  172|     160|        42|       6.950|      5.240|      8.219|     0.620|        1.568|    13.899|   10.481|   16.439|     15.528|     14.267|        0.395|  1.455|    1.075|       1.225|
|127  |img_sb_50_5  |   1| 470.387| 294.402|  323|     300|        55|       9.731|      8.066|     10.993|     0.760|        1.363|    19.462|   16.131|   21.987|     22.422|     18.366|        0.574| -0.823|    1.077|       1.342|
|226  |img_sb_50_5  |   2| 459.729| 173.123|  325|     305|        56|       9.732|      8.281|     11.075|     0.588|        1.337|    19.463|   16.562|   22.149|     21.601|     19.227|        0.456| -1.043|    1.066|       1.302|
|320  |img_sb_50_5  |   3| 514.174| 295.761|  305|     288|        54|       9.417|      8.181|     10.465|     0.524|        1.279|    18.834|   16.362|   20.931|     20.915|     18.597|        0.458|  0.936|    1.059|       1.314|
|420  |img_sb_50_5  |   4| 580.539| 217.850|  319|     301|        57|       9.639|      8.157|     11.067|     0.754|        1.357|    19.279|   16.313|   22.134|     22.067|     18.448|        0.549| -0.174|    1.060|       1.234|
|520  |img_sb_50_5  |   5| 591.795| 252.059|  288|     266|        52|       9.150|      8.174|     10.186|     0.456|        1.246|    18.300|   16.349|   20.371|     20.312|     18.050|        0.459| -0.819|    1.083|       1.338|
|620  |img_sb_50_5  |   6| 567.606| 343.011|  277|     256|        52|       8.936|      8.142|      9.619|     0.328|        1.181|    17.871|   16.284|   19.238|     19.290|     18.286|        0.318|  1.122|    1.082|       1.287|
|720  |img_sb_50_5  |   7| 436.277| 290.885|  253|     235|        50|       8.522|      7.748|      9.629|     0.399|        1.243|    17.044|   15.497|   19.258|     18.506|     17.439|        0.335|  0.420|    1.077|       1.272|
|818  |img_sb_50_5  |   8| 556.869| 131.977|  298|     279|        55|       9.283|      7.912|     10.412|     0.739|        1.316|    18.566|   15.823|   20.824|     21.418|     17.721|        0.562|  0.067|    1.068|       1.238|
|916  |img_sb_50_5  |   9| 288.960| 309.741|  274|     253|        51|       8.881|      7.961|      9.441|     0.354|        1.186|    17.761|   15.923|   18.882|     19.197|     18.177|        0.322| -0.353|    1.083|       1.324|
|107  |img_sb_50_5  |  10| 508.955| 400.652|  287|     271|        53|       9.101|      7.940|     10.270|     0.533|        1.293|    18.202|   15.879|   20.540|     19.929|     18.422|        0.381|  1.371|    1.059|       1.284|
|1112 |img_sb_50_5  |  11| 422.662| 301.745|  290|     271|        53|       9.197|      8.109|     10.389|     0.588|        1.281|    18.393|   16.218|   20.778|     20.773|     17.787|        0.517|  0.458|    1.070|       1.297|
|128  |img_sb_50_5  |  12| 519.910| 385.671|  289|     268|        53|       9.144|      7.800|     10.690|     0.794|        1.371|    18.287|   15.600|   21.380|     21.255|     17.341|        0.578|  1.401|    1.078|       1.293|
|137  |img_sb_50_5  |  13| 329.583| 211.041|  266|     248|        51|       8.738|      7.978|      9.352|     0.333|        1.172|    17.476|   15.957|   18.704|     18.634|     18.189|        0.217|  0.394|    1.073|       1.285|
|147  |img_sb_50_5  |  14| 645.004| 334.419|  277|     260|        51|       8.959|      8.160|      9.707|     0.418|        1.190|    17.918|   16.320|   19.415|     19.560|     18.066|        0.383|  0.887|    1.065|       1.338|
|157  |img_sb_50_5  |  15| 472.599| 203.695|  279|     258|        51|       8.995|      7.672|      9.903|     0.565|        1.291|    17.989|   15.343|   19.806|     20.266|     17.536|        0.501| -1.198|    1.081|       1.348|
|166  |img_sb_50_5  |  16| 251.091| 315.229|  275|     257|        51|       8.916|      8.031|      9.730|     0.456|        1.212|    17.831|   16.062|   19.460|     19.813|     17.669|        0.452|  0.603|    1.070|       1.329|
|176  |img_sb_50_5  |  17| 282.871| 446.356|  303|     284|        54|       9.389|      7.877|     10.844|     0.716|        1.377|    18.778|   15.753|   21.688|     21.572|     17.899|        0.558|  1.126|    1.067|       1.306|
|186  |img_sb_50_5  |  18| 605.378| 313.120|  299|     277|        54|       9.324|      7.871|     10.556|     0.692|        1.341|    18.649|   15.742|   21.112|     21.406|     17.779|        0.557|  1.207|    1.079|       1.289|
|196  |img_sb_50_5  |  19| 582.391| 190.900|  271|     250|        51|       8.832|      7.855|      9.809|     0.498|        1.249|    17.665|   15.710|   19.617|     19.628|     17.585|        0.444| -0.071|    1.084|       1.309|
|206  |img_sb_50_5  |  20| 450.667| 437.962|  261|     242|        50|       8.669|      7.957|      9.869|     0.506|        1.240|    17.338|   15.914|   19.738|     19.377|     17.159|        0.465|  0.209|    1.079|       1.312|
|2111 |img_sb_50_5  |  21| 561.062| 500.356|  275|     254|        51|       8.902|      8.220|      9.529|     0.319|        1.159|    17.804|   16.441|   19.059|     19.232|     18.195|        0.324| -0.187|    1.083|       1.329|
|227  |img_sb_50_5  |  22| 225.553| 293.960|  302|     279|        54|       9.378|      8.043|     10.607|     0.748|        1.319|    18.756|   16.087|   21.214|     21.727|     17.680|        0.581| -1.224|    1.082|       1.301|
|236  |img_sb_50_5  |  23| 634.887| 263.162|  291|     268|        53|       9.197|      8.022|     10.550|     0.655|        1.315|    18.395|   16.044|   21.100|     21.095|     17.558|        0.554| -0.829|    1.086|       1.302|
|245  |img_sb_50_5  |  24| 572.287| 398.721|  258|     237|        50|       8.611|      7.142|     10.014|     0.716|        1.402|    17.221|   14.284|   20.028|     19.899|     16.530|        0.557| -1.463|    1.089|       1.297|
|255  |img_sb_50_5  |  25| 315.937| 306.893|  270|     249|        51|       8.818|      7.846|      9.870|     0.533|        1.258|    17.636|   15.693|   19.739|     19.830|     17.333|        0.486| -1.442|    1.084|       1.304|
|265  |img_sb_50_5  |  26| 571.086| 300.672|  290|     272|        52|       9.171|      7.615|     10.318|     0.665|        1.355|    18.341|   15.231|   20.636|     20.886|     17.703|        0.531| -0.242|    1.066|       1.348|
|275  |img_sb_50_5  |  27| 566.765| 530.076|  277|     257|        51|       8.952|      8.058|      9.733|     0.471|        1.208|    17.904|   16.116|   19.467|     19.955|     17.670|        0.465| -0.777|    1.078|       1.338|
|285  |img_sb_50_5  |  28| 526.709| 268.982|  278|     260|        52|       8.974|      7.924|     10.078|     0.555|        1.272|    17.948|   15.848|   20.156|     20.281|     17.452|        0.509| -0.841|    1.069|       1.292|
|295  |img_sb_50_5  |  29| 467.880| 374.895|  266|     245|        51|       8.743|      7.825|      9.582|     0.485|        1.225|    17.485|   15.650|   19.165|     19.567|     17.301|        0.467| -1.325|    1.086|       1.285|
|304  |img_sb_50_5  |  30| 546.039| 478.907|  258|     239|        50|       8.604|      7.856|      9.485|     0.436|        1.207|    17.208|   15.713|   18.970|     19.067|     17.233|        0.428|  1.114|    1.079|       1.297|
|3110 |img_sb_50_5  |  31| 600.079| 226.300|  277|     260|        54|       8.946|      7.567|     10.161|     0.571|        1.343|    17.892|   15.133|   20.323|     19.566|     18.098|        0.380|  0.099|    1.065|       1.194|
|324  |img_sb_50_5  |  32| 383.807| 378.530|  264|     245|        50|       8.724|      7.721|      9.679|     0.450|        1.254|    17.448|   15.441|   19.358|     19.315|     17.406|        0.433| -0.303|    1.078|       1.327|
|334  |img_sb_50_5  |  33| 668.863| 290.603|  262|     244|        50|       8.690|      7.744|      9.665|     0.482|        1.248|    17.379|   15.489|   19.330|     19.370|     17.225|        0.457| -0.408|    1.074|       1.317|
|344  |img_sb_50_5  |  34| 431.195| 139.989|  266|     247|        51|       8.748|      7.356|      9.705|     0.564|        1.319|    17.497|   14.712|   19.410|     19.683|     17.238|        0.483| -1.335|    1.077|       1.285|
|354  |img_sb_50_5  |  35| 392.063| 521.500|  254|     233|        50|       8.526|      7.862|      9.036|     0.345|        1.149|    17.052|   15.724|   18.072|     18.613|     17.368|        0.360| -1.462|    1.090|       1.277|
|364  |img_sb_50_5  |  36| 559.661| 287.409|  254|     235|        49|       8.543|      7.948|      9.072|     0.289|        1.141|    17.086|   15.897|   18.144|     18.147|     17.826|        0.187| -0.982|    1.081|       1.329|
|374  |img_sb_50_5  |  37| 234.200| 399.186|  280|     259|        54|       9.009|      7.487|     10.535|     0.802|        1.407|    18.019|   14.974|   21.070|     21.024|     16.998|        0.588|  0.293|    1.081|       1.207|
|384  |img_sb_50_5  |  38| 440.307| 398.934|  290|     269|        54|       9.154|      7.630|     10.358|     0.779|        1.358|    18.308|   15.259|   20.716|     21.290|     17.353|        0.579|  1.475|    1.078|       1.250|
|394  |img_sb_50_5  |  39| 576.412| 477.708|  277|     257|        51|       8.954|      7.748|     10.044|     0.610|        1.296|    17.907|   15.496|   20.087|     20.380|     17.303|        0.528| -0.442|    1.078|       1.338|
|404  |img_sb_50_5  |  40| 540.642| 301.213|  282|     263|        51|       9.065|      7.997|     10.250|     0.674|        1.282|    18.130|   15.995|   20.499|     20.862|     17.215|        0.565|  0.775|    1.072|       1.362|
|4110 |img_sb_50_5  |  41| 211.262| 423.500|  248|     229|        48|       8.449|      7.590|      9.107|     0.353|        1.200|    16.898|   15.180|   18.215|     18.437|     17.132|        0.370| -1.059|    1.083|       1.353|
|424  |img_sb_50_5  |  42| 556.528| 400.429|  254|     235|        51|       8.532|      7.322|      9.793|     0.690|        1.337|    17.064|   14.644|   19.587|     19.660|     16.492|        0.544|  1.541|    1.081|       1.227|
|434  |img_sb_50_5  |  43| 296.449| 235.766|  265|     245|        50|       8.755|      7.608|      9.819|     0.587|        1.291|    17.510|   15.216|   19.637|     19.966|     16.893|        0.533| -0.841|    1.082|       1.332|
|444  |img_sb_50_5  |  44| 343.568| 356.701|  278|     257|        51|       9.009|      7.684|     10.000|     0.609|        1.301|    18.019|   15.369|   19.999|     20.511|     17.265|        0.540| -1.039|    1.082|       1.343|
|454  |img_sb_50_5  |  45| 493.621| 453.330|  261|     244|        51|       8.702|      7.459|     10.005|     0.633|        1.341|    17.404|   14.919|   20.009|     19.903|     16.725|        0.542| -0.912|    1.070|       1.261|
|464  |img_sb_50_5  |  46| 555.808| 431.780|  245|     225|        48|       8.382|      7.667|      9.087|     0.373|        1.185|    16.764|   15.335|   18.175|     18.331|     17.018|        0.372| -0.536|    1.089|       1.336|
|474  |img_sb_50_5  |  47| 386.514| 244.968|  249|     227|        48|       8.458|      7.845|      9.025|     0.316|        1.150|    16.917|   15.690|   18.051|     18.492|     17.122|        0.378|  0.476|    1.097|       1.358|
|484  |img_sb_50_5  |  48| 626.713| 332.502|  265|     253|        51|       8.764|      7.475|      9.832|     0.597|        1.315|    17.527|   14.951|   19.664|     19.403|     17.547|        0.427|  1.182|    1.047|       1.280|
|494  |img_sb_50_5  |  49| 544.752| 324.793|  242|     221|        47|       8.344|      7.441|      9.278|     0.447|        1.247|    16.687|   14.883|   18.556|     18.668|     16.500|        0.468|  0.635|    1.095|       1.377|
|504  |img_sb_50_5  |  50| 484.276| 439.346|  246|     227|        49|       8.397|      7.411|      9.160|     0.408|        1.236|    16.795|   14.823|   18.320|     18.435|     17.008|        0.386| -1.504|    1.084|       1.288|
|5110 |img_sb_50_5  |  51| 320.081| 426.332|  283|     261|        54|       9.105|      7.373|     11.157|     1.057|        1.513|    18.211|   14.746|   22.314|     22.022|     16.374|        0.669| -1.181|    1.084|       1.220|
|524  |img_sb_50_5  |  52| 319.141| 445.336|  241|     222|        48|       8.316|      7.383|      9.227|     0.430|        1.250|    16.633|   14.766|   18.453|     18.397|     16.712|        0.418| -1.007|    1.086|       1.314|
|534  |img_sb_50_5  |  53| 493.354| 308.000|  229|     210|        47|       8.081|      7.282|      8.798|     0.364|        1.208|    16.163|   14.564|   17.597|     17.309|     16.864|        0.225| -1.353|    1.090|       1.303|
|544  |img_sb_50_5  |  54| 578.883| 319.339|  257|     239|        50|       8.619|      7.293|     10.063|     0.669|        1.380|    17.238|   14.586|   20.126|     19.902|     16.452|        0.563| -0.453|    1.075|       1.292|
|554  |img_sb_50_5  |  55| 405.946| 368.581|  241|     222|        48|       8.309|      7.478|      9.046|     0.427|        1.210|    16.619|   14.956|   18.093|     18.518|     16.566|        0.447|  0.890|    1.086|       1.314|
|564  |img_sb_50_5  |  56| 494.897| 292.206|  252|     237|        51|       8.513|      6.726|     10.294|     0.933|        1.531|    17.025|   13.451|   20.587|     20.439|     15.755|        0.637|  0.087|    1.063|       1.218|
|574  |img_sb_50_5  |  57| 378.448| 210.429|  252|     233|        49|       8.505|      7.461|      9.696|     0.563|        1.300|    17.010|   14.923|   19.393|     19.018|     16.928|        0.456|  0.017|    1.082|       1.319|
|584  |img_sb_50_5  |  58| 366.053| 226.549|  226|     205|        46|       8.022|      7.478|      8.704|     0.295|        1.164|    16.045|   14.957|   17.407|     17.437|     16.481|        0.327|  0.127|    1.102|       1.342|
|594  |img_sb_50_5  |  59| 339.395| 305.517|  238|     217|        48|       8.244|      7.428|      9.149|     0.454|        1.232|    16.487|   14.855|   18.299|     18.454|     16.412|        0.457| -1.385|    1.097|       1.298|
|604  |img_sb_50_5  |  60| 257.492| 242.197|  264|     242|        51|       8.713|      7.415|      9.908|     0.766|        1.336|    17.426|   14.831|   19.816|     20.390|     16.481|        0.589|  1.539|    1.091|       1.275|
|6110 |img_sb_50_5  |  61| 440.867| 166.522|  249|     229|        50|       8.474|      7.114|      9.715|     0.766|        1.366|    16.947|   14.228|   19.429|     19.960|     15.893|        0.605|  0.395|    1.087|       1.252|
|624  |img_sb_50_5  |  62| 462.085| 279.513|  234|     222|        48|       8.180|      6.724|      9.546|     0.574|        1.420|    16.361|   13.448|   19.092|     18.282|     16.389|        0.443| -1.236|    1.054|       1.276|
|634  |img_sb_50_5  |  63| 462.850| 424.688|  234|     218|        48|       8.166|      6.439|      9.550|     0.718|        1.483|    16.333|   12.878|   19.101|     18.827|     15.949|        0.531|  0.470|    1.073|       1.276|
|644  |img_sb_50_5  |  64| 394.067| 228.933|  223|     208|        46|       7.977|      7.023|      9.265|     0.519|        1.319|    15.954|   14.045|   18.530|     17.659|     16.191|        0.399|  0.707|    1.072|       1.324|
|654  |img_sb_50_5  |  65| 422.412| 343.037|  216|     198|        46|       7.863|      6.758|      8.847|     0.475|        1.309|    15.726|   13.515|   17.694|     17.745|     15.509|        0.486|  0.842|    1.091|       1.283|
|664  |img_sb_50_5  |  66| 321.253| 194.188|  261|     248|        52|       8.679|      6.552|     10.381|     0.978|        1.584|    17.358|   13.104|   20.763|     20.765|     16.132|        0.630| -1.308|    1.052|       1.213|
|674  |img_sb_50_5  |  67| 481.853| 491.868|  190|     171|        43|       7.308|      6.816|      7.853|     0.295|        1.152|    14.616|   13.632|   15.706|     15.770|     15.340|        0.232| -0.683|    1.111|       1.291|
|684  |img_sb_50_5  |  68| 445.459| 146.500|  220|     205|        47|       7.911|      6.651|      9.230|     0.698|        1.388|    15.822|   13.301|   18.459|     18.492|     15.193|        0.570| -1.319|    1.073|       1.252|
|694  |img_sb_50_5  |  69| 387.915| 407.603|  199|     180|        44|       7.496|      6.879|      8.321|     0.372|        1.210|    14.993|   13.759|   16.641|     16.610|     15.259|        0.395|  0.957|    1.106|       1.292|
|704  |img_sb_50_5  |  70| 358.872| 375.948|  172|     157|        41|       6.938|      5.970|      7.831|     0.430|        1.312|    13.875|   11.939|   15.661|     15.622|     14.037|        0.439|  0.113|    1.096|       1.286|
|129  |img_sb_50_6  |   1| 569.890| 329.134|  283|     261|        52|       9.045|      7.923|     10.345|     0.718|        1.306|    18.091|   15.847|   20.689|     20.891|     17.243|        0.565| -1.552|    1.084|       1.315|
|228  |img_sb_50_6  |   2| 419.817| 200.960|  252|     230|        49|       8.502|      7.878|      9.267|     0.371|        1.176|    17.003|   15.755|   18.533|     18.389|     17.453|        0.315| -0.279|    1.096|       1.319|
|325  |img_sb_50_6  |   3| 574.313| 239.916|  297|     276|        54|       9.273|      7.861|     10.568|     0.697|        1.344|    18.546|   15.723|   21.137|     21.140|     17.920|        0.531| -0.318|    1.076|       1.280|
|425  |img_sb_50_6  |   4| 585.361| 270.740|  269|     249|        51|       8.806|      7.931|      9.636|     0.461|        1.215|    17.612|   15.863|   19.272|     19.613|     17.462|        0.455| -0.882|    1.080|       1.300|
|525  |img_sb_50_6  |   5| 339.351| 453.139|  288|     266|        53|       9.126|      7.842|     10.723|     0.786|        1.367|    18.251|   15.684|   21.447|     21.230|     17.271|        0.581| -0.092|    1.083|       1.288|
|625  |img_sb_50_6  |   6| 439.125| 185.343|  289|     270|        53|       9.176|      8.056|     10.355|     0.601|        1.285|    18.351|   16.112|   20.710|     20.813|     17.683|        0.527|  0.979|    1.070|       1.293|
|724  |img_sb_50_6  |   7| 558.623| 511.214|  257|     236|        49|       8.592|      7.908|      9.468|     0.328|        1.197|    17.184|   15.816|   18.935|     18.607|     17.583|        0.327| -0.315|    1.089|       1.345|
|819  |img_sb_50_6  |   8| 322.771| 366.742|  271|     251|        51|       8.844|      7.774|      9.993|     0.535|        1.285|    17.688|   15.548|   19.987|     19.904|     17.349|        0.490|  0.546|    1.080|       1.309|
|917  |img_sb_50_6  |   9| 293.912| 204.077|  261|     242|        50|       8.673|      7.595|     10.006|     0.578|        1.317|    17.346|   15.190|   20.012|     19.696|     16.875|        0.516| -1.398|    1.079|       1.312|
|108  |img_sb_50_6  |  10| 563.431| 359.208|  260|     238|        49|       8.650|      7.847|      9.364|     0.337|        1.193|    17.301|   15.693|   18.729|     18.771|     17.634|        0.343|  0.814|    1.092|       1.361|
|1113 |img_sb_50_6  |  11| 494.179| 406.146|  268|     248|        51|       8.786|      7.505|      9.959|     0.634|        1.327|    17.572|   15.010|   19.919|     20.105|     16.977|        0.536| -0.143|    1.081|       1.295|
|1210 |img_sb_50_6  |  12| 251.605| 311.407|  263|     242|        50|       8.694|      7.988|      9.603|     0.379|        1.202|    17.388|   15.976|   19.205|     19.086|     17.543|        0.394|  0.805|    1.087|       1.322|
|138  |img_sb_50_6  |  13| 529.332| 324.004|  274|     254|        52|       8.898|      7.607|     10.295|     0.715|        1.353|    17.795|   15.213|   20.589|     20.565|     16.987|        0.564| -0.896|    1.079|       1.273|
|148  |img_sb_50_6  |  14| 403.401| 430.740|  269|     252|        51|       8.815|      7.907|      9.893|     0.498|        1.251|    17.630|   15.814|   19.786|     19.643|     17.453|        0.459|  0.974|    1.067|       1.300|
|158  |img_sb_50_6  |  15| 406.920| 291.004|  263|     244|        50|       8.700|      7.600|      9.960|     0.518|        1.311|    17.400|   15.200|   19.920|     19.581|     17.095|        0.488|  0.316|    1.078|       1.322|
|167  |img_sb_50_6  |  16| 550.171| 155.872|  281|     261|        52|       9.003|      7.717|     10.138|     0.687|        1.314|    18.006|   15.434|   20.276|     20.706|     17.272|        0.552|  0.052|    1.077|       1.306|
|177  |img_sb_50_6  |  17| 338.066| 430.031|  259|     238|        50|       8.630|      7.600|      9.449|     0.499|        1.243|    17.259|   15.200|   18.898|     19.403|     16.987|        0.483|  0.313|    1.088|       1.302|
|187  |img_sb_50_6  |  18| 637.633| 350.090|  267|     247|        50|       8.783|      8.000|      9.700|     0.409|        1.212|    17.567|   16.001|   19.400|     19.218|     17.711|        0.388|  0.808|    1.081|       1.342|
|197  |img_sb_50_6  |  19| 545.525| 327.736|  261|     245|        51|       8.678|      6.406|     10.349|     0.828|        1.616|    17.355|   12.812|   20.697|     20.242|     16.509|        0.579| -0.942|    1.065|       1.261|
|207  |img_sb_50_6  |  20| 627.241| 281.322|  270|     250|        51|       8.842|      7.696|     10.169|     0.639|        1.321|    17.685|   15.392|   20.338|     20.297|     16.950|        0.550| -0.873|    1.080|       1.304|
|2112 |img_sb_50_6  |  21| 660.466| 307.227|  247|     228|        48|       8.427|      7.571|      9.096|     0.384|        1.201|    16.855|   15.141|   18.191|     18.552|     16.951|        0.406| -0.511|    1.083|       1.347|
|229  |img_sb_50_6  |  22| 325.488| 268.331|  248|     227|        48|       8.433|      7.641|      9.241|     0.356|        1.209|    16.865|   15.283|   18.481|     18.324|     17.239|        0.339| -0.205|    1.093|       1.353|
|237  |img_sb_50_6  |  23| 573.179| 489.328|  262|     243|        50|       8.706|      7.607|      9.955|     0.573|        1.309|    17.411|   15.214|   19.910|     19.785|     16.856|        0.524| -0.530|    1.078|       1.317|
|246  |img_sb_50_6  |  24| 543.921| 490.762|  239|     221|        48|       8.271|      7.522|      8.961|     0.388|        1.191|    16.542|   15.045|   17.921|     18.284|     16.634|        0.415|  0.903|    1.081|       1.304|
|256  |img_sb_50_6  |  25| 564.582| 539.912|  249|     230|        48|       8.458|      7.600|      9.269|     0.441|        1.220|    16.915|   15.199|   18.539|     18.774|     16.894|        0.436| -0.823|    1.083|       1.358|
|266  |img_sb_50_6  |  26| 593.141| 245.369|  263|     247|        50|       8.713|      7.440|     10.023|     0.540|        1.347|    17.426|   14.879|   20.047|     19.371|     17.348|        0.445|  0.129|    1.065|       1.322|
|276  |img_sb_50_6  |  27| 575.556| 212.109|  248|     228|        49|       8.424|      7.538|      9.213|     0.420|        1.222|    16.848|   15.076|   18.426|     18.634|     16.947|        0.416| -0.170|    1.088|       1.298|
|286  |img_sb_50_6  |  28| 273.766| 311.821|  252|     233|        49|       8.502|      7.459|      9.308|     0.441|        1.248|    17.004|   14.919|   18.616|     18.865|     17.009|        0.432|  1.424|    1.082|       1.319|
|296  |img_sb_50_6  |  29| 334.996| 306.416|  262|     243|        50|       8.700|      7.464|      9.759|     0.645|        1.307|    17.400|   14.928|   19.518|     20.039|     16.646|        0.557| -0.667|    1.078|       1.317|
|305  |img_sb_50_6  |  30| 373.272| 427.000|  228|     209|        47|       8.090|      7.073|      8.996|     0.453|        1.272|    16.179|   14.147|   17.992|     17.887|     16.261|        0.417|  0.669|    1.091|       1.297|
|3111 |img_sb_50_6  |  31| 236.738| 320.392|  240|     227|        48|       8.290|      7.618|      9.275|     0.438|        1.218|    16.581|   15.236|   18.551|     18.237|     16.799|        0.389| -0.538|    1.057|       1.309|
|326  |img_sb_50_6  |  32| 374.707| 459.054|  239|     221|        48|       8.266|      7.508|      9.078|     0.409|        1.209|    16.531|   15.016|   18.156|     18.309|     16.621|        0.419| -0.703|    1.081|       1.304|
|335  |img_sb_50_6  |  33| 435.320| 325.576|  250|     230|        48|       8.500|      7.459|      9.564|     0.571|        1.282|    17.000|   14.918|   19.128|     19.317|     16.498|        0.520|  0.706|    1.087|       1.364|
|345  |img_sb_50_6  |  34| 278.881| 344.925|  227|     208|        46|       8.055|      7.108|      8.886|     0.387|        1.250|    16.111|   14.216|   17.772|     17.803|     16.234|        0.410|  0.510|    1.091|       1.348|
|355  |img_sb_50_6  |  35| 250.854| 227.917|  240|     223|        48|       8.314|      7.039|      9.414|     0.659|        1.337|    16.628|   14.078|   18.829|     19.247|     15.882|        0.565|  0.482|    1.076|       1.309|
|365  |img_sb_50_6  |  36| 416.674| 377.629|  267|     248|        51|       8.765|      7.476|      9.923|     0.702|        1.327|    17.529|   14.951|   19.847|     20.218|     16.825|        0.555|  0.133|    1.077|       1.290|
|375  |img_sb_50_6  |  37| 568.156| 413.013|  237|     221|        47|       8.237|      6.883|      9.577|     0.675|        1.391|    16.475|   13.765|   19.153|     18.996|     15.918|        0.546| -1.476|    1.072|       1.348|
|385  |img_sb_50_6  |  38| 466.355| 351.538|  251|     231|        48|       8.519|      7.441|      9.639|     0.575|        1.295|    17.039|   14.881|   19.277|     19.472|     16.405|        0.539|  0.876|    1.087|       1.369|
|395  |img_sb_50_6  |  39| 619.917| 348.498|  241|     223|        47|       8.332|      7.322|      9.709|     0.469|        1.326|    16.665|   14.643|   19.418|     18.516|     16.604|        0.443|  1.146|    1.081|       1.371|
|405  |img_sb_50_6  |  40| 423.556| 337.043|  234|     217|        46|       8.188|      7.061|      9.717|     0.576|        1.376|    16.376|   14.122|   19.435|     18.502|     16.151|        0.488| -0.095|    1.078|       1.390|
|4111 |img_sb_50_6  |  41| 338.642| 349.406|  229|     209|        46|       8.095|      7.254|      8.748|     0.404|        1.206|    16.190|   14.507|   17.496|     17.791|     16.404|        0.387| -1.530|    1.096|       1.360|
|426  |img_sb_50_6  |  42| 452.204| 460.407|  221|     200|        45|       7.937|      7.337|      8.599|     0.326|        1.172|    15.875|   14.673|   17.197|     17.344|     16.211|        0.355|  0.469|    1.105|       1.371|
|435  |img_sb_50_6  |  43| 382.946| 228.705|  224|     203|        46|       7.992|      7.174|      8.848|     0.394|        1.233|    15.985|   14.348|   17.697|     17.728|     16.075|        0.422|  0.448|    1.103|       1.330|
|445  |img_sb_50_6  |  44| 540.464| 346.111|  235|     218|        48|       8.203|      7.216|      9.210|     0.545|        1.276|    16.405|   14.431|   18.419|     18.629|     16.081|        0.505|  1.163|    1.078|       1.282|
|455  |img_sb_50_6  |  45| 409.726| 483.909|  230|     211|        47|       8.112|      6.963|      9.211|     0.595|        1.323|    16.224|   13.926|   18.422|     18.580|     15.777|        0.528| -0.339|    1.090|       1.308|
|465  |img_sb_50_6  |  46| 347.814| 231.177|  226|     207|        46|       8.036|      7.125|      9.143|     0.498|        1.283|    16.071|   14.250|   18.286|     18.125|     15.882|        0.482|  1.262|    1.092|       1.342|
|475  |img_sb_50_6  |  47| 341.215| 366.553|  228|     209|        45|       8.088|      7.189|      8.897|     0.392|        1.238|    16.176|   14.377|   17.795|     17.505|     16.637|        0.311| -0.589|    1.091|       1.415|
|485  |img_sb_50_6  |  48| 552.965| 414.930|  229|     213|        47|       8.100|      6.958|      9.273|     0.697|        1.333|    16.201|   13.915|   18.546|     18.732|     15.635|        0.551|  1.447|    1.075|       1.303|
|495  |img_sb_50_6  |  49| 552.752| 444.858|  226|     206|        45|       8.060|      7.340|      8.809|     0.407|        1.200|    16.120|   14.679|   17.618|     17.989|     15.988|        0.458| -0.769|    1.097|       1.402|
|505  |img_sb_50_6  |  50| 493.004| 466.616|  237|     218|        46|       8.281|      6.987|      9.670|     0.620|        1.384|    16.563|   13.974|   19.340|     19.093|     15.808|        0.561| -0.972|    1.087|       1.407|
|5111 |img_sb_50_6  |  51| 453.653| 279.644|  225|     209|        46|       8.021|      7.097|      8.729|     0.374|        1.230|    16.042|   14.194|   17.458|     17.507|     16.391|        0.351| -0.575|    1.077|       1.336|
|526  |img_sb_50_6  |  52| 242.933| 335.818|  209|     192|        45|       7.701|      6.870|      8.801|     0.463|        1.281|    15.402|   13.739|   17.602|     17.282|     15.417|        0.452| -1.549|    1.089|       1.297|
|535  |img_sb_50_6  |  53| 496.995| 193.735|  215|     197|        46|       7.816|      6.825|      8.887|     0.495|        1.302|    15.631|   13.650|   17.773|     17.720|     15.450|        0.490|  0.469|    1.091|       1.277|
|545  |img_sb_50_6  |  54| 375.005| 329.970|  202|     184|        44|       7.593|      6.698|      8.584|     0.532|        1.282|    15.185|   13.396|   17.168|     17.452|     14.731|        0.536|  1.082|    1.098|       1.311|
|555  |img_sb_50_6  |  55| 307.687| 394.203|  217|     201|        46|       7.872|      6.337|      9.169|     0.694|        1.447|    15.744|   12.674|   18.338|     18.339|     15.139|        0.564|  1.230|    1.080|       1.289|
|565  |img_sb_50_6  |  56| 363.128| 438.118|  195|     178|        42|       7.439|      6.370|      8.299|     0.424|        1.303|    14.877|   12.741|   16.597|     16.616|     14.959|        0.435|  1.154|    1.096|       1.389|
|575  |img_sb_50_6  |  57| 359.276| 187.497|  199|     182|        43|       7.530|      6.464|      8.802|     0.573|        1.362|    15.060|   12.928|   17.605|     17.354|     14.612|        0.539| -1.196|    1.093|       1.352|
|585  |img_sb_50_6  |  58| 481.875| 503.653|  176|     159|        40|       7.043|      6.531|      7.749|     0.319|        1.187|    14.085|   13.061|   15.498|     15.283|     14.666|        0.281| -0.301|    1.107|       1.382|
|595  |img_sb_50_6  |  59| 408.377| 448.684|  215|     201|        49|       7.903|      5.768|      9.999|     1.245|        1.734|    15.807|   11.536|   19.999|     20.193|     13.644|        0.737|  1.289|    1.070|       1.125|
|605  |img_sb_50_6  |  60| 290.429| 481.981|  156|     142|        38|       6.634|      5.642|      7.532|     0.482|        1.335|    13.269|   11.284|   15.063|     15.338|     12.959|        0.535|  0.981|    1.099|       1.358|
|130  |img_sb_50_7  |   1| 579.277| 219.538|  314|     292|        56|       9.555|      8.162|     10.911|     0.738|        1.337|    19.111|   16.324|   21.821|     21.947|     18.224|        0.557| -0.211|    1.075|       1.258|
|230  |img_sb_50_7  |   2| 645.874| 331.089|  269|     249|        50|       8.803|      7.988|      9.481|     0.421|        1.187|    17.606|   15.976|   18.962|     19.153|     17.921|        0.353|  1.000|    1.080|       1.352|
|327  |img_sb_50_7  |   3| 591.119| 250.693|  277|     258|        51|       8.950|      8.052|      9.760|     0.448|        1.212|    17.900|   16.104|   19.521|     19.882|     17.733|        0.452| -0.749|    1.074|       1.338|
|427  |img_sb_50_7  |   4| 342.447| 441.352|  304|     286|        55|       9.380|      8.038|     10.659|     0.673|        1.326|    18.760|   16.077|   21.318|     21.399|     18.099|        0.534| -0.158|    1.063|       1.263|
|527  |img_sb_50_7  |   5| 576.200| 310.797|  295|     274|        53|       9.244|      7.867|     10.448|     0.718|        1.328|    18.488|   15.734|   20.895|     21.281|     17.646|        0.559| -1.531|    1.077|       1.320|
|626  |img_sb_50_7  |   6| 421.306| 181.984|  258|     237|        49|       8.608|      7.903|      9.246|     0.348|        1.170|    17.215|   15.806|   18.491|     18.628|     17.640|        0.321| -0.340|    1.089|       1.350|
|725  |img_sb_50_7  |   7| 409.086| 274.034|  268|     244|        50|       8.787|      7.980|      9.804|     0.488|        1.229|    17.575|   15.960|   19.608|     19.681|     17.322|        0.475|  0.301|    1.098|       1.347|
|820  |img_sb_50_7  |   8| 325.705| 252.146|  254|     232|        49|       8.532|      7.822|      9.282|     0.350|        1.187|    17.065|   15.643|   18.564|     18.550|     17.435|        0.342| -0.348|    1.095|       1.329|
|918  |img_sb_50_7  |   9| 440.736| 165.692|  299|     276|        53|       9.346|      8.143|     10.445|     0.602|        1.283|    18.692|   16.286|   20.890|     21.212|     17.944|        0.533|  0.971|    1.083|       1.338|
|109  |img_sb_50_7  |  10| 570.211| 341.283|  265|     246|        50|       8.735|      8.089|      9.419|     0.371|        1.164|    17.470|   16.179|   18.838|     19.000|     17.761|        0.355|  0.777|    1.077|       1.332|
|1114 |img_sb_50_7  |  11| 567.827| 497.467|  272|     252|        51|       8.851|      7.936|      9.492|     0.347|        1.196|    17.701|   15.872|   18.984|     19.204|     18.032|        0.344| -0.223|    1.079|       1.314|
|1211 |img_sb_50_7  |  12| 598.616| 224.867|  263|     244|        50|       8.714|      7.755|      9.638|     0.524|        1.243|    17.427|   15.510|   19.277|     19.495|     17.193|        0.471|  0.098|    1.078|       1.322|
|139  |img_sb_50_7  |  13| 633.750| 261.029|  280|     261|        52|       9.000|      7.914|     10.231|     0.653|        1.293|    18.000|   15.828|   20.462|     20.650|     17.267|        0.548| -0.890|    1.073|       1.301|
|149  |img_sb_50_7  |  14| 407.719| 417.274|  281|     261|        53|       9.043|      8.009|     10.432|     0.632|        1.303|    18.087|   16.017|   20.863|     20.452|     17.532|        0.515|  1.043|    1.077|       1.257|
|159  |img_sb_50_7  |  15| 324.143| 352.710|  279|     258|        51|       8.991|      7.971|     10.566|     0.618|        1.326|    17.983|   15.942|   21.132|     20.398|     17.434|        0.519|  0.510|    1.081|       1.348|
|168  |img_sb_50_7  |  16| 534.505| 306.047|  275|     255|        53|       8.924|      7.447|     10.346|     0.773|        1.389|    17.849|   14.894|   20.692|     20.886|     16.770|        0.596| -0.945|    1.078|       1.230|
|178  |img_sb_50_7  |  17| 553.144| 134.182|  291|     269|        53|       9.168|      7.795|     10.425|     0.779|        1.337|    18.336|   15.589|   20.850|     21.329|     17.367|        0.580|  0.065|    1.082|       1.302|
|188  |img_sb_50_7  |  18| 579.922| 191.144|  257|     236|        49|       8.601|      7.716|      9.440|     0.449|        1.223|    17.202|   15.432|   18.879|     19.148|     17.074|        0.453| -0.166|    1.089|       1.345|
|198  |img_sb_50_7  |  19| 668.173| 287.039|  255|     236|        50|       8.556|      7.674|      9.398|     0.474|        1.225|    17.112|   15.348|   18.797|     19.166|     16.936|        0.468| -0.455|    1.081|       1.282|
|208  |img_sb_50_7  |  20| 574.410| 526.797|  266|     248|        51|       8.748|      7.844|      9.628|     0.467|        1.227|    17.496|   15.688|   19.257|     19.473|     17.400|        0.449| -0.808|    1.073|       1.285|
|2113 |img_sb_50_7  |  21| 340.875| 417.495|  273|     253|        52|       8.873|      7.591|     10.037|     0.539|        1.322|    17.746|   15.181|   20.073|     19.949|     17.444|        0.485|  0.403|    1.079|       1.269|
|2210 |img_sb_50_7  |  22| 275.117| 301.473|  256|     234|        48|       8.594|      7.761|      9.402|     0.393|        1.211|    17.189|   15.522|   18.804|     18.932|     17.215|        0.416|  0.962|    1.094|       1.396|
|238  |img_sb_50_7  |  23| 551.188| 309.495|  277|     260|        53|       8.951|      7.395|     10.247|     0.688|        1.386|    17.903|   14.790|   20.494|     20.283|     17.475|        0.508| -0.809|    1.065|       1.239|
|247  |img_sb_50_7  |  24| 582.476| 474.790|  271|     252|        50|       8.872|      7.608|      9.946|     0.638|        1.307|    17.744|   15.216|   19.892|     20.309|     16.996|        0.547| -0.502|    1.075|       1.362|
|257  |img_sb_50_7  |  25| 552.466| 476.703|  249|     230|        48|       8.464|      7.567|      9.175|     0.410|        1.212|    16.928|   15.134|   18.349|     18.660|     16.995|        0.413|  0.927|    1.083|       1.358|
|267  |img_sb_50_7  |  26| 470.816| 335.100|  261|     246|        51|       8.692|      7.547|      9.952|     0.631|        1.319|    17.384|   15.093|   19.905|     19.909|     16.710|        0.544|  0.845|    1.061|       1.261|
|277  |img_sb_50_7  |  27| 377.039| 413.804|  230|     209|        46|       8.143|      7.288|      9.086|     0.453|        1.247|    16.285|   14.577|   18.172|     18.249|     16.051|        0.476|  0.740|    1.100|       1.366|
|287  |img_sb_50_7  |  28| 575.842| 396.544|  259|     240|        50|       8.634|      7.364|      9.957|     0.598|        1.352|    17.267|   14.727|   19.914|     19.382|     17.093|        0.471| -1.401|    1.079|       1.302|
|297  |img_sb_50_7  |  29| 335.955| 290.981|  268|     251|        51|       8.823|      7.645|     10.025|     0.688|        1.311|    17.647|   15.289|   20.050|     20.397|     16.737|        0.572| -0.644|    1.068|       1.295|
|306  |img_sb_50_7  |  30| 378.661| 446.865|  251|     230|        49|       8.489|      7.822|      9.323|     0.400|        1.192|    16.979|   15.643|   18.645|     18.760|     17.032|        0.419| -0.610|    1.091|       1.314|
|3112 |img_sb_50_7  |  31| 546.371| 328.387|  248|     230|        49|       8.456|      7.311|      9.492|     0.581|        1.298|    16.912|   14.621|   18.984|     19.173|     16.518|        0.508|  1.086|    1.078|       1.298|
|328  |img_sb_50_7  |  32| 278.051| 324.161|  236|     218|        48|       8.210|      7.380|      9.044|     0.389|        1.225|    16.420|   14.761|   18.089|     17.963|     16.753|        0.361|  0.019|    1.083|       1.287|
|336  |img_sb_50_7  |  33| 340.306| 334.983|  232|     214|        46|       8.150|      7.530|      9.104|     0.333|        1.209|    16.301|   15.060|   18.207|     17.599|     16.800|        0.298| -1.524|    1.084|       1.378|
|346  |img_sb_50_7  |  34| 560.738| 429.540|  237|     221|        47|       8.253|      7.437|      9.060|     0.438|        1.218|    16.506|   14.874|   18.119|     18.283|     16.529|        0.427| -0.623|    1.072|       1.348|
|356  |img_sb_50_7  |  35| 348.158| 213.765|  234|     216|        47|       8.178|      7.297|      9.072|     0.421|        1.243|    16.356|   14.593|   18.144|     18.164|     16.405|        0.429|  1.216|    1.083|       1.331|
|366  |img_sb_50_7  |  36| 500.128| 390.584|  274|     256|        52|       8.889|      7.502|     10.266|     0.793|        1.368|    17.778|   15.003|   20.532|     20.794|     16.791|        0.590| -0.137|    1.070|       1.273|
|376  |img_sb_50_7  |  37| 456.794| 261.820|  233|     213|        47|       8.153|      7.357|      8.680|     0.330|        1.180|    16.306|   14.714|   17.359|     17.680|     16.784|        0.314| -0.634|    1.094|       1.325|
|386  |img_sb_50_7  |  38| 426.901| 320.926|  242|     224|        47|       8.343|      6.960|      9.395|     0.603|        1.350|    16.686|   13.919|   18.790|     18.931|     16.315|        0.507|  0.025|    1.080|       1.377|
|396  |img_sb_50_7  |  39| 438.683| 309.171|  252|     234|        49|       8.504|      7.517|      9.538|     0.516|        1.269|    17.009|   15.035|   19.077|     18.999|     16.935|        0.453|  0.695|    1.077|       1.319|
|406  |img_sb_50_7  |  40| 627.960| 329.573|  248|     233|        49|       8.463|      6.741|      9.510|     0.569|        1.411|    16.926|   13.482|   19.020|     18.617|     17.107|        0.395|  0.993|    1.064|       1.298|
|4112 |img_sb_50_7  |  41| 292.530| 186.655|  264|     244|        50|       8.721|      7.472|     10.063|     0.716|        1.347|    17.442|   14.944|   20.126|     20.202|     16.642|        0.567| -1.441|    1.082|       1.327|
|428  |img_sb_50_7  |  42| 499.992| 452.719|  249|     230|        49|       8.491|      7.267|      9.731|     0.670|        1.339|    16.981|   14.534|   19.461|     19.699|     16.086|        0.577| -0.983|    1.083|       1.303|
|436  |img_sb_50_7  |  43| 343.274| 352.195|  241|     228|        48|       8.327|      6.876|      9.316|     0.502|        1.355|    16.654|   13.752|   18.631|     18.196|     16.984|        0.359| -0.647|    1.057|       1.314|
|446  |img_sb_50_7  |  44| 305.979| 383.260|  235|     217|        47|       8.217|      7.028|      8.971|     0.449|        1.276|    16.433|   14.056|   17.942|     18.352|     16.307|        0.459|  1.007|    1.083|       1.337|
|456  |img_sb_50_7  |  45| 420.522| 362.507|  276|     256|        53|       8.908|      7.407|     10.258|     0.752|        1.385|    17.815|   14.814|   20.515|     20.638|     17.057|        0.563|  0.073|    1.078|       1.235|
|466  |img_sb_50_7  |  46| 366.824| 425.259|  205|     187|        43|       7.638|      6.864|      8.575|     0.359|        1.249|    15.277|   13.727|   17.150|     16.632|     15.721|        0.326|  1.300|    1.096|       1.393|
|476  |img_sb_50_7  |  47| 560.130| 398.634|  238|     217|        47|       8.262|      6.836|      9.772|     0.831|        1.429|    16.523|   13.673|   19.545|     19.648|     15.418|        0.620|  1.514|    1.097|       1.354|
|486  |img_sb_50_7  |  48| 458.091| 446.684|  231|     212|        47|       8.112|      7.300|      8.913|     0.368|        1.221|    16.224|   14.601|   17.826|     17.727|     16.600|        0.351|  0.422|    1.090|       1.314|
|496  |img_sb_50_7  |  49| 383.742| 210.644|  233|     212|        47|       8.170|      7.323|      8.979|     0.452|        1.226|    16.340|   14.646|   17.958|     18.283|     16.227|        0.461|  0.378|    1.099|       1.325|
|506  |img_sb_50_7  |  50| 415.262| 471.675|  240|     220|        47|       8.306|      7.303|      9.326|     0.513|        1.277|    16.613|   14.606|   18.652|     18.766|     16.286|        0.497| -0.447|    1.091|       1.365|
|5112 |img_sb_50_7  |  51| 248.967| 211.847|  242|     225|        48|       8.356|      6.968|      9.520|     0.751|        1.366|    16.712|   13.936|   19.041|     19.649|     15.682|        0.603|  0.400|    1.076|       1.320|
|528  |img_sb_50_7  |  52| 359.125| 169.183|  208|     189|        45|       7.691|      6.558|      8.672|     0.522|        1.322|    15.381|   13.116|   17.344|     17.586|     15.052|        0.517| -1.211|    1.101|       1.291|
|536  |img_sb_50_7  |  53| 499.729| 173.569|  225|     207|        47|       8.014|      6.909|      8.907|     0.477|        1.289|    16.029|   13.818|   17.813|     18.032|     15.891|        0.473|  0.456|    1.087|       1.280|
|546  |img_sb_50_7  |  54| 377.614| 314.419|  210|     190|        45|       7.727|      6.737|      8.787|     0.509|        1.304|    15.454|   13.475|   17.574|     17.621|     15.178|        0.508|  0.920|    1.105|       1.303|
|556  |img_sb_50_7  |  55| 489.158| 490.956|  183|     164|        41|       7.181|      6.503|      7.816|     0.291|        1.202|    14.361|   13.005|   15.632|     15.588|     14.940|        0.285| -0.631|    1.116|       1.368|
|566  |img_sb_50_7  |  56| 412.986| 435.482|  218|     203|        47|       7.916|      5.912|      9.746|     1.114|        1.649|    15.832|   11.823|   19.493|     19.830|     14.061|        0.705|  1.267|    1.074|       1.240|
|576  |img_sb_50_7  |  57| 292.600| 471.587|  160|     143|        39|       6.692|      5.846|      7.621|     0.406|        1.304|    13.384|   11.693|   15.242|     15.204|     13.385|        0.474|  0.888|    1.119|       1.322|
|140  |img_sb_50_8  |   1| 407.836| 140.920|  324|     300|        56|       9.709|      8.690|     10.668|     0.569|        1.228|    19.419|   17.379|   21.335|     21.704|     19.016|        0.482| -1.258|    1.080|       1.298|
|239  |img_sb_50_8  |   2| 376.049| 397.674|  288|     269|        52|       9.131|      8.316|      9.981|     0.406|        1.200|    18.262|   16.631|   19.961|     19.952|     18.393|        0.387| -0.303|    1.071|       1.338|
|329  |img_sb_50_8  |   3| 616.251| 318.258|  283|     263|        52|       9.046|      8.260|      9.987|     0.426|        1.209|    18.093|   16.521|   19.973|     19.770|     18.254|        0.384|  0.778|    1.076|       1.315|
|429  |img_sb_50_8  |   4| 473.613| 366.213|  300|     281|        53|       9.330|      8.115|     10.623|     0.588|        1.309|    18.659|   16.231|   21.245|     20.885|     18.317|        0.480|  0.234|    1.068|       1.342|
|529  |img_sb_50_8  |   5| 529.046| 114.702|  302|     281|        54|       9.349|      7.883|     10.535|     0.716|        1.336|    18.698|   15.765|   21.070|     21.488|     17.891|        0.554|  0.025|    1.075|       1.301|
|627  |img_sb_50_8  |   6| 426.632| 138.706|  299|     275|        54|       9.302|      8.242|     10.354|     0.560|        1.256|    18.604|   16.485|   20.707|     20.813|     18.306|        0.476| -1.304|    1.087|       1.289|
|726  |img_sb_50_8  |   7| 341.391| 134.312|  276|     254|        51|       8.916|      8.338|      9.580|     0.312|        1.149|    17.833|   16.676|   19.160|     19.098|     18.401|        0.268| -0.954|    1.087|       1.333|
|823  |img_sb_50_8  |   8| 320.271| 265.757|  292|     273|        53|       9.197|      8.144|     10.066|     0.514|        1.236|    18.394|   16.287|   20.131|     20.565|     18.085|        0.476|  0.711|    1.070|       1.306|
|919  |img_sb_50_8  |   9| 296.369| 269.592|  287|     264|        52|       9.134|      7.985|     10.467|     0.633|        1.311|    18.269|   15.970|   20.935|     20.867|     17.503|        0.544|  0.472|    1.087|       1.334|
|1010 |img_sb_50_8  |  10| 470.594| 383.715|  288|     269|        52|       9.136|      7.714|     10.113|     0.538|        1.311|    18.272|   15.428|   20.227|     20.290|     18.107|        0.451|  0.409|    1.071|       1.338|
|1115 |img_sb_50_8  |  11| 433.946| 343.372|  298|     276|        53|       9.305|      8.154|     10.499|     0.659|        1.288|    18.611|   16.308|   20.997|     21.242|     17.857|        0.542|  0.342|    1.080|       1.333|
|1212 |img_sb_50_8  |  12| 418.701| 311.383|  274|     252|        51|       8.900|      8.129|      9.630|     0.379|        1.185|    17.800|   16.258|   19.261|     19.503|     17.886|        0.399| -0.639|    1.087|       1.324|
|1310 |img_sb_50_8  |  13| 297.850| 292.996|  266|     245|        51|       8.742|      7.889|      9.577|     0.458|        1.214|    17.484|   15.777|   19.154|     19.425|     17.436|        0.441|  0.286|    1.086|       1.285|
|1410 |img_sb_50_8  |  14| 453.163| 287.379|  306|     284|        55|       9.440|      8.255|     10.864|     0.630|        1.316|    18.879|   16.511|   21.728|     21.411|     18.219|        0.525| -0.917|    1.077|       1.271|
|1510 |img_sb_50_8  |  15| 531.087| 483.942|  275|     253|        51|       8.904|      7.942|      9.951|     0.440|        1.253|    17.807|   15.885|   19.902|     19.553|     17.924|        0.400| -0.323|    1.087|       1.329|
|169  |img_sb_50_8  |  16| 524.717| 180.280|  314|     295|        55|       9.584|      7.914|     11.048|     0.896|        1.396|    19.168|   15.828|   22.097|     22.552|     17.731|        0.618|  1.228|    1.064|       1.304|
|179  |img_sb_50_8  |  17| 546.599| 461.588|  284|     263|        52|       9.081|      7.979|     10.142|     0.586|        1.271|    18.161|   15.958|   20.283|     20.622|     17.524|        0.527| -0.501|    1.080|       1.320|
|189  |img_sb_50_8  |  18| 606.479| 246.703|  303|     283|        54|       9.422|      7.959|     10.672|     0.730|        1.341|    18.844|   15.918|   21.345|     21.745|     17.740|        0.578| -0.814|    1.071|       1.306|
|199  |img_sb_50_8  |  19| 415.599| 396.224|  277|     259|        52|       8.940|      7.826|      9.743|     0.496|        1.245|    17.879|   15.652|   19.487|     19.923|     17.709|        0.458|  0.027|    1.069|       1.287|
|209  |img_sb_50_8  |  20| 524.563| 209.793|  270|     249|        50|       8.833|      7.995|      9.679|     0.408|        1.211|    17.667|   15.991|   19.358|     19.480|     17.637|        0.425| -1.057|    1.084|       1.357|
|2114 |img_sb_50_8  |  21| 554.162| 173.507|  272|     252|        51|       8.856|      7.924|      9.553|     0.410|        1.206|    17.712|   15.849|   19.107|     19.477|     17.782|        0.408| -0.157|    1.079|       1.314|
|2211 |img_sb_50_8  |  22| 490.708| 220.863|  271|     252|        51|       8.837|      7.930|      9.725|     0.399|        1.226|    17.674|   15.860|   19.449|     19.345|     17.848|        0.386|  1.548|    1.075|       1.309|
|2310 |img_sb_50_8  |  23| 640.722| 274.421|  266|     247|        50|       8.756|      7.665|      9.697|     0.426|        1.265|    17.511|   15.330|   19.394|     19.309|     17.541|        0.418| -0.370|    1.077|       1.337|
|248  |img_sb_50_8  |  24| 386.328| 342.484|  287|     267|        53|       9.102|      7.589|     10.042|     0.623|        1.323|    18.205|   15.177|   20.083|     20.667|     17.696|        0.517|  0.161|    1.075|       1.284|
|258  |img_sb_50_8  |  25| 335.336| 184.233|  262|     246|        52|       8.670|      7.590|      9.607|     0.479|        1.266|    17.340|   15.179|   19.214|     19.129|     17.480|        0.406| -1.439|    1.065|       1.218|
|268  |img_sb_50_8  |  26| 321.860| 195.177|  265|     247|        51|       8.728|      7.598|      9.841|     0.521|        1.295|    17.456|   15.196|   19.682|     19.509|     17.310|        0.461|  0.496|    1.073|       1.280|
|278  |img_sb_50_8  |  27| 508.890| 259.212|  245|     224|        48|       8.405|      7.606|      9.333|     0.467|        1.227|    16.809|   15.212|   18.666|     18.851|     16.545|        0.479| -0.873|    1.094|       1.336|
|288  |img_sb_50_8  |  28| 597.977| 316.174|  265|     249|        50|       8.755|      7.229|      9.925|     0.566|        1.373|    17.509|   14.458|   19.849|     19.470|     17.429|        0.446|  1.092|    1.064|       1.332|
|298  |img_sb_50_8  |  29| 421.763| 429.054|  241|     221|        47|       8.313|      7.408|      9.099|     0.342|        1.228|    16.626|   14.816|   18.198|     18.137|     16.914|        0.361|  0.516|    1.090|       1.371|
|307  |img_sb_50_8  |  30| 536.638| 513.672|  268|     245|        51|       8.814|      8.029|      9.947|     0.518|        1.239|    17.629|   16.059|   19.894|     19.854|     17.189|        0.500| -0.762|    1.094|       1.295|
|3113 |img_sb_50_8  |  31| 243.313| 267.108|  249|     230|        48|       8.462|      7.629|      9.336|     0.400|        1.224|    16.925|   15.258|   18.672|     18.648|     17.008|        0.410|  0.747|    1.083|       1.358|
|3210 |img_sb_50_8  |  32| 441.373| 311.388|  268|     248|        49|       8.824|      7.462|      9.974|     0.616|        1.337|    17.647|   14.924|   19.948|     20.084|     17.002|        0.532| -0.404|    1.081|       1.403|
|337  |img_sb_50_8  |  33| 543.028| 381.881|  253|     233|        49|       8.544|      7.185|      9.872|     0.598|        1.374|    17.088|   14.370|   19.744|     19.504|     16.518|        0.532| -1.129|    1.086|       1.324|
|347  |img_sb_50_8  |  34| 463.890| 436.331|  254|     235|        49|       8.580|      7.235|      9.959|     0.687|        1.377|    17.160|   14.469|   19.917|     19.915|     16.245|        0.578| -1.023|    1.081|       1.329|
|357  |img_sb_50_8  |  35| 391.818| 454.672|  253|     234|        49|       8.525|      7.519|      9.521|     0.527|        1.266|    17.051|   15.038|   19.043|     19.244|     16.737|        0.494|  0.185|    1.081|       1.324|
|367  |img_sb_50_8  |  36| 486.707| 274.976|  246|     228|        48|       8.402|      7.526|      9.241|     0.473|        1.228|    16.804|   15.052|   18.481|     18.747|     16.722|        0.452|  1.106|    1.079|       1.342|
|377  |img_sb_50_8  |  37| 274.195| 371.921|  241|     223|        50|       8.346|      7.090|     10.194|     0.734|        1.438|    16.691|   14.181|   20.387|     19.356|     15.925|        0.568| -0.840|    1.081|       1.211|
|387  |img_sb_50_8  |  38| 281.123| 419.504|  236|     217|        47|       8.238|      6.989|      9.076|     0.451|        1.299|    16.476|   13.979|   18.153|     18.333|     16.408|        0.446| -1.164|    1.088|       1.343|
|397  |img_sb_50_8  |  39| 473.135| 153.143|  237|     217|        47|       8.251|      7.153|      9.202|     0.488|        1.286|    16.501|   14.305|   18.403|     18.574|     16.248|        0.484|  0.573|    1.092|       1.348|
|407  |img_sb_50_8  |  40| 466.490| 306.494|  251|     230|        50|       8.470|      7.373|      9.600|     0.563|        1.302|    16.940|   14.746|   19.200|     19.180|     16.695|        0.492| -0.392|    1.091|       1.262|
|4113 |img_sb_50_8  |  41| 551.896| 328.579|  259|     239|        50|       8.614|      7.535|      9.615|     0.547|        1.276|    17.228|   15.070|   19.231|     19.409|     17.002|        0.482|  0.113|    1.084|       1.302|
|4210 |img_sb_50_8  |  42| 272.575| 333.356|  233|     213|        47|       8.153|      7.390|      8.843|     0.387|        1.197|    16.306|   14.780|   17.687|     17.868|     16.617|        0.368|  1.410|    1.094|       1.325|
|437  |img_sb_50_8  |  43| 407.272| 285.463|  257|     237|        50|       8.591|      7.481|      9.996|     0.715|        1.336|    17.182|   14.962|   19.992|     19.978|     16.369|        0.573|  0.044|    1.084|       1.292|
|447  |img_sb_50_8  |  44| 284.464| 354.740|  235|     216|        47|       8.207|      7.408|      9.542|     0.543|        1.288|    16.415|   14.816|   19.084|     18.611|     16.099|        0.502| -1.150|    1.088|       1.337|
|457  |img_sb_50_8  |  45| 344.358| 292.177|  215|     197|        46|       7.835|      6.944|      9.120|     0.558|        1.313|    15.670|   13.887|   18.240|     17.980|     15.244|        0.530|  0.904|    1.091|       1.277|
|467  |img_sb_50_8  |  46| 324.713| 386.886|  202|     184|        44|       7.571|      6.830|      8.433|     0.406|        1.235|    15.142|   13.661|   16.865|     16.867|     15.260|        0.426|  0.665|    1.098|       1.311|
|477  |img_sb_50_8  |  47| 451.784| 474.758|  190|     176|        43|       7.313|      6.613|      7.861|     0.336|        1.189|    14.627|   13.225|   15.722|     15.945|     15.190|        0.304| -0.600|    1.080|       1.291|
|487  |img_sb_50_8  |  48| 376.628| 416.137|  226|     210|        50|       8.094|      5.560|     10.402|     1.278|        1.871|    16.188|   11.120|   20.803|     20.622|     14.066|        0.731|  1.308|    1.076|       1.136|
|150  |img_sb_50_9  |   1| 284.693| 363.818|  264|     242|        51|       8.703|      7.532|      9.507|     0.486|        1.262|    17.406|   15.064|   19.013|     19.047|     17.710|        0.368|  1.322|    1.091|       1.275|
|240  |img_sb_50_9  |   2| 339.391| 361.939|  279|     258|        53|       8.966|      7.620|      9.968|     0.652|        1.308|    17.932|   15.241|   19.935|     20.530|     17.310|        0.538| -0.095|    1.081|       1.248|
|330  |img_sb_50_9  |   3| 317.682| 418.894|  264|     244|        51|       8.698|      7.849|      9.647|     0.456|        1.229|    17.397|   15.697|   19.295|     19.281|     17.446|        0.426| -0.293|    1.082|       1.275|
|430  |img_sb_50_9  |   4| 417.476| 355.375|  267|     245|        51|       8.759|      7.794|      9.700|     0.404|        1.244|    17.518|   15.588|   19.399|     19.043|     17.878|        0.344|  0.624|    1.090|       1.290|
|530  |img_sb_50_9  |   5| 272.552| 349.517|  259|     239|        50|       8.627|      7.652|      9.600|     0.392|        1.254|    17.254|   15.305|   19.200|     18.978|     17.378|        0.402|  0.544|    1.084|       1.302|
|628  |img_sb_50_9  |   6| 407.470| 369.692|  266|     247|        51|       8.759|      7.558|      9.959|     0.650|        1.318|    17.519|   15.116|   19.918|     20.018|     16.937|        0.533|  0.224|    1.077|       1.285|
|727  |img_sb_50_9  |   7| 622.088| 315.523|  260|     242|        50|       8.650|      7.744|      9.567|     0.451|        1.235|    17.301|   15.488|   19.134|     18.901|     17.570|        0.369|  0.620|    1.074|       1.307|
|824  |img_sb_50_9  |   8| 238.600| 341.464|  265|     246|        51|       8.739|      7.822|      9.826|     0.491|        1.256|    17.478|   15.643|   19.652|     19.496|     17.323|        0.459| -0.724|    1.077|       1.280|
|920  |img_sb_50_9  |   9| 413.982| 280.607|  280|     257|        52|       8.995|      7.809|     10.343|     0.732|        1.325|    17.989|   15.618|   20.686|     20.887|     17.063|        0.577|  1.282|    1.089|       1.301|
|1011 |img_sb_50_9  |  10| 366.411| 163.554|  280|     260|        52|       9.019|      7.778|     10.149|     0.658|        1.305|    18.037|   15.556|   20.298|     20.702|     17.220|        0.555| -0.471|    1.077|       1.301|
|1116 |img_sb_50_9  |  11| 534.463| 189.220|  287|     267|        52|       9.165|      7.947|     10.483|     0.745|        1.319|    18.331|   15.894|   20.965|     21.287|     17.167|        0.591| -0.621|    1.075|       1.334|
|1213 |img_sb_50_9  |  12| 477.115| 164.514|  278|     260|        52|       9.011|      7.652|     10.382|     0.748|        1.357|    18.021|   15.305|   20.764|     20.930|     16.927|        0.588|  0.909|    1.069|       1.292|
|1311 |img_sb_50_9  |  13| 611.351| 247.299|  268|     248|        51|       8.808|      7.625|     10.095|     0.667|        1.324|    17.616|   15.249|   20.189|     20.319|     16.804|        0.562| -0.868|    1.081|       1.295|
|1411 |img_sb_50_9  |  14| 550.112| 505.220|  250|     229|        49|       8.471|      7.529|      9.559|     0.489|        1.270|    16.942|   15.057|   19.118|     19.054|     16.706|        0.481| -0.929|    1.092|       1.308|
|1511 |img_sb_50_9  |  15| 558.797| 454.506|  261|     243|        50|       8.668|      7.599|      9.981|     0.547|        1.313|    17.336|   15.198|   19.963|     19.567|     16.992|        0.496| -0.499|    1.074|       1.312|
|1610 |img_sb_50_9  |  16| 457.085| 342.735|  260|     239|        50|       8.650|      7.443|      9.740|     0.603|        1.309|    17.300|   14.885|   19.481|     19.722|     16.792|        0.524| -0.243|    1.088|       1.307|
|1710 |img_sb_50_9  |  17| 544.188| 476.635|  260|     241|        49|       8.655|      7.645|      9.474|     0.435|        1.239|    17.311|   15.290|   18.948|     19.109|     17.333|        0.421| -0.176|    1.079|       1.361|
|1810 |img_sb_50_9  |  18| 251.726| 290.111|  252|     233|        49|       8.503|      7.441|      9.439|     0.526|        1.269|    17.006|   14.881|   18.878|     19.180|     16.728|        0.489| -1.411|    1.082|       1.319|
|1910 |img_sb_50_9  |  19| 416.344| 145.195|  262|     241|        50|       8.680|      7.501|     10.017|     0.594|        1.335|    17.360|   15.001|   20.034|     19.702|     16.945|        0.510| -1.253|    1.087|       1.317|
|2010 |img_sb_50_9  |  20| 644.498| 272.988|  243|     224|        48|       8.344|      7.426|      9.034|     0.415|        1.216|    16.688|   14.852|   18.067|     18.551|     16.667|        0.439| -0.454|    1.085|       1.325|
|2115 |img_sb_50_9  |  21| 398.944| 261.316|  234|     214|        48|       8.171|      7.262|      8.951|     0.400|        1.232|    16.342|   14.525|   17.901|     18.034|     16.530|        0.400| -0.515|    1.093|       1.276|
|2212 |img_sb_50_9  |  22| 560.445| 327.042|  238|     220|        48|       8.253|      7.134|      9.027|     0.498|        1.265|    16.505|   14.268|   18.053|     18.581|     16.314|        0.479|  0.205|    1.082|       1.298|
|2311 |img_sb_50_9  |  23| 321.072| 513.232|  237|     217|        49|       8.233|      7.390|      9.275|     0.450|        1.255|    16.466|   14.780|   18.549|     18.396|     16.411|        0.452| -0.759|    1.092|       1.240|
|249  |img_sb_50_9  |  24| 338.026| 384.803|  234|     215|        48|       8.182|      7.366|      9.032|     0.373|        1.226|    16.364|   14.731|   18.065|     17.959|     16.600|        0.382|  0.855|    1.088|       1.276|
|259  |img_sb_50_9  |  25| 458.653| 441.037|  245|     223|        48|       8.405|      6.923|      9.925|     0.798|        1.434|    16.810|   13.846|   19.851|     19.905|     15.673|        0.616|  1.141|    1.099|       1.336|
|269  |img_sb_50_9  |  26| 604.586| 313.808|  239|     222|        47|       8.288|      7.203|      9.343|     0.527|        1.297|    16.576|   14.406|   18.686|     18.554|     16.448|        0.463|  1.341|    1.077|       1.360|
|279  |img_sb_50_9  |  27| 559.918| 178.365|  244|     225|        49|       8.359|      7.329|      9.279|     0.547|        1.266|    16.717|   14.658|   18.558|     18.961|     16.385|        0.503| -0.094|    1.084|       1.277|
|289  |img_sb_50_9  |  28| 552.764| 378.249|  225|     204|        47|       8.007|      7.085|      8.963|     0.512|        1.265|    16.015|   14.170|   17.927|     18.146|     15.804|        0.491| -0.576|    1.103|       1.280|
|299  |img_sb_50_9  |  29| 254.733| 335.041|  217|     201|        46|       7.855|      6.658|      8.806|     0.450|        1.323|    15.711|   13.316|   17.612|     17.383|     15.933|        0.400| -1.323|    1.080|       1.289|
|308  |img_sb_50_9  |  30| 496.447| 277.167|  228|     209|        47|       8.071|      7.218|      9.008|     0.477|        1.248|    16.142|   14.436|   18.016|     18.206|     15.944|        0.483|  1.028|    1.091|       1.297|
|3114 |img_sb_50_9  |  31| 422.122| 253.508|  238|     219|        48|       8.310|      6.990|      9.613|     0.682|        1.375|    16.619|   13.980|   19.225|     19.380|     15.631|        0.591|  0.972|    1.087|       1.298|
|3211 |img_sb_50_9  |  32| 518.335| 260.996|  227|     209|        47|       8.053|      7.198|      8.930|     0.485|        1.241|    16.106|   14.395|   17.860|     18.213|     15.862|        0.491| -0.882|    1.086|       1.291|
|338  |img_sb_50_9  |  33| 284.161| 190.090|  211|     192|        46|       7.738|      6.696|      8.656|     0.502|        1.293|    15.476|   13.391|   17.311|     17.546|     15.312|        0.488| -1.520|    1.099|       1.253|
|348  |img_sb_50_9  |  34| 256.424| 264.185|  238|     220|        48|       8.264|      6.773|      9.603|     0.787|        1.418|    16.528|   13.547|   19.205|     19.531|     15.526|        0.607| -1.389|    1.082|       1.298|
|358  |img_sb_50_9  |  35| 236.875| 405.975|  200|     181|        45|       7.520|      5.892|      9.201|     0.951|        1.561|    15.040|   11.785|   18.401|     18.600|     13.707|        0.676|  0.048|    1.105|       1.241|
|368  |img_sb_50_9  |  36| 467.801| 469.330|  176|     157|        41|       7.016|      6.297|      7.728|     0.360|        1.227|    14.032|   12.593|   15.456|     15.520|     14.445|        0.366| -0.422|    1.121|       1.316|



# Forma de objetos


A função `analyze_objects()` calcula uma gama de medidas que podem ser utilizadas para estudar a forma dos objetos, como por exemplo, folhas. Como exemplo, usarei a imagem `potato_leaves.png`, que foi coletada de [Gupta et al.(2020)](https://doi.org/10.1111/nph.16286)



```r
batata <- image_pliman("potato_leaves.jpg", plot = TRUE)

pot_meas <-
  analyze_objects(batata,
                  watershed = FALSE,
                  marker = "id",
                  show_chull = TRUE) # mostra o casco convex
```

<img src="/tutorials/pliman_lca/03_analyze_objects_files/figure-html/batata-1.png" width="960" />

```r
pot_meas$results %>% 
  print_tbl()
```



| id|       x|       y|  area| area_ch| perimeter| radius_mean| radius_min| radius_max| radius_sd| radius_ratio| diam_mean| diam_min| diam_max| major_axis| minor_axis| eccentricity|  theta| solidity| circularity|
|--:|-------:|-------:|-----:|-------:|---------:|-----------:|----------:|----------:|---------:|------------:|---------:|--------:|--------:|----------:|----------:|------------:|------:|--------:|-----------:|
|  1| 854.542| 224.043| 51380|   54536|       852|     131.565|     92.111|    198.025|    26.061|        2.150|   263.131|  184.222|  396.050|    305.737|    242.212|        0.610|  1.394|    0.942|       0.889|
|  2| 197.844| 217.851| 58923|   76706|      1064|     140.296|     70.106|    192.361|    28.585|        2.744|   280.592|  140.212|  384.723|    318.244|    274.128|        0.508| -0.099|    0.768|       0.654|
|  3| 536.210| 240.238| 35117|   62792|      1310|     109.900|     38.137|    188.511|    35.510|        4.943|   219.800|   76.273|  377.021|    253.498|    243.279|        0.281|  1.097|    0.559|       0.257|



As três medidas principais (em unidades de pixel) são:

1. `area` a área do objeto.
2. `area_ch` a área do casco convexo.
3. `perímetro` o perímetro do objeto.

Usando essas medidas, a circularidade e a solidez são calculadas conforme mostrado em (Gupta et al, 2020).

$$ circularidade = 4 \pi(area / perimeter ^ 2) $$





$$ solidez = area / area \\\_ch$$



A circularidade é influenciada por serrilhas e saliências. A solidez é sensível a folhas com lóbulos profundos ou com pecíolo distinto e pode ser usada para distinguir folhas sem tais estruturas. Ao contrário da circularidade, não é muito sensível a serrilhas e saliências menores, uma vez que o casco convexo permanece praticamente inalterado.

## Contorno do objeto

Os usuários também podem obter o contorno do objeto e o casco convexo da seguinte forma:




```r
cont <-
  object_contour(batata,
                 watershed = FALSE,
                 show_image = FALSE)

plot(batata)
plot_contour(cont, col = "red", lwd = 3)
```

<img src="/tutorials/pliman_lca/03_analyze_objects_files/figure-html/cont-1.png" width="960" />


## Casco convexo

A função `object_contour()` retorna uma lista com os pontos de coordenadas para cada contorno do objeto que pode ser usado posteriormente para obter o casco convexo com `conv_hull()`.


```r
conv <- conv_hull(cont)
plot(batata)
plot_contour(conv, col = "black", lwd = 3)
plot_measures(pot_meas, measure = "solidity")
```

<img src="/tutorials/pliman_lca/03_analyze_objects_files/figure-html/conv-1.png" width="960" />

## Área do casco convexo

Então, a área do casco convexo pode ser obtida com `poly_area()`.


```r
area <- poly_area(conv)
area
```

```
## $`1`
## [1] 54536
## 
## $`2`
## [1] 76706
## 
## $`3`
## [1] 62792.5
```





## Folhas como `ggplot2`




```r
# criar um quadro de dados para contorno e casco convexo
library(tidyverse)

df_cont <- bind_rows(cont, .id = "objeto")
df_conv <- bind_rows(conv, .id = "objeto")

ggplot(df_cont, aes(X1, X2, group = objeto)) +
  geom_polygon(aes(fill = objeto)) +
  geom_polygon(data = df_conv,
               aes(x, y, fill = objeto),
               alpha = 0.3) +
  theme_void() +
  theme(legend.position = "bottom")
```

<img src="/tutorials/pliman_lca/03_analyze_objects_files/figure-html/maskpoly-1.png" width="768" />



## Comprimento e largura
No exemplo a seguir, mostro como calcular o contorno do objeto, o centro de massa e os raios máximo e mínimo (em unidades de pixel). Nesse caso, o diâmetro mínimo e máximo (calculado com `analyze_objects()`) pode ser usado como uma medida para aproximar a largura e o comprimento do grão do feijão, respectivamente.



```r
bean <- image_import("bean.jpg", plot = TRUE)
```

<img src="/tutorials/pliman_lca/03_analyze_objects_files/figure-html/unnamed-chunk-17-1.png" width="672" />

```r
bean_meas <- 
  analyze_objects(bean,
                  index = "G",
                  fill_hull = TRUE,
                  watershed = FALSE,
                  show_contour = FALSE,
                  col_background = "black",
                  marker = "id")
bean_meas_cor <- get_measures(bean_meas, dpi = 300)
bean_meas_cor[, c("id", "diam_min", "diam_max")]
```

```
##    id diam_min diam_max
## 1   1    0.998    2.272
## 6   6    0.916    2.324
## 11 11    1.002    2.105
## 12 12    0.940    2.151
## 29 29    0.875    1.867
## 34 34    0.940    2.248
```

```r
# contorno
cont <- 
  object_contour(bean,
                 index = "G",
                 watershed = FALSE,
                 show_image = FALSE)

plot_contour(cont, col = "white", lwd = 2)

# centro de massa
cm <- poly_mass(cont)
plot_mass(cm,
          col = "white",
          arrow = TRUE)

# plota a largura e comprimento
plot_measures(bean_meas_cor, measure = "diam_min", vjust = 120)
plot_measures(bean_meas_cor, measure = "diam_max", hjust = 180)
```

<img src="/tutorials/pliman_lca/03_analyze_objects_files/figure-html/unnamed-chunk-17-2.png" width="672" />


# Comprimento de raiz
No exemplo a seguir, mostro como medir o comprimento da raiz de mudas de soja. As imagens foram coletadas de Silva et al. 2019^[Silva LJ da, Medeiros AD de, Oliveira AMS (2019) SeedCalc, a new automated R software tool for germination and seedling length data processing. J Seed Sci 41:250–257. https://doi.org/10.1590/2317-1545V42N2217267︎].



```r
roots <- image_import("root.jpg", plot = TRUE)

r1_meas <- 
  analyze_objects(roots,
                  index = "B",
                  marker = "id",
                  invert = TRUE)
```

<img src="/tutorials/pliman_lca/03_analyze_objects_files/figure-html/unnamed-chunk-18-1.png" width="672" />


Observe que a segmentação *"watershed"* segmentou os objetos conectados em vários objetos pequenos. Podemos melhorar esta segmentação usando o argumento `tolerance` (algumas tentativas serão necessárias para encontrar um valor adequado).


```r
r1_meas <- 
  analyze_objects(roots,
                  index = "B",
                  marker = "id",
                  invert = TRUE,
                  tolerance = 3.5)
```

<img src="/tutorials/pliman_lca/03_analyze_objects_files/figure-html/unnamed-chunk-19-1.png" width="672" />

Muito melhor, mas ainda não é o que procuramos. Observe que as raízes e os cotilédones foram selecionados. Podemos, no entanto, usar uma restrição na seleção de objetos que, neste caso, pode ser a excentricidade do objeto. Usando os argumentos `lower_eccent` os objetos podem ser selecionados em relação à sua excentricidade.


```r
r1_meas <- 
  analyze_objects(roots,
                  index = "B",
                  marker = "id",
                  invert = TRUE,
                  tolerance = 3,
                  lower_eccent = 0.95)
```

<img src="/tutorials/pliman_lca/03_analyze_objects_files/figure-html/unnamed-chunk-20-1.png" width="672" />

```r
r1_meas_cor <- get_measures(r1_meas, dpi = 150)
# calcula a metade do perímetro
r1_meas_cor$metade_perimetro <- r1_meas_cor$perimeter / 2

# plota as medidas
plot(roots)
plot_measures(r1_meas_cor,
              measure = "metade_perimetro",
              hjust = 30,
              col = "red")
plot_measures(r1_meas_cor,
              measure = "diam_max",
              hjust = -30)
```

<img src="/tutorials/pliman_lca/03_analyze_objects_files/figure-html/unnamed-chunk-20-2.png" width="672" />



# Valores RGB para cada objeto

Para obter a intensidade RGB de cada objeto de imagem, usamos o argumento `object_rgb = TRUE` na função `analyze_objects() `. Neste exemplo,


```r
img <- image_import("green.jpg", plot = TRUE)
```

<img src="/tutorials/pliman_lca/03_analyze_objects_files/figure-html/rgb1-1.png" width="960" />

```r
# identifica o índice que melhor segmenta a imagem
image_binary(img, index = "all")
```

<img src="/tutorials/pliman_lca/03_analyze_objects_files/figure-html/rgb1-2.png" width="960" />


O índice `NB` (padrão) foi escolhido para segmentar os grãos do fundo. A média dos valores da banda verde será calculada declarando `object_index = "G"`.


```r
soy_green <-
  analyze_objects(img,
                  object_index = "G",
                  marker_col = "black",
                  col_background = "white",
                  show_contour = FALSE)
plot_measures(soy_green,
              measure = "G",
              col = "black")
```

<img src="/tutorials/pliman_lca/03_analyze_objects_files/figure-html/rgb2-1.png" width="960" />


Parece que grãos com valores médios de verde (G) inferiores a 0.5 podem ser consideradas sementes esverdeadas. Os usuários podem então trabalhar com esse recurso e adaptá-lo ao seu caso.


```r
ids <- which(soy_green$object_index$G < 0.5)

# proporção de esverdeados (%)
length(ids) / soy_green$statistics[1,2] * 100
```

```
## [1] 10
```

```r
cont <- object_contour(img, show_image = FALSE)
plot(img)
plot_contour(cont, id = ids, col = "red")
```

<img src="/tutorials/pliman_lca/03_analyze_objects_files/figure-html/rgb4-1.png" width="672" />

```r
# somente na versao de desenvolvimento
report <- summary_index(soy_green, index = "G", cut_point = 0.5)
ids <- report$ids

plot(img)
plot_measures(soy_green,
              id = ids,
              measure = "G",
              col = "black")
```

<img src="/tutorials/pliman_lca/03_analyze_objects_files/figure-html/rgb4-2.png" width="672" />



## Grande número de objetos
Quando existem muitos objetos, o argumento `parallel = TRUE` irá acelerar a extração dos valores RGB. No exemplo a seguir, uma imagem com 1343 grãos de *Vicia cracca* é analisada. Os índices `"R"` e `"R/G"` são computados. Os grãos com um valor médio de vermelho superior a 0,25 são destacados.


```r
img2 <- image_import("vicia.jpg")
vicia <-
  analyze_objects(img2,
                  index = "B",
                  object_index = pliman_indexes_eq(),
                  show_image = FALSE,
                  parallel = TRUE)

head(vicia$object_index) %>%
  print_tbl()
```



| id|     R|     G|     B| R/(R+G+B)| G/(R+G+B)| B/(R+G+B)|   G/B|   R/B|   G/R| sqrt((R^2+G^2+B^2)/3)| sqrt((R*2+G*2+B*2)/3)| (R-G)/(R+G)| (2*G-R-B)/(2*G+R+B)| (2*R-G-B)/(G-B)| (G-R)/(G+R)| (G-B)/(G+B)| (R-B)/(R+B)| R+G+B| ((R+G+B)-3*B)/(R+G+B)| (G-R)/(G+R-B)| atan(2*(B-G-R)/30.5*(G-R))| atan(2*(R-G-R)/30.5*(G-B))|   B/G| R+G+B/3| 0.299*R + 0.587*G + 0.114*B| (25*(G-R)/(G+R-B)+1.25)| (max(R,G,B) - min(R,G,B)) / max(R,G,B)| (R-B)/R| 2*(R-G-B)/(G-B)| R**2/(B*G**3)|
|--:|-----:|-----:|-----:|---------:|---------:|---------:|-----:|-----:|-----:|---------------------:|---------------------:|-----------:|-------------------:|---------------:|-----------:|-----------:|-----------:|-----:|---------------------:|-------------:|--------------------------:|--------------------------:|-----:|-------:|---------------------------:|-----------------------:|--------------------------------------:|-------:|---------------:|-------------:|
|  1| 0.334| 0.336| 0.255|     0.354|     0.363|     0.282| 1.334| 1.325| 1.041|                 0.313|                 0.778|      -0.016|               0.066|            -Inf|       0.016|       0.132|       0.115| 0.925|                 0.153|  5.000000e-02|                          0|                     -0.002| 0.782|   0.755|                       0.326|            2.509000e+00|                                  0.912|   0.168|            -Inf|        13.233|
|  2| 0.296| 0.298| 0.239|     0.348|     0.356|     0.296| 1.238| 1.225|   Inf|                 0.280|                 0.734|      -0.017|               0.050|            -Inf|       0.017|       0.097|       0.081| 0.833|                 0.111|           Inf|                          0|                     -0.001| 0.836|   0.673|                       0.290|                     Inf|                                  1.000|    -Inf|            -Inf|        19.327|
|  3| 0.281| 0.289| 0.229|     0.348|     0.362|     0.290| 1.263| 1.223| 1.045|                 0.268|                 0.725|      -0.020|               0.062|            -Inf|       0.020|       0.112|       0.092| 0.799|                 0.130|  4.300000e-02|                          0|                     -0.001| 0.804|   0.646|                       0.280|            2.317000e+00|                                  0.898|   0.154|            -Inf|        15.999|
|  4| 0.290| 0.300| 0.240|     0.345|     0.361|     0.294| 1.253| 1.207| 1.058|                 0.279|                 0.736|      -0.026|               0.061|            -Inf|       0.026|       0.106|       0.081| 0.831|                 0.118|  5.800000e-02|                          0|                     -0.001| 0.816|   0.671|                       0.290|            2.700000e+00|                                  0.892|   0.126|            -Inf|        16.655|
|  5| 0.270| 0.301| 0.256|     0.319|     0.364|     0.317| 1.181| 1.060| 1.230|                 0.278|                 0.738|      -0.074|               0.068|            -Inf|       0.074|       0.076|       0.003| 0.827|                 0.049|  2.330000e-01|                          0|                     -0.001| 0.871|   0.657|                       0.287|            7.065000e+00|                                  0.977|  -0.129|            -Inf|        10.694|
|  6| 0.154| 0.202| 0.246|     0.255|     0.335|     0.410| 0.825| 0.640| 1.531|                 0.206|                 0.630|      -0.147|               0.005|           3.018|       0.147|      -0.097|      -0.235| 0.603|                -0.229|  6.872053e+12|                          0|                      0.001| 1.220|   0.439|                       0.193|            1.718013e+14|                                  0.992|  -0.974|          14.723|        14.218|

```r
cont2 <-
  object_contour(img2,
                 index = "B",
                 show_image = FALSE)

ids2 <- which(vicia$object_index$R > 0.25)
plot(img2)
plot_contour(cont2, id = ids2, col = "red")
```

<img src="/tutorials/pliman_lca/03_analyze_objects_files/figure-html/rgb5-1.png" width="1152" />

```r
# cria gráfico de densidade dos valores RGB para as duas classes de grãos
rgbs <-
  vicia$object_rgb %>%
  mutate(type = ifelse(id %in% ids2, "Destacado", "Não destacado")) %>%
  select(-id) %>%
  pivot_longer(-type) %>% 
  subset(name == "G")

ggplot(rgbs, aes(x = value)) +
  geom_density(fill = "green", alpha = 0.5) +
  facet_wrap(~type)
```

<img src="/tutorials/pliman_lca/03_analyze_objects_files/figure-html/rgb5-2.png" width="1152" />



# Área foliar
## Uma imagem

```r
folhas <- image_import(image = "leaves.jpg", plot = TRUE)
```

<img src="/tutorials/pliman_lca/03_analyze_objects_files/figure-html/unnamed-chunk-21-1.png" width="672" />

```r
af <-
  analyze_objects(folhas,
                  watershed = FALSE,
                  lower_eccent = 0.3,
                  show_contour = FALSE,
                  col_background = "black")
af_cor <- get_measures(af, dpi = 50.8)
plot_measures(af_cor, measure = "area")
```

<img src="/tutorials/pliman_lca/03_analyze_objects_files/figure-html/unnamed-chunk-21-2.png" width="672" />


## Preenchendo 'buracos'
Um aspecto importante a se considerar é quando há a presença de 'buracos' nas folhas. Isto pode ocorrer, por exemplo, pelo ataque de pragas. Neste caso, a área teria que ser considerada, pois ela estava lá!


```r
holes <- image_import("holes.jpg", plot = TRUE)
```

<img src="/tutorials/pliman_lca/03_analyze_objects_files/figure-html/unnamed-chunk-22-1.png" width="960" />

```r
af <-
  analyze_objects(holes,
                  watershed = FALSE,
                  col_background = "white",
                  marker = "area",
                  marker_col = "red",
                  marker_size = 3,
                  show_image = FALSE,
                  save_image = TRUE,
                  dir_processed = tempdir(),
                  contour_size = 5)

af2 <-
  analyze_objects(holes,
                  fill_hull = TRUE, # preenche 'buracos'
                  watershed = FALSE,
                  col_background = "white",
                  marker = "area",
                  marker_col = "red",
                  marker_size = 3,
                  show_image = FALSE,
                  save_image = TRUE,
                  prefix = "proc2_",
                  dir_processed = tempdir(),
                  contour_size = 5)

imgs <- image_import(pattern = "proc", path = tempdir())
image_combine(imgs)
```

<img src="/tutorials/pliman_lca/03_analyze_objects_files/figure-html/unnamed-chunk-22-2.png" width="960" />


## Várias imagens da mesma amostra

Se os usuários precisarem analisar várias imagens da mesma amostra, as imagens da mesma amostra devem compartilhar o mesmo prefixo de nome de arquivo, que é definido como a parte do nome do arquivo que precede o primeiro hífen (`-`) ou underscore (`_`). Então, ao usar `get_measures()`, as medidas das imagens de folhas chamadas, por exemplo, `F1-1.jpeg`,` F1_2.jpeg` e `F1-3.jpeg` serão combinadas em uma única imagem (`F1`), mostrado no objeto `merge`. Isso é útil, por exemplo, para analisar folhas grandes que precisam ser divididas em várias imagens ou várias folhas pertencentes à mesma amostra que não podem ser digitalizadas em uma imagem única.

No exemplo a seguir, cinco imagens serão usadas como exemplos. Cada imagem possui folhas de diferentes espécies. As imagens foram divididas em imagens diferentes que compartilham o mesmo prefixo (por exemplo, L1_\*, L2_\* e assim por diante). Observe que para garantir que todas as imagens sejam processadas, todas as imagens devem compartilhar um padrão comum, neste caso ("L"). Os três pontos no canto inferior direito têm uma distância conhecida de 5 cm entre eles, que pode ser usada para extrair o dpi da imagem com `dpi()`. Apenas para fins didáticos, considerarei que todas as imagens têm resolução de 100 dpi.



```r
# imagens inteiras
imgs <-
  image_import(pattern = "leaf",
               plot = TRUE,
               ncol = 2)
```

<img src="/tutorials/pliman_lca/03_analyze_objects_files/figure-html/merge0-1.png" width="960" />

```r
# imagens da mesma amostra
sample_imgs <-
  image_import(pattern = "L",
               plot = TRUE,
               ncol = 5)
```

<img src="/tutorials/pliman_lca/03_analyze_objects_files/figure-html/merge0-2.png" width="960" />

Aqui, usarei o `pattern =" L "` para indicar que todas as imagens com este nome de padrão devem ser analisadas. O índice verde (`" G "`) é usado para segmentar as folhas e `divisor de águas = FALSO` é usado para omitir o algoritmo de segmentação de divisor de águas.



```r
merged <-
  analyze_objects(pattern = "L",
                  index = "B",
                  watershed = FALSE)
```

```
## Processing image L1_1 |====                                      | 8% 00:00:00 
```

<img src="/tutorials/pliman_lca/03_analyze_objects_files/figure-html/merge1-1.png" width="672" />

```
## Processing image L1_2 |=======                                   | 17% 00:00:00 
```

<img src="/tutorials/pliman_lca/03_analyze_objects_files/figure-html/merge1-2.png" width="672" />

```
## Processing image L2_1 |==========                                | 25% 00:00:00 
```

<img src="/tutorials/pliman_lca/03_analyze_objects_files/figure-html/merge1-3.png" width="672" />

```
## Processing image L2_2 |==============                            | 33% 00:00:01 
```

<img src="/tutorials/pliman_lca/03_analyze_objects_files/figure-html/merge1-4.png" width="672" />

```
## Processing image L3_1 |==================                        | 42% 00:00:01 
```

<img src="/tutorials/pliman_lca/03_analyze_objects_files/figure-html/merge1-5.png" width="672" />

```
## Processing image L3_2 |=====================                     | 50% 00:00:01 
```

<img src="/tutorials/pliman_lca/03_analyze_objects_files/figure-html/merge1-6.png" width="672" />

```
## Processing image L3_3 |========================                  | 58% 00:00:02 
```

<img src="/tutorials/pliman_lca/03_analyze_objects_files/figure-html/merge1-7.png" width="672" />

```
## Processing image L4_1 |============================              | 67% 00:00:02 
```

<img src="/tutorials/pliman_lca/03_analyze_objects_files/figure-html/merge1-8.png" width="672" />

```
## Processing image L4_2 |================================          | 75% 00:00:02 
```

<img src="/tutorials/pliman_lca/03_analyze_objects_files/figure-html/merge1-9.png" width="672" />

```
## Processing image L4_3 |===================================       | 83% 00:00:02 
```

<img src="/tutorials/pliman_lca/03_analyze_objects_files/figure-html/merge1-10.png" width="672" />

```
## Processing image L5_1 |======================================    | 92% 00:00:03 
```

<img src="/tutorials/pliman_lca/03_analyze_objects_files/figure-html/merge1-11.png" width="672" />

```
## Processing image L5_2 |==========================================| 100% 00:00:03 
```

```
## --------------------------------------------
##  Image Objects
##   L1_1       1
##   L1_2       1
##   L2_1       2
##   L2_2       3
##   L3_1       1
##   L3_2       1
##   L3_3       1
##   L4_1       2
##   L4_2       2
##   L4_3       3
##   L5_1       3
##   L5_2       3
## --------------------------------------------
```

```
## Done!
```

<img src="/tutorials/pliman_lca/03_analyze_objects_files/figure-html/merge1-12.png" width="672" />

Usando a função `get_measures()` é possível converter as medidas de unidades de pixel em unidades métricas (cm$^ 2$).


```r
merged_cor <- get_measures(merged, dpi = 100)
```

Observe que o `merged_cor` é uma lista com três objetos:

* `results`: um data frame que contém as medidas de cada objeto individual (neste caso, folha) de cada imagem analisada.


```r
merged_cor$results %>% 
  print_tbl()
```



|img  | id|       x|       y|    area| area_ch| perimeter| radius_mean| radius_min| radius_max| radius_sd| radius_ratio| diam_mean| diam_min| diam_max| major_axis| minor_axis| eccentricity|  theta| solidity| circularity|
|:----|--:|-------:|-------:|-------:|-------:|---------:|-----------:|----------:|----------:|---------:|------------:|---------:|--------:|--------:|----------:|----------:|------------:|------:|--------:|-----------:|
|L1_1 |  1| 427.723| 516.719| 102.170| 292.253|   115.189|       6.217|      0.561|     11.913|   114.118|       21.226|    12.435|    1.122|   23.826|     19.863|     15.144|        0.647|  0.158|    0.350|       0.097|
|L1_2 |  1| 372.556| 526.031|  92.840| 207.023|   107.188|       5.341|      1.042|     10.168|    86.064|        9.754|    10.682|    2.085|   20.336|     15.123|     13.215|        0.486|  0.600|    0.448|       0.102|
|L2_1 |  1| 251.404| 282.798|  46.319|  46.789|    24.003|       3.936|      2.527|      5.920|    35.873|        2.342|     7.872|    5.054|   11.840|     10.479|      5.708|        0.839|  1.502|    0.990|       1.010|
|L2_1 |  2| 146.366| 701.900|  35.305|  36.136|    21.488|       3.441|      2.311|      5.209|    32.274|        2.254|     6.881|    4.621|   10.417|      9.308|      4.873|        0.852| -1.533|    0.977|       0.961|
|L2_2 |  1| 326.113| 391.141|  19.026|  19.221|    16.739|       2.613|      1.659|      4.129|    29.010|        2.488|     5.225|    3.319|    8.259|      7.301|      3.375|        0.887|  1.560|    0.990|       0.853|
|L2_2 |  2| 113.850| 755.321|  38.153|  38.670|    20.904|       3.534|      2.518|      5.097|    26.159|        2.024|     7.069|    5.036|   10.195|      8.955|      5.462|        0.792|  1.556|    0.987|       1.097|
|L2_2 |  3| 376.213| 784.804|  16.320|  16.439|    14.580|       2.365|      1.532|      3.616|    23.766|        2.361|     4.730|    3.063|    7.231|      6.509|      3.238|        0.867|  1.395|    0.993|       0.965|
|L3_1 |  1| 253.962| 480.290|  64.082| 117.849|    79.324|       4.199|      0.408|      9.476|    80.727|       23.207|     8.397|    0.817|   18.952|     15.225|      8.681|        0.822| -1.550|    0.544|       0.128|
|L3_2 |  1| 200.077| 436.484|  30.205|  57.570|    54.813|       2.830|      0.065|      6.576|    56.098|      100.588|     5.661|    0.131|   13.152|      9.857|      7.103|        0.693|  1.564|    0.525|       0.126|
|L3_3 |  1| 204.984| 363.476|  52.026|  87.382|    80.137|       3.494|      0.077|      7.821|    65.208|      101.216|     6.989|    0.155|   15.641|     12.404|      8.414|        0.735|  1.538|    0.595|       0.102|
|L4_1 |  1| 270.258| 326.544|  54.355|  54.773|    24.638|       4.177|      3.390|      5.717|    21.940|        1.686|     8.354|    6.780|   11.434|      9.918|      7.035|        0.705|  1.484|    0.992|       1.125|
|L4_1 |  3| 252.952| 845.157|  61.679|  63.975|    28.499|       4.540|      3.654|      6.488|    27.727|        1.776|     9.080|    7.307|   12.975|     10.549|      7.549|        0.699|  1.428|    0.964|       0.954|
|L4_2 |  1| 291.942| 235.565|  61.503|  62.870|    28.067|       4.544|      3.148|      6.592|    32.407|        2.094|     9.087|    6.297|   13.183|     10.970|      7.278|        0.748| -1.332|    0.978|       0.981|
|L4_2 |  2| 260.787| 799.754|  73.268|  75.388|    30.658|       4.938|      3.787|      7.013|    30.654|        1.852|     9.876|    7.574|   14.026|     11.609|      8.152|        0.712|  1.527|    0.972|       0.980|
|L4_3 |  1| 206.166| 213.417|  29.186|  29.581|    19.279|       3.097|      2.054|      4.374|    26.315|        2.130|     6.193|    4.107|    8.748|      8.256|      4.535|        0.836| -1.536|    0.987|       0.987|
|L4_3 |  2| 219.514| 552.896|  19.503|  20.439|    16.713|       2.595|      1.608|      3.940|    25.493|        2.451|     5.191|    3.215|    7.881|      7.069|      3.548|        0.865|  1.538|    0.954|       0.877|
|L4_3 |  3| 229.163| 937.157|  34.149|  35.426|    23.520|       3.470|      2.211|      5.138|    31.462|        2.324|     6.940|    4.421|   10.277|      8.809|      5.090|        0.816|  1.471|    0.964|       0.776|
|L5_1 |  1| 225.338| 275.720|  52.797|  54.448|    31.217|       4.590|      2.259|      7.735|    63.899|        3.425|     9.179|    4.517|   15.470|     13.610|      5.029|        0.929| -1.479|    0.970|       0.681|
|L5_1 |  2| 335.525| 884.869|  31.675|  32.608|    24.460|       3.619|      1.727|      6.199|    52.019|        3.590|     7.237|    3.454|   12.398|     10.718|      3.823|        0.934|  1.382|    0.971|       0.665|
|L5_1 |  3| 120.360| 887.853|  30.192|  32.323|    27.102|       3.827|      1.649|      6.774|    59.974|        4.109|     7.654|    3.297|   13.549|     11.055|      3.579|        0.946| -1.564|    0.934|       0.517|
|L5_2 |  1| 339.022| 300.133|  45.622|  46.825|    30.023|       4.331|      2.188|      7.465|    63.358|        3.412|     8.662|    4.376|   14.930|     13.160|      4.466|        0.941| -1.547|    0.974|       0.636|
|L5_2 |  2| 205.390| 802.624|  42.866|  43.898|    29.464|       4.267|      2.060|      7.335|    62.330|        3.561|     8.534|    4.120|   14.670|     12.766|      4.355|        0.940|  1.508|    0.976|       0.621|
|L5_2 |  3| 535.301| 819.600|  44.996|  46.294|    29.337|       4.300|      1.992|      7.465|    62.372|        3.748|     8.600|    3.984|   14.930|     13.069|      4.450|        0.940| -1.450|    0.972|       0.657|

* `summary`: um data frame que contém o resumo dos resultados, contendo o número de objetos em cada imagem (`n`) a soma, média e desvio padrão da área de cada imagem, bem como o valor médio para todas as outras medidas (perímetro, raio, etc.)



```r
merged_cor$summary %>% 
  print_tbl()
```



|img  |  n| area_sum| area_mean| area_sd| area_ch| perimeter| radius_mean| radius_min| radius_max| radius_sd| radius_ratio| diam_mean| diam_min| diam_max| major_axis| minor_axis| eccentricity|  theta| solidity| circularity|
|:----|--:|--------:|---------:|-------:|-------:|---------:|-----------:|----------:|----------:|---------:|------------:|---------:|--------:|--------:|----------:|----------:|------------:|------:|--------:|-----------:|
|L1_1 |  1|  102.170|   102.170|   0.000| 292.253|   115.189|       6.217|      0.561|     11.913|   114.118|       21.226|    12.435|    1.122|   23.826|     19.863|     15.144|        0.647|  0.158|    0.350|       0.097|
|L1_2 |  1|   92.840|    92.840|   0.000| 207.023|   107.188|       5.341|      1.042|     10.168|    86.064|        9.754|    10.682|    2.085|   20.336|     15.123|     13.215|        0.486|  0.600|    0.448|       0.102|
|L2_1 |  2|   81.624|    40.812|   7.788|  41.462|    22.746|       3.688|      2.419|      5.564|    34.073|        2.298|     7.377|    4.838|   11.128|      9.893|      5.290|        0.845| -0.016|    0.983|       0.986|
|L2_2 |  3|   73.500|    24.500|  11.901|  24.777|    17.407|       2.837|      1.903|      4.281|    26.312|        2.291|     5.675|    3.806|    8.562|      7.588|      4.025|        0.849|  1.504|    0.990|       0.972|
|L3_1 |  1|   64.082|    64.082|   0.000| 117.849|    79.324|       4.199|      0.408|      9.476|    80.727|       23.207|     8.397|    0.817|   18.952|     15.225|      8.681|        0.822| -1.550|    0.544|       0.128|
|L3_2 |  1|   30.205|    30.205|   0.000|  57.570|    54.813|       2.830|      0.065|      6.576|    56.098|      100.588|     5.661|    0.131|   13.152|      9.857|      7.103|        0.693|  1.564|    0.525|       0.126|
|L3_3 |  1|   52.026|    52.026|   0.000|  87.382|    80.137|       3.494|      0.077|      7.821|    65.208|      101.216|     6.989|    0.155|   15.641|     12.404|      8.414|        0.735|  1.538|    0.595|       0.102|
|L4_1 |  2|  116.034|    58.017|   5.178|  59.374|    26.568|       4.358|      3.522|      6.102|    24.833|        1.731|     8.717|    7.044|   12.205|     10.233|      7.292|        0.702|  1.456|    0.978|       1.040|
|L4_2 |  2|  134.771|    67.385|   8.319|  69.129|    29.362|       4.741|      3.468|      6.802|    31.530|        1.973|     9.482|    6.936|   13.605|     11.289|      7.715|        0.730|  0.097|    0.975|       0.980|
|L4_3 |  3|   82.838|    27.613|   7.449|  28.482|    19.837|       3.054|      1.957|      4.484|    27.757|        2.302|     6.108|    3.915|    8.968|      8.045|      4.391|        0.839|  0.491|    0.968|       0.880|
|L5_1 |  3|  114.664|    38.221|  12.645|  39.793|    27.593|       4.012|      1.878|      6.903|    58.631|        3.708|     8.023|    3.756|   13.806|     11.795|      4.144|        0.937| -0.554|    0.958|       0.621|
|L5_2 |  3|  133.484|    44.495|   1.445|  45.672|    29.608|       4.299|      2.080|      7.422|    62.687|        3.573|     8.599|    4.160|   14.843|     12.998|      4.424|        0.940| -0.496|    0.974|       0.638|

* `merge`: um data frame que contém os resultados mesclados pelo prefixo da imagem. Observe que, neste caso, os resultados são apresentados por L1, L2, L3, L4 e L5.


```r
merged_cor$merge %>% 
  print_tbl()
```



|img |  n| area_sum| area_mean| area_sd| area_ch| perimeter| radius_mean| radius_min| radius_max| radius_sd| radius_ratio| diam_mean| diam_min| diam_max| major_axis| minor_axis| eccentricity|  theta| solidity| circularity|
|:---|--:|--------:|---------:|-------:|-------:|---------:|-----------:|----------:|----------:|---------:|------------:|---------:|--------:|--------:|----------:|----------:|------------:|------:|--------:|-----------:|
|L1  |  2|  195.010|    97.505|   0.000| 249.638|   111.189|       5.779|      0.802|     11.040|   100.091|       15.490|    11.558|    1.604|   22.081|     17.493|     14.179|        0.567|  0.379|    0.399|       0.099|
|L2  |  5|  155.124|    32.656|   9.845|  33.120|    20.077|       3.263|      2.161|      4.922|    30.192|        2.295|     6.526|    4.322|    9.845|      8.741|      4.658|        0.847|  0.744|    0.987|       0.979|
|L3  |  3|  146.313|    48.771|   0.000|  87.600|    71.425|       3.508|      0.184|      7.958|    67.344|       75.004|     7.016|    0.367|   15.915|     12.495|      8.066|        0.750|  0.517|    0.555|       0.119|
|L4  |  7|  333.643|    51.005|   6.982|  52.328|    25.256|       4.051|      2.982|      5.796|    28.040|        2.002|     8.102|    5.965|   11.592|      9.856|      6.466|        0.757|  0.681|    0.974|       0.967|
|L5  |  6|  248.149|    41.358|   7.045|  42.733|    28.600|       4.156|      1.979|      7.162|    60.659|        3.641|     8.311|    3.958|   14.325|     12.396|      4.284|        0.938| -0.525|    0.966|       0.629|

O `area_sum` de img` L1` é a soma das duas folhas (uma em cada imagem)


```r
sum(merged_cor$results$area[1:2])
```

```
## [1] 195.01
```





```r
df_leaf <-
  merged_cor$results %>% 
  separate(img, into = c("img", "code"))

# leaf area of the different species
p1 <- 
  ggplot(df_leaf, aes(x = img, y = area)) +
  geom_boxplot() +
  geom_jitter(color = "red") +
  labs(x = "Imagem", y = expression(Área~(cm^2)))

p2 <- 
  ggplot(df_leaf, aes(x = img, y = area)) +
  stat_summary(fun = sum,
               geom = "bar",
               # fill = "white",
               col = "black") +
  labs(x = "Imagem", y = expression(Área~total~(cm^2)))


# solidity of the different species
p3 <- 
  ggplot(df_leaf, aes(x = img, y = solidity)) +
  geom_boxplot() +
  geom_jitter(color = "red") +
  labs(x = "Imagem", y = "Solidez")

p1 + p2 + p3 +
  plot_layout(ncol = 3)
```

<img src="/tutorials/pliman_lca/03_analyze_objects_files/figure-html/merge9-1.png" width="960" />



