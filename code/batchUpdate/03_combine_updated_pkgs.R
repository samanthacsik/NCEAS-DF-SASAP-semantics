# title: combine all updated pkg PIDs
# author: "Sam Csik"
# date created: "2021-03-18"
# date edited: "2021-03-18"
# R version: 3.6.3
# input: "data/updated_pkgs/*
# output: 

##########################################################################################
# Summary 
##########################################################################################

# each run of the batch-update code generates a list of all new/old metadata and resource map PIDs, for reference
# these are saved individually to "data/updated_pkgs/*"
# this script combines all those individual files into one df
# read this back into script 10a.3_batch_update_setup.R to remove from list of pkgs that still need updating

##########################################################################################
# combine dfs and turn into vector of original metadata pids
##########################################################################################

# read in and combine
updated_pkgs <- list.files("data/updated_pkgs/", pattern = "*.csv", full.names = TRUE) %>% 
  lapply(read_csv) %>%
  bind_rows   

# get vector of original metadata PIDS
list_updated_pkgs <- updated_pkgs$old_metadataPID

# clean up environment
rm(updated_pkgs)
