# title: Plotting Token/ngram Frequencies
# author: "Sam Csik"
# date created: "2020-10-12"
# date edited: "2020-10-12"
# R version: 3.6.3
# input: "data/text_mining/filtered_token_counts/*"
# output: "figures/token_frequencies/*"

#########################################################################################
# Summary
##########################################################################################

# this script: 
# (a) wrangles data to prepare for plotting (i.e. combines tokens into single col) 
# (b) plots term frequencies arranged by Counts 

##########################################################################################
# General Setup
##########################################################################################

##############################
# Load packages & custom functions
##############################

source(here::here("code", "0_libraries.R"))
source(here::here("code", "0_functions.R"))

##############################
# Read in data
##############################

# isolate filtered_token_counts
all_files <- list.files(path = here::here("data", "filtered_term_counts"), pattern = glob2rx("*.csv"), recursive = TRUE)

# remove excess columns, filter out stop_words, remove NAs, calculate counts
for(i in 1:length(all_files)){
  file_name <- all_files[i]
  import_filteredTermCounts(file_name)
}

##########################################################################################
# (a) Get data into appropriate format for plotting (NOTE: indiv terms dfs already in appropriate format)
  # 1) simplify indiv df names
  # 2) combine bigrams into single column for plotting
  # 3) combine trigrams into single column for plotting
  # 4) remove excess objects from global environment
##########################################################################################

##############################
# 1) simplify indiv df names
##############################

# get list of indiv dfs
indiv_list <- mget(ls(pattern = glob2rx("indiv/*")))

# resave with simplified names
for(i in 1:length(indiv_list)){
  object <- indiv_list[[i]]
  name <- names(indiv_list)[i]
  name <- strsplit(name, split = "/")
  name <- name[[1]][2]
  assign(name, object, envir = .GlobalEnv)
}

##############################
# 2) combine bigrams
##############################

# get lists of bigram dfs
bigram_list <- mget(ls(pattern = glob2rx("*BigramTokens")))

# combine words in bigram dfs
for(i in 1:length(bigram_list)){
  object <- bigram_list[[i]]
  name <- names(bigram_list)[i]
  name <- strsplit(name, split = "/")
  name <- name[[1]][2]
  combine_bigrams(object = object, object_name = name)
}

##############################
# 3) combine trigrams
##############################

# get list of trigram dfs
trigram_list <- mget(ls(pattern = glob2rx("*TrigramTokens")))

# combine words in trigram dfs
for(i in 1:length(trigram_list)){
  object <- trigram_list[[i]]
  name <- names(trigram_list)[i]
  name <- strsplit(name, split = "/")
  name <- name[[1]][2]
  combine_trigrams(object = object, object_name = name)
}

##############################
# 4) clean up global environment by removing old objects (e.g. "indiv/...", "bigram/...", "trigram/...")
##############################

rm(list = ls(pattern =  glob2rx("indiv/*")))
rm(list = ls(pattern =  glob2rx("bigrams/*")))
rm(list = ls(pattern =  glob2rx("trigrams/*")))

##########################################################################################
# (b) Create token frequency plots (arranged by Counts)
  # 1) create separate plots
  # 2) combine plots into  multi-panel plots using the patchwork package
##########################################################################################

##############################
# 1) create plots & save to global environment
##############################

# get updated list of all dfs
wrangledTerms_list <- mget(ls(pattern = glob2rx("*Tokens")))

# plot
for(i in 1:length(wrangledTerms_list)){
  obj <- wrangledTerms_list[i]
  df <- obj[[1]]
  name <- names(obj)
  print(name)
  create_frequencyByCount_plot(tokens_df = df, df_name = name)
}

##############################
# 2) combine figure panels and save
##############################

# title, keywords, abstract plots
tka_indivToken_plot <- titleIndiv_plot | keywordsIndiv_plot | abstractIndiv_plot
tka_bigramToken_plot <- titleBigram_plot | keywordsBigram_plot | abstractBigram_plot
tka_trigramToken_plot <- titleTrigram_plot + keywordsTrigram_plot + abstractTrigram_plot
tka_allTokens_plot <- (tka_indivToken_plot) / (tka_bigramToken_plot) / (tka_trigramToken_plot) + 
  plot_annotation(
    title = "50 most common terms in the SASAP metadata corpus -- Titles, Keywords, & Abstracts",
    subtitle = "Rows top to bottom: individual terms, bigrams, trigrams",
    caption = "Data queried on 2020-10-09"
)
# ggsave(filename = here::here("figures", "term_frequencies", "titleKeywordsAbstractTermCounts_top50_plot.png"), plot = tka_allTokens_plot, height = 25, width = 20)

# attributeName, attributeLabel, attributeDefinition plots
att_indivToken_plot <- attributeNamesIndiv_plot | attributeLabelIndiv_plot | attributeDefinitionIndiv_plot
att_bigramToken_plot <- plot_spacer() | attributeLabelBigram_plot | attributeDefinitionBigram_plot
att_trigramToken_plot <- plot_spacer() | attributeLabelTrigram_plot | attributeDefinitionTrigram_plot
att_allTokens_plot <- (att_indivToken_plot) / (att_bigramToken_plot) / (att_trigramToken_plot) +
  plot_annotation(
    title = "50 most common attribute-level terms in the SASAP metadata corpus -- attributeNames, attributeLabels, & attributeDefinitions",
    subtitle = "Rows top to bottom: individual terms, bigrams, trigrams",
    caption = "NOTE: attributeNames are maintained in original form (i.e. not split and counted as bigrams/trigrams); \n ALSO, attributeLables are missing in many dataTables across the SASAP corpus"
  )
# ggsave(filename = here::here("figures", "term_frequencies", "attributeTermCounts_top50_plot.png"), plot = att_allTokens_plot, height = 25, width = 20)
