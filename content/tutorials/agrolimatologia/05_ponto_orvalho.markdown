---
title: Temperatura no ponto de orvalho
linktitle: "5. Temperatura no ponto de orvalho"
toc: true
type: docs
date: "2021/07/09"
draft: false
code_download: true
menu:
  climato:
    parent: Agroclimatologia
    weight: 6
weight: 5
---

# Pacotes

```r
library(tidyverse)  # manipulação de dados
library(metan)      # manipulação de dados 
library(rio)        # importação/exportação de dados

clima_fred <- import("https://bit.ly/inmet_fred_2020")
clima_pf <- import("https://bit.ly/inmet_pf_2020")
```


# Período de molhamento foliar

```r
df_horas <- 
  subset(clima_fred, DATA %in% c("01/03/2020", 
                                 "01/06/2020")) %>% 
  select(DATA, HORA,  UM_INST)

ggplot(df_horas, aes(HORA, UM_INST, color = factor(DATA), group = DATA)) + 
  geom_line() + 
  geom_point() + 
  geom_hline(yintercept = 90, linetype = 2) + 
  theme(panel.grid.minor = element_blank(),
        legend.position = "bottom",
        legend.title = element_blank(),
        axis.title = element_text(size = 12),
        axis.text = element_text(size = 12)) + 
  scale_x_continuous(breaks = seq(0,24, by = 2)) + 
  labs(title = "Umidade relativa do ar",
       subtitle = "Estação INMET - UFSM-FW",
       caption = "Elaboração: Prof. Tiago Olivoto",
       x = "Hora do dia",
       y = "Umidade relativa do ar (%)")
```

<img src="/tutorials/agrolimatologia/05_ponto_orvalho_files/figure-html/unnamed-chunk-2-1.png" width="672" />

# Média mensal da soma diária de horas com UR > 90%

```r
df
```

```
## function (x, df1, df2, ncp, log = FALSE) 
## {
##     if (missing(ncp)) 
##         .Call(C_df, x, df1, df2, log)
##     else .Call(C_dnf, x, df1, df2, ncp, log)
## }
## <bytecode: 0x000000002b89e090>
## <environment: namespace:stats>
```

```r
# número de horas com UR > 90%
df_horas2 <- 
clima_fred %>% 
  select(DATA, HORA, MES, UM_INST) %>% 
  mutate(NHUR = ifelse(UM_INST > 90, 1, 0)) %>% 
  sum_by(DATA, MES) %>% 
  select_cols(DATA, MES, NHUR) %>% 
  means_by(MES)
```

```
## Warning: NA values removed to compute the function. Use 'na.rm = TRUE' to
## suppress this warning.
```

```
## To remove rows with NA use `remove_rows_na()'. 
## To remove columns with NA use `remove_cols_na()'.
```

```r
ggplot(df_horas2, aes(factor(MES), NHUR)) + 
  geom_col() +
  geom_text(aes(label = round(NHUR, 2)),
            vjust = -0.5) + 
  theme(panel.grid.minor = element_blank(),
        legend.position = "bottom",
        legend.title = element_blank(),
        axis.title = element_text(size = 12),
        axis.text = element_text(size = 12)) + 
  scale_y_continuous(expand = expansion(c(0, 0.1))) +
  labs(title = "Média mensal da soma diária com UR > 90%",
       subtitle = "Estação INMET - UFSM-FW",
       caption = "Elaboração: Prof. Tiago Olivoto",
       x = "Mês do ano",
       y = "Número de horas")
```

<img src="/tutorials/agrolimatologia/05_ponto_orvalho_files/figure-html/unnamed-chunk-3-1.png" width="672" />


# Temperatura no ponto de orvalho

```r
# Aproximação considerando a temperatura do ar (t) e umidade relativa (ur)
# fórmula disponível em https://pt.planetcalc.com/248/
get_tpo <- function(t, ur){
  a <- 17.27
  b <- 237.7
  ur <- ur / 100
  (b * ((a * t) / (b + t) + log(ur))) / (a - ((a * t) / (b + t) + log(ur)))
}

# ponto de orvalho
# umidade: 75 %
# temperatura: 15º
get_tpo(15, 75)
```

```
## [1] 10.60278
```

```r
# criar dados
temp <- seq(0, 40, by = 0.1)
ur <- seq(10, 90, by = 0.1)
df <- expand_grid(temp, ur)
df <- mutate(df, po = get_tpo(temp, ur))

# criar um gráfico
ggplot(df, aes(temp, ur)) +
  geom_tile(aes(fill = po)) +
  scale_fill_gradientn(colors = c("blue", "yellow", "red"),
                       breaks = seq(-35, 35, by = 5)) +
  theme(axis.ticks.length = unit(0.2, "cm")) +
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0)) +
  guides(fill = guide_colourbar(barheight = unit(8, "cm"),
                                title = element_blank())) +
  labs(title = "Temperatura do ponto de orvalho",
       subtitle = "Em relação a temperatura e umidade relativa do ar",
       caption = "Elaboração: Prof. Tiago Olivoto",
       x = "Temperatura do ar (ºC)",
       y = "Umidade relativa do ar (%)")
```

<img src="/tutorials/agrolimatologia/05_ponto_orvalho_files/figure-html/unnamed-chunk-4-1.png" width="672" />


