# title: communities and waterbodies
# author: "Sam Csik"
# date created: "2021-04-08"
# date edited: "2021-04-08"
# R version: 3.6.3
# input: "data/queries/query_SASAPSites_2021-04-08.csv"
# output: 

##########################################################################################
# Summary
##########################################################################################

# 

##########################################################################################
# General Setup
##########################################################################################

##############################
# Load packages
##############################

library(tidyverse)
library(janitor)

##############################
# Import data
##############################

sasap_sites <- read_csv(here::here("data", "queries", "query_SASAPSites_2021-04-08", "query_SASAPSites_CLEANED_2021-04-08.csv"))

##########################################################################################
# tidy data and get counts
##########################################################################################

sasap_site_counts <- sasap_sites %>% 
  mutate(sites_lower = str_to_lower(sites_sep)) %>% 
  select(sites_lower) %>% 
  group_by(sites_lower) %>% 
  count() %>% 
  arrange(-n)

# write_csv(sasap_site_counts, here::here("data", "queries", "query_SASAPSites_2021-04-08", "sasap_site_counts.csv"))  
