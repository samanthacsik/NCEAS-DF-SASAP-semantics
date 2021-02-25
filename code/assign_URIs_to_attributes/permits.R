# title: Identifying attributes to be annotated -- "permits/lisence" 
# author: "Sam Csik"
# date created: "2021-02-09"
# date edited: "2021-02-23"
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
         str_detect(entityName, "(?i)SportFishingLicenses") |
         identifier %in% c("doi:10.5063/F19C6VQ2", "doi:10.5063/F19C6VQ2"),
         !attributeDefinition %in% c("Year measurements were taken", "year of study", "year measurements were taken"))

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


#############################
# number of permit holders by age class
#############################

num_permitHolders_by_ageClass <- permits %>% 
  filter(entityName %in% c("ageClassDistribution4.csv"), 
         attributeUnit == "number", 
         attributeName != "Total") %>% 
  mutate(assigned_valueURI = rep(""),
         assigned_propertyURI = rep(""),
         notes = rep("number of permit holders, by age class"))
         
#############################
# percent of permit held by individuals in a given age class
#############################

perc_permits_by_ageClass <- permits %>% 
  filter(entityName %in% c("ageClassDistribution4.csv"),
         attributeUnit == "dimensionless") %>% 
  mutate(assigned_valueURI = rep(""),
         assigned_propertyURI = rep(""),
         notes = rep("percent of permits held by individuals within a given age class"))


#############################
# permit type/description
#############################

permitType <- permits %>% 
  filter(attributeName %in% c("Permit_Description", "Permit_Type_Name", "PermitType", 
                              "Permit_Type_Name", "type", "permitTypeName", "P_TYPE", 
                              "type_clean", "Permit.Type")) %>% 
  mutate(assigned_valueURI = rep(""),
         assigned_propertyURI = rep(""),
         notes = rep("permit type or description"))

#############################
# year permit was issued
#############################

permit_issueYear <- permits %>% 
  filter(attributeName %in% c("YEAR","YearIssued"),
         entityName != "transfersRelationshipByCommunity.csv") %>% 
  mutate(assigned_valueURI = rep(""),
         assigned_propertyURI = rep(""),
         notes = rep("year permit was issued"))

#############################
# number of issued permits
#############################

num_permitsIssued <- permits %>% 
  filter(str_detect(attributeDefinition, "(?i)issued"),
         !attributeName %in% c("ISSUE_DATE", "X.ISSUE_DATE", "IssueDate", "YEAR", 
                               "YearIssued", "PermitType", "Year", "Permit.Number", "Area"),
         !str_detect(attributeDefinition, "(?i)transferrable"),
         !str_detect(attributeDefinition, "(?i)interim")) %>% 
  mutate(assigned_valueURI = rep(""),
         assigned_propertyURI = rep(""),
         notes = rep("number of permits issued"))

num_interimPermitsIssued <- permits %>% 
  filter(str_detect(attributeDefinition, "(?i)issued"),
         !attributeName %in% c("ISSUE_DATE", "X.ISSUE_DATE", "IssueDate", "YEAR", 
                               "YearIssued", "PermitType", "Year", "Permit.Number", "Area"),
         str_detect(attributeDefinition, "(?i)interim")) %>% 
  mutate(assigned_valueURI = rep(""),
         assigned_propertyURI = rep(""),
         notes = rep("number of interim permits issued"))

num_transferablePermitsIssued <- permits %>% 
  filter(str_detect(attributeDefinition, "(?i)issued"),
         !attributeName %in% c("ISSUE_DATE", "X.ISSUE_DATE", "IssueDate", "YEAR", 
                               "YearIssued", "PermitType", "Year", "Permit.Number", "Area"),
         str_detect(attributeDefinition, "(?i)transferrable")) %>% 
  mutate(assigned_valueURI = rep(""),
         assigned_propertyURI = rep(""),
         notes = rep("number of transferable permits issued"))

#############################
# number of permits transferred
#############################

num_permitsTransferred <- permits %>% 
  filter(str_detect(attributeDefinition, "(?i)number of permits transferred")) %>% 
  mutate(assigned_valueURI = rep(""),
         assigned_propertyURI = rep(""),
         notes = rep("number permits transferred"))

#############################
# number permits returned
#############################

num_permitsReturned <- permits %>% 
  filter(str_detect(attributeDefinition, "(?i)number of permits returned")) %>% 
  mutate(assigned_valueURI = rep(""),
         assigned_propertyURI = rep(""),
         notes = rep("number permits returned"))

#############################
# number of permits held
#############################

num_permitsHeld <- permits %>% 
  filter(str_detect(attributeDefinition, "(?i)number of permits held"),
         entityName != "commercial_fishing.csv") %>% 
  mutate(assigned_valueURI = rep(""),
         assigned_propertyURI = rep(""),
         notes = rep("number of permits held"))

num_transferablePermitsHeld <- permits %>% 
  filter(str_detect(attributeDefinition, "(?i)number of transferable permits")) %>% 
  mutate(assigned_valueURI = rep(""),
         assigned_propertyURI = rep(""),
         notes = rep("number of transferable permits held"))
  
#############################
# mean age of __
#############################

mean_age_UNSORTED <- permits %>% 
  filter(str_detect(attributeDefinition, "(?i)mean age")) %>% 
  mutate(assigned_valueURI = rep(""),
         assigned_propertyURI = rep(""),
         notes = rep("mean age of __ (UNSORTED)"))

#############################
# UNSORTED -- REMOVE THESE FROM MASTER LIST TO CLEAN UP BUT FIGURE OUT WHAT TO DO WITH THESE LATER
#############################

UNSORTED <- permits %>% 
  filter(attributeName %in% c("CONFIDENTIAL", "DCCED/CFAB", "Transfer_DCCED/CFAB", "DCCED.CFAB")) %>% 
  mutate(assigned_valueURI = rep(""),
         assigned_propertyURI = rep(""),
         notes = rep("CURRENTLY UNSORTED, NEED TO BE ADDRESSED"))

##########################################################################################
# combine and ensure no duplicates
##########################################################################################

all_permit_atts <- rbind(licenseUSCitizenship, cityOfResidence, stateOfResidence, countryOfResidence, licenseClassCode, licenseTypeCode, licenseEndorsementNum, sexOfLicenseHolder, licenseIssueDate, licenseNum, licenseYear, licenseVendorNum, licenseZipCode, num_permitHolders_by_ageClass, perc_permits_by_ageClass, permitType, permit_issueYear, num_permitsIssued, num_interimPermitsIssued, num_transferablePermitsIssued, UNSORTED, num_permitsTransferred, num_permitsReturned, mean_age_UNSORTED, num_transferablePermitsHeld, num_permitsHeld)

remainder <- anti_join(permits, all_permit_atts)

# check that there are no duplicates
all_permits <- all_permit_atts %>% select(-assigned_valueURI,-assigned_propertyURI, -notes)
all_permits_distinct <- all_permit_atts %>% select(-assigned_valueURI, -assigned_propertyURI, -notes) %>% distinct()
isTRUE(length(all_permits$attributeName) == length(all_permits_distinct$attributeName))

# clean up global environment
rm(permits, TlicenseUSCitizenship, cityOfResidence, stateOfResidence, countryOfResidence, licenseClassCode, licenseTypeCode, licenseEndorsementNum, sexOfLicenseHolder, licenseIssueDate, licenseNum, licenseYear, licenseVendorNum, licenseZipCode, num_permitHolders_by_ageClass, perc_permits_by_ageClass, permitType, permit_issueYear, num_permitsIssued, num_interimPermitsIssued, num_transferablePermitsIssued, num_permitsTransferred, num_permitsReturned, mean_age_UNSORTED, num_transferablePermitsHeld, num_permitsHeld, UNSORTED, remainder, all_permits, all_permits_distinct)

  
