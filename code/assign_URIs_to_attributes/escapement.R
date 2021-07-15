# title: Identifying attributes to be annotated -- "escapement"
# author: "Sam Csik"
# date created: "2021-02-04"
# date edited: "2021-02-04"
# R version: 3.6.3
# input: "data/queries/query2020-10-09/fullQuery_semAnnotations2020-10-09_attributes.csv"
# output: 

##########################################################################################
# Summary
##########################################################################################

# Identifying attributes related to "escapement"

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

escapement <- attributes %>% 
  filter(str_detect(attributeDefinition, "(?i)escapement value") |
         str_detect(attributeDefinition, "(?i)annual escapement") |
         str_detect(attributeDefinition, "(?i)number of fish escaping upstream") |
         attributeName == "COUNT")

##########################################################################################
# determine appropriate valueURIs
##########################################################################################

#############################
# annual escapement
#############################

annual_escapement <- escapement %>% 
  filter(attributeName %in% c("TotalEscapement", "Escapement", "REPORTED_ESCAPEMENT", "OFFICIAL_ESCAPEMENT") | 
         str_detect(attributeDefinition, "(?i)annual escapement")) %>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/salmon_000480"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         prefName = rep("Annual escapement count"),
         ontoName = rep("tbd"),
         grouping = rep("annual_escapement"),
         notes = rep("annual escapement counts")) 

#############################
# daily escapement
#############################

daily_escapement <- escapement %>% 
  filter(str_detect(attributeDefinition, "(?i)number of fish escaping upstream") |
         attributeName == "COUNT") %>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/salmon_000481"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         prefName = rep("Daily escapement count"),
         ontoName = rep("tbd"),
         grouping = rep("daily_escapement"),
         notes = rep("daily escapement counts")) 

##########################################################################################
# combine and ensure no duplicates
##########################################################################################

all_escapement_atts <- rbind(annual_escapement, daily_escapement)

remainder <- anti_join(escapement, all_escapement_atts)

# check that there are no duplicates
all_escapement <- all_escapement_atts %>% select(-assigned_valueURI, -assigned_propertyURI, -prefName, -ontoName, -grouping, -notes)
all_escapement_distinct <- all_escapement_atts %>% select(-assigned_valueURI, -assigned_propertyURI, -prefName, -ontoName, -grouping, -notes) %>% distinct()
isTRUE(length(all_escapement$attributeName) == length(all_escapement_distinct$attributeName))

# clean up global environment
rm(escapement, annual_escapement, daily_escapement, all_escapement, all_escapement_distinct, remainder)

