# Salmon Data Integration Portal annotation prep

# NOTE CHANGES IN REPLICATED DATA IDENTIFIERS (use SDI_replicated_query.csv, not SDI_replicated_query_old.csv):

# Bell 2021:
  # old metadata pid = urn:uuid:22464585-00e2-4be2-8ef0-75a2ebc6bcb3
  # new metadata pid = urn:uuid:4ad48407-8044-4f4a-9596-18e9cb221656
  # old rm = resource_map_urn:uuid:138a5075-7622-4e0a-86e6-bced019a2b5c
  # new rm = resource_map_urn:uuid:4ad48407-8044-4f4a-9596-18e9cb221656

# Malick 2015
  # old metadata pid = urn:uuid:379f256c-b3d5-4f66-a76f-a982a2538c59
  # new metadata pid = urn:uuid:5624cbc2-9f95-4ddd-a342-c2049dadbf69
  # old rm = resource_map_urn:uuid:0844d4a8-5306-4f6d-ae61-9ff94b28c57e
  # new rm = resource_map_urn:uuid:5624cbc2-9f95-4ddd-a342-c2049dadbf69

# BCO-DMO 2009
  # old metadata pid = urn:uuid:1646fd83-e7b8-4876-b695-333dd6d6675b
  # new metadata pid = urn:uuid:77bf16c1-2120-466f-8f5e-f5694d56870a
  # old rm = resource_map_urn:uuid:8ce56af1-8ae6-4177-8225-c87d4e52d547
  # new rm = resource_map_urn:uuid:77bf16c1-2120-466f-8f5e-f5694d56870a

##############################
# load libraries
##############################

library(tidyverse)
library(janitor)

##############################
# load data for salmon data integration test
##############################

# identifiers (need to change these to dev.nceas identifiers)
SDI_SASAP_identifiers <- c("doi:10.5063/F1891459", # Brenner et al. 2017 (sockeye brood tables) -- match for Malick 2015
                           "doi:10.5063/F1K64GBK", # ADF&G 2018 (ASL Arctic-Yukon-Kuskokwim Region) -- match for Bell 2021
                           "doi:10.5063/F15T3HRG") # ADF&G 2018 (ASL Bristol Bay) -- match for BCO-DMO 2009

# attributes from cloned SASAP data
SDI_SASAP_attributes <- read_csv(here::here("data", "annotationPrep", "round1_allAttributes.csv")) %>% 
  filter(identifier %in% SDI_SASAP_identifiers) %>% 
  select(-ID, -annotation_round, -general_topic)

# attributes from replicated (external) data
SDI_replicated_query <- read_csv(here::here("data", "annotationPrep", "SDI_replicated_query.csv"))

# combine SASAP + replicated (external) attributes; update identifiers of cloned datasets -- USE THIS ONE FOR ANNOTATIONS
SDI_attributes_all <- rbind(SDI_SASAP_attributes, SDI_replicated_query) %>% 
  filter(prefName != "tbd") %>% 
  mutate(
    update_id = case_when(
      identifier == "doi:10.5063/F15T3HRG" ~ "001",
      identifier == "doi:10.5063/F1891459" ~ "002",
      identifier == "doi:10.5063/F1K64GBK" ~ "003",
      identifier == "urn:uuid:77bf16c1-2120-466f-8f5e-f5694d56870a" ~ "004", # BCO-DMO
      identifier == "urn:uuid:5624cbc2-9f95-4ddd-a342-c2049dadbf69" ~ "005", # Malick
      identifier == "urn:uuid:4ad48407-8044-4f4a-9596-18e9cb221656" ~ "006" # Bell
    )
  ) %>% 
  mutate(
    update_id_description = case_when(
      identifier == "doi:10.5063/F15T3HRG" ~ "ADF&G 2018 (ASL Bristol Bay) -- match for BCO-DMO 2009",
      identifier == "doi:10.5063/F1891459" ~ "Brenner et al. 2017 (sockeye brood tables) -- match for Malick 2015",
      identifier == "doi:10.5063/F1K64GBK" ~ "ADF&G 2018 (ASL Arctic-Yukon-Kuskokwim Region) -- match for Bell 2021",
      identifier == "urn:uuid:77bf16c1-2120-466f-8f5e-f5694d56870a" ~ "BCO-DMO 2009",
      identifier == "urn:uuid:5624cbc2-9f95-4ddd-a342-c2049dadbf69" ~ "Malick 2015",
      identifier == "urn:uuid:4ad48407-8044-4f4a-9596-18e9cb221656" ~ "Bell 2021"
    )
  ) %>% 
  rename(original_identifier = identifier) %>% 
  mutate(
    new_identifier = case_when(
      original_identifier == "doi:10.5063/F15T3HRG" ~ "urn:uuid:ce3b4f4d-180c-4df7-bde8-49246495a5a4", # Bristol Bay
      original_identifier == "doi:10.5063/F1891459" ~ "urn:uuid:74f8ac15-19bd-4fba-862b-3b6ef9088a6e", # Brenner et al.
      original_identifier == "doi:10.5063/F1K64GBK" ~ "urn:uuid:3c6f106a-84ea-4dea-b536-fe1e440c5905", # AYK
      original_identifier == "urn:uuid:77bf16c1-2120-466f-8f5e-f5694d56870a" ~ "urn:uuid:77bf16c1-2120-466f-8f5e-f5694d56870a",
      original_identifier == "urn:uuid:5624cbc2-9f95-4ddd-a342-c2049dadbf69" ~ "urn:uuid:5624cbc2-9f95-4ddd-a342-c2049dadbf69",
      original_identifier == "urn:uuid:4ad48407-8044-4f4a-9596-18e9cb221656" ~ "urn:uuid:4ad48407-8044-4f4a-9596-18e9cb221656"
    )
  ) %>% 
  rename(identifier = new_identifier)

##############################
# load length attributes for manual annotations -- THESE ARE ONLY FROM CLONED SASAP DATA; NEED TO SORT THORUGH REPLICATED EXTERNAL DATA BY HAND
##############################

SDI_lengths <- read_csv(here::here("data", "annotationPrep", "round1_fishLengths.csv")) %>%
  filter(identifier %in% SDI_SASAP_identifiers) %>% 
  mutate(
    update_id = case_when(
      identifier == "doi:10.5063/F15T3HRG" ~ "001",
      identifier == "doi:10.5063/F1891459" ~ "002",
      identifier == "doi:10.5063/F1K64GBK" ~ "003"
    )
  )  %>% 
  mutate(
    update_id_description = case_when(
      identifier == "doi:10.5063/F15T3HRG" ~ "ADF&G 2018 (ASL Bristol Bay) -- match for BCO-DMO 2009",
      identifier == "doi:10.5063/F1891459" ~ "Brenner et al. 2017 (sockeye brood tables) -- match for Malick 2015",
      identifier == "doi:10.5063/F1K64GBK" ~ "ADF&G 2018 (ASL Arctic-Yukon-Kuskokwim Region) -- match for Bell 2021"
    )
  ) %>% 
  rename(original_identifier = identifier) %>% 
  mutate(
    new_identifier = case_when(
      original_identifier == "doi:10.5063/F15T3HRG" ~ "urn:uuid:ce3b4f4d-180c-4df7-bde8-49246495a5a4", # Bristol Bay
      original_identifier == "doi:10.5063/F1891459" ~ "urn:uuid:74f8ac15-19bd-4fba-862b-3b6ef9088a6e", # Brenner et al.
      original_identifier == "doi:10.5063/F1K64GBK" ~ "urn:uuid:3c6f106a-84ea-4dea-b536-fe1e440c5905" # AYK
    )
  ) %>% 
  rename(identifier = new_identifier)

##############################
# load species attributes for manual annotations -- THESE ARE ONLY FROM CLONED SASAP DATA; NEED TO SORT THORUGH REPLICATED EXTERNAL DATA BY HAND
##############################

SDI_species <- read_csv(here::here("data", "annotationPrep", "round1_species.csv")) %>%
  filter(identifier %in% SDI_SASAP_identifiers) %>% 
  mutate(
    update_id = case_when(
      identifier == "doi:10.5063/F15T3HRG" ~ "001",
      identifier == "doi:10.5063/F1891459" ~ "002",
      identifier == "doi:10.5063/F1K64GBK" ~ "003"
    )
  )   %>% 
  mutate(
    update_id_description = case_when(
      identifier == "doi:10.5063/F15T3HRG" ~ "ADF&G 2018 (ASL Bristol Bay) -- match for BCO-DMO 2009",
      identifier == "doi:10.5063/F1891459" ~ "Brenner et al. 2017 (sockeye brood tables) -- match for Malick 2015",
      identifier == "doi:10.5063/F1K64GBK" ~ "ADF&G 2018 (ASL Arctic-Yukon-Kuskokwim Region) -- match for Bell 2021"
    )
  ) %>% 
  rename(original_identifier = identifier) %>% 
  mutate(
    new_identifier = case_when(
      original_identifier == "doi:10.5063/F15T3HRG" ~ "urn:uuid:ce3b4f4d-180c-4df7-bde8-49246495a5a4", # Bristol Bay
      original_identifier == "doi:10.5063/F1891459" ~ "urn:uuid:74f8ac15-19bd-4fba-862b-3b6ef9088a6e", # Brenner et al.
      original_identifier == "doi:10.5063/F1K64GBK" ~ "urn:uuid:3c6f106a-84ea-4dea-b536-fe1e440c5905" # AYK
    )
  ) %>% 
  rename(identifier = new_identifier)

##############################
# clean up environment
##############################

rm(SDI_SASAP_identifiers, SDI_SASAP_attributes, SDI_replicated_query)

