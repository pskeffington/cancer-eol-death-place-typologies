# 00_combine_cdc_wonder_batches.R
# Purpose: combine CDC WONDER two-batch tab-delimited exports into the
# canonical raw file expected by Object 02.

source("analysis/00_setup.R")

input_files <- c(
  here::here("data", "raw", "cdc_wonder_mcd_cancer_65plus_county_year_place_2018_2020.txt"),
  here::here("data", "raw", "cdc_wonder_mcd_cancer_65plus_county_year_place_2021_2024.txt")
)

output_file <- here::here(
  "data",
  "raw",
  "cdc_wonder_mcd_cancer_65plus_county_year_place_2018_2024.txt"
)

find_table_lines <- function(path) {
  if (!file.exists(path)) {
    stop(paste0("Missing CDC WONDER batch file: ", path), call. = FALSE)
  }

  lines <- readr::read_lines(path)

  header_index <- which(
    stringr::str_detect(lines, "County") &
      stringr::str_detect(lines, "Year") &
      stringr::str_detect(lines, "Place of Death") &
      stringr::str_detect(lines, "Deaths")
  )[1]

  if (is.na(header_index)) {
    stop(paste0("Could not find CDC WONDER table header in: ", path), call. = FALSE)
  }

  table_lines <- lines[header_index:length(lines)]
  tab_count <- stringr::str_count(table_lines[1], "\t")

  table_lines[
    stringr::str_count(table_lines, "\t") == tab_count &
      !stringr::str_detect(table_lines, "^---")
  ]
}

table_blocks <- purrr::map(input_files, find_table_lines)

header <- table_blocks[[1]][1]
body <- purrr::map(table_blocks, ~ .x[-1]) |>
  unlist(use.names = FALSE)

combined <- c(header, body)

readr::write_lines(combined, output_file)

message("Combined ", length(input_files), " CDC WONDER batch files.")
message("Wrote canonical raw file: ", output_file)
