library(dplyr)
library(ggplot2)

# Function to create frequency by rank data frame
create_freq_by_rank <- function(doc_words) {
  freq_by_rank <- doc_words %>% 
    group_by(origin) %>% 
    mutate(rank = row_number(), 
           `term frequency` = n/total) %>%
    ungroup()
  
  return(freq_by_rank)
}

# Function to create the initial plot
create_initial_plot <- function(freq_by_rank) {
  ggplot(freq_by_rank, aes(rank, `term frequency`, color = origin)) + 
    geom_line(size = 1.1, alpha = 0.8, show.legend = FALSE) + 
    scale_x_log10() +
    scale_y_log10()
}

# Function to add regression line and filter data
add_regression_line <- function(freq_by_rank, subset_start = 10, subset_end = 500) {
  rank_subset <- freq_by_rank %>% 
    filter(rank < subset_end,
           rank > subset_start)
  
  regression_line <- lm(log10(`term frequency`) ~ log10(rank), data = rank_subset)
  
  plot <- ggplot(freq_by_rank, aes(rank, `term frequency`, color = origin)) + 
    geom_abline(intercept = coef(regression_line)[1], slope = coef(regression_line)[2], 
                color = "gray50", linetype = 2) +
    geom_line(size = 1.1, alpha = 0.8, show.legend = FALSE) + 
    scale_x_log10() +
    scale_y_log10()
  
  return(plot)
}

