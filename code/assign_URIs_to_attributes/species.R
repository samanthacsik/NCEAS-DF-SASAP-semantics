# title: Identifying attributes to be annotated -- "species"
# author: "Sam Csik"
# date created: "2021-02-03"
# date edited: "2021-02-03"
# R version: 3.6.3
# input: "data/queries/query2020-10-09/fullQuery_semAnnotations2020-10-09_attributes.csv"
# output: 

##########################################################################################
# Summary
##########################################################################################

# Identifying attributes related to "species"

##########################################################################################
# General Setup
##########################################################################################

# 2021-02-03 @ 15:50 -- remainder has 31 attributes left, but taking a break

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

species <- attributes %>% 
  filter(str_detect(attributeName, "(?i)species") |
         str_detect(attributeDefinition, "(?i)scientific name")) 
  
##########################################################################################
# determine appropriate valueURIs
##########################################################################################

#############################
# scientific name (pretty sure this is the only one across all the data...)
#############################

sci_name <- species %>% 
  filter(str_detect(attributeDefinition, "(?i)scientific name")) %>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/ECSO_00002735"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"), # https://schema.org/about
         propertyURI_label = rep("containsMeasurementsOfType"), # about
         prefName = rep("species name"),
         ontoName = rep("The Ecosystem Ontology"),
         grouping = rep("sci_name"),
         notes = rep("scientific name/taxonomic classification"))

#############################
# species codes (ADFG)
#############################

tempA <- species %>%  
  filter(str_detect(attributeName, "(?i)code")) %>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/salmon_000525"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         propertyURI_label = rep("containsMeasurementsOfType"),
         prefName = rep("ADF&G species code"),
         ontoName = rep("tbd"),
         grouping = rep("ADFG_species_code"),
         notes = rep("ADFG species code"))

tempB <- species %>%  
  filter(attributeName == "Species_ID") %>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/salmon_000525"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         propertyURI_label = rep("containsMeasurementsOfType"),
         prefName = rep("ADF&G species code"),
         ontoName = rep("tbd"),
         grouping = rep("ADFG_species_code"),
         notes = rep("ADFG species code"))

ADFG_species_code <- rbind(tempA, tempB) 

#############################
# species codes 
#############################

species_code <- species %>% 
  filter(attributeName%in% c("SpeciesNo")) %>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/ECSO_00002490"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         propertyURI_label = rep("containsMeasurementsOfType"),
         prefName = rep("species code"),
         ontoName = rep("The Ecosystem Ontology"),
         grouping = rep("species_code"),
         notes = rep("species code (not ADFG)"))

#############################
# common name -- WILL HAVE TO CHANGE THIS OUT WITH WHATEVER WE DECIDE
#############################

common_name <- species %>% 
  filter(str_detect(attributeDefinition, "(?i)common name") |
         attributeName %in% c("Species_Name", "species", "Species") |
         attributeDefinition %in% c("Species of fish", "Name of species defined by ADFG species code",
                                    "species of stock", "Species valued", "Commonly used name of fish being counted.",
                                    "Species of the tagged fish", "Species of fish being counted")) %>%
  filter(attributeDefinition != "The sub-genus classification of salmonids being sampled") %>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/ECSO_00002735"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"), # https://schema.org/about
         propertyURI_label = rep("containsMeasurementsOfType"), # about
         prefName = rep("species name"),
         ontoName = rep("tbd"),
         grouping = rep("common_name"),
         notes = rep("common name -- identity"))

#############################
# common name (product)
#############################

common_name_product <- species %>% 
  filter(entityName == "Total_wholesale.csv",
         attributeName %in% c("SpeciesName", "SpeciesGroup")) %>% 
  mutate(assigned_valueURI = rep("tbd"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         propertyURI_label = rep("tbd"),
         prefName = rep("tbd"),
         ontoName = rep("tbd"),
         grouping = rep("common_name_product"),
         notes = rep("common name - fish as a product"))

#############################
# sub-genus
#############################

subGenus <- species %>% 
  filter(str_detect(attributeDefinition, "(?i)sub-genus")) %>% 
  mutate(assigned_valueURI = rep("tbd"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         propertyURI_label = rep("containsMeasurementsOfType"),
         prefName = rep("tbd"),
         ontoName = rep("tbd"),
         grouping = rep("subGenus"),
         notes = rep("subGenus"))

##########################################################################################
# combine and ensure no duplicates
##########################################################################################

all_species_atts <- rbind(sci_name, ADFG_species_code, species_code, common_name, common_name_product, subGenus)

remainder <- anti_join(species, all_species_atts)

# check that there are no duplicates
all_spp <- all_species_atts %>% select(-assigned_valueURI,-assigned_propertyURI, -prefName, -ontoName, -grouping, -notes)
all_spp_distinct <- all_species_atts %>% select(-assigned_valueURI, -assigned_propertyURI, -prefName, -ontoName, -grouping, -notes) %>% distinct()
isTRUE(length(all_spp$attributeName) == length(all_spp_distinct$attributeName))

# clean up global environment
rm(ADFG_species_code, all_spp, all_spp_distinct, common_name, common_name_product, remainder, sci_name, species, species_code, subGenus, tempA, tempB)
