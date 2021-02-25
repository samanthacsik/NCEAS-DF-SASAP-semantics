# title: Identifying attributes to be annotated -- "area/location"
# author: "Sam Csik"
# date created: "2021-02-23"
# date edited: "2021-02-23"
# R version: 3.6.3
# input: "data/queries/query2020-10-09/fullQuery_semAnnotations2020-10-09_attributes.csv"
# output: 

##########################################################################################
# Summary
##########################################################################################

# Identifying attributes related to "area/location"

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

area <- attributes %>% 
  filter(str_detect(attributeName, "(?i)area"))

##########################################################################################
# determine appropriate valueURIs
##########################################################################################

#############################
# 
#############################

##########################################################################################
# combine and ensure no duplicates
##########################################################################################

all_area_atts <- rbind()

remainder <- anti_join(area, all_area_atts)

# check that there are no duplicates
all_area <- all_area_atts %>% select(-assigned_valueURI, - assigned_propertyURI, -notes)
all_area_distinct <- all_area_atts %>% select(-assigned_valueURI, - assigned_propertyURI, -notes) %>% distinct()
isTRUE(length(all_area$attributeName) == length(all_area_distinct$attributeName))

# clean up global environment
rm(area, remainder, all_area, all_area_distinct)
