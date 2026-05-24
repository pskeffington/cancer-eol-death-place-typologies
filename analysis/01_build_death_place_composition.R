# 01_build_death_place_composition.R
# Purpose: transform raw CDC WONDER cancer mortality export into a county-year
# death-place composition file with suppression and audit controls.

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

share_tolerance <- 0.000001

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

assert_file_exists <- function(path) {
  if (!file.exists(path)) {
    stop(
      paste0(
        "Raw CDC WONDER export not found: ", path, "\n",
        "Expected file: data/raw/cdc_wonder_mcd_cancer_65plus_county_year_place_2018_2024.txt\n",
        "Create this file using the extraction parameters in docs/cdc_wonder_extraction_notes.md."
      ),
      call. = FALSE
    )
  }
}

read_wonder_export <- function(path) {
  raw_lines <- readr::read_lines(path)

  header_line <- which(
    stringr::str_detect(raw_lines, "County") &
      stringr::str_detect(raw_lines, "Year") &
      stringr::str_detect(raw_lines, "Place of Death") &
      stringr::str_detect(raw_lines, "Deaths")
  )[1]

  if (is.na(header_line)) {
    stop(
      paste0(
        "Could not detect the CDC WONDER tabular header. ",
        "Confirm that the export is tab-delimited and includes County, Year, Place of Death, and Deaths."
      ),
      call. = FALSE
    )
  }

  tabular_text <- raw_lines[header_line:length(raw_lines)]
  header_tab_count <- stringr::str_count(tabular_text[1], "\t")

  tabular_text <- tabular_text[
    stringr::str_count(tabular_text, "\t") == header_tab_count &
      !stringr::str_detect(tabular_text, "^---")
  ]

  readr::read_tsv(
    I(paste(tabular_text, collapse = "\n")),
    show_col_types = FALSE,
    na = c("", "NA", "Not Applicable", "Missing")
  ) |>
    janitor::clean_names()
}

rename_first_available <- function(df, target, candidates) {
  hit <- candidates[candidates %in% names(df)][1]

  if (is.na(hit)) {
    stop(paste0("Missing required field after name cleaning: ", target), call. = FALSE)
  }

  if (hit != target) {
    df <- dplyr::rename(df, !!target := dplyr::all_of(hit))
  }

  df
}

normalize_raw_schema <- function(df) {
  aliases <- list(
    county = c("county", "residence_county"),
    county_code = c("county_code", "residence_county_code", "county_fips", "fips"),
    year = c("year", "year_code"),
    place_of_death = c("place_of_death"),
    deaths = c("deaths")
  )

  out <- df

  for (target in names(aliases)) {
    out <- rename_first_available(out, target, aliases[[target]])
  }

  missing_fields <- setdiff(required_raw_fields, names(out))
  if (length(missing_fields) > 0) {
    stop(paste0("Missing required fields: ", paste(missing_fields, collapse = ", ")), call. = FALSE)
  }

  out
}

clean_fips <- function(x) {
  x_chr <- as.character(x)
  x_chr <- stringr::str_remove_all(x_chr, "[^0-9]")
  x_chr <- dplyr::if_else(nchar(x_chr) > 5, stringr::str_sub(x_chr, 1, 5), x_chr)
  stringr::str_pad(x_chr, width = 5, side = "left", pad = "0")
}

parse_deaths <- function(x) {
  x_chr <- as.character(x)
  x_lower <- stringr::str_to_lower(stringr::str_squish(x_chr))

  suppressed <- stringr::str_detect(
    x_lower,
    "suppressed|unreliable|not available|missing|^suppressed$"
  )

  deaths_num <- readr::parse_number(
    x_chr,
    na = c("", "NA", "Not Applicable", "Missing", "Suppressed")
  )

  tibble::tibble(
    deaths = deaths_num,
    suppressed_cell = suppressed,
    death_count_missing = is.na(deaths_num) & !suppressed
  )
}

standardize_mortality <- function(df) {
  death_parse <- parse_deaths(df$deaths)

  df |>
    dplyr::mutate(
      county_name = as.character(.data$county),
      fips_county_full = clean_fips(.data$county_code),
      fips_state = stringr::str_sub(.data$fips_county_full, 1, 2),
      fips_county = stringr::str_sub(.data$fips_county_full, 3, 5),
      year = as.integer(.data$year),
      place_of_death_raw = stringr::str_squish(as.character(.data$place_of_death))
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
      .data$suppressed_cell,
      .data$death_count_missing
    )
}

summarise_counts <- function(mortality_long) {
  mortality_long |>
    dplyr::group_by(
      .data$fips_state,
      .data$fips_county,
      .data$fips_county_full,
      .data$county_name,
      .data$year,
      .data$count_variable
    ) |>
    dplyr::summarise(
      deaths = dplyr::if_else(
        any(.data$suppressed_cell | .data$death_count_missing, na.rm = TRUE),
        NA_real_,
        sum(.data$deaths, na.rm = TRUE)
      ),
      suppressed_component = any(.data$suppressed_cell, na.rm = TRUE),
      missing_component = any(.data$death_count_missing, na.rm = TRUE),
      .groups = "drop"
    )
}

add_missing_count_columns <- function(df) {
  for (v in expected_count_vars) {
    if (!v %in% names(df)) {
      df[[v]] <- 0
    }
  }

  df
}

build_composition <- function(mortality_long) {
  composition_counts <- mortality_long |>
    summarise_counts() |>
    dplyr::select(
      .data$fips_state,
      .data$fips_county,
      .data$fips_county_full,
      .data$county_name,
      .data$year,
      .data$count_variable,
      .data$deaths
    ) |>
    tidyr::pivot_wider(
      names_from = .data$count_variable,
      values_from = .data$deaths,
      values_fill = 0
    ) |>
    add_missing_count_columns()

  suppression_summary <- mortality_long |>
    dplyr::group_by(.data$fips_county_full, .data$year) |>
    dplyr::summarise(
      suppressed_any = any(.data$suppressed_cell, na.rm = TRUE),
      suppressed_cell_count = sum(.data$suppressed_cell, na.rm = TRUE),
      death_count_missing_any = any(.data$death_count_missing, na.rm = TRUE),
      death_count_missing_count = sum(.data$death_count_missing, na.rm = TRUE),
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
      low_count_flag = dplyr::if_else(
        is.na(.data$cancer_deaths_total_65plus),
        NA,
        .data$cancer_deaths_total_65plus < 30
      ),
      composition_complete = !.data$suppressed_any &
        !.data$death_count_missing_any &
        .data$unmapped_place_count == 0 &
        !is.na(.data$cancer_deaths_total_65plus) &
        .data$cancer_deaths_total_65plus > 0,
      share_hospital = dplyr::if_else(
        .data$composition_complete,
        .data$hospital_deaths_primary / .data$cancer_deaths_total_65plus,
        NA_real_
      ),
      share_hospital_excluding_doa = dplyr::if_else(
        .data$composition_complete,
        .data$hospital_deaths_excluding_doa / .data$cancer_deaths_total_65plus,
        NA_real_
      ),
      share_home = dplyr::if_else(
        .data$composition_complete,
        .data$deaths_home / .data$cancer_deaths_total_65plus,
        NA_real_
      ),
      share_hospice_facility = dplyr::if_else(
        .data$composition_complete,
        .data$deaths_hospice_facility / .data$cancer_deaths_total_65plus,
        NA_real_
      ),
      share_nursing_ltc = dplyr::if_else(
        .data$composition_complete,
        .data$deaths_nursing_ltc / .data$cancer_deaths_total_65plus,
        NA_real_
      ),
      share_other_unknown = dplyr::if_else(
        .data$composition_complete,
        (.data$deaths_other_unknown + .data$deaths_unmapped) / .data$cancer_deaths_total_65plus,
        NA_real_
      ),
      share_sum_check = .data$share_hospital +
        .data$share_home +
        .data$share_hospice_facility +
        .data$share_nursing_ltc +
        .data$share_other_unknown,
      share_sum_pass = dplyr::if_else(
        .data$composition_complete,
        abs(.data$share_sum_check - 1) <= share_tolerance,
        NA
      ),
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
      "missing_count_county_year_rows",
      "low_count_county_year_rows",
      "unmapped_raw_place_rows",
      "share_sum_fail_rows",
      "min_year",
      "max_year"
    ),
    audit_value = as.character(c(
      nrow(mortality_long),
      nrow(composition),
      sum(composition$composition_complete, na.rm = TRUE),
      sum(composition$suppressed_any, na.rm = TRUE),
      sum(composition$death_count_missing_any, na.rm = TRUE),
      sum(composition$low_count_flag, na.rm = TRUE),
      sum(mortality_long$place_group == "unmapped", na.rm = TRUE),
      sum(composition$share_sum_pass == FALSE, na.rm = TRUE),
      min(composition$year, na.rm = TRUE),
      max(composition$year, na.rm = TRUE)
    ))
  )
}

stop_if_failed_audit <- function(composition) {
  share_failures <- composition |>
    dplyr::filter(.data$share_sum_pass == FALSE)

  if (nrow(share_failures) > 0) {
    stop(
      paste0(
        "Share-sum audit failed for ", nrow(share_failures), " complete county-years. ",
        "Inspect outputs/death_place_composition_audit.csv and processed composition output."
      ),
      call. = FALSE
    )
  }
}

assert_file_exists(raw_file)

raw_wonder <- read_wonder_export(raw_file) |>
  normalize_raw_schema()

mortality_long <- standardize_mortality(raw_wonder)
composition <- build_composition(mortality_long)
audit <- build_audit(mortality_long, composition)

stop_if_failed_audit(composition)

readr::write_csv(composition, processed_file, na = "")
readr::write_csv(audit, audit_file, na = "")

message("Wrote processed file: ", processed_file)
message("Wrote audit file: ", audit_file)
