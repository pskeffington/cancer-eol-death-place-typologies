# 00_setup.R
# Purpose: project setup and package loading for cancer end-of-life death-place typology analysis.

required_packages <- c(
  "tidyverse",
  "janitor",
  "readr",
  "readxl",
  "stringr",
  "lubridate",
  "sf",
  "tigris",
  "tidycensus",
  "broom",
  "sandwich",
  "lmtest",
  "nnet",
  "cluster",
  "factoextra",
  "here"
)

install_missing <- function(packages) {
  missing <- packages[!packages %in% rownames(installed.packages())]
  if (length(missing) > 0) {
    install.packages(missing)
  }
}

load_packages <- function(packages) {
  invisible(lapply(packages, library, character.only = TRUE))
}

install_missing(required_packages)
load_packages(required_packages)

options(tigris_use_cache = TRUE)

project_dirs <- c(
  "data/raw",
  "data/processed",
  "data/crosswalks",
  "docs",
  "figures",
  "manuscript",
  "outputs",
  "tables"
)

invisible(lapply(project_dirs, dir.create, recursive = TRUE, showWarnings = FALSE))

message("Project setup complete.")
