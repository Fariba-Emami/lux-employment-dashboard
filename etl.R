# ---------------------------
# Phase 1: Data Understanding & Initial ETL with UTF-8 Fix & PostgreSQL Upload
# ---------------------------

# ---------------------------
# Step 1: Install & Load Packages
# ---------------------------
required_packages <- c("readr", "tidyverse", "dplyr", "lubridate", "DBI", "RPostgres", "stringr")
installed_packages <- rownames(installed.packages())
to_install <- setdiff(required_packages, installed_packages)
if (length(to_install) > 0) install.packages(to_install)
lapply(required_packages, library, character.only = TRUE)

# ---------------------------
# Step 2: Define File Paths
# ---------------------------
data_path_prefix <- "F:/R_Track/Modual_6/data/"
data_folder <- data_path_prefix
clean_folder <- "F:/R_Track/Modual_6/clean/"
dir.create(clean_folder, showWarnings = FALSE, recursive = TRUE)

# Optional date filters
start_date_filter <- lubridate::ymd("2009-01-01")
end_date_filter <- lubridate::ymd("2025-12-31")

# ---------------------------
# Step 3: Define File Rename Map
# ---------------------------
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

# ---------------------------
# Step 4: Function to Fix Encoding (to UTF-8)
# ---------------------------
fix_encoding <- function(df) {
  char_cols <- sapply(df, is.character)
  df[char_cols] <- lapply(df[char_cols], function(col) {
    col <- as.character(col)
    iconv(col, from = "", to = "UTF-8", sub = "")
  })
  return(df)
}

# ---------------------------
# Step 5: Database connection function
# ---------------------------
get_db_connection <- function() {
  con <- dbConnect(
    RPostgres::Postgres(),
    dbname = Sys.getenv("PG_DB"),
    host = Sys.getenv("PG_HOST"),
    port = as.integer(Sys.getenv("PG_PORT")),
    user = Sys.getenv("PG_USER"),
    password = Sys.getenv("PG_PASSWORD")
  )
  return(con)
}

# ---------------------------
# Step 6: Function to upload dataframe to PostgreSQL
# ---------------------------
upload_df_to_db <- function(df, new_name) {
  table_name <- tools::file_path_sans_ext(new_name)
  con <- get_db_connection()
  
  tryCatch({
    # Upload: overwrite table if exists
    dbWriteTable(con, name = DBI::Id(schema = Sys.getenv("PG_SCHEMA"), table = table_name), 
                 value = df, overwrite = TRUE, row.names = FALSE)
    message(paste("📤 Uploaded table to DB:", table_name))
  }, error = function(e) {
    warning(paste("❌ Failed to upload table:", table_name, "->", e$message))
  })
  
  dbDisconnect(con)
}

# ---------------------------
# Step 7: Read, Clean, Fix Encoding, Save & Upload Files
# ---------------------------
for (old_name in names(file_rename_map)) {
  path <- file.path(data_folder, old_name)
  
  if (!file.exists(path)) {
    warning(paste("❌ File not found:", path))
    next
  }
  
  # Read CSV (semicolon-delimited, UTF-8)
  df <- tryCatch({
    read_csv2(path, locale = locale(encoding = "UTF-8"))
  }, error = function(e) {
    warning(paste("❌ Error reading:", path, "-", e$message))
    return(NULL)
  })
  
  if (is.null(df)) next
  
  # Convert "Date" column if present
  if ("Date" %in% names(df)) {
    raw_dates <- df$Date
    df$Date <- suppressWarnings(lubridate::dmy(raw_dates))
    if (sum(is.na(df$Date)) > 0.9 * length(df$Date)) {
      df$Date <- suppressWarnings(lubridate::ymd(raw_dates))
    }
    if (sum(is.na(df$Date)) > 0.9 * length(df$Date)) {
      df$Date <- suppressWarnings(lubridate::mdy(raw_dates))
    }
    na_count <- sum(is.na(df$Date))
    message(paste("📅 Date parsing for", old_name, "→", na_count, "NAs"))
    
    # Optional: filter by date range
    # df <- df %>% filter(Date >= start_date_filter & Date <= end_date_filter)
  }
  
  # Fix encoding
  df <- fix_encoding(df)
  
  # Save cleaned CSV
  new_name <- file_rename_map[[old_name]]
  write_csv(df, file.path(clean_folder, new_name))
  message(paste("✅ Cleaned and saved:", new_name))
  
  # Upload to PostgreSQL
  upload_df_to_db(df, new_name)
}

# ---------------------------
# Done
# ---------------------------
message("🎉 All files processed, cleaned, saved, and uploaded successfully.")
