library(shiny)
library(ggplot2)
library(dplyr)

#file connections that is also code for the server. plotting and data processing is separated to have better oversight. 
source("R/data_processing.R")
source("R/plotting.R")

shinyServer(function(input, output) {
  pokemon$capture_rate <- as.numeric(pokemon$capture_rate) # this code is used to mae the capture rate variable numerical. Also this causes the capture rate variable to be that selected variable for the scatterplot. That corresponds nicely with the rmd file that also gives insights in the capture rate
  pokemon[774, "capture_rate"] <- (30+255)/2

  #
  processed_data <- reactive({ 
    
    # the server code is put in to reactive which will allow the server code to internally update the code when changes are made. this makes it possible to make a dynamic plot. 
    data <- pokemon
    pokemon_filtered <- data %>% filter(generation %in% input$generation) # the initial code of pokemon with dubs in the rmd file was used for this code. 
    
    # the if else statements asses different possibilities.
    if (length(input$typeSelection) == 1 && input$typeSelection == "type2") { # when type 1 is selected and the user chooses to include type 2,  in pokemon filtered will pokemon of type 2 will be added. 
      pokemon_filtered <- pokemon_filtered %>% filter(!is.na(type2)) 
      pokemon_filtered$type1 <- pokemon_filtered$type2
    } else if (length(input$typeSelection) == 2) { # when type 2 is selected type 1 will change to type 2 and thus exclude type 1
      pokemon_filtered <- pokemon_filtered %>%
        filter(!is.na(type2)) %>%
        mutate(type1 = type2) %>%
        bind_rows(data)
    }
    
    sorted_pokemon <- process_pokemon_data(pokemon_filtered, input$sortOrder) # this code is used to sort pokemon on mean, median and maximum according to the code above
    
    return(sorted_pokemon)
  })
  
  
  # output is used to render the plot in the app
  output$violinPlot <- renderPlot({  
    plot_violin(processed_data())
  })
  
  output$scatterplot <- renderPlot({
    data <- processed_data()
    x_vars <- input$x_vars_scatter
    
    p <- ggplot(data, aes_string(x = x_vars, y = "base_total")) + # this is the code to use the scatterplot function in plotting.R
      geom_point()
    
    
    # these smooth lines are calculated for the x variable that is used
    if ("lin" %in% input$smooth_lines) {
      p <- p + geom_smooth(method = "lm", se = FALSE, color = "#EE8130")
    }
    if ("sq" %in% input$smooth_lines) {
      p <- p + geom_smooth(method = "lm", formula = y ~ poly(x, 2), se = FALSE, color = "#6390F0")
    }
    if ("cub" %in% input$smooth_lines) {
      p <- p + geom_smooth(method = "lm", formula = y ~ poly(x, 3), se = FALSE, color = "#7AC74C")
    }
    
    p
  })
  
  output$modelres <- renderTable({
    data <- processed_data()
    x_var <- input$x_vars_scatter
    
    models <- list(
      lin = lm(paste("base_total ~", x_var), data = data),
      sq = lm(paste("base_total ~", x_var, "+ I(", x_var, "^2)"), data = data),
      cub = lm(paste("base_total ~", x_var, "+ I(", x_var, "^2) + I(", x_var, "^3)"), data = data) # this is used to have a text from the models based on the input that is chosen. 
    )
    
    model_summaries <- lapply(models, summary)
    model_summaries <- Filter(function(x) x$adj.r.squared != 0, model_summaries) #This code is needed for the statistics under the scatterplot. adjusted r squared is calculated 
    
    result <- do.call(rbind, lapply(names(model_summaries), function(name) { # this code is also used for the statistics table to find out the name of the variable. 
      model <- model_summaries[[name]]
      data.frame(
        Model = name,
        R.squared = round(model$r.squared, 3),
        Adj.R.squared = round(model$adj.r.squared, 3),
        DF = model$df[2]
      )
    }))
    
    result
  })
  
  output$statout <- renderText({ # this is the output code for the statistics table. 
    data <- processed_data()
    x_vars <- input$x_vars_scatter
    
    models <- list(
      lin = lm(paste("base_total ~", x_vars, collapse = " + "), data = data),
      sq = lm(paste("base_total ~", paste("poly(", x_vars, ", 2)", collapse = " + ")), data = data),
      cub = lm(paste("base_total ~", paste("poly(", x_vars, ", 3)", collapse = " + ")), data = data)
    )
    
    model_summaries <- lapply(models, summary)
    best_model <- model_summaries[[which.max(sapply(model_summaries, function(x) x$adj.r.squared))]]
    best_model_name <- names(model_summaries)[which.max(sapply(model_summaries, function(x) x$adj.r.squared))]
    
    paste0("The best fitting model is: ", best_model_name, " with an Adjusted R-squared of: ", # this output will give the user the text that will inform the best fitting model and the specific r square. the fitting models are linear, squared and cubic. 
           round(best_model$adj.r.squared, 3), ", F(", best_model$fstatistic[2], ", ", 
           best_model$fstatistic[3], ") = ", round(best_model$fstatistic[1], 3), ".")
  })
  
  output$hover_info <- renderUI({ # this code is inspired by code found in stack overflow. This code makes it possible to connect information to a dot of a scatterplot when hovered over by the cursor.  https://stackoverflow.com/questions/76567653/add-hover-over-text-for-label-of-virtualselectinput-in-r-shiny-app
    hover <- input$plot_hover
    if (!is.null(hover)) {
      point <- nearPoints(processed_data(), hover, threshold = 5, maxpoints = 1)
      if (nrow(point) == 0) return(NULL)
      
      div(
        style = "position: absolute; z-index: 100; background-color: rgba(245, 245, 245, 0.85); padding: 10px; border-radius: 5px;",
        strong(point$name),
        tags$br(),
        "Weight: ", point$weight, "kg",
        tags$br(),
        "Height: ", point$height, "m",
        tags$br(),
        "Type 1: ", point$type1,
        tags$br(),
        "Type 2: ", ifelse(is.na(point$type2), "N/A", point$type2)
      )
    }
  })
})