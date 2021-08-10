# title: Identifying attributes to be annotated -- "fish sex"
# author: "Sam Csik"
# date created: "2021-02-25"
# date edited: "2021-02-"25"
# R version: 3.6.3
# input: "data/queries/query2020-10-09/fullQuery_semAnnotations2020-10-09_attributes.csv"
# output: 

##########################################################################################
# Summary
##########################################################################################

# Identifying attributes related to "fish sex"

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

sex <- attributes %>% 
  filter(str_detect(attributeDefinition, "(?i)sex"),
         !attributeDefinition %in% c("Sex of license holder", "Sex of proponent, if individual"),
         !attributeName %in% c("n"))

##########################################################################################
# determine appropriate valueURIs
##########################################################################################

#############################
# sex determination method
#############################

sex_determination_method <- sex %>% 
  filter(str_detect(attributeDefinition, "(?i)method")) %>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/salmon_000186"), # verified v0.2.1
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         propertyURI_label = rep("containsMeasurementsOfType"),
         prefName = rep("Fish sex determination method"),
         ontoName = rep("The Ecosystem Ontology"),
         grouping = rep("sex_determination_method"),
         notes = rep("method used to determin sex of fish"))

#############################
# sex of fish
#############################

fishSex<- sex %>% 
  filter(attributeName %in% c("RecSex", "sex", "Sex", "SEX")) %>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/salmon_000216"), # verified v0.2.1
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         propertyURI_label = rep("containsMeasurementsOfType"),
         prefName = rep("Fish sex measurement type"),
         ontoName = rep("The Ecosystem Ontology"),
         grouping = rep("fishSex"),
         notes = rep("sex of fish"))

##########################################################################################
# combine and ensure no duplicates
##########################################################################################

all_sex_atts <- rbind(sex_determination_method, fishSex)

remainder <- anti_join(sex, all_sex_atts)

# check that there are no duplicates
all_sex <- all_sex_atts %>% select(-assigned_valueURI, - assigned_propertyURI, -prefName, -ontoName, -grouping, -notes)
all_sex_distinct <- all_sex_atts %>% select(-assigned_valueURI, - assigned_propertyURI, -grouping, -notes) %>% distinct()
isTRUE(length(all_sex$attributeName) == length(all_sex_distinct$attributeName))

# clean up global environment
rm(sex, sex_determination_method, fishSex, all_sex_distinct, all_sex, remainder)



