# title: Identifying attributes to be annotated -- "dates"
# author: "Sam Csik"
# date created: "2021-02-09"
# date edited: "2021-02-09"
# R version: 3.6.3
# input: "data/queries/query2020-10-09/fullQuery_semAnnotations2020-10-09_attributes.csv"
# output: 

##########################################################################################
# Summary
##########################################################################################

# Identifying attributes related to "dates"

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

dates <- attributes %>% 
  filter(str_detect(attributeName, "(?i)date") |
         str_detect(attributeName, "(?i)year"))

##########################################################################################
# determine appropriate valueURIs
##########################################################################################

#############################
# brood year
#############################

brood_year <- dates %>% 
  filter(attributeName %in% c("BroodYear")) %>% 
  mutate(assigned_valueURI = rep(""),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         notes = rep("brood year; ASSIGN URI FOR YEAR??"))

#############################
# date
#############################

date <- dates %>% 
  filter(attributeName %in% c("Date", "sampleDate")) %>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/ECSO_00002051"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         notes = rep("general date of measurement"))

#############################
# issue date of license
#############################

license_issue_date <- dates %>% 
  filter(attributeLabel %in% c("License Issue Date")) %>% 
  mutate(assigned_valueURI = rep(""),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         notes = rep("issue date of license"))

##########################################################################################
# combine and ensure no duplicates
##########################################################################################

all_date_atts <- rbind(brood_year, date, license_issue_date)

remainder <- anti_join(dates, all_date_atts)

# check that there are no duplicates
all_dates <- all_date_atts %>% select(-assigned_valueURI,-assigned_propertyURI, -notes)
all_dates_distinct <- all_date_atts %>% select(-assigned_valueURI, -assigned_propertyURI, -notes) %>% distinct()
isTRUE(length(all_dates$attributeName) == length(all_dates_distinct$attributeName))

# clean up global environment
rm(dates, all_dates, all_dates_distinct)
