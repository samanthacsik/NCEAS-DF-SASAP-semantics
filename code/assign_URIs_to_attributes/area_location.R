# title: Identifying attributes to be annotated -- "area/location"
# author: "Sam Csik"
# date created: "2021-02-23"
# date edited: "2021-02-23"
# R version: 3.6.3
# input: "data/queries/query2020-10-09/fullQuery_semAnnotations2020-10-09_attributes.csv"
# output: 

##########################################################################################
# Summary
##########################################################################################

# Identifying attributes related to "area/location"

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

location <- attributes %>% 
  filter(str_detect(attributeName, "(?i)area") |
         str_detect(attributeDefinition, "(?i)latitude") |
         str_detect(attributeDefinition, "(?i)longitude"))

##########################################################################################
# determine appropriate valueURIs
##########################################################################################

#############################
# latitude & longitude
#############################

latLon <- location %>% 
  filter(attributeDefinition %in% c("(latitude, longitude) of location of violation")) %>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/ECSO_00002269"),
         assigned_propertyURI = rep("tbd"),
         prefName = rep("latitude and longitude coordinates"),
         ontoName = rep("tbd"),
         grouping = rep("latLon"),
         notes = rep("latitude and longitude"))

#############################
# latitude
#############################

latitude <- location %>% 
  filter(attributeDefinition %in% c("Latitude", "latitude of city", "Latitude of city", "latitude of community",
                                    "Latitude of community", "latitude of count location", "Latitude of count location",
                                    "latitude of location", "latitude of violation", "Latitude where community is located",
                                    "Latitude where Native place is located", "Latitude where tribe is located",
                                    "Recovery latitude", "Release latitude")) %>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/ECSO_00002130"),
         assigned_propertyURI = rep("tbd"),
         prefName = rep("latitude coordinate"),
         ontoName = rep("tbd"),
         grouping = rep("latitude"),
         notes = rep("latitude"))


#############################
# latitude degrees
#############################

latitudeDeg <- location %>% 
  filter(attributeDefinition %in% c("Decimal degree latitude of the observation.", "Latitude degrees at release",
                                    "Latitude degrees at recovery", "Latitude of monitoring station , decimal degrees", 
                                    "latitude in decimal degrees", "Latitude location of the station in decimal degrees",
                                    "Latitude of monitoring station, decimal degrees")) %>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/ECSO_00002247"),
         assigned_propertyURI = rep("tbd"),
         prefName = rep("latitude degree component"),
         ontoName = rep("tbd"),
         grouping = rep("latitudeDeg"),
         notes = rep("latitude degree component"))

#############################
# latitude minutes
#############################

latitudeMin <- location %>% 
  filter(attributeDefinition %in% c("Latitude minutes at recovery", "Latitude minutes at release")) %>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/ECSO_00002137"),
         assigned_propertyURI = rep("tbd"),
         prefName = rep("latitude minute component"),
         ontoName = rep("tbd"),
         grouping = rep("latitudeMin"),
         notes = rep("latitude minute component"))

#############################
# longitude coordinate
#############################

longitude <- location %>% 
  filter(attributeDefinition %in% c("Longitude", "longitude of city", "Longitude of city", "longitude of community",
                                    "Longitude of community", "longitude of count location", "Longitude of count location",
                                    "longitude of location", "longitude of violation", "Longitude where community is located",
                                    "Longitude where Native place is located", "Longitude where tribe is located",
                                    "Release longitude", "Recovery longitude")) %>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/ECSO_00002132"),
         assigned_propertyURI = rep("tbd"),
         prefName = rep("longitude coordinate"),
         ontoName = rep("tbd"),
         grouping = rep("longitude"),
         notes = rep("longitude"))

#############################
# longitude degrees
#############################

longitudeDeg <- location %>% 
  filter(attributeDefinition %in% c("Decimal degree longitude of the observation.", "Longitude degrees at release",
                                    "Longitude degrees at recovery", "Longitude of monitoring station , decimal degrees", 
                                    "longitude in decimal degrees", "Longitude location of the site in decimal degrees",
                                    "Longitude of monitoring station, decimal degrees")) %>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/ECSO_00002239"),
         assigned_propertyURI = rep("tbd"),
         prefName = rep("longitdue degree component"),
         ontoName = rep("tbd"),
         grouping = rep("longitudeDeg"),
         notes = rep("longitude degree component"))

#############################
# longitude minutes
#############################

longitudeMin <- location %>% 
  filter(attributeDefinition %in% c("Longitude minutes at recovery", "Longitude minutes at release")) %>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/ECSO_00002151"),
         assigned_propertyURI = rep("tbd"),
         prefName = rep("longitude minute component"),
         ontoName = rep("tbd"),
         grouping = rep("longitudeMin"),
         notes = rep("longitude minute component"))

##########################################################################################
# combine and ensure no duplicates
##########################################################################################

all_location_atts <- rbind(latLon, latitude, latitudeDeg, latitudeMin, longitude, longitudeDeg, longitudeMin)

remainder <- anti_join(location, all_location_atts)

# check that there are no duplicates
all_location <- all_location_atts %>% select(-assigned_valueURI, - assigned_propertyURI, -prefName, -ontoName, -grouping, -notes)
all_location_distinct <- all_location_atts %>% select(-assigned_valueURI, - assigned_propertyURI, -prefName, -ontoName, -grouping, -notes) %>% distinct()
isTRUE(length(all_location$attributeName) == length(all_location_distinct$attributeName))

# clean up global environment
rm(latLon, location, latitude, latitudeDeg, latitudeMin, longitude, longitudeDeg, longitudeMin, remainder, all_location, all_location_distinct)
