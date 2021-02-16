# title: Identifying attributes to be annotated -- "precipitation"
# author: "Sam Csik"
# date created: "2021-02-04"
# date edited: "2021-02-04"
# R version: 3.6.3
# input: "data/queries/query2020-10-09/fullQuery_semAnnotations2020-10-09_attributes.csv"
# output: 

##########################################################################################
# Summary
##########################################################################################

# Identifying attributes related to "precipitation"

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

precipitation <- attributes %>% 
  filter(str_detect(attributeDefinition, "(?i)precipitation"))

##########################################################################################
# determine appropriate valueURIs
##########################################################################################

#############################
# total monthly precipitation
#############################

tempA <- precipitation %>% 
  filter(str_detect(attributeDefinition, "(?i)total precipitation in")) 

tempB <- precipitation %>% 
  filter(attributeDefinition == "Total precipitation")

monthly_total_precip <- rbind(tempA, tempB) %>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/ECSO_00001237"),
         assigned_propertyURI = rep(""),
         notes = rep("monthly total precipitation"))

#############################
# quarlerly mean preciptiation
#############################

tempC <- precipitation %>% 
  filter(str_detect(attributeDefinition, "(?i)quarter")) 

tempD <- precipitation %>% 
  filter(attributeDefinition == "Mean precipitation") 

quarterly_mean_precip <- rbind(tempC, tempD) %>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/ECSO_00001237"),
         assigned_propertyURI = rep(""),
         notes = rep("quarterly mean precipitation"))

#############################
# annual mean preciptiation
#############################

annual_mean_precipitation <- precipitation %>% 
  filter(entityName %in% c("precip_regional_yearly_wide.csv", "precip_hucs_yearly_wide.csv")) %>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/ECSO_00001237"),
         assigned_propertyURI = rep(""),
         notes = rep("annual mean precipitation"))

##########################################################################################
# combine and ensure no duplicates
##########################################################################################

all_precipitation_atts <- rbind(monthly_total_precip, quarterly_mean_precip, annual_mean_precipitation)

remainder <- anti_join(precipitation, all_precipitation_atts)

# check that there are no duplicates
all_precipitation <- all_precipitation_atts %>% select(-assigned_valueURI, - assigned_propertyURI, -notes)
all_precipitation_distinct <- all_precipitation_atts %>% select(-assigned_valueURI, - assigned_propertyURI, -notes) %>% distinct()
isTRUE(length(all_precipitation$attributeName) == length(all_precipitation_distinct$attributeName))

# clean up global environment
rm(monthly_total_precip, quarterly_mean_precip, annual_mean_precipitation, tempA, tempB, tempC, tempD, all_precipitation, all_precipitation_distinct, remainder)