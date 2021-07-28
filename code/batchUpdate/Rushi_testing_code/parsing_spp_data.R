
library(tidyverse)

a <- read_csv(here::here("data", "RushiTesting", "speciesData", "MandV2010.csv")) 
unique(a$Species)

b <- read_csv(here::here("data", "RushiTesting", "speciesData", "2_ESCAPEMENT_DATA.csv")) 
unique(b$SPECIES)

c <- read_csv(here::here("data", "RushiTesting", "speciesData", "3_REPORTED_ESCAPEMENT.csv")) 
unique(c$SPECIES)

# d<- read_csv(here::here("data", "RushiTesting", "speciesData", "4_LUT_STREAM_SECTION_ATTRIBUTES.csv")) 
# unique(d$ABBREVIATED_NAME)

e <- read_csv(here::here("data", "RushiTesting", "speciesData", "6_LUT_SPECIES.csv")) 
unique(e$SCIENTIFIC_NAME)

f <- read_csv(here::here("data", "RushiTesting", "speciesData","Cunningham_BristolBay.csv"))
unique(f$Species)

g <- read_csv(here::here("data", "RushiTesting", "speciesData","ASL_formatted_BristolBay.csv"))
unique(g$Species)

h <- read_csv(here::here("data", "RushiTesting", "speciesData","BB_ASL.csv"))
unique(h$Species)

i <- read_csv(here::here("data", "RushiTesting", "speciesData","AYKDBMS.csv"))
unique(i$Species)

j <- read_csv(here::here("data", "RushiTesting", "speciesData","Statewide_Salmon_COAR_production_wholesale.csv"))
unique(j$species)

k <- read_csv(here::here("data", "RushiTesting", "speciesData","Total_wholesale.csv"))
unique(k$SpeciesGroup) # SpeciesName

l <- read_csv(here::here("data", "RushiTesting", "speciesData","PricePounds.csv"))
unique(l$Species) 

m <- read_csv(here::here("data", "RushiTesting", "speciesData","CompiledEsc.csv"))
unique(m$Species) 

n <- read_csv(here::here("data", "RushiTesting", "speciesData","ASFDB_FullPermit.csv"))
unique(n$species) 

o <- read_csv(here::here("data", "RushiTesting", "speciesData","Escapement_location_linked.csv"))
unique(o$Species) 

p <- read_csv(here::here("data", "RushiTesting", "speciesData","ASL_formatted_SoutheastSupplement.csv"))
unique(p$Species) 

q <- read_csv(here::here("data", "RushiTesting", "speciesData","Hatchery_releases.csv"))
unique(q$Species) 

r <- read_csv(here::here("data", "RushiTesting", "speciesData","Central_region_20170517.csv"))
unique(r$Species) 

rr <- read_csv(here::here("data", "RushiTesting", "speciesData","centralRegion2011to2017.csv"))
unique(rr$Species) 

s <- read_csv(here::here("data", "RushiTesting", "speciesData","fishery_disaster_request_details.csv"))
unique(s$Species) 

t <- read_csv(here::here("data", "RushiTesting", "speciesData","salmon-abundance_mean-cumulative-annual-count_by-region.csv"))
unique(t$Species) 

u <- read_csv(here::here("data", "RushiTesting", "speciesData","Glennallen_Harvest.csv"))
unique(u$Species) 

v <- read_csv(here::here("data", "RushiTesting", "speciesData","Glennallen_Harvest.csv"))
unique(v$Species) 

w <- read_csv(here::here("data", "RushiTesting", "speciesData","Statewide_Salmon.csv"))
unique(w$Species) 

x <- read_csv(here::here("data", "RushiTesting", "speciesData","CFEC_permitEarnings.csv"))
unique(x$clade)

y <- read_csv(here::here("data", "RushiTesting", "speciesData","Commercial_Harvest_Reports.csv"))
unique(y$species)

z <- read_csv(here::here("data", "RushiTesting", "speciesData","PWS_CopperRiver.csv"))
unique(z$species)

aa <- read_csv(here::here("data", "RushiTesting", "speciesData","MandV2016.csv"))
unique(aa$Species)

bb <- read_csv(here::here("data", "RushiTesting", "speciesData","Harvest_All_Sectors.csv"))
unique(bb$species)

cc <- read_csv(here::here("data", "RushiTesting", "speciesData","FSB_Coding_Database.csv"))
unique(cc$Species)

dd <- read_csv(here::here("data", "RushiTesting", "speciesData","NorthernArea_ASL.csv"))
unique(dd$species)
# ASL_formatted_Kotzebue.csv
# ASL_formatted_Kuskokwim.csv
# ASL_formatted_NorthernArea.csv
# ASL_formatted_NortonSound.csv
# ASL_formatted_Yukon.csv
# ASL_formatted_YukonCanada.csv
# YukonCanada_ASL.csv
# Yukon_ASL.csv
# NortonSound_ASL.csv
# NorthernArea_ASL.csv
# Kuskokwim_ASL.csv
# Kotzebue_ASL.csv

ee <- read_csv(here::here("data", "RushiTesting", "speciesData","AKSalmon_Exvessel_Prices.csv"))
unique(ee$Species)

ff <- read_csv(here::here("data", "RushiTesting", "speciesData","PWS_weirTower.csv"))
unique(ff$Species)
# PWS_Weir_Tower_export.csv
# PWS_weirTower.csv

gg <- read_csv(here::here("data", "RushiTesting", "speciesData","weights.csv"))
unique(gg$Species)

hh <- read_csv(here::here("data", "RushiTesting", "speciesData","ASL_formatted_LowerCookInlet.csv"))
unique(hh$Species)

ii <- read_csv(here::here("data", "RushiTesting", "speciesData","AKAvgMonthlySpec_Long.csv"))
unique(ii$Species)

jj <- read_csv(here::here("data", "RushiTesting", "speciesData","BOF_Proposals.csv"))
unique(jj$Species)

kk <- read_csv(here::here("data", "RushiTesting", "speciesData","catchEstimates_1996_2016.csv"))
unique(kk$species)
# harvestEstimates_1996_2016.csv
# catchEstimates_1996_2016.csv

ll <- read_csv(here::here("data", "RushiTesting", "speciesData","CommunitySubsistenceInformationSystem.csv"))
unique(ll$Resource)

mm <- read_csv(here::here("data", "RushiTesting", "speciesData","AreaByYear.csv"))
unique(mm$Species)
# DistrictByYear_SASAPRegion.csv
# Daily.csv
# StatWeekByArea.csv
# StatAreaByYear.csv
# AreaByYear.csv

nn <- read_csv(here::here("data", "RushiTesting", "speciesData","knb.92053.1.csv"))
unique(nn$Species)

oo <- read_csv(here::here("data", "RushiTesting", "speciesData","ADFG_Salmon_Escapement_First_Attempt.csv"))
unique(oo$Species)
# ADFG_Salmon_Escapement_First_Attempt.csv
# ADFG_firstAttempt_reformatted.csv

pp <- read_csv(here::here("data", "RushiTesting", "speciesData","2015.csv"))
unique(pp$species_code)
# ASL_bristol_bay_full.csv
# 2010.csv: 410, 450, 420
# 2012.csv
# 2013.csv
# 2014.csv
# 2015.csv







