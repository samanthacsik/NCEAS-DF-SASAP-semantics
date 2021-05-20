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

# Identifying attributes related to "fish counts (surveys, harvest, etc) as well as fish weights"

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
         str_detect(attributeDefinition, "(?i)Weight of the fish.") |
         str_detect(attributeDefinition, "(?i)Weight of fish.") |
         str_detect(attributeDefinition, "(?i)Weight of salmon fish in grams.") |
         str_detect(attributeDefinition, "(?i)weight of sampled fish in grams") |
         str_detect(attributeDefinition, "(?i)weight in kg") |
         attributeUnit %in% c("tonne", "pound") |
         attributeName %in% c("Chum", "Coho", "Chinook", "Pink", "Sockeye", "Total"))

##########################################################################################
# determine appropriate valueURIs
##########################################################################################

#############################
# annual harvested GOOD
#############################

annual_harvested <- fishCounts %>% 
  filter(str_detect(attributeDefinition, "(?i)harvested in")) %>% 
  mutate(assigned_valueURI = rep("tbd"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         prefName = rep("tbd"),
         ontoName = rep("tbd"),
         grouping = rep("annual_harvest"),
         notes = rep("number of salmon (by species) harvested annually"))

#############################
# species ratio GOOD
#############################

species_ratio <- fishCounts %>% 
  filter(str_detect(attributeDefinition, "(?i)the species ratio")) %>% 
  mutate(assigned_valueURI = rep("tbd"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         prefName = rep("tbd"),
         ontoName = rep("tbd"),
         grouping = rep("species_ratio"),
         notes = rep("species ratio"))

#############################
# counts of mature returning salmon (by natural- or enhanced-origin species) by region
#############################
#!!!! needs to be divided up
counts_by_region <- fishCounts %>% 
  filter(str_detect(attributeDefinition, "(?i)number of fish in")) %>% 
  mutate(assigned_valueURI = rep("tbd"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         prefName = rep("tbd"),
         ontoName = rep("tbd"),
         grouping = rep("counts_by_region"),
         notes = rep("fish counts (by region)"))

#############################
# number fish harvested
#############################
#!!! needs to be split up
numFishHarvested_byRegion <- fishCounts %>% 
  filter(attributeName %in% c("Chum", "Coho", "Chinook", "Pink", "Sockeye"), # included 'Total' but should break out
         attributeUnit == "number",
         attributeDefinition != "total number of permit holders from that resident type") %>% 
  mutate(assigned_valueURI = rep("tbd"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         prefName = rep("tbd"),
         ontoName = rep("tbd"),
         grouping = rep("numFishHarvested_byRegion"),
         notes = rep("number of fish harvested by year"))

# ---- clean up repeats for BristolBay.csv ----

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
  filter(attributeUnit == "thousandsOfTonnes" |
         attributeName %in% c("Chinook_Lbs", "Chum_Lbs", "Pink_Lbs", "Coho_Lbs", "Sockeye_Lbs", 
                              "X_Total_Lbs", "Chinook.Lbs", "Chum.Lbs", "Pink.Lbs", "Coho.Lbs", "Sockeye.Lbs",
                              "Total.Pounds", "Total.Salmon.Lbs", "NETPOUNDS", "net_lbs", "pounds", "Total_Salmon_Lbs", 
                              "pu_lbs_harvested", "Total_Lbs_Harvested")) %>% 
  mutate(assigned_valueURI = rep("tbd"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         prefName = rep("tbd"),
         ontoName = rep("tbd"),
         grouping = rep("biomassFishHarvested"),
         notes = rep("biomass of fish harvested by year (this may no longer be accurate; need to read more to determine if it's a measurement over a year): also includes a mix of commercial, personal use, and subsistence fishery harvest"))

#############################
# fish biomass by region
#############################

fishBiomass_byRegion <- fishCounts %>% 
  filter(attributeUnit == "tonne",
         attributeName != "TOTAL") %>% 
  mutate(assigned_valueURI = rep("tbd"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         prefName = rep("tbd"),
         ontoName = rep("tbd"),
         grouping = rep("biomassFishHarvested_byRegion"),
         notes = rep("biomass of fish, by region and year"))

#############################
# total fish biomass
#############################

total_fishBiomass <- fishCounts %>% 
  filter(attributeUnit == "tonne",
         attributeName == "TOTAL") %>% 
  mutate(assigned_valueURI = rep("tbd"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         prefName = rep("tbd"),
         ontoName = rep("tbd"),
         grouping = rep("total_fishBiomass"),
         notes = rep("total fish biomass (across regions) by year"))

#############################
# weight of processed product
#############################

weightProcessedProduct <- fishCounts %>% 
  filter(attributeName %in% c("TotalNetWeight", "net_weight")) %>% 
  mutate(assigned_valueURI = rep("tbd"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         prefName = rep("tbd"),
         ontoName = rep("tbd"),
         grouping = rep("weight_processed_product"),
         notes = rep("weight of processed fish product"))

#############################
# average weight of fish
#############################

avgWeight <- fishCounts %>% 
  filter(str_detect(attributeDefinition, "(?i)average adult weight of")) %>% 
  mutate(assigned_valueURI = rep("tbd"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         prefName = rep("tbd"),
         ontoName = rep("tbd"),
         grouping = rep("avgWeight_adultSalmon"),
         notes = rep("average weight of adult salmon, by species"))

#############################
# weight of fish (kg)
#############################

weightKG <- fishCounts %>% 
  filter(str_detect(attributeDefinition, "(?i)Weight of the fish.") |
         str_detect(attributeDefinition, "(?i)Weight of fish.") |
         str_detect(attributeDefinition, "(?i)weight in kg")) %>% 
  filter(!attributeName %in% c("NETPOUNDS", "net_lbs")) %>% 
  mutate(assigned_valueURI = rep("tbd"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         prefName = rep("tbd"),
         ontoName = rep("tbd"),
         grouping = rep("fish_weightKG"),
         notes = rep("weight of fish in kg"))

#############################
# weight of fish (g)
#############################

weightG <- fishCounts %>% 
  filter(str_detect(attributeDefinition, "(?i)Weight of salmon fish in grams.") |
           str_detect(attributeDefinition, "(?i)weight of sampled fish in grams")) %>% 
  mutate(assigned_valueURI = rep("tbd"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         prefName = rep("tbd"),
         ontoName = rep("tbd"),
         grouping = rep("fish_weightG"),
         notes = rep("weight of fish in g"))

##########################################################################################
# combine and ensure no duplicates
##########################################################################################

all_fishCounts_atts <- rbind(annual_harvested, species_ratio, counts_by_region, numFishHarvested_byRegion_CLEANED, biomassFishHarvested, fishBiomass_byRegion, total_fishBiomass, weightProcessedProduct, avgWeight, weightKG, weightG)

remainder <- anti_join(fishCounts, all_fishCounts_atts)

# check that there are no duplicates
all_fishCounts <- all_fishCounts_atts %>% select(-assigned_valueURI,-assigned_propertyURI, -prefName, -ontoName, -grouping, -notes)
all_fishCounts_distinct <- all_fishCounts_atts %>% select(-assigned_valueURI, -assigned_propertyURI, -prefName, -ontoName, -grouping, -notes) %>% distinct()
isTRUE(length(all_fishCounts$attributeName) == length(all_fishCounts_distinct$attributeName))

# clean up global environment
rm(annual_harvested, species_ratio, counts, remainder, all_fishCounts, all_fishCounts_distinct, fishCounts, numFishHarvested, numFishHarvested_byRegion_BB, numFishHarvested_byRegion_rest, numFishHarvested_byRegion, numFishHarvested_byRegion_CLEANED, biomassFishHarvested, fishBiomass_byRegion, total_fishBiomass, avgWeight, weightG, weightKG, counts_by_region, weightProcessedProduct)
