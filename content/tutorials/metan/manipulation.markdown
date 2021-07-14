+++
title = "Data manipulation in R with metan"
linktitle = "Manipulation"
date = "2020/04/03"
toc = true  # Show table of contents? true/false
type = "docs"  # Do not modify.
[menu.metan]
    parent = "R package metan"
    weight = 3
+++




## Utilities for rows and columns
### Add columns and rows
The functions `add_cols()` and `add_rows()` can be used to add columns and rows, respectively to a data frame.


```r
library(metan)
add_cols(data_ge,
         ROW_ID = 1:420)
# # A tibble: 420 x 6
#    ENV   GEN   REP      GY    HM ROW_ID
#    <fct> <fct> <fct> <dbl> <dbl>  <int>
#  1 E1    G1    1      2.17  44.9      1
#  2 E1    G1    2      2.50  46.9      2
#  3 E1    G1    3      2.43  47.8      3
#  4 E1    G2    1      3.21  45.2      4
#  5 E1    G2    2      2.93  45.3      5
#  6 E1    G2    3      2.56  45.5      6
#  7 E1    G3    1      2.77  46.7      7
#  8 E1    G3    2      3.62  43.2      8
#  9 E1    G3    3      2.28  47.8      9
# 10 E1    G4    1      2.36  47.9     10
# # ... with 410 more rows
```

It is also possible to add a column based on existing data. Note that the arguments `.after` and `.before` are used to select the position of the new column(s). This is particularly useful to put variables of the same category together.


```r
add_cols(data_ge,
         GY2 = GY^2,
         .after = "GY")
# # A tibble: 420 x 6
#    ENV   GEN   REP      GY   GY2    HM
#    <fct> <fct> <fct> <dbl> <dbl> <dbl>
#  1 E1    G1    1      2.17  4.70  44.9
#  2 E1    G1    2      2.50  6.27  46.9
#  3 E1    G1    3      2.43  5.89  47.8
#  4 E1    G2    1      3.21 10.3   45.2
#  5 E1    G2    2      2.93  8.60  45.3
#  6 E1    G2    3      2.56  6.58  45.5
#  7 E1    G3    1      2.77  7.67  46.7
#  8 E1    G3    2      3.62 13.1   43.2
#  9 E1    G3    3      2.28  5.18  47.8
# 10 E1    G4    1      2.36  5.57  47.9
# # ... with 410 more rows
```

### Select or remove columns and rows
The functions `select_cols()` and `select_rows()` can be used to select columns and rows, respectively from a data frame.


```r
select_cols(data_ge2, ENV, GEN)
# # A tibble: 156 x 2
#    ENV   GEN  
#    <fct> <fct>
#  1 A1    H1   
#  2 A1    H1   
#  3 A1    H1   
#  4 A1    H10  
#  5 A1    H10  
#  6 A1    H10  
#  7 A1    H11  
#  8 A1    H11  
#  9 A1    H11  
# 10 A1    H12  
# # ... with 146 more rows
select_rows(data_ge2, 1:3)
# # A tibble: 3 x 18
#   ENV   GEN   REP      PH    EH    EP    EL    ED    CL    CD    CW    KW    NR
#   <fct> <fct> <fct> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
# 1 A1    H1    1      2.61  1.71 0.658  16.1  52.2  28.1  16.3  25.1  217.  15.6
# 2 A1    H1    2      2.87  1.76 0.628  14.2  50.3  27.6  14.5  21.4  184.  16  
# 3 A1    H1    3      2.68  1.58 0.591  16.0  50.7  28.4  16.4  24.0  208.  17.2
# # ... with 5 more variables: NKR <dbl>, CDED <dbl>, PERK <dbl>, TKW <dbl>,
# #   NKE <dbl>
```

Numeric columns can be selected quickly by using the function `select_numeric_cols()`. Non-numeric columns are selected with `select_non_numeric_cols()`


```r
select_numeric_cols(data_ge2)
# # A tibble: 156 x 15
#       PH    EH    EP    EL    ED    CL    CD    CW    KW    NR   NKR  CDED  PERK
#    <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
#  1  2.61  1.71 0.658  16.1  52.2  28.1  16.3  25.1  217.  15.6  36.6 0.538  89.6
#  2  2.87  1.76 0.628  14.2  50.3  27.6  14.5  21.4  184.  16    31.4 0.551  89.5
#  3  2.68  1.58 0.591  16.0  50.7  28.4  16.4  24.0  208.  17.2  31.8 0.561  89.7
#  4  2.83  1.64 0.581  16.7  54.1  31.7  17.4  26.2  194.  15.6  32.8 0.586  87.9
#  5  2.79  1.71 0.616  14.9  52.7  32.0  15.5  20.7  176.  17.6  28   0.607  89.7
#  6  2.72  1.51 0.554  16.7  52.7  30.4  17.5  26.8  207.  16.8  32.8 0.577  88.5
#  7  2.75  1.51 0.549  17.4  51.7  30.6  18.0  26.2  217.  16.8  34.6 0.594  89.1
#  8  2.72  1.56 0.573  16.7  47.2  28.7  17.2  24.1  181.  13.6  34.4 0.608  88.3
#  9  2.77  1.67 0.600  15.8  47.9  27.6  16.4  20.5  166.  15.2  34.8 0.576  89.0
# 10  2.73  1.54 0.563  14.9  47.5  28.2  15.5  20.1  161.  14.8  31.6 0.597  88.7
# # ... with 146 more rows, and 2 more variables: TKW <dbl>, NKE <dbl>
select_non_numeric_cols(data_ge2)
# # A tibble: 156 x 3
#    ENV   GEN   REP  
#    <fct> <fct> <fct>
#  1 A1    H1    1    
#  2 A1    H1    2    
#  3 A1    H1    3    
#  4 A1    H10   1    
#  5 A1    H10   2    
#  6 A1    H10   3    
#  7 A1    H11   1    
#  8 A1    H11   2    
#  9 A1    H11   3    
# 10 A1    H12   1    
# # ... with 146 more rows
```

We can select the first or last columns quickly with `select_first_col()` and `select_last_col()`, respectively.


```r
select_first_col(data_ge2)
# # A tibble: 156 x 1
#    ENV  
#    <fct>
#  1 A1   
#  2 A1   
#  3 A1   
#  4 A1   
#  5 A1   
#  6 A1   
#  7 A1   
#  8 A1   
#  9 A1   
# 10 A1   
# # ... with 146 more rows
select_last_col(data_ge2)
# # A tibble: 156 x 1
#      NKE
#    <dbl>
#  1  521.
#  2  494.
#  3  565.
#  4  519.
#  5  502.
#  6  525.
#  7  575 
#  8  501.
#  9  513.
# 10  480.
# # ... with 146 more rows
```


To remove columns or rows, use `remove_cols()` and `remove_rows()`.

```r
remove_cols(data_ge2, ENV, GEN)
# # A tibble: 156 x 16
#    REP      PH    EH    EP    EL    ED    CL    CD    CW    KW    NR   NKR  CDED
#    <fct> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
#  1 1      2.61  1.71 0.658  16.1  52.2  28.1  16.3  25.1  217.  15.6  36.6 0.538
#  2 2      2.87  1.76 0.628  14.2  50.3  27.6  14.5  21.4  184.  16    31.4 0.551
#  3 3      2.68  1.58 0.591  16.0  50.7  28.4  16.4  24.0  208.  17.2  31.8 0.561
#  4 1      2.83  1.64 0.581  16.7  54.1  31.7  17.4  26.2  194.  15.6  32.8 0.586
#  5 2      2.79  1.71 0.616  14.9  52.7  32.0  15.5  20.7  176.  17.6  28   0.607
#  6 3      2.72  1.51 0.554  16.7  52.7  30.4  17.5  26.8  207.  16.8  32.8 0.577
#  7 1      2.75  1.51 0.549  17.4  51.7  30.6  18.0  26.2  217.  16.8  34.6 0.594
#  8 2      2.72  1.56 0.573  16.7  47.2  28.7  17.2  24.1  181.  13.6  34.4 0.608
#  9 3      2.77  1.67 0.600  15.8  47.9  27.6  16.4  20.5  166.  15.2  34.8 0.576
# 10 1      2.73  1.54 0.563  14.9  47.5  28.2  15.5  20.1  161.  14.8  31.6 0.597
# # ... with 146 more rows, and 3 more variables: PERK <dbl>, TKW <dbl>,
# #   NKE <dbl>
remove_rows(data_ge2, 1:2, 5:8)
# # A tibble: 150 x 18
#    ENV   GEN   REP      PH    EH    EP    EL    ED    CL    CD    CW    KW    NR
#    <fct> <fct> <fct> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
#  1 A1    H1    3      2.68  1.58 0.591  16.0  50.7  28.4  16.4  24.0  208.  17.2
#  2 A1    H10   1      2.83  1.64 0.581  16.7  54.1  31.7  17.4  26.2  194.  15.6
#  3 A1    H11   3      2.77  1.67 0.600  15.8  47.9  27.6  16.4  20.5  166.  15.2
#  4 A1    H12   1      2.73  1.54 0.563  14.9  47.5  28.2  15.5  20.1  161.  14.8
#  5 A1    H12   2      2.56  1.56 0.616  15.7  49.9  29.9  16.2  24.0  188.  17.2
#  6 A1    H12   3      2.79  1.53 0.546  15.0  52.7  31.4  15.2  32.9  193.  20  
#  7 A1    H13   1      2.74  1.60 0.586  14.6  54.0  32.5  15.1  31.5  205.  20  
#  8 A1    H13   2      2.64  1.37 0.517  14.8  53.7  31.0  15.5  31.1  239.  20.4
#  9 A1    H13   3      2.93  1.77 0.602  14.9  52.7  30.1  15.8  31.3  212.  15.6
# 10 A1    H2    1      2.55  1.22 0.481  15.1  51.7  27.7  15.3  23.7  198.  16.4
# # ... with 140 more rows, and 5 more variables: NKR <dbl>, CDED <dbl>,
# #   PERK <dbl>, TKW <dbl>, NKE <dbl>
```


### Concatenating columns
The function `concatetate()` can be used to concatenate multiple columns of a data frame. It return a data frame with all the original columns in `.data` plus the concatenated variable, after the last column (by default), or at any position when using the arguments `.before` or `.after`.



```r
concatenate(data_ge, ENV, GEN, REP, .after = "REP")
# # A tibble: 420 x 6
#    ENV   GEN   REP   new_var    GY    HM
#    <fct> <fct> <fct> <chr>   <dbl> <dbl>
#  1 E1    G1    1     E1_G1_1  2.17  44.9
#  2 E1    G1    2     E1_G1_2  2.50  46.9
#  3 E1    G1    3     E1_G1_3  2.43  47.8
#  4 E1    G2    1     E1_G2_1  3.21  45.2
#  5 E1    G2    2     E1_G2_2  2.93  45.3
#  6 E1    G2    3     E1_G2_3  2.56  45.5
#  7 E1    G3    1     E1_G3_1  2.77  46.7
#  8 E1    G3    2     E1_G3_2  3.62  43.2
#  9 E1    G3    3     E1_G3_3  2.28  47.8
# 10 E1    G4    1     E1_G4_1  2.36  47.9
# # ... with 410 more rows
```

To drop the existing variables and keep only the concatenated column, use the argument `drop = TRUE`. To use `concatenate()` within a given function like `add_cols()` use the argument `pull = TRUE` to pull out the results to a vector.

```r
concatenate(data_ge, ENV, GEN, REP, drop = TRUE) %>% head()
# # A tibble: 6 x 1
#   new_var
#   <chr>  
# 1 E1_G1_1
# 2 E1_G1_2
# 3 E1_G1_3
# 4 E1_G2_1
# 5 E1_G2_2
# 6 E1_G2_3
concatenate(data_ge, ENV, GEN, REP, pull = TRUE) %>% head()
# [1] "E1_G1_1" "E1_G1_2" "E1_G1_3" "E1_G2_1" "E1_G2_2" "E1_G2_3"
```


To check if a column exists in a data frame, use `column_exists()`


```r
column_exists(data_ge, "ENV")
# [1] TRUE
```

### Getting levels
To get the levels and the size of the levels of a factor, the functions `get_levels()` and `get_level_size()` can be used.


```r
get_levels(data_ge, ENV)
#  [1] "E1"  "E10" "E11" "E12" "E13" "E14" "E2"  "E3"  "E4"  "E5"  "E6"  "E7" 
# [13] "E8"  "E9"
get_level_size(data_ge, ENV)
#  E1 E10 E11 E12 E13 E14  E2  E3  E4  E5  E6  E7  E8  E9 
#  30  30  30  30  30  30  30  30  30  30  30  30  30  30
```


## Utilities for numbers and strings
### Rounding whole data frames
The function `round_cols()`round a selected column or a whole data frame to the specified number of decimal places (default 0). If no variables are informed, then all numeric variables are rounded.


```r
round_cols(data_ge2)
# # A tibble: 156 x 18
#    ENV   GEN   REP      PH    EH    EP    EL    ED    CL    CD    CW    KW    NR
#    <fct> <fct> <fct> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
#  1 A1    H1    1      2.61  1.71 0.66   16.1  52.2  28.1  16.3  25.1  217.  15.6
#  2 A1    H1    2      2.87  1.76 0.63   14.2  50.3  27.6  14.5  21.4  184.  16  
#  3 A1    H1    3      2.68  1.58 0.59   16.0  50.7  28.4  16.4  24.0  208.  17.2
#  4 A1    H10   1      2.83  1.64 0.580  16.7  54.0  31.7  17.4  26.2  194.  15.6
#  5 A1    H10   2      2.79  1.71 0.62   14.9  52.7  32.0  15.5  20.7  176.  17.6
#  6 A1    H10   3      2.72  1.51 0.55   16.7  52.7  30.4  17.5  26.8  207.  16.8
#  7 A1    H11   1      2.75  1.51 0.55   17.4  51.7  30.6  18.0  26.2  217.  16.8
#  8 A1    H11   2      2.72  1.56 0.570  16.7  47.2  28.7  17.2  24.1  181.  13.6
#  9 A1    H11   3      2.77  1.67 0.6    15.8  47.9  27.6  16.4  20.5  166.  15.2
# 10 A1    H12   1      2.73  1.54 0.56   14.9  47.5  28.2  15.5  20.1  161.  14.8
# # ... with 146 more rows, and 5 more variables: NKR <dbl>, CDED <dbl>,
# #   PERK <dbl>, TKW <dbl>, NKE <dbl>
```

Alternatively, select variables to round.

```r
round_cols(data_ge2, PH, EP, digits = 1)
# # A tibble: 156 x 18
#    ENV   GEN   REP      PH    EH    EP    EL    ED    CL    CD    CW    KW    NR
#    <fct> <fct> <fct> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
#  1 A1    H1    1       2.6  1.71   0.7  16.1  52.2  28.1  16.3  25.1  217.  15.6
#  2 A1    H1    2       2.9  1.76   0.6  14.2  50.3  27.6  14.5  21.4  184.  16  
#  3 A1    H1    3       2.7  1.58   0.6  16.0  50.7  28.4  16.4  24.0  208.  17.2
#  4 A1    H10   1       2.8  1.64   0.6  16.7  54.1  31.7  17.4  26.2  194.  15.6
#  5 A1    H10   2       2.8  1.71   0.6  14.9  52.7  32.0  15.5  20.7  176.  17.6
#  6 A1    H10   3       2.7  1.51   0.6  16.7  52.7  30.4  17.5  26.8  207.  16.8
#  7 A1    H11   1       2.8  1.51   0.5  17.4  51.7  30.6  18.0  26.2  217.  16.8
#  8 A1    H11   2       2.7  1.56   0.6  16.7  47.2  28.7  17.2  24.1  181.  13.6
#  9 A1    H11   3       2.8  1.67   0.6  15.8  47.9  27.6  16.4  20.5  166.  15.2
# 10 A1    H12   1       2.7  1.54   0.6  14.9  47.5  28.2  15.5  20.1  161.  14.8
# # ... with 146 more rows, and 5 more variables: NKR <dbl>, CDED <dbl>,
# #   PERK <dbl>, TKW <dbl>, NKE <dbl>
```

### Extracting and replacing numbers

The functions `extract_number()`, and `replace_number()` can be used to extract or replace numbers. As an example, we will extract the number of each genotype in `data_g`. By default, the extracted numbers are put as a new variable called `new_var` after the last column of the data.


```r
extract_number(data_ge, GEN, .after = "GEN")
# # A tibble: 420 x 6
#    ENV   GEN   new_var REP      GY    HM
#    <fct> <fct>   <dbl> <fct> <dbl> <dbl>
#  1 E1    G1          1 1      2.17  44.9
#  2 E1    G1          1 2      2.50  46.9
#  3 E1    G1          1 3      2.43  47.8
#  4 E1    G2          2 1      3.21  45.2
#  5 E1    G2          2 2      2.93  45.3
#  6 E1    G2          2 3      2.56  45.5
#  7 E1    G3          3 1      2.77  46.7
#  8 E1    G3          3 2      3.62  43.2
#  9 E1    G3          3 3      2.28  47.8
# 10 E1    G4          4 1      2.36  47.9
# # ... with 410 more rows
```

If the argument `drop` is set to `TRUE` then, only the new variable is kept and all others are dropped.


```r
extract_number(data_ge, GEN, drop = TRUE)
# # A tibble: 420 x 1
#    new_var
#      <dbl>
#  1       1
#  2       1
#  3       1
#  4       2
#  5       2
#  6       2
#  7       3
#  8       3
#  9       3
# 10       4
# # ... with 410 more rows
```

To pull out the results into a vector, use the argument `pull = TRUE`. This is particularly useful when `extract_*` or `replace_*` are used within a function like `add_cols()`.



```r
extract_number(data_ge, GEN, pull = TRUE)
#   [1]  1  1  1  2  2  2  3  3  3  4  4  4  5  5  5  6  6  6  7  7  7  8  8  8  9
#  [26]  9  9 10 10 10  1  1  1  2  2  2  3  3  3  4  4  4  5  5  5  6  6  6  7  7
#  [51]  7  8  8  8  9  9  9 10 10 10  1  1  1  2  2  2  3  3  3  4  4  4  5  5  5
#  [76]  6  6  6  7  7  7  8  8  8  9  9  9 10 10 10  1  1  1  2  2  2  3  3  3  4
# [101]  4  4  5  5  5  6  6  6  7  7  7  8  8  8  9  9  9 10 10 10  1  1  1  2  2
# [126]  2  3  3  3  4  4  4  5  5  5  6  6  6  7  7  7  8  8  8  9  9  9 10 10 10
# [151]  1  1  1  2  2  2  3  3  3  4  4  4  5  5  5  6  6  6  7  7  7  8  8  8  9
# [176]  9  9 10 10 10  1  1  1  2  2  2  3  3  3  4  4  4  5  5  5  6  6  6  7  7
# [201]  7  8  8  8  9  9  9 10 10 10  1  1  1  2  2  2  3  3  3  4  4  4  5  5  5
# [226]  6  6  6  7  7  7  8  8  8  9  9  9 10 10 10  1  1  1  2  2  2  3  3  3  4
# [251]  4  4  5  5  5  6  6  6  7  7  7  8  8  8  9  9  9 10 10 10  1  1  1  2  2
# [276]  2  3  3  3  4  4  4  5  5  5  6  6  6  7  7  7  8  8  8  9  9  9 10 10 10
# [301]  1  1  1  2  2  2  3  3  3  4  4  4  5  5  5  6  6  6  7  7  7  8  8  8  9
# [326]  9  9 10 10 10  1  1  1  2  2  2  3  3  3  4  4  4  5  5  5  6  6  6  7  7
# [351]  7  8  8  8  9  9  9 10 10 10  1  1  1  2  2  2  3  3  3  4  4  4  5  5  5
# [376]  6  6  6  7  7  7  8  8  8  9  9  9 10 10 10  1  1  1  2  2  2  3  3  3  4
# [401]  4  4  5  5  5  6  6  6  7  7  7  8  8  8  9  9  9 10 10 10
```

To replace numbers of a given column with a specified replacement, use `replace_number()`. By default, numbers are replaced with "". The argument `drop` and `pull` can also be used, as shown above.


```r
replace_number(data_ge, GEN)
# # A tibble: 420 x 6
#    ENV   GEN   REP      GY    HM new_var
#    <fct> <fct> <fct> <dbl> <dbl> <chr>  
#  1 E1    G1    1      2.17  44.9 G      
#  2 E1    G1    2      2.50  46.9 G      
#  3 E1    G1    3      2.43  47.8 G      
#  4 E1    G2    1      3.21  45.2 G      
#  5 E1    G2    2      2.93  45.3 G      
#  6 E1    G2    3      2.56  45.5 G      
#  7 E1    G3    1      2.77  46.7 G      
#  8 E1    G3    2      3.62  43.2 G      
#  9 E1    G3    3      2.28  47.8 G      
# 10 E1    G4    1      2.36  47.9 G      
# # ... with 410 more rows
replace_number(data_ge,
               var = REP,
               pattern = "1",
               replacement = "Rep_1",
               new_var = R_ONE,
               .after = "REP")
# # A tibble: 420 x 6
#    ENV   GEN   REP   R_ONE    GY    HM
#    <fct> <fct> <fct> <chr> <dbl> <dbl>
#  1 E1    G1    1     Rep_1  2.17  44.9
#  2 E1    G1    2     2      2.50  46.9
#  3 E1    G1    3     3      2.43  47.8
#  4 E1    G2    1     Rep_1  3.21  45.2
#  5 E1    G2    2     2      2.93  45.3
#  6 E1    G2    3     3      2.56  45.5
#  7 E1    G3    1     Rep_1  2.77  46.7
#  8 E1    G3    2     2      3.62  43.2
#  9 E1    G3    3     3      2.28  47.8
# 10 E1    G4    1     Rep_1  2.36  47.9
# # ... with 410 more rows
```

### Extracting, replacing, and removing strings
The functions `extract_string()`, and `replace_string()` are used in the same context of `extract_number()`, and `replace_number()`, but for handling with strings.


```r
extract_string(data_ge, GEN)
# # A tibble: 420 x 6
#    ENV   GEN   REP      GY    HM new_var
#    <fct> <fct> <fct> <dbl> <dbl> <chr>  
#  1 E1    G1    1      2.17  44.9 G      
#  2 E1    G1    2      2.50  46.9 G      
#  3 E1    G1    3      2.43  47.8 G      
#  4 E1    G2    1      3.21  45.2 G      
#  5 E1    G2    2      2.93  45.3 G      
#  6 E1    G2    3      2.56  45.5 G      
#  7 E1    G3    1      2.77  46.7 G      
#  8 E1    G3    2      3.62  43.2 G      
#  9 E1    G3    3      2.28  47.8 G      
# 10 E1    G4    1      2.36  47.9 G      
# # ... with 410 more rows
```

To replace strings, we can use the function `replace_strings()`.

```r
replace_string(data_ge,
               var = GEN,
               new_var = GENOTYPE,
               replacement = "GENOTYPE_",
               .after = "GEN")
# # A tibble: 420 x 6
#    ENV   GEN   GENOTYPE   REP      GY    HM
#    <fct> <fct> <chr>      <fct> <dbl> <dbl>
#  1 E1    G1    GENOTYPE_1 1      2.17  44.9
#  2 E1    G1    GENOTYPE_1 2      2.50  46.9
#  3 E1    G1    GENOTYPE_1 3      2.43  47.8
#  4 E1    G2    GENOTYPE_2 1      3.21  45.2
#  5 E1    G2    GENOTYPE_2 2      2.93  45.3
#  6 E1    G2    GENOTYPE_2 3      2.56  45.5
#  7 E1    G3    GENOTYPE_3 1      2.77  46.7
#  8 E1    G3    GENOTYPE_3 2      3.62  43.2
#  9 E1    G3    GENOTYPE_3 3      2.28  47.8
# 10 E1    G4    GENOTYPE_4 1      2.36  47.9
# # ... with 410 more rows
```

To remove all strings of a data frame, use `remove_strings()`.

```r
remove_strings(data_ge)
# # A tibble: 420 x 5
#      ENV   GEN   REP    GY    HM
#    <dbl> <dbl> <dbl> <dbl> <dbl>
#  1     1     1     1  2.17  44.9
#  2     1     1     2  2.50  46.9
#  3     1     1     3  2.43  47.8
#  4     1     2     1  3.21  45.2
#  5     1     2     2  2.93  45.3
#  6     1     2     3  2.56  45.5
#  7     1     3     1  2.77  46.7
#  8     1     3     2  3.62  43.2
#  9     1     3     3  2.28  47.8
# 10     1     4     1  2.36  47.9
# # ... with 410 more rows
```
