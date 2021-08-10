# title: Convert replicated data files to 'dataTables' -- Bell 2021
# author: "Sam Csik"
# date created: "2021-08-05"
# date edited: "2021-08-05"
# R version: 3.6.3
# input: 
# output: no output, but publishes updates to dev.nceas

##############################
# setup
##############################

library(arcticdatautils)
devnceas <- dataone::D1Client("STAGING2", "urn:node:mnTestKNB")

##############################
# download pkg & metadata
##############################

# get package using metadata pid
pkg <- get_package(devnceas@mn, 
                   "urn:uuid:22464585-00e2-4be2-8ef0-75a2ebc6bcb3", # this is actually the metadata pid from solr (will throw a warning but that's okay)
                   file_names = TRUE)

# extract resource map
resource_pid <-  pkg$resource_map

# get pkg using resource map 
current_pkg <- getDataPackage(devnceas, identifier = resource_pid, lazyLoad = TRUE, quiet = FALSE)

# get current_metadata_pid
current_metadata_pid  <- selectMember(current_pkg, name = "sysmeta@formatId", value = "https://eml.ecoinformatics.org/eml-2.2.0")

# get doc
doc <- read_eml(getObject(devnceas@mn, current_metadata_pid)) 

##############################
# convert to dataTables & validate
##############################

# convert to dataTables
doc <- eml_otherEntity_to_dataTable(doc, index = 1, validate_eml = TRUE)

# validate
eml_validate(doc)

##############################
# generate new pid & write eml
##############################

new_id <- dataone::generateIdentifier(devnceas@mn, "UUID")
eml_path <- "/Users/samanthacsik/Repositories/NCEAS-DF-SASAP-semantics/eml/SDI_test_portal/Chum_salmon_escapement_Bonanza_METADATA.xml"
write_eml(doc, eml_path)

##############################
# publish update
##############################

doc_name <- current_metadata_pid
dp <- replaceMember(current_pkg, doc_name, replacement = eml_path, newId = new_id, formatId = "https://eml.ecoinformatics.org/eml-2.2.0") 
message("Old metadata PID: " , doc_name, " | New metadata PID: ", new_id)
new_rm <- uploadDataPackage(devnceas, dp, public = TRUE, quiet = FALSE)

# old metadata pid = urn:uuid:22464585-00e2-4be2-8ef0-75a2ebc6bcb3
# new metadata pid = urn:uuid:4ad48407-8044-4f4a-9596-18e9cb221656
# old rm = resource_map_urn:uuid:138a5075-7622-4e0a-86e6-bced019a2b5c
# new rm = resource_map_urn:uuid:4ad48407-8044-4f4a-9596-18e9cb221656


