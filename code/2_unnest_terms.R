# title: Unnest Tokens -- titles, keywords, abstracts
# author: "Sam Csik"
# date created: "2020-10-08"
# date edited: "2020-10-08"
# R version: 3.6.3
# input: "data/queries/query2020-10-09/*"
# output: "data/text_mining/unnested_tokens/*"

##########################################################################################
# Summary
##########################################################################################

# This script uses the tidytext package to unnest (i.e. separate into individual columns) tokens (i.e. words) into various ngrams (where n = 1, 2, or 3)
# Specifically, we unnest titles, keywords, abstracts, attributeNames, attributeLabels, attributeDescriptions
# These unnested tokens are saved as .csv files for use in later scripts

##########################################################################################
# General Setup
##########################################################################################

##############################
# Load packages & custom functions
##############################

source(here::here("code", "0_libraries.R"))
source(here::here("code", "0_functions.R"))

##############################
# Upload data
##############################

solr_query <- read_csv(here::here("data", "queries", "query2020-10-09", "fullQuery_semAnnotations2020-10-09_solr.csv"))
attributes <- read_csv(here::here("data", "queries", "query2020-10-09", "fullQuery_semAnnotations2020-10-09_attributes.csv"))

##############################
# Add `author` field from `solr_query` to `attributes` df
##############################

authors_ids <- solr_query %>% select(identifier, author)
attributes <- inner_join(attributes, authors_ids)

##########################################################################################
# Unnest tokens using `process_df()` to split fields into individual terms, bigrams, and trigrams; maintain associated identifier and author
##########################################################################################

##############################
# Process TITLES, KEYWORDS, ABSTRACTS (from df: `solr_query`)
  # unnest tokens (for individual words, bigrams, trigrams)
##############################

# fields to unnest
tka_fields <- tribble(
  ~my_input,  
  "title",    
  "keywords",     
  "abstract", 
)

# process dfs
for (row in 1:nrow(tka_fields)) {
  item <- as.character(tka_fields[row,][,1][,1])
  print(item)
  process_df(solr_query, item)
}

##############################
# Process ATTRIUBTE-LEVEL INFORMATION (from df `attributes`)
  # NOTE: attributeNames are already unnested thanks to the `eatocsv` package, but need some wrangling to get into the same format as titles, keywords, abstracts (above)
  # NOTE: attributeDefinitions & *attributeLabels need to be unnested
    # *attributeLabels are largely missing
##############################

# --------------
# attributeNames
# --------------

`unnested_attributeNamesIndivTokens2020-10-09` <- attributes %>% 
  select(identifier, author, attributeName) %>% 
  rename(word1 = attributeName) %>% 
  mutate(word2 = rep(""), word3 = rep(""))

# --------------
# attributeDefinitions & attributeLabels
# --------------

# individual tokens
aLaD_fields <- tribble(
  ~my_input,  
  "attributeLabel",    
  "attributeDefinition"
)

# process dfs
for (row in 1:nrow(aLaD_fields)) {
  item <- as.character(aLaD_fields[row,][,1][,1])
  print(item)
  process_df(attributes, item)
}

##########################################################################################
# print all unnested dfs as .csv files
##########################################################################################

# get lists of new filterCounts dfs
indiv_list <- mget(ls(pattern = glob2rx("unnested_*Indiv*")))
bigram_list <- mget(ls(pattern = glob2rx("unnested_*Bigram*")))
trigram_list <- mget(ls(pattern = glob2rx("unnested_*Trigram*")))

# save indiv terms
for (i in 1:length(indiv_list)){
  data <- indiv_list[[i]]
  names <- names(indiv_list)[i]
  file_path <- "data/unnested_terms/indiv"
  output_csv(data, names, file_path)
}

# save bigram terms
for (i in 1:length(bigram_list)){
  data <- bigram_list[[i]]
  names <- names(bigram_list)[i]
  file_path <- "data/unnested_terms/bigrams"
  output_csv(data, names, file_path)
}

# save trigram terms
for (i in 1:length(trigram_list)){
  data <- trigram_list[[i]]
  names <- names(trigram_list)[i]
  file_path <- "data/unnested_terms/trigrams"
  output_csv(data, names, file_path)
}