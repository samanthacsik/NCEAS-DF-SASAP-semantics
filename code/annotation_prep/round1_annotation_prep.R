# Round 1 SASAP annotation preparation

##############################
# load libraries
##############################

library(tidyverse)
library(janitor)

##############################
# get round 1 package identifiers
##############################

round1_pkgs <- read_csv(here::here("data", "queries", "query2020-10-09", "unique_pkgs.csv")) %>% 
  filter(annotation_round == "round 1") %>% 
  select(-new_version, -new_URL)

write_csv(round1_pkgs, here::here("data", "annotationPrep", "round1_pkgs.csv"))

round1_pkgIDs <- unique(round1_pkgs$identifier)

##############################
# get all round 1 attributes 
##############################

# 12,261 attributes total
round1_attributes_all <- read_csv(here::here("data", "queries", "query2020-10-09", "fullQuery_semAnnotations2020-10-09_attributes.csv")) %>% 
  filter(identifier %in% round1_pkgIDs) %>% 
  select(-valueURI, -propertyURI)

##############################
# get all previously sorted attributes and filter for round 1 attributes
##############################

# 10,910 attributes (had been assigned a general 'grouping' during prior organization)
round1_attributes_prevSort <- read_csv(here::here("data", "sorted_attributes", "SASAP_attributes_sorted.csv")) %>% 
  filter(identifier %in% round1_pkgIDs)

##############################
# remaining round 1 attributes to be sorted
##############################

# round1_all_atts <- round1_attributes %>% select(identifier, entityName, attributeName)
# round1_all_sorted_atts <- round1_attributes_prevSort %>% select(identifier, entityName, attributeName)
# round1_attributes_unsorted <- anti_join(round1_all_atts, round1_all_sorted_atts)

##############################
# join sorting notes with all attribute information from round 1 SASAP packages
##############################

round1 <- full_join(round1_attributes_all, round1_attributes_prevSort) %>% 
  select(-ontoName)

write_csv(round1, here::here("data", "annotationPrep", "round1_allAttributes.csv"))

##############################
# what's left to assess
##############################

# remainder <- round1 %>% 
#   filter(!assigned_valueURI %in% c(
#     "http://purl.dataone.org/odo/salmon_000525", # ADF&G species code
#     "http://purl.dataone.org/odo/salmon_000527", # ADF&G gear code
#     "http://purl.dataone.org/odo/salmon_000480", # Annual escapement count 
#     "http://purl.dataone.org/odo/salmon_000481", # Daily escapement count 
#     "http://purl.dataone.org/odo/ECSO_00001237", # Precipitation volume -- COME BACK TO THIS
#     "http://purl.dataone.org/odo/ECSO_00001225", # Air temperature  -- COME BACK TO THIS
#     "http://purl.dataone.org/odo/salmon_000520", # Brood year
#     "http://purl.dataone.org/odo/salmon_00235", # Distance between scale circuli
#     "http://purl.dataone.org/odo/ECSO_00001720", # data quality flag
#     "http://purl.dataone.org/odo/ECSO_00002051", # date
#     "http://purl.dataone.org/odo/salmon_000681", # Age error code
#     "http://purl.dataone.org/odo/salmon_00187", # Total age
#     "http://purl.dataone.org/odo/salmon_00188", # Freshwater age
#     "http://purl.dataone.org/odo/salmon_00189", # Saltwater age
#     "http://purl.dataone.org/odo/salmon_00200", # Fish age expressed in European notation
#     "http://purl.dataone.org/odo/salmon_00216", # Fish sex measurement type
#     "http://purl.dataone.org/odo/salmon_000529", # Fish sample code
#     "http://purl.dataone.org/odo/salmon_00142", # Fishing gear type
#     "http://purl.dataone.org/odo/ECSO_00002130", # latitude coordinate
#     "http://purl.dataone.org/odo/ECSO_00002247", # latitude degree component
#     "http://purl.dataone.org/odo/ECSO_00002132", # longitude
#     "http://purl.dataone.org/odo/ECSO_00002239", # longitude degree component
#     "http://purl.dataone.org/odo/salmon_000691", # Age class 0.1 recruits,
#     "http://purl.dataone.org/odo/salmon_000692", # Age class 0.2 recruits
#     "http://purl.dataone.org/odo/salmon_000693", # Age class 0.3 recruits
#     "http://purl.dataone.org/odo/salmon_000694", # Age class 0.4 recruits
#     "http://purl.dataone.org/odo/salmon_000695", # Age class 0.5 recruits
#     "http://purl.dataone.org/odo/salmon_000705", # Age class 0.6 recruits
#     "http://purl.dataone.org/odo/salmon_000665", # Age class 1 recruits
#     "http://purl.dataone.org/odo/salmon_000696", # Age class 1.1 recruits
#     "http://purl.dataone.org/odo/salmon_000697", # Age class 1.2 recruits
#     "http://purl.dataone.org/odo/salmon_000698", # Age class 1.3 recruits
#     "http://purl.dataone.org/odo/salmon_000699", # Age class 1.4 recruits
#     "http://purl.dataone.org/odo/salmon_000700", # Age class 1.5 recruits
#     "http://purl.dataone.org/odo/salmon_000701", # Age class 1.6 recruits
#     "http://purl.dataone.org/odo/salmon_000666", # Age class 2 recruits
#     "http://purl.dataone.org/odo/salmon_000709", # Age class 2.1 recruits
#     "http://purl.dataone.org/odo/salmon_000710", # Age class 2.2 recruits
#     "http://purl.dataone.org/odo/salmon_000711", # Age class 2.3 recruits
#     "http://purl.dataone.org/odo/salmon_000712", # Age class 2.4 recruits
#     "http://purl.dataone.org/odo/salmon_000713", # Age class 2.5 recruits
#     "http://purl.dataone.org/odo/salmon_000667", # Age class 3 recruits
#     "http://purl.dataone.org/odo/salmon_000718", # Age class 3.1 recruits
#     "http://purl.dataone.org/odo/salmon_000719", # Age class 3.2 recruits
#     "http://purl.dataone.org/odo/salmon_000720", # Age class 3.3 recruits
#     "http://purl.dataone.org/odo/salmon_000721", # Age class 3.4 recruits
#     "http://purl.dataone.org/odo/salmon_000668", # Age class 4 recruits
#     "http://purl.dataone.org/odo/salmon_000727", # Age class 4.1 recruits
#     "http://purl.dataone.org/odo/salmon_000728", # Age class 4.2 recruits
#     "http://purl.dataone.org/odo/salmon_000729", # Age class 4.3 recruits
#     "http://purl.dataone.org/odo/salmon_000669", # Age class 5 recruits
#     "http://purl.dataone.org/odo/salmon_000670", # Age class 6 recruits
#     "http://purl.dataone.org/odo/salmon_000754", # Age class 7 recruits
#     "http://purl.dataone.org/odo/salmon_000755", # Age class 8 recruits
#     "http://purl.dataone.org/odo/salmon_00186", # Fish sex determination method
#     "http://purl.dataone.org/odo/salmon_000671", # Fish stock code
#     "http://purl.dataone.org/odo/ECSO_00002768", # study location name
#     "http://purl.dataone.org/odo/ECSO_00002050", # year of measurement
#     "http://purl.dataone.org/odo/ECSO_00002040", # time of measurement
#     "http://purl.dataone.org/odo/ECSO_00002047", # month of measurement
#     "http://purl.dataone.org/odo/ECSO_00002366", # season
#     "http://purl.dataone.org/odo/salmon_000663", # Total recruit abundance
#     "http://purl.dataone.org/odo/salmon_000782", # Recruits per spawner
#     "http://purl.dataone.org/odo/salmon_000493", # Fish biomass -- COME BACK TO THIS ONE
#     "http://purl.dataone.org/odo/salmon_000492", # Commercial harvest count
#     "http://purl.dataone.org/odo/salmon_000680", # Gum card number
#     "http://purl.dataone.org/odo/ECSO_00002768", # study location name
#     "http://purl.dataone.org/odo/salmon_000777", # Girth of fish
#     "http://purl.dataone.org/odo/salmon_000647", # Fish stock name
#     "http://purl.dataone.org/odo/salmon_000780", # AWC water body code
#     "http://purl.dataone.org/odo/salmon_000481", # Daily escapement count
#     "http://purl.dataone.org/odo/salmon_000480", # Annual escapement count
#     "http://purl.dataone.org/odo/salmon_000785", # Sport fishery harvest count
#     "http://purl.dataone.org/odo/salmon_000783", # Subsistence fishery harvest count
#     "http://purl.dataone.org/odo/salmon_000492", # Commercial fishery harvest count
#     "http://purl.dataone.org/odo/salmon_00127"
#   )) %>% 
#   
#   # see 'need_help' below (only removing these to make it easier to see what's left)
#   filter(!grouping %in% c(
#     "avgWeight_adultSalmon",
#     "biomassFishHarvested",
#     "biomassFishHarvested_byRegion",
#     "common_name",
#     "fish_weightG",
#     "fish_weightKG",
#     "fishLengths",
#     "sci_name",
#     "meshSize",
#     "dailyEscapement", 
#     "annualEscapement",
#     "salmon_abundance",
#     "totalHarvest"
#   )) %>% 
#   
#   # removing attributes that won't be annotated (at least during this round)
#   filter(!attributeName %in% c(
#     # -------------- LOCATIONS, DISTRICTS, REGIONS, ETC --------------
#     "district", "District", "DISTRICT", "DistrictID",
#     "Location_ID", "locationID", "LocationID", "locationType", "location_source", "location", 
#     "Location Description", "Location Name", "location_code", "LOCATION_DESCRIPTION", "Location_filename",
#     "location_filename", "LocationCode", "locationF", "locationHistory", "LocationF", "location_name",
#     "Sub District", "sub_district", "SubDisctrictID", "SubDistrict", "Jurisdiction",
#     "SASAP.Region", "SASAP Region", "SASAP.Region", "SASAP.region", "SASAP.Region_Corrected", "area", "zone name",
#     "MANAGEMENT_AREA", "managementArea", "Area", "Region", "system", "System", "subSystem", "SUBDISTRICT",
#     "subDistrict", "SubDistrictID", "Sub.Region", "Sub.DistrictID", "Sub.District", "statArea", "Stat.area",
#     "subDistrict", "subdistrict", "INDEX_AREA", "zone", "Ocean.Region", "REGION_ID", "parentLocationID", 
#     "region", "region_id", "SASAP_REGION", "SECTION", "CURRENT_2018_DIST_SUBD", "zone_name",
#     # -------------- WATER BODIES --------------
#     "STREAM_SECTION", "STREAM_LIFE", "STREAM", "Stream", "stream", "River",
#     # -------------- PROJECT INFO --------------
#     "ASLProjectType", "Project", "ProjectNumber", "Observation Method", "Observation Site", "OBSERVER",  "REMARKS",
#     "project", "PROJECT", "PROJECT_NAME", "project_type", "ProjectName", "DESCRIPTION", "description",
#     # -------------- DATES --------------
#     "Date.data.incorporated", "Date.data.obtained", "END_DATE", "START_DATE", "Initial.Year", "Year.Implemented", "yr_sea",
#     # -------------- DATA INFO/CODES --------------
#     "batch_barcode", "tray_barcode", "individual_barcode", "genetics_code", "genetics", "CF Stream Code", 
#     "Method", "METHOD", "NOTES", "number_cards", "n", "scale_card_position", "image_name", "number_scales", "id_numeric",
#     "fishNum", "fish_num", "errorAgeDescription",
#     "sample_number", "SampleNum", "sampler", "file", "DataSource", 
#     # -------------- SURVEYS --------------
#     "form_number", "SURVEY_CONDITIONS", "SURVEY_ID", "SURVEY_RATING", "SURVEY_TYPE", "Title", "period", "period_code",
#     "tender_name",
#     # -------------- Harvest --------------
#     "Chitina_Subdistrict_Harvest_CV", "Chitina_Subdistrict_Harvest_Federal", "Chitina_Subdistrict_Harvest_SE", 
#     "Chitina_Subdistrict_Harvest_State", "Copper_District_District_Total_Harvest", "Copper_District_Donated_Harvest",
#     "Copper_District_Educational_Harvest", "Copper_District_Homepack_Harvest", "Glennallen_Subdistrict_Harvest_CV",
#     "Glennallen_Subdistrict_Harvest_Federal", "Glennallen_Subdistrict_Harvest_SE", "Glennallen_Subdistrict_Harvest_State",
#     "Inriver_SE", "Inriver_UCI", "Inriver_LCI", "Inriver_CV",
#     # -------------- SALMON RUN --------------
#     "run", "RunType", "Lower", "Upper", "Total_Run", "Run",
#     # -------------- UNSORTED --------------
#     "GENERAL_CONDITIONS", "user_id", "URL", "Type", "AMA", "IT_DEFINED",
#      "CONDITION", "COMMENTS", "comment", "Comment..we.will.update.this.later.", "Collection Method",
#     "COUNTABLE_VIDEO", "ID", "ID1", "SURVEY_NUMBER",
#     "Source", "Source.ID", 
#     "problem", "solution", "solution_description", "problem_detailed", "problem_description",
#     "PILOT", "POSITION", "processor_name", 
#     "RT_EXPANSION", "session_name",
#     "solution_code", "Sport_CV", "Sport_SE", "DIST_CF_CD",
#     "tbl_AWL_IndividualFish_NealaEntered", "tbl_AWL_SampleEvents_NealaEntered", "lithocode",
#     "Catch_Esc", "Catch.Esc", "CF_S_CODE", "file", "DESCRIPTION", "DATA_EDIT_COMMENT", "WATER CONDITIONS", "WATER_CONDITIONS"
#   ))

##############################
# need to add terms/get help on these
##############################

# need_help <- round1 %>% 
#   filter(grouping %in% c(
#     "avgWeight_adultSalmon", # currently only 3 attributes; don't yet have a term for this
#     "biomassFishHarvested", # some of these attributes describe total biomass for a single species (e.g. Pink salmon), some describe total biomass across species; also some in lbs, some in thousandtonnes; how should we resolve this?
#     "biomassFishHarvested_byRegion", # 
#     "avg_air_temp", # currently annotating with ECSO's 'Air temperature', but these attributes all represent an average temperature
#     "annual_mean_precipitation", # these three precipitation groupings are currently grouped together as ECSO's 'Precipitation Volume'
#     "quarterly_mean_precip", # see above
#     "monthly_total_precip", # see above
#     "common_name", # how will we annotate a 'species' column? with, for e.g. 'Pacific salmon'? A 'species' column may make the most sense?
#     # "counts_by_region", # attributes in this group (currently) represent salmon counts broken up by country. However, the entity names describe the salmon types (enhanced-origin returning; natural-origin returning) 
#     "fish_weightG", # currently fish weights are separated by units
#     "fish_weightKG", # see above
#     "fishLengths", # annotate column with ALL fish length measurement types??
#     "sci_name", # do we want to also annotate a column like this as 'species'? or 'Pacific salmon'? etc?
#     "meshSize", # this isn't a 'Fishing gear type' but rather a quality of a fishing gear type (net)
#     "daily_escapement", # okay to break daily vs annual escapement up into two separate classes?
#     "annual_escapement", # see above
#     "salmon_abundance_biomass", #
#     "salmon_abundance_counts",
#     "totalHarvest" # this is a combination of harvest across years, regions, and/or fishery types; break apart further?
#   )) %>% 
#   select(-assigned_propertyURI, -assigned_valueURI, -prefName)

# write_csv(need_help, here::here("data", "annotationPrep", "need_help_reviewing_these_annotations_2021-07-21.csv"))

##############################
# revised round 1 attributes -- removing those that we won't address (after discussions with Bryce)
##############################

# round1_allAttributes_revised <- round1 %>% 
#   filter(!grouping %in% c("meshSize"))
# 
# write_csv(round1_allAttributes_revised, here::here("data", "annotationPrep", "round1_allAttributes_revised.csv"))

##############################
# species & fishLengths for each entity
##############################

round1_species <- read_csv(here::here("data", "annotationPrep", "species_datasets.csv")) %>% 
  filter(identifier %in% round1_pkgIDs)

# write_csv(round1_species, here::here("data", "annotationPrep", "round1_species.csv"))

round1_fishLengths <- read_csv(here::here("data", "sorted_attributes", "manual_fish_length_assignments", "fishLengths.csv")) %>% 
  filter(identifier %in% round1_pkgIDs)

# write_csv(round1_fishLengths, here::here("data", "annotationPrep", "round1_fishLengths.csv"))

round1_fishLengths_TYPES <- read_csv(here::here("data", "annotationPrep", "round1_fishLengths.csv"))
