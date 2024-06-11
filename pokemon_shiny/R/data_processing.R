# In this file the code that is used in the Rmd file is used to data process the pokemon code to be able to show the main type and the secondary type within the violin plot. The processing that is needed for that is shown below. 
process_pokemon_data <- function(pokemon, sortOrder) { # it is made into a function which will allow to have a variable as input. in this situation the sortOrder will be integrated in the function. This makes it possible to sort the pokemon type by type. 
  
  if ("type2" %in% colnames(pokemon)) {
    pokemon_with_type2 <- pokemon %>%
      filter(!is.na(type2))
    
    pokemon_with_dups <- pokemon_with_type2 %>%
      mutate(type1 = type2) %>%
      bind_rows(pokemon_with_type2)
    
    pokemon_with_dups <- bind_rows(pokemon, pokemon_with_dups) 
  } else {
    pokemon_with_dups <- pokemon
  }# explanation for this code can be found in the rmd file
  
  # a if else structure is used to choose different ways of ordering the pokemon. pokemon with dups is used because it contains both type 1 and type 2. this way sorting based on mean, median and min max will be possible
  if (sortOrder == "Mean Base Total") { 
    pokemon_with_dups$type1 <- factor(pokemon_with_dups$type1, 
                                      levels = names(sort(tapply(pokemon_with_dups$base_total, 
                                                                 pokemon_with_dups$type1, mean), 
                                                          decreasing = TRUE)))
  } else if (sortOrder == "Max Base Total to Min") {
    pokemon_with_dups$type1 <- factor(pokemon_with_dups$type1, 
                                      levels = names(sort(tapply(pokemon_with_dups$base_total, 
                                                                 pokemon_with_dups$type1, max), 
                                                          decreasing = TRUE)))
  } else if (sortOrder == "Median Base Total") {
    pokemon_with_dups$type1 <- factor(pokemon_with_dups$type1, 
                                      levels = names(sort(tapply(pokemon_with_dups$base_total, 
                                                                 pokemon_with_dups$type1, median), 
                                                          decreasing = TRUE)))
  }
  
  return(pokemon_with_dups) # return statement for finishing the function
}

