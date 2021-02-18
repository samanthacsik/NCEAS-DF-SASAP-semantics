# title: Identifying attributes to be annotated -- "age"
# author: "Sam Csik"
# date created: "2021-02-17"
# date edited: "2021-02-17"
# R version: 3.6.3
# input: "data/queries/query2020-10-09/fullQuery_semAnnotations2020-10-09_attributes.csv"
# output: 

##########################################################################################
# Summary
##########################################################################################

# Identifying attributes related to "age"
# NEED TO COME BACK TO THIS -- AGE OF COMMUNITY MEMBERS & PERMIT HOLDERS

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

age <- attributes %>% 
  filter(str_detect(attributeName, "(?i)age") |
         str_detect(attributeDefinition, "(?i)circuli"))

##########################################################################################
# determine appropriate valueURIs
##########################################################################################

#############################
# age of fish
#############################

fishAge <- age %>% 
  filter(attributeName %in% c("age")) %>% 
  mutate(assigned_valueURI = rep(""),
         assigned_propertyURI = rep(""),
         notes = rep("age of salmon"))

freshwaterAge <- age %>% 
  filter(attributeName %in% c("ageFresh", "Fresh Water Age", "fresh_water_age", "Fresh.Water.Age", "FreshwaterAge", "FW_AGE")) %>% 
  mutate(assigned_valueURI = rep(""),
         assigned_propertyURI = rep(""),
         notes = rep("fresh water age of salmon"))

saltwaterAge<- age %>% 
  filter(attributeName %in% c("ageSalt", "Salt Water Age", "salt_water_age", "Salt.Water.Age", "SW_AGE", "OceanAge")) %>% 
  mutate(assigned_valueURI = rep(""),
         assigned_propertyURI = rep(""),
         notes = rep("salt water age of salmon"))

fishAgeEuroNotation <- age %>% 
  filter(attributeName %in% c("AGE_EUROPEAN", "AgeEuropean")) %>% 
  mutate(assigned_valueURI = rep(""),
         assigned_propertyURI = rep(""),
         notes = rep("age of salmon in European notation"))

#############################
# age of fish (error)
#############################

errorAgeCode <- age %>% 
  filter(attributeName %in% c("Age.Error", "ageError", "AGE_ERROR_CODE", "age_error", "Age Error")) %>% 
  filter(attributeDefinition != "Description of age error: Otolith, Inverted, Regenerated, Illegible, Missing, Reabsorbed, Wrong Species, or Not Preferred") %>% 
  mutate(assigned_valueURI = rep(""),
         assigned_propertyURI = rep(""),
         notes = rep("code for error in salmon age"))

errorAgeDescription <- age %>% 
  filter(attributeDefinition == "Description of age error: Otolith, Inverted, Regenerated, Illegible, Missing, Reabsorbed, Wrong Species, or Not Preferred") %>% 
  mutate(assigned_valueURI = rep(""),
         assigned_propertyURI = rep(""),
         notes = rep("description of error in salmon age"))

#############################
# distance between circuli
#############################

circuliDist <- age %>% 
  filter(str_detect(attributeDefinition, "(?i)circuli")) %>% 
  mutate(assigned_valueURI = rep(""),
         assigned_propertyURI = rep(""),
         notes = rep("distance between scale circuli"))

##########################################################################################
# combine and ensure no duplicates
##########################################################################################

all_age_atts <- rbind(fishAge, freshwaterAge, saltwaterAge, fishAgeEuroNotation, errorAgeCode, errorAgeDescription, circuliDist)

remainder <- anti_join(age, all_age_atts)

# check that there are no duplicates
all_age <- all_age_atts %>% select(-assigned_valueURI, - assigned_propertyURI, -notes)
all_age_distinct <- all_age_atts %>% select(-assigned_valueURI, - assigned_propertyURI, -notes) %>% distinct()
isTRUE(length(all_age$attributeName) == length(all_age_distinct$attributeName))

# clean up global environment
rm(age, fishAge, freshwaterAge, saltwaterAge, fishAgeEuroNotation, errorAgeCode, errorAgeDescription, circuliDist, all_age_distinct, all_age, remainder)

