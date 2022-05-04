## ----global_options, include = FALSE-----------------------------------------------------------------
knitr::opts_chunk$set(cache = FALSE, comment = "#", collapse = TRUE)



## ----eval=FALSE--------------------------------------------------------------------------------------
## # mudar de acordo com a pasta em seu computador
## setwd("E:/Desktop/UFSC/cursos/pliman_imgp/imgs")


## ----echo = FALSE------------------------------------------------------------------------------------
knitr::opts_knit$set(root.dir = "E:/Desktop/UFSC/cursos/pliman_imgp/imgs")


## ----collapse = TRUE, message=FALSE, warning=FALSE---------------------------------------------------
library(pliman)
library(tidyverse)
library(patchwork)
img <- image_import("soy1.jpeg")



## ----import2-----------------------------------------------------------------------------------------
img_list1 <- image_import(c("img_sb_50_1.jpg", "img_sb_50_2.jpg"))
img_list2 <- image_import(pattern = "img_sb_")
str(img_list2)


## ----display1, fig.width = 10, fig.height=6----------------------------------------------------------
# Imagens individuais
plot(img)



## ----display2, fig.width = 10, fig.height=5----------------------------------------------------------
# Combine imagens
image_combine(img_list1)


## ----manipulate1-------------------------------------------------------------------------------------
image_dimension(img)
img_resized <- image_resize(img, rel_size = 50)
image_dimension(img_resized)


## ----eval = FALSE------------------------------------------------------------------------------------
## # executado apenas em uma seção interativa
## rule <- image_import("rule.jpg", plot = TRUE)
## dpi(rule)


## ----export, eval=FALSE------------------------------------------------------------------------------
## image_export(img, "img_exported.jpg")
## 
## # exportar lista (exemplo de subpasta)
## image_export(img_list2,
##              subfolder = "lista_exportada")


## ----segmentação2, fig.width = 10, fig.height = 5----------------------------------------------------
img <- 
  image_import("leaf5.jpg", plot = TRUE) %>% 
  image_resize(30) # reduz a resolução (plota mais rápido)

# Calcule os índices
indexes <- image_index(img, index = c("R, G, B"))

# Crie um gráfico raster com os valores RGB
plot(indexes, ncol = 3)

# Cria um histograma com os valores RGB
plot(indexes,
     type = "density",
     ncol = 3)


## ----segmentação3, fig.width = 10, fig.height = 5----------------------------------------------------
segmented <- image_segment(img, index = "B")


## ----binary1, fig.width = 10, fig.height = 5---------------------------------------------------------
binary <- image_binary(img, index = "B")

# tamanho de imagem original
image_binary(img,
             index = "B",
             resize = FALSE)

# inverte a binarização
image_binary(img,
             index = "B",
             resize = FALSE,
             invert = TRUE)


## ---- fig.width = 12, fig.height = 6-----------------------------------------------------------------
soy <- image_import("soy1.jpeg", plot = TRUE)

# contagem manual
# pick_count(soy)

# contagem automática
count <- analyze_objects(soy)
count$statistics


## ---- fig.width = 12, fig.height = 6-----------------------------------------------------------------
count2 <-
  analyze_objects(soy,
                  watershed = FALSE,
                  show_contour = FALSE,
                  marker = "id",
                  show_original = FALSE,
                  show_segmentation = TRUE) # padrão



## ----------------------------------------------------------------------------------------------------
system.time(
  list_res <- analyze_objects(pattern = "img_sb", show_image = FALSE)
)

# procesamento paralelo
# três múltiplas seções (observe o tempo!)
system.time(
  list_res <- 
    analyze_objects(pattern = "img_sb",
                    show_image = FALSE,
                    parallel = TRUE,
                    workers = 3)
)



## ----collapse=TRUE-----------------------------------------------------------------------------------
img <- image_pliman("objects_300dpi.jpg", plot = TRUE)



## ---- fig.width = 10, fig.height = 5-----------------------------------------------------------------
img_res <- analyze_objects(img, marker = "id")



## ----------------------------------------------------------------------------------------------------
get_measures(img_res,
             id = 1,
             area ~ 100)



## ----------------------------------------------------------------------------------------------------
img_res_cor <- get_measures(img_res, dpi = 300) |> as.data.frame()
img_res_cor


## ----------------------------------------------------------------------------------------------------
object_contour(img) %>%  # obtém o contorno dos objetos
  poly_mass() %>%        # computa o centro de massa e raios mínimo e máximo
  plot_mass()            # plota as medidas


## ----batata, fig.width = 10--------------------------------------------------------------------------
batata <- image_pliman("potato_leaves.jpg", plot = TRUE)

pot_meas <-
  analyze_objects(batata,
                  watershed = FALSE,
                  marker = "id",
                  show_chull = TRUE) # mostra o casco convex
pot_meas$results



## ----------------------------------------------------------------------------------------------------
bean <- image_import("bean.jpg", plot = TRUE)

bean_meas <- 
  analyze_objects(bean,
                  index = "G",
                  fill_hull = TRUE,
                  watershed = FALSE,
                  show_contour = FALSE,
                  col_background = "black",
                  marker = "id",
                  threshold = 0.45)
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


## ----------------------------------------------------------------------------------------------------
folhas <- image_import(image = "leaves.jpg", plot = TRUE)
af <-
  analyze_objects(folhas,
                  marker = "id",
                  watershed = FALSE,
                  show_contour = FALSE,
                  col_background = "black")

af_cor <- get_measures(af, dpi = 50.5)
plot_measures(af_cor,
              vjust = -25,
              col = "red",
              measure = "area")

get_measures(af, id = 30, area ~ 25)


## ----fig.width=10, fig.height=6----------------------------------------------------------------------
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


## ----------------------------------------------------------------------------------------------------
img <- image_import(pattern = "ref_", plot = TRUE)

area <- 
  analyze_objects(img = "ref_img",
                  foreground = "ref_leaf",
                  background = "ref_back",
                  reference = "ref_ref",
                  reference_area = 12,
                  marker = "area",
                  watershed = FALSE)


## ----merge0, fig.width = 10, fig.height = 10---------------------------------------------------------
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


## ----merge1------------------------------------------------------------------------------------------
merged <-
  analyze_objects(pattern = "L",
                  index = "B",
                  watershed = FALSE)


## ----merge2------------------------------------------------------------------------------------------
merged_cor <- get_measures(merged, dpi = 100)


## ----merge3------------------------------------------------------------------------------------------
merged_cor$results


## ----merge4------------------------------------------------------------------------------------------
merged_cor$summary


## ----merge5------------------------------------------------------------------------------------------
merged_cor$merge


## ----merge6------------------------------------------------------------------------------------------
sum(merged_cor$results$area[1:2])


## ----merge9, fig.width=10, fig.height=5--------------------------------------------------------------
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


## ----rgb1, fig.width = 10, fig.height = 10-----------------------------------------------------------
img <- image_import("soy1.jpeg", plot = TRUE)




## ----rgb2, fig.width = 10, fig.height = 10-----------------------------------------------------------
soy_green <-
  analyze_objects(img,
                  object_index = "R",
                  marker_col = "black",
                  col_background = "white",
                  show_contour = FALSE)

plot_measures(soy_green,
              measure = "R",
              col = "black")


## ----rgb4--------------------------------------------------------------------------------------------
report <- summary_index(soy_green, index = "R", cut_point = 0.6)
ids <- report$ids

plot(img)
plot_measures(soy_green,
              id = ids,
              measure = "R",
              col = "black")
cont <- object_contour(img, show_image = FALSE)
plot_contour(cont, id = ids, col = "red")


## ----rgb5, fig.width = 12, fig.height=10-------------------------------------------------------------
img2 <- image_import("vicia.jpg", plot = TRUE)

vicia <-
  analyze_objects(img2,
                  index = "B",
                  object_index = "R",
                  show_image = FALSE,
                  parallel = TRUE)

resumo_indice <- 
  summary_index(vicia,
                index = "R",
                cut_point = 0.25,
                select_higher = TRUE)

cont2 <-
  object_contour(img2,
                 index = "B",
                 show_image = FALSE)
ids2 <- resumo_indice$ids
plot_contour(cont2, id = ids2, col = "red")


# cria gráfico de densidade dos valores RGB para as duas classes de grãos
rgbs <-
  vicia$object_rgb %>%
  mutate(type = ifelse(id %in% ids2, "Destacado", "Não destacado")) %>%
  select(-id) %>%
  pivot_longer(-type)

ggplot(rgbs, aes(x = value)) +
  geom_density(aes(fill = name), alpha = 0.5) +
  facet_wrap(~type)


## ----doença1, fig.width = 12, fig.height = 3, collapse=TRUE------------------------------------------

img <- image_import("soy_1.jpg")
h <- image_import("sev_healthy.png")
d <- image_import("sev_disease.png")
b <- image_import("sev_back.png")
image_combine(img, h, d, b, ncol = 4)


## ----eval=FALSE, fig.width=10------------------------------------------------------------------------
## b2 <- pick_palette(img)
## h2 <- pick_palette(img)
## d2 <- pick_palette(img)
## image_combine(h2, d2, b2, ncol = 3)
## 


## ----------------------------------------------------------------------------------------------------
sev <- 
  measure_disease(img = img,
                  img_healthy = h,
                  img_symptoms = d,
                  img_background = b)
sev$severity


## ----------------------------------------------------------------------------------------------------
sev <- 
  measure_disease(img = img,
                  img_healthy = h,
                  img_symptoms = d,
                  img_background = b,
                  show_contour = FALSE)


## ----------------------------------------------------------------------------------------------------
sev <- 
  measure_disease(img = img,
                  img_healthy = h,
                  img_symptoms = d,
                  img_background = b,
                  show_contour = FALSE,
                  show_original = FALSE,
                  col_lesions = "brown")


## ----------------------------------------------------------------------------------------------------
sev <- 
  measure_disease(img = img,
                  img_healthy = h,
                  img_symptoms = d,
                  img_background = b,
                  watershed = TRUE,
                  lesion_size = "elarge",
                  show_contour = FALSE, # não mostra os contornos
                  show_features = TRUE, # computa características das lesões
                  show_segmentation = TRUE) # mostra as segmentações
sev$severity

sev$statistics
sev$shape[1:10, ]


## ----eval=FALSE--------------------------------------------------------------------------------------
## img %>%
##   image_resize(50) %>%
##   image_segment_iter(nseg = 2, ncol = 3)
## 


## ----------------------------------------------------------------------------------------------------
# após escolhidos os índices, utiliza
sev_index <- 
  measure_disease(img, 
                  index_lb = "G",
                  index_dh = "GLAI",
                  threshold = c("Otsu", 0.5),
                  show_image = TRUE)
sev_index$severity


## ----------------------------------------------------------------------------------------------------
system.time(
  sev_lote <- 
    measure_disease(pattern = "soy_",
                    img_healthy = "sev_healthy",
                    img_symptoms = "sev_disease",
                    img_background = "sev_back",
                    col_lesions = "brown",
                    show_contour = FALSE,
                    show_image = FALSE,
                    save_image = TRUE,
                    dir_processed = "processed",
                    parallel = TRUE)
)
sev_lote$severity


## ----fig.width=10, fig.height=10---------------------------------------------------------------------
imgs <- 
  image_import(pattern = "proc_",
               path = "processed",
               plot = TRUE,
               ncol = 5)


## ----------------------------------------------------------------------------------------------------
sad(sev_lote, n = 8, ncol = 4)


## ----------------------------------------------------------------------------------------------------
mult1 <- image_import("multiplas_01.jpeg", plot = TRUE)
image_index(mult1)

# 
byl <- 
  measure_disease_byl(pattern = "multiplas_",
                      index = "B", # usado para segmentar a folha do fundo
                      img_healthy = "sev_healthy",
                      img_symptoms = "sev_disease",
                      show_contour = FALSE,
                      col_lesions = "red")
byl$severity

