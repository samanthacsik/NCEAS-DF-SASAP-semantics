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
# first-pass exploration
##########################################################################################

##############################
# get counts of unique attributeNames
##############################

unique_attributeNames_counts <- attributes %>% 
  group_by(attributeName) %>% 
  count() %>% 
  arrange(-n)

         