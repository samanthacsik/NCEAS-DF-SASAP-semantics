# title: combine attributes for annotation
# author: "Sam Csik"
# date created: "2021-02-03"
# date edited: "2021-02-03"
# R version: 3.6.3
# input: 
# output: 

##########################################################################################
# Summary
##########################################################################################

# generate data frame with all attributes to be semantically annotated, with appropriate property and value URIs (or lackthereof if they need to be added to existing/new ontologies)

##########################################################################################
# General Setup
##########################################################################################

##############################
# Load packages
##############################

library(tidyverse)
library(janitor)

##############################
# Import data
##############################

source(here::here("code", "05a_exploring_attributes.R"))
source(here::here("code", "assign_URIs_to_attributes", "agency.R"))
source(here::here("code", "assign_URIs_to_attributes", "dates.R"))
source(here::here("code", "assign_URIs_to_attributes", "escapement.R")) 
source(here::here("code", "assign_URIs_to_attributes", "fishAge.R")) 
source(here::here("code", "assign_URIs_to_attributes", "fishCounts.R"))
source(here::here("code", "assign_URIs_to_attributes", "fishLength.R"))
source(here::here("code", "assign_URIs_to_attributes", "flags.R")) 
source(here::here("code", "assign_URIs_to_attributes", "gear.R")) 
source(here::here("code", "assign_URIs_to_attributes", "permits.R")) 
source(here::here("code", "assign_URIs_to_attributes", "precipitation.R"))
source(here::here("code", "assign_URIs_to_attributes", "random_ids.R"))
source(here::here("code", "assign_URIs_to_attributes", "recruits.R"))
source(here::here("code", "assign_URIs_to_attributes", "sampleInfo.R"))
source(here::here("code", "assign_URIs_to_attributes", "fishSex.R"))
source(here::here("code", "assign_URIs_to_attributes", "species.R"))
source(here::here("code", "assign_URIs_to_attributes", "temperature.R")) 

##########################################################################################
# Ensure no attribute has been annotated with two different URIs/organize final list of attributes to annotate
##########################################################################################

SASAP_attributes <- rbind(all_age_atts, 
                          all_agency_atts, 
                          all_date_atts, 
                          all_escapement_atts,
                          all_fishCounts_atts, 
                          all_length_atts, 
                          all_flag_atts, 
                          all_gear_atts, 
                          all_permit_atts, 
                          all_precipitation_atts, 
                          all_randomID_atts,
                          all_recruit_atts, 
                          all_sample_atts, 
                          all_sex_atts, 
                          all_species_atts, 
                          all_temp_atts) %>% 
  select(-valueURI, -propertyURI)

# check that there are no duplicates
SASAP_attributes_test <- SASAP_attributes %>% select(-assigned_valueURI, -assigned_propertyURI, -prefName, -ontoName, -grouping, -notes)
SASAP_attributes_distinct <- SASAP_attributes %>% select(-assigned_valueURI, -assigned_propertyURI, -prefName, -ontoName, -grouping, -notes) %>% distinct()
isTRUE(length(SASAP_attributes_test$attributeName) == length(SASAP_attributes_distinct$attributeName))

# if need to find repeats
repeats <- get_dupes(SASAP_attributes_test)

##############################
# save as .csv
##############################

# write_csv(SASAP_attributes, here::here("data", "sorted_attributes", "SASAP_attributes_sorted.csv"))
test <- read_csv(here::here("data", "sorted_attributes", "SASAP_attributes_sorted.csv"))

##############################
# generate list of all attributes yet to be sorted
##############################

master_list_remainder <- anti_join(attributes, SASAP_attributes)

