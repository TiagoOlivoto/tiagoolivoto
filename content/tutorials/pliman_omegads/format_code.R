format_rcode <- function(){
  path <- dirname(rstudioapi::getSourceEditorContext()$path)
  idpedu::mergeRMDFiles(dir = path,
                        title = "Scripts R - pliman", 
                        files = list.files(path,
                                           pattern = "*.Rmarkdown",
                                           full.names = TRUE)[-1], 
                        mergedFileName = "scripts_pliman_rmd.Rmd")
  knitr::purl(input = paste0(path, "/scripts_pliman_rmd.Rmd"),
              output = paste0(path, "/scripts_pliman_r.R"),
              documentation = 0)
}

format_rcode()
