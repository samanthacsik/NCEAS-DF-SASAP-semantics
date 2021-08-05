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
# change 'devnceas' to 'knb' at the following locations:
  # 02_batch_update_childORunnested.R (currently line 414)
  # get_datapackage_metadata.R (currently lines 13, 21, 39)
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

attributes <- read_csv(here::here("data", "annotationPrep", "round1_allAttributes.csv"))

# col_types = cols(.default = col_character())) %>% 
#   mutate(num_datasets = as.numeric(num_datasets))

# 1: 2021-07-27@13:07 ------------------------------------------------------------------------------------------------
# original rm: resource_map_doi:10.5063/F1891459
# original URL: https://search.dataone.org/view/doi:10.5063/F1891459
# new rm: resource_map_urn:uuid:22cf0551-a0e5-45a8-82ab-47ab00aa85a4
# new URL: https://dev.nceas.ucsb.edu/view/urn%3Auuid%3A3dd897e3-46f6-4bf5-8c90-93bb9601d5cc
# post-update metadata PID: urn:uuid:3dd897e3-46f6-4bf5-8c90-93bb9601d5cc

# switch out pkg identifier for testing -- will not need this step when running for real
test1 <- attributes %>%
  filter(viewURL %in% c("https://search.dataone.org/view/doi:10.5063/F1891459")) %>%
  rename(identifierOriginal = identifier) %>%
  mutate(testIdentifier = rep("resource_map_urn:uuid:22cf0551-a0e5-45a8-82ab-47ab00aa85a4")) %>%
  rename(identifier = testIdentifier) %>% 
  drop_na(grouping) %>% 
  filter(assigned_propertyURI != "tbd")












#########################################################################################
# round 1 exploration for real deal
  # 85 total groupings
    # 70 measurementType groupings
    # 12 nameType groupings
    # 1 equipmentType groupings
    # 1 methodType groupings
    # 1 notationType groupings
#########################################################################################

a <- attributes %>% 
  drop_na(grouping) %>% 
  filter(!grouping %in% c("meshSize"))

measurementType_groupings <- a %>% # http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType
  filter(grouping %in% c(
    "annual_escapement", "daily_escapement",
    "date", "sample_year", "sample_season", "sample_month", "sample_time", "brood_year",
    "total_recruits", "num_recruits_per_spawner",
    "num_recruits_by_ageClass_0.1", "num_recruits_by_ageClass_0.2", "num_recruits_by_ageClass_0.3",
    "num_recruits_by_ageClass_0.4", "num_recruits_by_ageClass_0.5", "num_recruits_by_ageClass_1.1",
    "num_recruits_by_ageClass_1.2", "num_recruits_by_ageClass_1.3", "num_recruits_by_ageClass_1.4",
    "num_recruits_by_ageClass_1.5", "num_recruits_by_ageClass_2.1", "num_recruits_by_ageClass_2.2",
    "num_recruits_by_ageClass_2.3", "num_recruits_by_ageClass_2.4", "num_recruits_by_ageClass_3.1",
    "num_recruits_by_ageClass_3.2", "num_recruits_by_ageClass_3.3", "num_recruits_by_ageClass_3.4",
    "num_recruits_by_ageClass_4.1", "num_recruits_by_ageClass_4.2", "num_recruits_by_ageClass_4.3",
    "num_recruits_by_ageClass_2.5", "num_recruits_by_ageClass_3", "num_recruits_by_ageClass_4", 
    "num_recruits_by_ageClass_5", "num_recruits_by_ageClass_6", "num_recruits_by_ageClass_7", 
    "num_recruits_by_ageClass_8", "num_recruits_by_ageClass_1", "num_recruits_by_ageClass_2", 
    "num_recruits_by_ageClass_0.6", "num_recruits_by_ageClass_1.6",
    "salmon_abundance",
    "biomassFishHarvested", "biomassFishHarvested_byRegion", 
    "numHarvestedCommercial_byRegion","numHarvestedSport_byRegion", "numHarvestedSubsistence_byRegion", 
    "totalHarvest", "total_fishBiomass",
    "latitude", "latitudeDeg",
    "longitude", "longitudeDeg", "longitudeMin",
    "data_quality_flags",
    "fishSex", "fishLengths", "fishGirth", 
    "fish_weightKG", "fish_weightG", "avgWeight_adultSalmon",
    "fishAge", "freshwaterAge", "saltwaterAge",
    "circuliDist", 
    "monthly_total_precip", "quarterly_mean_precip", "annual_mean_precipitation",
    "avg_air_temp"
    ))

nameType_groupings <- a %>% 
  filter(grouping %in% c(
    "common_name", "sci_name", # http://schema.org/about
    "fishStockName", "ADFG_species_code", "ADFGgearCode", # https://schema.org/identifier
    "stock_id", "AWC_water_body_codes", "fishSampleID", # https://schema.org/identifier
    "errorAgeDescription", # https://schema.org/description
    "errorAgeCode", # https://schema.org/identifier 
    "gumCardNo", # https://schema.org/identifier
    "studyLocationName" # http://www.w3.org/ns/prov#atLocation
  ))

equipmentType_groupings <- a %>% 
  filter(grouping %in% c(
    "gearType"
  ))

methodType_groupings <- a %>% # http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#usesMethod OR http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#measuresUsingProtocol 
  filter(grouping %in% c(
    "sex_determination_method"
  ))

notationType_groupings <- a %>% 
  filter(grouping %in% c(
    "fishAgeEuroNotation"
  ))










#########################################################################################
# Data Subsets -- Rushi testing
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
# post-update metadata PID: urn:uuid:d0406e02-ec5e-4c8b-a21a-afa8c2bd8b63
# https://search.dataone.org/view/doi:10.5063/F1542KVC
# https://dev.nceas.ucsb.edu/view/urn%3Auuid%3A461fa59f-efdd-4080-b9e4-60e32687ca98
# https://dev.nceas.ucsb.edu/view/urn%3Auuid%3Ad0406e02-ec5e-4c8b-a21a-afa8c2bd8b63

# spp3 <- read_csv(here::here("data", "RushiTesting", "speciesData", "HighSeas_tag_recovery_database.csv"))
# unique(spp$Species) # CHUM, SOCKEYE, PINK, COHO, CHINOOK, STEELHEAD

# test3 <- attributes %>%
#   filter(viewURL %in% c("https://search.dataone.org/view/doi:10.5063/F1542KVC")) %>%
#   rename(identifierOriginal = identifier) %>%
#   mutate(testIdentifier = rep("resource_map_urn:uuid:ae3c5617-970d-4d61-867f-ca2f9758531c")) %>%
#   rename(identifier = testIdentifier)

# test3.2 <- attributes %>%
#     filter(viewURL %in% c("https://search.dataone.org/view/doi:10.5063/F1542KVC")) %>%
#     rename(identifierOriginal = identifier) %>%
#     mutate(testIdentifier = rep("resource_map_urn:uuid:d0406e02-ec5e-4c8b-a21a-afa8c2bd8b63")) %>%
#     rename(identifier = testIdentifier) 

# test3.3 directly in script 02a.3_batchUpdate_SPP3.R

# ------------------------------------------------------------------------------------------------
# original: doi:10.5063/F1639N0M; new: resource_map_urn:uuid:1dc641c2-fc89-47f2-95d2-901fb7f8afa4
# post-update metadata PID: urn:uuid:230bbbd8-9d39-4b9b-b573-da29b6a60443
# https://search.dataone.org/view/doi:10.5063/F1639N0M
# https://dev.nceas.ucsb.edu/view/urn%3Auuid%3A29eda9ca-e82b-4da0-85b7-d7796c85193b
# 
# test4 <- attributes %>%
#   filter(viewURL %in% c("https://search.dataone.org/view/doi:10.5063/F1639N0M")) %>%
#   filter(assigned_valueURI != "tbd") %>%
#   filter(prefName != "number of years") %>%
#   rename(identifierOriginal = identifier) %>%
#   mutate(testIdentifier = rep("resource_map_urn:uuid:1dc641c2-fc89-47f2-95d2-901fb7f8afa4")) %>%
#   rename(identifier = testIdentifier)

# urn:uuid:335dd277-08b8-4e8d-b8ca-922f7f7a242c
# test4.2 <- attributes %>%
#   filter(viewURL %in% c("https://search.dataone.org/view/doi:10.5063/F1639N0M")) %>%
#   filter(assigned_valueURI != "tbd") %>%
#   filter(prefName != "number of years") %>%
#   rename(identifierOriginal = identifier) %>%
#   mutate(testIdentifier = rep("resource_map_urn:uuid:230bbbd8-9d39-4b9b-b573-da29b6a60443")) %>%
#   rename(identifier = testIdentifier)

# ------------------------------------------------------------------------------------------------
# original: doi:10.5063/F1891459; new: resource_map_urn:uuid:7515b8e6-7fdb-460f-a4ec-7b385ad3a330
# post-update metadata PID: urn:uuid:641beab0-0b46-4cd5-87d7-611816faaae4
# https://search.dataone.org/view/doi:10.5063/F1891459
# https://dev.nceas.ucsb.edu/view/urn%3Auuid%3Aa88f8e1f-8eca-437a-8853-e813eac2ad01

# spp5a <- read_csv(here::here("data", "RushiTesting", "speciesData", "raw_brood_table_2019_07_16.csv"))
# unique(spp5a$Species) # Sockeye

# spp5b <- read_csv(here::here("data", "RushiTesting", "speciesData", "StockInfo.csv"))
# unique(spp5b$Species) # Sockeye

# test5 <- attributes %>% 
#   filter(viewURL %in% c("https://search.dataone.org/view/doi:10.5063/F1891459")) %>% 
#   filter(assigned_valueURI != "tbd") %>% 
#   rename(identifierOriginal = identifier) %>%
#   mutate(testIdentifier = rep("resource_map_urn:uuid:7515b8e6-7fdb-460f-a4ec-7b385ad3a330")) %>%
#   rename(identifier = testIdentifier)

# https://dev.nceas.ucsb.edu/view/urn%3Auuid%3A7e068dc4-cfc5-4120-b91e-cece549ba46d
# test5.2 <- attributes %>% 
#   filter(viewURL %in% c("https://search.dataone.org/view/doi:10.5063/F1891459")) %>% 
#   filter(assigned_valueURI != "tbd") %>% 
#   rename(identifierOriginal = identifier) %>%
#   mutate(testIdentifier = rep("resource_map_urn:uuid:641beab0-0b46-4cd5-87d7-611816faaae4")) %>%
#   rename(identifier = testIdentifier)
  
# ------------------------------------------------------------------------------------------------
# original: doi:10.5063/F1T151XN; new: resource_map_urn:uuid:075d8b92-2408-47bd-b0f7-3c2483cf53ef
# post-update metadata PID: 
# https://search.dataone.org/view/doi:10.5063/F1T151XN
# https://dev.nceas.ucsb.edu/view/urn%3Auuid%3A3772a412-c538-4184-a9be-b0e5a203f19a

# spp6a <- read_csv(here::here("data", "RushiTesting", "speciesData", "1 DistrictByYear_SASAPRegion.csv"))
# unique(spp6a$Species) # sockeye, pink, chum, coho, chinook
# 
# spp6b <- read_csv(here::here("data", "RushiTesting", "speciesData", "2 Daily.csv"))
# unique(spp6b$Species) # sockeye, pink, chum, coho, chinook
# 
# spp6c <- read_csv(here::here("data", "RushiTesting", "speciesData", "3 StatWeekByArea.csv"))
# unique(spp6c$Species) # sockeye, pink, chum, coho, chinook
# 
# spp6d <- read_csv(here::here("data", "RushiTesting", "speciesData", "4 StatAreaByYear.csv"))
# unique(spp6d$Species) # sockeye, pink, chum, coho, chinook
# 
# spp6e <- read_csv(here::here("data", "RushiTesting", "speciesData", "5 AreaByYear.csv"))
# unique(spp6e$Species) # sockeye, pink, chum, coho, chinook

# test6 <- attributes %>% 
#   filter(viewURL %in% c("https://search.dataone.org/view/doi:10.5063/F1T151XN")) %>% 
#   filter(assigned_valueURI != "tbd") %>% 
#   rename(identifierOriginal = identifier) %>%
#   mutate(testIdentifier = rep("resource_map_urn:uuid:075d8b92-2408-47bd-b0f7-3c2483cf53ef")) %>%
#   rename(identifier = testIdentifier)

# 7------------------------------------------------------------------------------------------------
# original: doi:10.5063/F12805X0; new: 
# https://search.dataone.org/view/doi:10.5063/F12805X0
# https://dev.nceas.ucsb.edu/view/urn%3Auuid%3A6c948813-23e1-4c3d-86b6-e503a1b135d8

# spp7 <- read_csv(here::here("data", "RushiTesting", "speciesData", "Hatchery_returns.csv"))
# unique(spp7$Species) # sockeye, pink, chum, coho, chinook

# test7 <- attributes %>%
#   filter(viewURL %in% c("https://search.dataone.org/view/doi:10.5063/F12805X0")) %>%
#   filter(assigned_valueURI != "tbd") %>%
#   rename(identifierOriginal = identifier) %>%
#   mutate(testIdentifier = rep("resource_map_urn:uuid:2421d2b6-2f6a-4331-a053-60e0c659b076")) %>%
#   rename(identifier = testIdentifier)

# 8------------------------------------------------------------------------------------------------
# original: doi:10.5063/F1GB22B9; new: 
# https://search.dataone.org/view/doi:10.5063/F1GB22B9
# 
# test8 <- attributes %>%
#   filter(viewURL %in% c("https://search.dataone.org/view/doi:10.5063/F1GB22B9")) %>%
#   filter(assigned_valueURI != "tbd") %>%
#   rename(identifierOriginal = identifier) %>%
#   mutate(testIdentifier = rep("")) %>%
#   rename(identifier = testIdentifier)





