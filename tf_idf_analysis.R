library(dplyr)
library(tidyr)
library(ggplot2)
library(forcats)
library(tidytext)

# Function to create tf-idf data frame
create_tf_idf <- function(doc_words) {
  doc_tf_idf <- doc_words %>%
    bind_tf_idf(token, origin, n)
  
  return(doc_tf_idf)
}

# Function to create tf-idf plot
create_tf_idf_plot <- function(doc_tf_idf, top_n = 15) {
  tf_idf_ordered <- doc_tf_idf %>%
    select(-total) %>%
    arrange(desc(tf_idf))
  
  top_terms <- doc_tf_idf %>%
    group_by(origin) %>%
    slice_max(tf_idf, n = top_n) %>%
    ungroup()
  
  plot <- top_terms %>%
    ggplot(aes(tf_idf, fct_reorder(token, tf_idf), fill = origin)) +
    geom_col(show.legend = FALSE) +
    facet_wrap(~origin, ncol = 2, scales = "free") +
    labs(x = "tf-idf", y = NULL)+
    theme(
      panel.grid.major.y = element_blank(),
      axis.text.y = element_text(size = 14),  # Adjust the font size as needed
      
    ) 
  
  return(plot)
}
