## # mudar de acordo com a pasta em seu computador
## setwd("E:/Desktop/tiagoolivoto/static/tutorials/pliman_ip/imgs")

library(pliman)  
img <- image_import("grains.jpg")


img_list1 <- image_import(c("grains.jpg", "green.jpg"))
img_list2 <- image_import(pattern = "maize_")
str(img_list1)

# Imagens individuais
plot(img)



# Combine imagens
image_combine(img_list1)



image_dimension(img)
img_resized <- image_resize(img, rel_size = 50)
image_dimension(img_resized)

crop1 <-
  image_crop(img,
             width = 171:1088,
             height = 115:855,
             plot = TRUE)

crop2 <-
  image_crop(img,
             height = 115:855,
             plot = TRUE)

## # executa apenas em uma seção iterativa
## image_crop(img)

auto_crop <- image_autocrop(img, plot = TRUE)

# apara 100 pixels de todas as bordas
img_trim <- image_trim(img, edge = 50, plot = TRUE)

# O mesmo é alcançado com
img_trim2 <-
  image_trim(img,
             top = 50,
             bottom = 50,
             left = 50,
             right = 50,
             plot = TRUE)

# apara 100 pixels da parte superior e 50 da inferior
img_trim3 <-
  image_trim(img,
             top = 100,
             bottom = 50,
             plot = TRUE)



## # executado apenas em uma seção interativa
## rule <- image_import("rule.jpg", plot = TRUE)
## dpi(rule)

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
              ncol = 2)

## image_export(img, "img_exported.jpg")
## 
## # ou para uma subpasta
## image_export(img, "test/img_exported.jpg")

knitr::opts_knit$set(root.dir = "E:/Desktop/tiagoolivoto/static/tutorials/pliman_ip/imgs")

## # mudar de acordo com a pasta em seu computador
## setwd("E:/Desktop/tiagoolivoto/static/tutorials/pliman_ip/imgs")

library(pliman) 
img <- image_import("grains.jpg")
img <- image_resize(img, rel_size = 50, plot = TRUE)


# Calcule os índices
indexes <- image_index(img, index = c("R, G, B, NR, NG, NB"))

# Crie um gráfico raster com os valores RGB
plot(indexes)

# Crie um histograma com os valores RGB
plot(indexes, type = "density")

segmented <- image_segment(img, index = c("R, G, B, NR, NG, NB"))


binary <- image_binary(img)

# tamanho de imagem original
image_binary(img,
             index = "B",
             resize = FALSE)

# inverte a binarização
image_binary(img,
             index = "B",
             resize = FALSE,
             invert = TRUE)

knitr::opts_knit$set(root.dir = "E:/Desktop/tiagoolivoto/static/tutorials/pliman_ip/imgs")

## # mudar de acordo com a pasta em seu computador
## setwd("E:/Desktop/tiagoolivoto/static/tutorials/pliman_ip/imgs")

# gerar tabelas html
print_tbl <- function(table,  digits = 3, ...){
  knitr::kable(table, booktabs = TRUE, digits = digits, ...)
}
library(pliman)
library(tidyverse)
library(patchwork)

img <- image_pliman("objects_300dpi.jpg", plot = TRUE)


image_binary(img)


cont <- object_contour(img)
img_res <-
  analyze_objects(img,
                  marker = "id",
                  index = "B") # use o índice azul para segmentar

get_measures(img_res,
             id = 1,
             area ~ 100)


# número de pixels para o perímetro do quadrado maior

ls_px <- img_res$results$perimeter[1]
pixels_to_cm(px = ls_px, dpi = 300)




get_measures(img_res, dpi = 300) %>% 
  print_tbl()


soy <- image_pliman("soybean_touch.jpg")

count <-
  analyze_objects(soy,
                  index = "NB") # padrão
count$statistics %>% 
  print_tbl()

count2 <-
  analyze_objects(soy,
                  show_contour = FALSE,
                  marker = "id",
                  show_segmentation = FALSE,
                  col_background = "white",
                  index = "NB") # padrão



# Obtenha as medidas do objeto

medidas <- get_measures(count)
medidas %>% 
  print_tbl()


analyze_objects(soy, 
                marker = "id",
                show_original = FALSE,
                lower_size = 2057.36)


analyze_objects(soy,
                marker = "id",
                topn_lower = 5,
                col_background = "black",
                my_index = "B /(R + G + B)")

folhas <- image_import(image = "leaves.jpg", plot = TRUE)

# obter o id de cada objeto
object_id(folhas,  watershed = FALSE)

# Obtenha as coordenadas de um retângulo delimitador em torno de todos os objetos
object_coord(folhas, watershed = FALSE)

# Obtenha as coordenadas para todos os objetos
object_coord(folhas,
             id = "all",
             watershed = FALSE)

# Obtenha as coordenadas dos objetos 1 e 3
object_coord(folhas,
             id = c(2, 4),
             watershed = FALSE)

id1 <- 
  object_isolate(folhas,
                 watershed = FALSE,
                 id = 32,
                 edge = 5)
plot(id1)

system.time(
  list_res <- analyze_objects(pattern = "img_sb")
)

# procesamento paralelo
# três múltiplas seções
system.time(
  list_res <- 
    analyze_objects(pattern = "img_sb",
                    show_image = FALSE,
                    parallel = TRUE,
                    workers = 3)
)

list_res$count %>% print_tbl()
list_res$results %>% print_tbl()


batata <- image_pliman("potato_leaves.jpg", plot = TRUE)

pot_meas <-
  analyze_objects(batata,
                  watershed = FALSE,
                  marker = "id",
                  show_chull = TRUE) # mostra o casco convex
pot_meas$results %>% 
  print_tbl()


cont <-
  object_contour(batata,
                 watershed = FALSE,
                 show_image = FALSE)

plot(batata)
plot_contour(cont, col = "red", lwd = 3)


conv <- conv_hull(cont)
plot(batata)
plot_contour(conv, col = "black", lwd = 3)
plot_measures(pot_meas, measure = "solidity")

area <- poly_area(conv)
area



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

bean <- image_import("bean.jpg", plot = TRUE)

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

roots <- image_import("root.jpg", plot = TRUE)

r1_meas <- 
  analyze_objects(roots,
                  index = "B",
                  marker = "id",
                  invert = TRUE)

r1_meas <- 
  analyze_objects(roots,
                  index = "B",
                  marker = "id",
                  invert = TRUE,
                  tolerance = 3.5)

r1_meas <- 
  analyze_objects(roots,
                  index = "B",
                  marker = "id",
                  invert = TRUE,
                  tolerance = 3,
                  lower_eccent = 0.95)
r1_meas_cor <- get_measures(r1_meas, dpi = 150)
r1_meas_cor
plot(roots)
plot_measures(r1_meas_cor, measure = "diam_max")

img <- image_import("green.jpg", plot = TRUE)
# identifica o índice que melhor segmenta a imagem
image_binary(img, index = "all")


soy_green <-
  analyze_objects(img,
                  object_index = "G",
                  marker_col = "black",
                  col_background = "white",
                  show_contour = FALSE)
plot_measures(soy_green,
              measure = "G",
              col = "black")

ids <- which(soy_green$object_index$G < 0.5)

# proporção de esverdeados (%)
length(ids) / soy_green$statistics[1,2] * 100

cont <- object_contour(img, show_image = FALSE)
plot(img)
plot_contour(cont, id = ids, col = "red")

img2 <- image_import("vicia.jpg")
vicia <-
  analyze_objects(img2,
                  index = "B",
                  object_index = pliman_indexes_eq(),
                  show_image = FALSE,
                  parallel = TRUE)

head(vicia$object_index) %>%
  print_tbl()

cont2 <-
  object_contour(img2,
                 index = "B",
                 show_image = FALSE)

ids2 <- which(vicia$object_index$R > 0.25)
plot(img2)
plot_contour(cont2, id = ids2, col = "red")


# cria gráfico de densidade dos valores RGB para as duas classes de grãos
rgbs <-
  vicia$object_rgb %>%
  mutate(type = ifelse(object %in% ids2, "Destacado", "Não destacado")) %>%
  select(-object) %>%
  pivot_longer(-type) %>% 
  subset(name == "G")

ggplot(rgbs, aes(x = value)) +
  geom_density(fill = "green", alpha = 0.5) +
  facet_wrap(~type)

af <-
  analyze_objects(folhas,
                  watershed = FALSE,
                  lower_eccent = 0.3,
                  show_contour = FALSE,
                  col_background = "black")
af_cor <- get_measures(af, dpi = 50.8)
plot_measures(af_cor, measure = "area")

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

# imagens inteiras
imgs <-
  image_import(pattern = "leaf",
               plot = TRUE,
               ncol = 2)

# imagens da mesma amostra
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

sum(merged_cor$results$area[1:2])

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

## # mudar de acordo com a pasta em seu computador
## setwd("E:/Desktop/tiagoolivoto/static/tutorials/pliman_ip/imgs")

# gerar tabelas html
print_tbl <- function(table,  digits = 3, ...){
  knitr::kable(table, booktabs = TRUE, digits = digits, ...)
}
library(pliman)
library(tidyverse)

img <- image_import("img_1.jpeg")
h <- image_import("h_img1.png")
d <- image_import("d_img1.png")
b <- image_import("b_img1.png")
image_combine(img, h, d, b, ncol = 4)

sev <- 
  measure_disease(img = img,
                  img_healthy = h,
                  img_symptoms = d,
                  img_background = b,
                  show_image = TRUE)

sev <- 
  measure_disease(img = img,
                  img_healthy = h,
                  img_symptoms = d,
                  img_background = b,
                  show_image = TRUE,
                  show_contour = FALSE)

sev <- 
  measure_disease(img = img,
                  img_healthy = h,
                  img_symptoms = d,
                  img_background = b,
                  show_image = TRUE,
                  show_contour = FALSE,
                  show_original = FALSE)

sev <- 
  measure_disease(img = img,
                  img_healthy = h,
                  img_symptoms = d,
                  img_background = b,
                  show_image = TRUE,
                  watershed = TRUE,
                  show_contour = FALSE, # não mostra os contornos
                  show_features = TRUE, # computa características das lesões
                  show_segmentation = TRUE) # mostra as segmentações
sev$severity

sev$statistics %>% 
  print_tbl()
sev$shape[1:10, ] %>% 
  print_tbl()

## img %>%
##   image_resize(50) %>%
##   image_segment_iter(nseg = 2)
## 

# após escolhidos os índices, utiliza
sev_index <- 
  measure_disease(img, 
                  index_lb = "G",
                  index_dh = "NGRDI",
                  threshold = c("Otsu", -0.05),
                  show_image = TRUE)

system.time(
  sev_lote <- 
    measure_disease(pattern = "soy",
                    img_healthy = "healthy",
                    img_symptoms = "disease",
                    img_background = "back",
                    show_image = FALSE)
)
sev_lote$severity %>% 
  print_tbl()

system.time(
  sev_lote <- 
    measure_disease(pattern = "soy",
                    img_healthy = "healthy",
                    img_symptoms = "disease",
                    img_background = "back",
                    show_image = FALSE,
                    parallel = TRUE)
)

imgs <- 
  image_import(pattern = "proc_",
               path = "processed",
               plot = TRUE,
               ncol = 5)

ovos <- image_import("ovos.jpg", plot = TRUE)

## # funciona apenas em uma seção iterativa
## image_segment_iter(img, nseg = 2)
## 

ovos_cont <- 
  measure_disease(ovos,
                  index_lb = "HUE2",
                  index_dh = "GRAY",
                  invert = c(FALSE, TRUE),
                  threshold = c("Otsu", 0.7),
                  show_features = TRUE,
                  show_segmentation = TRUE,
                  show_contour = FALSE)
ovos_cont$statistics


ovos_cont <- 
  measure_disease(ovos,
                  index_lb = "HUE2",
                  index_dh = "GRAY",
                  invert = c(FALSE, TRUE),
                  threshold = c("Otsu", 0.7),
                  show_features = TRUE,
                  show_contour = FALSE,
                  col_lesions = "blue",
                  col_background = "black")


img <- image_import("maize_1.png", plot = TRUE)
image_segment(img, index = "all")



img <- image_import("maize_2.png", plot = TRUE)
image_segment(img, index = "all")



img2 <- image_crop(img,
                   width = 959:32,
                   height = 163:557,
                   plot = TRUE)


image_segment_iter(img2, 
                   nseg = 2, # define o número de segmentações
                   index = c("NR", "GLI"), # índices para primeira e segunda
                   invert = c(T, F), # inverter a segmentação? (passa um vetor)
                   ncol = 3) # número de colunas no plot

