+++
title = "Bar plots for one-way and two-way trials"
linktitle = "Bar plots"
date = "2020/04/16"
toc = true  # Show table of contents? true/false
type = "docs"  # Do not modify.
[menu.metan]
    parent = "R package metan"
    weight = 4
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
str(df)
# tibble [15 x 17] (S3: tbl_df/tbl/data.frame)
#  $ GEN : Factor w/ 13 levels "H1","H10","H11",..: 2 2 2 3 3 3 4 4 4 5 ...
#  $ REP : Factor w/ 3 levels "1","2","3": 1 2 3 1 2 3 1 2 3 1 ...
#  $ PH  : num [1:15] 1.79 2.05 2.27 1.71 2.09 ...
#  $ EH  : num [1:15] 0.888 1.032 1.114 0.808 1.06 ...
#  $ EP  : num [1:15] 0.514 0.504 0.491 0.489 0.509 ...
#  $ EL  : num [1:15] 13.9 13.6 14.5 15.5 12.2 ...
#  $ ED  : num [1:15] 44.1 43.9 43.7 45.2 46.9 ...
#  $ CL  : num [1:15] 26.2 23.5 24.6 25 26.5 ...
#  $ CD  : num [1:15] 15 14.4 16.1 16.7 14.3 ...
#  $ CW  : num [1:15] 12.9 11.5 12.5 15.2 13.5 ...
#  $ KW  : num [1:15] 116 118 128 140 114 ...
#  $ NR  : num [1:15] 14.8 16 15.2 15.6 16.8 16.4 16.4 17.6 14.8 18 ...
#  $ NKR : num [1:15] 33 32.4 34.6 36 26.2 35 32 31.4 25.4 30.8 ...
#  $ CDED: num [1:15] 0.596 0.535 0.566 0.552 0.566 ...
#  $ PERK: num [1:15] 89.8 91.1 90.7 90.3 89.3 ...
#  $ TKW : num [1:15] 258 233 251 264 288 ...
#  $ NKE : num [1:15] 446 496 524 535 397 ...

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

<img src="plots_files/figure-html/unnamed-chunk-1-1.png" width="672" style="display: block; margin: auto;" />


## Bar plots for two-way trials

In plant breeding, two-way trials are ver common. A classic two-way trial with qualitative treatments (genotypes and environments) will be used here to show how to create a bar plot for this kind of data with [`plot_factbars()`](https://tiagoolivoto.github.io/metan/reference/barplots.html).


```r
df_fat <- 
  data_ge2 %>% 
  subset(GEN %in% c("H9", "H10", "H11")) %>% 
  droplevels()
str(df_fat)
# tibble [36 x 18] (S3: tbl_df/tbl/data.frame)
#  $ ENV : Factor w/ 4 levels "A1","A2","A3",..: 1 1 1 1 1 1 1 1 1 2 ...
#  $ GEN : Factor w/ 3 levels "H10","H11","H9": 1 1 1 2 2 2 3 3 3 1 ...
#  $ REP : Factor w/ 3 levels "1","2","3": 1 2 3 1 2 3 1 2 3 1 ...
#  $ PH  : num [1:36] 2.83 2.79 2.72 2.75 2.72 ...
#  $ EH  : num [1:36] 1.64 1.71 1.51 1.51 1.56 ...
#  $ EP  : num [1:36] 0.581 0.616 0.554 0.549 0.573 ...
#  $ EL  : num [1:36] 16.7 14.9 16.7 17.4 16.7 ...
#  $ ED  : num [1:36] 54.1 52.7 52.7 51.7 47.2 ...
#  $ CL  : num [1:36] 31.7 32 30.4 30.6 28.7 ...
#  $ CD  : num [1:36] 17.4 15.5 17.5 18 17.2 ...
#  $ CW  : num [1:36] 26.2 20.7 26.8 26.2 24.1 ...
#  $ KW  : num [1:36] 194 176 207 217 181 ...
#  $ NR  : num [1:36] 15.6 17.6 16.8 16.8 13.6 15.2 14.4 14.4 16 15.2 ...
#  $ NKR : num [1:36] 32.8 28 32.8 34.6 34.4 34.8 31.2 34.4 31.4 30 ...
#  $ CDED: num [1:36] 0.586 0.607 0.577 0.594 0.608 ...
#  $ PERK: num [1:36] 87.9 89.7 88.5 89.1 88.3 ...
#  $ TKW : num [1:36] 374 347 394 377 361 ...
#  $ NKE : num [1:36] 519 502 525 575 501 ...

p1 <- plot_factbars(df_fat, ENV, GEN, resp = PH)
p2 <- plot_factbars(df_fat, ENV, GEN,
                    resp = PH,
                    palette = "Blues",
                    lab.bar = letters[1:12])
p1 + p2 + plot_annotation(tag_levels = "1", tag_prefix = "p")
```

<img src="plots_files/figure-html/unnamed-chunk-2-1.png" width="960" style="display: block; margin: auto;" />

