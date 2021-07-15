# exploring datasets for potential integration

# packages
library(tidyverse)

# SASAP attributes
atts <- read_csv(here::here("data", "sorted_attributes", "SASAP_attributes_sorted.csv"))

#################################
# Pacific Salmon Explorer
#################################

# -----------------------------------------------------------------------------
# annual estimates of age composition (the number of salmon of a given age that return to spawn) for each Skeena salmon CU (1989-2012)
PSE_age_comp <- read_csv(here::here("data", "data_integration", "PSE", "age_composition.csv"))
unique(age_comp$species) # chinook, chum, coho, lake sockeye
# parameter: age class
# location: name of conservation unit (I think?)
# species: chinook, chum, coho, lake sockeye
# year: year data was collected
# datavalue: counts of individuals
#-----potential SASAP matches-----
  # https://search.dataone.org/view/doi:10.5063/F19P2ZXK

chinook <- age_comp %>% 
  filter(species == "Chinook") %>% 
  filter(year == "2010") %>% 
  filter(location == "Upper Skeena")

SASAP_age_comp <- read_csv(here::here("data", "data_integration", "SASAP", "Nelson_chinook.csv"))

# -----------------------------------------------------------------------------
recruits <- read_csv(here::here("data", "data_integration", "PSE", "recruits_per_spawner.csv"))
# parameter: Recruits, Spawners
# location: 
# species: 
# datavalue:

# -----------------------------------------------------------------------------
catch <- read_csv(here::here("data", "data_integration", "PSE", "catch_in_US_and_CND.csv"))
unique(catch$species) 
# parameter: canadian vs us fishery
# location: name of conservation unit (genetically/geographically distinct population...so stock?)
# species: chinook, chum, coho, lake sockeye, pink (even), pink (odd), river sockeye
# datavalue: catch (Catch estimates report the number of adult salmon that were caught in commercial (including both Canadian and U.S.), recreational, and First Nations food, social, and ceremonial (FSC) fisheries)

# -----------------------------------------------------------------------------
# meh
spawner_abund <- read_csv(here::here("data", "data_integration", "PSE", "spawner_abundance.csv"))
unique(spawner_abund$species) # chinook, chum, coho, lake sockeye, pink (even), pink (odd), river sockeye
# LGL counts: a CU level reconstruction of total spawner abundance
# NuSEDS counts by CU: observed spawner counts at the CU level
# NuSEDS counts by stream: sum of all estimates of spawner abundance from all survey streams 
# Total run:

# -----------------------------------------------------------------------------
# meh
avg_run_timing <- read_csv(here::here("data", "data_integration", "PSE", "avg_run_timing.csv"))
unique(avg_run_timing$species) # chinook, chum, coho, lake sockeye, pink (even), pink (odd), river sockeye

#################################
# Zenodo
#################################


#################################
# StreamNet
#################################

# -----------------------------------------------------------------------------
telem <- read_csv(here::here("data", "data_integration", "StreamNet", "final_telem_tagging.csv"))
unique(telem$Species) # FACH (snake river fall chinook salmon subyearlings of hatchery origin)
# annotate: species, weight (g), fork length (mm) PIT code, tag code, release date, release time

# -----------------------------------------------------------------------------
lyleFalls2004 <- read_csv(here::here("data", "data_integration", "StreamNet", "2004LyleFallsAdultTrapFinalDatabase_022406.csv"))
# sp_code: ChBrite, Steelhead, Lamprey, Coho, ChTule

#################################
# BCO DMO
#################################

# -----------------------------------------------------------------------------
# https://search.dataone.org/view/doi:10.5063/F15T3HRG
bcodmo <- read_csv(here::here("data", "data_integration", "BCO-DMO", "bco_dmo.csv"))
unique(bcodmo$maturity) 
# species_common_name: Sockeye, Chinook, Coho, Chum, Pink
# maturity: J, A, I

#################################
# Malick 2015
#################################

# -----------------------------------------------------------------------------
# https://search.dataone.org/view/doi:10.5063/F1891459
pink <- read_csv(here::here("data", "data_integration", "Malick_Cox2016", "pink_data.csv"))
unique(pink$region)
chum <- read_csv(here::here("data", "data_integration", "Malick_Cox2016", "chum_data.csv"))
unique(chum$sub.region)
SASAP_broodTable <- read_csv(here::here("data", "data_integration", "SASAP", "raw_brood_table_2019_07_16.csv"))
unique(SASAP_broodTable$Ocean.Region)
# species: sockeye
# region: 