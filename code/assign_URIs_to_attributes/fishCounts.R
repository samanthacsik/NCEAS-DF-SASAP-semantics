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
         str_detect(attributeDefinition, "(?i)escapement") | # NOTE: ALL ESCAPEMENT COUNTS MOVED TO 'escapement.R'
         str_detect(attributeDefinition, "(?i)cumulative") |
         str_detect(attributeDefinition, "(?i)No. of observed") |
         str_detect(attributeDefinition, "(?i)number of fish in") |
         attributeName %in% c("Sport_Harvest", "Inriver_Harvest", "Total_Harvest", "Inriver_Abundance",
                              "Glennallen_Subdistrict_Harvest_Total", "Chitina_Subdistrict_Harvest_Total",
                              "Copper_District_Subsistence_Harvest", "Copper_District_Commercial_Harvest",
                              "Chitina_Subdistrict_Harvest_Total", "Glennallen_Subdistrict_Harvest_Total",
                              "Total_Harvest", "Inriver_Harvest", "meanCumAnnualCount") |
         # not sure why, but ended up lumping weight into this fishCounts category    
         str_detect(attributeDefinition, "(?i)Weight of the fish.") |
         str_detect(attributeDefinition, "(?i)Weight of fish.") |
         str_detect(attributeDefinition, "(?i)Weight of fish") |
         str_detect(attributeDefinition, "(?i)Weight of salmon fish in grams.") |
         str_detect(attributeDefinition, "(?i)weight of sampled fish in grams") |
         str_detect(attributeDefinition, "(?i)weight in kg") |
         attributeUnit %in% c("tonne", "pound") |
         attributeName %in% c("Chum", "Coho", "Chinook", "Pink", "Sockeye", "Total", "Total all 3 species"))

##########################################################################################
# determine appropriate valueURIs
##########################################################################################

#############################
# annual harvested GOOD
#############################

# annual_harvested <- fishCounts %>% 
#   filter(str_detect(attributeDefinition, "(?i)harvested in")) %>% 
#   mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/salmon_000492"),
#          assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
#          prefName = rep("Commercial harvest count"),
#          ontoName = rep("tbd"),
#          grouping = rep("annual_harvest"),
#          notes = rep("number of salmon (by species) harvested annually"))

# VERIFIED -- this is commercial harvest data, broken down by year (combine with 'numHarvestedCommercial')

#############################
# species ratio GOOD
#############################

species_ratio <- fishCounts %>% 
  filter(str_detect(attributeDefinition, "(?i)the species ratio")) %>% 
  mutate(assigned_valueURI = rep("tbd"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         propertyURI_label = rep("containsMeasurementsOfType"),
         prefName = rep("tbd"),
         ontoName = rep("tbd"),
         grouping = rep("species_ratio"),
         notes = rep("species ratio"))

#############################
# counts of mature returning salmon (by natural- or enhanced-origin species) by region
#############################
#!!!! COMBINED THIS WITH 'generalAbundance' below
# counts_by_region <- fishCounts %>% 
#   filter(str_detect(attributeDefinition, "(?i)number of fish in") |
#          attributeDefinition %in% c("total number of fish", "number of total salmon (millions of fish)",
#                                     "number of total salmon, all three species (millions of fish)")) %>% 
#   mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/salmon_000499"),
#          assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
#          prefName = rep("Fish abundance"),
#          ontoName = rep("tbd"),
#          grouping = rep("counts_by_region"),
#          notes = rep("fish counts (by region)"))

#############################
# number fish harvested
#############################

# OLD -- INCLUDED NON-COMMERCIAL COUNTS; SAVING FOR NOW AS A RECORD OF PAST
# numHarvestedCommercial <- fishCounts %>% 
#   filter(str_detect(attributeDefinition, "(?i)harvested in"),
#          attributeName %in% c("Chum", "Coho", "Chinook", "Pink", "Sockeye", "Copper_District_Commercial_Harvest"), # included 'Total' but should break out
#          !attributeUnit %in% c("thousandsOfTonnes", "kilogram"),
#          # !entityName %in% c("Glennallen District By Gear and Permit - All Years.csv",
#          #                    "Glennallen District By Gear and Permit - All Years.csv"),
#          attributeDefinition != "total number of permit holders from that resident type") %>% 
#   mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/salmon_000492"),
#          assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
#          prefName = rep("Commercial fishery harvest count"),
#          ontoName = rep("tbd"),
#          grouping = rep("numFishHarvestedCommercial_byRegion"),
#          notes = rep("number of fish harvested (commercial) by year"))

# NEW commercial harvest counts -- files OLD numHarvestedCommercial (above) and combines with 'annual_harvested' (above)
numHarvestedCommercial <- fishCounts %>% 
  filter(str_detect(attributeDefinition, "(?i)harvested in") |
         attributeName %in% c("Chum", "Coho", "Chinook", "Pink", "Sockeye", "Copper_District_Commercial_Harvest"), # included 'Total' but should break out
         !entityName %in% c("Glennallen District By Gear and Permit - All Years.csv",
                            "Glennallen District Gear Permit ANS District - 2011-2015.csv"), 
         !attributeUnit %in% c("thousandsOfTonnes", "kilogram"),
         identifier != "doi:10.5063/F1Z899P0") %>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/salmon_000492"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         propertyURI_label = rep("containsMeasurementsOfType"),
         prefName = rep("Commercial fishery harvest count"),
         ontoName = rep("tbd"),
         grouping = rep("numHarvestedCommercial_byRegion"),
         notes = rep("number of fish harvested (commercial) by year"))

# ---- clean up repeats for BristolBay.csv ----

numHarvestedCommercial_BB <- numHarvestedCommercial %>% filter(entityName == "BristolBay.csv") %>% distinct()
numHarvestedCommercial_rest <- numHarvestedCommercial %>% filter(entityName != "BristolBay.csv")
numHarvestedCommercial_CLEANED <- rbind(numHarvestedCommercial_BB, numHarvestedCommercial_rest) # USE THIS ONE

# ----------------------------------------------

numHarvestedSubsistence <- fishCounts %>% 
  filter(attributeName %in% c("Copper_District_Subsistence_Harvest") |
         entityName %in% c("Glennallen District By Gear and Permit - All Years.csv",
                           "Glennallen District Gear Permit ANS District - 2011-2015.csv")) %>% 
  filter(attributeUnit != "pound") %>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/salmon_000783"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         propertyURI_label = rep("containsMeasurementsOfType"),
         prefName = rep("Subsistence fishery harvest count"),
         ontoName = rep("tbd"),
         grouping = rep("numHarvestedSubsistence_byRegion"),
         notes = rep("number of fish harvested (subsistence) by year"))

numHarvestedSport <- fishCounts %>% 
  filter(attributeName %in% c("Sport_Harvest")) %>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/salmon_000785"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         propertyURI_label = rep("containsMeasurementsOfType"),
         prefName = rep("Sport fishery harvest count"),
         ontoName = rep("tbd"),
         grouping = rep("numHarvestedSport_byRegion"),
         notes = rep("number of fish harvested (sport) by year"))

totalHarvest <- fishCounts %>% 
  filter(attributeName %in% c("Chitina_Subdistrict_Harvest_Total", "Glennallen_Subdistrict_Harvest_Total",
                              "Total_Harvest", "Inriver_Harvest")) %>% 
  mutate(assigned_valueURI = rep("tbd"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         propertyURI_label = rep("containsMeasurementsOfType"),
         prefName = rep("tbd"),
         ontoName = rep("tbd"),
         grouping = rep("totalHarvest"),
         notes = rep("this category may include total harvest for varying periods of time, across regions, and/or across fishery types"))

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
  filter(attributeUnit != "thousandsOfTonnes") %>% 
  filter(attributeName != "Total all 3 species") %>% 
  mutate(assigned_valueURI = rep("tbd"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         propertyURI_label = rep("containsMeasurementsOfType"),
         prefName = rep("tbd"),
         ontoName = rep("tbd"),
         grouping = rep("biomassFishHarvested"),
         notes = rep("general biomass fish harvested"))


#############################
# total fish biomass 
#############################

total_fishBiomass <- fishCounts %>% 
  filter(attributeName %in% c("TOTAL", "Total all 3 species")) %>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/salmon_000493"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         propertyURI_label = rep("containsMeasurementsOfType"),
         prefName = rep("Fish biomass"),
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
         propertyURI_label = rep("containsMeasurementsOfType"),
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
         propertyURI_label = rep("containsMeasurementsOfType"),
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
  #filter(attributeUnit == "kilogram") %>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/salmon_000659"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         propertyURI_label = rep("containsMeasurementsOfType"),
         prefName = rep("Wet weight"),
         ontoName = rep("tbd"),
         grouping = rep("fish_weightKG"),
         notes = rep("weight of fish in kg"))

#############################
# weight of fish (g)
#############################

weightG <- fishCounts %>% 
  filter(str_detect(attributeDefinition, "(?i)Weight of salmon fish in grams.") |
         str_detect(attributeDefinition, "(?i)weight of sampled fish in grams") |
         str_detect(attributeDefinition, "(?i)Weight of fish")) %>% 
  filter(attributeUnit == "gram") %>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/salmon_000659"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         propertyURI_label = rep("containsMeasurementsOfType"),
         prefName = rep("Wet weight"),
         ontoName = rep("tbd"),
         grouping = rep("fish_weightG"),
         notes = rep("weight of fish in g"))

#############################
# salmon abundance counts (was called 'general abundance')
#############################

salmon_abundance_counts <- fishCounts %>% 
  filter(attributeDefinition %in% c("number of chum salmon (millions of fish)",
                                    "number of pink salmon (millions of fish)",
                                    "number of sockeye salmon (millions of fish)") |
         attributeName %in% c("Inriver_Abundance", "meanCumAnnualCount") |
         str_detect(attributeDefinition, "(?i)number of fish in") |
         attributeDefinition %in% c("total number of fish", "number of total salmon (millions of fish)",
                                    "number of total salmon, all three species (millions of fish)"))  %>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/salmon_000504"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         propertyURI_label = rep("containsMeasurementsOfType"),
         prefName = rep("Salmon abundance"), # this needs to be defined in the onto still
         ontoName = rep("tbd"),
         grouping = rep("salmon_abundance_counts"),
         notes = rep("general abundance of salmon (counts)"))

#############################
# salmon abundance biomass (was called 'general abundance')
#############################

salmon_abundance_biomass <- fishCounts %>% 
  filter(str_detect(attributeDefinition, "(?i)biomass of")) %>% 
  filter(!attributeName %in% c("TOTAL", "Total all 3 species")) %>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/salmon_000493"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         propertyURI_label = rep("containsMeasurementsOfType"),
         prefName = rep("Fish biomass"), 
         ontoName = rep("tbd"),
         grouping = rep("salmon_abundance_biomass"),
         notes = rep("general abundance of salmon (biomass)"))

##########################################################################################
# combine and ensure no duplicates
##########################################################################################

all_fishCounts_atts <- rbind(totalHarvest, numHarvestedSport, species_ratio, numHarvestedCommercial_CLEANED, biomassFishHarvested, 
                            total_fishBiomass, weightProcessedProduct, avgWeight, weightKG, weightG, numHarvestedSubsistence,
                              salmon_abundance_counts, salmon_abundance_biomass) # fishBiomass_byRegion, 

remainder <- anti_join(fishCounts, all_fishCounts_atts) 

escapement_other_remainder <- remainder %>%
   filter(str_detect(attributeDefinition, "(?i)escapement") |
          str_detect(attributeDefinition, "(?i)round pound") |
          str_detect(attributeDefinition, "(?i)probability") |
          str_detect(attributeDefinition, "(?i)remote video") |
          str_detect(attributeDefinition, "(?i)permit") |
          attributeName %in% c("Daily sockeye", "Daily kings"))
  # filter(attributeUnit == "pound")
            
final_remainder <- anti_join(remainder, escapement_other_remainder) %>% 
  filter(attributeUnit != "pound")

# check that there are no duplicates
all_fishCounts <- all_fishCounts_atts %>% select(-assigned_valueURI,-assigned_propertyURI, -prefName, -ontoName, -grouping, -notes)
all_fishCounts_distinct <- all_fishCounts_atts %>% select(-assigned_valueURI, -assigned_propertyURI, -prefName, -ontoName, -grouping, -notes) %>% distinct()
isTRUE(length(all_fishCounts$attributeName) == length(all_fishCounts_distinct$attributeName))

# if need to find repeats
repeats <- get_dupes(all_fishCounts)

# clean up global environment
rm(remainder, escapement_other_remainder, final_remainder, all_fish_counts, all_fishCounts_distinct, repeats, weightG, weightKG, avgWeight, weightProcessedProduct, total_fishBiomass, 
   fishBiomass_byRegion, biomassFishHarvested, totalHarvest, numHarvestedSport, numHarvestedSubsistence, numHarvestedCommercial, numHarvestedCommercial_CLEANED,
   numHarvestedCommercial_rest, numHarvestedCommercial_BB, species_ratio, fishCounts, salmon_abundance_biomass, salmon_abundance_counts, salmon_abundance_biomass)


rm(numHarvestedSport, numHarvestedSubsistence, annual_harvested, species_ratio, counts, remainder, all_fishCounts, all_fishCounts_distinct, fishCounts, numFishHarvested, numHarvestedCommercial_BB, numHarvestedCommercial_rest, numHarvestedCommercial, numHarvestedCommercial_byRegion_CLEANED, biomassFishHarvested, fishBiomass_byRegion, total_fishBiomass, avgWeight, weightG, weightKG, counts_by_region, weightProcessedProduct)