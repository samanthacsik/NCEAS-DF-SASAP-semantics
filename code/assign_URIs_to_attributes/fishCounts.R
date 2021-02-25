# title: Identifying attributes to be annotated -- "fish counts"
# author: "Sam Csik"
# date created: "2021-02-09"
# date edited: "2021-02-25"
# R version: 3.6.3
# input: "data/queries/query2020-10-09/fullQuery_semAnnotations2020-10-09_attributes.csv"
# output: 

##########################################################################################
# Summary
##########################################################################################

# Identifying attributes related to "species"

# NOTE NEED TO COME BACK TO THESE, NOT SORTED CORRECTLY YET

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

fishCounts <- attributes %>% 
  filter(str_detect(attributeDefinition, "(?i)the species ratio") |
         str_detect(attributeDefinition, "(?i)harvested in") |
         str_detect(attributeDefinition, "(?i)number of fish in") |
         attributeUnit == "tonne" |
         attributeName %in% c("Chum", "Coho", "Chinook", "Pink", "Sockeye", "Total"))

##########################################################################################
# determine appropriate valueURIs
##########################################################################################

#############################
# annual harvested GOOD
#############################

annual_harvested <- fishCounts %>% 
  filter(str_detect(attributeDefinition, "(?i)harvested in")) %>% 
  mutate(assigned_valueURI = rep(""),
         assigned_propertyURI = rep(""),
         notes = rep("number of salmon (by species) harvested annually"))

#############################
# species ratio GOOD
#############################

species_ratio <- fishCounts %>% 
  filter(str_detect(attributeDefinition, "(?i)the species ratio")) %>% 
  mutate(assigned_valueURI = rep(""),
         assigned_propertyURI = rep(""),
         notes = rep("species ratio"))

#############################
# counts of mature returning salmon (by natural origin species) by region
#############################
#!!!! needs to be divided up
counts_by_region <- fishCounts %>% 
  filter(str_detect(attributeDefinition, "(?i)number of fish in")) %>% 
  mutate(assigned_valueURI = rep(""),
         assigned_propertyURI = rep(""),
         notes = rep("fish counts (by region)"))

#############################
# number fish harvested
#############################
#!!! needs to be split up
numFishHarvested_byRegion <- fishCounts %>% 
  filter(attributeName %in% c("Chum", "Coho", "Chinook", "Pink", "Sockeye"), # included 'Total' but should break out
         attributeUnit == "number",
         attributeDefinition != "total number of permit holders from that resident type") %>% 
  mutate(assigned_valueURI = rep(""),
         assigned_propertyURI = rep(""),
         notes = rep("number of fish harvested by year"))

# ---- clean up repeats for BristolBay.cscv ----

numFishHarvested_byRegion_BB <- numFishHarvested_byRegion %>% filter(entityName == "BristolBay.csv") %>% distinct()
numFishHarvested_byRegion_rest <- numFishHarvested_byRegion %>% filter(entityName != "BristolBay.csv")
numFishHarvested_byRegion_CLEANED <- rbind(numFishHarvested_byRegion_BB, numFishHarvested_byRegion_rest) # USE THIS ONE

# ----------------------------------------------

# total_numFishHarvested <- fishCounts %>% #!!!!!!!!!!!!!!!!! NOT CORRECT
#   filter(attributeName %in% c("Total"), 
#          attributeUnit == "number",
#          attributeDefinition != "total number of permit holders from that resident type") %>% 
#   mutate(assigned_valueURI = rep(""),
#          assigned_propertyURI = rep(""),
#          notes = rep("total number of fish harvested (across all regions) by year"))

#############################
# fish biomass harvested
#############################

biomassFishHarvested <- fishCounts %>% 
  filter(attributeUnit == "thousandsOfTonnes") %>% 
  mutate(assigned_valueURI = rep(""),
         assigned_propertyURI = rep(""),
         notes = rep("biomass of fish harvested by year"))

#############################
# fish biomass by region
#############################

fishBiomass_byRegion <- fishCounts %>% 
  filter(attributeUnit == "tonne",
         attributeName != "TOTAL") %>% 
  mutate(assigned_valueURI = rep(""),
         assigned_propertyURI = rep(""),
         notes = rep("biomass of fish, by region and year"))

#############################
# total fish biomass
#############################

total_fishBiomass <- fishCounts %>% 
  filter(attributeUnit == "tonne",
         attributeName == "TOTAL") %>% 
  mutate(assigned_valueURI = rep(""),
         assigned_propertyURI = rep(""),
         notes = rep("total fish biomass (across regions) by year"))


##########################################################################################
# combine and ensure no duplicates
##########################################################################################

all_fishCounts_atts <- rbind(annual_harvested, species_ratio, counts_by_region, numFishHarvested_byRegion_CLEANED, biomassFishHarvested, fishBiomass_byRegion, total_fishBiomass)

remainder <- anti_join(fishCounts, all_fishCounts_atts)

# check that there are no duplicates
all_fishCounts <- all_fishCounts_atts %>% select(-assigned_valueURI,-assigned_propertyURI, -notes)
all_fishCounts_distinct <- all_fishCounts_atts %>% select(-assigned_valueURI, -assigned_propertyURI, -notes) %>% distinct()
isTRUE(length(all_fishCounts$attributeName) == length(all_fishCounts_distinct$attributeName))

# clean up global environment
rm(annual_harvested, species_ratio, counts, remainder, all_fishCounts, all_fishCounts_distinct, fishCounts, numFishHarvested, numFishHarvested_byRegion_BB, numFishHarvested_byRegion_rest, numFishHarvested_byRegion_CLEANED, biomassFishHarvested, fishBiomass_byRegion, total_fishBiomass)
