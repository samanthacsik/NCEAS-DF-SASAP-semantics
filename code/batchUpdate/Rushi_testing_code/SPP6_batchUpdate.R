# title: SASAP TESTING MULTIPLE ANNOTATIONS PER ATTRIBUTE OR DATATABLE (https://search.dataone.org/view/doi:10.5063/F1T151XN)
# author: "Sam Csik"
# date created: "2021-01-04"
# date edited: "2021-05-20"
# R version: 3.6.3
# input: "code/10a.3_batch_update_setup.R"
# output: no output, but publishes updates to arcticdata.io 

##########################################################################################
# Summary - READ BEFORE RUNNING
##########################################################################################

# TESTING ON DEV
# first run batch update, then annotate attribute/dataTable with species by hand
# SPECIES: 
  # dataTable 1 
  # dataTable 2
  # dataTable 3, attribute 5
  # dataTable 4, attribute 4
  # dataTable 5, attribute 4

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
source(here::here("code", "batchUpdate", "01_batch_update_setup.R"))

# load functions
source(here::here("code", "batchUpdate_functions", "get_datapackage_metadata().R"))
source(here::here("code", "batchUpdate_functions", "get_eml_version().R"))
source(here::here("code", "batchUpdate_functions", "download_pkg_filter_data().R"))
source(here::here("code", "batchUpdate_functions", "get_entities().R"))
source(here::here("code", "batchUpdate_functions", "build_attributeID().R"))
source(here::here("code", "batchUpdate_functions", "verify_attributeID_isUnique().R"))
source(here::here("code", "batchUpdate_functions", "process_results().R"))
source(here::here("code", "batchUpdate_functions", "annotate_attributes_packedEntity().R"))
source(here::here("code", "batchUpdate_functions", "annotate_attributes_unpackedEntity().R"))
source(here::here("code", "batchUpdate_functions", "annotate_eml_attributes().R"))
source(here::here("code", "batchUpdate_functions", "annotate_single_dataTable_multiple_attributes().R"))
source(here::here("code", "batchUpdate_functions", "annotate_multiple_dataTables_multiple_attributes().R"))
source(here::here("code", "batchUpdate_functions", "annotate_single_dataTable_single_attribute().R"))
source(here::here("code", "batchUpdate_functions", "annotate_multiple_dataTables_single_attribute().R"))
source(here::here("code", "batchUpdate_functions", "annotate_single_otherEntity_multiple_attributes().R"))
source(here::here("code", "batchUpdate_functions", "annotate_multiple_otherEntities_multiple_attributes().R"))
source(here::here("code", "batchUpdate_functions", "annotate_single_otherEntity_single_attribute().R"))
source(here::here("code", "batchUpdate_functions", "annotate_multiple_otherEntities_single_attribute().R"))
source(here::here("code", "batchUpdate_functions", "process_entities_by_type().R"))

##########################################################################################
# STEP 1: update eml documents with semantic annotations
##########################################################################################

##############################
# ensure subset of data is named 'attributes'
##############################

# >>>>>>>> UPDATE HERE BEFORE EACH RUN <<<<<<<<<< 
attributes <- test6
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


# -------------------------------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------------------------------
# ANNOTATE BY HAND - SPECIES 
  # dataTable 1 
  # dataTable 2
  # dataTable 3
  # dataTable 4, attribute 14
  # dataTable 5, attribute 15
# -------------------------------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------------------------------

containsMeasurementsofType <- "http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"

# dataTable 1
doc$dataset$dataTable[[1]]$id <- "dataTable1_sppList"
doc$dataset$dataTable[[1]]$annotation <- list(
  list(propertyURI = list(label = "contains measurements of type", propertyURI = containsMeasurementsofType), 
       valueURI = list(label = "Oncorhynchus kisutch", valueURI = "http://purl.bioontology.org/ontology/SNOMEDCT/81789001")),
  list(propertyURI = list(label = "contains measurements of type", propertyURI = containsMeasurementsofType), 
       valueURI = list(label = "Oncorhynchus tshawytscha", valueURI = "http://purl.bioontology.org/ontology/SNOMEDCT/68644008")),
  list(propertyURI = list(label = "contains measurements of type", propertyURI = containsMeasurementsofType), 
       valueURI = list(label = "Oncorhynchus nerka", valueURI = "http://purl.bioontology.org/ontology/SNOMEDCT/68644008")),
  list(propertyURI = list(label = "contains measurements of type", propertyURI = containsMeasurementsofType), 
       valueURI = list(label = "Oncorhynchus gorbuscha", valueURI = "http://purl.bioontology.org/ontology/SNOMEDCT/23662001")),
  list(propertyURI = list(label = "contains measurements of type", propertyURI = containsMeasurementsofType), 
       valueURI = list(label = "Oncorhynchus keta", valueURI = "http://purl.bioontology.org/ontology/SNOMEDCT/62285003"))
)

# dataTable 2
doc$dataset$dataTable[[2]]$id <- "dataTable2_sppList"
doc$dataset$dataTable[[2]]$annotation <- list(
  list(propertyURI = list(label = "contains measurements of type", propertyURI = containsMeasurementsofType), 
       valueURI = list(label = "Oncorhynchus kisutch", valueURI = "http://purl.bioontology.org/ontology/SNOMEDCT/81789001")),
  list(propertyURI = list(label = "contains measurements of type", propertyURI = containsMeasurementsofType), 
       valueURI = list(label = "Oncorhynchus tshawytscha", valueURI = "http://purl.bioontology.org/ontology/SNOMEDCT/68644008")),
  list(propertyURI = list(label = "contains measurements of type", propertyURI = containsMeasurementsofType), 
       valueURI = list(label = "Oncorhynchus nerka", valueURI = "http://purl.bioontology.org/ontology/SNOMEDCT/68644008")),
  list(propertyURI = list(label = "contains measurements of type", propertyURI = containsMeasurementsofType), 
       valueURI = list(label = "Oncorhynchus gorbuscha", valueURI = "http://purl.bioontology.org/ontology/SNOMEDCT/23662001")),
  list(propertyURI = list(label = "contains measurements of type", propertyURI = containsMeasurementsofType), 
       valueURI = list(label = "Oncorhynchus keta", valueURI = "http://purl.bioontology.org/ontology/SNOMEDCT/62285003"))
  )

# dataTable 3
doc$dataset$dataTable[[3]]$id <- "dataTable3_sppList"
doc$dataset$dataTable[[3]]$annotation <- list(
  list(propertyURI = list(label = "contains measurements of type", propertyURI = containsMeasurementsofType), 
       valueURI = list(label = "Oncorhynchus kisutch", valueURI = "http://purl.bioontology.org/ontology/SNOMEDCT/81789001")),
  list(propertyURI = list(label = "contains measurements of type", propertyURI = containsMeasurementsofType), 
       valueURI = list(label = "Oncorhynchus tshawytscha", valueURI = "http://purl.bioontology.org/ontology/SNOMEDCT/68644008")),
  list(propertyURI = list(label = "contains measurements of type", propertyURI = containsMeasurementsofType), 
       valueURI = list(label = "Oncorhynchus nerka", valueURI = "http://purl.bioontology.org/ontology/SNOMEDCT/68644008")),
  list(propertyURI = list(label = "contains measurements of type", propertyURI = containsMeasurementsofType), 
       valueURI = list(label = "Oncorhynchus gorbuscha", valueURI = "http://purl.bioontology.org/ontology/SNOMEDCT/23662001")),
  list(propertyURI = list(label = "contains measurements of type", propertyURI = containsMeasurementsofType), 
       valueURI = list(label = "Oncorhynchus keta", valueURI = "http://purl.bioontology.org/ontology/SNOMEDCT/62285003"))
)

# dataTable 4, attribute 4
doc$dataset$dataTable[[4]]$attributeList$attribute[[14]]$id <- "dataTable4_sppListAtt14"
doc$dataset$dataTable[[4]]$attributeList$attribute[[14]]$annotation <- list(
  list(propertyURI = list(label = "contains measurements of type", propertyURI = containsMeasurementsofType), 
       valueURI = list(label = "Species", valueURI = "http://purl.dataone.org/odo/ECSO_00000313")),
  list(propertyURI = list(label = "contains measurements of type", propertyURI = containsMeasurementsofType), 
       valueURI = list(label = "Oncorhynchus kisutch", valueURI = "http://purl.bioontology.org/ontology/SNOMEDCT/81789001")),
  list(propertyURI = list(label = "contains measurements of type", propertyURI = containsMeasurementsofType), 
       valueURI = list(label = "Oncorhynchus tshawytscha", valueURI = "http://purl.bioontology.org/ontology/SNOMEDCT/68644008")),
  list(propertyURI = list(label = "contains measurements of type", propertyURI = containsMeasurementsofType), 
       valueURI = list(label = "Oncorhynchus nerka", valueURI = "http://purl.bioontology.org/ontology/SNOMEDCT/68644008")),
  list(propertyURI = list(label = "contains measurements of type", propertyURI = containsMeasurementsofType), 
       valueURI = list(label = "Oncorhynchus gorbuscha", valueURI = "http://purl.bioontology.org/ontology/SNOMEDCT/23662001")),
  list(propertyURI = list(label = "contains measurements of type", propertyURI = containsMeasurementsofType), 
       valueURI = list(label = "Oncorhynchus keta", valueURI = "http://purl.bioontology.org/ontology/SNOMEDCT/62285003"))
)

# dataTable 5, attribute 4
doc$dataset$dataTable[[5]]$attributeList$attribute[[15]]$id <- "dataTable5_sppListAtt15"
doc$dataset$dataTable[[5]]$attributeList$attribute[[15]]$annotation <- list(
  list(propertyURI = list(label = "contains measurements of type", propertyURI = containsMeasurementsofType), 
       valueURI = list(label = "Species", valueURI = "http://purl.dataone.org/odo/ECSO_00000313")),
  list(propertyURI = list(label = "contains measurements of type", propertyURI = containsMeasurementsofType), 
       valueURI = list(label = "Oncorhynchus kisutch", valueURI = "http://purl.bioontology.org/ontology/SNOMEDCT/81789001")),
  list(propertyURI = list(label = "contains measurements of type", propertyURI = containsMeasurementsofType), 
       valueURI = list(label = "Oncorhynchus tshawytscha", valueURI = "http://purl.bioontology.org/ontology/SNOMEDCT/68644008")),
  list(propertyURI = list(label = "contains measurements of type", propertyURI = containsMeasurementsofType), 
       valueURI = list(label = "Oncorhynchus nerka", valueURI = "http://purl.bioontology.org/ontology/SNOMEDCT/68644008")),
  list(propertyURI = list(label = "contains measurements of type", propertyURI = containsMeasurementsofType), 
       valueURI = list(label = "Oncorhynchus gorbuscha", valueURI = "http://purl.bioontology.org/ontology/SNOMEDCT/23662001")),
  list(propertyURI = list(label = "contains measurements of type", propertyURI = containsMeasurementsofType), 
       valueURI = list(label = "Oncorhynchus keta", valueURI = "http://purl.bioontology.org/ontology/SNOMEDCT/62285003"))
)

spp_validation <- eml_validate(doc)
# -------------------------------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------------------------------
# END
# -------------------------------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------------------------------


write_eml(doc, "~/eml.xml")
eml_validate("~/eml.xml")

new_id <- dataone::generateIdentifier(devnceas@mn, "UUID")

doc_name <- current_metadata_pid
dp <- current_pkg
dp <- replaceMember(dp, doc_name, replacement = "~/eml.xml", newId = new_id, formatId = "https://eml.ecoinformatics.org/eml-2.2.0") 
new_rm <- uploadDataPackage(devnceas, dp, public = TRUE, quiet = FALSE)









