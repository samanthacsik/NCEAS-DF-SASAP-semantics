# title: Identifying attributes to be annotated -- "fish girth"
# author: "Sam Csik"
# date created: "2021-07-16"
# date edited: "2021-07-16"
# R version: 3.6.3
# input: "data/queries/query2020-10-09/fullQuery_semAnnotations2020-10-09_attributes.csv"
# output: 

##########################################################################################
# Summary
##########################################################################################

# Identifying attributes related to "fish girth"

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
 
girth <- attributes %>% 
  filter(str_detect(attributeDefinition, "(?i)girth"))

##########################################################################################
# determine appropriate valueURIs
##########################################################################################

#############################
# girth
#############################

fishGirth <- girth %>% 
  filter(str_detect(attributeDefinition, "(?i)girth")) %>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/salmon_000777"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         propertyURI_label = rep("containsMeasurementsOfType"),
         prefName = rep("Girth of fish"),
         ontoName = rep("tbd"),
         grouping = rep("fishGirth"),
         notes = rep("girth of fish"))


##########################################################################################
# combine and ensure no duplicates
##########################################################################################

all_girth_atts <- rbind(fishGirth)

remainder <- anti_join(girth, all_girth_atts)

# check that there are no duplicates
all_girth <- all_girth_atts %>% select(-assigned_valueURI, - assigned_propertyURI, -prefName, -ontoName, -grouping, -notes)
all_girth_distinct <- all_girth_atts %>% select(-assigned_valueURI, - assigned_propertyURI, -grouping, -notes) %>% distinct()
isTRUE(length(all_girth$attributeName) == length(all_girth_distinct$attributeName))

# clean up global environment
rm(girth, fishGirth, all_girth_distinct, all_girth, remainder)
