# 01_build_death_place_composition.R
# Purpose: transform raw CDC WONDER cancer mortality extract into county-year death-place composition file.

source("analysis/00_setup.R")

raw_file <- here::here(
  "data",
  "raw",
  "cdc_wonder_mcd_cancer_65plus_county_year_place_2018_2024.txt"
)

processed_file <- here::here(
  "data",
  "processed",
  "cancer_eol_death_place_composition_county_year.csv"
)

audit_file <- here::here(
  "outputs",
  "death_place_composition_audit.csv"
)

required_raw_fields <- c(
  "county",
  "county_code",
  "year",
  "place_of_death",
  "deaths"
)

standard_place_levels <- tibble::tribble(
  ~place_of_death_raw, ~place_group, ~count_variable,
  "Medical Facility - Inpatient", "hospital", "deaths_inpatient",
  "Medical Facility - Outpatient or ER", "hospital", "deaths_outpatient_er",
  "Medical Facility - Dead on Arrival", "hospital", "deaths_doa",
  "Decedent's home", "home", "deaths_home",
  "Hospice Facility", "hospice_facility", "deaths_hospice_facility",
  "Nursing home/long term care", "nursing_ltc", "deaths_nursing_ltc",
  "Other", "other_unknown", "deaths_other_unknown",
  "Place of death unknown", "other_unknown", "deaths_other_unknown"
)

assert_file_exists <- function(path) {
  if (!file.exists(path)) {
    stop(
      paste0(
        "Raw CDC WONDER extract not found: ", path, "\n",
        "Expected file: data/raw/cdc_wonder_mcd_cancer_65plus_county_year_place_2018_2024.txt\n",
        "Create this file using the extraction parameters in docs/cdc_wonder_extraction_notes.md."
      ),
      call. = FALSE
    )
  }
}

read_wonder_export <- function(path) {
  raw_lines <- readr::read_lines(path)

  header_line <- which(stringr::str_detect(raw_lines, "County") & stringr::str_detect(raw_lines, "Deaths"))[1]

  if (is.na(header_line)) {
    stop("Could not detect CDC WONDER tabular header. Confirm the export is tab-delimited and includes County and Deaths columns.", call. = FALSE)
  }

  tabular_text <- raw_lines[header_line:length(raw_lines)]

  # CDC WONDER appends footnotes after the table. Keep rows that preserve the table width.
  header_n_tabs <- stringr::str_count(tabular_text[1], "\t")
  tabular_text <- tabular_text[stringr::str_count(tabular_text, "\t") == header_n_tabs]

  readr::read_tsv(
    paste(tabular_text, collapse = "\n"),
    show_col_types = FALSE,
    na = c("", "NA", "Not Applicable", "Missing")
  ) |>
    janitor::clean_names()
}

normalize_raw_schema <- function(df) {
  # CDC WONDER column names vary depending on export options. This block keeps the script tolerant.
  aliases <- list(
    county = c("county", "residence_county"),
    county_code = c("county_code", "residence_county_code", "county_fips", "fips"),
    year = c("year", "year_code"),
    place_of_death = c("place_of_death"),
    deaths = c("deaths")
  )

  out <- df

  for (target in names(aliases)) {
    candidates <- aliases[[target]]
    hit <- candidates[candidates %in% names(out)][1]
    if (is.na(hit)) {
      stop(paste0("Missing required field after cleaning names: ", target), call. = FALSE)
    }
    if (hit != target) {
      out <- dplyr::rename(out, !!target := dplyr::all_of(hit))
    }
  }

  missing_fields <- setdiff(required_raw_fields, names(out))
  if (length(missing_fields) > 0) {
    stop(paste0("Missing required fields: ", paste(missing_fields, collapse = ", ")), call. = FALSE)
  }

  out
}

parse_deaths <- function(x) {
  x_chr <- as.character(x)
  suppressed <- stringr::str_detect(stringr::str_to_lower(x_chr), "suppressed|unreliable|missing")
  deaths_num <- readr::parse_number(x_chr, na = c("", "NA", "Not Applicable", "Missing", "Suppressed"))
  tibble::tibble(deaths = deaths_num, suppressed_cell = suppressed | is.na(deaths_num))
}

standardize_mortality <- function(df) {
  death_parse <- parse_deaths(df$deaths)

  df |>
    dplyr::mutate(
      county_name = as.character(.data$county),
      fips_county_full = stringr::str_pad(as.character(.data$county_code), width = 5, side = "left", pad = "0"),
      fips_state = stringr::str_sub(.data$fips_county_full, 1, 2),
      fips_county = stringr::str_sub(.data$fips_county_full, 3, 5),
      year = as.integer(.data$year),
      place_of_death_raw = as.character(.data$place_of_death)
    ) |>
    dplyr::bind_cols(death_parse) |>
    dplyr::left_join(standard_place_levels, by = "place_of_death_raw") |>
    dplyr::mutate(
      place_group = dplyr::coalesce(.data$place_group, "unmapped"),
      count_variable = dplyr::coalesce(.data$count_variable, "deaths_unmapped")
    ) |>
    dplyr::select(
      .data$fips_state,
      .data$fips_county,
      .data$fips_county_full,
      .data$county_name,
      .data$year,
      .data$place_of_death_raw,
      .data$place_group,
      .data$count_variable,
      .data$deaths,
      .data$suppressed_cell
    )
}

build_composition <- function(mortality_long) {
  composition_counts <- mortality_long |>
    dplyr::group_by(
      .data$fips_state,
      .data$fips_county,
      .data$fips_county_full,
      .data$county_name,
      .data$year,
      .data$count_variable
    ) |>
    dplyr::summarise(
      deaths = if (any(.data$suppressed_cell)) NA_real_ else sum(.data$deaths, na.rm = TRUE),
      suppressed_cell_count = sum(.data$suppressed_cell, na.rm = TRUE),
      .groups = "drop"
    ) |>
    tidyr::pivot_wider(
      names_from = .data$count_variable,
      values_from = .data$deaths,
      values_fill = 0
    )

  expected_count_vars <- c(
    "deaths_inpatient",
    "deaths_outpatient_er",
    "deaths_doa",
    "deaths_home",
    "deaths_hospice_facility",
    "deaths_nursing_ltc",
    "deaths_other_unknown",
    "deaths_unmapped"
  )

  for (v in expected_count_vars) {
    if (!v %in% names(composition_counts)) {
      composition_counts[[v]] <- 0
    }
  }

  suppression_summary <- mortality_long |>
    dplyr::group_by(.data$fips_county_full, .data$year) |>
    dplyr::summarise(
      suppressed_any = any(.data$suppressed_cell, na.rm = TRUE),
      suppressed_cell_count = sum(.data$suppressed_cell, na.rm = TRUE),
      unmapped_place_count = sum(.data$place_group == "unmapped", na.rm = TRUE),
      .groups = "drop"
    )

  composition_counts |>
    dplyr::left_join(suppression_summary, by = c("fips_county_full", "year")) |>
    dplyr::mutate(
      hospital_deaths_primary = .data$deaths_inpatient + .data$deaths_outpatient_er + .data$deaths_doa,
      hospital_deaths_excluding_doa = .data$deaths_inpatient + .data$deaths_outpatient_er,
      cancer_deaths_total_65plus = .data$hospital_deaths_primary +
        .data$deaths_home +
        .data$deaths_hospice_facility +
        .data$deaths_nursing_ltc +
        .data$deaths_other_unknown +
        .data$deaths_unmapped,
      low_count_flag = .data$cancer_deaths_total_65plus < 30,
      composition_complete = !.data$suppressed_any & .data$unmapped_place_count == 0,
      share_hospital = dplyr::if_else(.data$composition_complete & .data$cancer_deaths_total_65plus > 0,
                                      .data$hospital_deaths_primary / .data$cancer_deaths_total_65plus,
                                      NA_real_),
      share_hospital_excluding_doa = dplyr::if_else(.data$composition_complete & .data$cancer_deaths_total_65plus > 0,
                                                    .data$hospital_deaths_excluding_doa / .data$cancer_deaths_total_65plus,
                                                    NA_real_),
      share_home = dplyr::if_else(.data$composition_complete & .data$cancer_deaths_total_65plus > 0,
                                  .data$deaths_home / .data$cancer_deaths_total_65plus,
                                  NA_real_),
      share_hospice_facility = dplyr::if_else(.data$composition_complete & .data$cancer_deaths_total_65plus > 0,
                                              .data$deaths_hospice_facility / .data$cancer_deaths_total_65plus,
                                              NA_real_),
      share_nursing_ltc = dplyr::if_else(.data$composition_complete & .data$cancer_deaths_total_65plus > 0,
                                         .data$deaths_nursing_ltc / .data$cancer_deaths_total_65plus,
                                         NA_real_),
      share_other_unknown = dplyr::if_else(.data$composition_complete & .data$cancer_deaths_total_65plus > 0,
                                           (.data$deaths_other_unknown + .data$deaths_unmapped) / .data$cancer_deaths_total_65plus,
                                           NA_real_),
      share_sum_check = .data$share_hospital + .data$share_home + .data$share_hospice_facility + .data$share_nursing_ltc + .data$share_other_unknown,
      smoothing_method = "none"
    ) |>
    dplyr::arrange(.data$year, .data$fips_state, .data$fips_county)
}

build_audit <- function(mortality_long, composition) {
  tibble::tibble(
    audit_item = c(
      "raw_rows",
      "county_year_rows",
      "complete_county_year_rows",
      "suppressed_county_year_rows",
      "low_count_county_year_rows",
      "unmapped_raw_place_rows",
      "min_year",
      "max_year"
    ),
    audit_value = c(
      nrow(mortality_long),
      nrow(composition),
      sum(composition$composition_complete, na.rm = TRUE),
      sum(composition$suppressed_any, na.rm = TRUE),
      sum(composition$low_count_flag, na.rm = TRUE),
      sum(mortality_long$place_group == "unmapped", na.rm = TRUE),
      min(composition$year, na.rm = TRUE),
      max(composition$year, na.rm = TRUE)
    )
  )
}

assert_file_exists(raw_file)

raw_wonder <- read_wonder_export(raw_file) |>
  normalize_raw_schema()

mortality_long <- standardize_mortality(raw_wonder)
composition <- build_composition(mortality_long)
audit <- build_audit(mortality_long, composition)

readr::write_csv(composition, processed_file, na = "")
readr::write_csv(audit, audit_file, na = "")

message("Wrote processed file: ", processed_file)
message("Wrote audit file: ", audit_file)
