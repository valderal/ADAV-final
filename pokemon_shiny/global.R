#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#


library(shiny)
library(ggplot2)
library(dplyr)
library(shinyWidgets)

source("R/data_processing.R")
source("R/plotting.R")
source("R/utils.R")

# Load data
pokemon <- read.csv("data/pokemon_sort.csv")  # Replace with actual data file path
colors <- c("normal" = "#A8A77A",
            "fire"= "#EE8130",
            "water"= "#6390F0",
            "electric"= "#F7D02C",
            "grass"= "#7AC74C",
            "ice"="#96D9D6",
            "fighting"= "#C22E28",
            "poison"= "#A33EA1",
            "ground"= "#E2BF65",
            "flying"= "#A98FF3",
            "psychic"= "#F95587",
            "bug"= "#A6B91A",
            "rock"= "#B6A136",
            "ghost"= "#735797",
            "dragon"= "#6F35FC",
            "dark"= "#705746",
            "steel"= "#B7B7CE",
            "fairy"= "#D685AD")