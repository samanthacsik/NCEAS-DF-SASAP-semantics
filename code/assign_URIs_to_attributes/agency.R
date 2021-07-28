# title: Identifying attributes to be annotated -- "agency"
# author: "Sam Csik"
# date created: "2021-02-04"
# date edited: "2021-02-04"
# R version: 3.6.3
# input: "data/queries/query2020-10-09/fullQuery_semAnnotations2020-10-09_attributes.csv"
# output: 

##########################################################################################
# Summary
##########################################################################################

# Identifying attributes related to "agency"

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

agency <- attributes %>% 
  filter(str_detect(attributeName, "(?i)agency") |
         str_detect(attributeDefinition, "(?i)agency"))

##########################################################################################
# determine appropriate valueURIs
##########################################################################################

#############################
# agency name/acronym or code
#############################

agency_name <- agency %>% 
  filter(attributeName %in% c("Agency", "AGENCY", "agency_cd", "SourceName", "IncidentAgency", "AGY_SHORT_NAME", "RelAgency")) %>% 
  mutate(assigned_valueURI = rep("tbd"),
         assigned_propertyURI = rep("tbd"),
         propertyURI_label = rep("tbd"),
         prefName = rep("tbd"),
         ontoName = rep("tbd"),
         grouping = rep("agency_name"),
         notes = rep("agency name"))

agency_code <- agency %>% 
  filter(attributeName %in% c("AGY_NUM")) %>% 
  mutate(assigned_valueURI = rep("tbd"),
         assigned_propertyURI = rep("tbd"),
         propertyURI_label = rep("tbd"),
         prefName = rep("tbd"),
         ontoName = rep("tbd"),
         grouping = rep("agency_code"),
         notes = rep("numeric identifier of agency"))

#############################
# contact person
#############################

contact_person <- agency %>% 
  filter(attributeName %in% c("Contact_person")) %>% 
  mutate(assigned_valueURI = rep("tbd"),
         assigned_propertyURI = rep("tbd"),
         propertyURI_label = rep("tbd"),
         prefName = rep("tbd"),
         ontoName = rep("tbd"),
         grouping = rep("contact_person"),
         notes = rep("contact person at agency"))

#############################
# contact email
#############################

contact_email <- agency %>% 
  filter(attributeName %in% c("Contact_email")) %>% 
  mutate(assigned_valueURI = rep("tbd"),
         assigned_propertyURI = rep("tbd"),
         propertyURI_label = rep("tbd"),
         prefName = rep("tbd"),
         ontoName = rep("tbd"),
         grouping = rep("contact_email"),
         notes = rep("contact email at agency"))

#############################
# contact telephone
#############################

contact_telephone <- agency %>% 
  filter(attributeName %in% c("Contact_telephone")) %>% 
  mutate(assigned_valueURI = rep("tbd"),
         assigned_propertyURI = rep("tbd"),
         propertyURI_label = rep("tbd"),
         prefName = rep("tbd"),
         ontoName = rep("tbd"),
         grouping = rep("contact_telephone"),
         notes = rep("contact phone number at agency"))

#############################
# hyperlink to agency
#############################

agency_hyperlink <- agency %>% 
  filter(attributeName %in% c("Link")) %>% 
  mutate(assigned_valueURI = rep("tbd"),
         assigned_propertyURI = rep("tbd"),
         propertyURI_label = rep("tbd"),
         prefName = rep("tbd"),
         ontoName = rep("tbd"),
         grouping = rep("agency_hyperlink"),
         notes = rep("agency hyperlink"))

##########################################################################################
# combine and ensure no duplicates
##########################################################################################

all_agency_atts <- rbind(agency_name, agency_code, contact_person, contact_email, contact_telephone, agency_hyperlink)

remainder <- anti_join(agency, all_agency_atts)

# check that there are no duplicates
all_agency <- all_agency_atts %>% select(-assigned_valueURI, -assigned_propertyURI, -prefName, -ontoName, -grouping, -notes)
all_agency_distinct <- all_agency_atts %>% select(-assigned_valueURI, -assigned_propertyURI, -prefName, -ontoName, -grouping, -notes) %>% distinct()
isTRUE(length(all_agency$attributeName) == length(all_agency_distinct$attributeName))

# clean up global environment
rm(agency, agency_name, agency_code, contact_person, contact_email, contact_telephone, agency_hyperlink, remainder, all_agency, all_agency_distinct)
