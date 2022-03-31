---
title: Fitopatometria
linktitle: "3. Fitopatometria"
toc: true
type: docs
date: "2022/03/31"
draft: false
df_print: paged
code_download: true
menu:
  plimanufsc:
    parent: pliman
    weight: 4
weight: 3
---



# Diretório das imagens

```r
# mudar de acordo com a pasta em seu computador
setwd("E:/Desktop/tiagoolivoto/static/tutorials/pliman_ufsc_fito/leaves")
```


# Severidade da doença
## Utilizando paletas


```r
library(pliman)
```

```
## |==========================================================|
```

```
## | Tools for Plant Image Analysis (pliman 1.1.0)            |
```

```
## | Author: Tiago Olivoto                                    |
```

```
## | Type 'citation('pliman')' to know how to cite pliman     |
```

```
## | Type 'vignette('pliman_start')' for a short tutorial     |
```

```
## | Visit 'http://bit.ly/pkg_pliman' for a complete tutorial |
```

```
## |==========================================================|
```

```r
img <- image_import("exemp_1.jpeg", plot = TRUE)
h <- image_import("exem_h.png")
d <- image_import("exem_d.png")
b <- image_import("exem_b.png")
image_combine(img, h, d, b, ncol = 4)
```

<img src="/tutorials/pliman_ufsc_fito/03_quantification_files/figure-html/doença1-1.png" width="1152" />


## Gerando paletas

```r
h2 <- pick_palette(img)
d2 <- pick_palette(img)
b2 <- pick_palette(img)
image_combine(h2, d2, b2, ncol = 3)
```


### Padrão da função

```r
sev <- 
  measure_disease(img = img,
                  img_healthy = h,
                  img_symptoms = d,
                  img_background = b)
```

<img src="/tutorials/pliman_ufsc_fito/03_quantification_files/figure-html/unnamed-chunk-3-1.png" width="672" />


### Mostrando preenchimento das lesões

```r
sev <- 
  measure_disease(img = img,
                  img_healthy = h,
                  img_symptoms = d,
                  img_background = b,
                  show_contour = FALSE)
```

<img src="/tutorials/pliman_ufsc_fito/03_quantification_files/figure-html/unnamed-chunk-4-1.png" width="672" />


### Mostrando uma máscara

```r
sev <- 
  measure_disease(img = img,
                  img_healthy = h,
                  img_symptoms = d,
                  img_background = b,
                  show_contour = FALSE,
                  show_original = FALSE,
                  col_lesions = "brown") # padrão é "black"
```

<img src="/tutorials/pliman_ufsc_fito/03_quantification_files/figure-html/unnamed-chunk-5-1.png" width="672" />


### Segmentando e analisando as lesões
Ao utilizar `show_features = TRUE`, a função analisa as lesões e retorna resultados como número de lesões, área, perímetro, etc. Com `show_segmentation = TRUE`, as lesões segmentadas são mostradas.

```r
sev <- 
  measure_disease(img = img,
                  img_healthy = h,
                  img_symptoms = d,
                  img_background = b,
                  show_features = TRUE,
                  show_segmentation = TRUE)
```

<img src="/tutorials/pliman_ufsc_fito/03_quantification_files/figure-html/unnamed-chunk-6-1.png" width="672" />

```r
# corrigir as medidas (dpi = 150)
sev_corrected <- get_measures(sev, dpi = 150)
```


## Processamento em lote
Para analisar diversas imagens de um diretório, utiliza-se o argumento `pattern`, para declarar um padrão de nomes de arquivos. Serão utilizadas 15 folhas de soja disponíveis no repositório  https://osf.io/4hbr6, um banco de dados de imagens de anotação de severidade de doenças de plantas. Obrigado a [Emerson M. Del Ponte](https://osf.io/jb6yd/) e seus colaboradores por manter este projeto disponível publicamente.


```r
system.time(
  sev_lote <- 
    measure_disease(pattern = "soy",
                    img_healthy = "soja_h",
                    img_symptoms = "soja_s",
                    img_background = "soja_b",
                    show_image = FALSE,
                    save_image = TRUE,
                    dir_processed = "processadas",
                    show_contour = FALSE,
                    col_lesions = "brown")
)
```

```
## Processing image soy_1 |=                                        | 2% 00:00:00 
```

```
## Processing image soy_10 |==                                      | 4% 00:00:01 
```

```
## Processing image soy_11 |==                                      | 6% 00:00:03 
```

```
## Processing image soy_12 |===                                     | 8% 00:00:05 
```

```
## Processing image soy_13 |====                                    | 10% 00:00:07 
```

```
## Processing image soy_14 |=====                                   | 12% 00:00:08 
```

```
## Processing image soy_15 |======                                  | 14% 00:00:09 
```

```
## Processing image soy_16 |======                                  | 16% 00:00:10 
```

```
## Processing image soy_17 |=======                                 | 18% 00:00:12 
```

```
## Processing image soy_18 |========                                | 20% 00:00:14 
```

```
## Processing image soy_19 |=========                               | 22% 00:00:15 
```

```
## Processing image soy_2 |==========                               | 24% 00:00:16 
```

```
## Processing image soy_20 |==========                              | 26% 00:00:17 
```

```
## Processing image soy_21 |===========                             | 28% 00:00:19 
```

```
## Processing image soy_22 |============                            | 30% 00:00:20 
```

```
## Processing image soy_23 |=============                           | 32% 00:00:21 
```

```
## Processing image soy_24 |==============                          | 34% 00:00:22 
```

```
## Processing image soy_25 |==============                          | 36% 00:00:23 
```

```
## Processing image soy_26 |===============                         | 38% 00:00:25 
```

```
## Processing image soy_27 |================                        | 40% 00:00:26 
```

```
## Processing image soy_28 |=================                       | 42% 00:00:28 
```

```
## Processing image soy_29 |==================                      | 44% 00:00:29 
```

```
## Processing image soy_3 |===================                      | 46% 00:00:30 
```

```
## Processing image soy_30 |===================                     | 48% 00:00:32 
```

```
## Processing image soy_31 |====================                    | 50% 00:00:32 
```

```
## Processing image soy_32 |=====================                   | 52% 00:00:33 
```

```
## Processing image soy_33 |======================                  | 54% 00:00:34 
```

```
## Processing image soy_34 |======================                  | 56% 00:00:36 
```

```
## Processing image soy_35 |=======================                 | 58% 00:00:37 
```

```
## Processing image soy_36 |========================                | 60% 00:00:38 
```

```
## Processing image soy_37 |=========================               | 62% 00:00:39 
```

```
## Processing image soy_38 |==========================              | 64% 00:00:41 
```

```
## Processing image soy_39 |==========================              | 66% 00:00:42 
```

```
## Processing image soy_4 |============================             | 68% 00:00:43 
```

```
## Processing image soy_40 |============================            | 70% 00:00:44 
```

```
## Processing image soy_41 |=============================           | 72% 00:00:45 
```

```
## Processing image soy_42 |==============================          | 74% 00:00:46 
```

```
## Processing image soy_43 |==============================          | 76% 00:00:48 
```

```
## Processing image soy_44 |===============================         | 78% 00:00:49 
```

```
## Processing image soy_45 |================================        | 80% 00:00:50 
```

```
## Processing image soy_46 |=================================       | 82% 00:00:51 
```

```
## Processing image soy_47 |==================================      | 84% 00:00:52 
```

```
## Processing image soy_48 |==================================      | 86% 00:00:53 
```

```
## Processing image soy_49 |===================================     | 88% 00:00:54 
```

```
## Processing image soy_5 |=====================================    | 90% 00:00:55 
```

```
## Processing image soy_50 |=====================================   | 92% 00:00:56 
```

```
## Processing image soy_6 |=======================================  | 94% 00:00:57 
```

```
## Processing image soy_7 |=======================================  | 96% 00:00:58 
```

```
## Processing image soy_8 |======================================== | 98% 00:00:59 
```

```
## Processing image soy_9 |=========================================| 100% 00:01:00 
```

```
##   usuário   sistema decorrido 
##     57.84      3.46     62.09
```

```r
sev_lote$severity
```

```
##       img  healthy symptomatic
## 1   soy_1 92.48983   7.5101704
## 2  soy_10 57.14002  42.8599751
## 3  soy_11 87.02533  12.9746675
## 4  soy_12 63.30058  36.6994200
## 5  soy_13 53.33565  46.6643496
## 6  soy_14 99.77272   0.2272832
## 7  soy_15 70.31388  29.6861235
## 8  soy_16 30.23881  69.7611925
## 9  soy_17 18.95548  81.0445217
## 10 soy_18 82.52570  17.4742988
## 11 soy_19 39.48138  60.5186197
## 12  soy_2 85.19605  14.8039494
## 13 soy_20 34.63734  65.3626606
## 14 soy_21 34.30445  65.6955513
## 15 soy_22 76.33624  23.6637563
## 16 soy_23 58.78885  41.2111489
## 17 soy_24 74.39452  25.6054774
## 18 soy_25 10.03006  89.9699381
## 19 soy_26 28.06065  71.9393547
## 20 soy_27 33.58660  66.4133964
## 21 soy_28 50.53791  49.4620902
## 22 soy_29 23.70696  76.2930424
## 23  soy_3 19.19967  80.8003318
## 24 soy_30 43.79722  56.2027792
## 25 soy_31 13.43545  86.5645466
## 26 soy_32 46.04719  53.9528082
## 27 soy_33 90.44873   9.5512682
## 28 soy_34 44.10307  55.8969339
## 29 soy_35 60.17911  39.8208915
## 30 soy_36 93.05782   6.9421812
## 31 soy_37 39.05552  60.9444834
## 32 soy_38 52.41416  47.5858421
## 33 soy_39 40.97922  59.0207824
## 34  soy_4 67.22206  32.7779358
## 35 soy_40 66.45601  33.5439878
## 36 soy_41 97.34867   2.6513344
## 37 soy_42 86.55391  13.4460933
## 38 soy_43 90.54265   9.4573485
## 39 soy_44 57.84400  42.1559962
## 40 soy_45 84.38064  15.6193556
## 41 soy_46 83.99512  16.0048833
## 42 soy_47 76.24265  23.7573540
## 43 soy_48 75.66491  24.3350914
## 44 soy_49 70.62256  29.3774431
## 45  soy_5 80.64299  19.3570083
## 46 soy_50 51.19428  48.8057156
## 47  soy_6 64.30643  35.6935701
## 48  soy_7 62.41296  37.5870363
## 49  soy_8 43.23970  56.7602968
## 50  soy_9 79.59905  20.4009531
```




## Diagramas de área padrão

Os diagramas de área padrão (SAD) têm sido usados há muito tempo como uma ferramenta para auxiliar na estimativa da severidade de doenças de plantas, servindo como um modelo de referência padrão antes ou durante as avaliações.

Dado um objeto calculado com `measure_disease()`, um SAD com `n` imagens contendo os respectivos valores de severidade é obtido com `sad()`.

As folhas com menor e maior severidade sempre estarão no SAD. Se `n = 1`, a folha com a menor severidade será retornada. As outras são amostradas sequencialmente para obter as `n` imagens após a severidade ter sido ordenada em ordem crescente. Por exemplo, se houver 30 folhas e `n` for definido como 3, as folhas amostradas serão a 1ª, 15ª e 30ª com os menores valores de severidade.

O SAD só pode ser calculado se um nome de padrão de imagem for usado no argumento `pattern` da função `measure_disease()`. Se as imagens forem salvas, as `n` imagens serão recuperadas do diretório `dir_processed` (diretório padrão por default). Caso contrário, a severidade será calculada novamente para gerar as imagens. Um SAD com 8 imagens do exemplo acima pode ser obtido facilmente com:


```r
sad(sev_lote, n = 6, ncol = 3)
```

<img src="/tutorials/pliman_ufsc_fito/03_quantification_files/figure-html/unnamed-chunk-8-1.png" width="672" />

```
##       img  healthy symptomatic rank
## 6  soy_14 99.77272   0.2272832    1
## 40 soy_45 84.38064  15.6193556   10
## 7  soy_15 70.31388  29.6861235   20
## 5  soy_13 53.33565  46.6643496   30
## 31 soy_37 39.05552  60.9444834   40
## 18 soy_25 10.03006  89.9699381   50
```


## Processamento paralelo

Para acelerar o tempo de processamento quando várias imagens estão disponíveis, pode-se utilizar o argumento `paralell`. Isto criará múltiplas seções R em segundo plano, sendo cada uma responsável pelo processamento de uma parte das imagens.


```r
system.time(
  sev_lote <- 
    measure_disease(pattern = "soy",
                    img_healthy = "soja_h",
                    img_symptoms = "soja_s",
                    img_background = "soja_b",
                    show_image = FALSE,
                    parallel = TRUE)
)
```

```
## Image processing using multiple sessions (6). Please wait.
```

```
##   usuário   sistema decorrido 
##      0.36      0.06     23.52
```



## Várias imagens da mesma amostra

Se os usuários precisarem analisar várias imagens da mesma amostra, as imagens da mesma amostra devem compartilhar o mesmo prefixo de nome de arquivo, que é definido como a parte do nome do arquivo que precede o primeiro hífen (`-`) ou underscore (`_`). 

No exemplo a seguir, 16 imagens serão usadas como exemplos. Aqui, elas representam quatro repetiçoes de quatro diferentes tratamentos (`TRAT1_1, TRAT1_2, ..., TRAT4_4`). Observe que para garantir que todas as imagens sejam processadas, todas as imagens devem compartilhar um padrão comum, neste caso ("TRAT").


```r
system.time(
  sev_trats <- 
    measure_disease(pattern = "TRAT",
                    img_healthy = "feijao_h",
                    img_symptoms = "feijao_s",
                    img_background = "feijao_b",
                    show_features = TRUE,
                    show_image = FALSE,
                    parallel = TRUE)
)
```

```
## Image processing using multiple sessions (6). Please wait.
```

```
##   usuário   sistema decorrido 
##      0.26      0.07     11.18
```

```r
sev <- 
  sev_trats$severity |> 
  separate_col(img, into = c("TRAT", "REP"))

library(ggplot2)
ggplot(sev, aes(TRAT, symptomatic))+
  geom_boxplot() +
  geom_jitter(alpha = 0.3)
```

<img src="/tutorials/pliman_ufsc_fito/03_quantification_files/figure-html/unnamed-chunk-10-1.png" width="672" />




## Múltiplas folhas em uma foto

Quando múltiplas folhas estão presentes em uma imagem, a função `measure_disease` retorna a severidade média das folhas presentes na imagem. Para quantificar a severidade *por folha*, a função `measure_disease_byl()` pode ser utilizada.

Esta função calcula a porcentagem de área foliar sintomática usando paletas de cores ou índices RGB para cada folha (`byl`) de uma imagem. Isso permite, por exemplo, processar réplicas do mesmo tratamento e obter os resultados de cada replicação com uma única imagem. Para fazer isso, as amostras de folhas são primeiro divididas usando a função `object_split()` e, em seguida, a função `measure_disease()` é aplicado à lista de folhas.


```r
mult1 <- image_import("multiplas_01.jpeg", plot = TRUE)
```

<img src="/tutorials/pliman_ufsc_fito/03_quantification_files/figure-html/unnamed-chunk-11-1.png" width="672" />

```r
image_index(mult1)
```

<img src="/tutorials/pliman_ufsc_fito/03_quantification_files/figure-html/unnamed-chunk-11-2.png" width="672" />

```r
byl <- 
  measure_disease_byl(pattern = "multiplas_",
                      index = "B", # usado para segmentar a folha do fundo
                      img_healthy = "soja_h",
                      img_symptoms = "soja_s",
                      show_contour = FALSE,
                      show_features = TRUE,
                      col_lesions = "red")
```

```
## Processing image multiplas_01 |=======                           | 20% 00:00:00 
```

```
## Processing image multiplas_02 |==============                    | 40% 00:00:02 
```

<img src="/tutorials/pliman_ufsc_fito/03_quantification_files/figure-html/unnamed-chunk-11-3.png" width="672" />

```
## Processing image multiplas_03 |====================              | 60% 00:00:07 
```

<img src="/tutorials/pliman_ufsc_fito/03_quantification_files/figure-html/unnamed-chunk-11-4.png" width="672" />

```
## Processing image multiplas_04 |===========================       | 80% 00:00:10 
```

<img src="/tutorials/pliman_ufsc_fito/03_quantification_files/figure-html/unnamed-chunk-11-5.png" width="672" />

```
## Processing image multiplas_05 |==================================| 100% 00:00:14 
```

<img src="/tutorials/pliman_ufsc_fito/03_quantification_files/figure-html/unnamed-chunk-11-6.png" width="672" /><img src="/tutorials/pliman_ufsc_fito/03_quantification_files/figure-html/unnamed-chunk-11-7.png" width="672" />

```r
results_byl <- get_measures(byl)
head(results_byl$results)
```

```
##            img leaf id       x       y area area_ch perimeter radius_mean
## 1 multiplas_01    1  1 231.889  26.444    9       4         8       1.298
## 2 multiplas_01    1  2 377.333  32.667    3       0         3       0.654
## 3 multiplas_01    1  3 169.600  80.800    5       1         5       0.848
## 4 multiplas_01    1  4 239.276 120.483   29      19        17       2.637
## 5 multiplas_01    1  5 327.500 234.500    4       1         4       0.707
## 6 multiplas_01    1  6 122.556 244.556    9       4         9       1.366
##   radius_min radius_max radius_sd radius_ratio diam_mean diam_min diam_max
## 1      0.515      1.875     0.418        3.638     2.596    1.031    3.750
## 2      0.471      0.745     0.129        1.581     1.308    0.943    1.491
## 3      0.447      1.265     0.285        2.828     1.696    0.894    2.530
## 4      1.713      3.895     0.589        2.274     5.274    3.426    7.790
## 5      0.707      0.707     0.000        1.000     1.414    1.414    1.414
## 6      0.497      2.266     0.576        4.561     2.732    0.994    4.532
##   major_axis minor_axis eccentricity  theta solidity circularity
## 1      4.619      2.352        0.861 -1.107    2.250       1.767
## 2      2.309      1.333        0.816  0.785      Inf       4.189
## 3      3.098      1.789        0.816  1.249    5.000       2.513
## 4      7.634      5.005        0.755 -1.188    1.526       1.261
## 5      2.000      2.000        0.000  0.000    4.000       3.142
## 6      5.154      2.495        0.875 -0.254    2.250       1.396
```

```r
head(results_byl$summary)
```

```
##            img   n  area_sum area_mean area_sd    area area_ch perimeter
## 1 multiplas_01 230 103092.22   448.227 147.442  31.513  28.761    15.848
## 2 multiplas_02 332 141756.21   426.977 167.618 411.910 646.726    73.904
## 3 multiplas_03 344 123906.19   360.192 149.474 171.733 245.337    42.233
## 4 multiplas_04 197  94085.67   477.592 136.248 156.533 215.325    37.640
## 5 multiplas_05 370 124524.41   336.552 116.059 112.086 140.116    33.284
##   radius_mean radius_min radius_max radius_sd radius_ratio diam_mean diam_min
## 1       2.330      1.085      3.510     0.720          Inf     4.661    2.169
## 2       8.228      2.666     13.393     2.792        7.144    16.455    5.333
## 3       5.250      1.915      8.409     1.740        5.783    10.501    3.831
## 4       4.689      1.681      7.438     1.547          Inf     9.378    3.361
## 5       4.324      1.602      6.855     1.424          Inf     8.649    3.204
##   diam_max major_axis minor_axis eccentricity  theta solidity circularity
## 1    7.020      7.497      4.137        0.763  0.274      Inf       1.735
## 2   26.785     25.785     13.367        0.784 -0.030    1.065       0.918
## 3   16.818     16.652      8.485        0.776  0.075    1.293       1.131
## 4   14.876     14.952      7.838        0.775  0.089      Inf       1.267
## 5   13.709     13.666      7.067        0.751  0.045      Inf       1.599
```

```r
head(results_byl$merge)
```

```
##         img    n area_sum area_mean area_sd    area area_ch perimeter
## 1 multiplas 1473 587364.7   409.908 143.368 176.755 255.253    40.581
##   radius_mean radius_min radius_max radius_sd radius_ratio diam_mean diam_min
## 1       4.964       1.79      7.921     1.645          Inf     9.929     3.58
##   diam_max major_axis minor_axis eccentricity theta solidity circularity
## 1   15.842      15.71      8.179         0.77 0.091      Inf        1.33
```




