# CDC WONDER Source Triage

Reviewed: 2026-05-24

## Purpose

This file prevents source confusion between CDC WONDER mortality datasets that look similar but do not support the same analytic design.

The project requires county-year cancer mortality counts by place of death. Therefore, the primary source must expose all of the following fields in one query:

```text
County
Year
Place of Death
Underlying Cause of Death
Age Group
Deaths
```

## Accepted primary source

```text
source_id: S01
source_name: CDC WONDER Multiple Cause of Death, 2018-2024, Single Race
request_url: https://wonder.cdc.gov/mcd-icd10-expanded.html
project_status: accepted_primary_source
reason: This dataset supports county-level residence geography, underlying cause of death, year, age, place of death, and death counts.
```

Use this source for Object 02 and the raw mortality export expected by:

```text
analysis/01_build_death_place_composition.R
```

Expected raw export path:

```text
data/raw/cdc_wonder_mcd_cancer_65plus_county_year_place_2018_2024.txt
```

## Rejected source for Object 02

```text
source_id: S01A
source_name: United States Cancer Statistics, 2018-2023 Mortality Single Race
request_url: https://wonder.cdc.gov/cancermort-v2022_SR.html
documentation_url: https://wonder.cdc.gov/wonder/help/cancermort-v2023.html
project_status: rejected_for_primary_death_place_file
reason: This source supports national, state, region/division, and metropolitan-area cancer mortality tabulations, but it does not expose county-level place-of-death composition. It is therefore unsuitable for the primary death-place typology file.
```

The USCS cancer mortality source may be retained only as a secondary context or external check for broader cancer mortality counts/rates. It must not feed the county-year death-place typology pipeline.

## Extraction rule

For the primary pipeline, do not export from the USCS cancer mortality request page. Export from the Multiple Cause of Death request page.

Primary grouping:

```text
Group Results By: County
And By: Year
And By: Place of Death
```

Primary filters:

```text
Dataset: Multiple Cause of Death, 2018-2024, Single Race
Age: 65-69 years, 70-74 years, 75-79 years, 80-84 years, 85+ years
Underlying Cause of Death: ICD-10 C00-C97 malignant neoplasms
Measure: Deaths
Export type: TSV or tab-delimited text
Show suppressed values: yes
Show zero values: yes, if available
```

## Decision

Use `mcd-icd10-expanded.html` for Object 02. Do not use `cancermort-v2022_SR.html` for Object 02.
