

# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#
library(shinydashboard)
library(shinyjs)
library(shiny)
library(shinyBS)
library(shinyjqui)
library(rhandsontable)
library(plotly)
library(shinycssloaders)
 

source("R_Code/sourceDir.R")

sourceDir("Modules/")
sourceDir("R_Code/")

ui <- dashboardPage(
  dashboardHeader(
    title = "Plater - PFS Pate Tool"),
    
  dashboardSidebar(
    sidebarMenu(
    id = "tabs",
    menuItem("Plate Setup ", tabName = "platesetup", icon = icon("address-card")),
    menuItem("Sample Query", tabName = "samplequery", icon = icon("address-card")) #,
  #  menuItem("Plate Editor", tabName = "plateeditor", icon = icon("address-card"))
  
  )),
  
  dashboardBody(
    tabItems(
    tabItem(tabName = "platesetup", platesetupUI("platesetup")),
    tabItem(tabName = "samplequery", samplequeryUI("samplequery")) #,
  #  tabItem(tabName = "plateeditor", plateeditorUI("plateeditor"))
            
    )
  )
)        