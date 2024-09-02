#####################################################################################################
# This R script encompasses a comprehensive analysis of the HICMA dataset (hicma.net),
# focusing on its arabic corpus. It includes data loading, merging,
# Arabic text preprocessing, part-of-speech analysis, frequency analysis, Zipf's
# Law analysis, TF-IDF analysis, N-gram analysis, word pairs and correlations
# analysis, Latent Dirichlet Allocation (LDA) topic modeling, Principal
# Component Analysis (PCA), and clustering. Each section is organized with clear
# titles and descriptions, providing a step-by-step guide through the data
# exploration and analysis process.

#####################################################################################################

# Set the working directory and load necessary functions
setwd('/hicma-exploration-r')
source("load_data.R")
source("preprocess_data.R")
source("visualization.R")
source("frequency_analysis.R")
source("rank_analysis.R")
source("tf_idf_analysis.R")
source("unigram_analysis.R")
source("topicmodeling_analysis.R")
source("pca_clustering.R")

# Set seed for reproducibility
set.seed(1234)

#####################################################################################################
# Data Loading and Merging

## Load and merge datasets from Set1, Set2, and Set3
path_set1 <- "Full_Dataset/Set1"
path_set2 <- "Full_Dataset/Set2"
path_set3 <- "Full_Dataset/Set3"
merged_table <- merge_tables(path_set1, path_set2, path_set3)
print(dim(merged_table))
merged_table

#####################################################################################################
# Text Preprocessing

## Load Arabic NLP model and preprocess text
m_arabic <- load_arabic_udpipe_model()
text_df <-
  preprocess_and_annotate_arabic_text(m_arabic, merged_table)
arabic_stopwords <- load_arabic_stopwords()

#####################################################################################################
# Part-of-Speech Analysis

## Generate plots for top nouns, verbs, and adjectives in the full corpus
top_nouns_plot <-
  generate_top_pos_plot(text_df, "NOUN", "Top Nouns in Full Corpus")
top_verbs_plot <-
  generate_top_pos_plot(text_df, "VERB", "Top Verbs in Full Corpus")
top_adjs_plot <-
  generate_top_pos_plot(text_df, "ADJ", "Top Adjectives in Full Corpus")
gridExtra::grid.arrange(top_nouns_plot, top_verbs_plot, top_adjs_plot, ncol = 3)

## Generate plots for top nouns, verbs, and adjectives in each Set (Set1, Set2, Set3)
for (x in c("Set1", "Set2", "Set3")) {
  top_nouns_plot <-
    generate_top_pos_plot(text_df %>% filter(origin == x), "NOUN", paste("Top Nouns in ", x))
  top_verbs_plot <-
    generate_top_pos_plot(text_df %>% filter(origin == x), "VERB", paste("Top Verbs in ", x))
  top_adjs_plot <-
    generate_top_pos_plot(text_df %>% filter(origin == x), "ADJ", paste("Top Adj in ", x))
  gridExtra::grid.arrange(top_nouns_plot, top_verbs_plot, top_adjs_plot, ncol = 3)
}

## Generate and visualize word clouds for the full corpus of each Set
generate_wordcloud2(text_df, arabic_stopwords)
generate_wordcloud2(text_df %>% filter(origin == "Set1"), arabic_stopwords)
generate_wordcloud2(text_df %>% filter(origin == "Set2"), arabic_stopwords)
generate_wordcloud2(text_df %>% filter(origin == "Set3"), arabic_stopwords)

#####################################################################################################
# Frequency Analysis

## Calculate word frequencies and perform correlation tests
plot_result <- calculate_frequency_and_plot(text_df)
print(plot_result$plot)
cor_test_result_set12 <- perform_correlation_test(plot_result$freq, "Set2")
cor_test_result_set13 <- perform_correlation_test(plot_result$freq, "Set3")
print(cor_test_result_set12)
print(cor_test_result_set13)

#####################################################################################################
# Words Histogram

## Create a histogram of document word counts
doc_words <- count_words(text_df)
hist_plot <- create_words_histogram(doc_words)
print(hist_plot)

#####################################################################################################
# Zipf's Law Analysis

## Analyze frequency by rank and visualize Zipf's Law
freq_by_rank <- create_freq_by_rank(doc_words)
initial_plot <- create_initial_plot(freq_by_rank)
final_plot <- add_regression_line(freq_by_rank)
print(initial_plot)
print(final_plot)

#####################################################################################################
# TF-IDF Analysis

## Create and visualize TF-IDF (Term Frequency-Inverse Document Frequency)
doc_tf_idf <- create_tf_idf(doc_words)
tf_idf_plot <- create_tf_idf_plot(doc_tf_idf)
print(tf_idf_plot)

#####################################################################################################
# N-Gram and TF-IDF Analysis

## Generate and visualize bigrams for the entire dataset and each Set
data <-
  tibble(
    doc_id = paste0("doc", 1:dim(merged_table)[1]),
    text = merged_table$label,
    class = merged_table$class,
    origin = merged_table$origin
  )

generate_ngram_tf_idf_plot(data,arabic_stopwords)

## Generate and visualize bigrams for the full corpus and each Set
data %>%
  count_bigrams(arabic_stopwords) %>%
  filter(n > 15) %>%
  visualize_bigrams()
data %>%
  filter(origin == "Set1") %>%
  count_bigrams(arabic_stopwords) %>%
  filter(n > 15) %>%
  visualize_bigrams()
data %>%
  filter(origin == "Set2") %>%
  count_bigrams(arabic_stopwords) %>%
  filter(n > 5) %>%
  visualize_bigrams()
data %>%
  filter(origin == "Set3") %>%
  count_bigrams(arabic_stopwords) %>%
  filter(n > 15) %>%
  visualize_bigrams()

#####################################################################################################
# Word Pairs and Correlations Analysis

## Calculate word pairs and correlations
word_pairs <- calculate_word_pairs(text_df, arabic_stopwords)
word_cors <- calculate_word_correlations(text_df, arabic_stopwords)
print(word_pairs)
print(word_cors)
visualize_word_correlations_graph(word_cors)

#####################################################################################################
# Latent Dirichlet Allocation (LDA) Topic Modeling

## Perform LDA topic modeling and visualize results
mat <- create_document_term_matrix(text_df,arabic_stopwords)
n.topics <- 10
lda_model <- train_lda_model(mat, n.topics)
top_terms <- get_top_terms(lda_model)
plot_top_terms(top_terms)
document_topic_matrix <- get_document_topic_matrix(lda_model)
plot_document_topic_distribution(document_topic_matrix)

#####################################################################################################
# Principal Component Analysis (PCA) and Clustering

## Perform PCA for documents and words, and cluster terms
pca_result_1 <- perform_pca_documents(mat)
plot_pca_2d(pca_result_1,
            x_limits = c(-500, 100),
            y_limits = c(-50, 50))
pca_result_2 <- perform_pca_words(mat)

result_fit <-
  cluster_terms(
    mat,
    lowfreq = 50,
    highfreq_ratio = 0.9,
    num_clusters = 3
  )
