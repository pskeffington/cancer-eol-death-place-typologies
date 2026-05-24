# CDC WONDER Extraction Notes

## Object

Primary mortality extraction for cancer end-of-life death-place typology analysis.

## Source

CDC WONDER Multiple Cause of Death by Single Race, 2018-2024 final data.

## Source validation status

Verified against current CDC WONDER documentation on 2026-05-24.

## Data basis

The Multiple Cause of Death data are national mortality and population data based on death certificates for U.S. residents. Each death certificate contains one underlying cause of death, up to twenty additional multiple causes, and demographic data.

## Planned extraction universe

```text
Dataset: Multiple Cause of Death by Single Race, 2018-2024
Years: 2018-2024
Age: 65+ years
Geography: county of decedent residence
Underlying cause of death: ICD-10 malignant neoplasms, C00-C97
Measure: death counts
Group results by: county, year, place of death
```

## Required by-variables

```text
County
Year
Place of Death
```

Optional stratification variables for later sensitivity runs:

```text
Age Group
Sex
Race
Hispanic Origin
Urbanization
Underlying Cause of Death
```

## Cause-of-death case definition

Primary cancer cohort:

```text
Underlying Cause of Death = ICD-10 C00-C97
```

Interpretation:

```text
Deaths where malignant neoplasm initiated the train of events leading directly to death, using the underlying cause-of-death field.
```

## Age definition

Primary analysis:

```text
65-74 years
75-84 years
85+ years
```

These may be combined to define age 65+.

Sensitivity analysis:

```text
75-84 years
85+ years
```

## Place-of-death field values

CDC WONDER documentation lists the following values:

```text
Medical Facility - Inpatient
Medical Facility - Outpatient or ER
Medical Facility - Dead on Arrival
Decedent's home
Hospice Facility
Nursing home/long term care
Other
Place of death unknown
```

These are mapped in `docs/place_of_death_codebook.md`.

## Suppression rule

CDC WONDER suppresses death counts representing fewer than ten deaths. Project handling is defined in `docs/suppression_rules.md`.

## Extraction file naming convention

Raw export file should be saved locally as:

```text
data/raw/cdc_wonder_mcd_cancer_65plus_county_year_place_2018_2024.txt
```

Processed output target:

```text
data/processed/cancer_eol_death_place_composition_county_year.csv
```

## Required export settings

```text
Output format: tab-delimited file
Measures: deaths only for primary build
Rates: not required for primary composition file
Show totals: yes, if available
Show zero values: yes, if available
Precision: not applicable for death counts
```

## Known limitations

- County-level small cells are suppressed.
- Death-place categories identify location of death, not whether hospice services were used outside a hospice facility.
- Death certificate data measure decedent residence geography, not necessarily hospital or facility location.
- This design supports ecological patterning and association, not causal inference.

## Stage 1 status

```text
Years: verified
County field: verified
Place-of-death field: verified
Underlying cause ICD-10 field: verified
Age group field: verified
Suppression rule: verified
Manual extraction file: pending
```
