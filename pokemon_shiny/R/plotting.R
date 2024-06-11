# this file contains the ggplot code that is used for the app. The plot_violin code that was made in the rmd file is adapted so that the plot will be dynamic for the user.
plot_violin <- function(data) {
  ggplot(data, aes(x = type1, y = base_total, fill = type1)) + # type 1 is used as categorical variable. this way the voilin plot splits on the type1 of pokemon. For furter explanation the rmd file can be checked. 
    geom_violin() +
    labs(
      title = "Violin plot of base total stats per type ordered by the mean base total of the pokemon for the type",
      x = "Type",  
      y = "Base Total",
      fill = "Type"
    ) +
    scale_fill_manual(values = colors) +
    theme_minimal() +
    theme(
      axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1),
      legend.position = "none"
    )
}

# this is new code that is made to create a simple scatterplot. A attempt is made to have multiple x axis inputs to have the user make models manually but this failed by an error that we where not able to fix. Warning: Error in switch: EXPR must be a length 1 vector. Because of this reason it was settled to use the predictor variables where only one predictor at the time is possible
plot_scatter <- function(data, x_vars) { 

  
  p <- ggplot(data, aes(y = base_total)) + # base_total is the dependent variable
    geom_point(aes_string(x = paste(x_vars, collapse = " + "))) + # the x variable is x_vars which will be a option for the user in the ui to choose all the numeric varibles. The "+ " was an attempt to make multiple x_var inputs
    theme_minimal() +
    labs(x = paste(x_vars, collapse = " + "), y = "Base Total", #This code is used for the text that the user will see
         title = paste("Scatterplot of", paste(x_vars, collapse = " and "), "vs Base Total")) #This code is for the title that will change acoording to the x_var input chosen by the user. 
  
}