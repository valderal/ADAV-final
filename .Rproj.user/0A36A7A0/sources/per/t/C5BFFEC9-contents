#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(tidyverse)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  output$regPlot <- renderPlot({
    
    # models
    model.lin <- lm(base_total ~ capture_rate, data = pokemon)
    model.sq <- lm(base_total ~ capture_rate + I(capture_rate^2), data=pokemon)
    model.cub <- lm(base_total ~ capture_rate + I(capture_rate^2) + I(capture_rate^3), data=pokemon)
    
    # predicted vars
    x_pred <- seq(min(pokemon$capture_rate), 
                  max(pokemon$capture_rate), 
                  length.out = 300)
    y_pred.lin <- predict(model.lin, newdata = tibble(capture_rate = x_pred))
    y_pred.sq <- predict(model.sq, newdata = tibble(capture_rate = x_pred))
    y_pred.cub <- predict(model.cub, newdata = tibble(capture_rate = x_pred))
    
    # ggplot
    ggplot(data = pokemon,
           mapping = aes(x = capture_rate, y = base_total)) +
      geom_point() +
      geom_line(data = tibble(capture_rate = x_pred, base_total = y_pred.lin), col = "blue") +
      geom_line(data = tibble(capture_rate = x_pred, base_total = y_pred.sq), col = "red") +
      geom_line(data = tibble(capture_rate = x_pred, base_total = y_pred.cub), col = "green") +
      theme_minimal()
    
  })

})
