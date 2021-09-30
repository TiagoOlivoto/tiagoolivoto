## ----global_options, include = FALSE-------------------------------------------------------
knitr::opts_knit$set(root.dir = "E:/Desktop/tiagoolivoto/static/tutorials/pliman_esalq/leaves")


## ----eval=FALSE----------------------------------------------------------------------------
## # mudar de acordo com a pasta em seu computador
## setwd("E:/Desktop/tiagoolivoto/static/tutorials/pliman_esalq/leaves")


## ----collapse = TRUE, message=FALSE, warning=FALSE-----------------------------------------

library(pliman)  
img <- image_import("img_1.jpeg")
plot(img)



## ----import2-------------------------------------------------------------------------------

img_list <-
  image_import(pattern = "img_")
names(img_list)


## ----display1, fig.width = 12--------------------------------------------------------------
# Imagens individuais
plot(img)



## ----display2, fig.width = 12--------------------------------------------------------------

# Combine imagens
image_combine(img_list)




## ----manipulate1---------------------------------------------------------------------------
image_dimension(img)
img_resized <- image_resize(img, rel_size = 50)
image_dimension(img_resized)


## ------------------------------------------------------------------------------------------
crop1 <-
  image_crop(img,
             width = 38:1530,
             height = 168:874,
             plot = TRUE)


## ------------------------------------------------------------------------------------------
crop2 <-
  image_crop(img,
             width = 38:1530,
             plot = TRUE)


## ----eval = FALSE--------------------------------------------------------------------------
## # executa apenas em uma seção iterativa
## image_crop(img)


## ------------------------------------------------------------------------------------------
auto_crop <- image_autocrop(img, plot = TRUE)


## ----manipulate2, fig.width = 10-----------------------------------------------------------
# apara 100 pixels de todas as bordas
img_trim <- image_trim(img, edge = 100, plot = TRUE)

# O mesmo é alcançado com
img_trim2 <-
  image_trim(img,
             top = 100,
             bottom = 100,
             left = 100,
             right = 100,
             plot = TRUE)

# apara 200 pixels da parte superior e inferior
img_trim3 <-
  image_trim(img,
             top = 200,
             bottom = 200,
             plot = TRUE)




## ----eval = FALSE--------------------------------------------------------------------------
## # executado apenas em uma seção interativa
## rule <- image_import("rule.jpg", plot = TRUE)
## dpi(rule)


## ----manipulate6, fig.width = 10, fig.height = 6-------------------------------------------
img_filter <- image_filter(img)
img_blur <- image_blur(img)
img_contrast <- image_contrast(img)
img_dilatation <- image_dilate(img)
img_erosion <- image_erode(img)
image_combine(img, img_filter, img_blur, img_contrast, img_dilatation, img_erosion)


## ----export, eval=FALSE--------------------------------------------------------------------
## imagem_exportar(img, "img_exported.jpg")


## ---- echo=FALSE, eval=TRUE----------------------------------------------------------------


## ----eval=FALSE----------------------------------------------------------------------------
## # mudar de acordo com a pasta em seu computador
## setwd("E:/Desktop/tiagoolivoto/static/tutorials/pliman_esalq/leaves")


## ----collapse = TRUE, message=FALSE, warning=FALSE-----------------------------------------
library(pliman)  
img <- image_import("img_1.jpeg")
img <- image_resize(img, 50)
plot(img)



## ----segmentação2, fig.width = 10, fig.height = 5------------------------------------------
# Calcule os índices
indexes <- image_index(img, index = c("R, G, B, NR, NG, NB"))

# Crie um gráfico raster com os valores RGB
plot(indexes)

# Crie um histograma com os valores RGB
plot(indexes, type = "hist")


## ----segmentação3, fig.width = 10, fig.height = 5------------------------------------------
segmented <- image_segment(img, index = c("R, G, B, NR, NG, NB"))



## ----binary1, fig.width = 10, fig.height = 5-----------------------------------------------
binary <- image_binary(img)

# tamanho de imagem original
image_binary(img,
             index = "G",
             resize = FALSE)


## ----binary2, fig.width = 10, fig.height = 5-----------------------------------------------

image_binary(img,
             index = "G",
             resize = FALSE,
             fill_hull = TRUE)

## ---- echo=FALSE, eval=TRUE----------------------------------------------------------------


## ----eval=FALSE----------------------------------------------------------------------------
## # mudar de acordo com a pasta em seu computador
## setwd("E:/Desktop/tiagoolivoto/static/tutorials/pliman_esalq/leaves")


## ----doença1, fig.width = 12, fig.height = 3-----------------------------------------------
# gerar tabelas html
print_tbl <- function(table,  digits = 3, ...){
  knitr::kable(table, booktabs = TRUE, digits = digits, ...)
}
library(pliman)
img <- image_import("img_1.jpeg")
h <- image_import("h_img1.png")
d <- image_import("d_img1.png")
b <- image_import("b_img1.png")
image_combine(img, h, d, b, ncol = 4)


## ------------------------------------------------------------------------------------------
sev <- 
  measure_disease(img = img,
                  img_healthy = h,
                  img_symptoms = d,
                  img_background = b,
                  show_image = TRUE)


## ------------------------------------------------------------------------------------------
sev <- 
  measure_disease(img = img,
                  img_healthy = h,
                  img_symptoms = d,
                  img_background = b,
                  show_image = TRUE,
                  show_contour = FALSE)


## ------------------------------------------------------------------------------------------
sev <- 
  measure_disease(img = img,
                  img_healthy = h,
                  img_symptoms = d,
                  img_background = b,
                  show_image = TRUE,
                  show_contour = FALSE,
                  show_original = FALSE)


## ------------------------------------------------------------------------------------------
sev <- 
  measure_disease(img = img,
                  img_healthy = h,
                  img_symptoms = d,
                  img_background = b,
                  show_image = TRUE,
                  show_contour = FALSE, # não mostra os contornos
                  segment = TRUE, # segmenta as lesões que se tocam por poucos pixeis
                  show_segmentation = TRUE) # mostra as segmentações


## ------------------------------------------------------------------------------------------
feat <- 
  measure_disease(img = img,
                  img_healthy = h,
                  img_symptoms = d,
                  img_background = b,
                  show_image = TRUE,
                  segment = TRUE,
                  show_features = TRUE, # computa características das lesões
                  lesion_size = "medium") # padrão
print_tbl(feat$statistics)
print_tbl(feat$shape[1:10, ])

# corrigir as medidas (dpi = 150)
feat_corrected <- get_measures(feat, dpi = 150)



## ------------------------------------------------------------------------------------------
feat <- 
  measure_disease(img = img,
                  img_healthy = h,
                  img_symptoms = d,
                  img_background = b,
                  show_image = TRUE,
                  segment = TRUE,
                  show_features = TRUE, # computa características das lesões
                  lesion_size = "large") 



## ------------------------------------------------------------------------------------------
feat <- 
  measure_disease(img = img,
                  img_healthy = h,
                  img_symptoms = d,
                  img_background = b,
                  show_image = TRUE,
                  segment = TRUE,
                  tolerance  = 0.2) 



## ------------------------------------------------------------------------------------------
# library(pliman)
sev_img2 <- 
  measure_disease(img = "img_2",
                  img_healthy = "h_img2",
                  img_symptoms = "d_img2",
                  img_background = "b_img2",
                  show_image = FALSE,
                  show_contour = FALSE,
                  col_background  = "black")


imgs <- image_import(c("img_2.jpeg", "mask_im2.jpeg"))
image_combine(imgs)


## ------------------------------------------------------------------------------------------
sev_folhas <- 
  measure_disease(img = "soy_21",
                  img_healthy = "h_s",
                  img_symptoms = "d_s",
                  img_background = "b_s",
                  show_image = TRUE,
                  save_image = TRUE,
                  show_contour = FALSE,
                  col_background = "black")


## ----eval=FALSE----------------------------------------------------------------------------
## image_segment_iter(img)
## 


## ------------------------------------------------------------------------------------------
# após escolhidos os índices, utiliza
sev_index <- 
  measure_disease(img, 
                  index_lb = "G",
                  index_dh = "NGRDI",
                  show_image = TRUE)


## ------------------------------------------------------------------------------------------

system.time(
  sev_lote <- 
    measure_disease(pattern = "soy",
                    img_healthy = "h_s",
                    img_symptoms = "d_s",
                    img_background = "b_s",
                    verbose = FALSE)
)
print_tbl(sev_lote$severity)
# exporta os resultados
# rio::export(sev_lote$severity, "severidade.xlsx")


## ------------------------------------------------------------------------------------------
system.time(
  sev_lote <- 
    measure_disease(pattern = "soy",
                    img_healthy = "h_s",
                    img_symptoms = "d_s",
                    img_background = "b_s",
                    verbose = FALSE,
                    parallel = TRUE)
)


## ------------------------------------------------------------------------------------------
pepper <- image_import("pepper.png", plot = TRUE)
image_index(pepper, index = "all")


## ------------------------------------------------------------------------------------------

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
                   index = c("R/(G+B)", "GLI"), # índices para primeira e segunda
                   invert = c(T, F), # inverter a segmentação? (passa um vetor)
                   ncol = 3) # número de colunas no plot


img <- image_import("maize_3.png", plot = TRUE)
image_segment(img, index = "all")



## ---- echo=FALSE, eval=TRUE----------------------------------------------------------------

