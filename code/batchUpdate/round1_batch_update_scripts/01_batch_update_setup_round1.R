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
knb <- dataone::D1Client("PROD", "urn:node:KNB")
# devnceas <- dataone::D1Client("STAGING2", "urn:node:mnTestKNB")

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

source(here::here("code", "annotation_prep", "round1_annotation_prep", "round1_annotation_prep.R"))

attributes <- round1
rm(round1)

# attributes <- read_csv(here::here("data", "annotationPrep", "round1_allAttributes.csv"))
# col_types = cols(.default = col_character())) %>% 
#   mutate(num_datasets = as.numeric(num_datasets))

# 001: 2021-08-xx@xx:xx ------------------------------------------------------------------------------------------------
# original metadata PID: doi:10.5063/F1416VB4
# original URL: https://search.dataone.org/view/doi:10.5063/F1416VB4
# round1_001 <- attributes %>%
#   filter(ID == "001")
# 
# round1_spp_001 <- round1_species %>%
#   filter(ID == "001")
# 
# round1_lengths_001 <- round1_fishLengths_TYPES %>%
#   filter(ID == "001")
# 
# rm(round1_fishLengths_TYPES, round1_species)


# 002: 2021-08-xx@xx:xx ------------------------------------------------------------------------------------------------
# original metadata PID: doi:10.5063/F14B2ZMJ
# original URL: https://search.dataone.org/view/doi:10.5063/F14B2ZMJ
# round1_002 <- attributes %>%
#   filter(ID == "002")
# 
# round1_spp_002 <- round1_species %>%
#   filter(ID == "002")
# 
# round1_lengths_002 <- round1_fishLengths_TYPES %>%
#   filter(ID == "002")
# 
# rm(round1_fishLengths_TYPES, round1_species)

# 003: 2021-08-xx@xx:xx ------------------------------------------------------------------------------------------------
# original metadata PID: doi:10.5063/F14Q7S94
# original URL: https://search.dataone.org/view/doi:10.5063/F14Q7S94
# round1_003 <- attributes %>%
#  filter(ID == "003")
# 
# round1_spp_003 <- round1_species %>%
#   filter(ID == "003")
# 
# round1_lengths_003 <- round1_fishLengths_TYPES %>%
#   filter(ID == "003")
# 
# rm(round1_fishLengths_TYPES, round1_species)

# 004: 2021-08-xx@xx:xx ------------------------------------------------------------------------------------------------
# original metadata PID: doi:10.5063/F1513WHZ
# original URL: https://search.dataone.org/view/doi:10.5063/F1513WHZ
# round1_004 <- attributes %>%
#   filter(ID == "004")
# 
# round1_spp_004 <- round1_species %>%
#   filter(ID == "004")
# 
# round1_lengths_004 <- round1_fishLengths_TYPES %>%
#   filter(ID == "004")
# 
# rm(round1_fishLengths_TYPES, round1_species)

# 005: 2021-08-xx@xx:xx ------------------------------------------------------------------------------------------------
# original metadata PID: doi:10.5063/F15T3HRG
# original URL: https://search.dataone.org/view/doi:10.5063/F15T3HRG
# round1_005 <- attributes %>%
#   filter(ID == "005")
# 
# round1_spp_005 <- round1_species %>%
#   filter(ID == "005")
# 
# round1_lengths_005 <- round1_fishLengths_TYPES %>%
#   filter(ID == "005")
# 
# rm(round1_fishLengths_TYPES, round1_species)

# 006: 2021-08-xx@xx:xx ------------------------------------------------------------------------------------------------
# original metadata PID: doi:10.5063/F1610XMW
# original URL: https://search.dataone.org/view/doi:10.5063/F1610XMW
# round1_006 <- attributes %>%
#   filter(ID == "006")
# 
# round1_spp_006 <- round1_species %>%
#   filter(ID == "006")
# 
# round1_lengths_006 <- round1_fishLengths_TYPES %>%
#   filter(ID == "006")
# 
# rm(round1_fishLengths_TYPES, round1_species)

# 007: 2021-08-xx@xx:xx ------------------------------------------------------------------------------------------------
# original metadata PID: doi:10.5063/F1891459
# original URL: https://search.dataone.org/view/doi:10.5063/F1891459
# round1_007 <- attributes %>%
#   filter(ID == "007")
# 
# round1_spp_007 <- round1_species %>%
#   filter(ID == "007")
# 
# round1_lengths_007 <- round1_fishLengths_TYPES %>%
#   filter(ID == "007")
# 
# rm(round1_fishLengths_TYPES, round1_species)

# 008: 2021-08-xx@xx:xx ------------------------------------------------------------------------------------------------
# original rm: doi:10.5063/F18G8J0D
# original URL: https://search.dataone.org/view/doi:10.5063/F18G8J0D
# round1_008 <- attributes %>%
#   filter(ID == "008")
# 
# round1_spp_008 <- round1_species %>%
#   filter(ID == "008")
# 
# round1_lengths_008 <- round1_fishLengths_TYPES %>%
#   filter(ID == "008")
# 
# rm(round1_fishLengths_TYPES, round1_species)

# 009: 2021-08-xx@xx:xx ------------------------------------------------------------------------------------------------
# original metadata PID: doi:10.5063/F18K77BT
# original URL: https://search.dataone.org/view/doi:10.5063/F18K77BT
# round1_009 <- attributes %>%
#   filter(ID == "009")
# 
# round1_spp_009 <- round1_species %>%
#   filter(ID == "009")
# 
# round1_lengths_009 <- round1_fishLengths_TYPES %>%
#   filter(ID == "009")
# 
# rm(round1_fishLengths_TYPES, round1_species)

# 010: 2021-08-xx@xx:xx ------------------------------------------------------------------------------------------------
# original metadata PID: doi:10.5063/F19K48HN
# original URL: https://search.dataone.org/view/doi:10.5063/F19K48HN
# round1_010 <- attributes %>%
#   filter(ID == "010")
# 
# round1_spp_010 <- round1_species %>%
#   filter(ID == "010")
# 
# round1_lengths_010 <- round1_fishLengths_TYPES %>%
#   filter(ID == "010")
# 
# rm(round1_fishLengths_TYPES, round1_species)

# 011: 2021-08-xx@xx:xx ------------------------------------------------------------------------------------------------
# original metadata PID: doi:10.5063/F19P2ZXK
# original URL: https://search.dataone.org/view/doi:10.5063/F19P2ZXK
# round1_011 <- attributes %>%
#   filter(ID == "011")
# 
# round1_spp_011 <- round1_species %>%
#   filter(ID == "011")
# 
# round1_lengths_011 <- round1_fishLengths_TYPES %>%
#   filter(ID == "011")
# 
# rm(round1_fishLengths_TYPES, round1_species)

# 012: 2021-08-xx@xx:xx ------------------------------------------------------------------------------------------------
# original metadata PID: doi:10.5063/F11834SM
# original URL: https://search.dataone.org/view/doi:10.5063/F11834SM
# round1_012 <- attributes %>%
#   filter(ID == "012")
# 
# round1_spp_012 <- round1_species %>%
#   filter(ID == "012")
# 
# round1_lengths_012 <- round1_fishLengths_TYPES %>%
#   filter(ID == "012")
# 
# rm(round1_fishLengths_TYPES, round1_species)

# 013: 2021-08-xx@xx:xx ------------------------------------------------------------------------------------------------
# original metadata PID: doi:10.5063/F11R6NSS
# original URL: https://search.dataone.org/view/doi:10.5063/F11R6NSS
# round1_013 <- attributes %>%
#   filter(ID == "013")
# 
# round1_spp_013 <- round1_species %>%
#   filter(ID == "013")
# 
# round1_lengths_013 <- round1_fishLengths_TYPES %>%
#   filter(ID == "013")
# 
# rm(round1_fishLengths_TYPES, round1_species)

# 014: 2021-08-xx@xx:xx ------------------------------------------------------------------------------------------------
# original metadata PID: doi:10.5063/F11Z42Q5
# original URL: https://search.dataone.org/view/doi:10.5063/F11Z42Q5
# round1_014 <- attributes %>%
#   filter(ID == "014")
# 
# round1_spp_014 <- round1_species %>%
#   filter(ID == "014")
# 
# round1_lengths_014 <- round1_fishLengths_TYPES %>%
#   filter(ID == "014")
# 
# rm(round1_fishLengths_TYPES, round1_species)

# 015: 2021-08-xx@xx:xx ------------------------------------------------------------------------------------------------
# original metadata PID: doi:10.5063/F1222S1G
# original URL: https://search.dataone.org/view/doi:10.5063/F1222S1G
# round1_015 <- attributes %>%
#   filter(ID == "015")
# 
# round1_spp_015 <- round1_species %>%
#   filter(ID == "015")
# 
# round1_lengths_015 <- round1_fishLengths_TYPES %>%
#   filter(ID == "015")
# 
# rm(round1_fishLengths_TYPES, round1_species)

# 016: 2021-08-xx@xx:xx ------------------------------------------------------------------------------------------------
# original metadata PID: doi:10.5063/F1319T59
# original URL: https://search.dataone.org/view/doi:10.5063/F1319T59
# round1_016 <- attributes %>%
#   filter(ID == "016")
# 
# round1_spp_016 <- round1_species %>%
#   filter(ID == "016")
# 
# round1_lengths_016 <- round1_fishLengths_TYPES %>%
#   filter(ID == "016")
# 
# rm(round1_fishLengths_TYPES, round1_species)

# 017: 2021-08-xx@xx:xx ------------------------------------------------------------------------------------------------
# original metadata PID: doi:10.5063/F1Z899P0
# original URL: https://search.dataone.org/view/doi:10.5063/F1Z899P0
# round1_017 <- attributes %>%
#   filter(ID == "017")
# 
# round1_spp_017 <- round1_species %>%
#   filter(ID == "017")
# 
# round1_lengths_017 <- round1_fishLengths_TYPES %>%
#   filter(ID == "017")
# 
# rm(round1_fishLengths_TYPES, round1_species)

# 018: 2021-08-xx@xx:xx ------------------------------------------------------------------------------------------------
# original metadata PID: doi:10.5063/F1ZW1J77
# original URL: https://search.dataone.org/view/doi:10.5063/F1ZW1J77
# round1_018 <- attributes %>%
#   filter(ID == "018")
# 
# round1_spp_018 <- round1_species %>%
#   filter(ID == "018")
# 
# round1_lengths_018 <- round1_fishLengths_TYPES %>%
#   filter(ID == "018")
# 
# rm(round1_fishLengths_TYPES, round1_species)

# 019: 2021-08-xx@xx:xx ------------------------------------------------------------------------------------------------
# original metadata PID: doi:10.5063/F1BR8QG4
# original URL: https://search.dataone.org/view/doi:10.5063/F1BR8QG4
# round1_019 <- attributes %>%
#   filter(ID == "019")
# 
# round1_spp_019 <- round1_species %>%
#   filter(ID == "019")
# 
# round1_lengths_019 <- round1_fishLengths_TYPES %>%
#   filter(ID == "019")
# 
# rm(round1_fishLengths_TYPES, round1_species)

# 020: 2021-08-xx@xx:xx ------------------------------------------------------------------------------------------------
# original metadata PID: doi:10.5063/F1DB8030
# original URL: https://search.dataone.org/view/doi:10.5063/F1DB8030
# round1_020 <- attributes %>%
#   filter(ID == "020")
# 
# round1_spp_020 <- round1_species %>%
#   filter(ID == "020")
# 
# round1_lengths_020 <- round1_fishLengths_TYPES %>%
#   filter(ID == "020")
# 
# rm(round1_fishLengths_TYPES, round1_species)

# 021: 2021-08-xx@xx:xx ------------------------------------------------------------------------------------------------
# original metadata PID: doi:10.5063/F1DF6PHX
# original URL: https://search.dataone.org/view/doi:10.5063/F1DF6PHX
# round1_021 <- attributes %>%
#   filter(ID == "021")
# 
# round1_spp_021 <- round1_species %>%
#   filter(ID == "021")
# 
# round1_lengths_021 <- round1_fishLengths_TYPES %>%
#   filter(ID == "021")
# 
# rm(round1_fishLengths_TYPES, round1_species)


# 022: 2021-08-xx@xx:xx ------------------------------------------------------------------------------------------------
# original metadata PID: doi:10.5063/F1FF3QMV
# original URL: https://search.dataone.org/view/doi:10.5063/F1FF3QMV
# round1_022 <- attributes %>%
#   filter(ID == "022")
# 
# round1_spp_022 <- round1_species %>%
#   filter(ID == "022")
# 
# round1_lengths_022 <- round1_fishLengths_TYPES %>%
#   filter(ID == "022")
# 
# rm(round1_fishLengths_TYPES, round1_species)


# 023: 2021-08-xx@xx:xx ------------------------------------------------------------------------------------------------
# original metadata PID: doi:10.5063/F1G15Z4D
# original URL: https://search.dataone.org/view/doi:10.5063/F1G15Z4D
# round1_023 <- attributes %>%
#   filter(ID == "023")
# 
# round1_spp_023 <- round1_species %>%
#   filter(ID == "023")
# 
# round1_lengths_023 <- round1_fishLengths_TYPES %>%
#   filter(ID == "023")
# 
# rm(round1_fishLengths_TYPES, round1_species)

# 024: 2021-08-xx@xx:xx ------------------------------------------------------------------------------------------------
# original metadata PID: doi:10.5063/F1GB22B9
# original URL: https://search.dataone.org/view/doi:10.5063/F1GB22B9
# round1_024 <- attributes %>%
#   filter(ID == "024")
# 
# round1_spp_024 <- round1_species %>%
#   filter(ID == "024")
# 
# round1_lengths_024 <- round1_fishLengths_TYPES %>%
#   filter(ID == "024")
# 
# rm(round1_fishLengths_TYPES, round1_species)

# 025: 2021-08-xx@xx:xx ------------------------------------------------------------------------------------------------
# original metadata PID: doi:10.5063/F1GX48V4
# original URL: https://search.dataone.org/view/doi:10.5063/F1GX48V4
# round1_025 <- attributes %>%
#   filter(ID == "025")
# 
# round1_spp_025 <- round1_species %>%
#   filter(ID == "025")
# 
# round1_lengths_025 <- round1_fishLengths_TYPES %>%
#   filter(ID == "025")
# 
# rm(round1_fishLengths_TYPES, round1_species)

# 026: 2021-08-xx@xx:xx ------------------------------------------------------------------------------------------------
# original metadata PID: doi:10.5063/F1J38QTX
# original URL: https://search.dataone.org/view/doi:10.5063/F1J38QTX
# round1_026 <- attributes %>%
#   filter(ID == "026")

# round1_spp_026 <- round1_species %>%
#   filter(ID == "026")
# 
# round1_lengths_026 <- round1_fishLengths_TYPES %>%
#   filter(ID == "026")
# 
# rm(round1_fishLengths_TYPES, round1_species)

# 027: 2021-08-xx@xx:xx ------------------------------------------------------------------------------------------------
# original metadata PID: doi:10.5063/F1J67F66
# original URL: https://search.dataone.org/view/doi:10.5063/F1J67F66
# round1_027 <- attributes %>%
#   filter(ID == "027")
# 
# round1_spp_027 <- round1_species %>%
#   filter(ID == "027")
# 
# round1_lengths_027 <- round1_fishLengths_TYPES %>%
#   filter(ID == "027")
# 
# rm(round1_fishLengths_TYPES, round1_species)


# 028: 2021-08-xx@xx:xx ------------------------------------------------------------------------------------------------
# original metadata PID: doi:10.5063/F1K35RXV
# original URL: https://search.dataone.org/view/doi:10.5063/F1K35RXV
# round1_028 <- attributes %>%
#   filter(ID == "028")
# 
# round1_spp_028 <- round1_species %>%
#   filter(ID == "028")
# 
# round1_lengths_028 <- round1_fishLengths_TYPES %>%
#   filter(ID == "028")
# 
# rm(round1_fishLengths_TYPES, round1_species)

# 029: 2021-08-xx@xx:xx ------------------------------------------------------------------------------------------------
# original metadata PID: doi:10.5063/F1K64GBK
# original URL: https://search.dataone.org/view/doi:10.5063/F1K64GBK
# round1_029 <- attributes %>%
#   filter(ID == "029")
# 
# round1_spp_029 <- round1_species %>%
#   filter(ID == "029")
# 
# round1_lengths_029 <- round1_fishLengths_TYPES %>%
#   filter(ID == "029")
# 
# rm(round1_fishLengths_TYPES, round1_species)

# 030: 2021-08-xx@xx:xx ------------------------------------------------------------------------------------------------
# original metadata PID: doi:10.5063/F1KD1W57
# original URL: https://search.dataone.org/view/doi:10.5063/F1KD1W57
# round1_030 <- attributes %>%
#   filter(ID == "030")
# 
# round1_spp_030 <- round1_species %>%
#   filter(ID == "030")
# 
# round1_lengths_030 <- round1_fishLengths_TYPES %>%
#   filter(ID == "030")
# 
# rm(round1_fishLengths_TYPES, round1_species)

# 031: 2021-08-xx@xx:xx ------------------------------------------------------------------------------------------------
# original metadata PID: doi:10.5063/F1MK6B60
# original URL: https://search.dataone.org/view/doi:10.5063/F1MK6B60
# round1_031 <- attributes %>%
#   filter(ID == "031")
# 
# round1_spp_031 <- round1_species %>%
#   filter(ID == "031")
# 
# round1_lengths_031 <- round1_fishLengths_TYPES %>%
#   filter(ID == "031")
# 
# rm(round1_fishLengths_TYPES, round1_species)

# 032: 2021-08-xx@xx:xx ------------------------------------------------------------------------------------------------
# original metadata PID: doi:10.5063/F1NV9GHW
# original URL: https://search.dataone.org/view/doi:10.5063/F1NV9GHW
# round1_032 <- attributes %>%
#   filter(ID == "032")
# 
# round1_spp_032 <- round1_species %>%
#   filter(ID == "032")
# 
# round1_lengths_032 <- round1_fishLengths_TYPES %>%
#   filter(ID == "032")
# 
# rm(round1_fishLengths_TYPES, round1_species)

# 033: 2021-08-xx@xx:xx ------------------------------------------------------------------------------------------------
# original metadata PID: doi:10.5063/F1NZ85X6
# original URL: https://search.dataone.org/view/doi:10.5063/F1NZ85X6
# round1_033 <- attributes %>%
#   filter(ID == "033")
# 
# round1_spp_033 <- round1_species %>%
#   filter(ID == "033")
# 
# round1_lengths_033 <- round1_fishLengths_TYPES %>%
#   filter(ID == "033")
# 
# rm(round1_fishLengths_TYPES, round1_species)

# 034: 2021-08-xx@xx:xx ------------------------------------------------------------------------------------------------
# original metadata PID: doi:10.5063/F1PR7T8D
# original URL: https://search.dataone.org/view/doi:10.5063/F1PR7T8D
# round1_034 <- attributes %>%
#   filter(ID == "034")
# 
# round1_spp_034 <- round1_species %>%
#   filter(ID == "034")
# 
# round1_lengths_034 <- round1_fishLengths_TYPES %>%
#   filter(ID == "034")
# 
# rm(round1_fishLengths_TYPES, round1_species)

# 035: 2021-08-xx@xx:xx ------------------------------------------------------------------------------------------------
# original metadata PID: doi:10.5063/F1SF2TG1
# original URL: https://search.dataone.org/view/doi:10.5063/F1SF2TG1
# round1_035 <- attributes %>%
#   filter(ID == "035")
# 
# round1_spp_035 <- round1_species %>%
#   filter(ID == "035")
# 
# round1_lengths_035 <- round1_fishLengths_TYPES %>%
#   filter(ID == "035")
# 
# rm(round1_fishLengths_TYPES, round1_species)

# 036: 2021-08-xx@xx:xx ------------------------------------------------------------------------------------------------
# original metadata PID: doi:10.5063/F1SJ1HWB
# original URL: https://search.dataone.org/view/doi:10.5063/F1SJ1HWB
# round1_036 <- attributes %>%
#   filter(ID == "036")
# 
# round1_spp_036 <- round1_species %>%
#   filter(ID == "036")
# 
# round1_lengths_036 <- round1_fishLengths_TYPES %>%
#   filter(ID == "036")
# 
# rm(round1_fishLengths_TYPES, round1_species)

# 037: 2021-08-xx@xx:xx ------------------------------------------------------------------------------------------------
# original metadata PID: doi:10.5063/F1TH8JZ8
# original URL: https://search.dataone.org/view/doi:10.5063/F1TH8JZ8
# round1_037 <- attributes %>%
#   filter(ID == "037")
# 
# round1_spp_037 <- round1_species %>%
#   filter(ID == "037")
# 
# round1_lengths_037 <- round1_fishLengths_TYPES %>%
#   filter(ID == "037")
# 
# rm(round1_fishLengths_TYPES, round1_species)

# 038: 2021-08-xx@xx:xx ------------------------------------------------------------------------------------------------
# original metadata PID: doi:10.5063/F1VT1QB1
# original URL: https://search.dataone.org/view/doi:10.5063/F1VT1QB1
# round1_038 <- attributes %>%
#   filter(ID == "038")
# 
# round1_spp_038 <- round1_species %>%
#   filter(ID == "038")
# 
# round1_lengths_038 <- round1_fishLengths_TYPES %>%
#   filter(ID == "038")
# 
# rm(round1_fishLengths_TYPES, round1_species)

# 039: 2021-08-xx@xx:xx ------------------------------------------------------------------------------------------------
# original metadata PID: doi:10.5063/F1W957GP
# original URL: https://search.dataone.org/view/doi:10.5063/F1W957GP
# round1_039 <- attributes %>%
#   filter(ID == "039")
# 
# round1_spp_039 <- round1_species %>%
#   filter(ID == "039")
# 
# round1_lengths_039 <- round1_fishLengths_TYPES %>%
#   filter(ID == "039")
# 
# rm(round1_fishLengths_TYPES, round1_species)

# 040: 2021-08-xx@xx:xx ------------------------------------------------------------------------------------------------
# original metadata PID: doi:10.5063/F1X63K76
# original URL: https://search.dataone.org/view/doi:10.5063/F1X63K76
# round1_040 <- attributes %>%
#   filter(ID == "040")
# 
# round1_spp_040 <- round1_species %>%
#   filter(ID == "040")
# 
# round1_lengths_0340 <- round1_fishLengths_TYPES %>%
#   filter(ID == "040")
# 
# rm(round1_fishLengths_TYPES, round1_species)

