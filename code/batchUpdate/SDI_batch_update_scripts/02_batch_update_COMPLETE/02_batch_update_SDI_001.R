# title: batch update of datapackages with semantic annotations -- SALMON DATA INTEGRATION TEST PORTAL 001 (ADF&G Bristol Bay)
# author: "Sam Csik"
# date created: "2021-08-xx"
# date edited: "2021-08-xx"
# R version: 3.6.3
# input: 
# output: no output, but publishes updates to dev.nceas

##########################################################################################
# Summary - READ BEFORE RUNNING
##########################################################################################

# Pre-update steps:
#------------------
# 1) filter 'attributes' df for a subset of packages to be updated (do this in script 01_batch_update_setup.R)
# 2) rename subset as 'attributes' (do this in THIS script, 10b_batch_update_childORunnested.R)
# 3) update file path for writing EML (naming convention: eml/run#_pkgTypeIDtype_sizeClass_date, e.g. run1_standaloneDOI_small_2021Mar11)

# Post-update steps: 
#-------------------
# 1) save 'old_new_PIDs' df to a .csv file with the same naming convention as above (e.g. run1_standaloneDOI_small_2021Mar11) 
# 2) note any updated package as "complete" in the attributes df (do this in script 10a_batch_update_setup.R)

# Rinse, repeat

##########################################################################################
# General Setup
##########################################################################################

# load data/setup
source(here::here("code", "batchUpdate", "SDI_batch_update_scripts", "01_batch_update_setup_SDI.R"))

# load functions
source(here::here("code", "batchUpdate_functions", "all_batchUpdate_functions.R"))

##########################################################################################
# STEP 1: update eml documents with semantic annotations
##########################################################################################

##############################
# ensure subset of data is named 'attributes'
##############################

# >>>>>>>> UPDATE HERE BEFORE EACH RUN <<<<<<<<<< 
attributes <- SDI_atts_001 %>% 
  filter(!attributeName %in% c("Species", "Length"))
# -----------------------------------------------

##############################
# get vector of all unique datapackages
##############################

unique_datapackage_ids <- unique(attributes$identifier)

##############################
# create empty lists for sorting pkgs and docs into 
##############################

list_of_docs_to_publish_update <- list() # modified docs that passed validation
list_of_pkgs_to_publish_update <- list() # corresponding packages that will be updated (needed for 2nd for loop)
list_of_docs_failed_INITIAL_validation <- list() # docs that failed initial validation (before modifications)
list_of_pkgs_failed_INITIAL_validation <- list() # corresponding pkgs that failed initial validation (before modifications)
list_of_docs_failed_FINAL_validation <- list() # docs that failed final validation (after modifications)
list_of_pkgs_failed_FINAL_validation <- list() # corresponding packages that failed final validation (after modifications)

# -------------------------------------------------------------------------------------------------------------
# ----------------- get metadata/info for a particular datapackage and run initial validation -----------------
# -------------------------------------------------------------------------------------------------------------

tryLog(for(dp_num in 1:length(unique_datapackage_ids)){
  
  # get a package_id from unique_datapackage_ids vector
  pkg_identifier <- unique_datapackage_ids[[dp_num]]
  
  # download datapackage & parse
  outputs <- download_pkg_filter_data(pkg_identifier, attributes)
  doc <- outputs[[1]]
  current_pkg <- outputs[[2]]
  current_datapackage_subset <- outputs[[3]]
  current_metadata_pid <- outputs[[4]] 
  
  # initial validation
  initial_validation <- eml_validate(doc)
  
  # GATE to stop non-valid docs from processing
  if(isFALSE(initial_validation[1])){
    message("-------------- doc ", dp_num, " passes INTIAL validation -> ",  initial_validation[1], " --------------")
    list_of_docs_failed_INITIAL_validation[[dp_num]] <- doc
    list_of_pkgs_failed_INITIAL_validation[[dp_num]] <- current_pkg
    names(list_of_docs_failed_INITIAL_validation)[[dp_num]] <- current_metadata_pid
    names(list_of_pkgs_failed_INITIAL_validation)[[dp_num]] <- current_metadata_pid
    message("--------------Skipping to next doc...--------------")
    next
  }
  
  # for packages that passed initial validation, print message
  message("-------------- doc ", dp_num, " (", current_metadata_pid, ") passes INITIAL validation -> ",  initial_validation[1], " --------------")
  
  # GATE: ensure that the current metadata pid matches the packageId; if not, update the packageId with the current metadata pid
  if(current_metadata_pid != doc$packageId){
    message("!!!!!!!!!!!")
    message("doc_name (", current_metadata_pid, ") does not match packageId (", doc$packageId, ")")
    message("!!!!!!!!!!!")
    doc$packageId <- current_metadata_pid
    message("Updating packageId with the correct metadata pid...")
    message("!!!!!!!!!!!")
    message("packageId is now: ", doc$packageId)
    message("!!!!!!!!!!!")
  }
  
  # report how many dataTables and otherEntities are present in the current datapackage (informational only)
  get_entities(doc)
  
  # ---------------------------------------------------------------------------------------------------------------------------------------
  # -------------------------------- add annotations from the 'attributes' df to attributes in the EML doc --------------------------------
  # ---------------------------------------------------------------------------------------------------------------------------------------

  doc <- annotate_eml_attributes(doc)
  
  # ----------------------------------------------------------------------------------------------------------------------------------------
  # ----------------- validate modified doc and add to appropriate list so that it can be manually reviewed (if necessary) -----------------
  # ----------------------------------------------------------------------------------------------------------------------------------------
  
  # validate doc
  final_validation <- eml_validate(doc)
  
  # if doc passes validation, add to 'list_of_docs_to_publish_update()'
  if(isTRUE(final_validation[1])){
    message("-------------- doc ", dp_num, " (", current_metadata_pid, ") passes FINAL validation -> ",  final_validation[1], " --------------") 
    list_of_docs_to_publish_update[[dp_num]] <- doc
    list_of_pkgs_to_publish_update[[dp_num]] <- current_pkg
    names(list_of_docs_to_publish_update)[[dp_num]] <- current_metadata_pid 
    names(list_of_pkgs_to_publish_update)[[dp_num]] <- current_metadata_pid
    message("-------------- doc & pkg ", dp_num, " (", current_metadata_pid, ") have been added to the PUBLISH_UPDATE lists --------------")
  }
  
  # if doc fails validation, add to 'list_of_docs_failed_validation()' and 'list_of_pkgs_failed_validation()'
  if(isFALSE(final_validation[1])){
    message("-------------- doc ", dp_num, " (", current_metadata_pid, ") passes FINAL validation -> ",  final_validation[1], " --------------") 
    list_of_docs_failed_FINAL_validation[[dp_num]] <- doc
    list_of_pkgs_failed_FINAL_validation[[dp_num]] <- current_pkg
    names(list_of_docs_failed_FINAL_validation)[[dp_num]] <- current_metadata_pid 
    names(list_of_pkgs_failed_FINAL_validation)[[dp_num]] <- current_metadata_pid
    message("-------------- doc & pkg ", dp_num, " (", current_metadata_pid, ") have been added to the FAILED lists --------------")
  }
   
}, write.error.dump.file = TRUE, write.error.dump.folder = "dump_files", include.full.call.stack = FALSE) 








# getting ready for manual annnotations (species & length).......








# -------------------------------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------------------------------
# ANNOTATE BY HAND 
# -------------------------------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------------------------------

containsMeasurementsofType <- "http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"

##############################
# dataTable 1 (ASL_unformatted_BristolBay.csv) -- DO NOT ANNOTATE SPPECIES FOR THIS DATATABLE (really don't need to annotate at all, but skipping spp bc they are just coded values; 'formatted' version should be completely annotated)
##############################

# attribute 4 (Length = mid-eye to fork of tail)
doc$dataset$dataTable[[1]]$attributeList$attribute[[4]]$id <- "dataTable1_length"
doc$dataset$dataTable[[1]]$attributeList$attribute[[4]]$annotation <- list(propertyURI = list(label = "contains measurements of type", propertyURI = containsMeasurementsofType),
                                                                           valueURI = list(label = "Mid-orbit to fork of tail", valueURI = "http://purl.dataone.org/odo/salmon_000133"))

##############################
# dataTable 2 (ASL_formatted_BristolBay.csv) 
##############################

# attribute 3 (Species = chum, sockeye, pink, coho, chinook)
doc$dataset$dataTable[[2]]$attributeList$attribute[[3]]$id <- "dataTable2_spp"
doc$dataset$dataTable[[2]]$attributeList$attribute[[3]]$annotation <- list(
  list(propertyURI = list(label = "contains measurements of type", propertyURI = containsMeasurementsofType),
       valueURI = list(label = "Chum salmon", valueURI = "http://purl.dataone.org/odo/salmon_000240")),
  list(propertyURI = list(label = "contains measurements of type", propertyURI = containsMeasurementsofType),
       valueURI = list(label = "Sockeye salmon", valueURI = " http://purl.dataone.org/odo/salmon_000242")),
  list(propertyURI = list(label = "contains measurements of type", propertyURI = containsMeasurementsofType),
       valueURI = list(label = "Pink salmon", valueURI = "http://purl.dataone.org/odo/salmon_000241")),
  list(propertyURI = list(label = "contains measurements of type", propertyURI = containsMeasurementsofType),
       valueURI = list(label = "Coho salmon", valueURI = "http://purl.dataone.org/odo/salmon_000243")),
  list(propertyURI = list(label = "contains measurements of type", propertyURI = containsMeasurementsofType),
       valueURI = list(label = "Chinook salmon", valueURI = "http://purl.dataone.org/odo/salmon_000239"))
)

# attribute 5 (Length = Mid-orbit to fork of tail, Fork length, Post-orbit to fork of tail)
doc$dataset$dataTable[[2]]$attributeList$attribute[[5]]$id <- "dataTable2_length"
doc$dataset$dataTable[[2]]$attributeList$attribute[[5]]$annotation <- list(
  list(propertyURI = list(label = "contains measurements of type", propertyURI = containsMeasurementsofType),
       valueURI = list(label = "Mid-orbit to fork of tail", valueURI = "http://purl.dataone.org/odo/salmon_000133")),
  list(propertyURI = list(label = "contains measurements of type", propertyURI = containsMeasurementsofType),
       valueURI = list(label = "Fork length", valueURI = "http://purl.dataone.org/odo/salmon_000128")),
  list(propertyURI = list(label = "contains measurements of type", propertyURI = containsMeasurementsofType),
       valueURI = list(label = "Post-orbit to fork of tail", valueURI = "http://purl.dataone.org/odo/salmon_000129"))
)


# -------------------------------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------------------------------
# END
# -------------------------------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------------------------------

# 
# write_eml(doc, "~/eml.xml")
# eml_validate("~/eml.xml")
# 
# new_id <- dataone::generateIdentifier(devnceas@mn, "UUID")
# 
# doc_name <- current_metadata_pid
# dp <- current_pkg
# dp <- replaceMember(dp, doc_name, replacement = "~/eml.xml", newId = new_id, formatId = "https://eml.ecoinformatics.org/eml-2.2.0") 
# new_rm <- uploadDataPackage(devnceas, dp, public = TRUE, quiet = FALSE)








# some space to breathe...











##########################################################################################
# STEP 2: clean up environment, make sure lists are cleaned (no empty elements)
##########################################################################################

# clean up global environment...
rm(current_datapackage_subset, current_pkg, doc, outputs, current_metadata_pid, dp_num, duplicate_ids, final_validation, initial_validation, pkg_identifier, unique_datapackage_ids, validate_attributeID_hash)

# !!!!!!!!!
# BE SURE TO MANUALLY INSPECT LISTS BELOW AND ASSESS BLANK ELEMENTS -- MAKE SURE LISTS MATCH (though there is check for this built into step 3 below)
# !!!!!!!!!

# clean up lists (manually inspect and remove empty (NA) element(s), if necessary...if all docs passed initial/final validation then you won't need to worry about removing NAs)
publish_update_docs <- list_of_docs_to_publish_update
publish_update_pkgs <- list_of_pkgs_to_publish_update






























##########################################################################################
# STEP 3: publish updates to arctic.io 
##########################################################################################

##############################
# create empty df to store old and new pids in (in case they are needed for later reference) 
##############################

old_new_PIDs <- data.frame(old_metadataPID = as.character(),
                           old_resource_map = as.character(),
                           new_metadataPID = as.character(),
                           new_resource_map = as.character())

##############################
# create empty lists for docs/pkgs that don't match
##############################

nonmatching_docs <- list()
nonmatching_pkgs <- list()
id_not_in_dp <- list() 

##############################
# publish updates
##############################

tryLog(for(doc_num in 1:length(publish_update_docs)){ 

  # ----------------------------------------------------------------------------------------------
  # ----------------- get doc + metadata pid from the publish_update_docs() list -----------------
  # ----------------------------------------------------------------------------------------------
  
  # get doc from list
  doc <- publish_update_docs[[doc_num]]
  doc_name <- names(publish_update_docs)[[doc_num]]
  dataset_name <- doc$dataset$title
  message("Grabbing doc ", doc_num, ": ", doc_name)
  
  # -----------------------------------------------------------------------------------
  # ----------- extract DataPackage instance from publish_update_pkgs() list ----------
  # -----------------------------------------------------------------------------------
  
  # get DataPackage instance from list based on index that matched doc_num 
  dp <- publish_update_pkgs[[doc_num]]
  pkg_name <- names(publish_update_pkgs)[[doc_num]]
  original_rm <- dp@resmapId
  
  # -----------------------------------------------------------------------------------
  # -------------------------- make sure doc and pkg matches --------------------------
  # -----------------------------------------------------------------------------------
  
  # GATE: make sure doc and pkg names from both lists match; if not, throw a warning, save to lists, and move to next doc/pkg pair
  if(doc_name != pkg_name){
    warning("The doc name matches the pkg name: ", doc_name == pkg_name, " |  Saving to lists and moving to next doc/pkg pair.")
    nonmatching_docs[[doc_num]] <- doc
    names(nonmatching_docs)[[doc_num]] <- doc_name
    nonmatching_pkgs[[doc_num]] <- dp
    names(nonmatching_docs)[[doc_num]] <- pkg_name
    next
  } 
  
  # print message if doc and package match
  message("The doc name matches the pkg name: ", doc_name == pkg_name)
  
  # -----------------------------------------------------------------------------------
  # ------------- get package_type from 'attributes' df using metadata_pid ------------
  # -----------------------------------------------------------------------------------
  
  # # filter attributes df using metadata_pid
  # atts_filtered <- attributes %>% 
  #   filter(identifier == doc_name)
  # 
  # # get package_type
  # package_type <- atts_filtered[[1, 12]]
  
  # ---------------------------------------------------------------------
  # ----------------- generate new pid and write to eml -----------------
  # ---------------------------------------------------------------------

  # generate new pid (either doi or urn:uuid depending on what the original had) for metadata and write eml path (using old & new pids in eml file name)
  if(isTRUE(str_detect(doc_name, "(?i)doi"))) {
    new_id <- dataone::generateIdentifier(devnceas@mn, "DOI")
    message("Generating a new metadata DOI: ", new_id)
    title_snakecase <- gsub(" ", "_", dataset_name)
    short_title <- substr(title_snakecase, start = 1, stop = 30)
    eml_name <- paste(short_title, "_METADATA.xml", sep = "")
    # >>>>>>>> UPDATE HERE BEFORE EACH RUN <<<<<<<<<< 
    eml_path <- paste("/Users/samanthacsik/Repositories/NCEAS-DF-SASAP-semantics/eml/SDI_test_portal/", eml_name, sep = "")
    # ------------------------------------------------
    message("eml path: ", eml_path)
  } else if(isTRUE(str_detect(doc_name, "(?i)urn:uuid"))) {
    new_id <- dataone::generateIdentifier(devnceas@mn, "UUID")
    message("Generating a new metadata uuid: ", new_id)
    title_snakecase <- gsub(" ", "_", dataset_name)
    short_title <- substr(title_snakecase, start = 1, stop = 30)
    eml_name <- paste(short_title, "_METADATA.xml", sep = "")
    # >>>>>>>> UPDATE HERE BEFORE EACH RUN <<<<<<<<<< 
    eml_path <- paste("/Users/samanthacsik/Repositories/NCEAS-DF-SASAP-semantics/eml/SDI_test_portal/", eml_name, sep = "")
    # ------------------------------------------------
  } else {
    stop("The original metadata ID format, ", metadata_pid, " is not recognized. No new ID has been generated.")
  }
  
  # write eml
  write_eml(doc, eml_path)
  
  # ---------------------------------------------------------------
  # ------------------------ publish update -----------------------
  # ---------------------------------------------------------------
  
  # get DataObject names in current dp  
  message("Getting DataObject names from current package...")
  pkg_objects <- names(dp@objects)
  
  # check to make sure that the doc_name has a matching DataObject name in the current package; if so, replaceMember   
  if(isTRUE(str_subset(pkg_objects, pkg_name) == pkg_name)){
    dp <- replaceMember(dp, doc_name, replacement = eml_path, newId = new_id, formatId = "https://eml.ecoinformatics.org/eml-2.2.0") 
    # double_check_sysmeta_formatId <- getSystemMetadata(d1c_prod@mn, new_id)
    # message("formatId is 2.2.0: ", double_check_sysmeta@formatId == "https://eml.ecoinformatics.org/eml-2.2.0")
    message("replaceMember() complete!")

    # if no match is found, add to the 'id_not_in_dp()' list and move to next DataPackage
  } else{
    message("DataObject for id ", doc_name, " was not found in the DataPackage. Adding to list and skipping to next DataPackage.")
    id_not_in_dp[[doc_num]] <- dp
    names(id_not_in_dp)[[doc_num]] <- doc_name
    next
  }
    
  # publish update
  message("Publishing update for the following data package: ", doc_name)
  new_rm <- uploadDataPackage(devnceas, dp, public = TRUE, quiet = FALSE)
  message("Old metadata PID: " , doc_name, " | New metadata PID: ", new_id)
  message("-------------- Datapackage ", doc_num, " has been updated! --------------")
  
  # ---------------------------------------------------------------------------
  # ----------------- save old + new pids to df for reference -----------------
  # ---------------------------------------------------------------------------
  
  pids <- data.frame(old_metadataPID = doc_name,
                     old_resource_map = original_rm,
                     new_metadataPID = new_id, 
                     new_resource_map = new_rm)
  
  old_new_PIDs <- rbind(old_new_PIDs, pids)
  
  message("______ PIDS SAVED ______")
  
})

# ---------------------------------------------------------------
# ------------- save old/new metadata PIDs to a .csv ------------
# ---------------------------------------------------------------

# >>>>>>>> UPDATE HERE BEFORE EACH RUN <<<<<<<<<< 
# write_csv(old_new_PIDs, here::here("data", "updated_pkgs", "SDI_test_portal", "SDI_001.csv"))
# ------------------------------------------------

# old metadata pid: urn:uuid:ce3b4f4d-180c-4df7-bde8-49246495a5a4
# new metadata pid: urn:uuid:3d7b7c87-8f3a-4195-a294-b3bf1a406a64
# old rm: resource_map_urn:uuid:fb214067-160a-4f65-a217-00a1b1205c25
# new rm: resource_map_urn:uuid:3d7b7c87-8f3a-4195-a294-b3bf1a406a64










#------------------------------------------------------------------------------------------------------
# species and length annotations didn't appear -- trying again
#------------------------------------------------------------------------------------------------------

# get package using metadata pid
pkg <- get_package(devnceas@mn, 
                   "urn:uuid:3d7b7c87-8f3a-4195-a294-b3bf1a406a64", # this is actually the metadata pid from solr (will throw a warning but that's okay)
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
# manually add annotations
##############################

containsMeasurementsofType <- "http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"

###
# dataTable 1 (ASL_unformatted_BristolBay.csv) -- DO NOT ANNOTATE SPPECIES FOR THIS DATATABLE (really don't need to annotate at all, but skipping spp bc they are just coded values; 'formatted' version should be completely annotated)
###

# attribute 4 (Length = mid-eye to fork of tail)
doc$dataset$dataTable[[1]]$attributeList$attribute[[4]]$id <- "dataTable1_length"
doc$dataset$dataTable[[1]]$attributeList$attribute[[4]]$annotation <- list(propertyURI = list(label = "contains measurements of type", propertyURI = containsMeasurementsofType),
                                                                           valueURI = list(label = "Mid-orbit to fork of tail", valueURI = "http://purl.dataone.org/odo/salmon_000133"))
###
# dataTable 2 (ASL_formatted_BristolBay.csv) 
###

# attribute 3 (Species = chum, sockeye, pink, coho, chinook)
doc$dataset$dataTable[[2]]$attributeList$attribute[[3]]$id <- "dataTable2_spp"
doc$dataset$dataTable[[2]]$attributeList$attribute[[3]]$annotation <- list(
  list(propertyURI = list(label = "contains measurements of type", propertyURI = containsMeasurementsofType),
       valueURI = list(label = "Chum salmon", valueURI = "http://purl.dataone.org/odo/salmon_000240")),
  list(propertyURI = list(label = "contains measurements of type", propertyURI = containsMeasurementsofType),
       valueURI = list(label = "Sockeye salmon", valueURI = " http://purl.dataone.org/odo/salmon_000242")),
  list(propertyURI = list(label = "contains measurements of type", propertyURI = containsMeasurementsofType),
       valueURI = list(label = "Pink salmon", valueURI = "http://purl.dataone.org/odo/salmon_000241")),
  list(propertyURI = list(label = "contains measurements of type", propertyURI = containsMeasurementsofType),
       valueURI = list(label = "Coho salmon", valueURI = "http://purl.dataone.org/odo/salmon_000243")),
  list(propertyURI = list(label = "contains measurements of type", propertyURI = containsMeasurementsofType),
       valueURI = list(label = "Chinook salmon", valueURI = "http://purl.dataone.org/odo/salmon_000239"))
)

# attribute 5 (Length = Mid-orbit to fork of tail, Fork length, Post-orbit to fork of tail)
doc$dataset$dataTable[[2]]$attributeList$attribute[[5]]$id <- "dataTable2_length"
doc$dataset$dataTable[[2]]$attributeList$attribute[[5]]$annotation <- list(
  list(propertyURI = list(label = "contains measurements of type", propertyURI = containsMeasurementsofType),
       valueURI = list(label = "Mid-orbit to fork of tail", valueURI = "http://purl.dataone.org/odo/salmon_000133")),
  list(propertyURI = list(label = "contains measurements of type", propertyURI = containsMeasurementsofType),
       valueURI = list(label = "Fork length", valueURI = "http://purl.dataone.org/odo/salmon_000128")),
  list(propertyURI = list(label = "contains measurements of type", propertyURI = containsMeasurementsofType),
       valueURI = list(label = "Post-orbit to fork of tail", valueURI = "http://purl.dataone.org/odo/salmon_000129"))
)

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

# old metadata pid: urn:uuid:3d7b7c87-8f3a-4195-a294-b3bf1a406a64
# new metadata pid: urn:uuid:5f59b36c-e35c-4327-963c-f1071e82e047














#------------------------------------------------------------------------------------------------------
# update length labels
#------------------------------------------------------------------------------------------------------

# run lines 0-46 for setup

# get package using metadata pid
pkg <- get_package(devnceas@mn, 
                   "urn:uuid:5f59b36c-e35c-4327-963c-f1071e82e047", # this is actually the metadata pid from solr (will throw a warning but that's okay)
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
# manually add annotations
##############################

containsMeasurementsofType <- "http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"

#------------------------------
# dataTable 1 (ASL_unformatted_BristolBay.csv) -- DO NOT ANNOTATE SPPECIES FOR THIS DATATABLE (really don't need to annotate at all, but skipping spp bc they are just coded values; 'formatted' version should be completely annotated)
#------------------------------

# attribute 4 (Length = mid-eye to fork of tail)
doc$dataset$dataTable[[1]]$attributeList$attribute[[4]]$id <- "dataTable1_length"
doc$dataset$dataTable[[1]]$attributeList$attribute[[4]]$annotation <- list(propertyURI = list(label = "contains measurements of type", propertyURI = containsMeasurementsofType),
                                                                           valueURI = list(label = "Mid-orbit to fork of tail length", valueURI = "http://purl.dataone.org/odo/salmon_000133"))
#------------------------------
# dataTable 2 (ASL_formatted_BristolBay.csv) 
#------------------------------

# attribute 5 (Length = Mid-orbit to fork of tail, Fork length, Post-orbit to fork of tail)
doc$dataset$dataTable[[2]]$attributeList$attribute[[5]]$id <- "dataTable2_length"
doc$dataset$dataTable[[2]]$attributeList$attribute[[5]]$annotation <- list(
  list(propertyURI = list(label = "contains measurements of type", propertyURI = containsMeasurementsofType),
       valueURI = list(label = "Mid-orbit to fork of tail length", valueURI = "http://purl.dataone.org/odo/salmon_000133")),
  list(propertyURI = list(label = "contains measurements of type", propertyURI = containsMeasurementsofType),
       valueURI = list(label = "Fork length", valueURI = "http://purl.dataone.org/odo/salmon_000128")),
  list(propertyURI = list(label = "contains measurements of type", propertyURI = containsMeasurementsofType),
       valueURI = list(label = "Post-orbit to fork of tail length", valueURI = "http://purl.dataone.org/odo/salmon_000129"))
)



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

# old metadata pid: urn:uuid:5f59b36c-e35c-4327-963c-f1071e82e047
# new metadata pid: urn:uuid:88eba987-a7e8-40cc-9106-f0223106fe65





