# Analysis Plan

## Object 01: Mortality extraction

Extract CDC WONDER Multiple Cause of Death records for age 65+ cancer deaths, ICD-10 C00-C97, by county, year, and place of death.

Expected output:

```text
data/processed/cdc_wonder_cancer_eol_county_year.csv
```

Minimum fields:

```text
fips_county_full, county_name, state_name, year, place_of_death, deaths
```

## Object 02: Death-place composition

Transform place-of-death long counts into county-year wide composition.

Expected output:

```text
data/processed/cancer_eol_death_place_composition_county_year.csv
```

Core derived fields:

```text
cancer_deaths_total_65plus
share_hospital
share_home
share_hospice_facility
share_nursing_ltc
share_other_unknown
```

## Object 03: County stability flags

Apply count thresholds and suppression flags.

Planned rules:

- Flag county-years with total cancer deaths below a chosen stability threshold.
- Preserve raw counts.
- Do not silently impute suppressed values.
- If smoothing is used, save both unsmoothed and smoothed values.

## Object 04: Typology classification

Classify counties using death-place composition variables.

Candidate methods:

- k-means clustering on standardized death-place shares
- hierarchical clustering
- latent class analysis
- Dirichlet mixture modeling, if needed

Primary method selection should prioritize interpretability, stability, and reproducibility.

## Object 05: Structural covariate merge

Merge county-level healthcare supply, socioeconomic, rurality, and regional intensity variables.

Expected output:

```text
data/processed/analytic_county_year_typology_file.csv
```

## Object 06: Descriptive tables

Planned tables:

1. Data-source inventory and analytic exclusions
2. County-year sample characteristics
3. Death-place distribution by rurality
4. Typology profile table
5. Regression table for hospital-death share
6. Sensitivity-analysis summary

## Object 07: Figures

Planned figures:

1. National county map of hospital-death share
2. National county typology map
3. Typology profile radar/stacked composition figure
4. Scatterplot of hospital-death share vs. end-of-life care intensity
5. Rurality-stratified typology distribution

## Object 08: Models

### Primary descriptive model

County typology assignment using death-place shares.

### Association model

Outcome:

```text
share_hospital
```

Predictors:

```text
rurality_code
hospice_supply_proxy
hospital_beds_per_1000
physicians_per_100k
poverty_rate
median_household_income
pct_age_65plus
pct_uninsured
state fixed effects or HRR fixed effects where feasible
```

### Sensitivity models

- Age 75+
- Major cancer subtypes
- Exclude sparse counties
- Alternative rurality classification
- Alternative hospital-death definition excluding DOA

## Object 09: Manuscript claim control

Each manuscript claim must map to one of:

- Source document citation
- Generated table
- Generated figure
- Model output file
- Explicit interpretation boundary note

Unsupported causal claims are prohibited.
