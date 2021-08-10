# title: Identifying attributes to be annotated -- "dates"
# author: "Sam Csik"
# date created: "2021-02-09"
# date edited: "2021-02-09"
# R version: 3.6.3
# input: "data/queries/query2020-10-09/fullQuery_semAnnotations2020-10-09_attributes.csv"
# output: 

##########################################################################################
# Summary
##########################################################################################

# Identifying attributes related to "dates"
# NOTE: any dates related to permits or licenses will be sorted in the 'permits.R' script
# 76 unsorted attributes remaining

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

dates <- attributes %>% 
  filter(str_detect(attributeName, "(?i)date") |
         str_detect(attributeName, "(?i)year") |
         str_detect(attributeName, "(?i)month") |
         attributeName %in% c("season", "by"))

times <- attributes %>% 
  filter(str_detect(attributeName, "(?i)time"))

dates_times <- rbind(dates, times)

##########################################################################################
# determine appropriate valueURIs
##########################################################################################

#############################
# brood year
#############################

brood_year <- dates_times %>% 
  filter(attributeName %in% c("BroodYear", "Year Brood", "by") |
         attributeDefinition %in% c("Brood year")) %>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/salmon_000520"), # verified v0.2.1
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         propertyURI_label = rep("containsMeasurementsOfType"),
         prefName = rep("Brood year"),
         ontoName = rep("tbd"),
         grouping = rep("brood_year"),
         notes = rep("brood year; ASSIGN URI FOR YEAR??"))

#############################
# commercial harvest year
#############################

commHarvestYear <- dates_times %>% 
  filter(attributeDefinition %in% c("Year commercial harvest data was collected", "year of salmon harvest") |
         attributeName %in% c("OperationYear")) %>% 
  mutate(assigned_valueURI = rep("tbd"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         propertyURI_label = rep("containsMeasurementsOfType"),
         prefName = rep("tbd"),
         ontoName = rep("tbd"),
         grouping = rep("commHarvestYear"),
         notes = rep("year of commecial harvest"))

# ---- clean up repeats for BristolBay.cscv ----

commHarvestYear_BB <- commHarvestYear %>% filter(entityName == "BristolBay.csv") %>% distinct()
commHarvestYear_rest <- commHarvestYear %>% filter(entityName != "BristolBay.csv")
commHarvestYear_CLEANED <- rbind(commHarvestYear_BB, commHarvestYear_rest) # USE THIS ONE

# ----------------------------------------------

#############################
# sample year
#############################

sample_year <- dates_times %>% 
  filter(attributeName %in% c("sampleYear", "SAMPLE_YEAR", "periodyear", "data_file_year", "subs_year") |
         attributeDefinition %in% c("year of observation", "Year of observation", "year of study", "Year of the survey",
                                    "Year of harvest", "year of harvest",
                                    "Year that abundance data are from", "Year that data are from", "observation year",
                                    "year sample was taken", "year the data corresponds to", 
                                    "Year measurements were taken", "year measurements were taken",
                                    "Year data were collected", "Year surveyed", 
                                    "Year in which the survey/escapement project was", 
                                    "The year the salmon escapement data was taken", 
                                    "The year the data was sampled", "The year in which the escapement occurred.",
                                    "The year for which the estimated value applies.")) %>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/ECSO_00002050"), # verified v0.2.1
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         propertyURI_label = rep("containsMeasurementsOfType"),
         prefName = rep("year of measurement"),
         ontoName = rep("The Ecosystem Ontology"),
         grouping = rep("sample_year"),
         notes = rep("year of measurement"))

#############################
# month of measurement
#############################

sample_month <- dates_times %>% 
  filter(attributeName %in% c("month")) %>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/ECSO_00002047"), # verified v0.2.1
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         propertyURI_label = rep("containsMeasurementsOfType"),
         prefName = rep("month of year"),
         ontoName = rep("The Ecosystem Ontology"),
         grouping = rep("sample_month"),
         notes = rep("month of measurement"))

#############################
# season of measurement
#############################

sample_season <- dates_times %>% 
  filter(attributeName %in% c("season")) %>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/ECSO_00002366"), # verified v0.2.1
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         propertyURI_label = rep("containsMeasurementsOfType"),
         prefName = rep("season"),
         ontoName = rep("The Ecosystem Ontology"),
         grouping = rep("sample_season"),
         notes = rep("season of observation"))

#############################
# sample time
#############################

sample_time <- dates_times %>% 
  filter(attributeName %in% c("sampleTime", "sondeTime_ADT", "HoboTime_ADT") |
         attributeDefinition %in% c("The time the survey was conducted, if available.")) %>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/ECSO_00002040"), # verified v0.2.1
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         propertyURI_label = rep("containsMeasurementsOfType"),
         prefName = rep("time of measurement"),
         ontoName = rep("The Ecosystem Ontology"),
         grouping = rep("sample_time"),
         notes = rep("time of measurement"))

#############################
# date
#############################

date <- dates_times %>% 
  filter(attributeName %in% c("Date", "sampleDate", "SampleDate", "SAMPLE_DATE", "sample_date", 
                              "Count Date", "catch_date", "yearmonth", "SW_DATE") |
         attributeDefinition %in% c("Date the survey/escapement project was conducted."))%>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/ECSO_00002051"), # verified v0.2.1
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         propertyURI_label = rep("containsMeasurementsOfType"),
         prefName = rep("date"),
         ontoName = rep("The Ecosystem Ontology"),
         grouping = rep("date"),
         notes = rep("date (of measurement)"))

#############################
# issue date of license -- SEPARATED THESE OUT TO REMOVE THEM (THESE ARE SORTED IN 'permits.R')
#############################

license_issue_date <- dates_times %>% 
  filter(attributeLabel %in% c("License Issue Date")) %>% 
  mutate(assigned_valueURI = rep("tbd"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         propertyURI_label = rep("containsMeasurementsOfType"),
         prefName = rep("tbd"),
         ontoName = rep("tbd"),
         grouping = rep("license_issue_date"),
         notes = rep("issue date of license"))

#############################
# number of years (duration or project/sample/etc)
#############################

numYears <- dates_times %>% 
  filter(attributeDefinition %in% c("Number of years data was collected at the site", 
                                    "number of years project was ongoing", "number of years the data covers",
                                    "The number of years of data collected")) %>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/ECSO_00001636"), # NOT VERIFIED (not in this version?)
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"), # https://www.w3.org/2006/time#hasTemporalDuration
         propertyURI_label = rep("containsMeasurementsOfType"), # hasTemporalDuration
         prefName = rep("number of years"),
         ontoName = rep("The Ecosystem Ontology"),
         grouping = rep("numYears"),
         notes = rep("number of years (data was collected)"))

#############################
# start date of data collection
#############################

startDate <- dates_times %>% 
  filter(attributeName %in% c("start_date", "Initial_date")) %>% 
  mutate(assigned_valueURI = rep("tbd"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"), # https://www.w3.org/2006/time#hasBeginning
         propertyURI_label = rep("containsMeasurementsOfType"), # hasBeginning
         prefName = rep("tbd"),
         ontoName = rep("tbd"),
         grouping = rep("startDate"),
         notes = rep("start date of data collection"))

#############################
# end date of data collection
#############################

endDate <- dates_times %>% 
  filter(attributeName %in% c("End_date")) %>% 
  mutate(assigned_valueURI = rep("tbd"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"), # https://www.w3.org/2006/time#hasEnd
         propertyURI_label = rep("containsMeasurementsOfType"), # hasEnd
         prefName = rep("tbd"),
         ontoName = rep("tbd"),
         grouping = rep("endDate"),
         notes = rep("end date of data collection"))

##########################################################################################
# combine and ensure no duplicates
##########################################################################################

all_date_atts <- rbind(brood_year, commHarvestYear_CLEANED, date, sample_time, sample_year, numYears, startDate, endDate, sample_month, sample_season)

remainder <- anti_join(dates_times, all_date_atts)

# check that there are no duplicates
all_dates <- all_date_atts %>% select(-assigned_valueURI,-assigned_propertyURI, -prefName, -ontoName, -grouping, -notes)
all_dates_distinct <- all_date_atts %>% select(-assigned_valueURI, -assigned_propertyURI, -prefName, -ontoName, -grouping, -notes) %>% distinct()
isTRUE(length(all_dates$attributeName) == length(all_dates_distinct$attributeName))

# clean up global environment
rm(dates, brood_year, commHarvestYear, commHarvestYear_BB, commHarvestYear_rest, commHarvestYear_CLEANED, date, license_issue_date, sample_time, sample_year, numYears, startDate, endDate, sample_month, sample_season, remainder, all_dates, all_dates_distinct, times, dates_times)
