knitr::opts_knit$set(root.dir = "E:/Desktop/tiagoolivoto/static/tutorials/pliman_ip/imgs")

## # mudar de acordo com a pasta em seu computador
## setwd("E:/Desktop/tiagoolivoto/static/tutorials/pliman_ip/imgs")

library(pliman)
library(tidyverse)
library(patchwork)
img <- image_import("folhas.jpg")


img_list1 <- image_import(c("img_sb_50_1.jpg", "img_sb_50_2.jpg"))
img_list2 <- image_import(pattern = "img_sb_")
str(img_list2)

# Imagens individuais
plot(img)


# Combine imagens
image_combine(img_list1)

image_dimension(img)
img_resized <- image_resize(img, rel_size = 50)
image_dimension(img_resized)

## #  this only works in an interactive section
## rule <- image_import("rule.jpg", plot = TRUE)
## (dpi <- dpi(rule))
## 
## rule2 <-
##   image_crop(rule,
##              width = 130:1390,
##              height = 582:1487,
##              plot = TRUE)
## 
## analyze_objects(rule2,
##                 watershed = FALSE,
##                 marker = "area") |>
##   get_measures(dpi = 518) |>
##   plot_measures(measure = "area", vjust = -100, size = 2)

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

## image_export(img, "img_exported.jpg")
## 
## # ou para uma subpasta
## image_export(img, "test/img_exported.jpg")



knitr::opts_knit$set(root.dir = "E:/Desktop/tiagoolivoto/static/tutorials/pliman_ip/imgs")

## # mudar de acordo com a pasta em seu computador
## setwd("E:/Desktop/tiagoolivoto/static/tutorials/pliman_ip/imgs")

library(pliman) 
img <- image_import("folhas.jpg", plot = TRUE)
img <- image_resize(img, rel_size = 30) #processamento mais rápido

# Calcule os índices
indexes <- image_index(img, index = c("R, G, B, NR, NG, NB"))

# Crie um gráfico raster com os valores RGB
plot(indexes)

# Crie um histograma com os valores RGB
plot(indexes, type = "density")


binary <- image_binary(img)


segmented <- 
  image_segment(img,
                index = "NB", # default
                fill_hull = TRUE)


## # Only run iteratively
## image_segment_iter(img, nseg = 1)



knitr::opts_knit$set(root.dir = "E:/Desktop/tiagoolivoto/static/tutorials/pliman_ip/imgs")

## # mudar de acordo com a pasta em seu computador
## setwd("E:/Desktop/tiagoolivoto/static/tutorials/pliman_ip/imgs")

library(pliman)
square <- draw_square(side = 1)
poly_area(square)
poly_perimeter(square)

shapes <- list(  side6 = draw_n_tagon(6, plot = FALSE),
                 side12 = draw_n_tagon(12, plot = FALSE),
                 side24 = draw_n_tagon(24, plot = FALSE),
                 side100 = draw_n_tagon(100, plot = FALSE),
                 side500 = draw_n_tagon(500, plot = FALSE),
                 side100 = draw_n_tagon(1000, plot = FALSE))

plot_polygon(shapes, merge = FALSE)

poly_area(shapes)
poly_perimeter(shapes)

leaves <- image_import("ref_leaves.jpg", plot = TRUE)

# getting the outline of objects
cont <- object_contour(leaves, watershed = FALSE, index = "HI")

# plotting the polygon
plot_polygon(cont)

cont <- cont[c("2", "4", "13", "24", "35")]
plot_polygon(cont)

poly_area(cont)

poly_perimeter(cont)

# perimeter of a circle with radius 2
circle <- draw_circle(radius = 2, plot = FALSE)
poly_perimeter(circle)

# check the result
2*pi*2

dist <- poly_centdist(cont)

# stats for radius
mean_list(dist)
min_list(dist)
max_list(dist)
sd_list(dist)

# average radius of circle above
poly_centdist(circle) |> mean_list()

aligned <- poly_align(cont, plot = FALSE)
plot_polygon(aligned, merge = FALSE, ncol = 5)
# calculate length and width
poly_lw(cont)

poly_circularity(cont)

poly_circularity_norm(cont)

# normalized circularity for different shapes
draw_square(plot =FALSE) |> poly_circularity_norm()
draw_circle(plot=FALSE) |> poly_circularity_norm()

poly_circularity_haralick(cont)

poly_convexity(cont)

poly_eccentricity(cont)

poly_elongation(cont)

poly_caliper(cont)

measures <- poly_measures(cont) |> round_cols()
t(measures)

(color_measures <- get_measures(measures, dpi = 50))


o2 <- cont[["2"]]
plot_polygon(o2)

rot <- poly_rotate(o2, angle = 45)

flipped <- 
  list(fx = poly_flip_x(o2), 
       fy = poly_flip_y(o2))

plot_polygon(flipped, merge = FALSE, aspect_ratio = 1)

# sample 50 coordinates
poly_sample(o2, n=50) |> plot_polygon()

# sample 10% of coordinates
poly_sample_prop(o2, prop = 0.1) |> plot_polygon()

smoothed <-
  list( original = o2,
        s1 = poly_smooth(o2, prop = 0.2, plot = FALSE),
        s2 = poly_smooth(o2, prop = 0.1, plot = FALSE),
        s1 = poly_smooth(o2, prop = 0.04, plot = FALSE)
  )

plot_polygon(smoothed, merge = FALSE, ncol = 2)

set.seed(1)
c1 <- draw_circle(n = 200, plot = FALSE)
c2 <- draw_circle(n = 200, plot = FALSE) |>
  poly_jitter(noise_x = 100,
              noise_y = 100,
              plot = FALSE)

plot_polygon(list(c1, c2), merge = FALSE)

# generate html tables
print_tbl <- function(table, digits = 3, ...){
  knitr :: kable(table, booktabs = TRUE, digits = digits, ...)
}
library(pliman)
library(tidyverse)
library(patchwork)

img <- image_pliman("objects_300dpi.jpg", plot = TRUE)


img_res <- analyze_objects(img, marker = "id")

get_measures(img_res ,
             id = 1,
             area ~ 100)


# number of pixels for the perimeter of the largest square

ls_px <- img_res$results$perimeter [1]
pixels_to_cm(px = ls_px , dpi = 300)



img_res_cor <- get_measures(img_res , dpi = 300)

t(img_res_cor) |>
  print_tbl()


object_contour(img) %>% # get the contour of objects
  poly_mass() %>% # computes center of mass and minimum and maximum radii
  plot_mass() # plot the measurements

t(img_res_cor) |>
  print_tbl() 

potato <- image_pliman("potato_leaves.jpg", plot = TRUE)

pot_meas <-
  analyze_objects(potato,
                  watershed = FALSE,
                  marker = "id",
                  show_chull = TRUE) # show the convex hull

pot_meas$results %>%
  print_tbl()


leaves <- image_import("folhas.jpg", plot = TRUE)

leaves_meas <-
  analyze_objects(leaves ,
                  watershed = FALSE,
                  col_background = "black")

leaves_cor <- get_measures(leaves_meas , dpi = 300)

t(leaves_cor) |>
  print_tbl()


# plot width and length
plot_measures(leaves_cor , measure = "width")
plot_measures(leaves_cor , measure = "length", vjust = 50)

count <-
  analyze_objects("grains",
                  show_segmentation = TRUE,
                  show_contour = FALSE,
                  marker = "id")
count$statistics


# Get the measurements of the object
measurements <- get_measures(count)
head(measurements)


analyze_objects("grains",
                marker = "id",
                lower_size = 719.1)

analyze_objects("grains",
                marker = "id",
                topn_lower = 5,
                col_background = "salmon",
                my_index = "B /(R + G + B)") # normalized blue(NB)

system.time(
  list_res <- analyze_objects(pattern = "img_sb", show_image = FALSE)
)

# parallel processing
# 6 multiple sections (50% of my pc's cores)
system.time(
  list_res <-
    analyze_objects(pattern = "img_sb",
                    show_image = FALSE,
                    parallel = TRUE)
)


leaves <- image_import("folhas.jpg", plot = TRUE)

# get the id of each object
object_id(leaves, watershed = FALSE)

# Get the coordinates of a bounding rectangle around all objects
object_coord(leaves, watershed = FALSE)

# Get coordinates for all objects
object_coord(leaves ,
             id = "all",
             watershed = FALSE)

# Get the coordinates of objects 1 and 2
# 20 border pixels
object_coord(leaves ,
             id = 1,
             edge = 20,
             watershed = FALSE)

id1 <-
  object_isolate(leaves ,
                 watershed = FALSE,
                 id = 1,
                 edge = 10)
plot(id1)

list <- object_split(leaves, watershed = FALSE)
str(list)

img <- image_import("green.jpg", plot = TRUE)
(indx <- pliman_indexes())

soy_green <-
  analyze_objects(img ,
                  object_index = indx [1:6], # R:NB
                  marker = "id",
                  marker_col = "black",
                  col_background = "white",
                  show_contour = FALSE)

# PCA with the indices
ind <- summary_index(soy_green, type ="var")


get_biplot(ind$pca_res, show = "var")
get_biplot(ind$pca_res, show = "ind")


plot(img)
plot_measures(soy_green ,
              measure = "R",
              col = " black ")

report <-
  summary_index(soy_green ,
                index = "R",
                cut_point = 0.6,
                plot = FALSE)
ids <- report$ids
report$between_id
report$within_id[ids,]


# ratio of pixels of each object(above and below 0.6)
barplot(t(report$within_id [,6:7]) |> as.matrix(),
        legend = c("R < 0.6", "R > 0.6"))

# distribution of RGB values
rgbs <-
  soy_green$object_rgb |>
  mutate(type = ifelse(id %in% ids, " Greenish ", " No greenish ")) |>
  select(-id) |>
  pivot_longer(-type)

ggplot(rgbs, aes(x = value)) +
  geom_density(aes(fill = name), alpha = 0.5) +
  facet_wrap(~ type)



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


leaves <- image_import(image = "ref_leaves.jpg", plot = TRUE)

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

img <- image_import(pattern = "ref_", plot = TRUE)

area <-
  analyze_objects(img = "ref_leaves",
                  foreground = "ref_folha",
                  background = "ref_back",
                  reference = "ref_ref",
                  reference_area = 25,
                  marker = "area",
                  watershed = FALSE)

holes <- image_import("holes.jpg", plot = TRUE)



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

# percent of injuried area
100 - 88379 / 99189 * 100

imgs <- 
  image_import(c("simple.jpg", "compound.jpg"),
               plot = TRUE)


simple <- imgs$simple.jpg
sarea <- analyze_objects(simple, marker = "id")


sarea <- 
  analyze_objects(simple,
                  watershed = FALSE,
                  marker = "id",
                  show_chull = TRUE)
sarea_cor <- get_measures(sarea, dpi = 48.65)
sarea_cor

compound <- imgs$compound.jpg
carea <- 
  analyze_objects(compound,
                  show_segmentation = TRUE,
                  show_contour = FALSE,
                  marker = "id")

carea <- 
  analyze_objects(compound,
                  watershed = FALSE,
                  show_segmentation = TRUE,
                  show_contour = FALSE,
                  show_chull = TRUE,
                  marker = "id")
carea_cor <- get_measures(carea, dpi = 49.5)
carea_cor

# entire images
imgs <-
  image_import(pattern = "leaf",
               plot = TRUE,
               ncol = 2)

# images of the same sample
sample_imgs <-
  image_import(pattern = "L",
               plot = TRUE,
               ncol = 5)

merged <-
  analyze_objects(pattern = "L",
                  index = "B",
                  watershed = FALSE)

merged_cor <- get_measures(merged, dpi = 100)

merged_cor$results %>%
  print_tbl()


merged_cor$summary %>%
  print_tbl()


merged_cor$merge %>%
  print_tbl()


sum(merged_cor$results$area [1:2])


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



knitr::opts_knit$set(root.dir = "E:/Desktop/tiagoolivoto/static/tutorials/pliman_ip/imgs")

## # mudar de acordo com a pasta em seu computador
## setwd("E:/Desktop/tiagoolivoto/static/tutorials/pliman_ip/imgs")

# generate html tables
print_tbl <- function(table, digits = 3, ...){
  knitr :: kable(table, booktabs = TRUE, digits = digits, ...)
}

library(pliman)
img <- image_import("exemp_1.jpeg", plot = TRUE)
h <- image_import("exem_h.png")
d <- image_import("exem_d.png")
b <- image_import("exem_b.png")
image_combine(img, h, d, b, ncol = 4)

## h2 <- pick_palette(img)
## d2 <- pick_palette(img)
## b2 <- pick_palette(img)
## image_combine(h2, d2, b2, ncol = 3)
## 

sev <- 
  measure_disease(img = img,
                  img_healthy = h,
                  img_symptoms = d,
                  img_background = b)
sev$severity

sev <- 
  measure_disease(img = img,
                  img_healthy = h,
                  img_symptoms = d,
                  img_background = b,
                  show_contour = FALSE)

sev <- 
  measure_disease(img = img,
                  img_healthy = h,
                  img_symptoms = d,
                  img_background = b,
                  show_original = FALSE,
                  col_lesions = "brown") # padrão é "black"

sev <- 
  measure_disease(img = img,
                  img_healthy = h,
                  img_symptoms = d,
                  img_background = b,
                  show_features = TRUE,
                  show_segmentation = TRUE)

# correct the measures (dpi = 150)
sev_corrected <- get_measures(sev, dpi = 150)

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
sev_lote$severity

sad(sev_lote, n = 6, ncol = 3)

system.time(
  sev_lote <- 
    measure_disease(pattern = "soy",
                    img_healthy = "soja_h",
                    img_symptoms = "soja_s",
                    img_background = "soja_b",
                    show_image = FALSE,
                    parallel = TRUE)
)



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
sev <- 
  sev_trats$severity |> 
  separate_col(img, into = c("TRAT", "REP"))

library(ggplot2)
ggplot(sev, aes(TRAT, symptomatic))+
  geom_boxplot() +
  geom_jitter(alpha = 0.3) +
  labs(x = "Tratamentos",
       y = "Severidade (%)")

byl <- 
  measure_disease_byl(pattern = "multiplas",
                      index = "B", # used to segment leaves from background
                      img_healthy = "soja_h",
                      img_symptoms = "soja_s",
                      show_contour = FALSE,
                      show_features = TRUE,
                      col_lesions = "red",
                      parallel = TRUE)

results_byl <- get_measures(byl)

results_byl$results |> 
  head() |> 
  print_tbl()
