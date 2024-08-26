# Assuming you are using the 'tm' and 'stats' packages
library(tm)
library(stats)
library(factoextra)

cluster_terms <- function(mat, lowfreq = 50, highfreq_ratio = 0.9, num_clusters = 3) {
  # Remove rare and common words
  word_freq <- findFreqTerms(mat, lowfreq = lowfreq, highfreq = nrow(mat) * highfreq_ratio)
  mat_filtered <- mat[, word_freq]
  
  # Remove rows with all zero values
  raw.sum <- apply(mat_filtered, 1, FUN = sum)
  mat_filtered <- mat_filtered[raw.sum != 0, ]
  
  # Calculate distance and perform hierarchical clustering
  d <- dist(t(mat_filtered), method = "euclidean")
  fit <- hclust(d = d, method = "complete")
  
  # Plot and return clusters
  plot(fit)
  rect.hclust(fit, k = num_clusters)
  return(fit)
}



# Function to perform PCA and visualize eigenvalues
perform_pca_documents <- function(mat, lowfreq = 50, highfreq_ratio = 0.9) {
  word_freq <- findFreqTerms(mat, lowfreq = lowfreq, highfreq = nrow(mat) * highfreq_ratio)
  mat_filtered <- mat[, word_freq]
  raw.sum <- apply(mat_filtered, 1, FUN = sum)
  mat_filtered <- mat_filtered[raw.sum != 0, ]
  d <- dist(mat_filtered, method = "euclidean")
  data <- scale(1 - d)
  pca_result <- prcomp(data)
  
  fviz_eig(pca_result, addlabels = TRUE)
  
  return(pca_result)
}

# Function to create a 2D PCA plot
plot_pca_2d <- function(pca_result, x_limits, y_limits) {
  labels <- sapply(strsplit(rownames(pca_result$x), "_"), `[`, 2)
  unique_labels <- unique(labels)
  label_colors <- rainbow(length(unique_labels))
  point_colors <- label_colors[match(labels, unique_labels)]
  
  ggplot(data.frame(PC1 = jitter(pca_result$x[, 1], 0.2),
                    PC2 = jitter(pca_result$x[, 2], 0.2),
                    Label = labels), 
         aes(x = PC1, y = PC2, color = Label, alpha = 0.7)) +
    geom_point(size = 3) +
    ggtitle('PCA 2D Plot') +
    xlab('Principal Component 1') +
    ylab('Principal Component 2') +
    xlim(x_limits) +
    ylim(y_limits) +
    theme_minimal() +
    guides(alpha = 'none') +
    scale_color_manual(values = label_colors)
}

# Function to perform PCA on transposed data and visualize results
perform_pca_words <- function(mat, lowfreq = 50, highfreq_ratio = 0.9) {
  word_freq <- findFreqTerms(mat, lowfreq = lowfreq, highfreq = nrow(mat) * highfreq_ratio)
  mat_filtered <- mat[, word_freq]
  raw.sum <- apply(mat_filtered, 1, FUN = sum)
  mat_filtered <- mat_filtered[raw.sum != 0, ]
  d <- dist(t(mat_filtered), method = "euclidean")
  data <- scale(1 - d)
  pca_result <- prcomp(data)
  
  plot(fviz_eig(pca_result, addlabels = TRUE))
  
  plot(fviz_pca_var(pca_result, col.var = "cos2",
               gradient.cols = c("black", "orange", "green"),
               repel = TRUE))
  
  plot(fviz_pca_ind(pca_result,
               col.ind = "cos2",
               gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
               repel = TRUE
  ))
  return(pca_result)
}

