---
title: Fotoperíodo
linktitle: "7. Fotoperíodo"
toc: true
type: docs
date: "2021/12/0"
draft: false
code_download: true
menu:
  climato:
    parent: Agroclimatologia
    weight: 7
weight: 6
---

Os seguintes exemplos de códigos servem para calcular a declinação solar e a duração do dia (horas de sol) de um determinado ponto em um determinado dia do ano.


# Pacotes

```r
library(tidyverse)  # manipulação de dados
```


# Funções auxiliares

```r
# converter graus para radianos
deg2rad = function(deg) {
  return((pi * deg) / 180)
}
# converter radianos para graus
rad2deg = function(rad) {
  return((180 * rad) / pi)
}
# converter hora em decimal para h:m:s
dec2hms <- function(nasc){
  min <- nasc%%1 * 60
  seg <- min%%1 * 60
  paste0(trunc(nasc), ":", trunc(min), ":", trunc(seg))
}
```

# Declinação solar

Declinação do Sol é a distância angular do Equador ao paralelo do astro. A declinação pode ser obtida a partir da seguinte [fórmula](https://pt.wikipedia.org/wiki/Declina%C3%A7%C3%A3o) 

$$
d = 23.45 * \sin[360 / 365.2422 \times (284 + N)]
$$
Onde: d = declinação; N = número do dia Juliano (1 = 01/01/2021 - 365 = 31/12/2021 ou 366 se ano bissexto). A função `dsol` função computa a declinação solar em função do dia Juliano




```r
# declinação solar
dsol <- function(dj){
  if(length(dj) > 1){
    sapply(dj, dsol)
  } else{
    23.45 * sin(deg2rad((360/365.2422) * (284 + dj)))
  }
}
# exemplo para dia 15/01
dsol(14)
```

```
## [1] -21.46852
```

```r
# um exemplo com a inclinação ao longo de um ano
df_decl <- 
data.frame(dj = 1:365,
           dec = dsol(1:365))
ggplot(df_decl, aes(x = dj, y = dec)) + 
  geom_line() +
  labs(x = "Dia juliano",
       y = "Declinação solar (º)")
```

<img src="/tutorials/agrolimatologia/07_compr_dia_files/figure-html/unnamed-chunk-3-1.png" width="672" />


# Duração do dia

A duração do dia e da noite pode ser calculada utilizando a latitude do local e o dia do ano de interesse:

$$
T=\frac{2}{15} \arccos (-\tan \phi \cdot \tan \delta)
$$

Onde \(T\) é o tempo de duração do dia; \(\phi\) é a latitude da cidade (para cidades do hemisfério sul, o sinal é negativo); \(\delta\) é a declinação solar, calculada no ítem anterior.



```r
hsol <- function(lat, dj, lon = NULL){
  ds <- dsol(dj)
  n <- (2 / 15) * rad2deg(acos(-(tan(deg2rad(lat))) * (tan(deg2rad(ds)))))
  n2 <- n / 2
  if(is.null(lon)){
    h_cor <- 0
  } else{
    dif <- (lon - 45)
    h_cor <-  dif / 15
  }
  nasc <- 12 - n2 
  por <- 12 + n2 
  nasc_cor <- nasc + h_cor
  por_cor <- por + h_cor
  return(data.frame(d_sol = ds,
                    h_sol = n,
                    nasc = dec2hms(nasc),
                    por = dec2hms(por),
                    nasc_cor = dec2hms(nasc_cor),
                    por_cor = dec2hms(por_cor)))
}
```


No seguinte exemplo, é calculado a duração do dia e o nascer e por do sol para a seguinte localidade

* Local: São Paulo
* Latitude: -23°32'36" (-23,543333)
* Longitude: 46°37'59" (46,633056)
* Cálculo para o dia 29 de abril (n=119)


```r
hsol(lat = -23.543333,
     lon = 46.633056,
     dj = 119)
```

```
##      d_sol    h_sol    nasc      por nasc_cor  por_cor
## 1 14.18302 11.15708 6:25:17 17:34:42  6:31:49 17:41:14
```




```r
df <- 
  data.frame(local = c(rep("Lat = -2", 730),
                       rep("Lat = -27", 730),
                       rep("Lat = -45", 730)),
             lat = c(rep(-2, 730),
                     rep(-27, 730),
                     rep(-45, 730)),
             data = rep(seq(as.Date('2021-01-01'), as.Date('2022-12-31'), by = "1 days"), 3),
             dj =  rep(1:730, 3)) %>% 
  mutate(hsol(lat = lat, dj = dj))


solt_equi <- as.Date(c('2021-03-20',
                       '2021-06-21',
                       '2021-09-22',
                       '2021-12-21',
                       '2022-03-20',
                       '2022-06-21',
                       '2022-09-22',
                       '2022-12-21'))

ggplot(df, aes(x = data, y = h_sol, col = local)) +
  geom_line(size = 1) +
  geom_hline(yintercept = 12, linetype = 2) + 
  scale_y_continuous(breaks = 9:15) + 
  scale_x_date(breaks = solt_equi,
               date_labels = "%d/%m") +
  labs(x = "Dias do ano",
       y = "Horas de sol",
       title = "Duração no comprimento do dia (H)",
       caption = "Elaboração: Prof. Tiago Olivoto") +
  theme_gray(base_size = 14) +
  theme(legend.position = "bottom",
        panel.grid.minor = element_blank(),
        legend.title = element_blank())
```

<img src="/tutorials/agrolimatologia/07_compr_dia_files/figure-html/unnamed-chunk-6-1.png" width="672" />


