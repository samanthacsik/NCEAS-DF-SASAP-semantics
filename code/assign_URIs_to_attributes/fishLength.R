# title: Identifying attributes to be annotated -- "fish length"
# author: "Sam Csik"
# date created: "2021-02-25"
# date edited: "2021-02-"25"
# R version: 3.6.3
# input: "data/queries/query2020-10-09/fullQuery_semAnnotations2020-10-09_attributes.csv"
# output: 

##########################################################################################
# Summary
##########################################################################################

# Identifying attributes related to "fish length"

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

length <- attributes %>% 
  filter(str_detect(attributeDefinition, "(?i)length"),
         !attributeDefinition %in% c("Length of the vessel"),
         !attributeName %in% c("SHAPE_Leng", "Shape_Length", "n", "CASING_STICKUP", "loanTerm_Years"))

# write_csv(length, here::here("data/sorted_attributes/manual_fish_length_assignments/fishLengths.csv"))

# downloaded data and manually assessed for length types -- notes here
length_notes <- read_csv(here::here("data/sorted_attributes/manual_fish_length_assignments/fishLengths.csv")) %>% select(-X11)

##########################################################################################
# determine appropriate valueURIs
##########################################################################################

# (GENERIC) length: http://ecoinformatics.org/oboe/oboe.1.2/oboe-characteristics.owl#Length

#############################
# TEMPORARY (TO REMOVE FROM MASTER_LIST)
#############################

# temp_lengths <- length %>% 
#   mutate(assigned_valueURI = rep("tbd"),
#          assigned_propertyURI = rep("tbd"),
#          propertyURI_label = rep("tbd"),
#          prefName = rep("tbd"),
#          ontoName = rep("tbd"),
#          grouping = rep("fishLengths"),
#          notes = rep("fish length measurement types"))

length_value <- length %>% 
  filter(attributeName %in% c("length", "Length", "RecLength", "RelLength", "LENGTH_MM")) %>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/salmon_000127"), # verified v0.2.1
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         propertyURI_label = rep("containsMeasurementsOfType"),
         prefName = rep("Fish length measurement type"),
         ontoName = rep("tbd"),
         grouping = rep("fishLengths_measurementValue"),
         notes = rep("fish lengths (values)"))

length_type <- length %>% 
  filter(attributeName %in% c("Type_of_length_measurement", "LengthType", "lengthMeasurementType", 
                              "Length.Measurement.Type", "LENGTH_TYPE", "length_type", 
                              "length_measurement_type", "Length Measurement Type")) %>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/salmon_000630"), # MAY NEED TO CHANGE THIS
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         propertyURI_label = rep("containsMeasurementsOfType"),
         prefName = rep("Fish length determination method"),
         ontoName = rep("tbd"),
         grouping = rep("fishLengths_measurementMethod"),
         notes = rep("fish length measurement types"))

##########################################################################################
# combine and ensure no duplicates
##########################################################################################

all_length_atts <- rbind(length_value, length_type)

remainder <- anti_join(length, all_length_atts)

# check that there are no duplicates
all_lengths <- all_length_atts %>% select(-assigned_valueURI, - assigned_propertyURI, -prefName, -ontoName, -grouping,  -notes)
all_lengths_distinct <- all_length_atts %>% select(-assigned_valueURI, - assigned_propertyURI, -prefName, -ontoName, -grouping, -notes) %>% distinct()
isTRUE(length(all_lengths$attributeName) == length(all_lengths_distinct$attributeName))

# clean up global environment
rm(temp_lengths, all_lengths_distinct, all_lengths, remainder, length, length_notes)



