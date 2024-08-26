library(topicmodels)

# Function to train LDA model
train_lda_model <- function(mat, n_topics, seed = 1234) {
  lda.model <- LDA(mat, n_topics, control = list(seed = seed))
  return(lda.model)
}

# Function to get top terms for each topic
get_top_terms <- function(lda_model, n_terms = 10) {
  topics <- tidy(lda_model, matrix = "beta")
  ap_top_terms <- topics %>%
    group_by(topic) %>%
    slice_max(beta, n = n_terms) %>% 
    ungroup() %>%
    arrange(topic, -beta)
  
  return(ap_top_terms)
}

# Function to plot top terms
plot_top_terms <- function(top_terms) {
  top_terms %>%
    mutate(term = reorder_within(term, beta, topic)) %>%
    ggplot(aes(beta, term, fill = factor(topic))) +
    geom_col(show.legend = FALSE) +
    facet_wrap(~ topic, scales = "free") +
    scale_y_reordered()
}

# Function to get document-topic matrix
get_document_topic_matrix <- function(lda_model) {
  ap_documents <- tidy(lda_model, matrix = "gamma")
  ap_documents <- ap_documents %>%
    separate(document, c("docid", "origin"), sep = "_", convert = TRUE)
  
  return(ap_documents)
}

# Function to plot document-topic distribution
plot_document_topic_distribution <- function(doc_topic_matrix) {
  doc_topic_matrix %>%
    mutate(origin = reorder(origin, gamma * topic)) %>%
    ggplot(aes(factor(topic), gamma)) +
    geom_boxplot() +
    facet_wrap(~ origin) +
    labs(x = "topic", y = expression(gamma))
}

