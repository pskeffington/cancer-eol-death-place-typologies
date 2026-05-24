# Data Source Registry

This file is the source-control anchor for all datasets used in the project. Every source must be validated before it is used in manuscript-weight claims.

## Source 01: CDC WONDER Multiple Cause of Death

- Role: Primary outcome data
- Level: county-year mortality counts
- Planned years: 2018-2024
- Population: age 65+ cancer decedents
- Case definition: underlying cause ICD-10 C00-C97
- Key variables: year, county, age group, sex, race/ethnicity, underlying cause, place of death, death count
- Validation status: pending extraction
- Notes: county-level small counts may be suppressed; suppression handling must be documented.

## Source 02: Dartmouth Atlas End-of-Life Care

- Role: regional end-of-life care intensity comparison
- Level: HRR, HSA, state, and/or county depending on available file
- Key variables: last-six-month care intensity measures, hospital days, ICU days, physician visits, hospice where available
- Validation status: pending source download and variable review
- Notes: geography linkage requires careful crosswalk documentation.

## Source 03: CMS Medicare Hospice Utilization Public Use File

- Role: hospice utilization and supply proxy
- Level: provider, state, or other available aggregation depending on file vintage
- Key variables: beneficiaries, visits, payments, provider characteristics, geography
- Validation status: pending source download and variable review
- Notes: county attribution may require provider location or other geographic proxy.

## Source 04: HRSA Area Health Resources Files

- Role: county healthcare supply and demographic context
- Level: county
- Key variables: hospital beds, clinicians, facilities, utilization, population context
- Validation status: pending source download and variable review
- Notes: variable naming can vary by release; freeze version before modeling.

## Source 05: American Community Survey 5-year estimates

- Role: county socioeconomic covariates
- Level: county
- Candidate variables: poverty, median household income, education, age structure, race/ethnicity, disability, insurance
- Validation status: pending API/extract setup
- Notes: use 5-year estimates for county stability.

## Source 06: Rurality / Urban-Rural Classification

- Role: rurality stratification and adjustment
- Candidate sources: NCHS Urban-Rural Classification Scheme, USDA RUCC, USDA Rural-Urban Continuum, or other official county classification
- Validation status: pending source selection
- Notes: select one primary rurality system and reserve alternatives for sensitivity analysis.

## Validation fields required for each final dataset

```text
source_name:
source_url:
download_date:
release_year:
file_name:
file_hash:
geographic_level:
time_period:
row_count:
key_variables:
known_limitations:
license_or_terms:
validation_notes:
```
