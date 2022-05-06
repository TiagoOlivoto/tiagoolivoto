---
title: Import and manipule
linktitle: "1. Import and manipulate"
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




# Image directory

```r
# mudar de acordo com a pasta em seu computador
setwd("E:/Desktop/tiagoolivoto/static/tutorials/pliman_ip/imgs")
```


## Import images

```r
library(pliman)
library(tidyverse)
library(patchwork)
img <- image_import("folhas.jpg")
```



To import a list of images, use a vector of image names, or the `pattern` argument. In the latter, all images that match the pattern name are imported into a list.


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


## Displaying imagens
Individual images are displayed with `plot()`. To combine images, the `image_combine()` function is used. Users can enter a comma-separated list of objects or a list of objects of the `Image` class.


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


`pliman` provides a set of `image_*()` functions to perform image manipulation and transformation of unique images or an image list based on [EBImage package](https://www.bioconductor.org/packages/release /bioc/vignettes/EBImage/inst/doc/EBImage-Introduction.html).


## Resize an image

Sometimes resizing high-resolution images is necessary to reduce computational effort and processing time. The `image_resize()` function is used to resize an image. The `rel_size` argument can be used to resize the image by relative size. For example, setting `rel_size = 50` for an image of width 1280 x 720, the new image will have a size of 640 x 360.


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



## Image resolution (DPI) {#dpi}
The `dpi()` function executes an interactive function to calculate the image resolution given a known distance entered by the user. To calculate the image resolution (dpi), the user must use the left mouse button to create a line of known distance. This can be done, for example, using a model with known distance, as follows.



```r
#  this only works in an interactive section
rule <- image_import("rule.jpg", plot = TRUE)
(dpi <- dpi(rule))

rule2 <- 
  image_crop(rule,
             width = 130:1390, 
             height = 582:1487, 
             plot = TRUE)

analyze_objects(rule2,
                watershed = FALSE,
                marker = "area") |> 
  get_measures(dpi = 518) |> 
  plot_measures(measure = "area", vjust = -100, size = 2)
```





# Filter, blur, contrast, dilatation, erosion, opening, and closing


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




# Export
To export images to the current directory, use the `image_export()` function. If an image list is exported, the images will be saved considering the name and extension present in the list. If no extension is present, images will be saved as `*.jpg` files.


```r
image_export(img, "img_exported.jpg")

# ou para uma subpasta
image_export(img, "test/img_exported.jpg")
```



