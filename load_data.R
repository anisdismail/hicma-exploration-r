merge_tables <- function(path_set1, path_set2, path_set3) {
  # Read tables
  table1 <- read.csv(file.path(path_set1, "labels.csv"), header = TRUE, row.names = 1)
  table2 <- read.csv(file.path(path_set2, "labels.csv"), header = TRUE, row.names = 1)
  table3 <- read.csv(file.path(path_set3, "labels.csv"), header = TRUE, row.names = 1)
  
  # Add a new column to identify the origin
  table1$origin <- "Set1"
  table2$origin <- "Set2"
  table3$origin <- "Set3"
  
  # Concatenate the tables vertically
  merged_table <- rbind(table1, table2, table3)
  
  return(merged_table)
}
