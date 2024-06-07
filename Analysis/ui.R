# library ----
library(shiny)
library(tidyverse)

# data prepping ----
# import Pokemon dataset
pokemon <- pokemon <- read_csv("data/pokemon_sort.csv")

# removing unused columns
pokemon <- select(pokemon, -c("japanese_name", "abilities", "classfication", 
                              "percentage_male"))

# put capture rate to correct class
pokemon$capture_rate <- as.numeric(pokemon$capture_rate)

# NA introduced to coercion, so searching for it and correcting it
item_count <- 1
for (item in pokemon$capture_rate) {
  if (is.na(item) == TRUE) {
    print(pokemon[item_count, ])
    item_count <- item_count + 1
  } else {
    item_count <- item_count + 1
  }
}

# minior has two forms that it switches to if it falls below 50% HP, so the new
# capture rate value will be the average of the two forms
pokemon[774, "capture_rate"] <- (30+255)/2

# add dummy variables for each type
all_values <- c("poison", "flying", "dark", "electric", "ice", "ground", "fairy", 
                "grass", "fighting", "psychic", "steel", "fire", "rock", "water", 
                "dragon", "ghost", "bug", "normal")

# Create new columns for each value and fill with 1 or 0 based on type1 and type2
for (val in all_values) {
  pokemon <- pokemon %>%
    mutate(!!val := as.numeric(type1 == val | type2 == val))
}

# search for NA's and see if they need to be replaced or not
column_list <- colnames(pokemon)
item_count <- 1
for (col in column_list) {
  if (sum(is.na(pokemon[item_count])) == 0) {
    item_count <- item_count + 1
  } else {
    cat(col, ":\n", sum(is.na(pokemon[item_count])), "\n")
    item_count <- item_count + 1
  }
}

# changing type2 NA's to be none, and adding pokemon to single_type dummy
pokemon$single_type <- 0
item_count <- 1
for (item in pokemon$type2) {
  if (is.na(item) == TRUE) {
    pokemon[item_count, "type2"] <- "none"
    pokemon[item_count, "single_type"] <- 1
    item_count <- item_count + 1
  } else {
    item_count <- item_count + 1
  }
}

# changing the NA's for height and weight to be filled with column mean
# Function to fill NaN values with column mean
fill_na_with_mean <- function(df, column) {
  df %>% 
    mutate(!!sym(column) := ifelse(is.na(!!sym(column)), mean(!!sym(column), 
                                                              na.rm = TRUE), 
                                   !!sym(column)))
}  

# Columns to fill NaN values
columns_to_fill <- c("height_m", "weight_kg")

# Fill NaN values for each specified column
for (col in columns_to_fill) {
  pokemon <- fill_na_with_mean(pokemon, col)
}


# UI definition ----
shinyServer(fluidPage(

    # Application title
    titlePanel("Pokemon Regression Analysis"),
    
    # description
    p("A Shiny app predicting the stats of different Pokemon in generations 1 to 7."),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
      sidebarPanel(
        
      ),

        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("regPlot")
        )
    )
))
