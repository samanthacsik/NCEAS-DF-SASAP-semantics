# title: Identifying attributes to be annotated -- "permits"
# author: "Sam Csik"
# date created: "2021-02-09"
# date edited: "2021-02-09"
# R version: 3.6.3
# input: "data/queries/query2020-10-09/fullQuery_semAnnotations2020-10-09_attributes.csv"
# output: 

##########################################################################################
# Summary
##########################################################################################

# Identifying attributes related to "permits"

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

permits <- attributes %>% 
  filter(str_detect(attributeDefinition, "(?i)permit"))


##########################################################################################
# determine appropriate valueURIs
##########################################################################################

#############################
# permits (all)
#############################

temp <- permits %>% 
  mutate(assigned_valueURI = rep(""),
         assigned_propertyURI = rep(""),
         notes = rep("temp; have not been sorted yet"))

##########################################################################################
# combine and ensure no duplicates
##########################################################################################

all_permit_atts <- rbind(temp)

remainder <- anti_join(permits, all_permit_atts)

# check that there are no duplicates
all_permits <- all_permit_atts %>% select(-assigned_valueURI,-assigned_propertyURI, -notes)
all_permits_distinct <- all_permit_atts %>% select(-assigned_valueURI, -assigned_propertyURI, -notes) %>% distinct()
isTRUE(length(all_permits$attributeName) == length(all_permits_distinct$attributeName))

# clean up global environment
rm(permits, remainder, all_permits, all_permits_distinct)

  
