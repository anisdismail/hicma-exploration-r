library(scales)
library(ggplot2)
library(wordcloud2)

# Function to generate top POS ggplot with title and color gradient
generate_top_pos_plot <- function(text_df, pos, title) {
  top_pos <- text_df %>%
    anti_join(arabic_stopwords, by = "token") %>%
    filter(str_detect(upos, pos)) %>%
    count(token, sort = TRUE) %>%
    filter(nchar(token) > 1) %>%
    top_n(10, n) %>%
    mutate(word = reorder(token, n))
  
  ggplot(top_pos, aes(x = word, y = n, fill = n)) +
    geom_col() +
    scale_fill_gradient(low = "#8F562B", high = "#276B42") +
    scale_y_continuous(labels = scales::comma) +
    labs(y = "Frequency", x = NULL, title = title) +
    coord_flip() +
    theme_minimal() +
    theme(panel.grid.major.y = element_blank())+ 
    guides(fill = FALSE)  
}

generate_wordcloud <- function(text_df, stopwords, min_freq = 30, scale_range = c(5, 0.5), color_palette = brewer.pal(6, "Dark2"), rotate_ratio = 0.2) {
  freq <- text_df %>%
    anti_join(stopwords, by = "token") %>%
    count(token, sort = TRUE) %>%
    filter(nchar(token) > 1) %>%
    mutate(word = reorder(token, n))
  
  wf <- data.frame(word = freq$word, freq = freq$n)
  
  set.seed(114)
  wordcloud(wf$word, wf$freq, min.freq = min_freq, scale = scale_range, colors = color_palette, rot.per = rotate_ratio)
}

generate_wordcloud2 <- function(text_df, stopwords, min_freq = 30, scale_range = c(5, 0.5), color_palette = brewer.pal(6, "Dark2"), rotate_ratio = 0.2) {
  freq <- text_df %>%
    anti_join(stopwords, by = "token") %>%
    count(token, sort = TRUE) %>%
    filter(nchar(token) > 1) %>%
    mutate(word = reorder(token, n))
  
  wf <- data.frame(word = freq$word, freq = freq$n)
  
  set.seed(114)
  cloud_colors <- c("#301d25", "#7a4d41", "#275238", "#9c1839", "#6ab668", "#59d0ee", "#6767f4", "#d6273b", "#fffb49", "#e69975", "#5a4239", "#8d332a")
  cloud_background <- "#d8cdbe"
  wordcloud2(wf,
             color = rep_len(cloud_colors, nrow(wf)),
             backgroundColor = cloud_background,
             fontFamily = "Titr",
             size = 2,
             minSize = 5,
             rotateRatio = 0)
}


# Function to create the plot
create_words_histogram <- function(doc_words) {
  ggplot(doc_words, aes(n/total, fill = origin)) +
    geom_histogram(binwidth = 0.00005, show.legend = FALSE) +
    xlim(NA, 0.0009) +
    facet_wrap(~origin, ncol = 2, scales = "free_y")
}


# Function to visualize word correlations graph
visualize_word_correlations_graph <- function(word_cors) {
  set.seed(2016)
  
  word_cors %>%
    graph_from_data_frame() %>%
    ggraph(layout = "fr") +
    geom_edge_link(aes(edge_alpha = correlation), show.legend = FALSE) +
    geom_node_point(color = "lightblue", size = 5) +
    geom_node_text(aes(label = name), repel = TRUE) +
    theme_void()
}