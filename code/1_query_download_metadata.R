# title: Query SASAP Archive and Tidy Attributes
# date created: "2020-10-08"
# date edited: "2020-10-08"
# R version: 3.6.3
# input: 
# output: 

##########################################################################################
# Summary
##########################################################################################

# 1) Use solr query to extract SASAP package identifiers holdings
# 2) Use identifiers to extract/download associated .xml files 
# 3) Extract attribute-level metadata from downloaded .xml files and save as .csv
    # NOTE-- the following did not have entities with attributes:
      # doi:10.5063/F17W69GV
      # doi:10.5063/F1GH9G79
      # doi:10.5063/F1NK3C9X
      # doi:10.5063/F1R20ZN2

##############################
# Load packages
##############################

source(here::here("code", "0_libraries.R"))

##############################
# set nodes & get token
##############################

# token reminder
options(dataone_test_token = "...")

# nodes
cn <- CNode("PROD")
knb_mn <- getMNode(cn, 'urn:node:KNB')

##########################################################################################
# 1) query KNB for the SASAP collection (only the most recent published version) for identifiers, titles, keywords, abstracts, and attribute info
##########################################################################################

# solr query
semAnnotations_query <- query(knb_mn, 
                              list(q = "documents:* AND obsolete:(*:* NOT obsoletedBy:*)",
                                   fl = "identifier, collectionQuery, project, title, keywords, abstract, attribute, sem_annotates, sem_annotation, sem_annotated_by, sem_comment",
                                   rows = "30000"),
                              as = "data.frame")

semAnnotations_query <- semAnnotations_query %>% 
  filter(project == "State of Alaska's Salmon and People")

# write.csv(semAnnotations_query, file = here::here("data", "queries", "query2020-10-08", paste("fullQuery_semAnnotations", Sys.Date(),".csv", sep = "")), row.names = FALSE)

##########################################################################################
# 2) download  SASAP metadata using package identifiers from solr query above
##########################################################################################

# read in the .csv file containing the package identifiers
identifiers_file <- list.files(path = here::here("data", "queries", "query2020-10-08"), full.names = TRUE, pattern = "*.csv")
identifiers_df <- read.csv(here::here("data", "queries", "query2020-10-08", "fullQuery_semAnnotations2020-10-08.csv"), stringsAsFactors = FALSE)

# download .xml files for each data package 
for (index in 1:length(identifiers_df$identifier)) {
  identifier <- identifiers_df$identifier[[index]]
  cn <- CNode("PROD")
  download_objects(node = cn,
                   pids = identifier,
                   path = here::here("data", "queries", "query2020-10-08", "xml")) 
  progress(index, max.value = length(identifiers_df$identifier))
}

##########################################################################################
# 3) extract entity and attribute information, including property and valueURIs associated with any attributes
##########################################################################################

# extract attribute-level metadata from all downloaded .xml files in the working directory
document_paths <- list.files(setwd(here::here("data", "queries", "query2020-10-08", "xml")), full.names = TRUE, pattern = "*.xml")
attributes <- extract_ea(document_paths)

# make the output CSV file prefix based on the input CSV file name
file_prefix <- basename(identifiers_file)
file_prefix <- gsub(".csv","", file_prefix)

# create the CSV file containing the entity-attribute metadata
write.csv(attributes, file = here::here("data", "queries", "query2020-10-08", paste0(file_prefix, "_attributes.csv")), row.names = FALSE)
print(paste0(file_prefix, "_attributes.csv created"))

# import data to view
extracted_attributes <- read_csv(here::here("data", "queries", "query2020-10-08", "fullQuery_semAnnotations2020-10-08_attributes.csv"))