annotate_single_dataTable_multiple_attributes <- function(doc, eml_att_num, current_attribute_id, attributeName_subset){
 
  # add attribute id to metadata
  doc$dataset$dataTable$attributeList$attribute[[eml_att_num]]$id <- current_attribute_id
  # message("Added attributeID, '", current_attribute_id, "' to metadata")
  
  # add property URI to metadata (this is the same for all attributes)
  # containsMeasurementsofType <- "http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType"
  # doc$dataset$dataTable$attributeList$attribute[[eml_att_num]]$annotation$propertyURI <- list(label = "contains measurements of",
  #                                                                                             propertyURI = containsMeasurementsofType)
  current_propertyURI <- attributeName_subset$assigned_propertyURI
  current_propertyLabel <- attributeName_subset$propertyURI_label
  doc$dataset$dataTable$attributeList$attribute[[eml_att_num]]$annotation$propertyURI <- list(label = current_propertyLabel,
                                                                                                            propertyURI = current_propertyURI)
  
  # add value URI to metadata
  current_valueURI <- attributeName_subset$assigned_valueURI
  current_label <- attributeName_subset$prefName
  doc$dataset$dataTable$attributeList$attribute[[eml_att_num]]$annotation$valueURI <- list(label = current_label,
                                                                                           valueURI = current_valueURI)
  # message("Added semantic annotation URI, '", current_valueURI, "' to metadata for attribute, '", current_attribute_name_from_eml, "'")
  
  return(doc)
}
