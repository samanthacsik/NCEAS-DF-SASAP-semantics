# title: Identifying attributes to be annotated -- "fish counts"
# author: "Sam Csik"
# date created: "2021-02-09"
# date edited: "2021-02-09"
# R version: 3.6.3
# input: "data/queries/query2020-10-09/fullQuery_semAnnotations2020-10-09_attributes.csv"
# output: 

##########################################################################################
# Summary
##########################################################################################

# Identifying attributes related to "species"

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

source(here::here("code", "05a_exploring_attributes.R"))

#############################
# get data subset
#############################

fishCounts <- attributes %>% 
  filter(str_detect(attributeDefinition, "(?i)the species ratio") |
         str_detect(attributeDefinition, "(?i)harvested in") |
         str_detect(attributeDefinition, "(?i)number of fish in"))

##########################################################################################
# determine appropriate valueURIs
##########################################################################################

#############################
# annual harvested
#############################

annual_harvested <- fishCounts %>% 
  filter(str_detect(attributeDefinition, "(?i)harvested in")) %>% 
  mutate(assigned_valueURI = rep(""),
         assigned_propertyURI = rep(""),
         notes = rep("number of salmon (by species) harvested annually"))

#############################
# annual harvested
#############################

species_ratio <- fishCounts %>% 
  filter(str_detect(attributeDefinition, "(?i)the species ratio")) %>% 
  mutate(assigned_valueURI = rep(""),
         assigned_propertyURI = rep(""),
         notes = rep("species ratio"))

#############################
# fish (individual?) counts (by region)
#############################

counts <- fishCounts %>% 
  filter(str_detect(attributeDefinition, "(?i)number of fish in")) %>% 
  mutate(assigned_valueURI = rep(""),
         assigned_propertyURI = rep(""),
         notes = rep("fish counts (by region)"))

##########################################################################################
# combine and ensure no duplicates
##########################################################################################

all_fishCounts_atts <- rbind(annual_harvested, species_ratio, counts)

remainder <- anti_join(fishCounts, all_fishCounts_atts)

# check that there are no duplicates
all_fishCounts <- all_fishCounts_atts %>% select(-assigned_valueURI,-assigned_propertyURI, -notes)
all_fishCounts_distinct <- all_fishCounts_atts %>% select(-assigned_valueURI, -assigned_propertyURI, -notes) %>% distinct()
isTRUE(length(all_fishCounts$attributeName) == length(all_fishCounts_distinct$attributeName))

# clean up global environment
rm(annual_harvested, species_ratio, counts, remainder, all_fishCounts, all_fishCounts_distinct, fishCounts)


