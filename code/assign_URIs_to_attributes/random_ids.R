# title: Identifying attributes to be annotated -- "identifiers"
# author: "Sam Csik"
# date created: "2021-02-17"
# date edited: "2021-02-17"
# R version: 3.6.3
# input: "data/queries/query2020-10-09/fullQuery_semAnnotations2020-10-09_attributes.csv"
# output: 

##########################################################################################
# Summary
##########################################################################################

# Identifying attributes related to "identifiers"

# COME BACK TO THIS: lots of duplicate terms and haven't yet figured out why 12May2021

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

# NOTE: 'Permit.Number not included here; should probably go under 'permits.R'; 'agency_code' included under 'agency.R'
ids <- attributes %>% 
  filter(attributeName %in% c("AKOATS_ID", "Stock.ID", "Proposal_Num", "SURVEY_ID", "	OBJECTID",
                              "IncidentNumber", "Source.ID", "commcode", "loanNumber", "IncidentNumber",
                              "id_numeric", "	id_original", "region_id", "loggerSN", "sample_number", 
                              "LocationID") |
           attributeDefinition %in% c("Numeric region ID", "Numeric ID of region") |
           str_detect(attributeName, "(?i)sample") |
           str_detect(attributeDefinition, "(?i)sample")) %>% 
           filter(!attributeName %in% c("Date", "sampleDate", "SampleDate", "Sample_interval", "sampleTime"))

##########################################################################################
# determine appropriate valueURIs
##########################################################################################

#############################
# fish sample identifier
#############################

fishSampleID <- ids %>% 
  filter(attributeDefinition %in% c("Numeric value assigned to a sample taken from a fish on a particular date")) %>% 
  mutate(assigned_valueURI = rep("tbd"),
         assigned_propertyURI = rep("tbd"),
         prefName = rep("tbd"),
         ontoName = rep("tbd"),
         grouping = rep("fishSampleID"),
         notes = rep("fish sample identifier"))

#############################
# UAA Alaksa Center for Conservation Science (AKOATS) identifier (unclear what this ID refers to exactly...)
#############################

AKOATS_id <- ids %>% 
  filter(attributeName %in% c("AKOATS_ID")) %>% 
  mutate(assigned_valueURI = rep("tbd"),
         assigned_propertyURI = rep("tbd"),
         prefName = rep("tbd"),
         ontoName = rep("tbd"),
         grouping = rep("AKOATS_id"),
         notes = rep("unique UAA Alaska Center for Conservation Science identifier"))

############################
# location or region id
#############################

locationRegion_id <- ids %>% 
  filter(attributeName %in% c("LocationID", "region", "region_id") |
         attributeDefinition %in% c("Numeric (HUC) region ID", "Numeric ID (HUC) of region")) %>% 
  mutate(assigned_valueURI = rep("tbd"),
         assigned_propertyURI = rep("tbd"),
         prefName = rep("tbd"),
         ontoName = rep("tbd"),
         grouping = rep("locationRegion_id"),
         notes = rep("unique identifier which describes a location or region"))

test <- get_dupes(locationRegion_id)


# location <- sample_info %>%
#   filter(str_detect(attributeName, "(?i)location")) %>%
#   mutate(assigned_valueURI = rep("tbd"),
#          assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
#          prefName = rep("tbd"),
#          ontoName = rep("tbd"),
#          grouping = rep("location"),
#          notes = rep("location where sample was collected"))

# ---- clean up repeats for sasap_regions.zip ----

zip_single <- locationRegion_id %>% filter(entityName == "sasap_regions.zip") %>% distinct()
locationRegion_rest <- locationRegion_id %>% filter(entityName != "sasap_regions.zip")
locationRegion_id_CLEANED <- rbind(zip_single, locationRegion_rest) # USE THIS ONE

############################
# stock id
#############################

stock_id <- ids %>% 
  filter(attributeName %in% c("Stock.ID")) %>% 
  mutate(assigned_valueURI = rep("tbd"),
         assigned_propertyURI = rep("tbd"),
         prefName = rep("tbd"),
         ontoName = rep("tbd"),
         grouping = rep("stock_id"),
         notes = rep("unique stock identifier"))

############################
# watershed id
#############################

watershed_id <- ids %>% 
  filter(attributeDefinition %in% c("Watershed ID number", "The numeric identification number of the watershed in this shapefile")) %>% 
  mutate(assigned_valueURI = rep("tbd"),
         assigned_propertyURI = rep("tbd"),
         prefName = rep("tbd"),
         ontoName = rep("tbd"),
         grouping = rep("watershed_id"),
         notes = rep("watershed identifier"))

##########################################################################################
# combine and ensure no duplicates
##########################################################################################

all_ID_atts <- rbind(fishSampleID, AKOATS_id, locationRegion_id, locationRegion_id_CLEANED, stock_id, watershed_id)

remainder <- anti_join(ids, all_ID_atts)

# check that there are no duplicates
all_IDs <- all_ID_atts %>% select(-assigned_valueURI, - assigned_propertyURI, -prefName, -ontoName, -grouping, -notes)
all_IDs_distinct <- all_ID_atts %>% select(-assigned_valueURI, - assigned_propertyURI, -prefName, -ontoName, -grouping, -notes) %>% distinct()
isTRUE(length(all_IDs$attributeName) == length(all_IDs_distinct$attributeName))

# if need to find repeats
# repeats <- get_dupes(all_IDs)
# test <- anti_join(all_IDs, all_IDs_distinct)

# clean up global environment
rm(ids, AKOATS_id, locationRegion_id, zip_single, locationRegion_rest, locationRegion_id_CLEANED, stock_id, watershed_id, remainder, all_IDs, all_IDs_distinct)

