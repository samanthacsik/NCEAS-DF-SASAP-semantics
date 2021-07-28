# title: Identifying attributes to be annotated -- "escapement"
# author: "Sam Csik"
# date created: "2021-02-04"
# date edited: "2021-02-04"
# R version: 3.6.3
# input: "data/queries/query2020-10-09/fullQuery_semAnnotations2020-10-09_attributes.csv"
# output: 

##########################################################################################
# Summary
##########################################################################################

# Identifying attributes related to "escapement"

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

escapement <- attributes %>% 
  filter(str_detect(attributeDefinition, "(?i)escapement") |
         str_detect(attributeDefinition, "(?i)cumulative") |
         str_detect(attributeDefinition, "(?i)No. of observed") |
         str_detect(attributeDefinition, "(?i)number of fish in") |
         str_detect(attributeName, "(?i)cumulative") |
         str_detect(attributeName, "(?i)daily") |
         # filter(str_detect(attributeDefinition, "(?i)escapement value") |
         # str_detect(attributeDefinition, "(?i)annual escapement") |
         str_detect(attributeDefinition, "(?i)number of fish escaping upstream") |
         attributeName %in% c("COUNT", "annualCount")) %>% 
  filter(!attributeName %in% c("CatchType", "STREAM_SECTION", "COUNTABLE_VIDEO", "NOTES", # some of these may no be necessary, but leaving bc I'm feeling lazy
                               "Species", "Date", "sampleDate", "Count Date","DATE", "District", "Type",
                               "Stock", "Location", "LocationID", "Lower", "SURVEY_TYPE", "STOCK",
                               "meanCumAnnualCount", "SASAP.Region", "SASAP.Region_Corrected", "STREAM_LIFE", "System",
                               "Location Name", "Observation Site", "Source", "SampleDate", "Method", "YEAR", "Year",
                               "Total_Run", "SURVEY_ID", "Upper", "Initial.Year", "Year.Implemented", "METHOD"))

##########################################################################################
# determine appropriate valueURIs
##########################################################################################

#############################
# daily escapement
#############################

daily_escapement <- escapement %>% 
  filter(str_detect(attributeDefinition, "(?i)number of fish escaping upstream") |
         str_detect(attributeName, "(?i)daily") |
         attributeName == "COUNT") %>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/salmon_000481"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         propertyURI_label = rep("containsMeasurementsOfType"),
         prefName = rep("Daily escapement count"),
         ontoName = rep("tbd"),
         grouping = rep("daily_escapement"),
         notes = rep("daily escapement counts")) 

#############################
# annual escapement
#############################

annual_escapement <- anti_join(escapement, daily_escapement) %>%  # escapement %>% 
  filter(identifier != "doi:10.5063/F1Z899P0") %>% # these are counts, not specifically escapement data
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/salmon_000480"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         propertyURI_label = rep("containsMeasurementsOfType"),
         prefName = rep("Annual escapement count"),
         ontoName = rep("tbd"),
         grouping = rep("annual_escapement"),
         notes = rep("annual escapement counts")) 
  # filter(attributeName %in% c("TotalEscapement", "Escapement", "REPORTED_ESCAPEMENT", "OFFICIAL_ESCAPEMENT") | 
  #        str_detect(attributeDefinition, "(?i)annual escapement")) %>% 
  # mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/salmon_000480"),
  #        assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
  #        prefName = rep("Annual escapement count"),
  #        ontoName = rep("tbd"),
  #        grouping = rep("annual_escapement"),
  #        notes = rep("annual escapement counts")) 


##########################################################################################
# combine and ensure no duplicates
##########################################################################################

all_escapement_atts <- rbind(annual_escapement, daily_escapement)

remainder <- anti_join(escapement, all_escapement_atts)

# check that there are no duplicates
all_escapement <- all_escapement_atts %>% select(-assigned_valueURI, -assigned_propertyURI, -prefName, -ontoName, -grouping, -notes)
all_escapement_distinct <- all_escapement_atts %>% select(-assigned_valueURI, -assigned_propertyURI, -prefName, -ontoName, -grouping, -notes) %>% distinct()
isTRUE(length(all_escapement$attributeName) == length(all_escapement_distinct$attributeName))

# clean up global environment
rm(escapement, annual_escapement, daily_escapement, all_escapement, all_escapement_distinct, remainder)

