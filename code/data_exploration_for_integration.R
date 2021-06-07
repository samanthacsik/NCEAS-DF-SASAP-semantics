# exploring datasets for potential integration

# packages
library(tidyverse)

#################################
# Pacific Salmon Explorer
#################################

age_comp <- read_csv(here::here("data", "data_integration", "PSE", "age_composition.csv"))
unique(age_comp$species) # chinook, chum, coho, lake sockeye
# parameter: age class
# location: name of conservation unit (I think?)
# species: chinook, chum, coho, lake sockeye
# year: year data was collected
# datavalue: counts of individuals

catch <- read_csv(here::here("data", "data_integration", "PSE", "catch_in_US_and_CND.csv"))
unique(catch$species) 
# parameter: canadian vs us fishery
# location: name of conservation unit (genetically/geographically distinct population...so stock?)
# species: chinook, chum, coho, lake sockeye, pink (even), pink (odd), river sockeye
# datavalue: catch (Catch estimates report the number of adult salmon that were caught in commercial (including both Canadian and U.S.), recreational, and First Nations food, social, and ceremonial (FSC) fisheries)

# meh
spawner_abund <- read_csv(here::here("data", "data_integration", "PSE", "spawner_abundance.csv"))
unique(spawner_abund$species) # chinook, chum, coho, lake sockeye, pink (even), pink (odd), river sockeye
# LGL counts: a CU level reconstruction of total spawner abundance
# NuSEDS counts by CU: observed spawner counts at the CU level
# NuSEDS counts by stream: sum of all estimates of spawner abundance from all survey streams 
# Total run:

# meh
avg_run_timing <- read_csv(here::here("data", "data_integration", "PSE", "avg_run_timing.csv"))
unique(avg_run_timing$species) # chinook, chum, coho, lake sockeye, pink (even), pink (odd), river sockeye

#################################
# Zenodo
#################################


#################################
# StreamNet
#################################

telem <- read_csv(here::here("data", "data_integration", "StreamNet", "final_telem_tagging.csv"))
unique(telem$Species) # FACH (snake river fall chinook salmon subyearlings of hatchery origin)
# annotate: species, weight (g), fork length (mm) PIT code, tag code, release date, release time
