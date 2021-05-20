# title: Identifying attributes to be annotated -- "flags"
# author: "Sam Csik"
# date created: "2021-02-09"
# date edited: "2021-02-09"
# R version: 3.6.3
# input: "data/queries/query2020-10-09/fullQuery_semAnnotations2020-10-09_attributes.csv"
# output: 

##########################################################################################
# Summary
##########################################################################################

# Identifying attributes related to "flags"

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

flags <- attributes %>% 
  filter(attributeName %in% c("UseFlag", "UseData", "mean_discharge_flag", "Flag", "max_temp_flag", "min_temp_flag", "mean_temp_flag"))

##########################################################################################
# determine appropriate valueURIs
##########################################################################################

#############################
# flags (all)
#############################

data_quality_flags <- flags %>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/ECSO_00001720"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         prefName = rep("data quality flag"),
         ontoName = rep("The Ecosystem Ontology"),
         grouping = rep("data_quality_flags"),
         notes = rep("data quality flag"))

##########################################################################################
# combine and ensure no duplicates
##########################################################################################

all_flag_atts <- rbind(data_quality_flags)

remainder <- anti_join(flags, all_flag_atts)

# check that there are no duplicates
all_flags <- all_flag_atts %>% select(-assigned_valueURI,-assigned_propertyURI, -prefName, -ontoName, -grouping, -notes)
all_flags_distinct <- all_flag_atts %>% select(-assigned_valueURI, -assigned_propertyURI, -prefName, -ontoName, -grouping, -notes) %>% distinct()
isTRUE(length(all_flags$attributeName) == length(all_flags_distinct$attributeName))

# clean up global environment
rm(flags, flags_all, data_quality_flags)
