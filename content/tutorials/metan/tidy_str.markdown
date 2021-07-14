+++
title = "Tidy up strings with the R package metan"
linktitle = "Tidy strings"
date = "2020/04/03"
toc = true  # Show table of contents? true/false
type = "docs"  # Do not modify.
[menu.metan]
    parent = "R package metan"
    weight = 5
+++




## Getting started

In this quick tip, I show you how to tidy character strings with the package [metan](https://tiagoolivoto.github.io/metan/). If the package is not yet installed, you can download it from [CRAN](https://cran.r-project.org/web/packages/metan/).
Install the released version of metan from [CRAN](https://CRAN.R-project.org/package=metan) with:


```r
install.packages("metan")

```

For the latest release notes on this development version, see the [NEWS file](https://tiagoolivoto.github.io/metan/news/index.html).

Then, load it with:

```r
library(metan)
```

`metan`'s function [`tidy_strings()`](https://tiagoolivoto.github.io/metan/reference/utils_num_str.html) can be used to tidy up characters strings by putting all word in upper case, replacing any space, tabulation, punctuation characters by `_` (underscore), and putting `_` between lower and upper case.

## A simple example
Suppose that we have a character string, say, `str = c("Env1", "env 1", "env.1")`. By definition `str` should represent a unique level in plant breeding trials, e.g., environment 1, but in fact it has three levels.

```r
str <- c("Env1", "env 1", "env.1")
levels(factor(str))
# [1] "env 1" "env.1" "Env1"
```
Bad idea!

We can use [`tidy_strings()`](https://tiagoolivoto.github.io/metan/reference/utils_num_str.html) to tidy up this string as follows:


```r
tidy_strings(str)
# [1] "ENV_1" "ENV_1" "ENV_1"
```
Great! We have now the unique level we should have before.

## More examples
All of the following will be translated into `"ENV_1"`.

```r
messy_env <- c("ENV 1", "Env   1", "Env1", "env1", "Env.1", "Env_1")
tidy_strings(messy_env)
# [1] "ENV_1" "ENV_1" "ENV_1" "ENV_1" "ENV_1" "ENV_1"
```
All of the following will be translated into `"GEN_*"`.

```r
messy_gen <- c("GEN1", "gen 2", "Gen.3", "gen-4", "Gen_5", "GEN_6")
tidy_strings(messy_gen)
# [1] "GEN_1" "GEN_2" "GEN_3" "GEN_4" "GEN_5" "GEN_6"
```

All of the following will be translated into `"ENV_GEN"`

```r
messy_int <- c("EnvGen", "Env_Gen", "env gen", "Env Gen", "ENV.GEN", "ENV_GEN")
tidy_strings(messy_int)
# [1] "ENV_GEN" "ENV_GEN" "ENV_GEN" "ENV_GEN" "ENV_GEN" "ENV_GEN"
```



## Tidy up a whole data frame
We can also tidy up strings of a whole data frame. By default the separator character is `_`. To change this default use the argument `sep`.

```r
library(tibble)
df <- tibble(Env = messy_env,
             gen = messy_gen,
             Env_Gen = interaction(Env, gen),
             y = rnorm(6, 300, 10))
df
# # A tibble: 6 x 4
#   Env     gen   Env_Gen           y
#   <chr>   <chr> <fct>         <dbl>
# 1 ENV 1   GEN1  ENV 1.GEN1     304.
# 2 Env   1 gen 2 Env   1.gen 2  308.
# 3 Env1    Gen.3 Env1.Gen.3     301.
# 4 env1    gen-4 env1.gen-4     295.
# 5 Env.1   Gen_5 Env.1.Gen_5    294.
# 6 Env_1   GEN_6 Env_1.GEN_6    303.
tidy_strings(df, sep = "")
# # A tibble: 6 x 4
#   Env   gen   Env_Gen      y
#   <chr> <chr> <chr>    <dbl>
# 1 ENV1  GEN1  ENV1GEN1  304.
# 2 ENV1  GEN2  ENV1GEN2  308.
# 3 ENV1  GEN3  ENV1GEN3  301.
# 4 ENV1  GEN4  ENV1GEN4  295.
# 5 ENV1  GEN5  ENV1GEN5  294.
# 6 ENV1  GEN6  ENV1GEN6  303.
```

To select variables to tidy up, simply type the variable name. Here, we also put all column names to upper case

```r
tidy_strings(df, Env) %>% 
  colnames_to_upper()
# # A tibble: 6 x 4
#   ENV   GEN   ENV_GEN           Y
#   <chr> <chr> <fct>         <dbl>
# 1 ENV_1 GEN1  ENV 1.GEN1     304.
# 2 ENV_1 gen 2 Env   1.gen 2  308.
# 3 ENV_1 Gen.3 Env1.Gen.3     301.
# 4 ENV_1 gen-4 env1.gen-4     295.
# 5 ENV_1 Gen_5 Env.1.Gen_5    294.
# 6 ENV_1 GEN_6 Env_1.GEN_6    303.
```
