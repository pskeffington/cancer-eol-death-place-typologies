# CDC WONDER Manual Export Steps

Reviewed: 2026-05-24

## Purpose

This file gives the exact manual extraction workflow for Object 02.

Object 02 requires a CDC WONDER Multiple Cause of Death export with county-year-place-of-death death counts for older adult cancer deaths.

## Do not use the USCS cancer mortality request page

Do not use this request page for Object 02:

```text
https://wonder.cdc.gov/cancermort-v2022_SR.html
```

Reason:

```text
United States Cancer Statistics mortality pages organize cancer mortality by cancer site, leading cancer site, region, division, state, MSA, year, age group, sex, ethnicity, and race. They do not expose county-level place-of-death composition needed for the typology pipeline.
```

## Use the Multiple Cause of Death request page

Use this request page:

```text
https://wonder.cdc.gov/mcd-icd10-expanded.html
```

Accept the data-use terms, then configure the request form.

## Section 1 — Organize table layout

Set:

```text
Group Results By: County
And By: Year
And By: Place of Death
And By: None
And By: None
```

Measures:

```text
Deaths: checked
Crude Rates: unchecked
Age Adjusted Rates: unchecked
Standard Error: unchecked
Confidence Interval: unchecked
```

Optional title:

```text
Cancer EOL deaths 65plus county year place 2018 2024
```

## Section 2 — Select location

Set:

```text
Location: United States / all counties
```

Do not restrict to one state for the primary national file.

## Section 3 — Select year and demographics

Set years:

```text
2018
2019
2020
2021
2022
2023
2024
```

Set age groups:

```text
65-69 years
70-74 years
75-79 years
80-84 years
85+ years
```

Set:

```text
Sex: All Sexes
Race: All Races
Hispanic Origin: All Origins
```

## Section 4 — Select cause of death

Set underlying cause of death to ICD-10 malignant neoplasms:

```text
C00-C97
```

Do not use multiple-cause fields for the primary cohort. The primary cohort is based on underlying cause of death.

## Section 5 — Other options

Set output/export options to preserve machine-readable structure:

```text
Show totals: yes, if available
Show zero values: yes, if available
Output format: tab-delimited text
```

CDC WONDER suppresses death counts of 9 or fewer. Do not alter suppressed cells manually.

## Save file

Save the exported tab-delimited text file as:

```text
data/raw/cdc_wonder_mcd_cancer_65plus_county_year_place_2018_2024.txt
```

## Run Object 02

From the repository root:

```bash
Rscript analysis/01_build_death_place_composition.R
```

Expected outputs:

```text
data/processed/cancer_eol_death_place_composition_county_year.csv
outputs/death_place_composition_audit.csv
```

## Audit expectation

The script should stop if complete county-years fail the share-sum audit. A successful run should produce an audit file with:

```text
share_sum_fail_rows = 0
```
