
idpedu::mergeRMDFiles(dir = "E:/Desktop/tiagoolivoto/content/tutorials/pliman_esalq",
                      title = "Scripts R - pliman", 
                      files = list.files("E:/Desktop/tiagoolivoto/content/tutorials/pliman_esalq",
                                         pattern = "*.Rmarkdown",
                                         full.names = TRUE)[-1], 
                      mergedFileName = "scripts_pliman.Rmd")


knitr::purl("E:/Desktop/tiagoolivoto/content/tutorials/pliman_esalq/scripts_pliman.Rmd")

