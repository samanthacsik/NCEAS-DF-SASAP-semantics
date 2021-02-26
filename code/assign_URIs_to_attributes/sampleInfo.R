# title: Identifying attributes to be annotated -- "sample information"
# author: "Sam Csik"
# date created: "2021-02-17"
# date edited: "2021-02-17"
# R version: 3.6.3
# input: "data/queries/query2020-10-09/fullQuery_semAnnotations2020-10-09_attributes.csv"
# output: 

##########################################################################################
# Summary
##########################################################################################

# Identifying attributes related to "sample information"
# NOTE: dates/times of sample collection are sorted in the 'dates.R' script rather than here

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

sample_info <- attributes %>% 
  filter(str_detect(attributeName, "(?i)sample") |
         str_detect(attributeDefinition, "(?i)sample")) %>% 
  filter(!attributeName %in% c("Date", "sampleDate", "SampleDate"))
  
##########################################################################################
# determine appropriate valueURIs
##########################################################################################

#############################
# fish sample identifier
#############################

fishSampleID <- sample_info %>% 
  filter(attributeDefinition %in% c("Numeric value assigned to a sample taken from a fish on a particular date")) %>% 
  mutate(assigned_valueURI = rep("tbd"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         prefName = rep("tbd"),
         ontoName = rep("tbd"),
         grouping = rep("fishSampleID"),
         notes = rep("fish sample identifier"))

#############################
# sample location identifier
#############################

location <- sample_info %>% 
  filter(str_detect(attributeName, "(?i)location")) %>% 
  mutate(assigned_valueURI = rep("tbd"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         prefName = rep("tbd"),
         ontoName = rep("tbd"),
         grouping = rep("location"),
         notes = rep("location where sample was collected"))

##########################################################################################
# combine and ensure no duplicates
##########################################################################################

all_sample_atts <- rbind(fishSampleID, location)

remainder <- anti_join(sample_info, all_sample_atts)

# check that there are no duplicates
all_sample <- all_sample_atts %>% select(-assigned_valueURI, - assigned_propertyURI, -prefName, -ontoName, -grouping, -notes)
all_sample_distinct <- all_sample_atts %>% select(-assigned_valueURI, - assigned_propertyURI, -prefName, -ontoName, -grouping, -notes) %>% distinct()
isTRUE(length(all_sample$attributeName) == length(all_sample_distinct$attributeName))

# clean up global environment
rm(sample_info, remainder, all_sample, all_sample_distinct)
