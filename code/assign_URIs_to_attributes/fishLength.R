# title: Identifying attributes to be annotated -- "fish length"
# author: "Sam Csik"
# date created: "2021-02-25"
# date edited: "2021-02-"25"
# R version: 3.6.3
# input: "data/queries/query2020-10-09/fullQuery_semAnnotations2020-10-09_attributes.csv"
# output: 

##########################################################################################
# Summary
##########################################################################################

# Identifying attributes related to "fish length"

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

length <- attributes %>% 
  filter(str_detect(attributeDefinition, "(?i)length"),
         !attributeDefinition %in% c("Length of the vessel"),
         !attributeName %in% c("SHAPE_Leng", "Shape_Length", "n", "CASING_STICKUP", "loanTerm_Years"))

# write_csv(length, here::here("data/sorted_attributes/manual_fish_length_assignments/fishLengths.csv"))

# downloaded data and manually assessed for length types -- notes here
length_notes <- read_csv(here::here("data/sorted_attributes/manual_fish_length_assignments/fishLengths.csv")) %>% select(-X11)

##########################################################################################
# determine appropriate valueURIs
##########################################################################################

# (GENERIC) length: http://ecoinformatics.org/oboe/oboe.1.2/oboe-characteristics.owl#Length

#############################
# TEMPORARY (TO REMOVE FROM MASTER_LIST)
#############################

temp_lengths <- length %>% 
  mutate(assigned_valueURI = rep(""),
         assigned_propertyURI = rep(""),
         prefName = rep(""),
         ontoName = rep(""),
         grouping = rep("temporary_lengths"),
         notes = rep("fish length measurement types"))

##########################################################################################
# combine and ensure no duplicates
##########################################################################################

all_length_atts <- rbind(temp_lengths)

remainder <- anti_join(temp_lengths, all_length_atts)

# check that there are no duplicates
all_lengths <- all_length_atts %>% select(-assigned_valueURI, - assigned_propertyURI, -prefName, -ontoName, -grouping,  -notes)
all_lengths_distinct <- all_length_atts %>% select(-assigned_valueURI, - assigned_propertyURI, -prefName, -ontoName, -grouping, -notes) %>% distinct()
isTRUE(length(all_lengths$attributeName) == length(all_lengths_distinct$attributeName))

# clean up global environment
rm(temp_lengths, all_lengths_distinct, all_lengths, remainder)



