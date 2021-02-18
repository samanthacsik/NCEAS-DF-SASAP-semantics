# title: Identifying attributes to be annotated -- "gear"
# author: "Sam Csik"
# date created: "2021-02-04"
# date edited: "2021-02-04"
# R version: 3.6.3
# input: "data/queries/query2020-10-09/fullQuery_semAnnotations2020-10-09_attributes.csv"
# output: 

##########################################################################################
# Summary
##########################################################################################

# Identifying attributes related to "gear"

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

gear <- attributes %>% 
  filter(str_detect(attributeName, "(?i)gear") |
         str_detect(attributeDefinition, "(?i)equipment"))

##########################################################################################
# determine appropriate valueURIs
##########################################################################################

#############################
# ADFG gear code
#############################

ADFGgearCode <- gear %>% 
  filter(str_detect(attributeDefinition, "(?i)ADFG") |
         attributeName %in% c("gear_type")) %>% 
  mutate(assigned_valueURI = rep(""),
         assigned_propertyURI = rep(""),
         notes = rep("ADFG gear code")) 

#############################
# gear code
#############################

gearCode <- gear %>% 
  filter(attributeName %in% c("RecGear", "RelGear")) %>% 
  mutate(assigned_valueURI = rep(""),
         assigned_propertyURI = rep(""),
         notes = rep("gear code (defined in metadata)")) 

#############################
# sample collection gear
#############################

gearType <- gear %>% 
  filter(attributeName %in% c("gear", "Gear", "GEAR", "Gear_Type_Name", "GearType", "gearTypeID"),
         attributeDefinition != "Name of gear defined by ADFG gear code") %>% 
  mutate(assigned_valueURI = rep(""),
         assigned_propertyURI = rep(""),
         notes = rep("fishing/sampling gear")) 

##########################################################################################
# combine and ensure no duplicates
##########################################################################################

all_gear_atts <- rbind(ADFGgearCode, gearCode, gearType)

remainder <- anti_join(gear, all_gear_atts)

# check that there are no duplicates
all_gear <- all_gear_atts %>% select(-assigned_valueURI, -assigned_propertyURI, - notes)
all_gear_distinct <- all_gear_atts %>% select(-assigned_valueURI, -assigned_propertyURI, - notes) %>% distinct()
isTRUE(length(all_gear$attributeName) == length(all_gear_distinct$attributeName))

# clean up global environment
rm(gear, ADFGgearCode, gearCode, gearType, remainder, all_gear, all_gear_distinct)

         