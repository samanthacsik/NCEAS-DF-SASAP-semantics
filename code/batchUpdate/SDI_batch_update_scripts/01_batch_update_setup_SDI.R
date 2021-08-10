# title: Data organization and setup for batch update of datapackages with semantic annotations -- SALMON DATA INTEGRATION TEST PORTAL
# author: "Sam Csik"
# date created: "2021-08-03"
# date edited: "2021-08-03"
# R version: 3.6.3
# input: 
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

source(here::here("code", "annotation_prep", "SDI_annotation_prep", "SDI_annotation_prep.R"))

# 001: 2021-08-xx@xx:xx ------------------------------------------------------------------------------------------------
# original rm: resource_map_urn:uuid:fb214067-160a-4f65-a217-00a1b1205c25
# original URL: https://dev.nceas.ucsb.edu/view/urn%3Auuid%3Ace3b4f4d-180c-4df7-bde8-49246495a5a4
# new rm: 
# new URL:
# post-update metadata PID: 

# SDI_atts_001 <- SDI_attributes_all %>%
#   filter(update_id == "001")
# 
# SDI_spp_001 <- SDI_species %>%
#   filter(update_id == "001")
# 
# SDI_lengths_001 <- SDI_lengths %>%
#   filter(update_id == "001")
# 
# rm(SDI_lengths, SDI_species)

# 002: 2021-08-xx@xx:xx ------------------------------------------------------------------------------------------------
# original rm: resource_map_urn:uuid:eecf9ead-a2a5-4253-8e3f-2cc51d9c94da
# original URL: https://dev.nceas.ucsb.edu/view/urn%3Auuid%3A74f8ac15-19bd-4fba-862b-3b6ef9088a6e
# new rm: 
# new URL:
# post-update metadata PID: 

# SDI_atts_002 <- SDI_attributes_all %>%
#   filter(update_id == "002")
# 
# SDI_spp_002 <- SDI_species %>%
#   filter(update_id == "002")
# 
# SDI_lengths_002 <- SDI_lengths %>%
#   filter(update_id == "002")
# 
# rm(SDI_lengths, SDI_species)

# 003: 2021-08-xx@xx:xx ------------------------------------------------------------------------------------------------
# original rm: resource_map_urn:uuid:5a282ed9-d043-4052-9d0f-22682e67cf0b
# original URL: https://dev.nceas.ucsb.edu/view/urn%3Auuid%3A3c6f106a-84ea-4dea-b536-fe1e440c5905
# new rm: 
# new URL:
# post-update metadata PID: 

# SDI_atts_003 <- SDI_attributes_all %>%
#   filter(update_id == "003")
# 
# SDI_spp_003 <- SDI_species %>%
#   filter(update_id == "003")
# 
# SDI_lengths_003 <- SDI_lengths %>%
#   filter(update_id == "003")
# 
# rm(SDI_lengths, SDI_species)

# 004: 2021-08-xx@xx:xx ------------------------------------------------------------------------------------------------
# original rm: resource_map_urn:uuid:77bf16c1-2120-466f-8f5e-f5694d56870a
# original URL: https://dev.nceas.ucsb.edu/view/urn%3Auuid%3A77bf16c1-2120-466f-8f5e-f5694d56870a
# new rm: 
# new URL:
# post-update metadata PID: 
 
# SDI_atts_004 <- SDI_attributes_all %>%
#   filter(update_id == "004")

# 005: 2021-08-xx@xx:xx ------------------------------------------------------------------------------------------------
# original rm: resource_map_urn:uuid:5624cbc2-9f95-4ddd-a342-c2049dadbf69
# original URL: https://dev.nceas.ucsb.edu/view/urn%3Auuid%3A5624cbc2-9f95-4ddd-a342-c2049dadbf69
# new rm: 
# new URL:
# post-update metadata PID: 

# SDI_atts_005 <- SDI_attributes_all %>%
#   filter(update_id == "005")

# 006: 2021-08-xx@xx:xx ------------------------------------------------------------------------------------------------
# original rm: resource_map_urn:uuid:4ad48407-8044-4f4a-9596-18e9cb221656
# original URL: https://dev.nceas.ucsb.edu/view/urn%3Auuid%3A4ad48407-8044-4f4a-9596-18e9cb221656
# new rm: 
# new URL:
# post-update metadata PID: 

# SDI_atts_006 <- SDI_attributes_all %>%
#   filter(update_id == "006")





