---
toc: true
title: metan v1.6.0 on CRAN
authors:
- admin
date: '2020-05-21'
slug: metan-v1-6-0-on-cran
categories:
  - metan
tags: []
subtitle: ''
summary: 'Find out the changes made in the v1.6.0 of metan package'
lastmod: '2020-05-21T11:26:48-03:00'
featured: no
image:
  caption: ''
  focal_point: ''
  preview_only: no
projects: []
---




I'm so excited to announce that the latest version of the R package [`metan`](https://tiagoolivoto.github.io/metan/index.html) is now on [CRAN](https://cran.r-project.org/web/packages/metan/). This is a minor release (v1.6.0) that includes new features and some minor improvements.

## New functions
* `Smith_Hazel()` and `print.sh()` and `plot.sh()` for computing the Smith and Hazel selection index.


The Smith-Hazel index is computed with the function `Smith_Hazel()`. Users can compute the index either by declaring known genetic and phenotypic variance-covariance matrices or by using as inpute data, a model fitted with the function `gamem()`. In this case, the variance-covariance are extracted internally. The economic weights in the argument `weights` are set by default to 1 for all traits.













