##########################################################################################
# Setting up Salmon Data Integration Test Portal
##########################################################################################

##############################
# clone pkg from KNB to test
##############################

# load pkgs
library(datamgmt)
library(dataone)
library(arcticdatautils)

# REMINDER: get authentication tokens

# define to and from for copy and paste
knb <- dataone::D1Client("PROD", "urn:node:KNB")
devnceas <- dataone::D1Client("STAGING2", "urn:node:mnTestKNB")

#-------------------------------------------------------------------------
# MATCH FOR MALICK 2016 
# clone pkg: Sockeye salmon brood tables, northeastern Pacific, 1922-2016. 
# original URL: https://knb.ecoinformatics.org/view/doi:10.5063/F1891459
# original rm: resource_map_urn:uuid:e414a9a6-ec17-4587-be60-35f9d7e8a210
# new URL: https://dev.nceas.ucsb.edu/view/urn%3Auuid%3Af96cc4b9-e896-4d80-a91b-1e3d71888f6e
# new rm: resource_map_urn:uuid:b43db3fa-6433-4540-994b-ca9857a816e3
#-------------------------------------------------------------------------

# pkg_clone <- datamgmt::copy_package("resource_map_urn:uuid:e414a9a6-ec17-4587-be60-35f9d7e8a210",
#                                      from = knb, to = devnceas)


#-------------------------------------------------------------------------
# MATCH FOR BELL 2021
# clone pkg: Salmon age, sex, and length data from Arctic-Yukon-Kuskokwim Region of Alaska, 1960-2017.
# original URL: https://knb.ecoinformatics.org/view/doi:10.5063/F1K64GBK
# original rm: resource_map_doi:10.5063/F1K64GBK
# new URL: 
# new rm: 
#-------------------------------------------------------------------------

# pkg_clone <- datamgmt::copy_package("resource_map_doi:10.5063/F1K64GBK",
#                                     from = knb, to = devnceas)

#-------------------------------------------------------------------------
# MATCH FOR BCODMO
# clone pkg: Salmon age, sex, and length data from Bristol Bay, Alaska, 1957-2009.
# original URL: https://knb.ecoinformatics.org/view/doi:10.5063/F15T3HRG
# original rm: esource_map_doi:10.5063/F15T3HRG
# new URL: 
# new rm: 
#-------------------------------------------------------------------------

# pkg_clone <- datamgmt::copy_package("resource_map_doi:10.5063/F15T3HRG",
#                                     from = knb, to = devnceas)

##############################
# explore Michael Malick's data for replication
##############################

chum <- read_csv(here::here("data", "data_integration", "Malick_Cox2016", "chum_data.csv"))
pink <- read_csv(here::here("data", "data_integration", "Malick_Cox2016", "pink_data.csv"))

# date ranges
min(chum$brood.yr)
max(chum$brood.yr)
min(pink$brood.yr)
max(pink$brood.yr)

# location
unique(chum$region)
unique(pink$region)

# stock.id
pink_stock_id <- read_csv(here::here("data", "data_integration", "Malick_Cox2016", "pink_info.csv"))
chum_stock_id <- read_csv(here::here("data", "data_integration", "Malick_Cox2016", "chum_info.csv"))

