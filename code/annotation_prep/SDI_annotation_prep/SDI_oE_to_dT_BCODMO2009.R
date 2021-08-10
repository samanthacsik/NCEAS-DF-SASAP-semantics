# title: Convert replicated data files to 'dataTables' -- BCO-DMO 2009
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
                   "urn:uuid:1646fd83-e7b8-4876-b695-333dd6d6675b", # this is actually the metadata pid from solr (will throw a warning but that's okay)
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
eml_path <- "/Users/samanthacsik/Repositories/NCEAS-DF-SASAP-semantics/eml/SDI_test_portal/Salmon_length_weight_sex_METADATA.xml"
write_eml(doc, eml_path)

##############################
# publish update
##############################

doc_name <- current_metadata_pid
dp <- replaceMember(current_pkg, doc_name, replacement = eml_path, newId = new_id, formatId = "https://eml.ecoinformatics.org/eml-2.2.0") 
message("Old metadata PID: " , doc_name, " | New metadata PID: ", new_id)
new_rm <- uploadDataPackage(devnceas, dp, public = TRUE, quiet = FALSE)

# old metadata pid = urn:uuid:1646fd83-e7b8-4876-b695-333dd6d6675b
# new metadata pid = urn:uuid:77bf16c1-2120-466f-8f5e-f5694d56870a
# old rm = resource_map_urn:uuid:8ce56af1-8ae6-4177-8225-c87d4e52d547
# new rm = resource_map_urn:uuid:77bf16c1-2120-466f-8f5e-f5694d56870a
