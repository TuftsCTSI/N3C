library(DatabaseConnector)
library(readr)
library(magrittr)
library(dplyr)
library(stringr)

connectionDetails <- DatabaseConnector::createConnectionDetails(
  dbms = "sql server",  # options: oracle, postgressql, redshift, sql server, pdw, netezza, bigquery, sqlite
  pathToDriver = "C:\\R\\",
  server = keyring::key_get("legacy-cdm-server"), # name of the server
  user = keyring::key_get("legacy-cdm-username"), # username to access server
  password = key_get("legacy-cdm-password") #password for that user
)

conn = DatabaseConnector::connect(connectionDetails)

full_person <- DatabaseConnector::querySql(conn, "SELECT * FROM TMC_RED.dbo.PERSON")
full_person_ext <- DatabaseConnector::querySql(conn, "SELECT * FROM TMC_RED.dbo.PERSON_EXT")
location <- DatabaseConnector::querySql(conn, "SELECT * FROM TMC_RED.dbo.LOCATION")

DatabaseConnector::disconnect(conn)

n3c_person <- read_delim(paste0(keyring::key_get("n3c-folder"), 'output/DATAFILES/PERSON.csv'), delim = "|")

full_n3c <- n3c_person %>%
  left_join(y = full_person %>% select(PERSON_ID, BIRTH_DATETIME), by = "PERSON_ID") %>% 
  left_join(y = full_person_ext, by = "PERSON_ID") %>% 
  left_join(y = location, by = "LOCATION_ID") %>%
  mutate(
    Gender = if_else(GENDER_CONCEPT_ID == '8532', 'Female', if_else(GENDER_CONCEPT_ID == '8507', 'Male', 'Unknown')),
    `Date of Birth` = format(BIRTH_DATETIME, "%Y/%m/%d"),
    SSN = NA_character_,
    Email = if_else(str_detect(EMAIL, "@"), str_remove(EMAIL, "mailto:"), NA_character_),
    Cellphone = if_else(!is.na(HOME_PHONE), HOME_PHONE, WORK_PHONE),
    Cellphone = str_remove_all(Cellphone, "\\D")
  ) %>% 
  select(
    record_ID = PERSON_ID,
    `First Name` = FIRST_NAME,
    `Last Name` = LAST_NAME,
    `Date of Birth`,
    Gender,
    SSN,
    ZIP,
    Email,
    Cellphone)

full_n3c %>% write_delim(paste0(keyring::key_get("n3c-folder"), 'datavant/input.csv'), delim = "|")

