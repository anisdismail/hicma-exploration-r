# Load necessary libraries
library(dplyr)
library(tidyr)
library(ggplot2)
library(forcats)  # Ensure forcats library is loaded for fct_reorder function
library(widyr)    # Ensure widyr library is loaded for bind_tf_idf function
library(ggraph)
library(igraph)

count_bigrams <- function(dataset,arabic_stopwords) {
  dataset %>%
    unnest_tokens(bigram, text, token = "ngrams", n = 2) %>%
    filter(!is.na(bigram)) %>%
    separate(bigram, c("word1", "word2"), sep = " ") %>%
    filter(!word1 %in% arabic_stopwords$token,
           !word2 %in% arabic_stopwords$token) %>%
    count(word1, word2, sort = TRUE)
}

visualize_bigrams <- function(bigrams) {
  set.seed(2016)
  a <- grid::arrow(type = "closed", length = unit(.15, "inches"))
  
  bigrams %>%
    graph_from_data_frame() %>%
    ggraph(layout = "fr") +
    geom_edge_link(aes(edge_alpha = n), show.legend = FALSE, arrow = a) +
    geom_node_point(color = "lightblue", size = 5) +
    geom_node_text(aes(label = name), vjust = 1, hjust = 1) +
    theme_void()
}

generate_ngram_tf_idf_plot <- function(data,arabic_stopwords, n = 2, top_n = 15) {
  ngram_column <- if (n == 2) "bigram" else if (n == 3) "trigram" else stop("Invalid value for n, must be 2 or 3.")
  
  ngram_data <- data %>%
    unnest_tokens(ngram_column, text, token = "ngrams", n = n) %>%
    filter(!is.na(ngram_column))
  
  if (n == 2) {
    ngram_data <- ngram_data %>%
      separate(ngram_column, c("word1", "word2"), sep = " ") %>%
      filter(!word1 %in% arabic_stopwords$token, !word2 %in% arabic_stopwords$token)
  } else if (n == 3) {
    ngram_data <- ngram_data %>%
      separate(ngram_column, c("word1", "word2", "word3"), sep = " ") %>%
      filter(!word1 %in% arabic_stopwords$token, !word2 %in% arabic_stopwords$token, !word3 %in% arabic_stopwords$token)
  }
  
  ngram_united <- ngram_data %>%
    unite(ngram_column, starts_with("word"), sep = " ")
  
  ngram_tf_idf <- ngram_united %>%
    count(origin, ngram_column) %>%
    bind_tf_idf(ngram_column, origin, n) %>%
    arrange(desc(tf_idf))
  
  top_ngrams <- ngram_tf_idf %>%
    group_by(origin) %>%
    slice_max(tf_idf, n = top_n) %>%
    ungroup()
  
  ggplot(top_ngrams, aes(tf_idf, fct_reorder(ngram_column, tf_idf), fill = origin)) +
    geom_col(show.legend = FALSE) +
    facet_wrap(~origin, ncol = 2, scales = "free") +
    labs(x = "tf-idf", y = NULL)+   
    theme(
      panel.grid.major.y = element_blank(),
      axis.text.y = element_text(size = 14),  # Adjust the font size as needed
      
    ) 
}



