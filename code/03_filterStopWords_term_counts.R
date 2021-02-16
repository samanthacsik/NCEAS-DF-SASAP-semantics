# title: Remove stop words and calculate term frequncies
# author: "Sam Csik"
# date created: "2020-10-09"
# date edited: "2020-10-12"
# R version: 3.6.3
# input: "data/queries/fullQuery_titleKeywordsAbstract2020-09-15.csv" & "data/attributes_query_eatocsv/extracted_attributes/fullQuery2020-09-13_attributes.csv" 
# output: "data/filtered_term_counts/*"

##########################################################################################
# Summary
##########################################################################################

# This script uses the tidytext package to filter out "stop_words" from unnested token files, count number of occurrences for each term (token), and count the number of unique identifiers & unique authors associated with each unique term
  # NOTE: unique_authors is not reliable--many data packages do not have an author listed
# These data frames are saved then as .csv files 

##########################################################################################
# General Setup
##########################################################################################

##############################
# Load packages & custom functions
##############################

source(here::here("code", "0_libraries.R"))
source(here::here("code", "0_functions.R"))

##########################################################################################
# Filter/count INDIVIDUAL TOKENS
##########################################################################################

# isolate individual token files #####(do not include attributes -- they are in a different format)
all_unnested_indiv_files <- list.files(path = here::here("data", "unnested_terms", "indiv"), pattern = glob2rx("unnested_*Indiv*"))

# remove excess columns, filter out stop_words, remove NAs, calculate counts
for(i in 1:length(all_unnested_indiv_files)){
  file_name <- all_unnested_indiv_files[i]
  file_path <- "data/unnested_terms/indiv"
  filterCount_indivTerms(file_path, file_name)
}

##########################################################################################
# Filter/count BIGRAMS 
##########################################################################################

# isolate bigram token files
all_unnested_bigram_files <- list.files(path = here::here("data","unnested_terms", "bigrams"), pattern = glob2rx("unnested_*Bigram*"))

# remove excess columns, filter out stop_words, remove NAs, calculate counts
for(i in 1:length(all_unnested_bigram_files)){
  file_name <- all_unnested_bigram_files[i]
  file_path <- "data/unnested_terms/bigrams"
  filterCount_bigramTerms(file_path, file_name)
}

##########################################################################################
# Filter/count TRIGRAMS
##########################################################################################

# isolate trigram token files
all_unnested_trigram_files <- list.files(path = here::here("data", "unnested_terms", "trigrams"), pattern = glob2rx("unnested_*Trigram*"))

# remove excess columns, filter out stop_words, remove NAs, calculate counts
for(i in 1:length(all_unnested_trigram_files)){
  file_name <- all_unnested_trigram_files[i]
  file_path <- "data/unnested_terms/trigrams"
  filterCount_trigramTerms(file_path, file_name)
}

##########################################################################################
# save as .csv files
##########################################################################################

# get lists of new filterCounts dfs
indiv_list <- mget(ls(pattern = glob2rx("filteredCounts_*Indiv*")))
bigram_list <- mget(ls(pattern = glob2rx("filteredCounts_*Bigram*")))
trigram_list <- mget(ls(pattern = glob2rx("filteredCounts_*Trigram*")))

# save indiv terms
for (i in 1:length(indiv_list)){
  data <- indiv_list[[i]]
  names <- names(indiv_list)[i]
  file_path <- "data/filtered_term_counts/indiv"
  output_csv(data, names, file_path)
}

# save bigram terms
for (i in 1:length(bigram_list)){
  data <- bigram_list[[i]]
  names <- names(bigram_list)[i]
  file_path <- "data/filtered_term_counts/bigrams"
  output_csv(data, names, file_path)
}

# save trigram terms
for (i in 1:length(trigram_list)){
  data <- trigram_list[[i]]
  names <- names(trigram_list)[i]
  file_path <- "data/filtered_term_counts/trigrams"
  output_csv(data, names, file_path)
}
