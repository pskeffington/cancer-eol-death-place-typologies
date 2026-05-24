# Variable Dictionary

Working variable dictionary. Final variable names must match extraction scripts and analytic files.

## Primary unit keys

| Variable | Type | Source | Definition | Status |
|---|---:|---|---|---|
| `fips_state` | string | CDC/ACS/HRSA | Two-digit state FIPS code | planned |
| `fips_county` | string | CDC/ACS/HRSA | Three-digit county FIPS code | planned |
| `fips_county_full` | string | derived | Five-digit county FIPS code | planned |
| `county_name` | string | source | County name | planned |
| `state_name` | string | source | State name | planned |
| `year` | integer | source | Calendar year | planned |

## Mortality outcomes

| Variable | Type | Source | Definition | Status |
|---|---:|---|---|---|
| `cancer_deaths_total_65plus` | integer | CDC WONDER | Total deaths age 65+ with underlying cause ICD-10 C00-C97 | planned |
| `deaths_inpatient` | integer | CDC WONDER | Deaths in inpatient medical facility | planned |
| `deaths_outpatient_er` | integer | CDC WONDER | Deaths in outpatient or emergency department setting | planned |
| `deaths_doa` | integer | CDC WONDER | Deaths recorded as dead on arrival | planned |
| `deaths_hospice_facility` | integer | CDC WONDER | Deaths in hospice facility | planned |
| `deaths_nursing_ltc` | integer | CDC WONDER | Deaths in nursing home or long-term care facility | planned |
| `deaths_home` | integer | CDC WONDER | Deaths at decedent home | planned |
| `deaths_other_unknown` | integer | CDC WONDER | Deaths in other or unknown location | planned |

## Derived outcome shares

| Variable | Type | Source | Definition | Status |
|---|---:|---|---|---|
| `share_hospital` | numeric | derived | Inpatient + outpatient/ER + DOA deaths divided by total cancer deaths | planned |
| `share_home` | numeric | derived | Home deaths divided by total cancer deaths | planned |
| `share_hospice_facility` | numeric | derived | Hospice facility deaths divided by total cancer deaths | planned |
| `share_nursing_ltc` | numeric | derived | Nursing/LTC deaths divided by total cancer deaths | planned |
| `typology_class` | categorical | derived | County typology assignment from clustering/LCA | planned |

## Structural predictors

| Variable | Type | Source | Definition | Status |
|---|---:|---|---|---|
| `rurality_code` | categorical | NCHS/USDA | County rurality classification | planned |
| `hospice_supply_proxy` | numeric | CMS/HRSA | Hospice supply or utilization proxy | planned |
| `hospital_beds_per_1000` | numeric | HRSA AHRF | Hospital beds per 1,000 population | planned |
| `physicians_per_100k` | numeric | HRSA AHRF | Physicians per 100,000 population | planned |
| `median_household_income` | numeric | ACS | County median household income | planned |
| `poverty_rate` | numeric | ACS | County poverty percentage | planned |
| `pct_age_65plus` | numeric | ACS | Percent population age 65+ | planned |
| `pct_uninsured` | numeric | ACS | Percent uninsured | planned |

## Dartmouth Atlas linkage variables

| Variable | Type | Source | Definition | Status |
|---|---:|---|---|---|
| `hrr_id` | string | Dartmouth/crosswalk | Hospital referral region identifier | planned |
| `hrr_name` | string | Dartmouth/crosswalk | Hospital referral region name | planned |
| `eol_care_intensity_index` | numeric | Dartmouth Atlas | End-of-life care intensity measure, exact definition pending source review | planned |

## Suppression flags

| Variable | Type | Source | Definition | Status |
|---|---:|---|---|---|
| `suppressed_any` | boolean | derived | Any suppressed cell affected county-year death-place composition | planned |
| `low_count_flag` | boolean | derived | Total deaths below predefined stability threshold | planned |
| `smoothing_method` | string | derived | Method used for sparse estimates, if any | planned |
