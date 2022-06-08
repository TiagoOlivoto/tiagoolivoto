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




<a class="btn btn-success" href="https://downgit.github.io/#/home?url=https://github.com/TiagoOlivoto/tiagoolivoto/tree/master/static/tutorials/r_quick_tips/003_import" target="_blank"><i class="fab fa-github"></i> Download do exemplo!</a>


<!-- # Tutorial -->

<!-- <iframe width="760" height="430" src="https://www.youtube.com/embed/8B8QDZnDhtY" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe> -->


# Diretório e pacotes
O pacote [`rio`](https://cran.r-project.org/web/packages/rio/index.html) é um pacote R relativamente recente utilizado para importação e exportação de dados. Ele faz suposições sobre o formato do arquivo ([veja os formatos suportados aqui](https://www.rdocumentation.org/packages/rio/versions/0.5.29)), ou seja, adivinha o formato do arquivo que você está tentando importar e, consequentemente, aplica funções de importação apropriadas a esse formato. Tudo isso é feito com a função `import()`.

O primeiro passo sugerido é definir o diretório de trabalho para a pasta dos arquivos. É razoável assumir que se o arquivo está em uma determinada pasta, esta pasta conterá seus scripts e saídas.


```r
# definir diretório
setwd("E:/Desktop/tiagoolivoto/static/tutorials/r_quick_tips/003_import")
library(rio)

# para instalar os pacotes sugeridos e ampliar o leque de formatos
install_formats()
```

```
## [1] TRUE
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
(padrao <- list.files(pattern = "df_excel"))
```

```
## [1] "df_excel.xlsx"  "df_excel2.xlsx" "df_excel3.xlsx"
```

```r
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
##   ..$ AF_M2: chr [1:12] "5,02" "3,65" "3,93" "4,71" ...
##   ..$ AF   : chr [1:12] "5016,43" "3648,36" "3925,33" "4705,27" ...
##   ..$ MST  : chr [1:12] "12,31" "10,73" "10,86" "10,98" ...
##   ..- attr(*, "filename")= chr "df_excel3.xlsx"
```

```r
df_lista_bind <- import_list(file = padrao, rbind = TRUE)
df_lista_bind
```

```
##    RAD REP AF_M2         AF      MST          _file
## 1   50   1  5.02 5016.42875 12.30785  df_excel.xlsx
## 2   50   2  3.65  3648.3589 10.73315  df_excel.xlsx
## 3   50   3  3.93 3925.33325  10.8614  df_excel.xlsx
## 4   50   4  4.71  4705.2685  10.9785  df_excel.xlsx
## 5   70   1  6.12  6118.4251  15.7518  df_excel.xlsx
## 6   70   2  5.61 5614.23305 13.30495  df_excel.xlsx
## 7   70   3  5.11 5109.94435 13.88435  df_excel.xlsx
## 8   70   4  4.98 4975.85695 13.09225  df_excel.xlsx
## 9  100   1  5.46   5464.528  16.9224  df_excel.xlsx
## 10 100   2  5.55 5551.95115 14.93085  df_excel.xlsx
## 11 100   3  5.72 5723.84875   16.129  df_excel.xlsx
## 12 100   4  5.87 5869.69745 15.78145  df_excel.xlsx
## 13  50   1  5.02 5016.42875 12.30785 df_excel2.xlsx
## 14  50   2  3.65  3648.3589 10.73315 df_excel2.xlsx
## 15  50   3  3.93 3925.33325  10.8614 df_excel2.xlsx
## 16  50   4  4.71  4705.2685  10.9785 df_excel2.xlsx
## 17  70   1  6.12  6118.4251  15.7518 df_excel2.xlsx
## 18  70   2  5.61 5614.23305 13.30495 df_excel2.xlsx
## 19  70   3  5.11 5109.94435 13.88435 df_excel2.xlsx
## 20  70   4  4.98 4975.85695 13.09225 df_excel2.xlsx
## 21 100   1  5.46   5464.528  16.9224 df_excel2.xlsx
## 22 100   2  5.55 5551.95115 14.93085 df_excel2.xlsx
## 23 100   3  5.72 5723.84875   16.129 df_excel2.xlsx
## 24 100   4  5.87 5869.69745 15.78145 df_excel2.xlsx
## 25  50   1  5,02    5016,43    12,31 df_excel3.xlsx
## 26  50   2  3,65    3648,36    10,73 df_excel3.xlsx
## 27  50   3  3,93    3925,33    10,86 df_excel3.xlsx
## 28  50   4  4,71    4705,27    10,98 df_excel3.xlsx
## 29  70   1  6,12    6118,43    15,75 df_excel3.xlsx
## 30  70   2  5,61    5614,23    13,30 df_excel3.xlsx
## 31  70   3  5,11    5109,94    13,88 df_excel3.xlsx
## 32  70   4  4,98    4975,86    13,09 df_excel3.xlsx
## 33 100   1  5,46    5464,53    16,92 df_excel3.xlsx
## 34 100   2  5,55    5551,95    14,93 df_excel3.xlsx
## 35 100   3  5,72    5723,85    16,13 df_excel3.xlsx
## 36 100   4  5,87    5869,70    15,78 df_excel3.xlsx
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
df_gsheet <- import(url, dec = ",")
df_gsheet
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


## SPSS

O arquivo `".sav"` de exemplo foi baixado [deste site](https://lo.unisa.edu.au/mod/book/view.php?id=646443&chapterid=106604) 

```r
df_spss <- import("df_spss.sav", setclass = "tbl")
df_spss
```

```
## # A tibble: 306 × 59
##    IDnumber   age   sex workstat increg incmnth incwk housing living homepay
##       <dbl> <dbl> <dbl>    <dbl>  <dbl>   <dbl> <dbl>   <dbl>  <dbl>   <dbl>
##  1 20160186    19     2        3      1       0   0         2      1       1
##  2 20160011    17     2        0      0       0   0         2      1       1
##  3 20160081    18     2        3      1     300  69.2       2      1       1
##  4 20160155    18     2        0      0       0   0         2      1       1
##  5 20160182    19     2        0      1     600 138.        2      1       4
##  6 20160027    17     2        0      0       0   0         2      1       4
##  7 20160188    19     2        0      0       0   0         2      1      99
##  8 20160013    17     2        0      0       0   0         2      1       1
##  9 20160214    20     2        0      1    1500 346.        3      2       4
## 10 20160216    20     2        3      1     400  92.3       3      2       1
## # … with 296 more rows, and 49 more variables: homecost <dbl>,
## #   homecostwk <dbl>, mobile <dbl>, mobilepay <dbl>, mobilecost <dbl>,
## #   mobilecostwk <dbl>, transport <dbl>, food <dbl>, entertain <dbl>,
## #   privhlth <dbl>, fs_illness <dbl>, fs_accident <dbl>, fs_death <dbl>,
## #   fs_mtlillness <dbl>, fs_disability <dbl>, fs_divsep <dbl>,
## #   fs_nogetjob <dbl>, fs_lossofjob <dbl>, fs_alcdrug <dbl>, fs_witviol <dbl>,
## #   fs_absvcrim <dbl>, fs_police <dbl>, fs_gambling <dbl>, famstress <dbl>, …
```

## DBF
O arquivo `".dbf"` de exemplo foi baixado [deste site](https://github.com/infused/dbf/blob/master/spec/fixtures/dbase_83.dbf) 

```r
df_dbf <- import("df_dbf.dbf")
df_dbf
```

```
##    ID CATCOUNT AGRPCOUNT PGRPCOUNT ORDER      CODE
## 1  87        2         0         0    87         1
## 2  26        3         0         0    26      CPKG
## 3  27        3         0         0    27      CHOC
## 4  28        3         0         0    28    PASTEL
## 5  29        2         0         0    29  CKR-1001
## 6  30        3         0         0    30         C
## 7  31        3         0         0    31     TBC01
## 8  32        2         0         0    32      BD01
## 9  33        1         0         0    33      DS02
## 10 34        1         0         0    34      AB01
## 11 35        2         0         0    35      1006
## 12 36        2         0         0    36      BC01
## 13 37        3         0         0    37      CC01
## 14 38        3         0         0    38    D-1005
## 15 39        2         0         0    39   CH-BC01
## 16 40        3         0         0    40         M
## 17 41        3         0         0    41        CR
## 18 42        2         0         0    42    SLEIGH
## 19 43        2         0         0    43      PT01
## 20 44        2         0         0    44    GINGER
## 21 45        3         0         0    45      LB01
## 22 46        2         0         0    46      CRAN
## 23 47        3         0         0    47     SAM02
## 24 48        1         0         0    48      CP01
## 25 49        2         0         0    49     NYEAR
## 26 50        1         0         0    50      CH02
## 27 51        1         0         0    51      CH03
## 28 52        1         0         0    52      CH04
## 29 53        1         0         0    53      CH05
## 30 54        1         0         0    54      CH06
## 31 55        1         0         0    55  MC-Heart
## 32 56        3         0         0    56      VA01
## 33 57        3         0         0    57     VA01A
## 34 58        3         0         0    58      VABC
## 35 59        2         0         0    59     BAS03
## 36 60        2         0         0    60     1004A
## 37 61        3         0         0    61     FUDGE
## 38 62        3         0         0    62   VA-1005
## 39 63        3         0         0    63      CS01
## 40 64        2         0         0    64    D-BCO1
## 41 65        2         0         0    65      SPBC
## 42 66        3         0         0    66   SP-1001
## 43 67        3         0         0    67        FB
## 44 69        3         0         0    69        WC
## 45 70        2         0         0    70 BABY-1002
## 46 71        2         0         0    71      PA03
## 47 72        3         0         0    72        EO
## 48 73        2         0         0    73    E-BC01
## 49 74        2         0         0    74     1101A
## 50 75        2         0         0    75      1101
## 51 76        2         0         0    76      E010
## 52 77        2         0         0    77      DK01
## 53 78        2         0         0    78    MC-EGG
## 54 79        2         0         0    79     BAS02
## 55 80        3         0         0    80       PKG
## 56 81        2         0         0    81 SHOE-BC01
## 57 82        2         0         0    82  TIE-BC01
## 58 83        3         0         0    83       PET
## 59 84        3         0         0    84 STAR-1001
## 60 85        2         0         0    85 STAR-BC01
## 61 86        3         0         0    86         H
## 62 88        3         0         0    88  EYEBALLS
## 63 89        2         0         0    89    H-BC01
## 64 90        3         0         0    90       HRV
## 65 91        2         0         0    91  HRV-BC01
## 66 93        2         0         0    93    D-1001
## 67 94        2         0         0    94      BD02
##                                           NAME
## 1                        Assorted Petits Fours
## 2                 Christmas Package Collection
## 3              Chocolate Assorted Petits Fours
## 4                 Pastel Assorted Petits Fours
## 5                                 Checkerbites
## 6                       Christmas Petits Fours
## 7                          Truffled Shortbread
## 8                           Biscotti di Divine
## 9                              Dresden Stollen
## 10                    Apricot Brandy Fruitcake
## 11                                 Trufflecots
## 12                       Butter Cookie Sampler
## 13                   Petite Cheesecake Sampler
## 14           Demitasse Truffles & Petits Fours
## 15                        Christmas Shortbread
## 16                                Mice-A-Fours
## 17                                    Critters
## 18                       Golden Sleigh Sampler
## 19                       Pumpkin Spice Teacake
## 20                              Ginger Teacake
## 21                    Lemon Buttermilk Teacake
## 22                    Cranberry Orange Teacake
## 23                            Tea Cake Sampler
## 24                        Chocolate Pecan Tart
## 25                       New Year Petits Fours
## 26                                Rose Tea Cup
## 27                              Violet Tea Cup
## 28                               Pansy Tea Cup
## 29                       Forget-me-not Tea Cup
## 30                       Morning Glory Tea Cup
## 31                      Golden Chocolate Heart
## 32                      Valentine Petits Fours
## 33                      Valentine Petits Fours
## 34                        Valentine Shortbread
## 35                           Basket of Romance
## 36                                     Fudgies
## 37                             Tunnel of Fudge
## 38 Valentine Demitasse Truffles & Petits Fours
## 39                       Butter Cinnamon Swirl
## 40                           Daisy Shortbreads
## 41                 Shamrock Shortbread Cookies
## 42              St. Patrick's Day Petits Fours
## 43                      Petit Four Favor Boxes
## 44                              Wedding Cremes
## 45                      Baby Shower Assortment
## 46                             Wedding Pastels
## 47                         Easter Petits Fours
## 48                          Easter Shortbreads
## 49                             Baby Hop Basket
## 50                     Great Grande Hop Basket
## 51                          Truffle Egg Carton
## 52                        Milk Chocolate Ducks
## 53                   Milk Chocolate Easter Egg
## 54                                  Tea Basket
## 55                      The Package Collection
## 56                  Shortbread Shoe Collection
## 57                                 Tin of Ties
## 58                           Petals and Cremes
## 59                          Hearts and Stripes
## 60              4th of July Shortbread Cookies
## 61                   Hallowed Eve Petits Fours
## 62                            Eyeball Truffles
## 63                        Halloween Shortbread
## 64                        Harvest Petits Fours
## 65                      Harvest Shortbread Tin
## 66            Demitasse Christmas Petits Fours
## 67                            Trio of Biscotti
##                            THUMBNAIL                           IMAGE PRICE
## 1          graphics/00000001/t_1.jpg         graphics/00000001/1.jpg  0.00
## 2       graphics/00000001/t_CPKG.jpg      graphics/00000001/CPKG.jpg  0.00
## 3       graphics/00000001/t_CHOC.jpg      graphics/00000001/CHOC.jpg  0.00
## 4     graphics/00000001/t_PASTEL.jpg    graphics/00000001/PASTEL.jpg  0.00
## 5   graphics/00000001/t_CKR-1001.jpg  graphics/00000001/CKR-1001.jpg 15.75
## 6          graphics/00000001/t_C.jpg         graphics/00000001/C.jpg  0.00
## 7      graphics/00000001/t_TBC01.jpg     graphics/00000001/TBC01.jpg 19.25
## 8       graphics/00000001/t_BD01.jpg      graphics/00000001/BD01.jpg 28.75
## 9       graphics/00000001/t_DS02.jpg      graphics/00000001/DS02.jpg 23.95
## 10      graphics/00000001/t_AB01.jpg      graphics/00000001/AB01.jpg 37.95
## 11      graphics/00000001/t_1006.jpg      graphics/00000001/1006.jpg 29.95
## 12      graphics/00000001/t_BC01.jpg      graphics/00000001/BC01.jpg 28.95
## 13      graphics/00000001/t_CC01.jpg      graphics/00000001/CC01.jpg 27.65
## 14    graphics/00000001/t_D-1005.jpg    graphics/00000001/D-1005.jpg 27.50
## 15   graphics/00000001/t_CH-BC01.jpg   graphics/00000001/CH-BC01.jpg 34.95
## 16         graphics/00000001/t_M.jpg         graphics/00000001/M.jpg  0.00
## 17        graphics/00000001/t_CR.jpg        graphics/00000001/CR.jpg  0.00
## 18    graphics/00000001/t_SLEIGH.jpg    graphics/00000001/SLEIGH.jpg 47.95
## 19      graphics/00000001/t_PT01.jpg      graphics/00000001/PT01.jpg 25.75
## 20    graphics/00000001/t_GINGER.jpg    graphics/00000001/GINGER.jpg 25.25
## 21      graphics/00000001/t_LB01.jpg      graphics/00000001/LB01.jpg 25.70
## 22      graphics/00000001/t_CRAN.jpg      graphics/00000001/CRAN.jpg 25.95
## 23     graphics/00000001/t_SAM02.jpg     graphics/00000001/SAM02.jpg 26.95
## 24      graphics/00000001/t_CP01.jpg      graphics/00000001/CP01.jpg 27.95
## 25     graphics/00000001/t_NYEAR.jpg     graphics/00000001/NYEAR.jpg  0.00
## 26      graphics/00000001/t_CH02.jpg      graphics/00000001/CH02.jpg 87.00
## 27      graphics/00000001/t_CH03.jpg      graphics/00000001/CH03.jpg 87.00
## 28      graphics/00000001/t_CH04.jpg      graphics/00000001/CH04.jpg 87.00
## 29      graphics/00000001/t_CH05.jpg      graphics/00000001/CH05.jpg 87.00
## 30      graphics/00000001/t_CH06.jpg      graphics/00000001/CH06.jpg 87.00
## 31  graphics/00000001/t_MC-HEART.jpg  graphics/00000001/MC-HEART.jpg 14.87
## 32      graphics/00000001/t_VA01.jpg      graphics/00000001/VA01.jpg 36.95
## 33     graphics/00000001/t_VA01A.jpg     graphics/00000001/VA01A.jpg 28.95
## 34      graphics/00000001/t_VABC.jpg      graphics/00000001/VABC.jpg 33.75
## 35     graphics/00000001/t_BAS03.jpg     graphics/00000001/BAS03.jpg 48.50
## 36     graphics/00000001/t_1004A.jpg     graphics/00000001/1004A.jpg 16.95
## 37     graphics/00000001/t_FUDGE.jpg     graphics/00000001/FUDGE.jpg 26.75
## 38   graphics/00000001/t_VA-1005.jpg   graphics/00000001/VA-1005.jpg 27.50
## 39      graphics/00000001/t_CS01.jpg    graphics/00000001/b_CS01.jpg 25.50
## 40    graphics/00000001/t_D-BC01.jpg    graphics/00000001/D-BC01.jpg 32.25
## 41      graphics/00000001/t_SPBC.jpg      graphics/00000001/SPBC.jpg 32.50
## 42   graphics/00000001/t_SP-1001.jpg   graphics/00000001/SP-1001.jpg 27.50
## 43        graphics/00000001/t_FB.jpg        graphics/00000001/FB.jpg 17.50
## 44        graphics/00000001/t_WC.jpg    graphics/00000001/WC_vs2.jpg  0.00
## 45 graphics/00000001/t_BABY-1002.jpg graphics/00000001/BABY-1002.jpg 44.75
## 46      graphics/00000001/t_PA03.jpg  graphics/00000001/PA03_vs2.jpg 49.50
## 47        graphics/00000001/t_EO.jpg        graphics/00000001/EO.jpg  0.00
## 48    graphics/00000001/t_E-BC01.jpg    graphics/00000001/E-BC01.jpg 35.25
## 49     graphics/00000001/t_1101A.jpg     graphics/00000001/1101A.jpg 27.50
## 50      graphics/00000001/t_1101.jpg      graphics/00000001/1101.jpg 49.95
## 51      graphics/00000001/t_E010.jpg      graphics/00000001/E010.jpg 28.95
## 52      graphics/00000001/t_DK01.jpg      graphics/00000001/DK01.jpg  6.95
## 53    graphics/00000001/t_MC-EGG.jpg    graphics/00000001/MC-EGG.jpg 28.95
## 54     graphics/00000001/t_BAS02.jpg     graphics/00000001/BAS02.jpg 39.75
## 55       graphics/00000001/t_PKG.jpg       graphics/00000001/PKG.jpg  0.00
## 56 graphics/00000001/t_SHOE-BC01.jpg graphics/00000001/SHOE-BC01.jpg 33.95
## 57  graphics/00000001/t_TIE-BC01.jpg  graphics/00000001/TIE-BC01.jpg 33.50
## 58       graphics/00000001/t_PET.jpg       graphics/00000001/PET.jpg  0.00
## 59 graphics/00000001/t_STAR-1001.jpg graphics/00000001/STAR-1001.jpg 28.25
## 60 graphics/00000001/t_STAR-BC01.jpg graphics/00000001/STAR-BC01.jpg 33.75
## 61        graphics/00000001/t_H1.jpg        graphics/00000001/H1.jpg  0.00
## 62  graphics/00000001/t_eyeballs.jpg  graphics/00000001/eyeballs.jpg 28.95
## 63    graphics/00000001/t_H-BC01.jpg    graphics/00000001/H-BC01.jpg 35.95
## 64       graphics/00000001/t_HRV.jpg       graphics/00000001/HRV.jpg  0.00
## 65  graphics/00000001/t_HRV-BC01.jpg  graphics/00000001/HRV-BC01.jpg 34.25
## 66    graphics/00000001/t_D-1001.jpg    graphics/00000001/D-1001.jpg 28.95
## 67      graphics/00000001/t_BD02.jpg      graphics/00000001/BD02.jpg 29.75
##     COST DESC WEIGHT TAXABLE ACTIVE
## 1   0.00    1   5.51    TRUE   TRUE
## 2  28.95    3   0.00   FALSE   TRUE
## 3  28.95    6   0.00   FALSE  FALSE
## 4  28.95    8   0.00   FALSE   TRUE
## 5  15.75    9   0.00   FALSE   TRUE
## 6  31.95   10   0.00   FALSE   TRUE
## 7  19.25   11   0.00   FALSE  FALSE
## 8  28.75   12   0.00   FALSE  FALSE
## 9  23.95   13   0.00   FALSE  FALSE
## 10 37.95   14   0.00   FALSE   TRUE
## 11 29.95   16   0.00   FALSE   TRUE
## 12 28.95   17   0.00   FALSE   TRUE
## 13 27.65   18   0.00   FALSE   TRUE
## 14 27.50   19   0.00   FALSE   TRUE
## 15 34.95   20   0.00   FALSE   TRUE
## 16 19.75   22   0.00   FALSE  FALSE
## 17 28.95   23   0.00   FALSE  FALSE
## 18 47.95   24   0.00   FALSE   TRUE
## 19 25.75   26   0.00   FALSE   TRUE
## 20 25.25   27   0.00   FALSE   TRUE
## 21 25.70   28   0.00   FALSE   TRUE
## 22 25.95   29   0.00   FALSE   TRUE
## 23 26.95   31   0.00   FALSE   TRUE
## 24 27.95   32   0.00   FALSE   TRUE
## 25 29.95   33   0.00   FALSE  FALSE
## 26  0.00   34   0.00   FALSE   TRUE
## 27  0.00   35   0.00   FALSE   TRUE
## 28  0.00   36   0.00   FALSE   TRUE
## 29  0.00   37   0.00   FALSE   TRUE
## 30  0.00   38   0.00   FALSE   TRUE
## 31 14.87   39   0.00   FALSE  FALSE
## 32 36.95   40   0.00   FALSE  FALSE
## 33 29.95   41   0.00   FALSE  FALSE
## 34 33.75   42   0.00   FALSE  FALSE
## 35 48.50   43   0.00   FALSE  FALSE
## 36 16.95   44   0.00   FALSE   TRUE
## 37 26.75   45   0.00   FALSE  FALSE
## 38 27.50   46   0.00   FALSE  FALSE
## 39 25.50   47   0.00   FALSE  FALSE
## 40 32.25   48   0.00   FALSE  FALSE
## 41 32.50   49   0.00   FALSE  FALSE
## 42 27.50   51   0.00   FALSE  FALSE
## 43 17.50   52   0.00    TRUE   TRUE
## 44 28.95   54   0.00   FALSE  FALSE
## 45 44.75   56   0.00   FALSE  FALSE
## 46 49.50   57   0.00   FALSE   TRUE
## 47 28.95   58   0.00   FALSE  FALSE
## 48 35.25   59   0.00   FALSE  FALSE
## 49 27.50   60   0.00   FALSE  FALSE
## 50 49.95   61   0.00   FALSE  FALSE
## 51 28.95   62   0.00   FALSE  FALSE
## 52  6.95   63   0.00   FALSE  FALSE
## 53 28.95   64   0.00   FALSE  FALSE
## 54 39.75   65   0.00   FALSE  FALSE
## 55 28.95   66   0.00   FALSE  FALSE
## 56 33.95   67   0.00   FALSE  FALSE
## 57 33.50   68   0.00   FALSE  FALSE
## 58 27.50   69   0.00   FALSE  FALSE
## 59 28.25   70   0.00   FALSE  FALSE
## 60 33.75   71   0.00   FALSE  FALSE
## 61 29.95   72   0.00   FALSE  FALSE
## 62 28.95   73   0.00   FALSE  FALSE
## 63 35.95   74   0.00   FALSE  FALSE
## 64  0.00   75   0.00   FALSE   TRUE
## 65  0.00   76   0.00   FALSE  FALSE
## 66  0.00   77   0.00   FALSE   TRUE
## 67  0.00   78   0.00   FALSE   TRUE
```

## ODS

```r
df_ods <- import("df_ods.ods")
```

```
## Loading required namespace: readODS
```

```r
df_ods
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


## Rdata

```r
df_rdata <- import("df_r.Rdata")
df_rdata
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



# Exportar

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
## [25] fastmap_1.1.0     xml2_1.3.3        stringr_1.4.0     knitr_1.39       
## [29] readODS_1.7.0     vctrs_0.4.1       sass_0.4.1        hms_1.1.1        
## [33] glue_1.6.2        data.table_1.14.2 R6_2.5.1          fansi_1.0.3      
## [37] readxl_1.4.0      foreign_0.8-82    rmarkdown_2.14    bookdown_0.26    
## [41] tzdb_0.3.0        readr_2.1.2       magrittr_2.0.3    htmltools_0.5.2  
## [45] ellipsis_0.3.2    utf8_1.2.2        stringi_1.7.6     crayon_1.5.1
```



