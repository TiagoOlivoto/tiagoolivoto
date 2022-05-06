---
title: Phytopathometry
linktitle: "4. Phytopathometry"
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


# Disease severity
## Using sample palettes

Sample palettes can be made by simply manually sampling small areas of representative images and producing a composite image that will represent each of the desired classes (background, healthy, and symptomatic tissues). 


```r
# generate html tables
print_tbl <- function(table, digits = 3, ...){
  knitr :: kable(table, booktabs = TRUE, digits = digits, ...)
}

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


## Producing sample palettes

Users can produce these palettes with `pick_palette()` function.


```r
h2 <- pick_palette(img)
d2 <- pick_palette(img)
b2 <- pick_palette(img)
image_combine(h2, d2, b2, ncol = 3)
```


### Defaults settings

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
## 1 92.40081    7.599192
```


### Filling lesions

```r
sev <- 
  measure_disease(img = img,
                  img_healthy = h,
                  img_symptoms = d,
                  img_background = b,
                  show_contour = FALSE)
```

<img src="/tutorials/pliman_ip/04_phytopathometry_files/figure-html/unnamed-chunk-5-1.png" width="672" />


### Showing a mask

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


### Segmenting and analyzing lesions

When using `show_features = TRUE`, the function analyzes the lesions and returns results such as number of lesions, area, perimeter, etc. With `show_segmentation = TRUE`, segmented lesions are shown.


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
# correct the measures (dpi = 150)
sev_corrected <- get_measures(sev, dpi = 150)
```


## Batch processing
To analyze several images from a directory, use the `pattern` argument to declare a pattern of filenames. Here, we Will used 50 soybean leaves available in the repository https://osf.io/4hbr6, a database of images of annotation of severity of plant diseases. Thanks to [Emerson M. Del Ponte](https://osf.io/jb6yd/) and his contributors for keeping this project publicly available. Using the `save_image = TRUE` argument we save the processed images in a temporary directory, defined by `tempdir()`.


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
## Processing image soy_15 |======                                  | 14% 00:00:07 
```

```
## Processing image soy_16 |======                                  | 16% 00:00:08 
```

```
## Processing image soy_17 |=======                                 | 18% 00:00:09 
```

```
## Processing image soy_18 |========                                | 20% 00:00:10 
```

```
## Processing image soy_19 |=========                               | 22% 00:00:11 
```

```
## Processing image soy_2 |==========                               | 24% 00:00:13 
```

```
## Processing image soy_20 |==========                              | 26% 00:00:13 
```

```
## Processing image soy_21 |===========                             | 28% 00:00:15 
```

```
## Processing image soy_22 |============                            | 30% 00:00:16 
```

```
## Processing image soy_23 |=============                           | 32% 00:00:16 
```

```
## Processing image soy_24 |==============                          | 34% 00:00:17 
```

```
## Processing image soy_25 |==============                          | 36% 00:00:18 
```

```
## Processing image soy_26 |===============                         | 38% 00:00:20 
```

```
## Processing image soy_27 |================                        | 40% 00:00:21 
```

```
## Processing image soy_28 |=================                       | 42% 00:00:22 
```

```
## Processing image soy_29 |==================                      | 44% 00:00:24 
```

```
## Processing image soy_3 |===================                      | 46% 00:00:25 
```

```
## Processing image soy_30 |===================                     | 48% 00:00:25 
```

```
## Processing image soy_31 |====================                    | 50% 00:00:26 
```

```
## Processing image soy_32 |=====================                   | 52% 00:00:27 
```

```
## Processing image soy_33 |======================                  | 54% 00:00:28 
```

```
## Processing image soy_34 |======================                  | 56% 00:00:29 
```

```
## Processing image soy_35 |=======================                 | 58% 00:00:30 
```

```
## Processing image soy_36 |========================                | 60% 00:00:31 
```

```
## Processing image soy_37 |=========================               | 62% 00:00:32 
```

```
## Processing image soy_38 |==========================              | 64% 00:00:33 
```

```
## Processing image soy_39 |==========================              | 66% 00:00:34 
```

```
## Processing image soy_4 |============================             | 68% 00:00:35 
```

```
## Processing image soy_40 |============================            | 70% 00:00:36 
```

```
## Processing image soy_41 |=============================           | 72% 00:00:37 
```

```
## Processing image soy_42 |==============================          | 74% 00:00:38 
```

```
## Processing image soy_43 |==============================          | 76% 00:00:39 
```

```
## Processing image soy_44 |===============================         | 78% 00:00:40 
```

```
## Processing image soy_45 |================================        | 80% 00:00:41 
```

```
## Processing image soy_46 |=================================       | 82% 00:00:42 
```

```
## Processing image soy_47 |==================================      | 84% 00:00:43 
```

```
## Processing image soy_48 |==================================      | 86% 00:00:44 
```

```
## Processing image soy_49 |===================================     | 88% 00:00:44 
```

```
## Processing image soy_5 |=====================================    | 90% 00:00:45 
```

```
## Processing image soy_50 |=====================================   | 92% 00:00:46 
```

```
## Processing image soy_6 |=======================================  | 94% 00:00:47 
```

```
## Processing image soy_7 |=======================================  | 96% 00:00:48 
```

```
## Processing image soy_8 |======================================== | 98% 00:00:48 
```

```
## Processing image soy_9 |=========================================| 100% 00:00:49 
```

```
##   usuário   sistema decorrido 
##     46.70      3.85     50.64
```

```r
sev_lote$severity
```

```
##       img  healthy symptomatic
## 1   soy_1 92.52563   7.4743652
## 2  soy_10 53.77352  46.2264815
## 3  soy_11 88.09271  11.9072925
## 4  soy_12 62.14973  37.8502662
## 5  soy_13 50.69540  49.3045969
## 6  soy_14 99.71032   0.2896812
## 7  soy_15 72.05556  27.9444391
## 8  soy_16 29.58402  70.4159828
## 9  soy_17 20.22205  79.7779521
## 10 soy_18 82.51413  17.4858743
## 11 soy_19 42.67324  57.3267573
## 12  soy_2 85.39472  14.6052822
## 13 soy_20 35.47402  64.5259831
## 14 soy_21 33.04771  66.9522886
## 15 soy_22 76.43200  23.5679982
## 16 soy_23 60.12710  39.8728959
## 17 soy_24 72.75270  27.2472998
## 18 soy_25 10.33450  89.6654954
## 19 soy_26 27.87645  72.1235462
## 20 soy_27 32.23449  67.7655105
## 21 soy_28 54.04358  45.9564223
## 22 soy_29 27.24976  72.7502403
## 23  soy_3 15.92240  84.0775990
## 24 soy_30 43.43413  56.5658737
## 25 soy_31 14.74770  85.2522959
## 26 soy_32 45.63878  54.3612233
## 27 soy_33 90.35326   9.6467381
## 28 soy_34 45.78971  54.2102881
## 29 soy_35 59.58620  40.4137992
## 30 soy_36 92.98744   7.0125599
## 31 soy_37 38.59930  61.4006992
## 32 soy_38 55.17430  44.8256972
## 33 soy_39 41.35854  58.6414616
## 34  soy_4 65.94024  34.0597552
## 35 soy_40 66.72246  33.2775399
## 36 soy_41 97.10586   2.8941362
## 37 soy_42 85.74192  14.2580846
## 38 soy_43 91.33162   8.6683812
## 39 soy_44 57.88192  42.1180843
## 40 soy_45 83.77265  16.2273515
## 41 soy_46 84.11146  15.8885412
## 42 soy_47 76.20198  23.7980150
## 43 soy_48 75.89337  24.1066313
## 44 soy_49 71.23578  28.7642179
## 45  soy_5 77.83521  22.1647893
## 46 soy_50 62.07399  37.9260118
## 47  soy_6 63.44981  36.5501873
## 48  soy_7 61.02503  38.9749725
## 49  soy_8 46.95837  53.0416265
## 50  soy_9 79.02519  20.9748074
```




## Diagramas de área padrão

Standard area diagrams (SAD) have long been used as a tool to aid the estimation of plant disease severity, serving as a standard reference template before or during the assessments.

Given an object computed with `measure_disease()` a Standard Area Diagram (SAD) with `n` images containing the respective severity values are obtained with `sad()`.

Leaves with the smallest and highest severity will always be in the SAD. If `n = 1`, the leaf with the smallest severity will be returned. The others are sampled sequentially to achieve the n images after severity has been ordered in ascending order. For example, if there are 30 leaves and n is set to 3, the leaves sampled will be the 1st, 15th, and 30th with the smallest severity values.

The SAD can be only computed if an image pattern name is used in argument `pattern` of `measure_disease()`. If the images are saved, the `n` images will be retrevied from `dir_processed` directory. Otherwise, the severity will be computed again to generate the images. A SAD with 8 images from the above example can be obtained easely with:


```r
sad(sev_lote, n = 6, ncol = 3)
```

<img src="/tutorials/pliman_ip/04_phytopathometry_files/figure-html/unnamed-chunk-9-1.png" width="672" />

```
##       img  healthy symptomatic rank
## 6  soy_14 99.71032   0.2896812    1
## 41 soy_46 84.11146  15.8885412   10
## 44 soy_49 71.23578  28.7642179   20
## 32 soy_38 55.17430  44.8256972   30
## 31 soy_37 38.59930  61.4006992   40
## 18 soy_25 10.33450  89.6654954   50
```


## Parallel processing

To speed up processing time when multiple images are available, you can use the `paralell` argument. In parallel programming (`parallel = TRUE`), the images are processed asynchronously (in parallel) in separate R sessions running in the background on the same machine. The number of sections is set by default to 50% of available cores. This number can be controlled explicitly with the argument workers.


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
##      0.28      0.05     20.35
```



## Multiple images of the same sample

If users need to analyze multiple images from the same sample, the images from the same sample must share the same filename prefix, which is defined as the part of the filename that precedes the first hyphen (`-`) or underscore (`_`).

In the following example, 16 images will be used as examples. Here, they represent four replicates of four different treatments (`TRAT1_1, TRAT1_2, ..., TRAT4_4`). Note that to ensure that all images are processed, all images must share a common pattern, in this case (`"TRAT"`).


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
##      0.25      0.05     13.11
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



## Multiple leaves in one image

When multiple leaves are present in an image, the `measure_disease` function returns the average severity of the leaves present in the image. To quantify the severity *per leaf*, the `measure_disease_byl()` function can be used.

This function computes the percentage of symptomatic leaf area using color palettes or RGB indices for each leaf (`byl`) of an image. This allows, for example, to process replicates of the same treatment and obtain the results of each replication with a single image. To do this, the sample sheets are first split using the `object_split()` function and then the `measure_disease()` function is applied to the sheet list.


```r
byl <- 
  measure_disease_byl(pattern = "multiplas",
                      index = "B", # used to segment leaves from background
                      img_healthy = "soja_h",
                      img_symptoms = "soja_s",
                      show_contour = FALSE,
                      show_features = TRUE,
                      col_lesions = "red",
                      parallel = TRUE)
```

```
## Image processing using multiple sessions (6). Please wait.
```

```r
results_byl <- get_measures(byl)

results_byl$results |> 
  head() |> 
  print_tbl()
```



|img          |leaf | id|       x|       y| area| area_ch| perimeter| radius_mean| radius_min| radius_max| radius_sd| diam_mean| diam_min| diam_max| major_axis| minor_axis| length| width| radius_ratio| eccentricity|  theta| solidity| convexity| elongation| circularity| circularity_haralick| circularity_norm|
|:------------|:----|--:|-------:|-------:|----:|-------:|---------:|-----------:|----------:|----------:|---------:|---------:|--------:|--------:|----------:|----------:|------:|-----:|------------:|------------:|------:|--------:|---------:|----------:|-----------:|--------------------:|----------------:|
|multiplas_01 |1    |  1| 231.804|  27.326|   46|      38|    23.142|       3.378|      2.673|      4.006|     0.381|     6.756|    5.346|    8.011|      7.931|      7.472|  7.483| 7.483|        1.499|        0.955|  1.195|    1.211|     0.856|      0.000|      11.643|                8.872|            1.218|
|multiplas_01 |1    |  2| 373.745|  31.213|   47|      39|    28.899|       3.775|      1.778|      6.331|     1.317|     7.550|    3.556|   12.663|     12.278|      5.347| 11.989| 4.948|        3.561|        0.203|  0.580|    1.205|     0.872|      0.587|      17.770|                2.866|            2.045|
|multiplas_01 |1    |  3| 317.000|  61.500|    4|       0|     5.000|       0.833|      0.500|      1.500|     0.471|     1.667|    1.000|    3.000|      4.472|      0.000|  3.000| 0.000|        3.000|        0.000|  1.571|      Inf|     0.600|      1.000|       6.250|                1.768|              Inf|
|multiplas_01 |1    |  4| 168.365|  82.447|   85|      81|    38.799|       4.885|      3.076|      6.987|     1.136|     9.770|    6.152|   13.973|     13.745|      8.446| 12.981| 8.509|        2.271|        0.420| -1.128|    1.049|     0.741|      0.345|      17.710|                4.299|            1.788|
|multiplas_01 |1    |  5| 226.706|  86.294|   17|      10|    11.828|       1.894|      1.294|      2.647|     0.394|     3.788|    2.587|    5.294|      5.552|      3.917|  4.933| 3.584|        2.046|        0.508| -0.459|    1.700|     0.845|      0.273|       8.230|                4.801|            1.113|
|multiplas_01 |1    |  6| 175.375| 104.094|   32|      23|    18.071|       2.847|      1.915|      3.913|     0.588|     5.693|    3.830|    7.827|      8.241|      4.918|  7.810| 4.476|        2.043|        0.360|  0.884|    1.391|     0.879|      0.427|      10.205|                4.840|            1.155|



## And now?


```r
f0 <- image_import("fungo.png", plot = TRUE)

back <- pick_palette(f0)
fore <- pick_palette(f0)

res <- 
analyze_objects(f0,
                background = back,
                foreground = fore,
                watershed = FALSE)

meas <- get_measures(res, dpi = 81)
plot_measures(meas,
              col = "black",
              measure = "area",
              size = 2)
```

<img src="/tutorials/pliman_ip/04_phytopathometry_files/figure-html/unnamed-chunk-13-1.png" width="672" />


