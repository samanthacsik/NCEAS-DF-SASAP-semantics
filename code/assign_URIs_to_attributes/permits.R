# title: Identifying attributes to be annotated -- "permits/lisence" 
# author: "Sam Csik"
# date created: "2021-02-09"
# date edited: "2021-02-09"
# R version: 3.6.3
# input: "data/queries/query2020-10-09/fullQuery_semAnnotations2020-10-09_attributes.csv"
# output: 

##########################################################################################
# Summary
##########################################################################################

# Identifying attributes related to "permits/license"
# NOTE: are permits different than licenses??
# NEED TO COME BACK TO THESE

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

permits <- attributes %>% 
  filter(str_detect(attributeDefinition, "(?i)permit") |
         str_detect(entityName, "(?i)SportFishingLicenses"))

##########################################################################################
# determine appropriate valueURIs
##########################################################################################

#############################
# license US citizenship (y/n)
#############################

licenseUSCitizenship <- permits %>% 
  filter(attributeName %in% c("CITIZEN", "USCitizen", "X.CITIZEN")) %>% 
  mutate(assigned_valueURI = rep(""),
         assigned_propertyURI = rep(""),
         notes = rep("license holder is US citizen (y/n)"))

#############################
# city of permit holder 
#############################

cityOfResidence <- permits %>% 
  filter(str_detect(attributeName, "(?i)city"),
         attributeName != "TOCITY" |
         attributeName %in% c("MailingCity")) %>% 
  mutate(assigned_valueURI = rep(""),
         assigned_propertyURI = rep(""),
         notes = rep("license holder city of residence"))

#############################
# state of permit holder 
#############################

stateOfResidence <- permits %>% 
  filter(attributeName %in% c("STATE", "MailingState", "X.STATE", "StateProvinceCode")) %>% 
  mutate(assigned_valueURI = rep(""),
         assigned_propertyURI = rep(""),
         notes = rep("license holder state of residence"))

#############################
# country of permit holder 
#############################

countryOfResidence <- permits %>% 
  filter(str_detect(attributeName, "(?i)country") |
         attributeName %in% c("MailingCountry")) %>% 
  mutate(assigned_valueURI = rep(""),
         assigned_propertyURI = rep(""),
         notes = rep("license holder country of residence"))

#############################
# license class code
#############################

licenseClassCode <- permits %>% 
  filter(attributeName %in% c("CLASS_CODE", "Class.Code", "ProductClassCode", "X.CLASS_CODE")) %>% 
  mutate(assigned_valueURI = rep(""),
         assigned_propertyURI = rep(""),
         notes = rep("license class code"))

#############################
# license type code
#############################

licenseTypeCode <- permits %>% 
  filter(attributeName %in% c("TYPE_CODE", "Type.Code", "License Year", "X.TYPE_CODE")) %>% 
  mutate(assigned_valueURI = rep(""),
         assigned_propertyURI = rep(""),
         notes = rep("license type code"))

#############################
# license endorsement number
#############################

licenseEndorsementNum <- permits %>% 
  filter(attributeName %in% c("EndorsementNumber")) %>% 
  mutate(assigned_valueURI = rep(""),
         assigned_propertyURI = rep(""),
         notes = rep("license endorsement number"))

#############################
# sex of license holder
#############################

sexOfLicenseHolder <- permits %>% 
  filter(attributeName %in% c("Gender", "SEX", "X.SEX")) %>% 
  mutate(assigned_valueURI = rep(""),
         assigned_propertyURI = rep(""),
         notes = rep("sex of license holder"))

#############################
# license issue date
#############################

licenseIssueDate <- permits %>% 
  filter(attributeName %in% c("ISSUE_DATE", "IssueDate", "X.ISSUE_DATE")) %>% 
  mutate(assigned_valueURI = rep(""),
         assigned_propertyURI = rep(""),
         notes = rep("license issue date"))

#############################
# license number
#############################

licenseNum <- permits %>% 
  filter(attributeName %in% c("LIC_NUM", "License.Number", "X.LIC_NUM")) %>% 
  mutate(assigned_valueURI = rep(""),
         assigned_propertyURI = rep(""),
         notes = rep("license number"))

#############################
# license year (also includes permit years)
#############################

licenseYear <- permits %>% 
  filter(attributeName %in% c("LIC_YR", "X.LIC_YR", "Year")) %>% 
  mutate(assigned_valueURI = rep(""),
         assigned_propertyURI = rep(""),
         notes = rep("license year"))

#############################
# license vendor number
#############################

licenseVendorNum <- permits %>% 
  filter(attributeName %in% c("VENDOR", "X.VENDOR", "VendorNumber")) %>% 
  mutate(assigned_valueURI = rep(""),
         assigned_propertyURI = rep(""),
         notes = rep("license vendor number"))

#############################
# license zip code
#############################

licenseZipCode <- permits %>% 
  filter(attributeName %in% c("ZIP", "X.ZIP", "MailingZip", "Zip", "Zip.Code")) %>% 
  mutate(assigned_valueURI = rep(""),
         assigned_propertyURI = rep(""),
         notes = rep("license zip code"))
  
##########################################################################################
# combine and ensure no duplicates
##########################################################################################

all_permit_atts <- rbind(licenseUSCitizenship, cityOfResidence, stateOfResidence, countryOfResidence, licenseClassCode, licenseTypeCode, licenseEndorsementNum, sexOfLicenseHolder, licenseIssueDate, licenseNum, licenseYear, licenseVendorNum, licenseZipCode)

remainder <- anti_join(permits, all_permit_atts)

# check that there are no duplicates
all_permits <- all_permit_atts %>% select(-assigned_valueURI,-assigned_propertyURI, -notes)
all_permits_distinct <- all_permit_atts %>% select(-assigned_valueURI, -assigned_propertyURI, -notes) %>% distinct()
isTRUE(length(all_permits$attributeName) == length(all_permits_distinct$attributeName))

# clean up global environment
rm(permits, TlicenseUSCitizenship, cityOfResidence, stateOfResidence, countryOfResidence, licenseClassCode, licenseTypeCode, licenseEndorsementNum, sexOfLicenseHolder, licenseIssueDate, licenseNum, licenseYear, licenseVendorNum, licenseZipCode, remainder, all_permits, all_permits_distinct)

  
