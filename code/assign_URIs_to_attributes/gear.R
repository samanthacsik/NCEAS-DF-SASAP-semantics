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
         str_detect(attributeName, "(?i)mesh") |
         str_detect(attributeDefinition, "(?i)equipment"))

##########################################################################################
# determine appropriate valueURIs
##########################################################################################

#############################
# mesh size
#############################

meshSize <- gear %>% 
  filter(str_detect(attributeName, "(?i)mesh")) %>% 
  mutate(assigned_valueURI = rep("tbd"),
         assigned_propertyURI = rep("tbd"),
         propertyURI_label = rep("tbd"),
         prefName = rep("tbd"),
         ontoName = rep("tbd"),
         grouping = rep("meshSize"),
         notes = rep("net mesh size")) 

#############################
# ADFG gear code
#############################

ADFGgearCode <- gear %>% 
  filter(str_detect(attributeDefinition, "(?i)ADFG") |
         attributeName %in% c("gear_type")) %>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/salmon_000527"),
         assigned_propertyURI = rep("tbd"),
         propertyURI_label = rep("tbd"),
         prefName = rep("ADF&G gear code"),
         ontoName = rep("tbd"),
         grouping = rep("ADFGgearCode"),
         notes = rep("ADFG gear code")) 

#############################
# gear code
#############################

gearCode <- gear %>% 
  filter(attributeName %in% c("RecGear", "RelGear")) %>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/salmon_000526"),
         assigned_propertyURI = rep("tbd"),
         propertyURI_label = rep("tbd"),
         prefName = rep("Fishing gear code"),
         ontoName = rep("tbd"),
         grouping = rep("gearCode"),
         notes = rep("gear code (defined in metadata)")) 

#############################
# sample collection gear
#############################

gearType <- gear %>% 
  filter(attributeName %in% c("gear", "Gear", "GEAR", "Gear_Type_Name", "GearType", "gearTypeID"),
         attributeDefinition != "Name of gear defined by ADFG gear code") %>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/salmon_00142"),
         assigned_propertyURI = rep("tbd"),
         propertyURI_label = rep("tbd"),
         prefName = rep("Fishing gear type"),
         ontoName = rep("tbd"),
         grouping = rep("gearType"),
         notes = rep("fishing/sampling gear")) 

##########################################################################################
# combine and ensure no duplicates
##########################################################################################

all_gear_atts <- rbind(ADFGgearCode, gearCode, gearType, meshSize)

remainder <- anti_join(gear, all_gear_atts)

# check that there are no duplicates
all_gear <- all_gear_atts %>% select(-assigned_valueURI, -assigned_propertyURI, -prefName, -ontoName, -grouping, -notes)
all_gear_distinct <- all_gear_atts %>% select(-assigned_valueURI, -assigned_propertyURI, -prefName, -ontoName, -grouping, -notes) %>% distinct()
isTRUE(length(all_gear$attributeName) == length(all_gear_distinct$attributeName))

# clean up global environment
rm(gear, ADFGgearCode, gearCode, gearType, remainder, all_gear, all_gear_distinct, meshSize)

         