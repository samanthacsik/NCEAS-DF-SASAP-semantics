# title: Identifying attributes to be annotated -- "place names"
# author: "Sam Csik"
# date created: "2021-02-23"
# date edited: "2021-02-23"
# R version: 3.6.3
# input: "data/queries/query2020-10-09/fullQuery_semAnnotations2020-10-09_attributes.csv"
# output: 

##########################################################################################
# Summary
##########################################################################################

# Identifying attributes related to "place names"

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

names <- attributes %>% 
  filter(str_detect(attributeDefinition, "(?i)name"))

##########################################################################################
# determine appropriate valueURIs
##########################################################################################

#############################
# name of sampled region
#############################

nameSampledRegion <- names %>% 
  filter(attributeDefinition %in% c("Name of sampled region", "Name of location where data was collected")) %>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/ECSO_00002768"),
         assigned_propertyURI = rep("tbd"),
         propertyURI_label = rep("tbd"),
         prefName = rep("study location name"),
         ontoName = rep("tbd"),
         grouping = rep("studyLocationName"),
         notes = rep("nane of sampled region"))


##########################################################################################
# combine and ensure no duplicates
##########################################################################################

all_name_atts <- rbind(nameSampledRegion)

remainder <- anti_join(names, all_name_atts)

# check that there are no duplicates
all_names <- all_name_atts %>% select(-assigned_valueURI, - assigned_propertyURI, -prefName, -ontoName, -grouping, -notes)
all_names_distinct <- all_name_atts %>% select(-assigned_valueURI, - assigned_propertyURI, -prefName, -ontoName, -grouping, -notes) %>% distinct()
isTRUE(length(all_names$attributeName) == length(all_names_distinct$attributeName))

# clean up global environment
rm(names, nameSampledRegion, remainder, all_names, all_names_distinct)
