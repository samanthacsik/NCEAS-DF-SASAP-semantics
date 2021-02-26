# title: Identifying attributes to be annotated -- "demographic data"
# author: "Sam Csik"
# date created: "2021-02-25"
# date edited: "2021-02-25"
# R version: 3.6.3
# input: "data/queries/query2020-10-09/fullQuery_semAnnotations2020-10-09_attributes.csv"
# output: 

##########################################################################################
# Summary
##########################################################################################

# Identifying attributes related to "demographic data"
# COME BACK TO THIS ONE

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
  filter(attributeName %in% c("Labor.Force", "Labor.Force.Participation.Rate",
                              "laotian", "korean"))
  filter(str_detect(attributeName, "(?i)"))

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
all_area <- all_area_atts %>% select(-assigned_valueURI, - assigned_propertyURI, -prefName, -ontoName, -grouping, -notes)
all_area_distinct <- all_area_atts %>% select(-assigned_valueURI, - assigned_propertyURI, -prefName, -ontoName, -grouping, -notes) %>% distinct()
isTRUE(length(all_area$attributeName) == length(all_area_distinct$attributeName))

# clean up global environment
rm(area, remainder, all_area, all_area_distinct)