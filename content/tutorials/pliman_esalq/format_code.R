
idpedu::mergeRMDFiles(dir = "E:/Desktop/tiagoolivoto/content/tutorials/gemsr",
                      title = "Scripts R - GEMS-R: metan", 
                      files = list.files("E:/Desktop/tiagoolivoto/content/tutorials/gemsr",
                                         pattern = "*.Rmarkdown",
                                         full.names = TRUE)[-1], 
                      mergedFileName = "scripts_gemsr.Rmd")


knitr::purl("E:/Desktop/tiagoolivoto/content/tutorials/gemsr/scripts_gemsr.Rmd")

