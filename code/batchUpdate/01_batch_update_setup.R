# title: Data organization and setup for batch update of datapackages with semantic annotations -- SASAP TESTING
# author: "Sam Csik"
# date created: "2021-01-27"
# date edited: "2021-05-19"
# R version: 3.6.3
# input: data/RushiTesting/RushiTesting.csv
# output: subsetted attributes df for use in script 10b_batch_update_childORunnested.R

##########################################################################################
# Summary
##########################################################################################

# NOTES:
# updated each package separately to more closely monitor the process (it's been a minute since I've worked on this code). 
# technically, all packages can be run at the same time

# load necessary packages, get token, set mn, etc.
# wrangle/filter attribute data to batch update subsets at a time
# does NOT include any ACADIS or LTER datapackages; all datapackages are PUBLIC
# packages are sorted by type (e.g. standalone, child, parent, etc), identifier type (DOI vs. UUID) and size (small <= 20 datasets; medium 21 - 100 datasets; large 101 - 300 datasets; xl > 300 datasets) for batch-update groupings 

##########################################################################################
# General Setup
##########################################################################################

##############################
# load packages
##############################

library(dataone)
library(datapack)
library(arcticdatautils) 
library(EML)
library(uuid)
library(tryCatchLog)
library(futile.logger) 
library(tidyverse)

##############################
# get token, set nodes
##############################

# get token reminder
# options(dataone_test_token = "...")

# set nodes 
# d1c_prod <- dataone::D1Client("PROD", "urn:node:ARCTIC")
# knb <- dataone::D1Client("PROD", "urn:node:KNB")
devnceas <- dataone::D1Client("STAGING2", "urn:node:mnTestKNB")

##############################
# configure tryCatchLog and create new hash/vector for verying id uniqueness
##############################

# configure tryCatchLog 
flog.appender(appender.file("error.log")) # choose files to log errors to
flog.threshold(ERROR) # set level of error logging (options: TRACE, DEBUG, INFO, WARM, ERROR, FATAL)

# create hash to store all auto-generated attribute ids (to ensure uniqueness; see `verify_attribute_id_isUnique()`) 
validate_attributeID_hash <- new.env(hash = TRUE)

# create empty vector to store duplicate attribute ids
duplicate_ids <- c()

##############################
# import data 
##############################

attributes <- read_csv(here::here("data", "RushiTesting", "Rushi_testing.csv"))

# col_types = cols(.default = col_character())) %>% 
#   mutate(num_datasets = as.numeric(num_datasets))

#########################################################################################
# Data Subsets 
##########################################################################################

# original: doi:10.5063/F1KD1W57; new: resource_map_urn:uuid:f286a177-6ed1-44d3-a553-d0c52d1e7a57
# post-update metadata PID: urn:uuid:f8e8bf6e-ce04-4045-94f4-9314e1219d58
# https://search.dataone.org/view/doi:10.5063/F1KD1W57
# https://dev.nceas.ucsb.edu/view/urn%3Auuid%3Ae7588688-0f0b-49e5-841e-85372db2908f

# test1 <- attributes %>% 
#   filter(viewURL %in% c("https://search.dataone.org/view/doi:10.5063/F1KD1W57")) %>% 
#   filter(assigned_valueURI != "tbd") %>% 
#   rename(identifierOriginal = identifier) %>% 
#   mutate(testIdentifier = rep("resource_map_urn:uuid:f286a177-6ed1-44d3-a553-d0c52d1e7a57")) %>% 
#   rename(identifier = testIdentifier)

# ------------------------------------------------------------------------------------------------
# original: doi:10.5063/F1MK6B60; new: resource_map_urn:uuid:243ffbcb-a4a1-406e-b3d5-3b9f569dd41f
# post-update metadata PID: urn:uuid:92571685-6cc1-45fe-b401-4a811d170393
# https://search.dataone.org/view/doi:10.5063/F1MK6B60
# https://dev.nceas.ucsb.edu/view/urn%3Auuid%3A29775493-a818-4cf9-b6dd-d01a19c8dcfd

# test2 <- attributes %>% 
#   filter(viewURL %in% c("https://search.dataone.org/view/doi:10.5063/F1MK6B60")) %>% 
#   filter(assigned_valueURI != "tbd") %>% 
#     rename(identifierOriginal = identifier) %>%
#     mutate(testIdentifier = rep("resource_map_urn:uuid:243ffbcb-a4a1-406e-b3d5-3b9f569dd41f")) %>%
#     rename(identifier = testIdentifier)

# ------------------------------------------------------------------------------------------------
# original: doi:10.5063/F1542KVC; new: resource_map_urn:uuid:ae3c5617-970d-4d61-867f-ca2f9758531c
# post-update metadata PID: 
# https://search.dataone.org/view/doi:10.5063/F1542KVC
# https://dev.nceas.ucsb.edu/view/urn%3Auuid%3A461fa59f-efdd-4080-b9e4-60e32687ca98

# COME BACK TO THIS ONE

spp3 <- read_csv(here::here("data", "RushiTesting", "speciesData", "HighSeas_tag_recovery_database.csv"))
unique(spp$Species) # CHUM, SOCKEYE, PINK, COHO, CHINOOK, STEELHEAD

test3 <- attributes %>% 
  filter(viewURL %in% c("https://search.dataone.org/view/doi:10.5063/F1542KVC")) %>% 
  # filter(assigned_valueURI != "tbd") %>% 
  #filter(!attributeName %in% c("RecSex", "Species")) %>% 
  rename(identifierOriginal = identifier) %>%
  mutate(testIdentifier = rep("resource_map_urn:uuid:ae3c5617-970d-4d61-867f-ca2f9758531c")) %>%
  rename(identifier = testIdentifier)

# ------------------------------------------------------------------------------------------------
# original: doi:10.5063/F1639N0M; new: resource_map_urn:uuid:1dc641c2-fc89-47f2-95d2-901fb7f8afa4
# post-update metadata PID: urn:uuid:230bbbd8-9d39-4b9b-b573-da29b6a60443
# https://search.dataone.org/view/doi:10.5063/F1639N0M
# https://dev.nceas.ucsb.edu/view/urn%3Auuid%3A29eda9ca-e82b-4da0-85b7-d7796c85193b

# test4 <- attributes %>% 
#   filter(viewURL %in% c("https://search.dataone.org/view/doi:10.5063/F1639N0M")) %>% 
#   filter(assigned_valueURI != "tbd") %>% 
#   filter(prefName != "number of years") %>% 
#   rename(identifierOriginal = identifier) %>%
#   mutate(testIdentifier = rep("resource_map_urn:uuid:1dc641c2-fc89-47f2-95d2-901fb7f8afa4")) %>%
#   rename(identifier = testIdentifier)

# ------------------------------------------------------------------------------------------------
# original: doi:10.5063/F1891459; new: resource_map_urn:uuid:7515b8e6-7fdb-460f-a4ec-7b385ad3a330
# post-update metadata PID: 
# https://search.dataone.org/view/doi:10.5063/F1891459
# https://dev.nceas.ucsb.edu/view/urn%3Auuid%3Aa88f8e1f-8eca-437a-8853-e813eac2ad01

spp5a <- read_csv(here::here("data", "RushiTesting", "speciesData", "raw_brood_table_2019_07_16.csv"))
unique(spp5a$Species) # Sockeye

spp5b <- read_csv(here::here("data", "RushiTesting", "speciesData", "StockInfo.csv"))
unique(spp5b$Species) # Sockeye

test5 <- attributes %>% 
  filter(viewURL %in% c("https://search.dataone.org/view/doi:10.5063/F1891459")) %>% 
  filter(assigned_valueURI != "tbd") %>% 
  filter(prefName != "Species") %>% 
  rename(identifierOriginal = identifier) %>%
  mutate(testIdentifier = rep("resource_map_urn:uuid:1dc641c2-fc89-47f2-95d2-901fb7f8afa4")) %>%
  rename(identifier = testIdentifier)
