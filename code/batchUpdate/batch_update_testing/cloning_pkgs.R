# cloning datasets to dev for testing 27Jul2021
  # https://search.dataone.org/view/doi:10.5063/F1891459

# search-stage.test.dataone.org/cn/v2/node (view source) (dev.nceas isn't here)
# stage2: (dev.nceas here) dev.neas.ucsb.edu

# 1) copy rm (after Package on website)
# 2) register KNB production token : options("dataone-token") to check
# 3) dev.neas.ucsb.edu (sign in)
# 4) register test  token : options("dataone-test-token") to check

library(datamgmt)
library(dataone)

# define to and from for copy and pastingx
knb <- dataone::D1Client("PROD", "urn:node:KNB")
devnceas <- dataone::D1Client("STAGING2", "urn:node:mnTestKNB")

# 1: 2021-07-27@13:07 ------------------------------------------------------------------------------------------------
# original: resource_map_doi:10.5063/F1891459 new: resource_map_urn:uuid:22cf0551-a0e5-45a8-82ab-47ab00aa85a4
# original URL: https://search.dataone.org/view/doi:10.5063/F1891459
# new URL: https://dev.nceas.ucsb.edu/view/urn%3Auuid%3A3dd897e3-46f6-4bf5-8c90-93bb9601d5cc
# pkg_clone <- datamgmt::copy_package("resource_map_doi:10.5063/F1891459",
#                                      from = knb, to = devnceas)
