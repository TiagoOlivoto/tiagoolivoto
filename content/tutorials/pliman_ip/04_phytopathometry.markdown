---
title: Fitopatometria
linktitle: "4. Fitopatometria"
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
    weight: 5
weight: 4
---



# Diretório das imagens

```r
# mudar de acordo com a pasta em seu computador
setwd("E:/Desktop/tiagoolivoto/static/tutorials/pliman_ip/imgs")
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
## | Tools for Plant Image Analysis (pliman 1.2.0)            |
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

<img src="/tutorials/pliman_ip/04_phytopathometry_files/figure-html/doença1-1.png" width="1152" />


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

<img src="/tutorials/pliman_ip/04_phytopathometry_files/figure-html/unnamed-chunk-4-1.png" width="672" />

```r
sev$severity
```

```
##    healthy symptomatic
## 1 92.74062    7.259378
```


### Mostrando preenchimento das lesões

```r
sev <- 
  measure_disease(img = img,
                  img_healthy = h,
                  img_symptoms = d,
                  img_background = b,
                  show_contour = FALSE)
```

<img src="/tutorials/pliman_ip/04_phytopathometry_files/figure-html/unnamed-chunk-5-1.png" width="672" />


### Mostrando uma máscara

```r
sev <- 
  measure_disease(img = img,
                  img_healthy = h,
                  img_symptoms = d,
                  img_background = b,
                  show_original = FALSE,
                  col_lesions = "brown") # padrão é "black"
```

<img src="/tutorials/pliman_ip/04_phytopathometry_files/figure-html/unnamed-chunk-6-1.png" width="672" />


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

<img src="/tutorials/pliman_ip/04_phytopathometry_files/figure-html/unnamed-chunk-7-1.png" width="672" />

```r
# corrigir as medidas (dpi = 150)
sev_corrected <- get_measures(sev, dpi = 150)
```


## Processamento em lote
Para analisar diversas imagens de um diretório, utiliza-se o argumento `pattern`, para declarar um padrão de nomes de arquivos. Serão utilizadas 50 folhas de soja disponíveis no repositório  https://osf.io/4hbr6, um banco de dados de imagens de anotação de severidade de doenças de plantas. Obrigado a [Emerson M. Del Ponte](https://osf.io/jb6yd/) e seus colaboradores por manter este projeto disponível publicamente. Ao utilizar o argumento `save_image = TRUE` salvamos as imagens processadas em um diretório temporário, definido por `tempdir()`.


```r
# criar um diretório temporário
temp_dir <- tempdir()

system.time(
  sev_lote <- 
    measure_disease(pattern = "soy",
                    img_healthy = "soja_h",
                    img_symptoms = "soja_s",
                    img_background = "soja_b",
                    show_image = FALSE,
                    save_image = TRUE,
                    dir_processed = temp_dir,
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
## Processing image soy_12 |===                                     | 8% 00:00:04 
```

```
## Processing image soy_13 |====                                    | 10% 00:00:05 
```

```
## Processing image soy_14 |=====                                   | 12% 00:00:06 
```

```
## Processing image soy_15 |======                                  | 14% 00:00:08 
```

```
## Processing image soy_16 |======                                  | 16% 00:00:08 
```

```
## Processing image soy_17 |=======                                 | 18% 00:00:09 
```

```
## Processing image soy_18 |========                                | 20% 00:00:11 
```

```
## Processing image soy_19 |=========                               | 22% 00:00:12 
```

```
## Processing image soy_2 |==========                               | 24% 00:00:13 
```

```
## Processing image soy_20 |==========                              | 26% 00:00:14 
```

```
## Processing image soy_21 |===========                             | 28% 00:00:15 
```

```
## Processing image soy_22 |============                            | 30% 00:00:17 
```

```
## Processing image soy_23 |=============                           | 32% 00:00:17 
```

```
## Processing image soy_24 |==============                          | 34% 00:00:18 
```

```
## Processing image soy_25 |==============                          | 36% 00:00:19 
```

```
## Processing image soy_26 |===============                         | 38% 00:00:21 
```

```
## Processing image soy_27 |================                        | 40% 00:00:22 
```

```
## Processing image soy_28 |=================                       | 42% 00:00:23 
```

```
## Processing image soy_29 |==================                      | 44% 00:00:25 
```

```
## Processing image soy_3 |===================                      | 46% 00:00:26 
```

```
## Processing image soy_30 |===================                     | 48% 00:00:27 
```

```
## Processing image soy_31 |====================                    | 50% 00:00:28 
```

```
## Processing image soy_32 |=====================                   | 52% 00:00:29 
```

```
## Processing image soy_33 |======================                  | 54% 00:00:30 
```

```
## Processing image soy_34 |======================                  | 56% 00:00:31 
```

```
## Processing image soy_35 |=======================                 | 58% 00:00:33 
```

```
## Processing image soy_36 |========================                | 60% 00:00:34 
```

```
## Processing image soy_37 |=========================               | 62% 00:00:35 
```

```
## Processing image soy_38 |==========================              | 64% 00:00:36 
```

```
## Processing image soy_39 |==========================              | 66% 00:00:37 
```

```
## Processing image soy_4 |============================             | 68% 00:00:38 
```

```
## Processing image soy_40 |============================            | 70% 00:00:39 
```

```
## Processing image soy_41 |=============================           | 72% 00:00:40 
```

```
## Processing image soy_42 |==============================          | 74% 00:00:41 
```

```
## Processing image soy_43 |==============================          | 76% 00:00:42 
```

```
## Processing image soy_44 |===============================         | 78% 00:00:43 
```

```
## Processing image soy_45 |================================        | 80% 00:00:44 
```

```
## Processing image soy_46 |=================================       | 82% 00:00:46 
```

```
## Processing image soy_47 |==================================      | 84% 00:00:47 
```

```
## Processing image soy_48 |==================================      | 86% 00:00:47 
```

```
## Processing image soy_49 |===================================     | 88% 00:00:48 
```

```
## Processing image soy_5 |=====================================    | 90% 00:00:49 
```

```
## Processing image soy_50 |=====================================   | 92% 00:00:50 
```

```
## Processing image soy_6 |=======================================  | 94% 00:00:51 
```

```
## Processing image soy_7 |=======================================  | 96% 00:00:52 
```

```
## Processing image soy_8 |======================================== | 98% 00:00:53 
```

```
## Processing image soy_9 |=========================================| 100% 00:00:54 
```

```
##   usuário   sistema decorrido 
##     50.66      4.49     55.30
```

```r
sev_lote$severity
```

```
##       img   healthy symptomatic
## 1   soy_1 92.657063   7.3429375
## 2  soy_10 57.028531  42.9714689
## 3  soy_11 87.680947  12.3190533
## 4  soy_12 61.948737  38.0512628
## 5  soy_13 50.700496  49.2995038
## 6  soy_14 99.768422   0.2315783
## 7  soy_15 72.877105  27.1228948
## 8  soy_16 30.626971  69.3730287
## 9  soy_17 19.748411  80.2515889
## 10 soy_18 81.583085  18.4169149
## 11 soy_19 41.143174  58.8568265
## 12  soy_2 85.453628  14.5463717
## 13 soy_20 35.382776  64.6172236
## 14 soy_21 33.891129  66.1088712
## 15 soy_22 74.651185  25.3488152
## 16 soy_23 58.397936  41.6020643
## 17 soy_24 74.961393  25.0386074
## 18 soy_25  9.997751  90.0022488
## 19 soy_26 29.589505  70.4104950
## 20 soy_27 30.691419  69.3085808
## 21 soy_28 52.490804  47.5091963
## 22 soy_29 23.314603  76.6853966
## 23  soy_3 16.609423  83.3905772
## 24 soy_30 43.163828  56.8361716
## 25 soy_31 14.637519  85.3624813
## 26 soy_32 50.275811  49.7241891
## 27 soy_33 90.760009   9.2399911
## 28 soy_34 45.949708  54.0502925
## 29 soy_35 60.273151  39.7268486
## 30 soy_36 94.816590   5.1834103
## 31 soy_37 37.185171  62.8148294
## 32 soy_38 58.103021  41.8969793
## 33 soy_39 40.361302  59.6386976
## 34  soy_4 66.346950  33.6530497
## 35 soy_40 67.364801  32.6351994
## 36 soy_41 97.030371   2.9696291
## 37 soy_42 86.026327  13.9736728
## 38 soy_43 90.836772   9.1632280
## 39 soy_44 57.338701  42.6612994
## 40 soy_45 82.644291  17.3557085
## 41 soy_46 83.864979  16.1350205
## 42 soy_47 75.456109  24.5438910
## 43 soy_48 75.731072  24.2689278
## 44 soy_49 69.680124  30.3198760
## 45  soy_5 80.024331  19.9756692
## 46 soy_50 56.575752  43.4242484
## 47  soy_6 61.502494  38.4975061
## 48  soy_7 59.890252  40.1097475
## 49  soy_8 50.748110  49.2518904
## 50  soy_9 80.251568  19.7484325
```




## Diagramas de área padrão

Os diagramas de área padrão (SAD) têm sido usados há muito tempo como uma ferramenta para auxiliar na estimativa da severidade de doenças de plantas, servindo como um modelo de referência padrão antes ou durante as avaliações.

Dado um objeto calculado com `measure_disease()`, um SAD com `n` imagens contendo os respectivos valores de severidade é obtido com `sad()`.

As folhas com menor e maior severidade sempre estarão no SAD. Se `n = 1`, a folha com a menor severidade será retornada. As outras são amostradas sequencialmente para obter as `n` imagens após a severidade ter sido ordenada em ordem crescente. Por exemplo, se houver 30 folhas e `n` for definido como 3, as folhas amostradas serão a 1ª, 15ª e 30ª com os menores valores de severidade.

O SAD só pode ser calculado se um nome de padrão de imagem for usado no argumento `pattern` da função `measure_disease()`. Se as imagens forem salvas, as `n` imagens serão recuperadas do diretório `dir_processed` (diretório padrão por default). Caso contrário, a severidade será calculada novamente para gerar as imagens. Um SAD com 8 imagens do exemplo acima pode ser obtido facilmente com:


```r
sad(sev_lote, n = 6, ncol = 3)
```

<img src="/tutorials/pliman_ip/04_phytopathometry_files/figure-html/unnamed-chunk-9-1.png" width="672" />

```
##       img   healthy symptomatic rank
## 6  soy_14 99.768422   0.2315783    1
## 41 soy_46 83.864979  16.1350205   10
## 44 soy_49 69.680124  30.3198760   20
## 2  soy_10 57.028531  42.9714689   30
## 31 soy_37 37.185171  62.8148294   40
## 18 soy_25  9.997751  90.0022488   50
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
##      0.31      0.06     21.75
```


## Várias imagens da mesma amostra

Se os usuários precisarem analisar várias imagens da mesma amostra, as imagens da mesma amostra devem compartilhar o mesmo prefixo de nome de arquivo, que é definido como a parte do nome do arquivo que precede o primeiro hífen (`-`) ou underscore (`_`). 

No exemplo a seguir, 16 imagens serão usadas como exemplos. Aqui, elas representam quatro repetições de quatro diferentes tratamentos (`TRAT1_1, TRAT1_2, ..., TRAT4_4`). Observe que para garantir que todas as imagens sejam processadas, todas as imagens devem compartilhar um padrão comum, neste caso (`"TRAT"`).


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
##      0.25      0.04     14.53
```

```r
sev <- 
  sev_trats$severity |> 
  separate_col(img, into = c("TRAT", "REP"))

library(ggplot2)
ggplot(sev, aes(TRAT, symptomatic))+
  geom_boxplot() +
  geom_jitter(alpha = 0.3) +
  labs(x = "Tratamentos",
       y = "Severidade (%)")
```

<img src="/tutorials/pliman_ip/04_phytopathometry_files/figure-html/unnamed-chunk-11-1.png" width="672" />



## Múltiplas folhas em uma foto

Quando múltiplas folhas estão presentes em uma imagem, a função `measure_disease` retorna a severidade média das folhas presentes na imagem. Para quantificar a severidade *por folha*, a função `measure_disease_byl()` pode ser utilizada.

Esta função calcula a porcentagem de área foliar sintomática usando paletas de cores ou índices RGB para cada folha (`byl`) de uma imagem. Isso permite, por exemplo, processar réplicas do mesmo tratamento e obter os resultados de cada replicação com uma única imagem. Para fazer isso, as amostras de folhas são primeiro divididas usando a função `object_split()` e, em seguida, a função `measure_disease()` é aplicado à lista de folhas.


```r
library(pliman)
byl <- 
  measure_disease_byl(img = "multiplas_04",
                      index = "B", # usado para segmentar a folha do fundo
                      img_healthy = "soja_h",
                      img_symptoms = "soja_s",
                  # img_background = "soja_b",
                      show_contour = FALSE,
                      show_features = TRUE,
                      col_lesions = "red",
                      parallel = TRUE)
```

<img src="/tutorials/pliman_ip/04_phytopathometry_files/figure-html/unnamed-chunk-12-1.png" width="672" />

```r
results_byl <- get_measures(byl)
head(results_byl$results)
```

```
## NULL
```

```r
head(results_byl$summary)
```

```
## NULL
```

```r
head(results_byl$merge)
```

```
## NULL
```


