---
title: Radiação
linktitle: "3. Radiação"
toc: true
type: docs
date: "2021/07/09"
draft: false
code_download: true
menu:
  climato:
    parent: Agroclimatologia
    weight: 4
weight: 3

---

# Pacotes

```r
library(tidyverse)  # manipulação de dados
library(metan)
library(lubridate)    # gráfico de radar
library(rio)        # importação/exportação de dados

clima <- import("https://bit.ly/inmet_fred_2020")

# gerar tabelas html
print_tbl <- function(table, digits = 3, n = NULL, ...){
  if(!missing(n)){
    knitr::kable(head(table, n = n), booktabs = TRUE, digits = digits, ...)
  } else{
  knitr::kable(table, booktabs = TRUE, digits = digits, ...)
  }
}
```


# Radiação solar (média mensal)


```r
df_rad <- 
clima %>% 
  sum_by(DIA, MES) %>% 
  means_by(MES) %>% 
  select(MES, RADIAC)
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
ggplot(df_rad, aes(factor(MES), RADIAC, group = 1)) + 
  stat_summary(geom = "point", 
               fun = mean) +
  stat_summary(geom = "line") + 
  theme(panel.grid.minor = element_blank(),
        legend.position = "bottom",
        legend.title = element_blank(),
        axis.title = element_text(size = 12),
        axis.text = element_text(size = 12)) + 
  labs(title = "Radiação solar",
       subtitle = "Estação INMET - UFSM-FW",
       caption = "Elaboração - Olivoto 2021",
       x = "Mês do ano",
       y = expression(paste("Radiação solar em média da soma diária (KJ m"^-2~")")))
```

```
## No summary function supplied, defaulting to `mean_se()`
```

<img src="/tutorials/agrolimatologia/03_radiacao_files/figure-html/unnamed-chunk-2-1.png" width="672" />


# Radiação solar em dois dias


```r
#rad
df_rad <- 
  clima %>% 
  select(MES, HORA, RADIAC) %>% 
  subset(MES %in% c("6", "12")) %>% 
  mutate(Mês = ifelse(MES == "6", "Junho", "Dezembro"))


ggplot(df_rad, aes(HORA, RADIAC, color = factor(Mês), group = Mês)) + 
  stat_summary(geom = "point", 
               fun = mean) +
  stat_summary(geom = "line") + 
  stat_summary(geom = "errorbar", width = 0.5) +
  theme(panel.grid.minor = element_blank(),
        legend.position = "bottom",
        legend.title = element_blank(),
        axis.title = element_text(size = 12),
        axis.text = element_text(size = 12)) + 
  scale_x_continuous(breaks = seq(0,24, by = 2)) + 
  labs(title = "Radiação em dois meses do ano",
       subtitle = "Estação INMET - UFSM-FW",
       caption = "Elaboração - Olivoto 2021",
       x = "Hora do dia",
       y = expression(paste("Radiação média horária (KJ m"^-2~")")))
```

```
## Warning: Removed 665 rows containing non-finite values (stat_summary).

## Warning: Removed 665 rows containing non-finite values (stat_summary).
```

```
## No summary function supplied, defaulting to `mean_se()`
```

```
## Warning: Removed 665 rows containing non-finite values (stat_summary).
```

```
## No summary function supplied, defaulting to `mean_se()`
```

<img src="/tutorials/agrolimatologia/03_radiacao_files/figure-html/unnamed-chunk-3-1.png" width="672" />


