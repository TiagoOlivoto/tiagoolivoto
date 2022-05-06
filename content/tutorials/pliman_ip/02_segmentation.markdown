---
title: Segment objects
linktitle: "2. Segment objects"
toc: true
type: docs
date: "2021/10/27"
lastmod: "2022/05/06"
draft: false
df_print: paged
code_download: true
menu:
  plimanip:
    parent: pliman
    weight: 3
weight: 2
---





# Image directory

```r
# mudar de acordo com a pasta em seu computador
setwd("E:/Desktop/tiagoolivoto/static/tutorials/pliman_ip/imgs")
```


# Import images

```r
library(pliman) 
img <- image_import("folhas.jpg", plot = TRUE)
```

<img src="/tutorials/pliman_ip/02_segmentation_files/figure-html/unnamed-chunk-3-1.png" width="672" />

```r
img <- image_resize(img, rel_size = 30) #processamento mais rápido
```


# Segment images

In `pliman`, the following functions can be used to segment an image.

* `image_binary()` to produce a binary (black and white) image.
* `image_segment()` to produce a segmented image (image objects and a white background).
* `image_segment_iter()` to segment an image interactively.

Both functions segment the image based on the value of some image index, which can be one of the RGB bands or any operation with these bands. Internally, these functions call `image_index()` to calculate these indices.

Here, we use the `index" `argument to test segmentation based on RGB and its normalized values. Users can also provide their index with the `my_index` argument.



```r
# Calcule os índices
indexes <- image_index(img, index = c("R, G, B, NR, NG, NB"))
```

<img src="/tutorials/pliman_ip/02_segmentation_files/figure-html/segmentação2-1.png" width="960" />

```r
# Crie um gráfico raster com os valores RGB
plot(indexes)
```

<img src="/tutorials/pliman_ip/02_segmentation_files/figure-html/segmentação2-2.png" width="960" />

```r
# Crie um histograma com os valores RGB
plot(indexes, type = "density")
```

<img src="/tutorials/pliman_ip/02_segmentation_files/figure-html/segmentação2-3.png" width="960" />

The two peaks represent the leaf (smallest peak) and the background (larger peak). The clearer the difference between these peaks, the better the image segmentation.



# Producing a binary image

To segment objects, `pliman` uses the `threshold` technique (Otsu, 1979)[^1], that is, a cut-off point (considering the pixel values) is chosen and the image is classified into two classes (foreground and background). We then have a binary image. We can produce this image with `image_binary()`. This binarization is the key process to all object analysis steps. The better the binarization, the better the results.


```r
binary <- image_binary(img)
```

<img src="/tutorials/pliman_ip/02_segmentation_files/figure-html/binary1-1.png" width="960" />

The `image_segment()` function is used to segment images using image indices. In our example, we will use the `NB` index to segment the bottom leaves.


```r
segmented <- 
  image_segment(img,
                index = "NB", # default
                fill_hull = TRUE)
```

<img src="/tutorials/pliman_ip/02_segmentation_files/figure-html/segmentação3-1.png" width="960" />



## Iterative segmentation

The function `image_segment_iter()` provides an iterative image segmentation. Users can choose how many segmentation to perform, using the argument `nseg`. Note that the same results can be obtained with `image_segment_iter()` using an iterative section.


```r
# Only run iteratively
image_segment_iter(img, nseg = 1)
```




[^1]: Otsu, N. 1979. Threshold selection method from gray-level histograms. IEEE Trans Syst Man Cybern SMC-9(1): 62–66. doi: 10.1109/tsmc.1979.4310076.

