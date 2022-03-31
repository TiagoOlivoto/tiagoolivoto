## # mudar de acordo com a pasta em seu computador
## setwd("E:/Desktop/tiagoolivoto/static/tutorials/pliman_ufsc_fito/leaves")

library(pliman)
img <- image_import("exemp_1.jpeg")
plot(img)


img_list <-  image_import(pattern = "exemp_", plot = TRUE)

# Imagens individuais
plot(img)



# Combine imagens
image_combine(img_list)



image_dimension(img)
img_resized <- image_resize(img, rel_size = 50)
image_dimension(img_resized)

crop1 <-
  image_crop(img,
             width = 71:685,
             height = 56:1159,
             plot = TRUE)

crop2 <-
  image_crop(img,
             height = 56:1159,
             plot = TRUE)

## # executa apenas em uma seção iterativa
## image_crop(img)

auto_crop <- image_autocrop(img, plot = TRUE)

## 
## # executado apenas em uma seção interativa
## rule <- image_import("rule.jpg", plot = TRUE)
## (dpi <- dpi(rule))
## 
## rule2 <- image_crop(rule, width = 379:1638, height = 790:1769)
## 
## analyze_objects(rule2,
##                 marker = "area",
##                 watershed = FALSE) |>
##   get_measures(dpi = 518) |>
##   plot_measures(measure = "area",
##                 vjust = -100,
##                 size = 2)

## imagem_exportar(img, "img_exported.jpg")



## # mudar de acordo com a pasta em seu computador
## setwd("E:/Desktop/tiagoolivoto/static/tutorials/pliman_ufsc_fito/leaves")

library(pliman)
img <- image_import("folhas.jpg", plot = TRUE)
resized <- image_resize(img, 30) # reduz a resolução (plota mais rápido)

# Calcule os índices
indexes <- image_index(resized, index = c("R, G, B"))

# Crie um gráfico raster com os valores RGB
plot(indexes, ncol = 3)

# Cria um histograma com os valores RGB
plot(indexes,
     type = "density",
     ncol = 3)

segmented <- image_segment(img, index = "B")

# tamanho de imagem original
image_binary(img, index = "B")

# inverte a binarização
image_binary(img, index = "B", invert = TRUE)



## # mudar de acordo com a pasta em seu computador
## setwd("E:/Desktop/tiagoolivoto/static/tutorials/pliman_ufsc_fito/leaves")


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
                  show_contour = FALSE,
                  show_original = FALSE,
                  col_lesions = "brown") # padrão é "black"

sev <- 
  measure_disease(img = img,
                  img_healthy = h,
                  img_symptoms = d,
                  img_background = b,
                  show_features = TRUE,
                  show_segmentation = TRUE)

# corrigir as medidas (dpi = 150)
sev_corrected <- get_measures(sev, dpi = 150)

system.time(
  sev_lote <- 
    measure_disease(pattern = "soy",
                    img_healthy = "soja_h",
                    img_symptoms = "soja_s",
                    img_background = "soja_b",
                    show_image = FALSE,
                    save_image = TRUE,
                    dir_processed = "processadas",
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
  geom_jitter(alpha = 0.3)

mult1 <- image_import("multiplas_01.jpeg", plot = TRUE)
image_index(mult1)

byl <- 
  measure_disease_byl(pattern = "multiplas_",
                      index = "B", # usado para segmentar a folha do fundo
                      img_healthy = "soja_h",
                      img_symptoms = "soja_s",
                      show_contour = FALSE,
                      show_features = TRUE,
                      col_lesions = "red")
results_byl <- get_measures(byl)
head(results_byl$results)
head(results_byl$summary)
head(results_byl$merge)
