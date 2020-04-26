+++
title = "Bar plots for one-way and two-way trials"
linktitle = "Bar plots"
date = "2020/04/16"
toc = true  # Show table of contents? true/false
type = "docs"  # Do not modify.
[menu.example]
    parent = "Data Visualization"
    weight = 2
+++




## Getting started

In this quick tip, I'll show you how to create bar plots quicly using the R package `metan`'. To arrange the plots, in this post I'll use the wounderful R package [´patchwork`](https://patchwork.data-imaginist.com/)

## Bar plots for one-way trials

If we have a one-way trial with qualitative treatments (e.g., genotypes), we can create a bar plot with [`plot_bars()`](https://tiagoolivoto.github.io/metan/reference/barplots.html).


```r
library(metan)
library(patchwork)

df <- 
  data_g %>% 
  subset(GEN %in% c("H9", "H10", "H11", "H12", "H13"))

p1 <- 
  plot_bars(df, GEN, PH)

p2 <- 
  plot_bars(df, GEN, PH,
            errorbar = FALSE,
            y.expand = 0.2,
            n.dodge = 2,
            xlab = "Genotypes",
            ylab = "Plant Height",
            lab.bar = c("b", "b" , "ab", "a", "b"))

p3 <- 
  plot_bars(df, GEN, PH,
            stat.erbar = "ci",
            width.bar = 0.4,
            fill.bar = "black",
            invert = TRUE,
            plot_theme = theme_metan_minimal())


p3 / {( p1 + p2 + plot_layout(widths = c(1.5, 1)))} +
  plot_layout(heights = c(1, 2)) +
  plot_annotation(title = "Combined plots",
                  subtitle = "test",
                  tag_levels = "a",
                  tag_prefix = "(",
                  tag_suffix = ")")
```

<img src="/tutorials/metan/plots_files/figure-html/unnamed-chunk-1-1.png" width="672" style="display: block; margin: auto;" />


## Bar plots for one-way trials

In plant breeding, two-way trials are ver common. A classic two-way trial with qualitative treatments (genotypes and environments) will be used here to show how to create a bar plot for this kind of data [`plot_factbars()`](https://tiagoolivoto.github.io/metan/reference/barplots.html).
