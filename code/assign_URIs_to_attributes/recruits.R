# title: Identifying attributes to be annotated -- "recruits"
# author: "Sam Csik"
# date created: "2021-02-04"
# date edited: "2021-02-04"
# R version: 3.6.3
# input: "data/queries/query2020-10-09/fullQuery_semAnnotations2020-10-09_attributes.csv"
# output: 

##########################################################################################
# Summary
##########################################################################################

# Identifying attributes related to "recruits"

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

recruits <- attributes %>% 
  filter(str_detect(attributeDefinition, "(?i)recruits"))

##########################################################################################
# determine appropriate valueURIs
##########################################################################################

#############################
# total recruits
#############################

total_recruits <- recruits %>% 
  filter(attributeName %in% c("TotalRecruits", "Recruits")) %>% 
  mutate(assigned_valueURI = rep("tbd"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         prefName = rep("tbd"),
         ontoName = rep("tbd"),
         grouping = rep("total_recruits"),
         notes = rep("total number of recruits (across age classes)"))

#############################
# recruits per spawner
#############################

num_recruits_per_spawner <- recruits %>% 
  filter(attributeName == "spawner") %>% 
  mutate(assigned_valueURI = rep("tbd"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         prefName = rep("tbd"),
         ontoName = rep("tbd"),
         grouping = rep("num_recruits_per_spawner"),
         notes = rep("number of recruits per spawner"))

#############################
# recruits by age class
#############################

tempA <- recruits %>% 
  filter(str_detect(attributeDefinition, "(?i)number of age"))

tempB <- recruits %>% 
  filter(str_detect(attributeDefinition, "(?i)number of recruits in"))

tempC <- recruits %>% 
  filter(str_detect(attributeDefinition, "(?i)number of total age"))

num_recruits_by_ageClass <- rbind(tempA, tempB, tempC) %>% 
  mutate(assigned_valueURI = rep("tbd"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         prefName = rep("tbd"),
         ontoName = rep("tbd"),
         grouping = rep("num_recruits_by_ageClass"),
         notes = rep("number of recruits per age class"))

##########################################################################################
# combine and ensure no duplicates
##########################################################################################

all_recruit_atts <- rbind(total_recruits, num_recruits_per_spawner, num_recruits_by_ageClass)

remainder <- anti_join(recruits, all_recruit_atts)

# check that there are no duplicates
all_recruits <- all_recruit_atts %>% select(-assigned_valueURI, - assigned_propertyURI, -prefName, -ontoName, -grouping, -notes)
all_recruits_distinct <- all_recruit_atts %>% select(-assigned_valueURI, - assigned_propertyURI, -prefName, -ontoName, -grouping, -notes) %>% distinct()
isTRUE(length(all_recruits$attributeName) == length(all_recruits_distinct$attributeName))

# clean up global environment
rm(recruits, total_recruits, num_recruits_per_spawner, tempA, tempB, tempC, num_recruits_by_ageClass, remainder, all_recruits, all_recruits_distinct)