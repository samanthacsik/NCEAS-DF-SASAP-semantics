# title: 
# author: "Sam Csik"
# date created: "2021-02-03"
# date edited: "2021-02-03"
# R version: 3.6.3
# input: "data/queries/query2020-10-09/fullQuery_semAnnotations2020-10-09_attributes.csv"
# output: 

##########################################################################################
# Summary
##########################################################################################

# assess the number of unique attributeNames that exist across SASAP data holdings

##########################################################################################
# General Setup
##########################################################################################

##############################
# Load packages
##############################

library(tidyverse)

##############################
# Import data
##############################

attributes <- read_csv(here::here("data", "queries", "query2020-10-09", "fullQuery_semAnnotations2020-10-09_attributes.csv"))

##########################################################################################

##########################################################################################

##############################
# get counts of unique attributeNames
##############################

unique_attributeNames_counts <- attributes %>% 
  group_by(attributeName) %>% 
  count() %>% 
  arrange(-n)

##############################
# get some general groupings of atttribute types to work with
##############################

# species_related_atts <- unique_attributeNames_counts %>% 
#   filter(str_detect(attributeName, "(?i)species"))
# 
# location_related_atts <- unique_attributeNames_counts %>% 
#   filter(str_detect(attributeName, "(?i)location"))
# 
# date_related_atts <- unique_attributeNames_counts %>% 
#   filter(str_detect(attributeName, "(?i)date"))
# 
# country_related_atts <- unique_attributeNames_counts %>% 
#   filter(str_detect(attributeName, "(?i)country"))
# 
# age_related_atts <- unique_attributeNames_counts %>% 
#   filter(str_detect(attributeName, "(?i)age"))

##############################
# get remainder to be sorted
##############################

# sorted_atts <- rbind(species_related_atts, location_related_atts, date_related_atts)
# distinct_sorted_atts <- sorted_atts %>% 
#   distinct(attributeName)
# 
# remainder <- anti_join(unique_attributeNames_counts, sorted_atts) 

         