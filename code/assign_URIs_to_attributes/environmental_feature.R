# title: Identifying attributes to be annotated -- "environmental features"
# author: "Sam Csik"
# date created: "2021-05-12"
# date edited: "2021-05-12"
# R version: 3.6.3
# input: "data/queries/query2020-10-09/fullQuery_semAnnotations2020-10-09_attributes.csv"
# output: 

##########################################################################################
# Summary
##########################################################################################

# Identifying attributes related to "environmental features"

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

envFeat <- attributes %>% 
  filter(attributeName %in% c("watertype", "Waterbody_type", "stream"))

#########################################################################################
# determine appropriate valueURIs
##########################################################################################

#############################
# waterbody type
#############################

waterbody_type <- envFeat %>% 
  filter(attributeName %in% c("Waterbody_type")) %>% 
  mutate(assigned_valueURI = rep("tbd"),
         assigned_propertyURI = rep("tbd"),
         prefName = rep("tbd"),
         ontoName = rep("tbd"),
         grouping = rep("waterbody_type"),
         notes = rep("waterbody type being monitored"))


##########################################################################################
# combine and ensure no duplicates
##########################################################################################

all_envFeat_atts <- rbind(waterbody_type)

remainder <- anti_join(envFeat, all_envFeat_atts)

# check that there are no duplicates
all_envFeat <- all_envFeat_atts %>% select(-assigned_valueURI,-assigned_propertyURI, -prefName, -ontoName, -grouping, -notes)
all_envFeat_distinct <- all_envFeat_atts %>% select(-assigned_valueURI, -assigned_propertyURI, -prefName, -ontoName, -grouping, -notes) %>% distinct()
isTRUE(length(all_envFeat$attributeName) == length(all_envFeat_distinct$attributeName))

# clean up global environment
rm(waterbody_type, remainder, all_envFeat, all_envFeat_distinct)
