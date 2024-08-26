
library(tibble)
library(udpipe)
library(stringr)
library(dplyr)
library(arabicStemR)
library(Matrix)

# Function to download and load Arabic UDpipe model
load_arabic_udpipe_model <- function() {
  udpipe::udpipe_download_model(language = "arabic-padt")
  return(udpipe::udpipe_load_model(file = "arabic-padt-ud-2.5-191206.udpipe"))
}

# Function to preprocess and annotate Arabic text
preprocess_and_annotate_arabic_text <- function(model, merged_table) {
  text_df <- tibble(
    doc_id = paste0("doc", 1:dim(merged_table)[1], "_", merged_table$origin),
    text = merged_table$label,
    class = merged_table$class,
    origin = merged_table$origin
  )
  
  ar_pos <- udpipe::udpipe_annotate(model, x = text_df$text, doc_id = text_df$doc_id) %>%
    as.data.frame()
  
  ar_pos_cleaned <- tibble(ar_pos) %>% 
    drop_na(lemma, upos, xpos) %>%
    filter(upos != "PUNCT" & upos != "NUM")
  
  text_df <- ar_pos_cleaned %>% 
    left_join(text_df, by = "doc_id")
  
  return(text_df)
}

# Function to load Arabic stopwords
load_arabic_stopwords <- function() {
  return(tibble(token = removeStopWords("سلام")$arabicStopwordList))
}

# Function to count words
count_words <- function(text_df) {
  doc_words <- text_df %>%
    count(origin, token, sort = TRUE)
  
  total_words <- doc_words %>% 
    group_by(origin) %>% 
    summarize(total = sum(n))
  
  doc_words <- left_join(doc_words, total_words)
  
  return(doc_words)
}


# Function to calculate word pairs
calculate_word_pairs <- function(text_df, stopwords_df) {
  text_df %>%
    anti_join(stopwords_df, by = "token") %>%
    pairwise_count(token, doc_id, sort = TRUE)
}

# Function to calculate word correlations
calculate_word_correlations <- function(text_df, stopwords_df, min_count = 20, correlation_threshold = 0.3) {
  text_df %>%
    anti_join(stopwords_df, by = "token") %>%
    group_by(token) %>%
    filter(n() >= min_count) %>%
    pairwise_cor(token, doc_id, sort = TRUE) %>%
    filter(correlation > correlation_threshold)
}



# Define the function
create_document_term_matrix <- function(text_df, stopwords, pos_tags = c("ADJ", "NOUN", "VERB")) {
  
  # Remove stopwords and filter by POS tags
  processed_df <- text_df %>%
    anti_join(stopwords, by = "token") %>%
    filter(upos %in% pos_tags) %>%
    count(doc_id, token, sort = TRUE)
  
  # Create Document-Term Matrix (DTM)
  dtm <- cast_dtm(processed_df, doc_id, token, n)
  
  return(dtm)
}


