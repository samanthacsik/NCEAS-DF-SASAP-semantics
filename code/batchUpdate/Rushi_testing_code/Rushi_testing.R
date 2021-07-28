# Rushi testing

source(here::here("code", "05b_combine_attributes_for_annotation.R"))

rm(test, unique_attributeNames_counts, repeats, SASAP_attributes_distinct, SASAP_attributes_test)

# testing <- SASAP_attributes %>% 
#   filter(viewURL %in% c("https://search.dataone.org/view/doi:10.5063/F1KD1W57",
#                         "https://search.dataone.org/view/doi:10.5063/F1MK6B60",
#                         "https://search.dataone.org/view/doi:10.5063/F1542KVC",
#                         "https://search.dataone.org/view/doi:10.5063/F1639N0M",
#                         "https://search.dataone.org/view/doi:10.5063/F1891459"))

test1 <- SASAP_attributes %>% 
  filter(viewURL %in% c("https://search.dataone.org/view/doi:10.5063/F1KD1W57")) %>% 
  filter(assigned_valueURI != "tbd")

test2 <- SASAP_attributes %>% 
  filter(viewURL %in% c("https://search.dataone.org/view/doi:10.5063/F1MK6B60")) %>% 
  filter(assigned_valueURI != "tbd")

test3 <- SASAP_attributes %>% 
  filter(viewURL %in% c("https://search.dataone.org/view/doi:10.5063/F1542KVC")) %>% 
  filter(assigned_valueURI != "tbd") %>% 
  filter(!attributeName %in% c("RecSex")) # , "Species"

test4 <- SASAP_attributes %>% 
  filter(viewURL %in% c("https://search.dataone.org/view/doi:10.5063/F1639N0M")) %>% 
  filter(assigned_valueURI != "tbd") %>% 
  filter(prefName != "number of years")
         
test5 <- SASAP_attributes %>% 
  filter(viewURL %in% c("https://search.dataone.org/view/doi:10.5063/F1891459")) %>% 
  filter(assigned_valueURI != "tbd") # %>% 
  # filter(prefName != "Species")

test6 <- SASAP_attributes %>% 
  filter(viewURL %in% c("https://search.dataone.org/view/doi:10.5063/F1T151XN")) %>% 
  filter(assigned_valueURI != "tbd")

test7 <- SASAP_attributes %>% 
  filter(viewURL %in% c("https://search.dataone.org/view/doi:10.5063/F12805X0")) %>% 
  filter(assigned_valueURI != "tbd")

Rushi_testing <- rbind(test1, test2, test3, test4, test5, test6, test7)
write_csv(Rushi_testing, here::here("data", "RushiTesting", "Rushi_testing.csv"))
 
# ---------------------------------------------------------------------------------
# SNOMED CT
# O. keta (chum): http://purl.bioontology.org/ontology/SNOMEDCT/62285003
# O. kisutch (coho): http://purl.bioontology.org/ontology/SNOMEDCT/81789001
# O. nerka (sockeye): http://purl.bioontology.org/ontology/SNOMEDCT/68644008
# O. tshawytcha (chinook): http://purl.bioontology.org/ontology/SNOMEDCT/81028000
# O. gorbuscha (pink): http://purl.bioontology.org/ontology/SNOMEDCT/23662001

# NCBITAXON
# O. kisutch: "http://purl.bioontology.org/ontology/NCBITAXON/8019"
# O. tshawytscha: "http://purl.bioontology.org/ontology/NCBITAXON/74940"
# O. nerka: "http://purl.bioontology.org/ontology/NCBITAXON/8023"
# O. gorbuscha: "http://purl.bioontology.org/ontology/NCBITAXON/8017"
# O. keta: "http://purl.bioontology.org/ontology/NCBITAXON/8018"