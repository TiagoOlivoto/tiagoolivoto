---
toc: true
title: pliman 1.0.0 available now!
subtitle: ''
summary: 'Find out the news in pliman v1.0.0'
author: Tiago Olivoto
date: '2021-11-10'
lastmod: '2021-11-10'
url_source: https://github.com/TiagoOlivoto/pliman
url_project: https://olivoto.netlify.app/project/pliman/
url_code: https://doi.org/10.5281/zenodo.5666820
url_slides: "https://tiagoolivoto.github.io/slides_R/slides/pliman_omegads/index.html#1"
url_video: "https://www.youtube.com/watch?v=ElvUVlPocgA"
# doi: "10.1111/2041-210X.13384"
links:
- icon: twitter
  icon_pack: fab
  name: Follow
  url: https://twitter.com/tolivoto
categories:
  - pliman
tags:
  - image analysis
  - image binary
  - image segmentation
  - phytopathometry
  - count objects
  - leaf area
  - WSMP
image:
  placement: 2
  caption: 'Image by Tiago Olivoto'
  preview_only: no
featured: no
math: true
---

<script src="https://kit.fontawesome.com/1f72d6921a.js" crossorigin="anonymous"></script>




<i class="far fa-calendar-alt"></i> After exactly four months since the last stable release, I'm so proud to announce that `pliman` 1.0.0 is now on [CRAN](https://CRAN.R-project.org/package=pliman). `pliman` was first released on CRAN on 2021/05/15 and since there, two stable versions have been released. This new version includes lots of new features and bug corrections. See [package news](https://tiagoolivoto.github.io/pliman/news/index.html) for more information.



# Instalation

```r
# The latest stable version is installed with
install.packages("pliman")

# Or the development version from GitHub:
# install.packages("devtools")
devtools::install_github("TiagoOlivoto/pliman")
```


# Object segmentation
In `pliman` the following functions can be used to segment an image.
* `image_binary()` to produce a binary (black and white) image
* `image_segment()` to produce a segmented image (image objects and a white background).
* `image_segment_iter()` to segment an image iteratively.

Both functions segment the image based on the value of some image index, which may be one of the RGB bands or any operation with these bands. Internally, these functions call `image_index()` to compute these indexes. The following indexes are currently available.


| Index |           Equation          |
|-------|:---------------------------:|
| R     |              R              |
| G     |              G              |
| B     |              B              |
| NR    |          R/(R+G+B)          |
| NG    |          G/(R+G+B)          |
| NB    |          B/(R+G+B)          |
| GB    |             G/B             |
| RB    |             R/B             |
| GR    |             G/R             |
| BI    |    sqrt((R\^2+G\^2+B\^2)/3)    |
| BIM   |    sqrt((R\*2+G\*2+B\*2)/3)    |
| SCI   |         (R-G)/(R+G)         |
| GLI   |     (2\*G-R-B)/(2\*G+R+B)     |
| HI    |       (2\*R-G-B)/(G-B)       |
| NGRDI |         (G-R)/(G+R)         |
| NDGBI |         (G-B)/(G+B)         |
| NDRBI |         (R-B)/(R+B)         |
| I     |            R+G+B            |
| S     |    ((R+G+B)-3\*B)/(R+G+B)    |
| VARI  |        (G-R)/(G+R-B)        |
| HUE   |  atan(2\*(B-G-R)/30.5\*(G-R)) |
| HUE2  |  atan(2\*(R-G-R)/30.5\*(G-B)) |
| BGI   |             B/G             |
| L     |           R+G+B/3           |
| GRAY  | 0.299\*R + 0.587\*G + 0.114\*B |
| GLAI  |   (25*(G-R)/(G+R-B)+1.25)   |
| GRVI  |         (G-R)/(G+R)         |
| CI    |           (R-B)/R           |
| SHP   |       2*(R-G-B)/(G-B)       |
| RI    |        \(R^2/(B*G^3)\)        |




Here, I use the argument `index` to test the segmentation based on the RGB and their normalized values. Users can also provide their index with the argument `my_index`.


```r
library(pliman)
# |=======================================================|
# | Tools for Plant Image Analysis (pliman 1.0.0)         |
# | Author: Tiago Olivoto                                 |
# | Type 'vignette('pliman_start')' for a short tutorial  |
# | Visit 'https://bit.ly/pliman' for a complete tutorial |
# |=======================================================|
soy <- image_pliman("soybean_touch.jpg")
```


```r
# Compute the indexes
indexes <- image_index(soy, index = c("R, G, B, NR, NG, NB"))
```

<img src="{{< blogdown/postref >}}index_files/figure-html/segmentation2-1.png" width="960" />

```r

# Create a raster plot with the RGB values
plot(indexes)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/segmentation2-2.png" width="960" />

```r

# Create a density plot with the RGB values
plot(indexes, type = "density")
```

<img src="{{< blogdown/postref >}}index_files/figure-html/segmentation2-3.png" width="960" />

In this example, we can see the distribution of the RGB values (first row) and the normalized RGB values (second row). The two peaks represent the grains (smaller peak) and the blue background (larger peak). The clearer the difference between these peaks, the better will the image segmentation.

## Segment an image

The function `image_segmentation()` is used to segment images using image indexes. In this example, I will use the same indexes computed below to see how the image is segmented. The output of this function can be used as input in the function `analyze_objects()`.


```r
segmented <- image_segment(soy, index = c("R, G, B, NR, NG, NB"))
```

<img src="{{< blogdown/postref >}}index_files/figure-html/segmentation3-1.png" width="960" />

It seems that the `"NB"` index provided better segmentation. `"R"` and `"NR"` resulted in an inverted segmented image, i.e., the grains were considered as background and the remaining as 'selected' image. To circumvent this problem, we can use the argument `invert` in those functions.


```r
image_segment(soy,
              index = c("R, NR"),
              invert = TRUE)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/segmentation4-1.png" width="960" />



## Produce a binary image

We can also produce a binary image with `image_binary()`. Just for curiosity, we will use the indexes `"B"` (blue) and `"NB"` (normalized blue). By default, `image_binary()` rescales the image to 30% of the size of the original image to speed up the computation time. Use the argument `resize = FALSE` to produce a binary image with the original size.


```r
binary <- image_binary(soy)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/binary1-1.png" width="960" />

```r

# original image size
image_binary(soy,
             index = c("B, NB"),
             resize = FALSE)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/binary1-2.png" width="960" />


# Counting crop grains 

Here, we will count the grains in the image `soybean_touch.jpg`. This image has a cyan background and contains 30 soybean grains that touch with each other. Two segmentation strategies are used. The first one is by using is image segmentation based on color indexes. 


```r
library(pliman)
soy <- image_pliman("soybean_touch.jpg", plot = TRUE)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-2-1.png" width="960" />

The function `analyze_objects()` segment the image using as default the normalized blue index, as follows \(NB = (B/(R+G+B))\), where *R*, *G*, and *B* are the red, green, and blue bands. Objects are counted and the segmented objects are colored with random permutations.


```r
count <- 
  analyze_objects(soy,
                  index = "NB") # default
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-3-1.png" width="960" />

```r

count$statistics
#        stat      value
# 1         n    30.0000
# 2  min_area  1366.0000
# 3 mean_area  2057.3667
# 4  max_area  2445.0000
# 5   sd_area   230.5574
# 6  sum_area 61721.0000
```

Users can set `show_contour = FALSE` to remove the contour line and identify the objects (in this example the grains) by using the arguments `marker = "id"`. The color of the background can also be changed with `col_background`.


```r
count <- 
  analyze_objects(soy,
                  show_contour = FALSE,
                  marker = "id",
                  show_segmentation = FALSE,
                  col_background = "white",
                  index = "NB") # default
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-4-1.png" width="960" />
In the following example, I will select objects with an area above the average of all objects by using `lower_size = 2057.36`. Additionally, I will use the argument `show_original = FALSE` to show the results as colors (non-original image).


```r
analyze_objects(soy,
                marker = "id",
                show_original = FALSE,
                lower_size = 2057.36,
                index = "NB") # default
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-5-1.png" width="960" />

Users can also use the `topn_*` arguments to select the top `n` objects based on either smaller or largest areas. Let's see how to point out the 5 grains with the smallest area, showing the original grains in a blue background. We will also use the argument `my_index` to choose a personalized index to segment the image. Just for comparison, we will set up explicitly the normalized blue index by calling `my_index = "B/(R+G+B)"`.


```r
analyze_objects(soy,
                marker = "id",
                topn_lower = 5,
                col_background = "blue",
                my_index = "B/(R+G+B)") # default
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-6-1.png" width="960" />


# Leaf area
We can use `analyze_objects()` to compute object features such as area, perimeter, radius, etc. This can be used, for example, to compute leaf area.
Let's compute the leaf area of `leaves` with `analyze_objects()`. First, we use `image_segmentation()` to identify candidate indexes to segment foreground (leaves) from background.


```r
path <- "https://raw.githubusercontent.com/TiagoOlivoto/paper_pliman/master/data/leaf_area/leaves2.jpg"
leaves <- image_import(path, plot = TRUE)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/leaf3-1.png" width="960" />


```r
image_segment(leaves, index = "all")
```

<img src="{{< blogdown/postref >}}index_files/figure-html/leaf4-1.png" width="768" />

`G` (Green) and `NB` (Normalized Blue) are two possible candidates to segment the leaves from the background. We will use the `NB` index here (default option in `analyze_objects()`). The measurement of the leaf area in this approach can be done in two main ways: 1) using an object of known area, and 2) knowing the image resolution in dpi (dots per inch).


## Using an object of known area

- Count the number of objects (leaves in this case)

Here, we use the argument `marker = "id"` of the function `analyze_objects()` to obtain the identification of each object (leaf), allowing for further adjustment of the leaf area. The argument watershed = FALSE is also used to prevent leaves to be segmented into multiple, small fractions.


```r
count <- analyze_objects(leaves,
                         marker = "id",
                         watershed = FALSE)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/leaf5-1.png" width="960" />

And here we are! Now, all leaves were identified correctly, but all measures were given in pixel units. The next step is to convert these measures to metric units.


- Convert the leaf area by the area of the known object

The function `get_measures()` is used to adjust the leaf area using object 30, a square with a side of 5 cm (25 cm$^2$).


```r
area <-
  get_measures(count,
               id = 30,
               area ~ 25)
# -----------------------------------------
# measures corrected with:
# object id: 30
# area     : 25
# -----------------------------------------
# Total    : 820.525 
# Average  : 35.675 
# -----------------------------------------

# plot the area to the segmented image
image_segment(leaves, index = "NB", verbose = FALSE)
plot_measures(area,
              measure = "area",
              col = "red") # default is "white"
```

<img src="{{< blogdown/postref >}}index_files/figure-html/leaf9-1.png" width="960" />


## knowing the image resolution in dpi (dots per inch)
When the image resolution is known, the measures in pixels obtained with `analyze_objects()` are corrected by the image resolution. The function `dpi()` can be used to compute the dpi of an image, provided that the size of any object is known. In this case, the estimated resolution considering the calibration of object 30 was ~50.8 DPIs. We inform this value in the `dpi` argument of `get_measures9)`.


```r
area2 <- get_measures(count, dpi = 50.8)
# compute the difference between the two methods
sum(area$area - area2$area)
# [1] 7.709
```


# Leaf shape

The function `analyze_objects()` computes a range of object features that can be used to study leaf shape. As a motivating example, I will use the image `potato_leaves.png`, which was gathered from Gupta et al. (2020)^[Gupta, S., Rosenthal, D. M., Stinchcombe, J. R., & Baucom, R. S. (2020). The remarkable morphological diversity of leaf shape in sweet potato (*Ipomoea batatas*): the influence of genetics, environment, and G×E. *New Phytologist*, 225(5), 2183–2195. https://doi.org/10.1111/nph.16286]




```r
potato <- image_pliman("potato_leaves.jpg", plot = TRUE)
pot_meas <-
  analyze_objects(potato,
                  watershed = FALSE,
                  marker = "id",
                  show_chull = TRUE) # shows the convex hull
```

<img src="{{< blogdown/postref >}}index_files/figure-html/potato-1.png" width="960" />

```r
print(pot_meas$results)
#   id        x        y  area area_ch perimeter radius_mean radius_min
# 1  1 854.5424 224.0429 51380   54536       852    131.5653   92.11085
# 2  2 197.8440 217.8508 58923   76706      1064    140.2962   70.10608
# 3  3 536.2100 240.2380 35117   62792      1310    109.9000   38.13658
#   radius_max radius_sd radius_ratio diam_mean  diam_min diam_max major_axis
# 1   198.0248  26.06131     2.149854  263.1305 184.22169 396.0497   305.7374
# 2   192.3613  28.58523     2.743861  280.5924 140.21215 384.7226   318.2436
# 3   188.5105  35.50978     4.943037  219.8001  76.27315 377.0210   253.4985
#   minor_axis eccentricity      theta  solidity circularity
# 1   242.2124    0.6102310  1.3936873 0.9421300   0.8894566
# 2   274.1280    0.5079648 -0.0992339 0.7681668   0.6540508
# 3   243.2790    0.2810738  1.0968854 0.5592591   0.2571489
```

Three key measures (in pixel units) are:

1. `area` the area of the object.
2. `area_ch` the area of the convex hull.
3. `perimeter` the perimeter of the object.

Using these measures, circularity and solidity are computed as shown in (Gupta et al, 2020).

$$ 
circularity = 4\pi(area / perimeter^2)
$$
$$ 
solidity = area / area\_ch
$$

Circularity is influenced by serrations and lobing. Solidity is sensitive to leaves with deep lobes, or with a distinct petiole, and can be used to distinguish leaves lacking such structures. Unlike circularity, it is not very sensitive to serrations and minor lobings, since the convex hull remains largely unaffected.


## Object contour

Users can also obtain the object contour and convex hull as follows:


```r
cont <-
  object_contour(potato,
                 watershed = FALSE,
                 show_image = FALSE)
plot(potato)
plot_contour(cont, col = "red", lwd = 3)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/cont-1.png" width="960" />

## Convex hull
The function `object_contour()` returns a list with the coordinate points for each object contour that can be further used to obtain the convex hull with `conv_hull()`.


```r
conv <- conv_hull(cont)
plot(potato)
plot_contour(conv, col = "red", lwd = 3)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/conv-1.png" width="960" />


## Area of the convex hull
Then, the area of the convex hull can be obtained with `poly_area()`.

```r
(area <- poly_area(conv))
# $`1`
# [1] 54536
# 
# $`2`
# [1] 76706
# 
# $`3`
# [1] 62792.5
```



# Phytopathometry

The function `measure_disease()` can be used to perform phytopathometric studies. A detailed explanation can be seen in the following manuscript.

<a href="https://www.researchgate.net/publication/353021781_Measuring_plant_disease_severity_in_R_introducing_and_evaluating_the_pliman_package" target="_blank" rel="noopener"><img src="https://github.com/TiagoOlivoto/tiagoolivoto/raw/master/static/tutorials/pliman_esalq/paper_rg.png" width="1000" height="273"/></a>


In brief, users need to provide sample pallets that represent the color classes (healthy, diseased, and background) in the image to be analyzed.


```r
library(pliman)
# set the path directory
path_soy <- "https://raw.githubusercontent.com/TiagoOlivoto/pliman/master/vignettes/imgs"
# import images
img <- image_import("leaf.jpg", path = path_soy)
healthy <- image_import("healthy.jpg", path = path_soy)
symptoms <- image_import("sympt.jpg", path = path_soy)
background <- image_import("back.jpg", path = path_soy)
image_combine(img, healthy, symptoms, background, ncol = 4)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/disease1-1.png" width="1152" />

Sample palettes can be made by simply manually sampling small areas of representative images and producing a composite image that will represent each of the desired classes (background, healthy, and symptomatic tissues). Another way is to use the `image_palette()` function to create sample color palettes


```r
pals <- image_palette(img, npal = 8)
image_combine(pals, ncol = 4)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-7-1.png" width="672" />


```r
# default settings
res <-
  measure_disease(img = img,
                  img_healthy = healthy,
                  img_symptoms = symptoms,
                  img_background = background,
                  show_image = FALSE,
                  save_image = TRUE,
                  dir_processed = tempdir())
res$severity
#    healthy symptomatic
# 1 89.27119    10.72881
```

Alternatively, users can create a mask instead of showing the original image.


```r
# create a personalized mask
res2 <- 
  measure_disease(img = img,
                  img_healthy = healthy,
                  img_symptoms = symptoms,
                  img_background = background,
                  show_original = FALSE, # create a mask
                  show_contour = FALSE, # hide the contour line
                  col_background = "white", # default
                  col_lesions = "black", # default
                  col_leaf = "green",
                  show_image = FALSE,
                  save_image = TRUE,
                  dir_processed = tempdir(),
                  prefix = "proc2_") 

res2$severity
#    healthy symptomatic
# 1 88.61436    11.38564
```


The results may vary depending on how palettes are chosen and are subjective due to the researcher’s experience. In the following example, I show a second example with a variation in the color palettes, where only the necrotic area is assumed to be the diseased tissue. Therefore, the symptomatic area will be smaller than the previous one.


```r
# import images
healthy2 <- image_import("healthy2.jpg", path = path_soy)
symptoms2 <- image_import("sympt2.jpg", path = path_soy)
background2 <- image_import("back2.jpg", path = path_soy)
image_combine(healthy2, symptoms2, background2, ncol = 3)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/disease4-1.png" width="1440" />

```r

res3 <-
  measure_disease(img = img,
                  img_healthy = healthy2,
                  img_symptoms = symptoms2,
                  img_background = background2,
                  show_image = FALSE,
                  save_image = TRUE,
                  dir_processed = tempdir(),
                  prefix = "proc3_")
res3$severity
#    healthy symptomatic
# 1 93.65719    6.342811

# combine the masks
masks <- 
  image_import(pattern = "proc",
               path = tempdir(),
               plot = TRUE,
               ncol = 3)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/disease4-2.png" width="1440" />


# Lesion features


```r
res4 <-
  measure_disease(img = img,
                  img_healthy = healthy,
                  img_symptoms = symptoms,
                  img_background = background,
                  show_features = TRUE,
                  marker = "area")
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-8-1.png" width="960" />

```r
res4$shape
#    id        x        y area perimeter radius_mean radius_min radius_max
# 1   1 222.3130 114.6097 1035       170   22.339665  0.2920516  38.980274
# 2   2 190.8581 130.8056 1332       219   20.445037  1.5551951  38.662849
# 3   3 178.9670 214.0985 3726       404   50.106176  1.9593910  95.058047
# 4   4 210.8052 194.4173 1838       222   24.204758  1.4817834  42.524049
# 5   5 264.2971 193.5652  138        41    6.224780  4.4097804   7.953052
# 6   6 120.4948 202.2990   97        31    5.138492  3.1849019   6.742861
# 9   7 211.9276 329.1351  925       126   18.389353  7.4493207  30.580630
# 11  8 281.2628 325.0620  274        56    9.113199  5.2290642  12.958184
# 12  9 347.9694 335.8605  294        56    9.529863  6.2387143  12.786438
# 14 10 184.7761 385.4308 1871       163   25.124882 12.7017588  38.174491
# 15 11 334.3464 370.2549  153        40    6.652527  4.3200116   9.190348
# 16 12 250.7095 377.2500  148        39    6.701419  3.5592108   9.380902
# 18 13 173.2803 450.1706 2269       239   28.767841 12.5082980  47.429064
# 21 14 110.1970 465.0644  264        65    8.927641  3.5456115  13.800300
# 22 15 123.6967 493.3245  943       114   17.852567  9.4786537  27.530894
# 23 16 149.9208 521.2183 1301       140   21.242699 11.1572000  33.015758
#    radius_sd radius_ratio major_axis eccentricity       theta
# 1  11.163014   133.470519   89.42319    0.9768497  1.39927478
# 2   8.995794    24.860449   72.75953    0.8867824  1.48033116
# 3  25.309074    48.514078  190.96246    0.9781812  1.16621696
# 4  10.150079    28.697884   81.14663    0.8428428  1.27701308
# 5   1.093704     1.803503   16.23906    0.7246037  0.11474134
# 6   1.000345     2.117133   13.64816    0.7240212  0.04168776
# 9   6.414117     4.105157   57.00194    0.9258327  1.53796799
# 11  2.061395     2.478108   25.33650    0.8318693 -0.43382014
# 12  1.957441     2.049531   25.80303    0.8209892  0.96330731
# 14  7.426579     3.005449   75.66131    0.9042416  1.20717566
# 15  1.353286     2.127390   17.67354    0.7588645  0.71082824
# 16  1.713426     2.635669   19.36235    0.8526921 -0.73479296
# 18  9.867100     3.791808   89.17478    0.8559365  0.98589396
# 21  2.850591     3.892220   26.70898    0.8397068  0.01007974
# 22  5.553782     2.904515   54.52703    0.9116833 -0.29170101
# 23  6.013110     2.959144   59.68798    0.8618813 -0.05630838
res4$statistics
#        stat   value
# 1         n    16.0
# 2  min_area    97.0
# 3 mean_area  1038.0
# 4  max_area  3726.0
# 5   sd_area  1008.6
# 6  sum_area 16608.0
```




# <i class="fas fa-scroll"></i> A little bit more!

<script src="https://kit.fontawesome.com/1f72d6921a.js" crossorigin="anonymous"></script>

> At [this link](https://tiagoolivoto.github.io/paper_pliman/code.html) you will find more examples on how to use {pliman} to analyze plant images. Source code and images can be downloaded [here](https://github.com/TiagoOlivoto/paper_pliman/archive/refs/heads/master.zip).

> The following talk (Portuguese language) was ministered to attend the invitation of the President of the Brazilian Region of the International Biometric Society (RBras).

<iframe width="860" height="505" src="https://www.youtube.com/embed/ElvUVlPocgA" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
