# Phase 1: Data Understanding & Initial ETL 

# List of required packages
packages <- c("readr", "tidyverse", "dplyr", "lubridate")

# Install only packages that are not already installed
installed_packages <- rownames(installed.packages())
for (pkg in packages) {
  if (!(pkg %in% installed_packages)) {
    install.packages(pkg)
  }
}

# Load the necessary libraries
library(readr)
library(tidyverse)
library(dplyr)
library(lubridate)

# --------------------------------------------------------------------------------
data_path_prefix <- "F:/R_Track/Modual_6/data/"
start_date_filter <- lubridate::ymd("2009-01-01")
end_date_filter <- lubridate::ymd("2025-12-31")

# Step 2: Set file paths
data_folder <- "F:/R_Track/Modual_6/data/"
clean_folder <- "F:/R_Track/Modual_6/clean/"
dir.create(clean_folder, showWarnings = FALSE)

# Step 3: Mapping of old filenames to new table names
file_rename_map <- list(
  "de-dispo-age.csv" = "job_seeker_by_age.csv",
  "de-flux.csv" = "job_seeker_flows.csv",
  "de-nationalite.csv" = "job_seeker_nationalities.csv",
  "de-metier.csv" = "job_seeker_professions.csv",
  "de-dispo-profils.csv" = "job_seeker_profiles.csv",
  "offres-details.csv" = "job_vacancy_details.csv",
  "offres-series.csv" = "monthly_vacancy_summary.csv",
  "de-indemnites.csv" = "unemployment_benefits.csv",
  "de-jeunes.csv" = "youth_job_seekers.csv",
  "de-mesures.csv" = "employment_measures.csv",
  "datasc-skills-vacancies.csv" = "datascience_skills_vacancies.csv"
)

# Step 4: Read, clean, and save each file with new names
for (old_name in names(file_rename_map)) {
  path <- file.path(data_folder, old_name)
  df <- read_csv2(path)
  
  if ("Date" %in% names(df)) {
    df$Date <- dmy(df$Date)
  }
  
  new_name <- file_rename_map[[old_name]]
  write_csv(df, file.path(clean_folder, new_name))
  message(paste("Cleaned and saved:", new_name))
}

# Done
print("All files cleaned, renamed, and saved.")