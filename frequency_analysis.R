# Load required libraries
library(tibble)
library(dplyr)
library(tidyr)
library(stringr)
library(ggplot2)
library(scales)

# Function to calculate frequency and create a ggplot
calculate_frequency_and_plot <- function(text_df) {
  frequency <- text_df %>% 
    count(origin, token) %>%
    group_by(origin) %>%
    mutate(proportion = n / sum(n)) %>% 
    select(-n) %>% 
    pivot_wider(names_from = origin, values_from = proportion) %>%
    pivot_longer(`Set2`:`Set3`,
                 names_to = "origin", values_to = "proportion")
  
  # Expect a warning about rows with missing values being removed
  plot <- ggplot(frequency, aes(x = proportion, y = `Set1`, 
                                color = abs(`Set1` - proportion))) +
    geom_abline(color = "gray40", lty = 2) +
    geom_jitter(alpha = 0.1, size = 2.5, width = 0.3, height = 0.3) +
    geom_text(aes(label = token), check_overlap = TRUE, vjust = 1.5, size = 4) + 
    scale_x_log10(labels = percent_format()) +
    scale_y_log10(labels = percent_format()) +
    scale_color_gradient(limits = c(0, 0.001), 
                         low = "darkslategray4", high = "gray75") +
    facet_wrap(~origin, ncol = 2) +
    theme(legend.position = "none") +
    labs(y = "Set1", x = NULL)
  
  return(list(freq = frequency, plot = plot))
}

# Function to perform correlation test
perform_correlation_test <- function(data, origin) {
  cor.test(data = data[data$origin == origin, ],
           ~ proportion + `Set1`)
}

