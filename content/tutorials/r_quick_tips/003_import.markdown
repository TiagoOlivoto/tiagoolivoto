---
title: Importação e exportação de dados
linktitle: "3. Importação de dados"
toc: true
type: docs
date: "2021/11/25"
lastmod: "2021/11/25"
draft: false
df_print: paged
code_download: true
menu:
  rqt:
    parent: rqt
    weight: 4
weight: 3
---




<a class="btn btn-success" href="https://github.com/TiagoOlivoto/tiagoolivoto/tree/master/static/tutorials/r_quick_tips/003_import" target="_blank"><i class="fab fa-github"></i> Código fonte</a>


<!-- # Tutorial -->

<!-- <iframe width="760" height="430" src="https://www.youtube.com/embed/8B8QDZnDhtY" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe> -->


# Diretório e pacotes
O pacote [`rio`](https://cran.r-project.org/web/packages/rio/index.html) é um pacote R relativamente recente utilizado para importação e exportação de dados. Ele faz suposições sobre o formato do arquivo ([veja os formatos suportados aqui](https://www.rdocumentation.org/packages/rio/versions/0.5.29)), ou seja, adivinha o formato do arquivo que você está tentando importar e, consequentemente, aplica funções de importação apropriadas a esse formato. Tudo isso é feito com a função `import()`.

O primeiro passo sugerido é definir o diretório de trabalho para a pasta dos arquivos. É razoável assumir que se o arquivo está em uma determinada pasta, esta pasta conterá seus scripts e saídas.


```r
# definir diretório
setwd("E:/Desktop/tiagoolivoto/static/tutorials/r_quick_tips/003_import")
library(rio)
```


# Importar
## Do excel
### Um arquivo

```r
# primeira planilha do excel
df_excel <- import("df_excel.xlsx")
df_excel
```

```
##    RAD REP AF_M2       AF      MST
## 1   50   1  5.02 5016.429 12.30785
## 2   50   2  3.65 3648.359 10.73315
## 3   50   3  3.93 3925.333 10.86140
## 4   50   4  4.71 4705.269 10.97850
## 5   70   1  6.12 6118.425 15.75180
## 6   70   2  5.61 5614.233 13.30495
## 7   70   3  5.11 5109.944 13.88435
## 8   70   4  4.98 4975.857 13.09225
## 9  100   1  5.46 5464.528 16.92240
## 10 100   2  5.55 5551.951 14.93085
## 11 100   3  5.72 5723.849 16.12900
## 12 100   4  5.87 5869.697 15.78145
```

```r
# uma planilha específica
# converter para tible
df_excel2 <- 
  import("df_excel.xlsx",
         sheet = "traits",
         setclass = "tbl")
df_excel2
```

```
## # A tibble: 12 × 2
##       AF   MST
##    <dbl> <dbl>
##  1 5016.  12.3
##  2 3648.  10.7
##  3 3925.  10.9
##  4 4705.  11.0
##  5 6118.  15.8
##  6 5614.  13.3
##  7 5110.  13.9
##  8 4976.  13.1
##  9 5465.  16.9
## 10 5552.  14.9
## 11 5724.  16.1
## 12 5870.  15.8
```

### Vários arquivos 


```r
padrao <- list.files(pattern = "df_excel")
df_lista <- import_list(file = padrao)
str(df_lista)
```

```
## List of 3
##  $ df_excel :'data.frame':	12 obs. of  5 variables:
##   ..$ RAD  : num [1:12] 50 50 50 50 70 70 70 70 100 100 ...
##   ..$ REP  : num [1:12] 1 2 3 4 1 2 3 4 1 2 ...
##   ..$ AF_M2: num [1:12] 5.02 3.65 3.93 4.71 6.12 5.61 5.11 4.98 5.46 5.55 ...
##   ..$ AF   : num [1:12] 5016 3648 3925 4705 6118 ...
##   ..$ MST  : num [1:12] 12.3 10.7 10.9 11 15.8 ...
##   ..- attr(*, "filename")= chr "df_excel.xlsx"
##  $ df_excel2:'data.frame':	12 obs. of  5 variables:
##   ..$ RAD  : num [1:12] 50 50 50 50 70 70 70 70 100 100 ...
##   ..$ REP  : num [1:12] 1 2 3 4 1 2 3 4 1 2 ...
##   ..$ AF_M2: num [1:12] 5.02 3.65 3.93 4.71 6.12 5.61 5.11 4.98 5.46 5.55 ...
##   ..$ AF   : num [1:12] 5016 3648 3925 4705 6118 ...
##   ..$ MST  : num [1:12] 12.3 10.7 10.9 11 15.8 ...
##   ..- attr(*, "filename")= chr "df_excel2.xlsx"
##  $ df_excel3:'data.frame':	12 obs. of  5 variables:
##   ..$ RAD  : num [1:12] 50 50 50 50 70 70 70 70 100 100 ...
##   ..$ REP  : num [1:12] 1 2 3 4 1 2 3 4 1 2 ...
##   ..$ AF_M2: num [1:12] 5.02 3.65 3.93 4.71 6.12 5.61 5.11 4.98 5.46 5.55 ...
##   ..$ AF   : num [1:12] 5016 3648 3925 4705 6118 ...
##   ..$ MST  : num [1:12] 12.3 10.7 10.9 11 15.8 ...
##   ..- attr(*, "filename")= chr "df_excel3.xlsx"
```

```r
df_lista_bind <- import_list(file = padrao, rbind = TRUE)
df_lista_bind
```

```
##    RAD REP AF_M2       AF      MST          _file
## 1   50   1  5.02 5016.429 12.30785  df_excel.xlsx
## 2   50   2  3.65 3648.359 10.73315  df_excel.xlsx
## 3   50   3  3.93 3925.333 10.86140  df_excel.xlsx
## 4   50   4  4.71 4705.269 10.97850  df_excel.xlsx
## 5   70   1  6.12 6118.425 15.75180  df_excel.xlsx
## 6   70   2  5.61 5614.233 13.30495  df_excel.xlsx
## 7   70   3  5.11 5109.944 13.88435  df_excel.xlsx
## 8   70   4  4.98 4975.857 13.09225  df_excel.xlsx
## 9  100   1  5.46 5464.528 16.92240  df_excel.xlsx
## 10 100   2  5.55 5551.951 14.93085  df_excel.xlsx
## 11 100   3  5.72 5723.849 16.12900  df_excel.xlsx
## 12 100   4  5.87 5869.697 15.78145  df_excel.xlsx
## 13  50   1  5.02 5016.429 12.30785 df_excel2.xlsx
## 14  50   2  3.65 3648.359 10.73315 df_excel2.xlsx
## 15  50   3  3.93 3925.333 10.86140 df_excel2.xlsx
## 16  50   4  4.71 4705.269 10.97850 df_excel2.xlsx
## 17  70   1  6.12 6118.425 15.75180 df_excel2.xlsx
## 18  70   2  5.61 5614.233 13.30495 df_excel2.xlsx
## 19  70   3  5.11 5109.944 13.88435 df_excel2.xlsx
## 20  70   4  4.98 4975.857 13.09225 df_excel2.xlsx
## 21 100   1  5.46 5464.528 16.92240 df_excel2.xlsx
## 22 100   2  5.55 5551.951 14.93085 df_excel2.xlsx
## 23 100   3  5.72 5723.849 16.12900 df_excel2.xlsx
## 24 100   4  5.87 5869.697 15.78145 df_excel2.xlsx
## 25  50   1  5.02 5016.429 12.30785 df_excel3.xlsx
## 26  50   2  3.65 3648.359 10.73315 df_excel3.xlsx
## 27  50   3  3.93 3925.333 10.86140 df_excel3.xlsx
## 28  50   4  4.71 4705.269 10.97850 df_excel3.xlsx
## 29  70   1  6.12 6118.425 15.75180 df_excel3.xlsx
## 30  70   2  5.61 5614.233 13.30495 df_excel3.xlsx
## 31  70   3  5.11 5109.944 13.88435 df_excel3.xlsx
## 32  70   4  4.98 4975.857 13.09225 df_excel3.xlsx
## 33 100   1  5.46 5464.528 16.92240 df_excel3.xlsx
## 34 100   2  5.55 5551.951 14.93085 df_excel3.xlsx
## 35 100   3  5.72 5723.849 16.12900 df_excel3.xlsx
## 36 100   4  5.87 5869.697 15.78145 df_excel3.xlsx
```

## Planilha separada por vírgulas

```r
df_csv <- import("df_csv.csv")
df_csv
```

```
##    RAD REP AF_M2      AF   MST
## 1   50   1  5.02 5016.43 12.31
## 2   50   2  3.65 3648.36 10.73
## 3   50   3  3.93 3925.33 10.86
## 4   50   4  4.71 4705.27 10.98
## 5   70   1  6.12 6118.43 15.75
## 6   70   2  5.61 5614.23 13.30
## 7   70   3  5.11 5109.94 13.88
## 8   70   4  4.98 4975.86 13.09
## 9  100   1  5.46 5464.53 16.92
## 10 100   2  5.55 5551.95 14.93
## 11 100   3  5.72 5723.85 16.13
## 12 100   4  5.87 5869.70 15.78
```


## Arquivos de texto

```r
df_txt <- import("df_txt.txt")
df_txt
```

```
##    RAD REP AF_M2      AF   MST
## 1   50   1  5.02 5016.43 12.31
## 2   50   2  3.65 3648.36 10.73
## 3   50   3  3.93 3925.33 10.86
## 4   50   4  4.71 4705.27 10.98
## 5   70   1  6.12 6118.43 15.75
## 6   70   2  5.61 5614.23 13.30
## 7   70   3  5.11 5109.94 13.88
## 8   70   4  4.98 4975.86 13.09
## 9  100   1  5.46 5464.53 16.92
## 10 100   2  5.55 5551.95 14.93
## 11 100   3  5.72 5723.85 16.13
## 12 100   4  5.87 5869.70 15.78
```


## Google sheets

```r
url <- "https://docs.google.com/spreadsheets/d/1b-Sj9l-VwJ-Oy-hFx7j8twsA5oC6-Fr9ukllywfim0E"
df_gsheet <- import(url)
df_gsheet
```

```
##    RAD REP AF_M2        AF       MST
## 1   50   1  5.02 5.016.429 1.230.785
## 2   50   2  3.65 3.648.359 1.073.315
## 3   50   3  3.93 3.925.333   10.8614
## 4   50   4  4.71 4.705.269   10.9785
## 5   70   1  6.12 6.118.425   157.518
## 6   70   2  5.61 5.614.233 1.330.495
## 7   70   3  5.11 5.109.944 1.388.435
## 8   70   4  4.98 4.975.857 1.309.225
## 9  100   1  5.46 5.464.528   169.224
## 10 100   2  5.55 5.551.951 1.493.085
## 11 100   3  5.72 5.723.849    16.129
## 12 100   4  5.87 5.869.697 1.578.145
```




# Exportar
A exportação de dados pode ser feita facilmente com a função `export()`.

```r
# exportar para excel
export(df_excel, "exportado.xlsx")
# exportar para txt
export(df_excel, "exportado.txt")
# exportar para csv
export(df_excel, "exportado.csv")

# exportar várias planilhas para um arquivo
export(
  list(
    plan1 = df_excel,
    plan2 = df_excel2
  ),
  file = "minha_lista.xlsx"
)
```


# Versão e pacotes


```r
sessionInfo()
```

```
## R version 4.2.0 (2022-04-22 ucrt)
## Platform: x86_64-w64-mingw32/x64 (64-bit)
## Running under: Windows 10 x64 (build 22000)
## 
## Matrix products: default
## 
## locale:
## [1] LC_COLLATE=Portuguese_Brazil.utf8  LC_CTYPE=Portuguese_Brazil.utf8   
## [3] LC_MONETARY=Portuguese_Brazil.utf8 LC_NUMERIC=C                      
## [5] LC_TIME=Portuguese_Brazil.utf8    
## 
## attached base packages:
## [1] stats     graphics  grDevices utils     datasets  methods   base     
## 
## other attached packages:
## [1] rio_0.5.29
## 
## loaded via a namespace (and not attached):
##  [1] zip_2.2.0         Rcpp_1.0.8.3      cellranger_1.1.0  bslib_0.3.1      
##  [5] compiler_4.2.0    pillar_1.7.0      jquerylib_0.1.4   forcats_0.5.1    
##  [9] tools_4.2.0       digest_0.6.29     jsonlite_1.8.0    evaluate_0.15    
## [13] lifecycle_1.0.1   tibble_3.1.7      pkgconfig_2.0.3   rlang_1.0.2      
## [17] openxlsx_4.2.5    cli_3.3.0         rstudioapi_0.13   curl_4.3.2       
## [21] yaml_2.3.5        blogdown_1.10     haven_2.5.0       xfun_0.31        
## [25] fastmap_1.1.0     stringr_1.4.0     knitr_1.39        vctrs_0.4.1      
## [29] sass_0.4.1        hms_1.1.1         glue_1.6.2        data.table_1.14.2
## [33] R6_2.5.1          fansi_1.0.3       readxl_1.4.0      foreign_0.8-82   
## [37] rmarkdown_2.14    bookdown_0.26     magrittr_2.0.3    htmltools_0.5.2  
## [41] ellipsis_0.3.2    utf8_1.2.2        stringi_1.7.6     crayon_1.5.1
```


