library(tidyverse)

#---------------- doi:10.5063/F1542KVC

HighSeas_tag_recovery_database <- read_csv(here::here("data", "sorted_attributes", "manual_fish_length_assignments", "SASAP_length_data", "HighSeas_tag_recovery_database.csv"))

#---------------- doi:10.5063/F15T3HRG

ASL_formatted_BristolBay <- read_csv(here::here("data", "sorted_attributes", "manual_fish_length_assignments", "SASAP_length_data", "ASL_formatted_BristolBay.csv"))
unique(ASL_formatted_BristolBay$Length.Measurement.Type)

#---------------- doi:10.5063/F15T3HRG

ASL_unformatted_BristolBay <- read_csv(here::here("data", "sorted_attributes", "manual_fish_length_assignments", "SASAP_length_data", "ASL_unformatted_BristolBay.csv"))
unique(ASL_unformatted_BristolBay$LengthType)
unique(ASL_unformatted_BristolBay$Type_of_length_measurement)
 
#---------------- doi:10.5063/F18K77BT

ASL_formatted_EastSideChinook <- read_csv(here::here("data", "sorted_attributes", "manual_fish_length_assignments", "SASAP_length_data", "ASL_formatted_EastSideChinook.csv"))
unique(ASL_formatted_EastSideChinook$Length.Measurement.Type)

#---------------- doi:10.5063/F11R6NSS 

ASL_formatted_SoutheastSupplement <- read_csv(here::here("data", "sorted_attributes", "manual_fish_length_assignments", "SASAP_length_data", "ASL_formatted_SoutheastSupplement.csv"),
                                              col_names = TRUE, col_types = cols(.default = col_character()))


#---------------- doi:10.5063/F12N50JP (parsing failure)

HR002286 <- read_csv(here::here("data", "sorted_attributes", "manual_fish_length_assignments", "SASAP_length_data", "HR002286.csv"), col_names = TRUE, col_types = cols(.default = col_character()))

#---------------- doi:10.5063/F12N50JP

Hatchery_releases <- read_csv(here::here("data", "sorted_attributes", "manual_fish_length_assignments", "SASAP_length_data", "Hatchery_releases.csv"), col_names = TRUE, col_types = cols(.default = col_character()))

#---------------- doi:10.5063/F1ZW1J77

sockeye_scale_data <- read_csv(here::here("data", "sorted_attributes", "manual_fish_length_assignments", "SASAP_length_data", "sockeye_scale_data.csv"), col_names = TRUE, col_types = cols(.default = col_character()))


#---------------- doi:10.5063/F1FF3QMV

PWS_CopperRiver <- read_csv(here::here("data", "sorted_attributes", "manual_fish_length_assignments", "SASAP_length_data", "PWS_CopperRiver.csv"), col_names = TRUE, col_types = cols(.default = col_character()))
unique(PWS_CopperRiver$length_measurement_type)

#---------------- doi:10.5063/F1K64GBK

ASL_formatted_Kotzebue <- read_csv(here::here("data", "sorted_attributes", "manual_fish_length_assignments", "SASAP_length_data", "ASL_formatted_Kotzebue.csv"), col_names = TRUE, col_types = cols(.default = col_character()))
unique(ASL_formatted_Kotzebue$Length.Measurement.Type)

#---------------- doi:10.5063/F1K64GBK

ASL_formatted_Kuskokwim <- read_csv(here::here("data", "sorted_attributes", "manual_fish_length_assignments", "SASAP_length_data", "ASL_formatted_Kuskokwim.csv"), col_names = TRUE, col_types = cols(.default = col_character()))
unique(ASL_formatted_Kuskokwim$Length.Measurement.Type)

#---------------- doi:10.5063/F1K64GBK

ASL_formatted_NorthernArea <- read_csv(here::here("data", "sorted_attributes", "manual_fish_length_assignments", "SASAP_length_data", "ASL_formatted_NorthernArea.csv"), col_names = TRUE, col_types = cols(.default = col_character()))
unique(ASL_formatted_NorthernArea$Length.Measurement.Type)

#---------------- doi:10.5063/F1K64GBK

ASL_formatted_NortonSound <- read_csv(here::here("data", "sorted_attributes", "manual_fish_length_assignments", "SASAP_length_data", "ASL_formatted_NortonSound.csv"), col_names = TRUE, col_types = cols(.default = col_character()))
unique(ASL_formatted_NortonSound$Length.Measurement.Type)

#---------------- doi:10.5063/F1K64GBK

ASL_formatted_Yukon <- read_csv(here::here("data", "sorted_attributes", "manual_fish_length_assignments", "SASAP_length_data", "ASL_formatted_Yukon.csv"), col_names = TRUE, col_types = cols(.default = col_character()))
unique(ASL_formatted_Yukon$Length.Measurement.Type)

#---------------- doi:10.5063/F1K64GBK

ASL_formatted_YukonCanada <- read_csv(here::here("data", "sorted_attributes", "manual_fish_length_assignments", "SASAP_length_data", "ASL_formatted_YukonCanada.csv"), col_names = TRUE, col_types = cols(.default = col_character()))
unique(ASL_formatted_YukonCanada$Length.Measurement.Type)

#---------------- doi:10.5063/F1K64GBK

YukonCanada_ASL <- read_csv(here::here("data", "sorted_attributes", "manual_fish_length_assignments", "SASAP_length_data", "YukonCanada_ASL.csv"), col_names = TRUE, col_types = cols(.default = col_character()))
unique(YukonCanada_ASL$lengthMeasurementType)

#---------------- doi:10.5063/F1K64GBK

Yukon_ASL <- read_csv(here::here("data", "sorted_attributes", "manual_fish_length_assignments", "SASAP_length_data", "Yukon_ASL.csv"), col_names = TRUE, col_types = cols(.default = col_character()))
unique(Yukon_ASL$lengthMeasurementType)

#---------------- doi:10.5063/F1K64GBK

NortonSound_ASL <- read_csv(here::here("data", "sorted_attributes", "manual_fish_length_assignments", "SASAP_length_data", "NortonSound_ASL.csv"), col_names = TRUE, col_types = cols(.default = col_character()))
unique(NortonSound_ASL$lengthMeasurementType)

#---------------- doi:10.5063/F1K64GBK

NorthernArea_ASL <- read_csv(here::here("data", "sorted_attributes", "manual_fish_length_assignments", "SASAP_length_data", "NorthernArea_ASL.csv"), col_names = TRUE, col_types = cols(.default = col_character()))
unique(NorthernArea_ASL$lengthMeasurementType)

#---------------- doi:10.5063/F1K64GBK

Kuskokwim_ASL <- read_csv(here::here("data", "sorted_attributes", "manual_fish_length_assignments", "SASAP_length_data", "Kuskokwim_ASL.csv"), col_names = TRUE, col_types = cols(.default = col_character()))
unique(Kuskokwim_ASL$lengthMeasurementType)
  
#---------------- doi:10.5063/F1K64GBK

Kotzebue_ASL <- read_csv(here::here("data", "sorted_attributes", "manual_fish_length_assignments", "SASAP_length_data", "Kotzebue_ASL.csv"), col_names = TRUE, col_types = cols(.default = col_character()))
unique(Kotzebue_ASL$lengthMeasurementType)

#---------------- doi:10.5063/F1NV9GHW

ASL_formatted_LowerCookInlet <- read_csv(here::here("data", "sorted_attributes", "manual_fish_length_assignments", "SASAP_length_data", "ASL_formatted_LowerCookInlet.csv"), col_names = TRUE, col_types = cols(.default = col_character()))
unique(ASL_formatted_LowerCookInlet$Length.Measurement.Type)

#---------------- doi:10.5063/F1PR7T8D

ASL_formatted_PrinceWilliamSoundpinks <- read_csv(here::here("data", "sorted_attributes", "manual_fish_length_assignments", "SASAP_length_data", "ASL_formatted_PrinceWilliamSoundpinks.csv"), col_names = TRUE, col_types = cols(.default = col_character()))
unique(ASL_formatted_PrinceWilliamSoundpinks$Length.Measurement.Type)

#---------------- doi:10.5063/F1W957GP

ASL_bristol_bay_full <- read_csv(here::here("data", "sorted_attributes", "manual_fish_length_assignments", "SASAP_length_data", "ASL_bristol_bay_full.csv"), col_names = TRUE, col_types = cols(.default = col_character()))
unique(ASL_bristol_bay_full$Length.Measurement.Type)

#---------------- doi:10.5063/F1W957GP

dat2010 <- read_csv(here::here("data", "sorted_attributes", "manual_fish_length_assignments", "SASAP_length_data", "2010.csv"), col_names = TRUE, col_types = cols(.default = col_character()))
unique(dat2010$length_type)

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
