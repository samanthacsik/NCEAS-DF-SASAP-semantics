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

# ------------------------------------------------------------------------------------------------
# original: doi:10.5063/F1KD1W57; new: resource_map_urn:uuid:f286a177-6ed1-44d3-a553-d0c52d1e7a57
# https://search.dataone.org/view/doi:10.5063/F1KD1W57
# https://dev.nceas.ucsb.edu/view/urn%3Auuid%3Ae7588688-0f0b-49e5-841e-85372db2908f
pkg_clone <- datamgmt::copy_package("resource_map_doi:10.5063/F1KD1W57",
                                     from = knb, to = devnceas)
                                     #add_access_to = NULL,
                                     #change_auth_node = TRUE,
                                     #new_pid = TRUE)

# ------------------------------------------------------------------------------------------------
# original: doi:10.5063/F1MK6B60; new: resource_map_urn:uuid:243ffbcb-a4a1-406e-b3d5-3b9f569dd41f
# https://search.dataone.org/view/doi:10.5063/F1MK6B60
# https://dev.nceas.ucsb.edu/view/urn%3Auuid%3A29775493-a818-4cf9-b6dd-d01a19c8dcfd
pkg_clone <- datamgmt::copy_package("resource_map_doi:10.5063/F1MK6B60",
                                    from = knb, to = devnceas)

# ------------------------------------------------------------------------------------------------
# original: doi:10.5063/F1542KVC; new: resource_map_urn:uuid:ae3c5617-970d-4d61-867f-ca2f9758531c
# https://search.dataone.org/view/doi:10.5063/F1542KVC
# https://dev.nceas.ucsb.edu/view/urn%3Auuid%3A461fa59f-efdd-4080-b9e4-60e32687ca98
pkg_clone <- datamgmt::copy_package("resource_map_doi:10.5063/F1542KVC",
                                    from = knb, to = devnceas)

# ------------------------------------------------------------------------------------------------
# original: doi:10.5063/F1639N0M; new: resource_map_urn:uuid:1dc641c2-fc89-47f2-95d2-901fb7f8afa4
# https://search.dataone.org/view/doi:10.5063/F1639N0M
# https://dev.nceas.ucsb.edu/view/urn%3Auuid%3A29eda9ca-e82b-4da0-85b7-d7796c85193b
pkg_clone <- datamgmt::copy_package("resource_map_doi:10.5063/F1639N0M",
                                    from = knb, to = devnceas)

# ------------------------------------------------------------------------------------------------
# original: doi:10.5063/F1891459; new: resource_map_urn:uuid:7515b8e6-7fdb-460f-a4ec-7b385ad3a330
# https://search.dataone.org/view/doi:10.5063/F1891459
# https://dev.nceas.ucsb.edu/view/urn%3Auuid%3Aa88f8e1f-8eca-437a-8853-e813eac2ad01
pkg_clone <- datamgmt::copy_package("resource_map_doi:10.5063/F1891459",
                                    from = knb, to = devnceas)
