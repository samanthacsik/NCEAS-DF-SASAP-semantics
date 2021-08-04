# title: Identifying attributes to be annotated -- "fish age"
# author: "Sam Csik"
# date created: "2021-02-17"
# date edited: "2021-02-17"
# R version: 3.6.3
# input: "data/queries/query2020-10-09/fullQuery_semAnnotations2020-10-09_attributes.csv"
# output: 

##########################################################################################
# Summary
##########################################################################################

# Identifying attributes related to "fish age"

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
         str_detect(attributeDefinition, "(?i)circuli") |
         attributeName %in% c("error_code"))

##########################################################################################
# determine appropriate valueURIs
##########################################################################################

#############################
# age of fish
#############################

fishAge <- age %>% 
  filter(attributeName %in% c("age")) %>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/salmon_00187"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         propertyURI_label = rep("containsMeasurementsOfType"),
         prefName = rep("Total age"),
         ontoName = rep("tbd"),
         grouping = rep("fishAge"),
         notes = rep("age of salmon; could also potentially use http://purl.dataone.org/odo/ECSO_00000656"))

freshwaterAge <- age %>% 
  filter(attributeName %in% c("ageFresh", "Fresh Water Age", "fresh_water_age", "Fresh.Water.Age", "FreshwaterAge", "FW_AGE")) %>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/salmon_00188"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         propertyURI_label = rep("containsMeasurementsOfType"),
         prefName = rep("Freshwater age"),
         ontoName = rep("tbd"),
         grouping = rep("freshwaterAge"),
         notes = rep("fresh water age of salmon"))

saltwaterAge<- age %>% 
  filter(attributeName %in% c("ageSalt", "Salt Water Age", "salt_water_age", "Salt.Water.Age", "SW_AGE", "OceanAge")) %>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/salmon_00189"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         propertyURI_label = rep("containsMeasurementsOfType"),
         prefName = rep("Saltwater age"),
         ontoName = rep("tbd"),
         grouping = rep("saltwaterAge"),
         notes = rep("salt water age of salmon"))

fishAgeEuroNotation <- age %>% 
  filter(attributeName %in% c("AGE_EUROPEAN", "AgeEuropean")) %>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/salmon_00200"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         propertyURI_label = rep("containsMeasurementsOfType"),
         prefName = rep("Fish age expressed in European notation"),
         ontoName = rep("tbd"),
         grouping = rep("fishAgeEuroNotation"),
         notes = rep("age of salmon in European notation"))

#############################
# age of fish (error)
#############################

errorAgeCode <- age %>% 
  filter(attributeName %in% c("Age.Error", "ageError", "AGE_ERROR_CODE", "age_error", "Age Error", "error_code")) %>% 
  filter(attributeDefinition != "Description of age error: Otolith, Inverted, Regenerated, Illegible, Missing, Reabsorbed, Wrong Species, or Not Preferred") %>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/salmon_000681"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         propertyURI_label = rep("containsMeasurementsOfType"),
         prefName = rep("Age error code"),
         ontoName = rep("tbd"),
         grouping = rep("errorAgeCode"),
         notes = rep("code for error in salmon age"))

errorAgeDescription <- age %>% 
  filter(attributeDefinition == "Description of age error: Otolith, Inverted, Regenerated, Illegible, Missing, Reabsorbed, Wrong Species, or Not Preferred") %>% 
  mutate(assigned_valueURI = rep("tbd"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         propertyURI_label = rep("containsMeasurementsOfType"),
         prefName = rep("tbd"),
         ontoName = rep("tbd"),
         grouping = rep("errorAgeDescription"),
         notes = rep("description of error in salmon age"))

#############################
# distance between circuli
#############################

circuliDist <- age %>% 
  filter(str_detect(attributeDefinition, "(?i)circuli")) %>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/salmon_00235"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         propertyURI_label = rep("containsMeasurementsOfType"),
         prefName = rep("Distance between scale circuli"),
         ontoName = rep("tbd"),
         grouping = rep("circuliDist"),
         notes = rep("distance between scale circuli; growth rate"))

##########################################################################################
# combine and ensure no duplicates
##########################################################################################

all_age_atts <- rbind(fishAge, freshwaterAge, saltwaterAge, fishAgeEuroNotation, errorAgeCode, errorAgeDescription, circuliDist)

remainder <- anti_join(age, all_age_atts)

# check that there are no duplicates
all_age <- all_age_atts %>% select(-assigned_valueURI, - assigned_propertyURI, -prefName, -ontoName, -grouping, -notes)
all_age_distinct <- all_age_atts %>% select(-assigned_valueURI, - assigned_propertyURI, -prefName, -ontoName, -grouping, -notes) %>% distinct()
isTRUE(length(all_age$attributeName) == length(all_age_distinct$attributeName))

# clean up global environment
rm(age, fishAge, freshwaterAge, saltwaterAge, fishAgeEuroNotation, errorAgeCode, errorAgeDescription, circuliDist, all_age_distinct, all_age, remainder)

