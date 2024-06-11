# The code is separated in several .R files. This was a option that you can choose when you start your project. The mapping structure is as follows: app.R, global.R, ui.R, server.R. in a Separate map called R there are two other r files:  data_processing.R, plotting.R each of the files are connected with the r code source().

#These libraries are used for the whole file 
library(shiny)
library(ggplot2)
library(dplyr)

#This is needed to connect the files with each other that the connection will be right
source("global.R") 
source("ui.R")
source("server.R")

shinyApp(ui = ui, server = server)
