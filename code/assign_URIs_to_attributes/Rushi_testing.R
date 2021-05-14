# Rushi testing

source(here::here("code", "05b_combine_attributes_for_annotation.R"))

testing <- SASAP_attributes %>% 
  filter(viewURL %in% c("https://search.dataone.org/view/doi:10.5063/F1KD1W57",
                        "https://search.dataone.org/view/doi:10.5063/F1MK6B60",
                        "https://search.dataone.org/view/doi:10.5063/F1542KVC",
                        "https://search.dataone.org/view/doi:10.5063/F1639N0M",
                        "https://search.dataone.org/view/doi:10.5063/F1891459"))

test1 <- SASAP_attributes %>% 
  filter(viewURL %in% c("https://search.dataone.org/view/doi:10.5063/F1KD1W57")) %>% 
  filter(assigned_valueURI != "tbd")

test2 <- SASAP_attributes %>% 
  filter(viewURL %in% c("https://search.dataone.org/view/doi:10.5063/F1MK6B60")) %>% 
  filter(assigned_valueURI != "tbd")

test3 <- SASAP_attributes %>% 
  filter(viewURL %in% c("https://search.dataone.org/view/doi:10.5063/F1542KVC")) %>% 
  filter(assigned_valueURI != "tbd") %>% 
  filter(!attributeName %in% c("RecSex", "Species"))

test4 <- SASAP_attributes %>% 
  filter(viewURL %in% c("https://search.dataone.org/view/doi:10.5063/F1639N0M")) %>% 
  filter(assigned_valueURI != "tbd") %>% 
  filter(prefName != "number of years")
         
test5 <- SASAP_attributes %>% 
  filter(viewURL %in% c("https://search.dataone.org/view/doi:10.5063/F1891459")) %>% 
  filter(assigned_valueURI != "tbd") %>% 
  filter(prefName != "Species")

Rushi_testing <- rbind(test1, test2, test3, test4, test5)
write_csv(Rushi_testing, here::here("data", "Rushi_testing.csv"))
