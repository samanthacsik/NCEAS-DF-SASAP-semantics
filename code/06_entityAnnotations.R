# title: wrangle categorical observations for entity-level annotations
# author: "Sam Csik"
# date created: "2021-03-23"
# date edited: "2021-03-23"
# R version: 3.6.3
# input: "data/sorted_attributes/SASAP_entityLevel_categoricalVar.csv
# output: 

##########################################################################################
# Summary
##########################################################################################

# Because most/all of SASAP's ASL data is in 'tidy/long' format (i.e. a single column does not represent a single measurement type), we've thought to annotate entities

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

entityData <- read_csv(here::here("data", "sorted_attributes", "SASAP_entityLevel_categoricalVar.csv"))

##########################################################################################
# tidy up
##########################################################################################

entityDataCleaned <- entityData %>% 
  separate_rows(observations, sep = ",") %>% 
  mutate(observations = str_trim(observations))


gear <- entityDataCleaned %>% 
  filter(attributeName == "Gear")

unique(gear$observations)

