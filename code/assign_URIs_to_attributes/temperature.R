# title: Identifying attributes to be annotated -- "temperature"
# author: "Sam Csik"
# date created: "2021-02-03"
# date edited: "2021-02-04"
# R version: 3.6.3
# input: "data/queries/query2020-10-09/fullQuery_semAnnotations2020-10-09_attributes.csv"
# output: 

##########################################################################################
# Summary
##########################################################################################

# Identifying attributes related to "temperature"

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

temp <- attributes %>% 
  filter(str_detect(attributeUnit, "(?i)celsius")) 

unique_identifiers <- unique(temp$identifier)

##########################################################################################
# determine appropriate valueURIs
##########################################################################################

#############################
# air temperature: http://purl.dataone.org/odo/ECSO_00001225
  # use predicate, 'average value': http://purl.obolibrary.org/obo/OBI_0000679
#############################

avg_air_temp <- temp %>%
  filter(identifier == "doi:10.5063/F1MK6B60") %>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/ECSO_00001225"),
         assigned_propertyURI = rep("tbd"),
         prefName = rep("Air Temperature"),
         ontoName = rep("The Ecosystem Ontology"),
         grouping = rep("avg_air_temp"),
         notes = rep("AVERAGE air temperature; propertyURI = containsMeanMeasurementsOfType?"))

#############################
# stream temperature 
#############################

stream_temp <- temp %>%
  filter(attributeDefinition %in% c("Stream temperature, measured in degrees C",
                                    "temperature, measured in degrees Celsius",
                                    "Stream temperature, measured in degrees Celsius",
                                    "temperature measured") |
           attributeName %in% c("HoboTemp", "sondeTemp")) %>% 
  mutate(assigned_valueURI = rep("tbd"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         prefName = rep("tbd"),
         ontoName = rep("tbd"),
         grouping = rep("stream_temp"),
         notes = rep("stream temp; ECSO has term for 'river temp' but not 'stream'"))

max_stream_temp <- temp %>% 
  filter(attributeName == "max_temp") %>% 
  mutate(assigned_valueURI = rep("tbd"),
         assigned_propertyURI = rep("tbd"),
         prefName = rep("tbd"),
         ontoName = rep("tbd"),
         grouping = rep("max_stream_temp"),
         notes = rep("MAX stream temp; propertyURI = containsMaximumMeasurementsOfType?"))

min_stream_temp <- temp %>% 
  filter(attributeName == "min_temp") %>% 
  mutate(assigned_valueURI = rep("tbd"),
         assigned_propertyURI = rep("tbd"),
         prefName = rep("tbd"),
         ontoName = rep("tbd"),
         grouping = rep("min_stream_temp"),
         notes = rep("MIN stream temp; propertyURI = containsMinimumnMeasurementsOfType?"))

mean_stream_temp <- temp %>% 
  filter(attributeName == "mean_temp") %>% 
  mutate(assigned_valueURI = rep("tbd"),
         assigned_propertyURI = rep("tbd"),
         prefName = rep("tbd"),
         ontoName = rep("tbd"),
         grouping = rep("mean_stream_temp"),
         notes = rep("AVERAGE stream temp; propertyURI = containsAverageMeasurementsOfType?"))

stream_temp_TBD <- temp %>%
  filter(attributeName %in% c("Hobo_Sonde", "ABS_diff")) %>% 
  mutate(assigned_valueURI = rep("tbd"),
         assigned_propertyURI = rep("tbd"),
         prefName = rep("tbd"),
         ontoName = rep("tbd"),
         grouping = rep("stream_temp_TBD"),
         notes = rep("difference between different instrument temperature meausurements"))

##########################################################################################
# combine and ensure no duplicates
##########################################################################################

all_temp_atts <- rbind(avg_air_temp, stream_temp, max_stream_temp, min_stream_temp, mean_stream_temp, stream_temp_TBD)

remainder <- anti_join(temp, all_temp_atts)

# check that there are no duplicates
all_temp <- all_temp_atts %>% select(-assigned_valueURI, -assigned_propertyURI, -prefName, -ontoName, -grouping, -notes)
all_temp_distinct <- all_temp_atts %>% select(-assigned_valueURI, -assigned_propertyURI, -prefName, -ontoName, -grouping, -notes) %>% distinct()
isTRUE(length(all_temp$attributeName) == length(all_temp_distinct$attributeName))

# clean up global environment
rm(temp, unique_identifiers, avg_air_temp, stream_temp, max_stream_temp, min_stream_temp, mean_stream_temp, stream_temp_TBD, remainder, all_temp, all_temp_distinct)
