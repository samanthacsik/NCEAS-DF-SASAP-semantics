# title: Identifying attributes to be annotated -- "UNKNOWN IDENTIFIERS"
# author: "Sam Csik"
# date created: "2021-02-17"
# date edited: "2021-02-17"
# R version: 3.6.3
# input: "data/queries/query2020-10-09/fullQuery_semAnnotations2020-10-09_attributes.csv"
# output: 

##########################################################################################
# Summary
##########################################################################################

# Identifying attributes related to "UNKNOWN IDENTIFIERS"

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

random_ids <- attributes %>% 
  filter(attributeName %in% c("AKOATS_ID"))

##########################################################################################
# determine appropriate valueURIs
##########################################################################################

#############################
# UAA Alaksa Center for Conservation Science (AKOATS) identifier (unclear what this ID refers to exactly...)
#############################

AKOATS_id <- random_ids %>% 
  filter(attributeName %in% c("AKOATS_ID")) %>% 
  mutate(assigned_valueURI = rep("tbd"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         prefName = rep("tbd"),
         ontoName = rep("tbd"),
         grouping = rep("AKOATS_id"),
         notes = rep("unique UAA Alaska Center for Conservation Science identifier"))

##########################################################################################
# combine and ensure no duplicates
##########################################################################################

all_randomID_atts <- rbind(AKOATS_id)

remainder <- anti_join(random_ids, all_randomID_atts)

# check that there are no duplicates
all_randomIDs <- all_randomID_atts %>% select(-assigned_valueURI, - assigned_propertyURI, -prefName, -ontoName, -grouping, -notes)
all_randomIDs_distinct <- all_randomID_atts %>% select(-assigned_valueURI, - assigned_propertyURI, -prefName, -ontoName, -grouping, -notes) %>% distinct()
isTRUE(length(all_randomIDs$attributeName) == length(all_randomIDs_distinct$attributeName))

# clean up global environment
rm(random_ids, AKOATS_id, remainder, all_randomIDs, all_randomIDs_distinct)
