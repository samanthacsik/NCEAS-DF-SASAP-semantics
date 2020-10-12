# title: Custom Functions for Data Wrangling & Plotting
# author: "Sam Csik"
# date created: "2020-10-08"
# date edited: "2020-10-08"
# packages updated: __
# R version: __
# input: NA
# output: NA

source(here::here("code", "0_libraries.R"))

#-----------------------------
# used in script "2_unnest_terms.R"
# function to unnest individual tokens and separates ngrams into multiple columns
  # takes arguments:
    # my_data: a df of solr query results
    # my_input: input column to get split (e.g. title), as string or symbol
    # split: number of words to split each input into (e.g. for trigrams, split = 3)
#-----------------------------

tidyTerms_unnest <- function(my_data, my_input, split) {
  my_data %>%
    select(identifier, author, my_input) %>%
    unnest_tokens(output = ngram, input = !!my_input, token = "ngrams", n = split) %>% 
    separate(ngram, into = c("word1", "word2", "word3"), sep = " ")
}

#-----------------------------
# used in script "2_unnest_terms.R"
# function that applies the tidyTerms_unnest() to all specified items within a df, and saves as data objects
  # takes arguments:
    # df: a df of solr query results
    # item: which column(s) (i.e. metadata fields) you'd like to process (e.g. title, keywords, abstract)
#-----------------------------

# function 
process_df <- function(df, item) {
  
  print(item)
  
  # unnest tokens
  word_table <- tidyTerms_unnest(df, item, 1)
  bigram_table <- tidyTerms_unnest(df, item, 2)
  trigram_table <- tidyTerms_unnest(df, item, 3)
  
  # create object names
  word_table_name <- paste("unnested_", item, "IndivTokens", Sys.Date(), sep = "")
  bigram_table_name <- paste("unnested_", item, "BigramTokens", Sys.Date(), sep = "")
  trigram_table_name <- paste("unnested_", item, "TrigramTokens", Sys.Date(), sep = "")
  
  # print as dfs
  assign(word_table_name, word_table, envir = .GlobalEnv)
  assign(bigram_table_name, bigram_table, envir = .GlobalEnv)
  assign(trigram_table_name, trigram_table, envir = .GlobalEnv)
}

#-----------------------------
# used in script: "3_filterStopWords_term_counts.R"
# functions filter out tidytext::data(stop_words), count unnested terms, and count number of unique identifiers and unique authors for each unique token (separate functions for individual tokens, bigrams, trigrams)
  # takes arguments:
    # file_path: where to save .csv file
    # file_name: name of .csv file saved to "data/unnested_terms/*"
#-----------------------------

###### individual tokens ###### 
filterCount_indivTerms <- function(file_path, file_name) {
  
  # create object name
  object_name <- basename(file_name)
  object_name <- gsub(".csv", "", object_name)
  object_name <- gsub("unnested_", "filteredCounts_", object_name)
  print(object_name)
  
  # total token counts
  token_counts <- read_csv(here::here(file_path, file_name)) %>% # file_path = "data/text_mining/unnested_tokens"
    rename(token = word1) %>% 
    select(identifier, token) %>% 
    filter(!token %in% stop_words$word, token != "NA") %>% 
    count(token, sort = TRUE)
  
  # unique ID counts for each token
  uniqueID_counts <- read_csv(here::here(file_path, file_name)) %>% 
    rename(token = word1) %>% 
    select(identifier, token) %>% 
    filter(!token %in% stop_words$word, token != "NA") %>% 
    group_by(token) %>% 
    summarise(unique_ids = n_distinct(identifier)) %>% 
    arrange(-unique_ids)
  
  # unique ID counts for each token
  uniqueAuthor_counts <- read_csv(here::here(file_path, file_name)) %>% 
    rename(token = word1) %>% 
    select(author, token) %>% 
    filter(!token %in% stop_words$word, token != "NA") %>% 
    group_by(token) %>% 
    summarise(unique_authors = n_distinct(author)) %>% 
    arrange(-unique_authors)
  
  # full_join dfs by token -- first token_counts and uniqueID_counts
  my_file <- full_join(token_counts, uniqueID_counts)
  # then uniqueAuthor_counts
  my_file <- full_join(my_file, uniqueAuthor_counts)
  
  # save as object_name
  assign(object_name, my_file, envir = .GlobalEnv)
}

######  bigrams ###### 
filterCount_bigramTerms <- function(file_path, file_name) {
  
  # create object name
  object_name <- basename(file_name)
  object_name <- gsub(".csv", "", object_name)
  object_name <- gsub("unnested_", "filteredCounts_", object_name)
  print(object_name)
  
  # wrangle data
  token_counts <- read_csv(here::here(file_path, file_name)) %>% 
    select(identifier, word1, word2) %>% 
    filter(!word1 %in% stop_words$word, !word2 %in% stop_words$word) %>% 
    filter(word1 != "NA", word2 != "NA") %>% 
    count(word1, word2, sort = TRUE) %>% 
    unite(col = "token", word1, word2, sep = " ")
  
  # unique ID counts for each token
  uniqueID_counts <- read_csv(here::here(file_path, file_name)) %>% 
    select(identifier, word1, word2) %>% 
    filter(!word1 %in% stop_words$word, !word2 %in% stop_words$word) %>% 
    filter(word1 != "NA", word2 != "NA") %>% 
    unite(col = "token", word1, word2, sep = " ") %>% 
    group_by(token) %>% 
    summarise(unique_ids = n_distinct(identifier)) %>% 
    arrange(-unique_ids)
  
  # unique ID counts for each token
  uniqueAuthor_counts <- read_csv(here::here(file_path, file_name)) %>% 
    select(author, word1, word2) %>% 
    filter(!word1 %in% stop_words$word, !word2 %in% stop_words$word) %>% 
    filter(word1 != "NA", word2 != "NA") %>% 
    unite(col = "token", word1, word2, sep = " ") %>% 
    group_by(token) %>% 
    summarise(unique_authors = n_distinct(author)) %>% 
    arrange(-unique_authors)
  
  # full_join dfs by token -- first token_counts and uniqueID_counts
  my_file <- full_join(token_counts, uniqueID_counts)
  # then uniqueAuthor_counts
  my_file <- full_join(my_file, uniqueAuthor_counts) %>% 
    separate(token, into = c("word1", "word2"), sep = " ")
  
  # save as object_name
  assign(object_name, my_file, envir = .GlobalEnv)
}

######trigrams ###### 
filterCount_trigramTerms <- function(file_path, file_name) {
  
  # create object name
  object_name <- basename(file_name)
  object_name <- gsub(".csv", "", object_name)
  object_name <- gsub("unnested_", "filteredCounts_", object_name)
  print(object_name)
  
  # wrangle data
  token_counts <- read_csv(here::here(file_path, file_name)) %>% 
    select(identifier, word1, word2, word3) %>% 
    filter(!word1 %in% stop_words$word, !word2 %in% stop_words$word, !word3 %in% stop_words$word) %>% 
    filter(word1 != "NA", word2 != "NA", word3 != "NA") %>% 
    count(word1, word2, word3, sort = TRUE) %>% 
    unite(col = "token", word1, word2, word3, sep = " ")
  
  # unique ID counts for each token
  uniqueID_counts <- read_csv(here::here(file_path, file_name)) %>% 
    select(identifier, word1, word2, word3) %>% 
    filter(!word1 %in% stop_words$word, !word2 %in% stop_words$word, !word3 %in% stop_words$word) %>% 
    filter(word1 != "NA", word2 != "NA", word3 != "NA") %>% 
    unite(col = "token", word1, word2, word3, sep = " ") %>% 
    group_by(token) %>% 
    summarise(unique_ids = n_distinct(identifier)) %>% 
    arrange(-unique_ids)
  
  # unique ID counts for each token
  uniqueAuthor_counts <- read_csv(here::here(file_path, file_name)) %>% 
    select(author, word1, word2, word3) %>% 
    filter(!word1 %in% stop_words$word, !word2 %in% stop_words$word, !word3 %in% stop_words$word) %>% 
    filter(word1 != "NA", word2 != "NA", word3 != "NA") %>% 
    unite(col = "token", word1, word2, word3, sep = " ") %>% 
    group_by(token) %>% 
    summarise(unique_authors = n_distinct(author)) %>% 
    arrange(-unique_authors)
  
  # full_join dfs by token -- first token_counts and uniqueID_counts
  my_file <- full_join(token_counts, uniqueID_counts)
  # then uniqueAuthor_counts
  my_file <- full_join(my_file, uniqueAuthor_counts) %>% 
    separate(token, into = c("word1", "word2", "word3"), sep = " ")
  
  # save as object_name
  assign(object_name, my_file, envir = .GlobalEnv)
}

#-----------------------------
# used in script: "2_unnest_terms.R", "3_filterStopWords_term_counts.R"
# function to save a df from the global environment whose name matches your specified pattern as a .csv to your specified directory
  # takes arguments:
    # data: data object
    # name: name of object, as character string
    # file path: where you'd like to save the .csv file(s)
#-----------------------------

# function to write as .csv files to appropriate subdirectory
output_csv <- function(data, names, file_path){
  write_csv(data, here::here(file_path, paste0(names, ".csv")))
}