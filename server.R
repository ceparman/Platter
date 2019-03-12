



library(stringr)
library(CoreAPIV2)
source("R_Code/sourceDir.R")
sourceDir("R_Code/")



function(input, output,session) {
  addClass(selector = "body", class = "sidebar-collapse")
  storedData <- reactiveValues()   
  
  storedData$sample_types <- c("TREATMENT","BLANK")
  
 callModule(platesetup,"platesetup",parentInput=input,parentSession = session,storedData)
 callModule(samplequery,"samplequery",parentInput=input,parentSession = session,storedData)
  #callModule(plateeditor,"plateeditor",parentInput=input,parentSession = session,storedData)
  
  }