library(shiny)
library(shinyWidgets)
library(ggplot2)
library(dplyr)

pokemon$capture_rate <- as.numeric(pokemon$capture_rate) # this code is used to mae the capture rate variable numerical. Also this causes the capture rate variable to be that selected variable for the scatterplot. That corresponds nicely with the rmd file that also gives insights in the capture rate
pokemon[774, "capture_rate"] <- (30+255)/2



numeric_pokemon <- pokemon[sapply(pokemon, is.numeric) & names(pokemon) != "base_total"] # This only selects the variables that are numerical which will make it possible to use as a predictor variable to predict base_total in a regression. 

shinyUI(fluidPage( # this is the start of the ui code. In this file the code is about the visuals and the functionalities for the user of the app. 
  

  titlePanel("Pokemon Base Stats Visualization"), # title for the user to read. 
  

  sidebarLayout( # the sidebar contains several dropdown buttons for the violin plot and other inputs for the scatterplot for the user to switch the visualization. 
    sidebarPanel(
      dropdownButton(
        radioButtons("sortOrder", "Sort Order:", # The radiobuttons will give the user the possibility to choose how to order the violin plot. radiobuttons are usefull when only one can be selected. 
                     choices = c("Mean Base Total", "Max Base Total to Min", "Median Base Total"), # These placeholders correlate with the data_processing.R code
                     selected = "Mean Base Total"),
        
        #this code is used to make a button for sortorder. the button will contain a label and also a icon. 
        label = "Select Sort Order",
        circle = FALSE,
        status = "primary",
        icon = icon("sort"),
        width = "300px"
      ),
      dropdownButton( # this input makes it possible to filter by generation.
        checkboxGroupInput("generation", "Select Generation:", # the checkboxGroupinput makes it possible to make multiple selections. As default all the generations are selected. 
                           choices = 1:7, selected = 1:7),
        #this code is used to make the botton for the user to click on. Timeline is used as icon for generations
        label = "Select Generations", 
        circle = FALSE,
        status = "primary",
        icon = icon("timeline"),
        width = "300px"
      ),
      # this input makes it possible for the user to choose the type. Type 1 is the default. checkboxgroupinput makes it possible to make multiple selections. The user can also choose type 2. 
      dropdownButton(
        checkboxGroupInput("typeSelection", "Type Selection:",
                           choices = c("Type 1" = "type1", "Type 2" = "type2"),
                           selected = c("type1")),
        label = "Select Main and/or Secondary Type",
        circle = FALSE,
        status = "primary",
        icon = icon("bolt"),
        width = "300px"
      ),
      
      # this code is used for the user input for the scatterplot. The user can select the x input with select input. The user can also choose the smooth lines that will be shown related to he table that will be shown under the plot. 
      
      selectInput("x_vars_scatter", "Select X-axis Variables for Scatterplot:",
                  choices = names(numeric_pokemon), selected = "capture_rate"),
      checkboxGroupInput("smooth_lines", "Select Smooth Lines for scatterplot:",
                         choices = c("Linear" = "lin", "Quadratic" = "sq", "Cubic" = "cub"),
                         selected = c("lin", "sq", "cub"))
    ),
    
   
    mainPanel(
      
      # in the mainpanel the ggplots are shown but putting them under each other would be to much information for the user all at once. so this is why it is chosen to use tabs. Tabsetpanel and tabpanel where used to make this possible. 
      tabsetPanel(
        tabPanel("Violin Plot",
                 plotOutput("violinPlot"),
                 dropdown(
                   label = "Explanation",
                   
                   # this shows an explanation text within a dropdown about the plot that is shown. 
                   tags$div(
                     p("The violin plot shows the base total statistic per type for pokemon. Every type has a separate voilin plot which makes it possible to compare the base total statistic among types. This can be used well in cooperation with the scatterplot.  The types can be sorted from high to low mean base total. Median and maximum to minimum can also be used as sorting option. Another option is to filter the pokemon by generations for the violin plot. As the last option for the violin plot there is a choice for selecting only the main type, or also include the secondary type. This makes it possible for the user to analyse the distribution of pokemon categorized by type in different ways.")
                   )
                 )
        ),
        tabPanel("Scatterplot",
                 plotOutput("scatterplot", hover = hoverOpts(id = "plot_hover")), #hoveropts is needed to know the location where the cursor needs to hover for information. We used it for the scatterplot. 
                 tabPanel("Statistical Analysis", 
                          h4("Statistical Analysis"), 
                          tableOutput("modelres") # modelres is a placeholder that will be used to gather the statistical information for the table under the scatterplot
                 ),
                 tabPanel(
                   h4("Explanation for Scatterplot"),
                   dropdown(
                     label = "Explanation",
                     tags$div(
                       p("The scatterplot shows the relationship between the selected X-axis variable chosen by the user and the base total statistic. In the side panel the user can choose different variables and include multiple lines. The lines that can be chosen are linear, quadratic and cubic regression. The last interactive element of the scatterplot is that when the cursor is hovering over a dot it will show a statistic of the pokemon what the dot is about. in the apearing textbox it will show the pokemon name, height, weight and the types for the pokemon. The statistical analysis table shows which regression line will be the best fit for the x variable as a predictor for base total as y variable.")
                     )
                   ))
        )
      )
    )
  ),
  
  uiOutput("hover_info") # uiOutput is used to show the output of the cursor hovering over a dot. the tab panel is chosen for the output location. 
))