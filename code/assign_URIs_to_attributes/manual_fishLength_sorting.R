library(tidyverse)

attributes <- read_csv(here::here("data", "sorted_attributes", "SASAP_attributes_sorted.csv"))

#---------------- doi:10.5063/F1542KVC : ENTITY-LEVEL ANNOTATIONS

HighSeas_tag_recovery_database <- read_csv(here::here("data", "sorted_attributes", "manual_fish_length_assignments", "SASAP_length_data", "HighSeas_tag_recovery_database.csv"))
unique(HighSeas_tag_recovery_database$Species)

#---------------- doi:10.5063/F15T3HRG : ENTITY-LEVEL ANNOTATIONS

ASL_formatted_BristolBay <- read_csv(here::here("data", "sorted_attributes", "manual_fish_length_assignments", "SASAP_length_data", "ASL_formatted_BristolBay.csv"))
unique(ASL_formatted_BristolBay$Species)
unique(ASL_formatted_BristolBay$Sex)
unique(ASL_formatted_BristolBay$Length.Measurement.Type)
unique(ASL_formatted_BristolBay$Location)

#---------------- doi:10.5063/F15T3HRG : no entity-level annotations

ASL_unformatted_BristolBay <- read_csv(here::here("data", "sorted_attributes", "manual_fish_length_assignments", "SASAP_length_data", "ASL_unformatted_BristolBay.csv"))
unique(ASL_unformatted_BristolBay$LengthType)
unique(ASL_unformatted_BristolBay$Type_of_length_measurement)
 
#---------------- doi:10.5063/F18K77BT : ENTITY-LEVEL ANNOTATIONS

ASL_formatted_EastSideChinook <- read_csv(here::here("data", "sorted_attributes", "manual_fish_length_assignments", "SASAP_length_data", "ASL_formatted_EastSideChinook.csv"))
unique(ASL_formatted_EastSideChinook$Species)
unique(ASL_formatted_EastSideChinook$Sex)
unique(ASL_formatted_EastSideChinook$SASAP.Region)
unique(ASL_formatted_EastSideChinook$Length.Measurement.Type)
unique(ASL_formatted_EastSideChinook$Location)
unique(ASL_formatted_EastSideChinook$Gear)
unique(ASL_formatted_EastSideChinook$ASLProjectType)

#---------------- doi:10.5063/F11R6NSS : ENTITY-LEVEL ANNOTATIONS

ASL_formatted_SoutheastSupplement <- read_csv(here::here("data", "sorted_attributes", "manual_fish_length_assignments", "SASAP_length_data", "ASL_formatted_SoutheastSupplement.csv"),
                                              col_names = TRUE, col_types = cols(.default = col_character()))
unique(ASL_formatted_SoutheastSupplement$Species)
unique(ASL_formatted_SoutheastSupplement$Location)
unique(ASL_formatted_SoutheastSupplement$SASAP.Region)
unique(ASL_formatted_SoutheastSupplement$ASLProjectType)

#---------------- doi:10.5063/F12N50JP (parsing failure) : no entity-level annotations

HR002286 <- read_csv(here::here("data", "sorted_attributes", "manual_fish_length_assignments", "SASAP_length_data", "HR002286.csv"), col_names = TRUE, col_types = cols(.default = col_character()))

#---------------- doi:10.5063/F12N50JP : ENTITY-LEVEL ANNOTATIONS

Hatchery_releases <- read_csv(here::here("data", "sorted_attributes", "manual_fish_length_assignments", "SASAP_length_data", "Hatchery_releases.csv"), col_names = TRUE, col_types = cols(.default = col_character()))
unique(Hatchery_releases$SASAPRegion)
unique(Hatchery_releases$Species)
unique(Hatchery_releases$Stage)

#---------------- doi:10.5063/F1ZW1J77 : ENTITY-LEVEL ANNOTATIONS

sockeye_scale_data <- read_csv(here::here("data", "sorted_attributes", "manual_fish_length_assignments", "SASAP_length_data", "sockeye_scale_data.csv"), col_names = TRUE, col_types = cols(.default = col_character()))
unique(sockeye_scale_data$location)
unique(sockeye_scale_data$sex)

#---------------- doi:10.5063/F1FF3QMV : ENTITY-LEVEL ANNOTATIONS

PWS_CopperRiver <- read_csv(here::here("data", "sorted_attributes", "manual_fish_length_assignments", "SASAP_length_data", "PWS_CopperRiver.csv"), col_names = TRUE, col_types = cols(.default = col_character()))
unique(PWS_CopperRiver$area)
unique(PWS_CopperRiver$location_name)
unique(PWS_CopperRiver$species)
unique(PWS_CopperRiver$sex)
unique(PWS_CopperRiver$project_type)
unique(PWS_CopperRiver$gear)
unique(PWS_CopperRiver$length_measurement_type)

#---------------- doi:10.5063/F1K64GBK : ENTITY-LEVEL ANNOTATIONS

ASL_formatted_Kotzebue <- read_csv(here::here("data", "sorted_attributes", "manual_fish_length_assignments", "SASAP_length_data", "ASL_formatted_Kotzebue.csv"), col_names = TRUE, col_types = cols(.default = col_character()))
unique(ASL_formatted_Kotzebue$District)
unique(ASL_formatted_Kotzebue$Location)
unique(ASL_formatted_Kotzebue$ASLProjectType)
unique(ASL_formatted_Kotzebue$Gear)
unique(ASL_formatted_Kotzebue$Species)
unique(ASL_formatted_Kotzebue$Sex)
unique(ASL_formatted_Kotzebue$Length.Measurement.Type)
unique(ASL_formatted_Kotzebue$SASAP.Region)

#---------------- doi:10.5063/F1K64GBK : ENTITY-LEVEL ANNOTATIONS

ASL_formatted_Kuskokwim <- read_csv(here::here("data", "sorted_attributes", "manual_fish_length_assignments", "SASAP_length_data", "ASL_formatted_Kuskokwim.csv"), col_names = TRUE, col_types = cols(.default = col_character()))
unique(ASL_formatted_Kuskokwim$District)
unique(ASL_formatted_Kuskokwim$Location)
unique(ASL_formatted_Kuskokwim$ASLProjectType)
unique(ASL_formatted_Kuskokwim$Gear)
unique(ASL_formatted_Kuskokwim$Species)
unique(ASL_formatted_Kuskokwim$Sex)
unique(ASL_formatted_Kuskokwim$Length.Measurement.Type)
unique(ASL_formatted_Kuskokwim$SASAP.Region)

#---------------- doi:10.5063/F1K64GBK : ENTITY-LEVEL ANNOTATIONS

ASL_formatted_NorthernArea <- read_csv(here::here("data", "sorted_attributes", "manual_fish_length_assignments", "SASAP_length_data", "ASL_formatted_NorthernArea.csv"), col_names = TRUE, col_types = cols(.default = col_character()))
unique(ASL_formatted_NorthernArea$SASAP.Region)
unique(ASL_formatted_NorthernArea$Location)
unique(ASL_formatted_NorthernArea$ASLProjectType)
unique(ASL_formatted_NorthernArea$Gear)
unique(ASL_formatted_NorthernArea$Species)
unique(ASL_formatted_NorthernArea$Sex)
unique(ASL_formatted_NorthernArea$Length.Measurement.Type)

#---------------- doi:10.5063/F1K64GBK : ENTITY-LEVEL ANNOTATIONS

ASL_formatted_NortonSound <- read_csv(here::here("data", "sorted_attributes", "manual_fish_length_assignments", "SASAP_length_data", "ASL_formatted_NortonSound.csv"), col_names = TRUE, col_types = cols(.default = col_character()))
unique(ASL_formatted_NortonSound$Location)
unique(ASL_formatted_NortonSound$ASLProjectType)
unique(ASL_formatted_NortonSound$Gear)
unique(ASL_formatted_NortonSound$Species)
unique(ASL_formatted_NortonSound$Sex)
unique(ASL_formatted_NortonSound$Length.Measurement.Type)
unique(ASL_formatted_NortonSound$SASAP.Region)

#---------------- doi:10.5063/F1K64GBK : ENTITY-LEVEL ANNOTATIONS

ASL_formatted_Yukon <- read_csv(here::here("data", "sorted_attributes", "manual_fish_length_assignments", "SASAP_length_data", "ASL_formatted_Yukon.csv"), col_names = TRUE, col_types = cols(.default = col_character()))
unique(ASL_formatted_Yukon$Location)
unique(ASL_formatted_Yukon$ASLProjectType)
unique(ASL_formatted_Yukon$Gear)
unique(ASL_formatted_Yukon$Species)
unique(ASL_formatted_Yukon$Sex)
unique(ASL_formatted_Yukon$Length.Measurement.Type)
unique(ASL_formatted_Yukon$SASAP.Region)

#---------------- doi:10.5063/F1K64GBK : ENTITY-LEVEL ANNOTATIONS

ASL_formatted_YukonCanada <- read_csv(here::here("data", "sorted_attributes", "manual_fish_length_assignments", "SASAP_length_data", "ASL_formatted_YukonCanada.csv"), col_names = TRUE, col_types = cols(.default = col_character()))
unique(ASL_formatted_YukonCanada$Location)
unique(ASL_formatted_YukonCanada$ASLProjectType)
unique(ASL_formatted_YukonCanada$Gear)
unique(ASL_formatted_YukonCanada$Species)
unique(ASL_formatted_YukonCanada$Sex)
unique(ASL_formatted_YukonCanada$Length.Measurement.Type)
unique(ASL_formatted_YukonCanada$SASAP.Region)

#---------------- doi:10.5063/F1K64GBK : ENTITY-LEVEL ANNOTATIONS

YukonCanada_ASL <- read_csv(here::here("data", "sorted_attributes", "manual_fish_length_assignments", "SASAP_length_data", "YukonCanada_ASL.csv"), col_names = TRUE, col_types = cols(.default = col_character()))
unique(YukonCanada_ASLL$location)
unique(YukonCanada_ASL$ASLProjectType)
unique(YukonCanada_ASL$gear)
unique(YukonCanada_ASL$species)
unique(YukonCanada_ASL$sex)
unique(YukonCanada_ASL$lengthMeasurementType)

#---------------- doi:10.5063/F1K64GBK : ENTITY-LEVEL ANNOTATIONS

Yukon_ASL <- read_csv(here::here("data", "sorted_attributes", "manual_fish_length_assignments", "SASAP_length_data", "Yukon_ASL.csv"), col_names = TRUE, col_types = cols(.default = col_character()))
unique(Yukon_ASL$location)
unique(Yukon_ASL$ASLProjectType)
unique(Yukon_ASL$gear)
unique(Yukon_ASL$species)
unique(Yukon_ASL$sex)
unique(Yukon_ASL$lengthMeasurementType)

#---------------- doi:10.5063/F1K64GBK : ENTITY-LEVEL ANNOTATIONS

NortonSound_ASL <- read_csv(here::here("data", "sorted_attributes", "manual_fish_length_assignments", "SASAP_length_data", "NortonSound_ASL.csv"), col_names = TRUE, col_types = cols(.default = col_character()))
unique(NortonSound_ASL$ASLProjectType)
unique(NortonSound_ASL$gear)
unique(NortonSound_ASL$species)
unique(NortonSound_ASL$sex)
unique(NortonSound_ASL$lengthMeasurementType)

#---------------- doi:10.5063/F1K64GBK : ENTITY-LEVEL ANNOTATIONS

NorthernArea_ASL <- read_csv(here::here("data", "sorted_attributes", "manual_fish_length_assignments", "SASAP_length_data", "NorthernArea_ASL.csv"), col_names = TRUE, col_types = cols(.default = col_character()))
unique(NorthernArea_ASL$ASLProjectType)
unique(NorthernArea_ASL$gear)
unique(NorthernArea_ASL$species)
unique(NorthernArea_ASL$sex)
unique(NorthernArea_ASL$lengthMeasurementType)

#---------------- doi:10.5063/F1K64GBK : ENTITY-LEVEL ANNOTATIONS

Kuskokwim_ASL <- read_csv(here::here("data", "sorted_attributes", "manual_fish_length_assignments", "SASAP_length_data", "Kuskokwim_ASL.csv"), col_names = TRUE, col_types = cols(.default = col_character()))
unique(Kuskokwim_ASL$ASLProjectType)
unique(Kuskokwim_ASL$gear)
unique(Kuskokwim_ASL$species)
unique(Kuskokwim_ASL$sex)
unique(Kuskokwim_ASL$lengthMeasurementType)
  
#---------------- doi:10.5063/F1K64GBK : ENTITY-LEVEL ANNOTATIONS

Kotzebue_ASL <- read_csv(here::here("data", "sorted_attributes", "manual_fish_length_assignments", "SASAP_length_data", "Kotzebue_ASL.csv"), col_names = TRUE, col_types = cols(.default = col_character()))
unique(Kotzebue_ASL$ASLProjectType)
unique(Kotzebue_ASL$gear)
unique(Kotzebue_ASL$species)
unique(Kotzebue_ASL$sex)
unique(Kotzebue_ASL$lengthMeasurementType)

#---------------- doi:10.5063/F1NV9GHW : ENTITY-LEVEL ANNOTATIONS

ASL_formatted_LowerCookInlet <- read_csv(here::here("data", "sorted_attributes", "manual_fish_length_assignments", "SASAP_length_data", "ASL_formatted_LowerCookInlet.csv"), col_names = TRUE, col_types = cols(.default = col_character()))
unique(ASL_formatted_LowerCookInlet$Species)
unique(ASL_formatted_LowerCookInlet$Sex)
unique(ASL_formatted_LowerCookInlet$Gear)
unique(ASL_formatted_LowerCookInlet$Length.Measurement.Type)
unique(ASL_formatted_LowerCookInlet$ASLProjectType)
unique(ASL_formatted_LowerCookInlet$SASAP.Region)

#---------------- doi:10.5063/F1PR7T8D : ENTITY-LEVEL ANNOTATIONS

ASL_formatted_PrinceWilliamSoundpinks <- read_csv(here::here("data", "sorted_attributes", "manual_fish_length_assignments", "SASAP_length_data", "ASL_formatted_PrinceWilliamSoundpinks.csv"), col_names = TRUE, col_types = cols(.default = col_character()))
unique(ASL_formatted_PrinceWilliamSoundpinks$ASLProjectType)
unique(ASL_formatted_PrinceWilliamSoundpinks$SASAP.Region)
unique(ASL_formatted_PrinceWilliamSoundpinks$Sex)
unique(ASL_formatted_PrinceWilliamSoundpinks$Length.Measurement.Type)
unique(ASL_formatted_PrinceWilliamSoundpinks$Species)

#---------------- doi:10.5063/F1W957GP : ENTITY-LEVEL ANNOTATIONS

ASL_bristol_bay_full <- read_csv(here::here("data", "sorted_attributes", "manual_fish_length_assignments", "SASAP_length_data", "ASL_bristol_bay_full.csv"), col_names = TRUE, col_types = cols(.default = col_character()))
unique(ASL_bristol_bay_full$Species)
unique(ASL_bristol_bay_full$ASLProjectType)
unique(ASL_bristol_bay_full$Gear)
unique(ASL_bristol_bay_full$Sex)
unique(ASL_bristol_bay_full$Length.Measurement.Type)
unique(ASL_bristol_bay_full$SASAP.Region)

#---------------- doi:10.5063/F1W957GP

dat2010 <- read_csv(here::here("data", "sorted_attributes", "manual_fish_length_assignments", "SASAP_length_data", "2010.csv"), col_names = TRUE, col_types = cols(.default = col_character()))
unique(dat2010$length_type)
unique(dat2010$species_code)

#---------------- doi:10.5063/F1W957GP

dat2011 <- read_csv(here::here("data", "sorted_attributes", "manual_fish_length_assignments", "SASAP_length_data", "2011.csv"), col_names = TRUE, col_types = cols(.default = col_character()))
unique(dat2011$length_type)

#---------------- doi:10.5063/F1W957GP

dat2012 <- read_csv(here::here("data", "sorted_attributes", "manual_fish_length_assignments", "SASAP_length_data", "2012.csv"), col_names = TRUE, col_types = cols(.default = col_character()))
unique(dat2012$length_type)

#---------------- doi:10.5063/F1W957GP

dat2013 <- read_csv(here::here("data", "sorted_attributes", "manual_fish_length_assignments", "SASAP_length_data", "2013.csv"), col_names = TRUE, col_types = cols(.default = col_character()))
unique(dat2013$length_type)

#---------------- doi:10.5063/F1W957GP

dat2014 <- read_csv(here::here("data", "sorted_attributes", "manual_fish_length_assignments", "SASAP_length_data", "2014.csv"), col_names = TRUE, col_types = cols(.default = col_character()))
unique(dat2014$length_type)

#---------------- doi:10.5063/F1W957GP

dat2015 <- read_csv(here::here("data", "sorted_attributes", "manual_fish_length_assignments", "SASAP_length_data", "2015.csv"), col_names = TRUE, col_types = cols(.default = col_character()))
unique(dat2015$length_type)

# ---------------- doi:10.5063/F1GB22B9
sportfish <- read_csv(here::here("data", "sorted_attributes", "manual_fish_length_assignments", "SASAP_length_data", "SportFish.csv"), col_names = TRUE, col_types = cols(.default = col_character()))
unique(sportfish$Species)
