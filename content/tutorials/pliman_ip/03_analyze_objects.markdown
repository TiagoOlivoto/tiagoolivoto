---
title: Analyzing objects
linktitle: "3. Analyzing objects"
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
    weight: 4
weight: 3
---



# Image directory

```r
# mudar de acordo com a pasta em seu computador
setwd("E:/Desktop/tiagoolivoto/static/tutorials/pliman_ip/imgs")
```

# Working with polygons
> A 'polygon' is a plane figure that is described by a finite number of straight line segments connected to form a closed polygonal chain (Singer, 1993)[^1].

Given the above, we can conclude that image objects can be expressed as polygons with `n` vertices. `pliman` has a set of functions(`draw_*()`) useful for drawing common shapes like circles, squares, triangles, rectangles and `n`- tagons . Another group of ` poly_*()` functions can be used to analyze polygons. Let's start with a simple example related to the area and perimeter of a square.


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
square <- draw_square(side = 1)
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/unnamed-chunk-3-1.png" width="672" />

```r
poly_area(square)
```

```
## [1] 1
```

```r
poly_perimeter(square)
```

```
## [1] 4
```

Now, let's see what happens when we start with a hexagon and increase the number of sides up to 1000.


```r
shapes <- list(  side6 = draw_n_tagon(6, plot = FALSE),
                 side12 = draw_n_tagon(12, plot = FALSE),
                 side24 = draw_n_tagon(24, plot = FALSE),
                 side100 = draw_n_tagon(100, plot = FALSE),
                 side500 = draw_n_tagon(500, plot = FALSE),
                 side100 = draw_n_tagon(1000, plot = FALSE))

plot_polygon(shapes, merge = FALSE)
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/unnamed-chunk-4-1.png" width="672" />

```r
poly_area(shapes)
```

```
##    side6   side12   side24  side100  side500  side100 
## 2.598076 3.000000 3.105829 3.139526 3.141510 3.141572
```

```r
poly_perimeter(shapes)
```

```
##    side6   side12   side24  side100  side500  side100 
## 6.000000 6.211657 6.265257 6.282152 6.283144 6.283175
```


Note that when \$n \to \infty\$, the sum of the sides becomes the circumference of the circle, given by \$2 \pi r\$, and the area becomes \$\pi r^2\$. This is fun, but `pliman` is primarily designed for analyzing plant image analysis. So why use polygons? Let's see how we can use these functions to get applicable information.



```r
leaves <- image_import("ref_leaves.jpg", plot = TRUE)

# getting the outline of objects
cont <- object_contour(leaves, watershed = FALSE, index = "HI")
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/unnamed-chunk-5-1.png" width="768" />

```r
# plotting the polygon
plot_polygon(cont)
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/unnamed-chunk-5-2.png" width="768" />


Nice! We can use the contours of any object to get useful information related to its shape. To reduce the amount of output, I will only use five samples: 2, 4, 13, 24, and 35.


```r
cont <- cont[c("2", "4", "13", "24", "35")]
plot_polygon(cont)
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/unnamed-chunk-6-1.png" width="672" />

In the current version of `pliman`, you can calculate the following measurements. For more details, see Chen & Wang (2005)[^2], Claude (2008)[^3], and Montero et al. (2009)[^4].

## Area

The area of a shape is calculated using Shoelace 's formula (Lee and Lim, 2017)[^5], as follows

$$
A=\frac{1}{2}\left |\sum_{i=1}^{n}\left(x_{i} y_{i+1}-x_{i+1}y_{i}\right)\right|
$$


```r
poly_area(cont)
```

```
##       2       4      13      24      35 
## 44952.0 46622.0 15124.5 12060.0  1654.5
```


## Perimeter
The perimeter is calculated as the sum of the Euclidean distance between all points on a shape. Distances can be obtained with `poly_distpts()`.


```r
poly_perimeter(cont)
```

```
##         2         4        13        24        35 
## 1275.4550  891.4062  559.3991  460.3869  591.8112
```

```r
# perimeter of a circle with radius 2
circle <- draw_circle(radius = 2, plot = FALSE)
poly_perimeter(circle)
```

```
## [1] 12.56635
```

```r
# check the result
2*pi*2
```

```
## [1] 12.56637
```


## Radius

The radius of a pixel on the object's contour is calculated as its distance from the object's centroid(also called 'center of mass'). These distances can be obtained with `poly_centdist()`.


```r
dist <- poly_centdist(cont)

# stats for radius
mean_list(dist)
```

```
##         2         4        13        24        35 
## 119.33467 124.86878  71.91624  64.04449  72.09876
```

```r
min_list(dist)
```

```
##         2         4        13        24        35 
## 68.868885 89.614639 48.363509 47.880800  3.341768
```

```r
max_list(dist)
```

```
##         2         4        13        24        35 
## 170.41035 185.66189 108.03828  95.25586 143.80833
```

```r
sd_list(dist)
```

```
##        2        4       13       24       35 
## 20.80831 27.19785 14.60321 13.56119 41.34589
```

```r
# average radius of circle above
poly_centdist(circle) |> mean_list()
```

```
## [1] 1.999998
```



## Length and width

The length and width of an object are calculated with `poly_lw()`, as the difference between the maximum and minimum of the `x` and `y` coordinates after the object has been aligned with `poly_align()`.


```r
aligned <- poly_align(cont, plot = FALSE)
plot_polygon(aligned, merge = FALSE, ncol = 5)
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/unnamed-chunk-10-1.png" width="960" />

```r
# calculate length and width
poly_lw(cont)
```

```
##      length      width
## 2  312.9211 265.501918
## 4  351.6712 186.401587
## 13 186.3352 140.427787
## 24 184.0703 100.133973
## 35 286.2853   9.956061
```

## Circularity, eccentricity, diameter and elongation

Circularity(Montero et al. 2009)[^6] is also called shape compactness, or measure of roundness of an object. It is given by \$C = P^2 / A\$, where \$P\$ is the perimeter and \$A\$ is the area of the object.


```r
poly_circularity(cont)
```

```
##         2         4        13        24        35 
##  36.18939  17.04356  20.69009  17.57513 211.68962
```

As the above measurement depends on the scale, normalized roundness can be used. In this case, a perfect circle is assumed to have circularity equal to 1. This measure is invariant under translation, rotation and scale transformations, given \$Cn = P^2 / 4 \pi A\$


```r
poly_circularity_norm(cont)
```

```
##         2         4        13        24        35 
##  2.879860  1.356284  1.646465  1.398584 16.845725
```

```r
# normalized circularity for different shapes
draw_square(plot =FALSE) |> poly_circularity_norm()
```

```
## [1] 1.27324
```

```r
draw_circle(plot=FALSE) |> poly_circularity_norm()
```

```
## [1] 1.000003
```


` poly_circularity_haralick()` calculates the circularity of Haralick , CH(Haralick , 1974)[^7]. The method is based on calculating all Euclidean distances from the object's centroid to each contour pixel. With this set of distances, the mean($m$) and the standard deviation($s$) are calculated. These statistical parameters are used in a ratio that calculates CH as $CH = m/ sd $.


```r
poly_circularity_haralick(cont)
```

```
##        2        4       13       24       35 
## 5.734954 4.591127 4.924687 4.722631 1.743795
```

`poly_convexity()` Calculates the convexity of a shape using a ratio of the perimeter of the convex hull to the perimeter of the polygon.


```r
poly_convexity(cont)
```

```
##         2         4        13        24        35 
## 0.6456159 0.9093251 0.7675646 0.9267030 0.7180971
```


`poly_eccentricity()` Calculates the eccentricity of a shape using the ratio of the eigenvalues(coordinate inertia axes).


```r
poly_eccentricity(cont)
```

```
##           2           4          13          24          35 
## 0.841114622 0.402214559 0.599908673 0.412005655 0.001474145
```


`poly_elongation()` Calculates the elongation of an object as `1 - width / length`


```r
poly_elongation(cont)
```

```
##         2         4        13        24        35 
## 0.1515373 0.4699549 0.2463701 0.4560015 0.9652233
```


`poly_caliper()` Calculates the gauge(also called Feret's diameter).


```r
poly_caliper(cont)
```

```
##        2        4       13       24       35 
## 317.6303 351.7528 187.4807 184.1738 286.2953
```


Users can use the `poly_measures()` function to calculate most object measurements in a single call.


```r
measures <- poly_measures(cont) |> round_cols()
t(measures)
```

```
##                             2        4       13       24      35
## id                       1.00     2.00     3.00     4.00    5.00
## x                      910.85   275.06   866.76   959.61  455.04
## y                      190.05   220.21   482.69   622.00  733.98
## area                 44952.00 46622.00 15124.50 12060.00 1654.50
## area_ch              57389.50 47114.00 16451.00 12404.00 2129.00
## perimeter             1275.45   891.41   559.40   460.39  591.81
## radius_mean            119.33   124.87    71.92    64.04   72.10
## radius_min              68.87    89.61    48.36    47.88    3.34
## radius_max             170.41   185.66   108.04    95.26  143.81
## radius_sd               20.81    27.20    14.60    13.56   41.35
## radius_ratio             2.47     2.07     2.23     1.99   43.03
## diam_mean              238.67   249.74   143.83   128.09  144.20
## diam_min               137.74   179.23    96.73    95.76    6.68
## diam_max               340.82   371.32   216.08   190.51  287.62
## caliper                317.63   351.75   187.48   184.17  286.30
## length                 312.92   351.67   186.34   184.07  286.29
## width                  265.50   186.40   140.43   100.13    9.96
## solidity                 0.78     0.99     0.92     0.97    0.78
## convexity                0.65     0.91     0.77     0.93    0.72
## elongation               0.15     0.47     0.25     0.46    0.97
## circularity             36.19    17.04    20.69    17.58  211.69
## circularity_haralick     3.31     3.29     3.31     3.53    0.08
## circularity_norm         2.88     1.36     1.65     1.40   16.85
## eccentricity             0.84     0.40     0.60     0.41    0.00
```

If the image resolution is known, the measurements can be corrected with ` get_measures()`. Image resolution can be obtained using a known distance in the image. In the example, the white square has a side of 5 cm. So using `dpi()` the resolution can be obtained. In this case, the dpi is ~50.


```r
(color_measures <- get_measures(measures, dpi = 50))
```

```
##    id      x      y    area area_ch perimeter radius_mean radius_min radius_max
## 2   1 910.85 190.05 116.005 148.102    64.793       6.062      3.499      8.657
## 4   2 275.06 220.21 120.315 121.584    45.284       6.343      4.552      9.432
## 13  3 866.76 482.69  39.031  42.454    28.418       3.654      2.457      5.488
## 24  4 959.61 622.00  31.123  32.010    23.388       3.253      2.432      4.839
## 35  5 455.04 733.98   4.270   5.494    30.064       3.663      0.170      7.306
##    radius_sd radius_ratio diam_mean diam_min diam_max caliper length  width
## 2      1.057        0.125    12.124    6.997   17.314  16.136 15.896 13.487
## 4      1.382        0.105    12.687    9.105   18.863  17.869 17.865  9.469
## 13     0.742        0.113     7.307    4.914   10.977   9.524  9.466  7.134
## 24     0.689        0.101     6.507    4.865    9.678   9.356  9.351  5.087
## 35     2.101        2.186     7.325    0.339   14.611  14.544 14.544  0.506
##    solidity convexity elongation circularity circularity_haralick
## 2      0.78      0.65       0.15       36.19                 3.31
## 4      0.99      0.91       0.47       17.04                 3.29
## 13     0.92      0.77       0.25       20.69                 3.31
## 24     0.97      0.93       0.46       17.58                 3.53
## 35     0.78      0.72       0.97      211.69                 0.08
##    circularity_norm eccentricity
## 2              2.88         0.84
## 4              1.36         0.40
## 13             1.65         0.60
## 24             1.40         0.41
## 35            16.85         0.00
```


Some useful functions can be used to manipulate coordinates. In the following example I will show some features implemented in `pliman`. Just for simplicity, I'll just use object 2.



```r
o2 <- cont[["2"]]
plot_polygon(o2)
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/unnamed-chunk-20-1.png" width="672" />

## Rotate polygons

` poly_rotate()` can be used to rotate the polygon coordinates by an `angle` (0-360 degrees) in the trigonometric (anti-clockwise) direction.



```r
rot <- poly_rotate(o2, angle = 45)
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/unnamed-chunk-21-1.png" width="384" />


## Invert polygons
` poly_flip_x()` and ` poly_flip_y()` can be used to flip shapes along the x and y axis, respectively.


```r
flipped <- 
  list(fx = poly_flip_x(o2), 
       fy = poly_flip_y(o2))

plot_polygon(flipped, merge = FALSE, aspect_ratio = 1)
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/unnamed-chunk-22-1.png" width="768" />


## Perimeter sampling

`poly_sample()` samples `n` coordinates between existing points, and `poly_sample_prop()` samples a proportion of coordinates between existing ones.


```r
# sample 50 coordinates
poly_sample(o2, n=50) |> plot_polygon()
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/unnamed-chunk-23-1.png" width="384" />

```r
# sample 10% of coordinates
poly_sample_prop(o2, prop = 0.1) |> plot_polygon()
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/unnamed-chunk-23-2.png" width="384" />


## smoothing

`poly_smooth()` smooths the contour of a polygon by combining ` prop` coordinate point samples and interpolating them using ` vertices` vertices(default is 1000) .


```r
smoothed <-
  list( original = o2,
        s1 = poly_smooth(o2, prop = 0.2, plot = FALSE),
        s2 = poly_smooth(o2, prop = 0.1, plot = FALSE),
        s1 = poly_smooth(o2, prop = 0.04, plot = FALSE)
  )

plot_polygon(smoothed, merge = FALSE, ncol = 2)
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/unnamed-chunk-24-1.png" width="576" />


## Noises


`poly_jitter()` adds a small amount of noise to a set of coordinates. See `base::jitter()` for more details.


```r
set.seed(1)
c1 <- draw_circle(n = 200, plot = FALSE)
c2 <- draw_circle(n = 200, plot = FALSE) |>
  poly_jitter(noise_x = 100,
              noise_y = 100,
              plot = FALSE)

plot_polygon(list(c1, c2), merge = FALSE)
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/unnamed-chunk-25-1.png" width="768" />




# Analyzing objects

The functions seen so far can be used to obtain measurements of objects. However, for image analysis it is necessary to combine different functions(mainly `object_contour()` and `poly_measures()`). Also, almost always, several images need to be analyzed and repeating this process each time would be tedious and inefficient. To address these needs, users can use the ` analyze_objects()` function. Let's start with a simple example, using the `object_300dpi.png` image available on [ GitHub page](https://github.com/TiagoOlivoto/pliman/tree/master/inst/tmp_images). To facilitate importing images from this folder, an `image_pliman()` helper function is used.



```r
# generate html tables
print_tbl <- function(table, digits = 3, ...){
  knitr :: kable(table, booktabs = TRUE, digits = digits, ...)
}
library(pliman)
library(tidyverse)
## Warning: package 'tidyverse' was built under R version 4.1.3
## -- Attaching packages --------------------------------------- tidyverse 1.3.1 --
## v ggplot2 3.3.5     v purrr   0.3.4
## v tibble  3.1.6     v dplyr   1.0.8
## v tidyr   1.2.0     v stringr 1.4.0
## v readr   2.1.2     v forcats 0.5.1
## -- Conflicts ------------------------------------------ tidyverse_conflicts() --
## x forcats::%>%()               masks stringr::%>%(), dplyr::%>%(), purrr::%>%(), tidyr::%>%(), tibble::%>%(), pliman::%>%()
## x tibble::column_to_rownames() masks pliman::column_to_rownames()
## x dplyr::filter()              masks stats::filter()
## x dplyr::lag()                 masks stats::lag()
## x tibble::remove_rownames()    masks pliman::remove_rownames()
## x tibble::rownames_to_column() masks pliman::rownames_to_column()
library(patchwork)

img <- image_pliman("objects_300dpi.jpg", plot = TRUE)
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/unnamed-chunk-26-1.png" width="672" />



The image above was produced with Microsoft PowerPoint. It has a known resolution of 300 dpi(dots per inch) and displays four objects

- Larger square: 10 x 10 cm (100 cm\$^2\$)
- Smaller square: 5 x 5 cm(25 cm\$^2\$)
- Rectangle: 4 x 2 cm(8 cm\$^2\$)
- Circle: 3 cm in diameter(~7.07 cm\$^2\$)


To count the objects in the image we use `analyze_objects()` and inform the image(the only required argument). By default, the `NB` index is used for object segmentation.



```r
img_res <- analyze_objects(img, marker = "id")
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/unnamed-chunk-27-1.png" width="960" />



## Adjusting object measurements

The results were stored in `img_res`. Since there is no scale declared in the example above, we have no idea about the actual area of objects in cm$^2$, only in pixels. In this case, we use `get_measures()` to adjust pixel measurements to metric units.

There are two main ways to adjust object measurements (from pixels to cm, for example). The first is to declare the known area, perimeter or radius of a given object. The measure for the other objects will then be calculated by a simple rule of three. The second is by declaring a known image resolution in dpi(dots per inch). In this case, perimeter, area and radius will be adjusted by the dpi informed.

### Declaring a known value

Since we know the area of the larger square (object 1), let's adjust the area of the other objects in the image using this.



```r
get_measures(img_res ,
             id = 1,
             area ~ 100)
```

```
## -----------------------------------------
## measures corrected with:
## object id: 1
## area     : 100
## -----------------------------------------
## Total    : 39.985 
## Average  : 13.328 
## -----------------------------------------
```

```
##   id        x        y   area area_ch perimeter radius_mean radius_min
## 2  2 1737.513  453.246 25.041  24.978    21.980       2.865      2.495
## 3  3 1737.575 1296.331  7.023   7.015     9.903       1.491      1.483
## 4  4 1737.972  939.503  7.922   7.880    11.906       1.666      0.986
##   radius_max radius_sd diam_mean diam_min diam_max major_axis minor_axis length
## 2      3.524     0.313     5.730    4.989    7.049      5.781      5.776  5.058
## 3      1.502     0.003     2.983    2.967    3.003      2.991      2.990  2.987
## 4      2.222     0.424     3.332    1.973    4.444      4.611      2.291  3.993
##   width radius_ratio eccentricity  theta solidity convexity elongation
## 2 5.050        1.413        0.999  1.539    1.003     0.681      0.002
## 3 2.992        1.012        0.998 -1.490    1.001     0.921     -0.001
## 4 1.976        2.253        0.346  0.000    1.005     0.837      0.505
##   circularity circularity_haralick circularity_norm
## 2      19.294                9.144            1.541
## 3      13.965              441.819            1.117
## 4      17.894                3.929            1.433
```



The same can be used to adjust measurements based on perimeter or radius. Let's adjust the perimeter of the objects by the perimeter of object 2(20 cm).


### Declaring the image resolution

If the image resolution is known, all measurements will be adjusted accordingly. Let's see a numerical example with `pixels_to_cm()`. This function converts the number of pixels(* px *) into cm, considering the image resolution in ` dpi `, as follows: \$cm = px \times(2.54 / dpi)\$. As we know the number of pixels of the larger square, its perimeter in cm is given by




```r
# number of pixels for the perimeter of the largest square

ls_px <- img_res$results$perimeter [1]
pixels_to_cm(px = ls_px , dpi = 300)
```

```
## [1] 39.9046
```

The perimeter of object 1 adjusted by image resolution is very close to the known value (40 cm). Below, the values of all measures are adjusted by declaring the `dpi` argument in `get_measures()`.


```r
img_res_cor <- get_measures(img_res , dpi = 300)

t(img_res_cor) |>
  print_tbl()
```



|                     |       1|        2|        3|        4|
|:--------------------|-------:|--------:|--------:|--------:|
|id                   |   1.000|    2.000|    3.000|    4.000|
|x                    | 668.506| 1737.513| 1737.575| 1737.972|
|y                    | 798.002|  453.246| 1296.331|  939.503|
|area                 |  99.729|   24.973|    7.004|    7.900|
|area_ch              |  99.644|   24.910|    6.996|    7.858|
|perimeter            |  39.905|   21.950|    9.890|   11.890|
|radius_mean          |   5.725|    2.861|    1.489|    1.664|
|radius_min           |   4.985|    2.491|    1.481|    0.985|
|radius_max           |   7.052|    3.520|    1.500|    2.219|
|radius_sd            |   0.628|    0.313|    0.003|    0.423|
|diam_mean            |  11.450|    5.722|    2.979|    3.327|
|diam_min             |   9.970|    4.983|    2.963|    1.970|
|diam_max             |  14.105|    7.039|    2.999|    4.438|
|major_axis           |  11.536|    5.773|    2.987|    4.604|
|minor_axis           |  11.526|    5.768|    2.986|    2.288|
|length               |  10.034|    5.051|    2.983|    3.988|
|width                |  10.017|    5.043|    2.988|    1.973|
|radius_ratio         |   1.415|    1.413|    1.012|    2.253|
|eccentricity         |   0.999|    0.999|    0.998|    0.346|
|theta                |   0.014|    1.539|   -1.490|    0.000|
|solidity             |   1.001|    1.003|    1.001|    1.005|
|convexity            |   0.752|    0.681|    0.921|    0.837|
|elongation           |   0.002|    0.002|   -0.001|    0.505|
|circularity          |  15.967|   19.294|   13.965|   17.894|
|circularity_haralick |   9.113|    9.144|  441.819|    3.929|
|circularity_norm     |   1.273|    1.541|    1.117|    1.433|



### Understanding measurements


```r
object_contour(img) %>% # get the contour of objects
  poly_mass() %>% # computes center of mass and minimum and maximum radii
  plot_mass() # plot the measurements
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/unnamed-chunk-31-1.png" width="672" />

* Larger square:
- The minimum diameter(a = 9.97) can be considered as the side of the square
- The maximum diameter, given by \$a \sqrt {2}\$ can be considered the diagonal of the square (\$9.97 \sqrt {2} = 14,099 \approx 14,105\$


```r
t(img_res_cor) |>
  print_tbl() 
```



|                     |       1|        2|        3|        4|
|:--------------------|-------:|--------:|--------:|--------:|
|id                   |   1.000|    2.000|    3.000|    4.000|
|x                    | 668.506| 1737.513| 1737.575| 1737.972|
|y                    | 798.002|  453.246| 1296.331|  939.503|
|area                 |  99.729|   24.973|    7.004|    7.900|
|area_ch              |  99.644|   24.910|    6.996|    7.858|
|perimeter            |  39.905|   21.950|    9.890|   11.890|
|radius_mean          |   5.725|    2.861|    1.489|    1.664|
|radius_min           |   4.985|    2.491|    1.481|    0.985|
|radius_max           |   7.052|    3.520|    1.500|    2.219|
|radius_sd            |   0.628|    0.313|    0.003|    0.423|
|diam_mean            |  11.450|    5.722|    2.979|    3.327|
|diam_min             |   9.970|    4.983|    2.963|    1.970|
|diam_max             |  14.105|    7.039|    2.999|    4.438|
|major_axis           |  11.536|    5.773|    2.987|    4.604|
|minor_axis           |  11.526|    5.768|    2.986|    2.288|
|length               |  10.034|    5.051|    2.983|    3.988|
|width                |  10.017|    5.043|    2.988|    1.973|
|radius_ratio         |   1.415|    1.413|    1.012|    2.253|
|eccentricity         |   0.999|    0.999|    0.998|    0.346|
|theta                |   0.014|    1.539|   -1.490|    0.000|
|solidity             |   1.001|    1.003|    1.001|    1.005|
|convexity            |   0.752|    0.681|    0.921|    0.837|
|elongation           |   0.002|    0.002|   -0.001|    0.505|
|circularity          |  15.967|   19.294|   13.965|   17.894|
|circularity_haralick |   9.113|    9.144|  441.819|    3.929|
|circularity_norm     |   1.273|    1.541|    1.117|    1.433|


The `analyze_objects()` function calculates a range of measurements that can be used to study the shape of objects, such as leaves. As an example, I will use the `potato_leaves.png` image, which was collected from [Gupta et al.(2020)](https://doi.org/10.1111/nph.16286).



```r
potato <- image_pliman("potato_leaves.jpg", plot = TRUE)

pot_meas <-
  analyze_objects(potato,
                  watershed = FALSE,
                  marker = "id",
                  show_chull = TRUE) # show the convex hull
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/potato-1.png" width="960" />

```r
pot_meas$results %>%
  print_tbl()
```



| id|       x|       y|  area| area_ch| perimeter| radius_mean| radius_min| radius_max| radius_sd| diam_mean| diam_min| diam_max| major_axis| minor_axis|  length|   width| radius_ratio| eccentricity|  theta| solidity| convexity| elongation| circularity| circularity_haralick| circularity_norm|
|--:|-------:|-------:|-----:|-------:|---------:|-----------:|----------:|----------:|---------:|---------:|--------:|--------:|----------:|----------:|-------:|-------:|------------:|------------:|------:|--------:|---------:|----------:|-----------:|--------------------:|----------------:|
|  1| 854.542| 224.043| 51380|   54536|  1005.916|     131.565|     92.111|    198.025|    26.061|   263.131|  184.222|  396.050|    305.737|    242.212| 345.519| 254.702|        2.150|        0.623|  1.394|    0.942|     0.914|      0.263|      19.694|                5.048|            1.580|
|  2| 197.844| 217.851| 58923|   76706|  1243.597|     140.296|     70.106|    192.361|    28.585|   280.592|  140.212|  384.723|    318.244|    274.128| 330.014| 330.998|        2.744|        0.789| -0.099|    0.768|     0.739|     -0.003|      26.247|                4.908|            2.108|
|  3| 536.210| 240.238| 35117|   62792|  1518.592|     109.900|     38.137|    188.511|    35.510|   219.800|   76.273|  377.021|    253.498|    243.279| 293.957| 306.794|        4.943|        0.924|  1.097|    0.559|     0.565|     -0.044|      65.670|                3.095|            5.325|



The three main measurements(in pixel units) are:

1. ` area ` the area of the object.
2. ` area_ch ` the area of the convex hull.
3. `perimeter` the perimeter of the object.


## Single image processing

In the following example, I show how to plot the length and width of each leaf in the following image.



```r
leaves <- image_import("folhas.jpg", plot = TRUE)
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/unnamed-chunk-33-1.png" width="672" />

```r
leaves_meas <-
  analyze_objects(leaves ,
                  watershed = FALSE,
                  col_background = "black")

leaves_cor <- get_measures(leaves_meas , dpi = 300)

t(leaves_cor) |>
  print_tbl()
```



|                     |       1|       2|
|:--------------------|-------:|-------:|
|id                   |   1.000|   2.000|
|x                    | 528.653| 233.994|
|y                    | 299.984| 825.804|
|area                 |   5.871|   3.874|
|area_ch              |   5.947|   4.207|
|perimeter            |  12.020|   9.747|
|radius_mean          |   1.592|   1.145|
|radius_min           |   0.736|   0.836|
|radius_max           |   2.672|   1.665|
|radius_sd            |   0.583|   0.219|
|diam_mean            |   3.185|   2.290|
|diam_min             |   1.473|   1.672|
|diam_max             |   5.343|   3.330|
|major_axis           |   4.844|   2.861|
|minor_axis           |   1.565|   1.743|
|length               |   5.240|   3.193|
|width                |   1.603|   1.883|
|radius_ratio         |   3.629|   1.991|
|eccentricity         |   0.135|   0.421|
|theta                |  -1.056|  -0.087|
|solidity             |   0.987|   0.921|
|convexity            |   0.918|   0.773|
|elongation           |   0.694|   0.410|
|circularity          |  24.608|  24.521|
|circularity_haralick |   2.732|   5.239|
|circularity_norm     |   1.973|   1.969|

```r
# plot width and length
plot_measures(leaves_cor , measure = "width")
plot_measures(leaves_cor , measure = "length", vjust = 50)
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/unnamed-chunk-33-2.png" width="672" />



Here, we will count the grains in the `grains.jpg` image. This image has a cyan background and contains 90 soybeans that touch each other. The ` analyze_objects()` function segments the image using the normalized blue index by default, as follows \$NB =(B /(R + G + B))\$, where *R*, *G* and *B * are the red, green and blue bands. Note that if the image is contained in the default directory, it is not necessary to import it. Just enter the image name in quotes in the `img` argument(e.g., `img = "grains"`).

In this example, objects are counted and segmented objects are colored with random colors using the `show_segmentation = TRUE` argument. Users can set ` show_contour = FALSE` to remove the contour line and identify the objects (in this example, the grains) using the `marker = "id"` arguments. The background color can also be changed with `col_background`.




```r
count <-
  analyze_objects("grains",
                  show_segmentation = TRUE,
                  show_contour = FALSE,
                  marker = "id")
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/unnamed-chunk-34-1.png" width="1152" />

```r
count$statistics
```

```
##        stat       value
## 1         n    90.00000
## 2  min_area   439.00000
## 3 mean_area   670.71111
## 4  max_area   834.00000
## 5   sd_area    71.51636
## 6  sum_area 60364.00000
```



```r
# Get the measurements of the object
measurements <- get_measures(count)
head(measurements)
```

```
##   id       x       y area area_ch perimeter radius_mean radius_min radius_max
## 1  1 351.824 411.147  834     800   103.669      15.827     14.814     16.877
## 2  2 824.939 264.776  818     796   106.497      15.707     13.713     17.676
## 3  3 710.004 262.800  761     733   100.255      15.112     12.886     17.048
## 4  4 811.438 198.836  730     700    97.083      14.792     13.908     15.505
## 5  5 818.924 714.852  735     707    98.255      14.834     13.673     16.038
## 6  6 807.158 341.957  752     721    98.841      15.021     13.581     16.724
##   radius_sd diam_mean diam_min diam_max major_axis minor_axis length  width
## 1     0.467    31.654   29.628   33.753     33.480     31.734 33.241 31.850
## 2     1.186    31.414   27.425   35.353     35.620     29.272 34.851 29.316
## 3     1.175    30.224   25.773   34.097     34.365     28.228 33.818 27.708
## 4     0.316    29.585   27.817   31.009     30.713     30.268 30.013 29.035
## 5     0.578    29.668   27.347   32.076     31.955     29.302 31.378 29.151
## 6     0.812    30.042   27.163   33.447     33.092     28.966 33.014 28.896
##   radius_ratio eccentricity  theta solidity convexity elongation circularity
## 1        1.139        0.927  1.331    1.042     0.879      0.042      12.886
## 2        1.289        0.739 -0.311    1.028     0.914      0.159      13.865
## 3        1.323        0.749 -0.261    1.038     0.882      0.181      13.208
## 4        1.115        0.981 -1.567    1.043     0.900      0.033      12.911
## 5        1.173        0.881 -1.227    1.040     0.886      0.071      13.135
## 6        1.231        0.806  0.574    1.043     0.875      0.125      12.991
##   circularity_haralick circularity_norm
## 1               33.906            1.086
## 2               13.241            1.171
## 3               12.857            1.117
## 4               46.798            1.092
## 5               25.666            1.112
## 6               18.506            1.099
```


In the following example, we will select objects with an area above the average of all objects using ` lower_size = 719.1`.




```r
analyze_objects("grains",
                marker = "id",
                lower_size = 719.1)
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/unnamed-chunk-36-1.png" width="1152" />



Users can also use the `topn _*` arguments to select the `n` objects based on the smallest or largest areas. Let's see how to select the 5 grains with the smallest area, showing the original grains on a blue background. We will also use the `my_index` argument to choose a custom index to segment the image. Just for comparison, we will explicitly set the normalized blue index by calling `my_index = "B /(R + G + B)"`.




```r
analyze_objects("grains",
                marker = "id",
                topn_lower = 5,
                col_background = "salmon",
                my_index = "B /(R + G + B)") # normalized blue(NB)
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/unnamed-chunk-37-1.png" width="1152" />



## Batch processing

In image analysis, it is often necessary to process more than one image. For example, in plant breeding, the number of grains per plant(eg wheat) is often used in indirect selection of high-yielding plants. In `pliman`, batch processing can be done when the user declares the `pattern` argument.


To speed up processing time, especially for large numbers of images, the `parallel = TRUE` argument can be used. In this case, images are processed asynchronously (in parallel) in separate `R` sessions running in the background on the same machine. The number of sections is set to 50% of available cores. This number can be explicitly controlled with the `workers` argument.



```r
system.time(
  list_res <- analyze_objects(pattern = "img_sb", show_image = FALSE)
)
```

```
## Processing image img_sb_50_1 |===                                | 8% 00:00:00 
Processing image img_sb_50_10 |=====                             | 15% 00:00:01 
Processing image img_sb_50_11 |========                          | 23% 00:00:01 
Processing image img_sb_50_12 |==========                        | 31% 00:00:01 
Processing image img_sb_50_13 |=============                     | 38% 00:00:02 
Processing image img_sb_50_2 |================                   | 46% 00:00:02 
Processing image img_sb_50_3 |===================                | 54% 00:00:03 
Processing image img_sb_50_4 |======================             | 62% 00:00:04 
Processing image img_sb_50_5 |========================           | 69% 00:00:05 
Processing image img_sb_50_6 |===========================        | 77% 00:00:05 
Processing image img_sb_50_7 |==============================     | 85% 00:00:06 
Processing image img_sb_50_8 |================================   | 92% 00:00:07 
Processing image img_sb_50_9 |===================================| 100% 00:00:08 
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
##      8.15      0.34      8.52
```

```r
# parallel processing
# 6 multiple sections (50% of my pc's cores)
system.time(
  list_res <-
    analyze_objects(pattern = "img_sb",
                    show_image = FALSE,
                    parallel = TRUE)
)
```

```
## Image processing using multiple sessions (6). Please wait.
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
##      0.08      0.03      4.43
```




# Object coordinates
Users can get the coordinates for all desired objects with `object_coord()`. When the `id` argument is set to `NULL` (default), a bounding rectangle is drawn including all objects. Use `id = "all"` to get the coordinates of all objects in the image or use a numeric vector to indicate the objects to calculate the coordinates. Note that the `watershed = FALSE` argument is used to avoid unique objects being split up into multiple objects by the watershed segmentation algorithm.



```r
leaves <- image_import("folhas.jpg", plot = TRUE)

# get the id of each object
object_id(leaves, watershed = FALSE)
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/objec2-1.png" width="672" />

```r
# Get the coordinates of a bounding rectangle around all objects
object_coord(leaves, watershed = FALSE)
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/objec2-2.png" width="672" />

```
## $col_min
## [1] 49
## 
## $col_max
## [1] 937
## 
## $row_min
## [1] 41
## 
## $row_max
## [1] 702
```

```r
# Get coordinates for all objects
object_coord(leaves ,
             id = "all",
             watershed = FALSE)
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/objec2-3.png" width="672" />

```
## $col_min
## [1]  49 710
## 
## $col_max
## [1] 603 937
## 
## $row_min
## [1] 379  41
## 
## $row_max
## [1] 702 424
```

```r
# Get the coordinates of objects 1 and 2
# 20 border pixels
object_coord(leaves ,
             id = 1,
             edge = 20,
             watershed = FALSE)
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/objec2-4.png" width="672" />

```
## $col_min
## [1] 31
## 
## $col_max
## [1] 621
## 
## $row_min
## [1] 361
## 
## $row_max
## [1] 720
```



# Isolating objects

Knowing the coordinates of each object, it is possible to isolate it. The `object_isolate()` function is used for this. In the following example, I will isolate object 1 and set a 10-pixel border around the object.


```r
id1 <-
  object_isolate(leaves ,
                 watershed = FALSE,
                 id = 1,
                 edge = 10)
plot(id1)
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/object3-1.png" width="672" />

# Including objects in a list

`object_split()` can be used to split up a series of objects contained in a single image into a list, where each element is one object. By default, the background is removed and shown in white.


```r
list <- object_split(leaves, watershed = FALSE)
```

```
## ==============================
## Summary of the procedure
## ==============================
## Number of objects: 2 
## Average area     : 67972 
## Minimum area     : 54043 
## Maximum area     : 81901 
## Objects created  : 2 
## ==============================
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/unnamed-chunk-39-1.png" width="960" />

```r
str(list)
```

```
## List of 2
##  $ 1:Formal class 'Image' [package "EBImage"] with 2 slots
##   .. ..@ .Data    : num [1:330, 1:561, 1:3] 1 1 1 1 1 1 1 1 1 1 ...
##   .. ..@ colormode: int 2
##   .. ..$ dim: int [1:3] 330 561 3
##  $ 2:Formal class 'Image' [package "EBImage"] with 2 slots
##   .. ..@ .Data    : num [1:390, 1:234, 1:3] 1 1 1 1 1 1 1 1 1 1 ...
##   .. ..@ colormode: int 2
##   .. ..$ dim: int [1:3] 390 234 3
```



# RGB values for each object

To get the RGB intensity of each object in the image, we use the `object_rgb = TRUE` argument in the `analyze_objects()` function. In the following example, we will use the R, G and B bands and their normalized values. The `pliman_indexes()` function returns the indexes available in the package. To compute a specific index, simply enter a formula containing the values of R, G, or B (e.g. `object_index = "B/G+R"`).




```r
img <- image_import("green.jpg", plot = TRUE)
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/rgb2-1.png" width="960" />

```r
(indx <- pliman_indexes())
```

```
##  [1] "R"     "G"     "B"     "NR"    "NG"    "NB"    "GB"    "RB"    "GR"   
## [10] "BI"    "BIM"   "SCI"   "GLI"   "HI"    "NGRDI" "NDGBI" "NDRBI" "I"    
## [19] "S"     "VARI"  "HUE"   "HUE2"  "BGI"   "L"     "GRAY"  "GLAI"  "SAT"  
## [28] "CI"    "SHP"   "RI"
```

```r
soy_green <-
  analyze_objects(img ,
                  object_index = indx [1:6], # R:NB
                  marker = "id",
                  marker_col = "black",
                  col_background = "white",
                  show_contour = FALSE)
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/rgb2-2.png" width="960" />

```r
# PCA with the indices
ind <- summary_index(soy_green, type ="var")
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/rgb2-3.png" width="960" />

The `R` index provided the greatest contribution to the variation of PC1. The biplot containing the indices (variables) and the grains (individuals) can be seen below.


```r
get_biplot(ind$pca_res, show = "var")
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/unnamed-chunk-40-1.png" width="768" /><img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/unnamed-chunk-40-2.png" width="768" />

```r
get_biplot(ind$pca_res, show = "ind")
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/unnamed-chunk-40-3.png" width="768" />


Now, let's plot the `R` index on each object


```r
plot(img)
plot_measures(soy_green ,
              measure = "R",
              col = " black ")
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/unnamed-chunk-41-1.png" width="672" />


It seems that grains with average red (`R`) value less than 0.6 can be considered greenish seeds. Users can then work with this feature and adapt it to their case.


```r
report <-
  summary_index(soy_green ,
                index = "R",
                cut_point = 0.6,
                plot = FALSE)
ids <- report$ids
report$between_id
```

```
##    n nsel prop mean_index_sel mean_index_nsel
## 1 50    5  0.1      0.5448581       0.7053636
```

```r
report$within_id[ids,]
```

```
##    id        x        y n_less n_greater less_ratio greater_ratio
## 30 30 520.5038 364.3333   2717       169      0.941         0.059
## 45 45 732.0470 638.1619   1588       370      0.811         0.189
## 47 47 282.1431 502.3110   1179       834      0.586         0.414
## 48 48 207.0196 808.0633    851       934      0.477         0.523
## 50 50 511.4493 808.5008   2389        15      0.994         0.006
```

```r
# ratio of pixels of each object(above and below 0.6)
barplot(t(report$within_id [,6:7]) |> as.matrix(),
        legend = c("R < 0.6", "R > 0.6"))
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/rgb4-1.png" width="960" />


In the following graph, I plot the distribution of the greenish and non-greenish R, G, and B values.


```r
# distribution of RGB values
rgbs <-
  soy_green$object_rgb |>
  mutate(type = ifelse(id %in% ids, " Greenish ", " No greenish ")) |>
  select(-id) |>
  pivot_longer(-type)

ggplot(rgbs, aes(x = value)) +
  geom_density(aes(fill = name), alpha = 0.5) +
  facet_wrap(~ type)
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/unnamed-chunk-42-1.png" width="672" />

Now, using the ids of each grain, I plot the values only in the greenish ones.



```r
# plot 
plot(img)
plot_measures(soy_green ,
              id = ids,
              measure = "R",
              col = "black")
cont <- object_contour(img , show_image = FALSE)

plot_contour(cont,
             id = ids,
             col = "red")
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/unnamed-chunk-43-1.png" width="672" />


When there are many objects, the `parallel = TRUE` argument will speed up extracting the RGB values. In the following example, an image with 1343 grains of *Vicia cracca* is analyzed. The indices `"R"` and `"R/G"` are computed. Grains with an average red value greater than 0.25 are highlighted.


```r
img2 <- image_import("vicia.jpg", plot = TRUE)

vicia <-
  analyze_objects(img2,
                  index = "B",
                  object_index = "R",
                  show_image = FALSE,
                  parallel = TRUE)

summary_index <-
  summary_index(vicia ,
                index = "R",
                cut_point = 0.25,
                select_higher = TRUE)

count2 <-
  object_contour(img2,
                 index = "B",
                 show_image = FALSE)

ids2 <- summary_index$ids
plot_contour(count2, id = ids2, col = "red")
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/rgb5-1.png" width="1152" />




# Leaf area
## Known resolution


```r
leaves <- image_import(image = "ref_leaves.jpg", plot = TRUE)
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/unnamed-chunk-44-1.png" width="672" />

```r
af <-
  analyze_objects(leaves ,
                  watershed = FALSE,
                  show_contour = FALSE,
                  col_background = "black",
                  marker = "id")
af_cor <- get_measures(af, dpi = 50.5)

plot_measures(af_cor ,
              measure = "area",
              vjust = -30,
              col = " red ")
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/unnamed-chunk-44-2.png" width="672" />



## Reference object (dev version)

The `reference` argument can now be used to correct the object measures even when images with different shooting distances are used. In this example, the leaf area of the `ref_leaves` image is quantified and corrected considering a 5 x 5 (25 cm\$^2\$) white square as the reference object. For this, it is necessary to provide color palettes referring to the background (`background`), leaves (` foreground`) and the reference object (`reference`). Also, the area of the reference object needs to be informed in `reference_area`.


```r
img <- image_import(pattern = "ref_", plot = TRUE)
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/unnamed-chunk-45-1.png" width="672" />

```r
area <-
  analyze_objects(img = "ref_leaves",
                  foreground = "ref_folha",
                  background = "ref_back",
                  reference = "ref_ref",
                  reference_area = 25,
                  marker = "area",
                  watershed = FALSE)
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/unnamed-chunk-45-2.png" width="672" />




## Filling 'holes'

An important aspect to consider in leaf area measures is when leaves present 'holes'. This can occur, for example, by the attack of pests. In this case, the area would have to be considered, because it was there! The image bellow is used as an example.


```r
holes <- image_import("holes.jpg", plot = TRUE)
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/unnamed-chunk-46-1.png" width="960" />


In this case, the missing area will not be computed using the default settings of `analyze_objects()`. To include this area as the leaf area, we can use the argument `fill_hull()`. Note that this will only work for missing areas within a closed object. If the missing area includes the original leaf contour, there is no (yet available) way to reconstruct the leaf perimeter.



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

# fill the missing area
af2 <-
  analyze_objects(holes,
                  fill_hull = TRUE, # fill ' holes '
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

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/unnamed-chunk-47-1.png" width="960" />

We can simply use the ratio between `proc_img` and `proc_img2` to compute the injured area in this leaflet.


```r
# percent of injuried area
100 - 88379 / 99189 * 100
```

```
## [1] 10.89839
```




## Compound leaves

A simple leaf blade is undivided. The blade of a compound leaf is divided into several leaflets. In the following examples, I will show how to analyze simple and compound leaves with `analyze_objects()`, mainly if the goal is to obtain the measures for each leaf (e.g., mean area), where the number of objects (leaves) will influence the results.

The following images by [Daniel Saueressig](https://www.florestaombrofilamista.com.br/sidol/?menu=contact) were obtained from the *Sistema de Identificação Dendrológica Online - Floresta Ombrófila Mista*[^8] and show examples of simple and compound leaves.


```r
imgs <- 
  image_import(c("simple.jpg", "compound.jpg"),
               plot = TRUE)
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/sc1-1.png" width="960" />


Analyzing non-touching simple leaves is fairly simple. We already did that. The squares in the background have 4 cm$^2$. With this information, it is possible to obtain the image resolution with `dpi(simple)`, which will be useful to adjust the measures. In this case, the estimated dpi is 48.65.


```r
simple <- imgs$simple.jpg
sarea <- analyze_objects(simple, marker = "id")
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/sc2-1.png" width="672" />

Note that with the default settings, the simple leaf was partitioned into small, segmented leaves. This can be solved by either using `object_size = "large"` or `watershed = FALSE`, to omit the watershed segmentation algorithm. The last is used here.



```r
sarea <- 
  analyze_objects(simple,
                  watershed = FALSE,
                  marker = "id",
                  show_chull = TRUE)
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/sc3-1.png" width="672" />

```r
sarea_cor <- get_measures(sarea, dpi = 48.65)
sarea_cor
```

```
##   id       x       y   area area_ch perimeter radius_mean radius_min radius_max
## 1  1 184.644 156.252 41.318  55.705    40.891       4.276      1.086      7.970
## 2  2  68.644 151.805 19.926  31.421    31.151       3.011      1.091      5.733
##   radius_sd diam_mean diam_min diam_max major_axis minor_axis length width
## 1     1.791     8.553    2.172   15.941     13.642      4.219 15.471 5.989
## 2     1.203     6.021    2.183   11.466      9.206      3.178 11.016 4.650
##   radius_ratio eccentricity theta solidity convexity elongation circularity
## 1        7.341        0.133 1.490    0.742     0.691      0.613      40.467
## 2        5.253        0.148 1.552    0.634     0.643      0.578      48.701
##   circularity_haralick circularity_norm
## 1                2.387            3.296
## 2                2.503            4.021
```


For compound leaves, if the watershed segmentation is used, leaflets will probably be considered as different leaves, as can be seen below.


```r
compound <- imgs$compound.jpg
carea <- 
  analyze_objects(compound,
                  show_segmentation = TRUE,
                  show_contour = FALSE,
                  marker = "id")
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/sc4-1.png" width="672" />

Therefore, using `watershed = FALSE` will solve this problem, since all leaflets connected by at least one pixel will be considered part of the same leaf.


```r
carea <- 
  analyze_objects(compound,
                  watershed = FALSE,
                  show_segmentation = TRUE,
                  show_contour = FALSE,
                  show_chull = TRUE,
                  marker = "id")
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/sc5-1.png" width="672" />

```r
carea_cor <- get_measures(carea, dpi = 49.5)
carea_cor
```

```
##   id       x       y   area area_ch perimeter radius_mean radius_min radius_max
## 1  1 114.670  91.252 15.896  32.768    47.898       2.253      0.026      4.931
## 2  2 113.051 244.551 18.747  42.155    53.377       2.534      0.071      5.896
##   radius_sd diam_mean diam_min diam_max major_axis minor_axis length width
## 1     1.140     4.506    0.051    9.861      6.956      5.535  8.113 6.396
## 2     1.254     5.068    0.143   11.792      8.406      6.555  9.304 7.099
##   radius_ratio eccentricity  theta solidity convexity elongation circularity
## 1      192.057        0.503 -0.258    0.485     0.432      0.212     144.331
## 2       82.740        0.632  0.706    0.445     0.433      0.237     151.974
##   circularity_haralick circularity_norm
## 1                1.976           12.302
## 2                2.021           12.907
```




## Multiple images of the same sample

If users need to analyze multiple images from the same sample, the images must share the same filename prefix, which is defined as the part of the filename that precedes the first hyphen (`-`) or underscore (`_`). Then, when using ` get_measures()`, measurements from leaf images called, for example, `F1-1.jpeg`, `F1_2.jpeg` and `F1-3.jpeg` will be combined into a single image (`F1`), displayed in the `merge` object. This is useful, for example, for analyzing large sheets that need to be split into multiple images or multiple sheets belonging to the same sample that cannot be scanned into a single image.

In the following example, five images will be used as examples. Each image has leaves of different species. The images have been split into different images that share the same prefix (eg L1_\*, L2_\*, and so on). Note that to ensure that all images are processed, all images must share a common pattern, in this case (`"L"`). The three dots in the lower right corner have a known distance of 5 cm between them, which can be used to extract the dpi of the image with `dpi()`. For teaching purposes only, I will assume that all images are 100 dpi resolution .



```r
# entire images
imgs <-
  image_import(pattern = "leaf",
               plot = TRUE,
               ncol = 2)
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/merge0-1.png" width="960" />

```r
# images of the same sample
sample_imgs <-
  image_import(pattern = "L",
               plot = TRUE,
               ncol = 5)
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/merge0-2.png" width="960" />

Here, I will use the `pattern = "L"` to indicate that all images with this pattern name should be merged. The green index (`"G"`) is used to segment the leaves and `watershed = FALSE` is used to omit the watershed segmentation algorithm.



```r
merged <-
  analyze_objects(pattern = "L",
                  index = "B",
                  watershed = FALSE)
```

```
## Processing image L1_1 |====                                      | 8% 00:00:00 
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/merge1-1.png" width="672" />

```
## Processing image L1_2 |=======                                   | 17% 00:00:00 
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/merge1-2.png" width="672" />

```
## Processing image L2_1 |==========                                | 25% 00:00:00 
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/merge1-3.png" width="672" />

```
## Processing image L2_2 |==============                            | 33% 00:00:01 
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/merge1-4.png" width="672" />

```
## Processing image L3_1 |==================                        | 42% 00:00:01 
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/merge1-5.png" width="672" />

```
## Processing image L3_2 |=====================                     | 50% 00:00:01 
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/merge1-6.png" width="672" />

```
## Processing image L3_3 |========================                  | 58% 00:00:02 
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/merge1-7.png" width="672" />

```
## Processing image L4_1 |============================              | 67% 00:00:02 
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/merge1-8.png" width="672" />

```
## Processing image L4_2 |================================          | 75% 00:00:02 
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/merge1-9.png" width="672" />

```
## Processing image L4_3 |===================================       | 83% 00:00:03 
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/merge1-10.png" width="672" />

```
## Processing image L5_1 |======================================    | 92% 00:00:03 
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/merge1-11.png" width="672" />

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

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/merge1-12.png" width="672" />

Using the `get_measures()` function it is possible to convert measurements from pixel units to metric units(cm\$^ 2\$).


```r
merged_cor <- get_measures(merged, dpi = 100)
```

Note that the  merged_cor` is a list with three objects:

* `results`: a data frame that contains the measurements of each individual object (in this case, leaf) of each analyzed image.


```r
merged_cor$results %>%
  print_tbl()
```



|img  | id|       x|       y|    area| area_ch| perimeter| radius_mean| radius_min| radius_max| radius_sd| diam_mean| diam_min| diam_max| major_axis| minor_axis| length|   width| radius_ratio| eccentricity|  theta| solidity| convexity| elongation| circularity| circularity_haralick| circularity_norm|
|:----|--:|-------:|-------:|-------:|-------:|---------:|-----------:|----------:|----------:|---------:|---------:|--------:|--------:|----------:|----------:|------:|-------:|------------:|------------:|------:|--------:|---------:|----------:|-----------:|--------------------:|----------------:|
|L1_1 |  1| 427.723| 516.719| 102.170|   7.423|   133.418|       6.217|      0.561|     11.913|     2.899|    12.435|    1.122|   23.826|     19.863|     15.144| 21.566| 723.144|       21.226|        0.639|  0.158|    0.350|     0.403|      0.148|     174.222|                2.145|           14.066|
|L1_2 |  1| 372.556| 526.031|  92.840|   5.258|   123.954|       5.341|      1.042|     10.168|     2.186|    10.682|    2.085|   20.336|     15.123|     13.215| 16.922| 579.543|        9.754|        0.804|  0.600|    0.448|     0.388|      0.130|     165.496|                2.443|           13.363|
|L2_1 |  1| 251.404| 282.798|  46.319|   1.188|    28.449|       3.936|      2.527|      5.920|     0.911|     7.872|    5.054|   11.840|     10.479|      5.708| 11.347| 234.501|        2.342|        0.391|  1.502|    0.990|     0.920|      0.475|      17.473|                4.320|            1.400|
|L2_1 |  2| 146.366| 701.900|  35.305|   0.918|    25.682|       3.441|      2.311|      5.209|     0.820|     6.881|    4.621|   10.417|      9.308|      4.873| 10.314| 198.859|        2.254|        0.372| -1.533|    0.977|     0.909|      0.510|      18.682|                4.197|            1.498|
|L2_2 |  1| 326.113| 391.141|  19.026|   0.488|    19.480|       2.613|      1.659|      4.129|     0.737|     5.225|    3.319|    8.259|      7.301|      3.375|  8.154| 140.051|        2.488|        0.272|  1.560|    0.990|     0.912|      0.564|      19.945|                3.546|            1.605|
|L2_2 |  2| 113.850| 755.321|  38.153|   0.982|    25.140|       3.534|      2.518|      5.097|     0.664|     7.069|    5.036|   10.195|      8.955|      5.462|  9.755| 222.389|        2.024|        0.476|  1.556|    0.987|     0.915|      0.421|      16.565|                5.319|            1.327|
|L2_2 |  3| 376.213| 784.804|  16.320|   0.418|    17.290|       2.365|      1.532|      3.616|     0.604|     4.730|    3.063|    7.231|      6.509|      3.238|  7.151| 137.701|        2.361|        0.327|  1.395|    0.993|     0.923|      0.511|      18.317|                3.918|            1.474|
|L3_1 |  1| 253.962| 480.290|  64.082|   2.993|    92.040|       4.199|      0.408|      9.476|     2.050|     8.397|    0.817|   18.952|     15.225|      8.681| 15.718| 391.803|       23.207|        0.371| -1.550|    0.544|     0.385|      0.367|     132.194|                2.048|           10.566|
|L3_2 |  1| 200.077| 436.484|  30.205|   1.462|    63.289|       2.830|      0.065|      6.576|     1.425|     5.661|    0.131|   13.152|      9.857|      7.103| 10.814| 323.238|      100.588|        0.511|  1.564|    0.525|     0.395|      0.241|     132.609|                1.986|           10.802|
|L3_3 |  1| 204.984| 363.476|  52.026|   2.219|    93.326|       3.494|      0.077|      7.821|     1.656|     6.989|    0.155|   15.641|     12.404|      8.414| 13.411| 365.188|      101.216|        0.467|  1.538|    0.595|     0.385|      0.308|     167.412|                2.110|           13.578|
|L4_1 |  1| 270.258| 326.544|  54.355|   1.391|    29.242|       4.177|      3.390|      5.717|     0.557|     8.354|    6.780|   11.434|      9.918|      7.035| 10.438| 285.642|        1.686|        0.616|  1.484|    0.992|     0.899|      0.305|      15.731|                7.495|            1.259|
|L4_1 |  3| 252.952| 845.157|  61.679|   1.625|    34.029|       4.540|      3.654|      6.488|     0.704|     9.080|    7.307|   12.975|     10.549|      7.549| 11.940| 313.620|        1.776|        0.544|  1.428|    0.964|     0.877|      0.333|      18.774|                6.447|            1.503|
|L4_2 |  1| 291.942| 235.565|  61.503|   1.597|    32.955|       4.544|      3.148|      6.592|     0.823|     9.087|    6.297|   13.183|     10.970|      7.278| 12.132| 297.169|        2.094|        0.475| -1.332|    0.978|     0.913|      0.378|      17.658|                5.520|            1.413|
|L4_2 |  2| 260.787| 799.754|  73.268|   1.915|    35.872|       4.938|      3.787|      7.013|     0.779|     9.876|    7.574|   14.026|     11.609|      8.152| 12.735| 325.870|        1.852|        0.525|  1.527|    0.972|     0.858|      0.350|      17.563|                6.342|            1.405|
|L4_3 |  1| 206.166| 213.417|  29.186|   0.751|    22.252|       3.097|      2.054|      4.374|     0.668|     6.193|    4.107|    8.748|      8.256|      4.535|  8.532| 181.531|        2.130|        0.412| -1.536|    0.987|     0.901|      0.460|      16.965|                4.633|            1.361|
|L4_3 |  2| 219.514| 552.896|  19.503|   0.519|    19.444|       2.595|      1.608|      3.940|     0.648|     5.191|    3.215|    7.881|      7.069|      3.548|  7.552| 145.554|        2.451|        0.324|  1.538|    0.954|     0.870|      0.510|      19.386|                4.008|            1.560|
|L4_3 |  3| 229.163| 937.157|  34.149|   0.900|    27.156|       3.470|      2.211|      5.138|     0.799|     6.940|    4.421|   10.277|      8.809|      5.090|  9.483| 210.667|        2.324|        0.344|  1.471|    0.964|     0.856|      0.436|      21.596|                4.342|            1.734|
|L5_1 |  1| 225.338| 275.720|  52.797|   1.383|    35.431|       4.590|      2.259|      7.735|     1.623|     9.179|    4.517|   15.470|     13.610|      5.029| 15.329| 204.313|        3.425|        0.175| -1.479|    0.970|     0.890|      0.661|      23.777|                2.828|            1.906|
|L5_1 |  2| 335.525| 884.869|  31.675|   0.828|    28.086|       3.619|      1.727|      6.199|     1.321|     7.237|    3.454|   12.398|     10.718|      3.823| 12.264| 159.670|        3.590|        0.156|  1.382|    0.971|     0.894|      0.669|      24.903|                2.739|            2.001|
|L5_1 |  3| 120.360| 887.853|  30.192|   0.821|    30.496|       3.827|      1.649|      6.774|     1.523|     7.654|    3.297|   13.549|     11.055|      3.579| 13.464| 149.277|        4.109|        0.109| -1.564|    0.934|     0.918|      0.718|      30.803|                2.512|            2.480|
|L5_2 |  1| 339.022| 300.133|  45.622|   1.189|    33.995|       4.331|      2.188|      7.465|     1.609|     8.662|    4.376|   14.930|     13.160|      4.466| 14.760| 183.139|        3.412|        0.152| -1.547|    0.974|     0.897|      0.685|      25.332|                2.691|            2.033|
|L5_2 |  2| 205.390| 802.624|  42.866|   1.115|    33.289|       4.267|      2.060|      7.335|     1.583|     8.534|    4.120|   14.670|     12.766|      4.355| 14.614| 179.397|        3.561|        0.144|  1.508|    0.976|     0.912|      0.688|      25.852|                2.695|            2.075|
|L5_2 |  3| 535.301| 819.600|  44.996|   1.176|    33.320|       4.300|      1.992|      7.465|     1.584|     8.600|    3.984|   14.930|     13.069|      4.450| 14.488| 185.768|        3.748|        0.155| -1.450|    0.972|     0.915|      0.674|      24.674|                2.714|            1.980|

* `summary` : a data frame that contains the summary of the results, containing the number of objects in each image (`n`) the sum, mean and standard deviation of the area of each image, as well as the average value for all others measurements (perimeter, radius, etc.)



```r
merged_cor$summary %>%
  print_tbl()
```



|img  |  n| area_sum| area_mean| area_sd| area_ch| perimeter| radius_mean| radius_min| radius_max| radius_sd| diam_mean| diam_min| diam_max| major_axis| minor_axis| length|   width| radius_ratio| eccentricity|  theta| solidity| convexity| elongation| circularity| circularity_haralick| circularity_norm|
|:----|--:|--------:|---------:|-------:|-------:|---------:|-----------:|----------:|----------:|---------:|---------:|--------:|--------:|----------:|----------:|------:|-------:|------------:|------------:|------:|--------:|---------:|----------:|-----------:|--------------------:|----------------:|
|L1_1 |  1|  102.170|   102.170|   0.000|   7.423|   133.418|       6.217|      0.561|     11.913|     2.899|    12.435|    1.122|   23.826|     19.863|     15.144| 21.566| 723.144|       21.226|        0.639|  0.158|    0.350|     0.403|      0.148|     174.222|                2.145|           14.066|
|L1_2 |  1|   92.840|    92.840|   0.000|   5.258|   123.954|       5.341|      1.042|     10.168|     2.186|    10.682|    2.085|   20.336|     15.123|     13.215| 16.922| 579.543|        9.754|        0.804|  0.600|    0.448|     0.388|      0.130|     165.496|                2.443|           13.363|
|L2_1 |  2|   81.624|    40.812|   7.788|   1.053|    27.065|       3.688|      2.419|      5.564|     0.865|     7.377|    4.838|   11.128|      9.893|      5.290| 10.830| 216.680|        2.298|        0.381| -0.016|    0.983|     0.914|      0.493|      18.078|                4.258|            1.449|
|L2_2 |  3|   73.500|    24.500|  11.901|   0.629|    20.637|       2.837|      1.903|      4.281|     0.668|     5.675|    3.806|    8.562|      7.588|      4.025|  8.353| 166.714|        2.291|        0.358|  1.504|    0.990|     0.917|      0.499|      18.276|                4.261|            1.469|
|L3_1 |  1|   64.082|    64.082|   0.000|   2.993|    92.040|       4.199|      0.408|      9.476|     2.050|     8.397|    0.817|   18.952|     15.225|      8.681| 15.718| 391.803|       23.207|        0.371| -1.550|    0.544|     0.385|      0.367|     132.194|                2.048|           10.566|
|L3_2 |  1|   30.205|    30.205|   0.000|   1.462|    63.289|       2.830|      0.065|      6.576|     1.425|     5.661|    0.131|   13.152|      9.857|      7.103| 10.814| 323.238|      100.588|        0.511|  1.564|    0.525|     0.395|      0.241|     132.609|                1.986|           10.802|
|L3_3 |  1|   52.026|    52.026|   0.000|   2.219|    93.326|       3.494|      0.077|      7.821|     1.656|     6.989|    0.155|   15.641|     12.404|      8.414| 13.411| 365.188|      101.216|        0.467|  1.538|    0.595|     0.385|      0.308|     167.412|                2.110|           13.578|
|L4_1 |  2|  116.034|    58.017|   5.178|   1.508|    31.635|       4.358|      3.522|      6.102|     0.631|     8.717|    7.044|   12.205|     10.233|      7.292| 11.189| 299.631|        1.731|        0.580|  1.456|    0.978|     0.888|      0.319|      17.253|                6.971|            1.381|
|L4_2 |  2|  134.771|    67.385|   8.319|   1.756|    34.413|       4.741|      3.468|      6.802|     0.801|     9.482|    6.936|   13.605|     11.289|      7.715| 12.433| 311.519|        1.973|        0.500|  0.097|    0.975|     0.886|      0.364|      17.610|                5.931|            1.409|
|L4_3 |  3|   82.838|    27.613|   7.449|   0.723|    22.951|       3.054|      1.957|      4.484|     0.705|     6.108|    3.915|    8.968|      8.045|      4.391|  8.522| 179.251|        2.302|        0.360|  0.491|    0.968|     0.876|      0.469|      19.315|                4.328|            1.552|
|L5_1 |  3|  114.664|    38.221|  12.645|   1.011|    31.338|       4.012|      1.878|      6.903|     1.489|     8.023|    3.756|   13.806|     11.795|      4.144| 13.686| 171.087|        3.708|        0.147| -0.554|    0.958|     0.901|      0.683|      26.494|                2.693|            2.129|
|L5_2 |  3|  133.484|    44.495|   1.445|   1.160|    33.535|       4.299|      2.080|      7.422|     1.592|     8.599|    4.160|   14.843|     12.998|      4.424| 14.620| 182.768|        3.573|        0.150| -0.496|    0.974|     0.908|      0.682|      25.286|                2.700|            2.029|

* `merge`: a data frame that contains the results merged by image prefix. Note that in this case the results are displayed by L1, L2, L3, L4 and L5.


```r
merged_cor$merge %>%
  print_tbl()
```



|img |  n| area_sum| area_mean| area_sd| area_ch| perimeter| radius_mean| radius_min| radius_max| radius_sd| diam_mean| diam_min| diam_max| major_axis| minor_axis| length|   width| radius_ratio| eccentricity|  theta| solidity| convexity| elongation| circularity| circularity_haralick| circularity_norm|
|:---|--:|--------:|---------:|-------:|-------:|---------:|-----------:|----------:|----------:|---------:|---------:|--------:|--------:|----------:|----------:|------:|-------:|------------:|------------:|------:|--------:|---------:|----------:|-----------:|--------------------:|----------------:|
|L1  |  2|  195.010|    97.505|   0.000|   6.341|   128.686|       5.779|      0.802|     11.040|     2.542|    11.558|    1.604|   22.081|     17.493|     14.179| 19.244| 651.343|       15.490|        0.722|  0.379|    0.399|     0.396|      0.139|     169.859|                2.294|           13.714|
|L2  |  5|  155.124|    32.656|   9.845|   0.841|    23.851|       3.263|      2.161|      4.922|     0.767|     6.526|    4.322|    9.845|      8.741|      4.658|  9.592| 191.697|        2.295|        0.370|  0.744|    0.987|     0.916|      0.496|      18.177|                4.260|            1.459|
|L3  |  3|  146.313|    48.771|   0.000|   2.225|    82.885|       3.508|      0.184|      7.958|     1.711|     7.016|    0.367|   15.915|     12.495|      8.066| 13.314| 360.076|       75.004|        0.450|  0.517|    0.555|     0.389|      0.305|     144.072|                2.048|           11.649|
|L4  |  7|  333.643|    51.005|   6.982|   1.329|    29.666|       4.051|      2.982|      5.796|     0.712|     8.102|    5.965|   11.592|      9.856|      6.466| 10.715| 263.467|        2.002|        0.480|  0.681|    0.974|     0.883|      0.384|      18.059|                5.743|            1.447|
|L5  |  6|  248.149|    41.358|   7.045|   1.085|    32.436|       4.156|      1.979|      7.162|     1.541|     8.311|    3.958|   14.325|     12.396|      4.284| 14.153| 176.927|        3.641|        0.148| -0.525|    0.966|     0.904|      0.683|      25.890|                2.697|            2.079|

The ` area_sum` of img `L1` is the sum of the two sheets (one in each image).


```r
sum(merged_cor$results$area [1:2])
```

```
## [1] 195.01
```


Below, I will create a plot to show the distribution of leaf area  


```r
df_leaf <-
  merged_cor$results %>%
  separate(img , into = c("img", "code"))

# leaf area of the different species
p1 <-
  ggplot(df_leaf, aes(img, area)) +
  geom_boxplot() +
  geom_jitter(color="red") +
  labs(x = " Image ", y = expression(Area ~(cm^2)))

p2 <-
  ggplot(df_leaf , aes(x = img , y = area)) +
  stat_summary(fun = sum,
               geom = "bar",
               col = " black ") +
  labs(x = " Image ", y = expression(Total~area ~(cm^2)))


# solidity of the different species
p3 <-
  ggplot(df_leaf , aes(x = img , y = solidity)) +
  geom_boxplot() +
  geom_jitter(color="red") +
  labs(x = "Image", y = "Solidity")

p1 + p2 + p3 +
  plot_layout(ncol = 3)
```

<img src="/tutorials/pliman_ip/03_analyze_objects_files/figure-html/merge9-1.png" width="960" />






[^1]: Singer, M.H. 1993. A general approach to moment calculation for polygons and line segments. Pattern Recognition 26(7): 1019–1028. doi: 10.1016/0031-3203(93)90003-F.


[^2]: Chen, C.H., and P.S.P. Wang. 2005. Handbook of Pattern Recognition and Computer Vision. 3rd ed. World Scientific.

[^3]: Claude, J. 2008. Morphometrics with R. Springer.

[^4]: Montero, R.S., E. Bribiesca, R. Santiago, and E. Bribiesca. 2009. State of the Art of Compactness and Circularity Measures. International Mathematical Forum 4(27): 1305–1335.

[^5]: Lee, Y., and W. Lim. 2017. Fórmula de cadarço: conectando a área de um polígono e o produto vetorial vetorial. The Mathematics Teacher 110(8): 631–636. doi: 10.5951/MATHTEACHER.110.8.0631.

[^6]: Montero, R.S., E. Bribiesca, R. Santiago, and E. Bribiesca. 2009. State of the Art of Compactness and Circularity Measures. International Mathematical Forum 4(27): 1305–1335

[^7]: Haralick, R.M. 1974. A Measure for Circularity of Digital Figures. IEEE Transactions on Systems, Man, and Cybernetics SMC-4(4): 394–396. doi: 10.1109/TSMC.1974.5408463.

[^8]: https://www.florestaombrofilamista.com.br/sidol/?menu=glossary

