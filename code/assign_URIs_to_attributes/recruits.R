# title: Identifying attributes to be annotated -- "recruits"
# author: "Sam Csik"
# date created: "2021-02-04"
# date edited: "2021-02-04"
# R version: 3.6.3
# input: "data/queries/query2020-10-09/fullQuery_semAnnotations2020-10-09_attributes.csv"
# output: 

##########################################################################################
# Summary
##########################################################################################

# Identifying attributes related to "recruits"

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

recruits <- attributes %>% 
  filter(str_detect(attributeDefinition, "(?i)recruits"))

##########################################################################################
# determine appropriate valueURIs
##########################################################################################

#############################
# total recruits
#############################

total_recruits <- recruits %>% 
  filter(attributeName %in% c("TotalRecruits", "Recruits")) %>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/salmon_000663"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         propertyURI_label = rep("containsMeasurementsOfType"),
         prefName = rep("Total recruit abundance"),
         ontoName = rep("tbd"),
         grouping = rep("total_recruits"),
         notes = rep("total number of recruits (across age classes)"))

#############################
# recruits per spawner
#############################

num_recruits_per_spawner <- recruits %>% 
  filter(attributeName == "spawner") %>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/salmon_000782"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         propertyURI_label = rep("containsMeasurementsOfType"),
         prefName = rep("Recruits per spawner"),
         ontoName = rep("tbd"),
         grouping = rep("num_recruits_per_spawner"),
         notes = rep("number of recruits per spawner"))

#############################
# recruits by age class
#############################

tempA <- recruits %>% 
  filter(str_detect(attributeDefinition, "(?i)number of age"))

tempB <- recruits %>% 
  filter(str_detect(attributeDefinition, "(?i)number of recruits in"))

tempC <- recruits %>% 
  filter(str_detect(attributeDefinition, "(?i)number of total age"))

num_recruits_by_ageClass <- rbind(tempA, tempB, tempC) #%>% 
  # mutate(assigned_valueURI = rep("tbd"),
  #        assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
  #        prefName = rep("tbd"),
  #        ontoName = rep("tbd"),
  #        grouping = rep("num_recruits_by_ageClass"),
  #        notes = rep("number of recruits per age class"))

#############################
# recruits by age class -- broken down further
#############################

# r0 <- num_recruits_by_ageClass %>% 
#   filter(str_detect(attributeDefinition, "0")) %>% 
#   mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/salmon_000664"),
#          assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
#          prefName = rep("Age class 0 recruits"),
#          ontoName = rep("tbd"),
#          grouping = rep("num_recruits_by_ageClass_0"),
#          notes = rep("number of recruits per age class 0"))

r0.1 <- num_recruits_by_ageClass %>% 
  filter(str_detect(attributeDefinition, "0.1")) %>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/salmon_000691"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         propertyURI_label = rep("containsMeasurementsOfType"),
         prefName = rep("Age class 0.1 recruits"),
         ontoName = rep("tbd"),
         grouping = rep("num_recruits_by_ageClass_0.1"),
         notes = rep("number of recruits per age class 0.1"))

r0.2 <- num_recruits_by_ageClass %>% 
  filter(str_detect(attributeDefinition, "0.2")) %>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/salmon_000692"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         propertyURI_label = rep("containsMeasurementsOfType"),
         prefName = rep("Age class 0.2 recruits"),
         ontoName = rep("tbd"),
         grouping = rep("num_recruits_by_ageClass_0.2"),
         notes = rep("number of recruits per age class 0.2"))

r0.3 <- num_recruits_by_ageClass %>% 
  filter(str_detect(attributeDefinition, "0.3")) %>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/salmon_000693"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         propertyURI_label = rep("containsMeasurementsOfType"),
         prefName = rep("Age class 0.3 recruits"),
         ontoName = rep("tbd"),
         grouping = rep("num_recruits_by_ageClass_0.3"),
         notes = rep("number of recruits per age class 0.3"))

r0.4 <- num_recruits_by_ageClass %>% 
  filter(str_detect(attributeDefinition, "0.4")) %>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/salmon_000694"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         propertyURI_label = rep("containsMeasurementsOfType"),
         prefName = rep("Age class 0.4 recruits"),
         ontoName = rep("tbd"),
         grouping = rep("num_recruits_by_ageClass_0.4"),
         notes = rep("number of recruits per age class 0.4"))

r0.5 <- num_recruits_by_ageClass %>% 
  filter(str_detect(attributeDefinition, "0.5")) %>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/salmon_000695"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         propertyURI_label = rep("containsMeasurementsOfType"),
         prefName = rep("Age class 0.5 recruits"),
         ontoName = rep("tbd"),
         grouping = rep("num_recruits_by_ageClass_0.5"),
         notes = rep("number of recruits per age class 0.5"))

r0.6 <- num_recruits_by_ageClass %>% 
  filter(str_detect(attributeDefinition, "0.6")) %>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/salmon_000705"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         propertyURI_label = rep("containsMeasurementsOfType"),
         prefName = rep("Age class 0.6 recruits"),
         ontoName = rep("tbd"),
         grouping = rep("num_recruits_by_ageClass_0.6"),
         notes = rep("number of recruits per age class 0.6"))

r1 <- num_recruits_by_ageClass %>%
  filter(attributeName == "R1.0") %>%
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/salmon_000665"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         propertyURI_label = rep("containsMeasurementsOfType"),
         prefName = rep("Age class 1 recruits"),
         ontoName = rep("tbd"),
         grouping = rep("num_recruits_by_ageClass_1"),
         notes = rep("number of recruits per age class 1"))

r1.1 <- num_recruits_by_ageClass %>% 
  filter(str_detect(attributeDefinition, "1.1")) %>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/salmon_000696"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         propertyURI_label = rep("containsMeasurementsOfType"),
         prefName = rep("Age class 1.1 recruits"),
         ontoName = rep("tbd"),
         grouping = rep("num_recruits_by_ageClass_1.1"),
         notes = rep("number of recruits per age class 1.1"))

r1.2 <- num_recruits_by_ageClass %>% 
  filter(str_detect(attributeDefinition, "1.2")) %>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/salmon_000697"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         propertyURI_label = rep("containsMeasurementsOfType"),
         prefName = rep("Age class 1.2 recruits"),
         ontoName = rep("tbd"),
         grouping = rep("num_recruits_by_ageClass_1.2"),
         notes = rep("number of recruits per age class 1.2"))

r1.3 <- num_recruits_by_ageClass %>% 
  filter(str_detect(attributeDefinition, "1.3")) %>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/salmon_000698"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         propertyURI_label = rep("containsMeasurementsOfType"),
         prefName = rep("Age class 1.3 recruits"),
         ontoName = rep("tbd"),
         grouping = rep("num_recruits_by_ageClass_1.3"),
         notes = rep("number of recruits per age class 1.3"))

r1.4 <- num_recruits_by_ageClass %>% 
  filter(str_detect(attributeDefinition, "1.4")) %>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/salmon_000699"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         propertyURI_label = rep("containsMeasurementsOfType"),
         prefName = rep("Age class 1.4 recruits"),
         ontoName = rep("tbd"),
         grouping = rep("num_recruits_by_ageClass_1.4"),
         notes = rep("number of recruits per age class 1.4"))

r1.5 <- num_recruits_by_ageClass %>% 
  filter(str_detect(attributeDefinition, "1.5")) %>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/salmon_000700"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         propertyURI_label = rep("containsMeasurementsOfType"),
         prefName = rep("Age class 1.5 recruits"),
         ontoName = rep("tbd"),
         grouping = rep("num_recruits_by_ageClass_1.5"),
         notes = rep("number of recruits per age class 1.5"))

r1.6 <- num_recruits_by_ageClass %>% 
  filter(str_detect(attributeDefinition, "1.6")) %>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/salmon_000701"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         propertyURI_label = rep("containsMeasurementsOfType"),
         prefName = rep("Age class 1.6 recruits"),
         ontoName = rep("tbd"),
         grouping = rep("num_recruits_by_ageClass_1.6"),
         notes = rep("number of recruits per age class 1.6"))

r2 <- num_recruits_by_ageClass %>% 
  filter(str_detect(attributeDefinition, "number of total age 2 recruits") |
         attributeName == "R2.0") %>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/salmon_000666"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         propertyURI_label = rep("containsMeasurementsOfType"),
         prefName = rep("Age class 2 recruits"),
         ontoName = rep("tbd"),
         grouping = rep("num_recruits_by_ageClass_2"),
         notes = rep("number of recruits per age class 2"))

r2.1 <- num_recruits_by_ageClass %>% 
  filter(str_detect(attributeDefinition, "2.1")) %>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/salmon_000709"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         propertyURI_label = rep("containsMeasurementsOfType"),
         prefName = rep("Age class 2.1 recruits"),
         ontoName = rep("tbd"),
         grouping = rep("num_recruits_by_ageClass_2.1"),
         notes = rep("number of recruits per age class 2.1"))

r2.2 <- num_recruits_by_ageClass %>% 
  filter(str_detect(attributeDefinition, "2.2")) %>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/salmon_000710"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         propertyURI_label = rep("containsMeasurementsOfType"),
         prefName = rep("Age class 2.2 recruits"),
         ontoName = rep("tbd"),
         grouping = rep("num_recruits_by_ageClass_2.2"),
         notes = rep("number of recruits per age class 2.2"))

r2.3 <- num_recruits_by_ageClass %>% 
  filter(str_detect(attributeDefinition, "2.3")) %>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/salmon_000711"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         propertyURI_label = rep("containsMeasurementsOfType"),
         prefName = rep("Age class 2.3 recruits"),
         ontoName = rep("tbd"),
         grouping = rep("num_recruits_by_ageClass_2.3"),
         notes = rep("number of recruits per age class 2.3"))

r2.4 <- num_recruits_by_ageClass %>% 
  filter(str_detect(attributeDefinition, "2.4")) %>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/salmon_000712"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         propertyURI_label = rep("containsMeasurementsOfType"),
         prefName = rep("Age class 2.4 recruits"),
         ontoName = rep("tbd"),
         grouping = rep("num_recruits_by_ageClass_2.4"),
         notes = rep("number of recruits per age class 2.4"))

r2.5 <- num_recruits_by_ageClass %>% 
  filter(str_detect(attributeDefinition, "2.5")) %>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/salmon_000713"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         propertyURI_label = rep("containsMeasurementsOfType"),
         prefName = rep("Age class 2.2 recruits"),
         ontoName = rep("tbd"),
         grouping = rep("num_recruits_by_ageClass_2.5"),
         notes = rep("number of recruits per age class 2.5"))

r3 <- num_recruits_by_ageClass %>% 
  filter(str_detect(attributeDefinition, "age 3 recruits") |
         attributeDefinition == "number of age 3.0 recruits") %>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/salmon_000667"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         propertyURI_label = rep("containsMeasurementsOfType"),
         prefName = rep("Age class 3 recruits"),
         ontoName = rep("tbd"),
         grouping = rep("num_recruits_by_ageClass_3"),
         notes = rep("number of recruits per age class 3"))

r3.1 <- num_recruits_by_ageClass %>% 
  filter(str_detect(attributeDefinition, "3.1")) %>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/salmon_000718"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         propertyURI_label = rep("containsMeasurementsOfType"),
         prefName = rep("Age class 3.1 recruits"),
         ontoName = rep("tbd"),
         grouping = rep("num_recruits_by_ageClass_3.1"),
         notes = rep("number of recruits per age class 3.1"))

r3.2 <- num_recruits_by_ageClass %>% 
  filter(str_detect(attributeDefinition, "3.2")) %>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/salmon_000719"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         propertyURI_label = rep("containsMeasurementsOfType"),
         prefName = rep("Age class 3.2 recruits"),
         ontoName = rep("tbd"),
         grouping = rep("num_recruits_by_ageClass_3.2"),
         notes = rep("number of recruits per age class 3.2"))

r3.3 <- num_recruits_by_ageClass %>% 
  filter(str_detect(attributeDefinition, "3.3")) %>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/salmon_000720"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         propertyURI_label = rep("containsMeasurementsOfType"),
         prefName = rep("Age class 3.3 recruits"),
         ontoName = rep("tbd"),
         grouping = rep("num_recruits_by_ageClass_3.3"),
         notes = rep("number of recruits per age class 3.3"))

r3.4 <- num_recruits_by_ageClass %>% 
  filter(str_detect(attributeDefinition, "3.4")) %>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/salmon_000721"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         propertyURI_label = rep("containsMeasurementsOfType"),
         prefName = rep("Age class 3.4 recruits"),
         ontoName = rep("tbd"),
         grouping = rep("num_recruits_by_ageClass_3.4"),
         notes = rep("number of recruits per age class 3.4"))

r4 <- num_recruits_by_ageClass %>% 
  filter(str_detect(attributeDefinition, "age 4 recruits")) %>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/salmon_000668"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         propertyURI_label = rep("containsMeasurementsOfType"),
         prefName = rep("Age class 4 recruits"),
         ontoName = rep("tbd"),
         grouping = rep("num_recruits_by_ageClass_4"),
         notes = rep("number of recruits per age class 4"))

r4.1 <- num_recruits_by_ageClass %>% 
  filter(str_detect(attributeDefinition, "4.1")) %>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/salmon_000727"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         propertyURI_label = rep("containsMeasurementsOfType"),
         prefName = rep("Age class 4.1 recruits"),
         ontoName = rep("tbd"),
         grouping = rep("num_recruits_by_ageClass_4.1"),
         notes = rep("number of recruits per age class 4.1"))

r4.2 <- num_recruits_by_ageClass %>% 
  filter(str_detect(attributeDefinition, "4.2")) %>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/salmon_000728"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         propertyURI_label = rep("containsMeasurementsOfType"),
         prefName = rep("Age class 4.2 recruits"),
         ontoName = rep("tbd"),
         grouping = rep("num_recruits_by_ageClass_4.2"),
         notes = rep("number of recruits per age class 4.2"))

r4.3 <- num_recruits_by_ageClass %>% 
  filter(str_detect(attributeDefinition, "4.3")) %>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/salmon_000729"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         propertyURI_label = rep("containsMeasurementsOfType"),
         prefName = rep("Age class 4.3 recruits"),
         ontoName = rep("tbd"),
         grouping = rep("num_recruits_by_ageClass_4.3"),
         notes = rep("number of recruits per age class 4.3"))

r5 <- num_recruits_by_ageClass %>% 
  filter(str_detect(attributeDefinition, "age 5 recruits")) %>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/salmon_000669"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         propertyURI_label = rep("containsMeasurementsOfType"),
         prefName = rep("Age class 5 recruits"),
         ontoName = rep("tbd"),
         grouping = rep("num_recruits_by_ageClass_5"),
         notes = rep("number of recruits per age class 5"))

r6 <- num_recruits_by_ageClass %>% 
  filter(str_detect(attributeDefinition, "age 6 recruits")) %>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/salmon_000670"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         propertyURI_label = rep("containsMeasurementsOfType"),
         prefName = rep("Age class 6 recruits"),
         ontoName = rep("tbd"),
         grouping = rep("num_recruits_by_ageClass_6"),
         notes = rep("number of recruits per age class 6"))

r7 <- num_recruits_by_ageClass %>% 
  filter(str_detect(attributeDefinition, "age 7 recruits") |
         attributeName == "R7") %>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/salmon_000754"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         propertyURI_label = rep("containsMeasurementsOfType"),
         prefName = rep("Age class 7 recruits"),
         ontoName = rep("tbd"),
         grouping = rep("num_recruits_by_ageClass_7"),
         notes = rep("number of recruits per age class 7"))

r8 <- num_recruits_by_ageClass %>% 
  filter(str_detect(attributeDefinition, "age 8 recruits")) %>% 
  filter(attributeName != "R7") %>% 
  mutate(assigned_valueURI = rep("http://purl.dataone.org/odo/salmon_000755"),
         assigned_propertyURI = rep("http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"),
         propertyURI_label = rep("containsMeasurementsOfType"),
         prefName = rep("Age class 8 recruits"),
         ontoName = rep("tbd"),
         grouping = rep("num_recruits_by_ageClass_8"),
         notes = rep("number of recruits per age class 8"))


##########################################################################################
# combine and ensure no duplicates
##########################################################################################

all_recruit_atts <- rbind(total_recruits, num_recruits_per_spawner, 
                          r0.1, r0.2, r0.3, r0.4, r0.5, r0.6,
                          r1, r1.1, r1.2, r1.3, r1.4, r1.5, r1.6,
                          r2, r2.1, r2.2, r2.3, r2.4, r2.5, 
                          r3, r3.1, r3.2, r3.3, r3.4,
                          r4, r4.1, r4.2, r4.3, r5, r6, r7, r8) # num_recruits_by_ageClass

remainder <- anti_join(recruits, all_recruit_atts)

# check that there are no duplicates
all_recruits <- all_recruit_atts %>% select(-assigned_valueURI, - assigned_propertyURI, -prefName, -ontoName, -grouping, -notes)
all_recruits_distinct <- all_recruit_atts %>% select(-assigned_valueURI, - assigned_propertyURI, -prefName, -ontoName, -grouping, -notes) %>% distinct()
isTRUE(length(all_recruits$attributeName) == length(all_recruits_distinct$attributeName))

# if need to find repeats
repeats <- get_dupes(all_recruits)

# clean up global environment
rm(recruits, total_recruits, num_recruits_per_spawner, tempA, tempB, tempC, num_recruits_by_ageClass, remainder, all_recruits, all_recruits_distinct,
   r0.1, r0.2, r0.3, r0.4, r0.5, r0.6, r1, r1.1, r1.2, r1.3, r1.4, r1.5, r1.6, r2, r2.1, r2.2, r2.3, r2.4, r2.5,
   r3, r3.1, r3.2, r3.3, r3.4, r4, r4.1, r4.2, r4.3, r5, r6, r7, r8)
