##############################
# load libraries
##############################

library(tidyverse)
library(janitor)

##############################
# get round 1 package identifiers
##############################

round1_pkgs <- read_csv(here::here("data", "queries", "query2020-10-09", "unique_pkgs.csv")) %>% 
  filter(annotation_round == "round 1") %>% 
  select(-new_version, -new_URL)

write_csv(round1, here::here("data", "annotationPrep", "round1_pkgs.csv"))

round1_pkgIDs <- unique(round1_pkgs$identifier)

##############################
# get all round 1 attributes 
##############################

# 12,261 attributes total
round1_attributes_all <- read_csv(here::here("data", "queries", "query2020-10-09", "fullQuery_semAnnotations2020-10-09_attributes.csv")) %>% 
  filter(identifier %in% round1_pkgIDs) %>% 
  select(-valueURI, -propertyURI)

##############################
# get all previously sorted attributes and filter for round 1 attributes
##############################

# 10,910 attributes (had been assigned a general 'grouping' during prior organization)
round1_attributes_prevSort <- read_csv(here::here("data", "sorted_attributes", "SASAP_attributes_sorted.csv")) %>% 
  filter(identifier %in% round1_pkgIDs)

##############################
# remaining round 1 attributes to be sorted
##############################

# round1_all_atts <- round1_attributes %>% select(identifier, entityName, attributeName)
# round1_all_sorted_atts <- round1_attributes_prevSort %>% select(identifier, entityName, attributeName)
# round1_attributes_unsorted <- anti_join(round1_all_atts, round1_all_sorted_atts)

##############################
# join sorting notes with all attribute information from round 1 SASAP packages
##############################

round1 <- full_join(round1_attributes_all, round1_attributes_prevSort) %>% 
  select(-ontoName)

##############################
# what's left to assess
##############################

remainder <- round1 %>% 
  filter(!assigned_valueURI %in% c(
    "http://purl.dataone.org/odo/salmon_000525", # ADF&G species code
    "http://purl.dataone.org/odo/salmon_000527", # ADF&G gear code
    "http://purl.dataone.org/odo/salmon_000480", # Annual escapement count 
    "http://purl.dataone.org/odo/salmon_000481", # Daily escapement count 
    "http://purl.dataone.org/odo/ECSO_00001237", # Precipitation volume -- COME BACK TO THIS
    "http://purl.dataone.org/odo/ECSO_00001225", # Air temperature  -- COME BACK TO THIS
    "http://purl.dataone.org/odo/salmon_000520", # Brood year
    "http://purl.dataone.org/odo/salmon_00235", # Distance between scale circuli
    "http://purl.dataone.org/odo/ECSO_00001720", # data quality flag
    "http://purl.dataone.org/odo/ECSO_00002051", # date
    "http://purl.dataone.org/odo/salmon_000681", # Age error code
    "http://purl.dataone.org/odo/salmon_00187", # Total age
    "http://purl.dataone.org/odo/salmon_00188", # Freshwater age
    "http://purl.dataone.org/odo/salmon_00189", # Saltwater age
    "http://purl.dataone.org/odo/salmon_00200", # Fish age expressed in European notation
    "http://purl.dataone.org/odo/salmon_00216", # Fish sex measurement type
    "http://purl.dataone.org/odo/salmon_000529", # Fish sample code
    "http://purl.dataone.org/odo/salmon_00142", # Fishing gear type
    "http://purl.dataone.org/odo/ECSO_00002130", # latitude coordinate
    "http://purl.dataone.org/odo/ECSO_00002247", # latitude degree component
    "http://purl.dataone.org/odo/ECSO_00002132", # longitude
    "http://purl.dataone.org/odo/ECSO_00002239" # longitude degree component
  )) %>% 
  # see 'need_help' below (only removing these to make it easier to see what's left)
  filter(!grouping %in% c(
    "avgWeight_adultSalmon",
    "biomassFishHarvested",
    "biomassFishHarvested_byRegion",
    "common_name",
    "counts_by_region",
    "errorAgeDescription",
    "fish_weightG",
    "fish_weightKG"
  ))

##############################
# need to add terms/get help on these
##############################

need_help <- round1 %>% 
  filter(grouping %in% c(
    "avgWeight_adultSalmon",
    "biomassFishHarvested",
    "biomassFishHarvested_byRegion",
    "common_name",
    "counts_by_region",
    "errorAgeDescription",
    "fish_weightG",
    "fish_weightKG"
  ))
