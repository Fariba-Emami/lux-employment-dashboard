#Phase 1: Data Understanding & Initial ETL 

# List of required packages
packages <- c("readr", "tidyverse", "dplyr", "lubridate")




# Install only packages that are not already installed
installed_packages <- rownames(installed.packages())
for (pkg in packages) {
  if (!(pkg %in% installed_packages)) {
    install.packages(pkg)
  }
}

# the necessary library

library(readr)
library(tidyverse)
library(dplyr)
library(lubridate)




# --------------------------------------------------------------------------------
data_path_prefix <- "F:/R_Track/Modual_6/data/"
start_date_filter <- lubridate::ymd("2009-01-01")
end_date_filter <- lubridate::ymd("2025-12-31")


# Phase 1: Data Understanding & Initial ETL

# # ----  Key Datasets ----
# 
# # 1. Residency Flows
# job_seeker_residency_flows <- read_csv2("F:/R_Track/Modual_6/data/de-flux.csv")
# 
# cleaned_residency_flows <- job_seeker_residency_flows %>%
#   rename(
#     RecordDate = Date,
#     ResidencyType = Residence,
#     Openings = Ouvertures,
#     Closings = Clotures
#   ) %>%
#   mutate(
#     RecordDate = dmy(RecordDate)  # Day-Month-Year
#   )
# 
# print(head(cleaned_residency_flows))
# 
# # ---- Step 3: Load Other Datasets (Initial Loading Only) ----
# 
# # 2. Age of job seekers
# job_seeker_age <- read_csv2("F:/R_Track/Modual_6/data/de-dispo-age.csv")
# 
# # 3. Duration of registration
# job_seeker_registration_duration <- read_csv2("F:/R_Track/Modual_6/data/de-age-duree.csv")
# 
# # 4. Data science skills in vacancies
# datasci_skills_vacancies <- read_csv2("F:/R_Track/Modual_6/data/datasc-skills-vacancies.csv")
# 
# # 5. Job seekers by municipality
# job_seeker_by_commune <- read_csv2("F:/R_Track/Modual_6/data/de-dispo-commune.csv")
# 
# # 6. Job seekers by education profile
# job_seeker_by_profile <- read_csv2("F:/R_Track/Modual_6/data/de-dispo-profils.csv")
# 
# # 7. Unemployment benefits
# unemployment_benefits <- read_csv2("F:/R_Track/Modual_6/data/de-indemnites.csv")
# 
# # 8. Youth job seekers
# youth_job_seekers <- read_csv2("F:/R_Track/Modual_6/data/de-jeunes.csv")
# 
# # 9. Employment measures
# employment_measures <- read_csv2("F:/R_Track/Modual_6/data/de-mesures.csv")
# 
# # 10. Desired professions
# desired_professions <- read_csv2("F:/R_Track/Modual_6/data/de-metier.csv")
# 
# # 11. Job seekers by nationality
# job_seeker_by_nationality <- read_csv2("F:/R_Track/Modual_6/data/de-nationalite.csv")
# 
# # 12. Vacancy details
# vacancy_details <- read_csv2("F:/R_Track/Modual_6/data/offres-details.csv")
# 
# # 13. Monthly vacancy time series
# monthly_vacancies <- read_csv2("F:/R_Track/Modual_6/data/offres-series.csv")
# 
# # ---- Step 4: Save Cleaned Example ----
# 
# # Save cleaned data for testing
# dir.create("F:/R_Track/Modual_6/clean", recursive = TRUE, showWarnings = FALSE)
# write_csv(cleaned_residency_flows, "F:/R_Track/Modual_6/clean/cleaned_residency_flows.csv")
# 
# 
# 




# Step 2: Set file paths
data_folder <- "F:/R_Track/Modual_6/data/"
clean_folder <- "F:/R_Track/Modual_6/clean/"
dir.create(clean_folder, showWarnings = FALSE)

# Step 3: List of files to clean
file_names <- c(
  "de-flux.csv",
  "de-dispo-age.csv",
  "de-age-duree.csv",
  "datasc-skills-vacancies.csv",
  "de-dispo-commune.csv",
  "de-dispo-profils.csv",
  "de-indemnites.csv",
  "de-jeunes.csv",
  "de-mesures.csv",
  "de-metier.csv",
  "de-nationalite.csv",
  "offres-details.csv",
  "offres-series.csv"
)

# Step 4: Read, clean, and save each file
for (file in file_names) {
  path <- paste0(data_folder, file)
  df <- read_csv2(path)
  
  if ("Date" %in% names(df)) {
    df$Date <- dmy(df$Date)
  }
  
  write_csv(df, paste0(clean_folder, "cleaned_", file))
}

# Done
print("All files cleaned and saved.")




