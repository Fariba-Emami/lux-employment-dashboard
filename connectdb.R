# Install packages if not done yet
install.packages("DBI")
install.packages("RPostgres")

# Load libraries
library(DBI)
library(RPostgres)

# Use .Renviron for credentials, example:
con <- dbConnect(
  RPostgres::Postgres(),
  dbname = Sys.getenv("PG_DB"),
  host = Sys.getenv("PG_HOST"),
  port = Sys.getenv("PG_PORT"),
  user = Sys.getenv("PG_USER"),
  password = Sys.getenv("PG_PASSWORD")
)
