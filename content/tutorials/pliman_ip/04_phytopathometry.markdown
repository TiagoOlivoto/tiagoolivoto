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
## 1 92.83025    7.169748
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
## Processing image soy_10 |==                                      | 4% 00:00:02 
```

```
## Processing image soy_11 |==                                      | 6% 00:00:03 
```

```
## Processing image soy_12 |===                                     | 8% 00:00:04 
```

```
## Processing image soy_13 |====                                    | 10% 00:00:06 
```

```
## Processing image soy_14 |=====                                   | 12% 00:00:07 
```

```
## Processing image soy_15 |======                                  | 14% 00:00:08 
```

```
## Processing image soy_16 |======                                  | 16% 00:00:08 
```

```
## Processing image soy_17 |=======                                 | 18% 00:00:10 
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
## Processing image soy_26 |===============                         | 38% 00:00:20 
```

```
## Processing image soy_27 |================                        | 40% 00:00:22 
```

```
## Processing image soy_28 |=================                       | 42% 00:00:23 
```

```
## Processing image soy_29 |==================                      | 44% 00:00:24 
```

```
## Processing image soy_3 |===================                      | 46% 00:00:25 
```

```
## Processing image soy_30 |===================                     | 48% 00:00:26 
```

```
## Processing image soy_31 |====================                    | 50% 00:00:27 
```

```
## Processing image soy_32 |=====================                   | 52% 00:00:27 
```

```
## Processing image soy_33 |======================                  | 54% 00:00:29 
```

```
## Processing image soy_34 |======================                  | 56% 00:00:30 
```

```
## Processing image soy_35 |=======================                 | 58% 00:00:31 
```

```
## Processing image soy_36 |========================                | 60% 00:00:32 
```

```
## Processing image soy_37 |=========================               | 62% 00:00:33 
```

```
## Processing image soy_38 |==========================              | 64% 00:00:34 
```

```
## Processing image soy_39 |==========================              | 66% 00:00:35 
```

```
## Processing image soy_4 |============================             | 68% 00:00:36 
```

```
## Processing image soy_40 |============================            | 70% 00:00:37 
```

```
## Processing image soy_41 |=============================           | 72% 00:00:37 
```

```
## Processing image soy_42 |==============================          | 74% 00:00:39 
```

```
## Processing image soy_43 |==============================          | 76% 00:00:40 
```

```
## Processing image soy_44 |===============================         | 78% 00:00:40 
```

```
## Processing image soy_45 |================================        | 80% 00:00:42 
```

```
## Processing image soy_46 |=================================       | 82% 00:00:43 
```

```
## Processing image soy_47 |==================================      | 84% 00:00:44 
```

```
## Processing image soy_48 |==================================      | 86% 00:00:44 
```

```
## Processing image soy_49 |===================================     | 88% 00:00:45 
```

```
## Processing image soy_5 |=====================================    | 90% 00:00:46 
```

```
## Processing image soy_50 |=====================================   | 92% 00:00:47 
```

```
## Processing image soy_6 |=======================================  | 94% 00:00:48 
```

```
## Processing image soy_7 |=======================================  | 96% 00:00:49 
```

```
## Processing image soy_8 |======================================== | 98% 00:00:49 
```

```
## Processing image soy_9 |=========================================| 100% 00:00:50 
```

```
##   usuário   sistema decorrido 
##     47.30      4.02     51.55
```

```r
sev_lote$severity
```

```
##       img  healthy symptomatic
## 1   soy_1 92.73146   7.2685398
## 2  soy_10 55.04010  44.9599018
## 3  soy_11 87.17110  12.8288982
## 4  soy_12 61.87196  38.1280356
## 5  soy_13 50.86890  49.1311038
## 6  soy_14 99.81025   0.1897478
## 7  soy_15 71.92649  28.0735148
## 8  soy_16 29.96514  70.0348591
## 9  soy_17 21.27273  78.7272680
## 10 soy_18 83.35940  16.6406010
## 11 soy_19 38.26796  61.7320359
## 12  soy_2 85.74767  14.2523324
## 13 soy_20 33.35104  66.6489582
## 14 soy_21 32.42312  67.5768785
## 15 soy_22 74.99314  25.0068645
## 16 soy_23 60.38278  39.6172227
## 17 soy_24 73.56431  26.4356889
## 18 soy_25 10.30743  89.6925715
## 19 soy_26 27.84452  72.1554768
## 20 soy_27 31.76647  68.2335285
## 21 soy_28 53.21907  46.7809278
## 22 soy_29 23.38000  76.6199997
## 23  soy_3 16.40237  83.5976287
## 24 soy_30 43.87531  56.1246917
## 25 soy_31 14.39778  85.6022238
## 26 soy_32 46.35475  53.6452540
## 27 soy_33 90.31809   9.6819114
## 28 soy_34 43.12353  56.8764726
## 29 soy_35 59.74704  40.2529629
## 30 soy_36 93.90086   6.0991362
## 31 soy_37 37.93420  62.0657972
## 32 soy_38 53.32752  46.6724777
## 33 soy_39 40.27709  59.7229122
## 34  soy_4 66.61054  33.3894587
## 35 soy_40 66.90941  33.0905881
## 36 soy_41 97.02440   2.9756026
## 37 soy_42 86.47105  13.5289502
## 38 soy_43 90.59471   9.4052911
## 39 soy_44 57.97418  42.0258175
## 40 soy_45 83.67090  16.3291044
## 41 soy_46 83.29936  16.7006407
## 42 soy_47 75.45897  24.5410255
## 43 soy_48 76.41285  23.5871508
## 44 soy_49 70.47054  29.5294613
## 45  soy_5 78.69218  21.3078153
## 46 soy_50 59.03612  40.9638796
## 47  soy_6 63.18407  36.8159338
## 48  soy_7 59.59425  40.4057476
## 49  soy_8 42.03463  57.9653662
## 50  soy_9 79.87053  20.1294717
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
## 6  soy_14 99.81025   0.1897478    1
## 40 soy_45 83.67090  16.3291044   10
## 44 soy_49 70.47054  29.5294613   20
## 2  soy_10 55.04010  44.9599018   30
## 31 soy_37 37.93420  62.0657972   40
## 18 soy_25 10.30743  89.6925715   50
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
##      0.36      0.04     26.95
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
##      0.29      0.06     16.24
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



|img          |leaf | id|       x|       y| area| area_ch| perimeter| radius_mean| radius_min| radius_max| radius_sd| diam_mean| diam_min| diam_max| major_axis| minor_axis| length|  width| radius_ratio| eccentricity|  theta| solidity| convexity| elongation| circularity| circularity_haralick| circularity_norm|
|:------------|:----|--:|-------:|-------:|----:|-------:|---------:|-----------:|----------:|----------:|---------:|---------:|--------:|--------:|----------:|----------:|------:|------:|------------:|------------:|------:|--------:|---------:|----------:|-----------:|--------------------:|----------------:|
|multiplas_01 |1    |  1| 231.571|  27.304|   56|      49|    27.213|       3.797|      2.675|      4.600|     0.496|     7.594|    5.351|    9.199|      9.128|      8.034|  8.785|  7.196|        1.719|        0.759| -0.832|    1.143|     0.827|      0.181|      13.224|                7.659|            1.339|
|multiplas_01 |1    |  2| 374.140|  31.105|   57|      47|    29.899|       4.099|      1.893|      6.757|     1.314|     8.197|    3.786|   13.514|     12.985|      6.031| 12.739|  5.529|        3.570|        0.233|  0.529|    1.213|     0.859|      0.566|      15.684|                3.120|            1.694|
|multiplas_01 |1    |  3| 317.000|  62.000|    5|       0|     7.000|       1.000|      0.000|      2.000|     0.707|     2.000|    0.000|    4.000|      5.657|      0.000|  4.000|  0.000|          Inf|        0.000|  1.571|      Inf|     0.571|      1.000|       9.800|                1.414|              Inf|
|multiplas_01 |1    |  4| 168.635|  82.337|  104|     101|    41.385|       5.348|      3.394|      7.482|     1.096|    10.697|    6.788|   14.964|     14.070|     10.293| 13.291| 11.397|        2.204|        0.644| -1.142|    1.030|     0.877|      0.143|      16.468|                4.880|            1.613|
|multiplas_01 |1    |  5| 226.706|  86.294|   17|      10|    11.828|       1.894|      1.294|      2.647|     0.394|     3.788|    2.587|    5.294|      5.552|      3.917|  4.933|  3.584|        2.046|        0.508| -0.459|    1.700|     0.845|      0.273|       8.230|                4.801|            1.113|
|multiplas_01 |1    |  6| 175.353| 104.088|   34|      25|    19.899|       2.994|      2.013|      4.527|     0.772|     5.988|    4.026|    9.055|      9.066|      4.843|  8.831|  4.645|        2.249|        0.297|  0.953|    1.360|     0.900|      0.474|      11.647|                3.880|            1.313|


