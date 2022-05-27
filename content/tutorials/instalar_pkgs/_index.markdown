+++
title = "Instalação de pacotes R [Português]"
linktitle = "Instalação de pacotes R [Português]"
summary = "Veja aqui as opções de instalação de pacotes no R. "
date = "2021/09/28"
lastmod = "2021/09/28"
toc = true  # Show table of contents? true/false
type = "docs"  # Do not modify.
[menu.installpkg]
+++


# CRAN

O repositório [CRAN](https://cran.r-project.org/) (Comprehensive R Archive Network) é o repositório mais conhecido para publicação de pacotes R, mas não o único. No dia da publicação deste post, 18.547 pacotes estavam disponíveis no CRAN. 


```r
# número de pacotes disponíveis
pkgs <- available.packages()
nrow(pkgs)



# Número de downloads desde janeiro de 2022
library(cranlogs)
d <- 
  cran_downloads(from = "2022-01-01",
                 to = "last-day")

library(ggplot2)
ggplot(d, aes(date, count)) + 
  geom_smooth(se = FALSE) +
  labs(x = "data",
       y = "Número de downloads")



# Instalar pacotes do CRAN (ex., metan)
install.packages("pliman")
```



# Github
O Github é o repositório onde a maioria dos desenvolvedores de pacotes hospedam o código fonte. As funções do pacote metan, por exemplo, podem ser encontradas em https://github.com/TiagoOlivoto/metan/tree/master/R.

Para realizar o download de um pacote do Github, siga as instruções do criador (geralmente) orientações são fornecidas, como nesta página do pacote pliman (https://github.com/TiagoOlivoto/pliman#installation). Para realizar o download, o pacote `remotes` é sugerido. Basta então informar o repositório.


```r
if (!require("remotes", quietly = TRUE)){
  install.packages("remotes")
}
remotes::install_github("TiagoOlivoto/pliman")
```


# Bioconductor

O [Bioconductor](https://www.bioconductor.org/) usa a linguagem de programação estatística R e é de código aberto e desenvolvimento aberto. Ele tem dois lançamentos por ano e uma comunidade de usuários ativa.

Para instalação de pacotes do Bioconductor, o pacote `BiocManager` pode ser utilizado. No seguinte exemplo, o pacote EBImage é instalado do repositório Bioconductor.


```r
# Instalar pacotes do Bioconductor
if (!require("BiocManager", quietly = TRUE)){
  install.packages("BiocManager")
}

# Instalar os pacotes
BiocManager::install("EBImage", force = TRUE)
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
## loaded via a namespace (and not attached):
##  [1] bookdown_0.26   digest_0.6.29   R6_2.5.1        jsonlite_1.8.0 
##  [5] magrittr_2.0.3  evaluate_0.15   blogdown_1.10   stringi_1.7.6  
##  [9] rlang_1.0.2     cli_3.3.0       rstudioapi_0.13 jquerylib_0.1.4
## [13] bslib_0.3.1     rmarkdown_2.14  tools_4.2.0     stringr_1.4.0  
## [17] xfun_0.31       fastmap_1.1.0   compiler_4.2.0  htmltools_0.5.2
## [21] knitr_1.39      sass_0.4.1
```

