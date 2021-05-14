# cloning datasets to dev for testing 14May2021

# https://search.dataone.org/view/doi:10.5063/F1KD1W57
# https://search.dataone.org/view/doi:10.5063/F1MK6B60
# https://search.dataone.org/view/doi:10.5063/F1542KVC
# https://search.dataone.org/view/doi:10.5063/F1639N0M
# https://search.dataone.org/view/doi:10.5063/F1891459

# search-stage.test.dataone.org/cn/v2/node (view source) (dev.nceas isn't here)
# stage2: (dev.nceas here) dev.neas.ucsb.edu

# 1) copy rm (after Package on website)
# 2) register KNB production token : options("dataone-token") to check
# 3) dev.neas.ucsb.edu (sign in)
# 4) register test  token : options("dataone-test-token") to check

library(datamgmt)
library(dataone)

# define to and from for copy and pasting
knb <- dataone::D1Client("PROD", "urn:node:KNB")
devnceas <- dataone::D1Client("STAGING2", "urn:node:mnTestKNB")

# clone package
pkg_clone <- datamgmt::copy_package("resource_map_doi:10.18739/A24B2X46G",
                                     from = knb, to = devnceas)
                                     #add_access_to = NULL,
                                     #change_auth_node = TRUE,
                                     #new_pid = TRUE)


# log into the RStudio server